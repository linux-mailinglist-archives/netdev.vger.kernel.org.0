Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F255064B2D2
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 10:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiLMJzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 04:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiLMJzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 04:55:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777942619;
        Tue, 13 Dec 2022 01:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670925322; x=1702461322;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B35o61MfXdYlAwUM9GwCc5x5yan7YcymzRvox6Bmkzo=;
  b=AnRZLhfMZE2id2FTJDFgOvwZUPWCSBKk+NjLSQbkTuImi/jKViDOoUA7
   dyWJwnGrjjq7FUNJj65pMQRSutal7ZPmkeUOwbLCOtqeiyZtng4lQkXXO
   ZCjEGzs5R+nwnQtNLaRHMfgAi7IUMZi8B5wSgbeiLzFp56iory9WoCRD/
   MmUR9DBgRy+J8oKNzjmI7DvxBC6Imj8PqqCSAEy1Yfu1xdj4JGWVqq3kL
   SGpQ8UD8BwOpEJFzQq2aJTAgBfLzFiGgwY0FzWBPX2npeWZaOfV90dVCA
   vQx85v8uIF2YytBUT0JNYcxBuof/vSa+7jWvwL31o7b9Ve2JtwSlKsIqQ
   w==;
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="203771669"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2022 02:55:21 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 02:55:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Tue, 13 Dec 2022 02:55:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BR5hQO0SO/syh+JtOtLRC8U1m8mMXoWvxN0IlBD7BuN+2SUGiANKXIjaJdIgB0Z9hZy+QoZzqCpLCeDNBpYf1tj4RpIjfo29wRJz0S97DievGO03CIHCe85y0H/jOd92kE3PREi+Lp2QU4o0jBcMZnRpJKPkMpfKeT1OTmWTX0APLwvoxdGFkn05uE8QnsqshratZOZyaNTDASJJEInByjGPImEkE0djnEA2qsKJo65O6qTzJ56cx4/9embR2ovlmUtZcbCfGVTn1kf0Mx50RChTFQB6ShdivgMlXebz4xzwAQ67gHKpZBTQSdORP7gCr8Fc5GL4O67vT/qtXlt+Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWzHpbTr/ZpcAZbMnTKrdDWEr0pUcQ5J3OkQ8PoJf2A=;
 b=dmHSLD095GbuvU13E/vtepMDWgtNyTBvyhh8Ly7tHL0DW92ux+GHtg7emlUWRzo78Aw5XSxHE9ivwdJiMnVdbSKlw7O31exS03VtSiRuADtHkfWY6St3xs4PLI7Htxljqt8F4+sUtAiJvTROesQUCeImBQjsOoen4BqULPhgEFfeq7jPdrVnKuGDuXYPIxl34ONTLnhBUdrYDgxg9ttPfu0PrZLv0sEukGSECYlwUEWJwGFBUOHtdD7m7HWRQnM+BEa3OCtO80XBNaF1LnuUV+pRsGHk6K3ox+xcvnaBRBKQWJgwCj3qKH+TozMUgCQxFs7toEx3XvV8Fqm9VYuokw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWzHpbTr/ZpcAZbMnTKrdDWEr0pUcQ5J3OkQ8PoJf2A=;
 b=sMdYtBlCp7oF+s+IoMC4aUj5k56ntnk51PSBfIQaVjhkRFxCz1lqhzo4TSIF3A9DVgZxOJjqEwptvQkXqy//F7vryoy5xml+3TWNqyCCF6sbM2cH9nbdbqSQhMBuzgB+pCTgzJ7/jNIGJGmUNjMWWroMWyfKpYunKlDeBc3SYBU=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by DS0PR11MB6445.namprd11.prod.outlook.com (2603:10b6:8:c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 13 Dec
 2022 09:55:19 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1%5]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 09:55:19 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Thread-Topic: [PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Thread-Index: AQHZCUVX+xhZw8rF5EesOiBOrBuDqa5g1PgAgAAJjpCAAAeBgIAI7uuggAA8woCAAY2XQA==
Date:   Tue, 13 Dec 2022 09:55:19 +0000
Message-ID: <CO1PR11MB4771700425BF89F9A2E3E655E2E39@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20221206073511.4772-1-Divya.Koppera@microchip.com>
 <20221206073511.4772-3-Divya.Koppera@microchip.com>
 <Y48+rLpF7Gre/s1P@lunn.ch>
 <CO1PR11MB47713C125F3D0E08B7A6A132E21B9@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Y49M++waEHLm0hEA@lunn.ch>
 <CO1PR11MB4771F8AA1CCAD01EAE797E59E2E29@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Y5b+W+bphtD+9chT@lunn.ch>
In-Reply-To: <Y5b+W+bphtD+9chT@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|DS0PR11MB6445:EE_
x-ms-office365-filtering-correlation-id: 2d8abf02-c08c-47d2-a691-08dadcf024ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zLFRHwtPg0oHtWWQOpCSrFyDezneKZR7+dbPc1TE69MqkzzfvW+9daMiON4q8SkcI2vBvJpBFSciRyMyDXbtQFgDf+GKLMVtRfanbgKHukQWbxeG4B7hYZXuKnrxJp9cGnB2H7+IFYYpf6h38JqxXfKVGwHwgue4m0nrfz7ceY4HYxTwVbDc11+HK4mGWK+x3qP/IHTo9Xh42mpx5LVqd3hbni8lfjFqeNV7pK/noA9JpLS5a5YQhMq3LHpvjtP9mlixuiNkLy5IDta+ZO89J/1mh9la8j3wdOTg0OAeZW5vbicqX395RLapci2tqyYKzMbZ367ws/4yOwPvLbjSM6t4k31QFGNVCtyfuJEoGzb6oslVA5FiBfvV0sW/GfZf4k0fMA8PRyLkMwhk705KatL4XlCblXBzqLcWQUEh/hupALfb14WfN9M84bSatVgAPJaZvTB0PDCyyY/7iwqn/WHMr8O6rXPaHvsKDgfez+rxqufWpu6CCH+B5sul/bqxQ6bDB1lHj4ewVNiMw8k3tYL04JqGvI4Dxo4djbpIR8vuva/WOUXp9QD8BUw4x6OvNZAOApaTKF32pjfmAdpuo5kpPDUh0XR3+NbqRUPG/5k19mJsh7O/Wc6d/AgDikd+Ejj3ehtXLOlRe9XDTcbOrVKCf5wI6YfK6fhjZ2crG5sx97bAOOb2Zsj/RuogSzargwW69bLKnZ8xnb5U6AHVJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(71200400001)(7416002)(83380400001)(478600001)(8936002)(86362001)(38070700005)(33656002)(122000001)(2906002)(38100700002)(76116006)(5660300002)(4326008)(41300700001)(9686003)(6506007)(52536014)(107886003)(186003)(53546011)(55016003)(8676002)(26005)(7696005)(6916009)(66556008)(66476007)(66946007)(66446008)(316002)(64756008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6rDBTHNcVjf2Gg96WPnUbH8KFYE8Uwx7LBbOzJEBBhNWhV+y2K90bO3Hgp/p?=
 =?us-ascii?Q?3ke4d/ctcpc/9aDeYEzPXLL7fVoae/9tSitUcuVr8p4baXH+z/Rf/3Raa1vO?=
 =?us-ascii?Q?jQeZ/WSyJsgPiKVu0397Rp8B4OEnGSjgrJIwqok0fXPrAjn4c0kdXHDqYfOt?=
 =?us-ascii?Q?hVeQkKjju7QLh1D8MIP1RBaIsK26wvmTGZI0V1EDEpKuoADUKKg0xL6n4xD9?=
 =?us-ascii?Q?LEaqXUPFMjb5TuodnqsL6gF1lK3Bpf1Vy8mJlZuJXOIzU/Zgi3cjLis1VJhn?=
 =?us-ascii?Q?v9XB3gfSHJEsKVqh4fqEvtBAki4zOiborim2z2HFFX1kuOGClRZiEDpzUOxN?=
 =?us-ascii?Q?TqpBMQMeKDRceUCHniC3q+1/93G8u7TPQQ/9WmhQi9OaycFGTSeAdCGqVpMo?=
 =?us-ascii?Q?pU6WmUz0AX9Em/z9birEYaKQUaXRjMz62reqtFw4I/lzEohjhCaslXb0V4J+?=
 =?us-ascii?Q?fvtHY/9eef+ufPDSVqJzRVBaSUh2JSvnywH2wwMpFvQGuT/oMSB1G5I0kIHn?=
 =?us-ascii?Q?ft0GYXJPL+SuQ4gHd5oBg/xByVWoCveaEmxkzcarKxYQYaadehztiixcVRAj?=
 =?us-ascii?Q?iaueJoZ934WjxxdtpEX1tNghOFx6Bx7I9MobQo/gHFb4x7WeAJryIW1HVirU?=
 =?us-ascii?Q?mAijsSFA3La4Bihw+IwbrqOFKXeR9uiiKzs5vuUnU8881u71Uxyc9aCIqdh6?=
 =?us-ascii?Q?MzdWOzKa5xhiGgLcO0c1rCFTF6AA5p68n5JtoekpF6rBY++tDAL6/d9nlayM?=
 =?us-ascii?Q?XKzejaXcpI1HAyCV/XuH/8GxzL/XEsQarq6oGpM6dzbgdNq86vxmElIvOcde?=
 =?us-ascii?Q?gSVI+nwsNrUyQefZtmQoUjq49Qxho5cZ+eoUK7yfAIlnjJQSent3B3oYt9UI?=
 =?us-ascii?Q?Qgny/vlCFKAiZgGaX5TlkBhCX1uJLy8gOKLRhmNhITCiiqXZihUb88Bklmvd?=
 =?us-ascii?Q?9NOzvdGplqdX+9YEWRB8CJYkC+aKts2RTJ0BPysKQTiLlF+mpO8Jb8phbK0b?=
 =?us-ascii?Q?+JfbE4hYxR98oHfIQQzZnj1RvxwFfPoTvbma1a8zWv1zWqT2vViPG/1M30OD?=
 =?us-ascii?Q?r7Z6w0o6KGQ/HEiWSD4om5fFEUxX7idEgSHMFoJgfmZ2N6pRX9CQlycd4Tj7?=
 =?us-ascii?Q?0H6G4bY6rydfiqugjbcxRDKRFeDsIXWYQMmjZnDtoPIO6gcNA9mvrnswBBOf?=
 =?us-ascii?Q?K3EynoKjbWFe9M8PQj/usTSuHYMIzAXvFa7dJLwW7yL30LZh8uid8M2CMZmk?=
 =?us-ascii?Q?MPzBSvwpBj8T7/DBpZ1rtICbkv8sVUIqoDepm7DOnThY598b2H0tC5sHhXOn?=
 =?us-ascii?Q?Moov7mUlnea7DxU6VY6PijGHRnMTobuKwgz1SPRnrLhd8yJozY6LSW/973CZ?=
 =?us-ascii?Q?iBz0preYqeF0j2M92hpE9/pVJ8i8hvgAyqBus6Lmk7ORv+Sj/nZVrXVmJELA?=
 =?us-ascii?Q?PiucKkbm1pECdA6fWH5vGUDsBQRp2t5bHy+k2JrKE88MlQ4ivQT+0OEHWFQT?=
 =?us-ascii?Q?XJKdstA2TOnR/BZZ7AJnNAmCyQMWHeld85N7FJer9rIVjzjwq26GraATWaT5?=
 =?us-ascii?Q?BW31hB+dynaIimfjFPHUoNIYibQfJHCp+b+BuWoTQpZ3BwK013hlZLZ5+agX?=
 =?us-ascii?Q?4A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8abf02-c08c-47d2-a691-08dadcf024ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 09:55:19.5941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VG4iB6dIV6Uyc2E+1dmYoWh8uwIYHc0qeMFCuO8OtVuKf5cFIntCbrJRHj5FkXkL0BSi176Rpg/cwAsnR6OLgX+RNGJUc3VnXtTo02PLjO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6445
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, December 12, 2022 3:42 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> richardcochran@gmail.com; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing =
zero
> to PTR_ERR
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > > know the content is safe
> > >
> > > > > > -     if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > > > > > -         !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > > > > > -             return 0;
> > > > > > -
> > > > >
> > > > > Why are you removing this ?
> > > > >
> > > >
> > > > I got review comment from Richard in v2 as below, making it as
> > > > consistent
> > > by checking ptp_clock. So removed it in next revision.
> > > >
> > > > " > static int lan8814_ptp_probe_once(struct phy_device *phydev)
> > > > > {
> > > > >         struct lan8814_shared_priv *shared =3D
> > > > > phydev->shared->priv;
> > > > >
> > > > >         if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > > > >             !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > > > >                 return 0;
> > > >
> > > > It is weird to use macros here, but not before calling ptp_clock_re=
gister.
> > > > Make it consistent by checking shared->ptp_clock instead.
> > > > That is also better form."
> > >
> > > O.K. If Richard said this fine.
>=20
> Since Richard wants this removed, i would just remove it. The object code
> saving is probably not much.

Okay, then I'll resend the patch.

>=20
>      Andrew
