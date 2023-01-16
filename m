Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF2666BE4A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 13:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjAPMzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 07:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjAPMy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 07:54:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D0223124;
        Mon, 16 Jan 2023 04:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673873564; x=1705409564;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CmgyijTIQgf5l3wBcU1wS+pR46hwH477Xa/OxZcxb5A=;
  b=UYNAu7ZxZuyhELzu+Aaq8agpiLNTWr8vDBM8gzGIp1WUk15tLnQjPm8w
   a58dqcJIy3o9S01IsDDeM5aN8NxsBoOriHxNtK6Mrlucl+mA5w43g/8Fn
   GuGknovi4fJv/OQaok63zvk+mRPFpOQ1o2CVqle6jijjaSYfUcngRbg4+
   lk0dkSiavazZ8yAflU/dP2WBDZIAZaX4Ad6KFMBTkGBiK39oUIgv8RI9q
   qqjz8ulZ2em/ih8PmjrSznT0tg0O9KsCDGwtcx/tdbfTh4wG4Srx2NK0S
   uRY8xNsV9xb3Khb85Wyqu3tXGtVhYQ7YEW/mJfhHxDrvq1XfLikIZBJvx
   g==;
X-IronPort-AV: E=Sophos;i="5.97,221,1669100400"; 
   d="scan'208";a="132529630"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 05:52:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 05:52:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 05:52:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1tIJDQ0DGBPT+EyzvR81mUJUxlmyHfSoxCnwpuDH2s04S9USFp97SjYacYeRmXuYVELX3XQRagpGV+UxBWDE9jtudxMc6paLRH/nE1JknYG5dVsaf7cpeNn5PJDbZ4yEzmimVLFeHhQbPNwSRNQW2L9VcAd+3jLwRfb5Indc6jqPtsHB0RfYFetIdZgAZojKhS+s22M3bFOGxysjBtdtPuZAwsrTGcV5X5CaG4cvOY9wl+zOLHMRe8zVHZl1yFkB49y8nYn9Nv3zSytO5Opk7vhSDwvTYwXmdfC4wlGc+EitjIzHbRzyHAhyD8I9L4EgYzcRHm8Nxm+e9EE9svK7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1HiIArCuCqpK20tnSGtcS2HpXggY3T82L9VcheDTMrQ=;
 b=G1CWQvo7Q4ejSCtC02lHdph7ljgzh/0qPuOEohRr52CyyoK1etGPiKSclhOlxRobygmZHfu0+vtRnIrXjyBaVDkCq0j5g73/kg5nxYOzehLhQgDUZA4iP/711Du03NNo3uysZiUh1WDYmN8RKsCUFmBUHZq0dh+edvG3HRbxrYhCkswL5dKaBAeyx4tvzlOobNvs6EiyBXF5Te4jNVaRJvWmRLITDIvZTe+vs9qhDZ1/UC1SVN27qxmXihvheUEVqFbGmNA6ZjxvjIGPe8A6GLwoitmY8QzBxVl0N4LIR0gLEnZZOa9v/1s0Ap25wrtqA5gN+aBz8OCe+5X9tIQ8Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HiIArCuCqpK20tnSGtcS2HpXggY3T82L9VcheDTMrQ=;
 b=uCwpKniyLnQpDNWmXNtpTGV4ONoGhcDf9qEWF891gncfa+BdoFoaoTzET3xK6aJSJfs6bxlipRloxCNy6EQTYccydZ32NruvvS2xy5t52J9kZjvc+S/YL0QLh+5+cyCD0+2JDkSTUH/3CNn7BbA2nLRRo2KTV3aB+78HWPx68iE=
Received: from PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10)
 by DS7PR11MB5968.namprd11.prod.outlook.com (2603:10b6:8:73::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13; Mon, 16 Jan 2023 12:52:36 +0000
Received: from PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::1ac5:42cb:a1d7:c6a1]) by PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::1ac5:42cb:a1d7:c6a1%8]) with mapi id 15.20.6002.013; Mon, 16 Jan 2023
 12:52:36 +0000
From:   <Daniel.Machon@microchip.com>
To:     <error27@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <Horatiu.Vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <petrm@nvidia.com>, <vladimir.oltean@nxp.com>,
        <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dcb: add new rewrite table
Thread-Topic: [PATCH net-next 3/6] net: dcb: add new rewrite table
Thread-Index: AQHZJsEGC96Yx9M0kE+chXGjz/NRZq6b7RcAgAUYNoA=
Date:   Mon, 16 Jan 2023 12:52:36 +0000
Message-ID: <Y8VIk3SKwTC3rqfJ@DEN-LT-70577>
References: <20230112201554.752144-1-daniel.machon@microchip.com>
 <20230112201554.752144-4-daniel.machon@microchip.com>
 <Y8EChkENXkUjfUQf@kadam>
