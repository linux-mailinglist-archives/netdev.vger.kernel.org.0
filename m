Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CD6649A10
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 09:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiLLIez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 03:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiLLIew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 03:34:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13505DFB4;
        Mon, 12 Dec 2022 00:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670834089; x=1702370089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NTRBZmxGGfRxJFgqeduzMwtYQ6uKXbsiECqi3jz1+HY=;
  b=DrclAw4Y57+weFG7Pen5U1FiCLRhePX/C3TtADTx+cb+lRjSQnxhd5V0
   pIrIT7QNw+sQqpvw9+xJx7YXwmmHTjxpMhYGOBEmEe84X11STeRiypWef
   Ifcfh2SASX7l9GKrMkAjwhtn/Mb78n8wVcBuH0uRs6M03CY5cWT13CNT9
   SEY3HuJC0Df3m5rFHVhd773VYUes4BDnuEbqY9rQHBcaGrfnONlbvraaY
   Evq8RGHI1Gamvqvgar24+YqhIjQCfFbPMHwEkmPVwLI6An/nOZX7qhzh+
   NJY1deEOv6DUWssIlG9VP2J7RhEbxqPKe2mvWvO8uADwgVn+UzJhZPOOl
   A==;
X-IronPort-AV: E=Sophos;i="5.96,237,1665471600"; 
   d="scan'208";a="127641879"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 01:34:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 01:34:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 01:34:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2RlwhwgnkAMO6cMRjmzicJsv20I35f5pzQ518NgDCIaVw0noGgyTjBx2jGoPFRGBYvFG31QprC8XILxNChLFkiWVKpSukeviHvm1BMtdfpvuqfX3etFIGFAGgVosbjmNWcWNJI7t0d90RzynYpusits9oR0q/1Y8EVG7J6oEGwXszlvQoftj5un1FBPnO15GdzIXpQpNeCAqN31EhbxxL5jdLFXvpc2a2Jegr5DH2IobIDPrwz/9zwMfJEtzyVVmlE1joulFBh1uidiiis2N7b2pF5otl/TjezY1MLz0YtR39uN/L2ifrN9g+k3y26huKygceXCX76OAs3HJthVng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bu6x3w6zzXr1mftX4f8Hy8Eka/1Fz3NeYg8FMoiOaZw=;
 b=RjvhlHqf3c7ARhv70pTq4DvoxcRDAAgmCczusOS4LXThywrpOOEyAfqEKcjhcYI+Cj9GfS43iVS1JlzdZN+RrK9kHXUJTnGwHPiEQfZ8dIQpRkbp27s5K+4cZSeRvFBbqsf/CaLc5+s4d4EvXcAaIyXiGPKTHiNISboEdTOCtZXENdqb0CspxKaytZ6sLmQSPfUeSVQyknnHGusCb74CR80FwX6C2rGo0iKo05GUVhhDoTuW7iYdWfCwk9v2/XJcc7YNAWCASXrOKLq43nkDMiQ2Z8ni78q61tDI4OExKU0A3ZONlZ7TJRgWrhu8sMHjppmS/ni60PhiHI4y39Pquw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bu6x3w6zzXr1mftX4f8Hy8Eka/1Fz3NeYg8FMoiOaZw=;
 b=WI23ayBq2c5P+pde9YC6jtlqOe43Tm7U7wlHtPTcrucZe7u9Dth+xTJS5ka1KlftWsxtUxpJB6ub9T4oPv3Dv/RbE6SLaS714HI8QU1xPWP012uWjovWGITl8FQw9XtIoArQVZpVvB2k+ve0XcbkYpD95+ugc42IhZ3MJJXjYuM=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 08:34:44 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 08:34:44 +0000
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
Thread-Index: AQHZCUVX+xhZw8rF5EesOiBOrBuDqa5g1PgAgAAJjpCAAAeBgIAI7uug
Date:   Mon, 12 Dec 2022 08:34:44 +0000
Message-ID: <CO1PR11MB4771F8AA1CCAD01EAE797E59E2E29@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20221206073511.4772-1-Divya.Koppera@microchip.com>
 <20221206073511.4772-3-Divya.Koppera@microchip.com>
 <Y48+rLpF7Gre/s1P@lunn.ch>
 <CO1PR11MB47713C125F3D0E08B7A6A132E21B9@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Y49M++waEHLm0hEA@lunn.ch>
