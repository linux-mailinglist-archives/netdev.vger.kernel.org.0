Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6046466D1E8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 23:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbjAPWtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 17:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbjAPWs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 17:48:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D522658E;
        Mon, 16 Jan 2023 14:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673909335; x=1705445335;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0Z+9qHgOQYi0Thm8p6TZX9uXDjvo6HB+Mo+JPgbxwhQ=;
  b=R8w6LKI6w/KkwJWqZ7xSdd4PJsokiQcTVG/wMpv8JcT9YXcbM4OrV0k1
   jym1IT45NDtvaGdCiKgjSeUEYCDSADiYNDTmBtVI4R3G7nfIX02gC0emo
   hgx4o5WWRhCqJm8AHeXGX+i+uYbNVHfA3EmDbHLdzbkPpg7J1r2mEDbew
   rYJVv67vFj6ZugD9gly+o8//pYFBnTaANCezAO6bagsrgKG4kKDOscdgz
   6u1S7MKtN0KNX8UvxvioFVevwZEf59r83V6v5eG1kPEAHz9gsci3T6L+m
   FPdY4uau5pLdPbaRIk2NzmXqk9Iu5MumP8b9BbBUIImrYbd6uANasZ0Rq
   g==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669100400"; 
   d="scan'208";a="196043896"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 15:48:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 15:48:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 15:48:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ET4BAMCMjPzYsL4r+EI2bJ8SOpxGF3+YwZMKKW/LHF0w8TioAIHNyMoaYbIxEJwJawRp/B6gkuvJMqJznfolMXjtnhQiZG+ZUP6zN0efAj6Cq2tkvCniuXhBZYCUDRn3pJn6BB6xx1ATY3mDVPz2otGR81D/m4f2KDsqNWae4yrUUL2e6w+ODHc3Fmq6DsDynQC0wYZD5BIXcFvcL2SNgBtcO+M5NvIu6lj1f0RxBmRWBzpyX3gwts9stdiWWwkWOwLhUmo7wwqXR1J0v360infkDFmGE/SdRPRSpLXqTFT10ubG+djvQMxMuMmWSqeqaSIK3yMQHnacIi1AFF4RSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQZmg0YQTucJ/v6+1dp7wX4miwji8UWVGzWGznT17Ig=;
 b=mKxooy2kbznd+Y88a63dHneN8HREHeUyAvWOf3PS9RfE5s1eDwstrqsNgmjcNlba+M1qBjhZaTzCQiUHcSb6J8StSjf325heKRLy1sNQ92Ze9ELiws4AMAebGmvyHkaVNX+aGM5RDiCAIjbQri5pHK6uvjQBKJnIvFc9AxW3CSgBB/8iM46eLgBT3bwCVNtSdDxsVDie62VYmw+Eua/5E6NadJ3exjjXdMTuNtsZN2UJ2YTiMCWnwTGkhTHtzKaDu/fu68hFDgqBdf0fpRoSoBUp5xhs8i2TONnPzz+HDq28K/KrIJENdBGZKrHhVLaw04nVr1buAopLyiHhwnXivw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQZmg0YQTucJ/v6+1dp7wX4miwji8UWVGzWGznT17Ig=;
 b=rXLnXFVEOt/HcxDLKS0l2X0/fz/fEYg9cHiSlshjxFUAdlTApQmYjGh3BSM7V7OHYm1CFgAWKB+VsKzlBzOIzrrJsDdfDSzIC2kv2bKMrrhbRuIjvV7bQG7nXFT8jsVsc9L8+5W+i2j1LuamsfABj972mWaq0ckwi/ocRwEMH/E=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by MW3PR11MB4700.namprd11.prod.outlook.com (2603:10b6:303:2d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 22:48:48 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 22:48:48 +0000
From:   <Jerry.Ray@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Thread-Topic: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Thread-Index: AQHZJHAUgbmW0ofBykmmlKO+Ubpgs66arr+AgAamOBCAAAu0gIAATvQw
Date:   Mon, 16 Jan 2023 22:48:47 +0000
Message-ID: <MWHPR11MB16938EF0B3FBFB87022A327AEFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-7-jerry.ray@microchip.com>
 <Y7/zlzcyTsF+z0cN@shell.armlinux.org.uk>
 <MWHPR11MB169301FF4ED0E0BB2305780AEFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
 <Y8WRVWaalcfW+vLB@shell.armlinux.org.uk>
In-Reply-To: <Y8WRVWaalcfW+vLB@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|MW3PR11MB4700:EE_
x-ms-office365-filtering-correlation-id: b3c476b1-78bc-4322-d0ea-08daf813d47e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TDrPqmPsR2s69kQ33Z5Xz+MTuEAR+zIsRJ9h//HaOtymUYhtBw3GZrZd2hakFDF2y4+FOsuJoqN3GROkF/WYSeoRTXySX6pf8lMa7kVQg4LInuZoosgSafyKXF0sUSgLneSK2tVE55P5yOMMBTZdY0JBVepFqIV0OYPRA9smZOMpYqDxqm4Rh++Jo61rq6CRPz04oSPCPKFHXAglmVYsxTLel6+fpVBzOyXapll4d6FWXJ+CKCEBRi0vclDUqIn474Dt5650Yk9sBVpPnu1sy+UsT7+QqxfokTlkNSz1THhtuZYXF3zIwykBXkoIBUubhyNP/04ku1QeVGntvenzzfIgpTKaZKGWRc6awBD92CCI1neAFrU20eIa3Dh/Q2hQsY/op0A7qprpeTO1Vk8eUIhzPJ2BCTu43PeHMpgP7JoeKhISKAETnM5Vohx/Vbi/TMVujXMjKM+WZVWuZJohL1pGOdo7ODMnDO0NgFEyDMZleg8V2H4hOL/4UL4roSCJTAQcC3CtcH35exDbmEyQTAVYpGXkx6Yb9n1J0aneB0VQEanxH/SCbXI7IAEVtbixp7++5vQhCzEgDwol2lr2GJbwOmf5PBYC8RU5BHZQJXkcfIrevr97L4G+Y2C/BA2fvS8UdIOH4UCl851IuQZ/O01ONm57I+3wBmUbtw34glbowzZYsrftKJxreWNDdFPRj0wuNvjLotQ2RR1OL8ilSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(71200400001)(7696005)(186003)(6916009)(4326008)(66476007)(8676002)(66556008)(9686003)(66446008)(76116006)(64756008)(26005)(66946007)(478600001)(6506007)(41300700001)(52536014)(8936002)(5660300002)(2906002)(7416002)(83380400001)(316002)(122000001)(54906003)(38070700005)(33656002)(38100700002)(86362001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pnaWRzt0gCjdRXf3eodZwgq8b20Qi+D2zlHdFBm20CMDXr6ThgS5wuDWNvg+?=
 =?us-ascii?Q?bafqpZi+IFS6d6atV2fx0Sj7r4ioTl9vnpmo99VZJay6OoNaDzBOLZ+TtQcZ?=
 =?us-ascii?Q?2XZbDhRLNJCVzljgIQVAbx09Ff7A5edHH77s/jweNyF/ECv82VIXDeLcID+j?=
 =?us-ascii?Q?TQsvghIw90FcW8v14M9wqi2uwUWu+ZmtkOFEqK8kzwj8wnuyauBBZ+J7Ns1y?=
 =?us-ascii?Q?Y7eeQe6eyW23Wi/81r0HeamzY/qNXuLie2IRk/3c4fh/uH0mqVwwwAKwdT05?=
 =?us-ascii?Q?R/7hPu5kpaZd4tlPo3OBfilfqR483/SszzhHMRKsXnSvuvA/xSULCHppjzP/?=
 =?us-ascii?Q?NdwYe/tt2jlBWo1fGfUkyzAdvSZrcRVGpfg/k6ONT2rB2NKnskx7eM3+vV8B?=
 =?us-ascii?Q?2cvVfjLQt+IJ+/vvC6qhf8ZuDdwJfUBR2mKYtBSLhlkdZCWZuUcoaVHHks2a?=
 =?us-ascii?Q?/0rc8JMzTwDFO5WsfIlV/e57NA6zow9EHW5tnU7G6NExdWJ+E+4Aiq+qw+KB?=
 =?us-ascii?Q?Kx39kSrThsx5pRcAFKu1hQucrK7CUY15OhTi4zE4bT9wxIacfDcewycDizfA?=
 =?us-ascii?Q?bJZY2Wi9CgcPpfx/nz6m8CtH1vrxu68HU7hUzVWUtRWisDuy0Wdj+jmlK7fD?=
 =?us-ascii?Q?mwBkvh9J2otuJ+3CBlgJkNo0tKltRRXiuKME8brz2E1x4pAocs29HUSXhKfm?=
 =?us-ascii?Q?Iy6b6gyBzG9Y1yfUyMY6kaNACGqA0iQVbiBIwOQGPqgANUvlXs5rs78xeX4M?=
 =?us-ascii?Q?3BvIWcb5JDWdhwvcXv9DQj3bl4w2Rm82yEO0YLg3fIez42H3dH2hjXqZsk79?=
 =?us-ascii?Q?Z2EAa4Ftc3Aru6WDXnfUUW/4kU9aY/GapiRXu+NTopVyy2gmk+OIWuYFqSCP?=
 =?us-ascii?Q?lliJ0/6MMxC8o0gtx9Wh1FZq90TLDjEmkWbLteR2iGF66S/3Bts9gouUMyNE?=
 =?us-ascii?Q?CI6b6zOKz38DGRn4DbP9iX/YRSEWcV4r9EHjKf3qDU1z8xXFx7blpo7s0BB2?=
 =?us-ascii?Q?RjRiXPXr+L+Jrq4agXe7u4FcXu/IOCFn8gp0X0guGesdUXYB5KBdGhRS1NQG?=
 =?us-ascii?Q?qEhJ/F/d1nj5RIcJ3wlYWbfAkQHqj5qCv3+Ph8J0VIlCegAkPwSRwkQaqW5X?=
 =?us-ascii?Q?76VPvX9jvZDRWWyyRXWgHwdfrb5CWTgH0qSU9irlicCe1JccMicDjrNGLjG2?=
 =?us-ascii?Q?TefyYyiSCWu6mJQGkjbAJ5nrKusBqyoJqqO4/bfTdWOSeShF0jVP/M4b0J0J?=
 =?us-ascii?Q?ioy7ex5BfKbG4UbaMYDR1CKxWk9ucV8yjnYU8SJNvXHC+SY+imkFG0ME2glj?=
 =?us-ascii?Q?jo6MwxUh+Tw+sH4eXfucnycIyGGvNRw5Lasey/lKfwiNQ6ByaDS9tUA2xRnD?=
 =?us-ascii?Q?GvcuRnakhzFAXwJxD2pYkitjIDOvbwGYgvYYUxkDbb7QEJfkDh957WOJ2t12?=
 =?us-ascii?Q?1CxUpWTkt8+Z+szWWbpDwfxliWXZ63oCNMm/8OTT1EX43/FF6lOFtLrd2cf8?=
 =?us-ascii?Q?PuD1FcGbDp5IH0Akph5IfP1ZVZbl7Ct5Kb6aifixjvnlVoZ6A6wTEAVUkusG?=
 =?us-ascii?Q?abBhdKmUytkFmDdo/i8IY0trbOPuwmyX1YUOf7YN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3c476b1-78bc-4322-d0ea-08daf813d47e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 22:48:47.8869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4S2zDta0W0f6EshqXOwwlGqterE7Q42AMfuC0abHwxBqPGxE1Va3QbM3SElha43yZ3SqPbG4V+NVJfKiDATIKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4700
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > +static void lan9303_phylink_get_caps(struct dsa_switch *ds, int po=
rt,
> > > > +                                  struct phylink_config *config)
> > > > +{
> > > > +     struct lan9303 *chip =3D ds->priv;
> > > > +
> > > > +     dev_dbg(chip->dev, "%s(%d) entered.", __func__, port);
> > > > +
> > > > +     config->mac_capabilities =3D MAC_10 | MAC_100 | MAC_ASYM_PAUS=
E |
> > > > +                                MAC_SYM_PAUSE;
> > >
> > > You indicate that pause modes are supported, but...
> > >
> > > > +static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int=
 port,
> > > > +                                     unsigned int mode,
> > > > +                                     phy_interface_t interface,
> > > > +                                     struct phy_device *phydev, in=
t speed,
> > > > +                                     int duplex, bool tx_pause,
> > > > +                                     bool rx_pause)
> > > > +{
> > > > +     u32 ctl;
> > > > +
> > > > +     /* On this device, we are only interested in doing something =
here if
> > > > +      * this is the xMII port. All other ports are 10/100 phys usi=
ng MDIO
> > > > +      * to control there link settings.
> > > > +      */
> > > > +     if (port !=3D 0)
> > > > +             return;
> > > > +
> > > > +     ctl =3D lan9303_phy_read(ds, port, MII_BMCR);
> > > > +
> > > > +     ctl &=3D ~BMCR_ANENABLE;
> > > > +
> > > > +     if (speed =3D=3D SPEED_100)
> > > > +             ctl |=3D BMCR_SPEED100;
> > > > +     else if (speed =3D=3D SPEED_10)
> > > > +             ctl &=3D ~BMCR_SPEED100;
> > > > +     else
> > > > +             dev_err(ds->dev, "unsupported speed: %d\n", speed);
> > > > +
> > > > +     if (duplex =3D=3D DUPLEX_FULL)
> > > > +             ctl |=3D BMCR_FULLDPLX;
> > > > +     else
> > > > +             ctl &=3D ~BMCR_FULLDPLX;
> > > > +
> > > > +     lan9303_phy_write(ds, port, MII_BMCR, ctl);
> > >
> > > There is no code here to program the resolved pause modes. Is it hand=
led
> > > internally within the switch? (Please add a comment to this effect
> > > either in get_caps or here.)
> > >
> > > Thanks.
> > >
> >
> > As I look into this, the part does have control flags for advertising
> > Symmetric and Asymmetric pause toward the link partner. The default is =
set
> > by a configuration strap on power-up. I am having trouble mapping the r=
x and
> > tx pause parameters into symmetric and asymmetric controls. Where can I=
 find
> > the proper definitions and mappings?
> >
> >   ctl &=3D ~( ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_AYM);
> >   if(tx_pause)
> >     ctl |=3D ADVERTISE_PAUSE_CAP;
> >   if(rx_pause)
> >     ctl |=3D ADVERTISE_PAUSE_AYM;
>=20
> lan9303_phylink_mac_link_up() has nothing to do with what might be
> advertised to the link partner - this is called when the link has been
> negotiated and established, and it's purpose is to program the results
> of the resolution into the MAC.
>=20
> That means programming the MAC to operate at the negotiated speed and
> duplex, and also permitting the MAC to generate pause frames when its
> receive side becomes full (tx_pause) and whether to act on pause frames
> received over the network (rx_pause).
>=20
> If there's nowhere to program the MAC to accept and/or generate pause
> frames, how are they controlled? Does the MAC always accept and/or
> generate them? Or does the MAC always ignore them and never generates
> them?
>=20
> If the latter, then that suggests pause frames are not supported, and
> thus MAC_SYM_PAUSE and MAC_ASYM_PAUSE should not be set in the get_caps
> method.
>=20
> This leads me on to another question - in the above quoted code, what
> device's BMCR is being accessed in lan9303_phylink_mac_link_up() ? Is
> it a PCS? If it is, please use the phylink_pcs support, as the
> pcs_config() method gives you what is necessary to program the PCS
> advertisement.
>=20
> Thanks.
>=20
> --

On this device, the XMII connection is the rev-xmii port connected to the C=
PU.
This is the DSA port. This device 'emulates' a phy (virtual phy) allowing t=
he
CPU to use standard phy registers to set things up.

Let me back up for a moment.
The device supports half-duplex BackPressure as well as full-duplex Flow
Control.
The device has bootstrapping options that will configure the Settings for
BP and FC. On port 0, these strapping options also affect the Virtual Phys
Auto-Negotiation Link Partner Base Page Ability Register.
If auto-negotiation is enabled, the flow control is enabled/disabled based
on the Sym/Asym settings of the Advertised and Link Partner's capabilities
registers.
If Manual Flow Control is enabled, then flow control is programmed into the
Manual_FC_0 register directly and the auto-neg registers are ignored. The
device can be strapped to use (default to) the Manual FC register.

So this is why I'm trying to reflect the flow control settings as provided =
in
the mac_link_up hook api into the emulated phy's aneg settings.

Question:  In the get capabilities API, should I report the device's
flow control capabilities independent of how the device is bootstrapped or
should I reflect the bootstrapped settings? I consider the bootstrap settin=
g
to affect the register default rather than limit what the device is physica=
lly
capable of supporting.

Thanks for helping me get this right.
Regards,
Jerry.