In-Reply-To: <Y8EChkENXkUjfUQf@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5580:EE_|DS7PR11MB5968:EE_
x-ms-office365-filtering-correlation-id: dee431db-b7fb-42d7-a808-08daf7c08b17
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oaTJhN81g0namES0YApDb85xYT+DU257kPuPe6gmYsQ82GkZlJ4ZIkSNEjIvuEc/Uw1dUbUfxVIzYzZTGwTNFnKoA3KycsnC6u0w5KH6ZenxGfGB/PKzLAKEgdRN6wyjOa00+ttEnXmEQkYLasz7ie50vzcvqkG+ExxI8eaes4p7n5btsB/lLokrngfRCPtS6k3MBQJuoeR5iIYAWgxBqet/FRuBhfocdyAFu0Z8ukCTtReH3d8l8nNw4sS1ZdizlejZTVqtIFIAIslBY5fXRswX1vq+IlD8TWppMLQ/LWfCWNWsRCaqElsq1hdhOWVlsZkQdkpfzDYz6wp8ZRXJS3INM64+Ddeo/uVG9N0heY+/33D18X2+wDZAw5SyqKf3uaudvhsmjyadQ47Ol7b9Ud/iQvj410GXLK6A09TxUMDjhgA0641sce+5mRbqXOzYHqraSvU6IJKhA09Zu1Ih+oae8eLHyIvA2jBkxnEP/9mD7jyj4KKh/XNZbkgDfCnU89PvHweKAiynqXJpd8kV/LiOhO2TlMx1kq2T34rGxtOgaImzYDJFG5hMasjit2I9BOV9dBLB8fKJxr2ReMqrSreNzD+zr5J0BQ6DDjJA3A2LraCNwZ/49cFvYAJxngdQLGpzjqbbl8ZV6e2gMbRR8NuuKlXN7bFsGoHe6eS8pHAlo+D4+iioNO8Tb6Q7KhBX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5580.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(376002)(396003)(136003)(346002)(39860400002)(451199015)(4744005)(2906002)(38100700002)(122000001)(41300700001)(5660300002)(66476007)(7416002)(66446008)(76116006)(6916009)(4326008)(64756008)(8676002)(66556008)(66946007)(8936002)(38070700005)(86362001)(54906003)(71200400001)(83380400001)(6512007)(6486002)(478600001)(91956017)(9686003)(316002)(33716001)(6506007)(26005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Aut7RG50EkfwERpb7wg1eqoroXaC2y+d1+bC0YQR0QGQzI7DnlnxYhifh0e5?=
 =?us-ascii?Q?oQ59yhzI99x7bCwUfMaZoeDGiagYoMPx2KPhT5elTjbqpV7DD4zSpf2JBJ7J?=
 =?us-ascii?Q?H/O0L8uL/AKv1jyB8/y2CU2Yyhqejn/Hx/AzoC+xY7piDNKuraBFpcCLf+mh?=
 =?us-ascii?Q?SljJHfvTOgTjFg8Qbyh1KEZKRVzrylDAuXDz8WbGYFUC7hmEWIfMngrvqy7v?=
 =?us-ascii?Q?L5O+9aw/WTgciof2FwiAPnysxjx0NChdbGp2uHSfELb+y7fOeFlML0IlzRMO?=
 =?us-ascii?Q?H8feO9gKI/K04bHkHrZAJEUuB+SFyIuLUB1GNYvQdBK+DiQH6gyw7NQB3vVc?=
 =?us-ascii?Q?Pi1sEXGRx83EI9jpVLeqV/z6jTCOX25y/o5HOoFskdujIbfdNkHVQLHlrtbR?=
 =?us-ascii?Q?YYDodgrqq1kcKVqpSIOitVXXzDwSwIqVfBAgim+wu6Db/UTg9daHpulL6fx2?=
 =?us-ascii?Q?04NF/8tvo9M5mNI/PEzutxZ9QXAzQebYZ+GKdFd7DkDFWYhy3gFjHwtLimdF?=
 =?us-ascii?Q?UCg9KLWxqavxzrTWzeVFn//1H8JqJuTpyr+r4sYpAkqBzvj5PTGYltaVGHb3?=
 =?us-ascii?Q?PxehohqQScyV42EHiN2TucLwGSvUvEDjizsCMwoEZQ1QLeAMNS5mx2R3AM+S?=
 =?us-ascii?Q?cf2cx4WWvsFj3+iFR4So7VlLvL9r70ZSxZ7vdJW20E4nbccL3pnlB9ZAFu7Z?=
 =?us-ascii?Q?jnjOoDlbgXSDMEaF5icoUHe8V5BXan7yBlOnRDk+PI+Fjp+T5uO+H/J1i/re?=
 =?us-ascii?Q?o/kHP5iZ+gqj4c1HygzHnnUx27Z7PCIpLmZamMqxoMCvh4LHUGZlF7EVgcx3?=
 =?us-ascii?Q?fV6mIPIe1VYR0xdcp0PsOwEj6aVqEPMgQwDfj0Uf4AlLGSZwTUolsPYE0OcA?=
 =?us-ascii?Q?dbMteHl38B/mNi26EY8rwLOJAE6kk7GOOXjp6/jvLfDH1OvaeRjHPtqgUR9g?=
 =?us-ascii?Q?4IOiVd0W/sLAJq7kH7HHrT7UxiNtugkaZhKqZ4M81BSDboQ7P7BBuSjvpIMr?=
 =?us-ascii?Q?EtTwrs/9ABjlWWY0KUXneat+b3BvQezMVAHp68Qr2aHUElrqM/An13jdT5rR?=
 =?us-ascii?Q?OJ7Jxf4TCR3oxNOULKK0C+AqAYCSWYDDPHCX/w2qeBlWPkITqlJQYdK53vq5?=
 =?us-ascii?Q?nqb3MBZ4hC07Vl299NbtsO9fcfBH6rqt4dm9xqHmmtrp4zN0baTGHk51+U58?=
 =?us-ascii?Q?cqc4Q2gSNWq62N0Yu5htJrWkcg/vbJndNsg2QrVTwl3Y7KCG6afCUbRTfJiS?=
 =?us-ascii?Q?49UAS+EXyI6dLhuo0tz5hFNTIhW2+I+caaey6Qo4UnB2InfRtuM42wh6fcKM?=
 =?us-ascii?Q?GXMi5BsyQlHZwiRMQRhWoQtG4KncwG5CdPiTbPGNQM7z0kDLrvH/O+DwUS7l?=
 =?us-ascii?Q?/gCocz3iDNwrMBaH0k94/xc3zhu17XgojjJuQvZ+N5GaVxwkwOiSGJzi8Zge?=
 =?us-ascii?Q?xylAr9OtWD+DHHsrRltjeI70G1xjiPTAv13TdSuRFmWA5bLMSIBSMWRp8qTf?=
 =?us-ascii?Q?FsKZltHG7GDVvWRtHhiOtUcYbICZmLm60uPOgTa7IDRSRvFp44yGPicjHPIT?=
 =?us-ascii?Q?+LWnP7/awUOG3grNkJ85PK4XL0eXDbQ45C/ltma4qc7OYz3WHSE9Kw9V/6FD?=
 =?us-ascii?Q?mA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B678C6B9A6D354419A275148091A72DE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5580.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee431db-b7fb-42d7-a808-08daf7c08b17
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 12:52:36.5242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MaMfwsE4fzmZM+2AoEd+Se4F32TL3pU6RI0gqIQXxUU/yZYBNdcTC4qClgkhN+T+D66iU/zsIcl8QnzrFE0yyIbYj4J9SCwCz92GYAd68Ko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5968
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,
Thank you for your feedback.

> On Thu, Jan 12, 2023 at 09:15:51PM +0100, Daniel Machon wrote:
> > +/* Get protocol value from rewrite entry. */
> > +u16 dcb_getrewr(struct net_device *dev, struct dcb_app *app)
>    ^^^
>=20
> > +{
> > +     struct dcb_app_type *itr;
> > +     u8 proto =3D 0;
>=20
> Should "proto" be a u16 to match itr->app.protocol and the return type?

It should.

>=20
> > +
> > +     spin_lock_bh(&dcb_lock);
> > +     itr =3D dcb_rewr_lookup(app, dev->ifindex, -1);
> > +     if (itr)
> > +             proto =3D itr->app.protocol;
> > +     spin_unlock_bh(&dcb_lock);
> > +
> > +     return proto;
> > +}
> > +EXPORT_SYMBOL(dcb_getrewr);
> > +
> > + /* Add rewrite entry to the rewrite list. */
> > +int dcb_setrewr(struct net_device *dev, struct dcb_app *new)
> > +{
> > +     int err =3D 0;
>=20
> No need to initialize this.  It only disables static checkers and
> triggers a false positive about dead stores.

Yes, you are right :)

Will be fixed in next version.

/Daniel=