In-Reply-To: <Y49M++waEHLm0hEA@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|PH7PR11MB6771:EE_
x-ms-office365-filtering-correlation-id: e95b1087-7887-41f2-8806-08dadc1bb86c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZJztoXr0Q+rQ1xyBeLNtTRavlXQFu/FtbUWPn1OqVsnSyT0pRn/iOSmdFkBfziyEW1NkwA02RRTsxWVstj87vUOlBF34TDULLhXX1hqzffGjTt6pdH9g8x6u5QUO5hGDTySlGB7lbj27fAnpg82YhZOhhOv5e0Z1V+zi32CQAzukR0l6PBxSnZ6PTfQtVIOJTRiaj6ldzjEyb2Sn7FTrRb9vtbkWeFHSG8TbEzBTFWwiU86frcfIXkcb5+whDEZGFg/h1jJ85HaCHZhNQHJROl9JI1bXa+yJn5sGl49dGbN1FbbvwIPhvvHcO63huMUuLJzhoarvgy1d7RKToHbD/v/rbaiPJlhhisQRZpWcSZFwYNUtNmXQwWjE85QBZa5G6BBFkrxOm65pBe6hwDTvwafawUxed78TNiAn6D2Ior0ukLJMmC5oJM5zX3PmS07d2TsBo9LfSUMG+LE7NRdioW6HuuTmcc1KXyrS5moNRSkK/p0eqcVA3eud7zg6tsLEW9zuRzIj1SLLebM9GHtRL3sY+6k1GGafCm4TFHKVRsm7TqNWqR7eFm2vYrY9SEpBIMOO8RuUyMGVRhkX3nORbP+W1CT96rBk0vF1wbyLEAv60697f8U3oB26oGmgR8/g18AoDgGqupRfqEXISeYvL7rKiL2SbFqxoLVPNEvIzJHqaLOiN1GMWxNu8e7pupWqb7jKioCCBu4Fm/9TxQOYCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199015)(52536014)(5660300002)(38070700005)(316002)(6916009)(7416002)(54906003)(8936002)(76116006)(4326008)(66946007)(66556008)(66476007)(8676002)(64756008)(26005)(66446008)(9686003)(86362001)(107886003)(6506007)(53546011)(7696005)(186003)(83380400001)(33656002)(41300700001)(478600001)(71200400001)(2906002)(122000001)(55016003)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aX5ho2XZGOEQ8xWONwOLwi4FlfZWAdNKzThyXrYWOotZLgkWAY9xaAWIYhLE?=
 =?us-ascii?Q?APVxrbn3/w1VR5qb+cOdGnFFI19Uh2vz3fbga9TjuuDAva4CVZHiEme3Kzdh?=
 =?us-ascii?Q?K00/IRAU8x5xQYE57iHFqsFw7n7zUyJyh78QFm0lAGkAYHMzC/Q8X6iU/Sh7?=
 =?us-ascii?Q?Y+GdVaVZNdOlYfzHEJk/1lO1oyvVEYP+b+0Jlbwmv7YNz4+aBU86D4WLFpdP?=
 =?us-ascii?Q?i/2BPZ9wrIOqIDJxDB/q3BRU06fthpGl6OYGQBTYOrHvq4ylaAgf1mMoVgDD?=
 =?us-ascii?Q?jYCl25MTKDHdbmzevlh5meqwLKYNu2tyHAEUY5wx+ck3Qey0NsOnHW6mjNNg?=
 =?us-ascii?Q?U/4hkU/0HRkiCcIebB8YN5MMl3gWLBoMm21aZepM9BySAO311SWhsJdmuhjr?=
 =?us-ascii?Q?vysRvHc+zz1uPQGm25PFKlF9XyShp1zZ7TH/uo1rpPtoZmWhgzxcLi0N+2M6?=
 =?us-ascii?Q?+LYSpoTzFPQ8uBYBUFm8RsPIgkGhdsO1qfCfHLE9Pt/0g6GDAsMRKyyCc7mb?=
 =?us-ascii?Q?tZdSYdPV3frMOu41CprcpWVoHA2e3GRlp1lY9todajCVTTOuZCCLPoxI0K1+?=
 =?us-ascii?Q?k38TyfAH5c5qBgmMxJycPRWzEfanjmckMzAdS0IlSSzMlvG6ix2xmQL5RHYq?=
 =?us-ascii?Q?YsrTUKJGN/7P92Ce223CgaaJJqPA7zm5uFkWuRKZbyGzzk8CTVDncWAUpM20?=
 =?us-ascii?Q?7fui9BzDcyRuLG4mRJxepCKjCPWJ7UpknhXH5rfg00xkvSKEcQjVbzzKBmTb?=
 =?us-ascii?Q?nqwp6ypH5UCJB5f892NOev+984mjCswweDTlkxoO3Bl4lf28Z5F61yPi91ad?=
 =?us-ascii?Q?EleUvD9/xx/XTH4O3A6V/u7AJYW+ETTKaqVKpsn9z5uqHrDGF+PcdEzdVKAv?=
 =?us-ascii?Q?VLMj7RUFhLDwO/suj1NO1ntnYlsV60izYQU2yCXwq7S7JBL2/J9tR5sYldoI?=
 =?us-ascii?Q?9GGQlTmMx9xWgqmKtSeVmHxUdeivLCO7r2fH4GGHU1HPgvL+ylrvKUGaCjAz?=
 =?us-ascii?Q?kD9PYGntwLQDpO8+fWgv6lKSBwbQw54WWQZfN+m/RPYTopuq/ObuHqOn5kci?=
 =?us-ascii?Q?mt2I+FFEmav2Aki+5Udi63hsvpj797le2vbczZ6+kohQdqxJTPgPFpynf0yF?=
 =?us-ascii?Q?vV+wD+/15dyY5Nfox09v/0n9qyEXCAZEyws1Q1NKH3ErsIZQ4GuxGwDozwVC?=
 =?us-ascii?Q?o6uCUCw1EPbRavYKKiPG56/63vbnw8Xukuk7unubHiuc0WIRpiq/+djzNvn9?=
 =?us-ascii?Q?htcwPH+geBKXRodFc2hQcuzcY0TLasQ3jyKOcGnnBCNT40jpHn1lMAETVHHQ?=
 =?us-ascii?Q?grabrxDNl8ocsIGLTJss70BWmJP3okelyxPgCH8hqhSNa28KzR0QvRG6Bvs9?=
 =?us-ascii?Q?mK19iunxpvxeEFCAjBNBuUASqHnHiURXq/JKrq0mhDtsISE8aDMek1GIGEEK?=
 =?us-ascii?Q?iDD77xqHVo4SGsGf6w/7UIC8I4nnA1YJd+3+dszhogCmAg1P7Kxr3fzGZVn3?=
 =?us-ascii?Q?zEngjQrL5VjOG7xyUjddbU0unN5Vcfh43f0YgLO/jhb/G8LhiKDvboFxALv7?=
 =?us-ascii?Q?wUp1ha8HEHLVNHalVKWrcczbK2NLgW/UVDkF4easJgpVxQjN2kZ205lbqmOs?=
 =?us-ascii?Q?ag=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e95b1087-7887-41f2-8806-08dadc1bb86c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 08:34:44.2069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aRhhMCx1xmFOlbcLf1fvywtByO7JtYSmELiI6oeRq1ktSu+wlaB251XQ+rLXu76ucs9Phd86y/LTzHSL+9oYYcCXN3Uidp4l/3hDEotX0KA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6771
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
> Sent: Tuesday, December 6, 2022 7:39 PM
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
> > > > -     if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > > > -         !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > > > -             return 0;
> > > > -
> > >
> > > Why are you removing this ?
> > >
> >
> > I got review comment from Richard in v2 as below, making it as consiste=
nt
> by checking ptp_clock. So removed it in next revision.
> >
> > " > static int lan8814_ptp_probe_once(struct phy_device *phydev)
> > > {
> > >         struct lan8814_shared_priv *shared =3D phydev->shared->priv;
> > >
> > >         if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > >             !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > >                 return 0;
> >
> > It is weird to use macros here, but not before calling ptp_clock_regist=
er.
> > Make it consistent by checking shared->ptp_clock instead.
> > That is also better form."
>=20
> O.K. If Richard said this fine.
>=20
> Just out of interest, could you disassemble lan8814_ptp_probe_once() when
> CONFIG_PTP_1588_CLOCK is disabled, with and without this check?
>=20

If I understand correctly,

With (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) check, initialization of mutex and=
 members of shared->ptp_clock_info need to be done in first function.
Without above check ptp_clock_register should be done in second function. C=
orrect me if I'm wrong.

In this case, if first function is bypassed because of clock disable config=
, no need to go to second function. Could you please check below solution, =
if that works fine?

> My guess is, when PTP is disabled, the mutex still gets initialised, all =
the
> member of shared->ptp_clock_info are set. The optimise cannot remove it.
> With the macro check, the function is empty. So you end up with a slightl=
y
> bigger text size.
>=20

If that is the case, I'll keep the CONFIG_PTP_1588_CLOCK disabled check bef=
ore calling lan8814_ptp_probe_once.

Next thing is if CONFIG_PTP_1588_CLOCK disabled check pass then ptp_clock_r=
egister will never return null because we are bypassing hardware clock chec=
k before calling function itself.
So, I can remove ptp_clock null check too. Let me know if this works, I'll =
do changes in next revision.

>        Andrew
