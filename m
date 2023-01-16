Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D70566CEA1
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjAPSTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjAPSSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:18:11 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D25A222EF;
        Mon, 16 Jan 2023 10:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673892340; x=1705428340;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pcSVsj+i19wUBIvhIhQAyhl12OFActOMxgMYRrrhbd0=;
  b=V5qrsHxyCuiDOdbWU2k2YO6C1ej3qkwwPR+Aie6ZBmKudTMFB+/sYl+M
   ah/MHQdqWekKcHyKeQ287L8F3ne02Qdzw50Bglj0aS/LyJ/b5Jqsmcjdj
   oU0rmugoxRlhbkiXRCRTkTQCGCF/T95I6Ivg5Z1NxFA5jdhERDV4I/ZTN
   rCQ/Y7CzAb5FVwoLfMCm8C7LrsAkFU7SlDBNdFsTvf3YQCvGycFvZinKS
   uWgkWjxN9DRIq6ca3qRlEA/+YLsROemqAxNMGjVbxT60Nnaq5orzM9/rq
   qhDXc79j28l/yAUcRvNwPrE5DCKBTQyMupvxnJyjDwOmsCL5otRopaCyq
   g==;
X-IronPort-AV: E=Sophos;i="5.97,221,1669100400"; 
   d="scan'208";a="196877762"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 11:05:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 11:05:39 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 16 Jan 2023 11:05:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATiqnTFtaSMNR7moc3fPdZKUxK8rPiCx3z75cyutNo7sGsJ6rhDkv5GdBM/06kIC+xRTlJu3GSspov0ONsv47NLmz9sttjq9MSE4PosdpdEqmC5U36xBFVnsmc+zT7a1M48DWggDyiOfkCxTsX+MZLVEpbLGA+j/2Wkj+irB7SmvUjkghceWiJN/qsRTLZHIJ2YrZK1b/jIKfXv6gwfSlQyT8sD5PhhXSE1n1mEa1EpggA6Ru/11D6vCz2iS6QWO1bhx4viz0lUm9lLl5kc/S+I7RdBwDiGLaA+X0qKl3ODyMu+WujfYxEz0w4XV9kPXslKxRIa32WtAkG5xfNzAqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZpTp/fZ9X8ZIaUIxXLRFlMHGPMAyMJXQjEOBqpEvu0=;
 b=WOHw6+5yjRoP6C1vrcfOQm4nXi2GONfg+5qqujA3LBtokCtFoMB2BgJpCdSzMk2C4i6W7mZ9WfUFuFYMlBwAmpGtXrTjgFrdZE9gzekRxGTCUJ8uZbAQHn/m1bkanU0RrFoak8yqSm7QhBdz80MIM06UK0zVYzeQdIa699zjl6VQFn/dz78ieDRGY+0uCERTXKoQV4cCiz7wMX0+TfFp347SdVFU8CDfiUu7jAa4VhOEUDs4RzTENM9/bASteGI5rD2Wv/CAVY7LsSP6m25zHFzCbu471d/lMnfvQaS2hAXBSMaBbz6x0/ZMdqQbWJ39w4eO3VQ253Qfu4wrtMkz3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZpTp/fZ9X8ZIaUIxXLRFlMHGPMAyMJXQjEOBqpEvu0=;
 b=dppt5t6i4PeZX7ozff0OoK7UtoG1mPba2/wYrRUm3Y64S12zIdKRphSIlxSp4YKyg2SgcaFwKlZNHLJxt7Dtz8GF76KU2tSyQs1WbGZw5s3NuMKRT+1JlgRvKOP+pVyQlIritXoGDrmTU7Swq5GXknfUAnFbJPVLlz0h8bEPDTg=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by IA1PR11MB7679.namprd11.prod.outlook.com (2603:10b6:208:3f1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 18:05:37 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 18:05:37 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v6 5/6] dsa: lan9303: Port 0 is xMII port
Thread-Topic: [PATCH net-next v6 5/6] dsa: lan9303: Port 0 is xMII port
Thread-Index: AQHZJHAfAi0Nk7E6jEC4WJFxnKf0Pa6ea7yAgAL1iGA=
Date:   Mon, 16 Jan 2023 18:05:37 +0000
Message-ID: <MWHPR11MB16933112707D97121C67E5C5EFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-6-jerry.ray@microchip.com>
 <20230114205351.czy2fkfrulrl4w6k@skbuf>
In-Reply-To: <20230114205351.czy2fkfrulrl4w6k@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|IA1PR11MB7679:EE_
x-ms-office365-filtering-correlation-id: 14750465-8ec7-428a-c543-08daf7ec4551
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sQPHEyuS8Wq8SPkGUoCfjV87h8W/H2K3FdTNIxIQ/eYJQpmKCE29jmdEv6CD1mn5up2PPcXQSCDh+VnUe9qr9bqXZvtsh+MQglKvbU+RTTbOfjrX/ovg074E3cLQQETk9t1dzApsvlh2Rs0aFPyTHAp72iWH/zE/ZwzN/SzWFAU/KjFQOLZO0C5r39XpuUZ8MC4Do3Fxv+E9QLUlQhl1xPEi73dbPMGPn3TUITGI94gHhM42PN3lp2PpszxysVSNytvtsxMAfsFS5w/XVdYWWcoxU/3xMbHOK3hKOffKZqx7AiedzGh/KABA3lJXuydFOynNZOCaLg0K/MEpV8g3/pOhCg8WjqYz6R2J93Tj4eRlDEP1fQuTs2lqi/Z25XhARihyr4Z/pm4b/cpDvntGN1EPrScnx+Rm2l2NAR7tE1kIl6gQToW9w1rUk7qYmE/U8zT8YWm5FuB4h2tcu2CwutPyolWaqhH1xclAOZcP52MwVlPd9LZSwcPmgkA99ebD/CZ7JsPX5xV+TzrE3fFrvw1b33u2RpRv2bAhtGLmOodeknSj9SdTLw7HvH0Rvv4vN/otyC/7TPb6gf9gbtIonSk5ey788fFxghCVgvmuNfPRbTYL/e17HPtmXDaH764xzlbiFSsWkn+6PmaekjPIjO15b2l4JDp1y6iBH0uEeM6AWXaFazhTgEzZYJoeub1SY27YyTAGpEU5wXVTbCoKww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(86362001)(6916009)(38070700005)(76116006)(66946007)(64756008)(66476007)(8936002)(55016003)(66556008)(52536014)(66446008)(8676002)(4326008)(2906002)(7416002)(122000001)(38100700002)(83380400001)(33656002)(5660300002)(478600001)(71200400001)(7696005)(54906003)(316002)(41300700001)(9686003)(26005)(186003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wDSiNEQokKIP8EYRWDP0WrWZXnmIFf+nXmt4YGBR686eD656g67PIMDsWt9J?=
 =?us-ascii?Q?gTVnIGWeGqE91RnfzkvIjyCrSJnlBhk27q10WuK++LOJ5i+UFXyZjAHzppYg?=
 =?us-ascii?Q?mUH+Dr3ERmrKdpcdRbA1TfOU8yQQUpmvZVeXnzL6ZP+ej3GpIxd3fnQPBlJR?=
 =?us-ascii?Q?yyWE5rfVlA1wFegkjP5u1UbLrQRpRhe7TQmx2zylEU22MUnznc0RUYNCUEO8?=
 =?us-ascii?Q?DDubQ/4Lse9xMYaR2zvBbNp0qjTvSjMf9IE4a9G75d5GhHfiZhuNSFouLhUN?=
 =?us-ascii?Q?We6Id2Za6sk4sYf4czzyy83mJN69pAMtyNbnAL4w2JxWZhYn/7OPBFJHmiQD?=
 =?us-ascii?Q?56MFBkNhPS2/bo0W9MePLEtvxFD2sA84I5EEydlZnuShrFhM1XrKK0xBSk4R?=
 =?us-ascii?Q?2okRPkAjFB/BO9hZpJTUJsO9Il+FICgXvU4hrQ6+kvYYYSVcqKtgpyoKBPEP?=
 =?us-ascii?Q?kP/VOmrfq0n06cTFt95kkSIg4i+4xK1VrfYG0uZxFmTUQnAaKpFZwIlGGtEH?=
 =?us-ascii?Q?I7WRvJdt3tDx63JVXkzpycz2wZTbCMqvvy0ZkfsXdC9Mq1STv7/rW+ec8b6Y?=
 =?us-ascii?Q?abcS3zuq3T4oHrYMG91Zl3pc0BFlzvn1WkqukhmM61QWNAjGw5aZdSdvUjDn?=
 =?us-ascii?Q?8yoJ2KlOmDCE9fMWflr+2+WnzZ35YZuyuC8weRGp0yJUQ56EWWd+I9D3NEj4?=
 =?us-ascii?Q?v2jgUxxGvtGhRM8To+SLS3ogMR8DeuyEo2AGHcF1hMwfraNyWU85s8yyJHbC?=
 =?us-ascii?Q?a2DKCgcvDEEH2+2sGzdQRhC4Aw++v6l+V2xk4QZo7GPHeDLrvpIZsZQqg9Xo?=
 =?us-ascii?Q?L52U4Ebd+3kg2+l32pKLhWHUkJ7CrILOv+OpDhOtskWHVg5s1vEBtEPhQSv/?=
 =?us-ascii?Q?mf4d9kBhP61v6Ly20lIzK/cam2BW902iaGHdScQTKtfMfx1R2X3r/Qjz4lIH?=
 =?us-ascii?Q?+hZ01oQm0EK4HBLDz/iKkbMq1GYz3MAqGxqKbX8cXYk6jzBFwncy3C+IXLrh?=
 =?us-ascii?Q?OigbOXiGmgFA1TAPcFvajzHmChhNKy6Ram52pVWh97hjdhLQ9Ty8K9ZKhuxI?=
 =?us-ascii?Q?RCRtsk7xlnvlt9GYV1eKQy8mWde/Ktp+kiqTZOkDZPTt6acOQqZe8b1eHBr6?=
 =?us-ascii?Q?YpcZcrDnBIKEwqcn0bBWy4Jo+B/AsHrfAntquS89r7ohmuEKia2wnrtPkhxT?=
 =?us-ascii?Q?Sp7EjynSOg2Q7GFquTtVk6PeOosLiB/yzHMKGhIsH7SyfvScHnk1ilYN0Aqp?=
 =?us-ascii?Q?PJUWzJeSeB0ZvVnti94cSynPoVhPC4flwiGMQNzVHcqlY/XD23wukk0tVH3R?=
 =?us-ascii?Q?1z9LF7ooTuCJ3UNXG4PnL9ClcCV10QCCpnC3YqeHXhocDRgfKg/oRNf7qJX9?=
 =?us-ascii?Q?JwjYvNYuRwXkAsgXcXjv3SPoPDG/iXCPqVVlGEvrAYJNwTCDq1kTN/qE/LNm?=
 =?us-ascii?Q?4zPt4sbTfkusFU6z1IhZDihxyF8dZCJelwqwhUhvOiFFLVsIHGKRlxQb+kTJ?=
 =?us-ascii?Q?yH0puubS+qO2vYUvwomDgB/fIrXcoz+H8rlWtWJLpKEedwLFfnseqt5HqhQJ?=
 =?us-ascii?Q?wJYYqf6sEj0EcnF8bVDgDKOLebRyizs4fjvdkbnD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14750465-8ec7-428a-c543-08daf7ec4551
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 18:05:37.3207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wQ9hnEdlq1TasGiMBypK1FEqr8+Y4U7QtwPNpGhvtzMjHK8UPcB7JD+TThhhk2EtC4x5KF5DGBvWHLUXxf5rHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7679
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > In preparing to move the adjust_link logic into the phylink_mac_link_up
> > api, change the macro used to check for the cpu port. In
> > phylink_mac_link_up, the phydev pointer passed in for the CPU port is
> > NULL, so we can't keep using phy_is_pseudo_fixed_link(phydev).
> >
> > Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> > ---
> > v5->v6:
> >   Using port 0 to identify the xMII port on the LAN9303.
> > ---
> >  drivers/net/dsa/lan9303-core.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-c=
ore.c
> > index 792ce6a26a6a..7be4c491e5d9 100644
> > --- a/drivers/net/dsa/lan9303-core.c
> > +++ b/drivers/net/dsa/lan9303-core.c
> > @@ -1063,7 +1063,11 @@ static void lan9303_adjust_link(struct dsa_switc=
h *ds, int port,
> >  {
> >       int ctl;
> >
> > -     if (!phy_is_pseudo_fixed_link(phydev))
> > +     /* On this device, we are only interested in doing something here=
 if
> > +      * this is an xMII port. All other ports are 10/100 phys using MD=
IO
> > +      * to control there link settings.
> > +      */
> > +     if (port !=3D 0)
>=20
> Maybe a macro LAN9303_XMII_PORT would be good, if it was also
> consistently used in lan9303_setup()?
>=20

Agreed.  As I add more devices that have different capabilities, this will
change. I was hesitant to add this logic now as it is uncalled for until
multiple device types are supported by the driver.

> >               return;
> >
> >       ctl =3D lan9303_phy_read(ds, port, MII_BMCR);
> > --
> > 2.17.1
> >
