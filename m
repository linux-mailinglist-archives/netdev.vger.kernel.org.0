Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148C75A429A
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 07:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiH2Fuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 01:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiH2Fuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 01:50:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D08402F0;
        Sun, 28 Aug 2022 22:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661752250; x=1693288250;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o4DkSsK52blsiV74Zi8++/pUFbof6+o/9tKOR++2q/I=;
  b=ItzigL+FoljUsR+vNqqFMADLmCmKckF7K100vssBKxY9vpK+UCQHieVy
   W8ah95xV8WziQsiwmXf1xVI+hbZ9MA1ayJwvW9nlD8Cr8hiFAdyc8iVV/
   5jd/aR/0rdfM6qDlsHMOYv7Ua6HHuMRWaGClnBtyx5nH3C+SAF+ulPg8x
   hyj8eMwqXCkVZWyzrZqS26BZkp3aK4oMY62SLMP8dqUfKN7B6US1vRn/o
   Q24c6WApsDz6mrggr8Qwu0FmgVi/+3Ih7Mb8kl/LhQMDEMPFhEn+mh9z+
   +Msbr++eon55hazqLZPxO7w79Y0icYssPdz/YcxnND4H1aS68JcZSBd0C
   A==;
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="188428570"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Aug 2022 22:50:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 28 Aug 2022 22:50:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Sun, 28 Aug 2022 22:50:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVmypjDD73ODgQU8C9tpWk6yvwxbsKIfbN+gXhuVOACFF8Unph0gWeAOLEdYRDsTAj+VDkBPObVcAkS8WP1f1jTYte6IxlySdGLTqSA3BO+jUaKO/ZAZqchlbudmXJ/J5TFSZqM28FJFxM8T+G8pkm3f7ENxTj2CmBeW1BN+a7pLdJQi4kLkTvTxfSKPEqSxLO8y3qbQW+VoUVe170UwP1JHD2AD3tHVgSzeE+sv9IULjiYZhAGzjnoYGnhAGg1d6boW4WjM+WYisE7eSrK1Jm9gylFkBu0bW3pp3aQWOr+E+BHNim+FHCZ+yffuhmTr+9ET+j9tNEoDc667dBouMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xUKKKAaDxUS5P0btvKCAK2WDw14OZXyFKbCqYyUV2H8=;
 b=dN2Hj4tsaZtIbr7u8Kil21Xm6D16dqa8SCnr0G4iYcqT2UeU3jvrNVhd0HTME0eK16cluZlwr/nuyXs09iA5QsEhguY/zeUQxwPSU1ZcNQUKanorzSAqubMgkh3SduiUrHZZr5CTaAXemTTBxFpcxeqNi4CSA8SKsqdo1xsUn/I8RR4oRA4bgxTtcfBDUPeQojnZpPT1J7mMus6L0QfnH3WhEeib6gdS+Gd1yoqoa3hIsN6Wj++UVyBKeN3oCQqQfgn9Mak7KM6oIkJ3Dr7I3SWLao5tf885PBPKqVzquBRhEqMDabrgI9jfh0UVtt82hlBHrTOcG/NgB9M1gHt8ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUKKKAaDxUS5P0btvKCAK2WDw14OZXyFKbCqYyUV2H8=;
 b=u91V+al4bnO0jISquT4N2ueQcKwOccYE+Ois3gpvtPGc0kTiMjAdSRZp8K0+Xwe/1In6kwJIJUMoiYzJd8ZQM8YcXYAnn3u+a1XbyIbeq82NhsxcVTtiC//IrztsdH0eN2sRoIRHLhTzZTXIaOFCv5BG3myJy2T4xbtSuVZ6sgo=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by SN7PR11MB6994.namprd11.prod.outlook.com (2603:10b6:806:2ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 05:50:44 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::955:c58c:4696:6814]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::955:c58c:4696:6814%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 05:50:44 +0000
From:   <Divya.Koppera@microchip.com>
To:     <michael@walle.cc>, <o.rempel@pengutronix.de>
CC:     <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>, <edumazet@google.com>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: RE: [PATCH net-next] net: phy: micrel: Adding SQI support for lan8814
 phy
Thread-Topic: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Index: AQHYuFmMgzj2knw/J0+AGHw88JSECa3A3vGAgAACdoCAAAmpAIAEdMlg
Date:   Mon, 29 Aug 2022 05:50:44 +0000
Message-ID: <CO1PR11MB47715CFC7E22969BD00F9E6AE2769@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
 <20220826084249.1031557-1-michael@walle.cc>
 <CO1PR11MB477162C762EF35B0E115B952E2759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <421712ea840fbe5edffcae4a6cb08150@walle.cc>
In-Reply-To: <421712ea840fbe5edffcae4a6cb08150@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63d0908d-649e-478e-2de9-08da898269e1
x-ms-traffictypediagnostic: SN7PR11MB6994:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZXTSKoMK13eWQys9isVtxt9SM7eeyWqGsrZQz8CXJ4KnPrM1KOOZB0Lq29FMZrUq5RpBMuZYzmkB68GH3o+HB2PquQJeDEioPzRr5mFB8uFuJdpq91BwAFRe+wz0MU8JxagO8r03rcUrvTJNOMc+98bX3VcU3FKZRuSTkDuiwEn5QPjs/EkQQx8AQ49EU/CP7fuk/IUftrZ37YupzxDPQ6hIeMn6LjkqoecJ+T4O1FZPXD8kYBl2ErZyOznOB89xA3BXT0MdGjxPNt60Mcq9Zurp+8U/YRosD4zdoal71CHifJ4QGu+7LfXhD17X01bD/j6ULEJAyUippJ6auUIvkkpPQRJ93aUmiUqaTGEk8bimg7obn12hikoFGOp27lkLMAKoPIbOVQj2oYTfnCPstSDji5KQAC78gL+FvJ3QbfyZI7gUUQT8tLF8JWgS5HCoai5bkrSrs6yh2mcDdatlGNRY+MV3fFi8Dc5HNchqBQUIrGLBgq2Bcz/Qn1OD/rebj/uqbfhSqELE5PW5jvx1+u/ZTfPqv2xifDNyWeI2/3IY33QyfwJAtjvBKXQ2zedHkWU8oLrAVE6KzuBcZ2VLbQ3NFYPbdqwmiAFQKjJcD8DySaER5NYQDgS1LJu9PmgmKXMYkGkoKOVczCYncDfbX4PRaJ1A4y6+6aGhHcT/KR2uzhaue0GhuqDJkApAbGHqHW08QLN0jTJX9R7FjCvGdy0IbHfElwLQhltfdEAD1K5dhLsXrAHVHbEwOHnf0vvf0e5o8k2hjqRdnNFoWS9dBfRxOwGdIyvBWhhYkPIr4mc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(396003)(346002)(136003)(366004)(38070700005)(4326008)(76116006)(66946007)(66556008)(66446008)(64756008)(8676002)(122000001)(38100700002)(86362001)(33656002)(83380400001)(186003)(7696005)(6506007)(478600001)(9686003)(26005)(53546011)(41300700001)(71200400001)(966005)(110136005)(316002)(54906003)(55016003)(66476007)(2906002)(7416002)(5660300002)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a53V4wDgeMP2JpTYGynILsN/eP4+d99eOoTbu8Pk2oOcyVs9V3Qmg7/XegUD?=
 =?us-ascii?Q?zCnwt86Qg06LiHxPPahbklCpOqhYe0CzQitk4f0H08fIQ+cqQucMLjFfVBX6?=
 =?us-ascii?Q?H+dscfnd8w53LnpINU16oRSFOnqYzGpkJHOS6oR9K2yVb+VYFkE/K5zA7fCw?=
 =?us-ascii?Q?gx+uBXExF5mA41O27fBYcn7WvenoyzKBPaGeWrcHRAD7xhBf+VgLrovxRZWz?=
 =?us-ascii?Q?OQB38cZtGY5fjMzfXDLjlXnCFmxQRe4b7T+7ypCa2oBHvg9swNlT61/Fzxvb?=
 =?us-ascii?Q?IdHjwU9OfjC7w4gdyyEt9+4QaErffT36hJ/cCJSJFq/+bRTfe6Aaus5ZlZKz?=
 =?us-ascii?Q?B4axpVjwaTVqkRY8Is/2Ued9JJuCmDXmgHZiAnnTiov4ReKXUOwWJ+nN8JaK?=
 =?us-ascii?Q?9+dc9y4JGBemvRS4thMDE6/QYB0zhiBd8IfqGS0rW3JBeMNeT9jIQ6q5S6eV?=
 =?us-ascii?Q?J8HnQYj4T8Tr54LruWt+uOnGn9beK1qbB5hZinwm4lq6Vs3uGrvqLRankHOK?=
 =?us-ascii?Q?n7sNu2WozFECLoQICjOoRr4d2idC5sSxeEokJaaqu6FTwvwCtlKJrTiDeDkA?=
 =?us-ascii?Q?k/5DNIumkdUY7+BTOoiayDaN7rPv76d+cMxFEX750oFXCYDupMhbmZMr19dZ?=
 =?us-ascii?Q?NHZe6xKy/2xdKERqqHez3HPolMeopPxK+hUNX4f2MxChINkChmQb/OAayldP?=
 =?us-ascii?Q?0OhYzN3QCdaX8hXBUle27AVi+hhyori3kcv6XkOTzQaYQs3UGP+fz4LfDIlF?=
 =?us-ascii?Q?eZvu7Bll0ISI2SBZ/Msb3+H9mWqXHOhCEbEv1wn5BHQXUVPcI2mdRtdDOXUw?=
 =?us-ascii?Q?zftWb+VWQfwzxqCrWImWdQC5WI/4ngZxgp13B9+wTOPH7FXeYvHQ6LTH/MsU?=
 =?us-ascii?Q?FS8cIOz1S1e4hLrdNxLWMU8jqsJHNrm8RTpiVZMRORY4wjJFaxBfvG5XUkA5?=
 =?us-ascii?Q?vYYtPcVcJcOPOOcWkiRIjVBqJ9f2Q9p0T4LMCy/OO9xZOQLXRapJNK75p39n?=
 =?us-ascii?Q?VAhMPE2WqUZ5FZd/UElylKzdoM5FG59OodyCcK6N71VvA0kwNfZWdhkqWiYV?=
 =?us-ascii?Q?N2zxNMI55p745naRk7FGD7f3RP+TwFMlLlAd3oFzCavJ5HX49fq1oZ0zOlpH?=
 =?us-ascii?Q?WhMl11n6rBTCl31xXttX0r4grHLUWGGjJXAyzJV1o+T75K3SRnRtttnO9JMb?=
 =?us-ascii?Q?VSLXW6qAEe+roCem6OTrHT/kmBE6zzFpAftU7FAQ7l3+4E38VnOiubsKO2gW?=
 =?us-ascii?Q?sWaYZcqTF4KTyglqd8x+H17z4vaTYxOs7diJCmaWx2QlN9hTnMmyJxxxazVX?=
 =?us-ascii?Q?5razMV4MUAbxyriOGNM8m8XsJbEHFTtDnuzJqJaa9eUWKVrVAEGQ+vhWJD7X?=
 =?us-ascii?Q?RoGShcHa7oYnAREyBx2oE818m6d1a19xLgP0gHlpfBRytg8AZTQiqALnqy7P?=
 =?us-ascii?Q?dkjx29s7Fsn4TmXEabGkOYHDu9lQUZw8p/cWjHZuFdOHwX+kMAnNDNPu4EPv?=
 =?us-ascii?Q?dmy/WiA9H8zwATipZt8MnDvu6WWicEcXy1vwSeiWA2WX1jcZ+t09LLBsZMDD?=
 =?us-ascii?Q?sN6fcpIgDlHSYzmtdi9ENivI1XDK2gjO5XQ/Ddf1okao0O5YIpQ6JMqR6ohE?=
 =?us-ascii?Q?yQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d0908d-649e-478e-2de9-08da898269e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 05:50:44.1309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZWQlllKUWDCkKfY4uCgKdD1KdLyqoMcUmManVr6ZDKWR2TrXPoh8lCW5WJOEvleyXKHCaX9EeTO/XiNul8jn2tJaWIwm7ILgG6rKLIKUJh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6994
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

> -----Original Message-----
> From: Michael Walle <michael@walle.cc>
> Sent: Friday, August 26, 2022 2:56 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>; Oleksij Rempel
> <o.rempel@pengutronix.de>
> Cc: UNGLinuxDriver <UNGLinuxDriver@microchip.com>; andrew@lunn.ch;
> davem@davemloft.net; edumazet@google.com; hkallweit1@gmail.com;
> kuba@kernel.org; linux-kernel@vger.kernel.org; linux@armlinux.org.uk;
> netdev@vger.kernel.org; pabeni@redhat.com
> Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
> lan8814 phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> [+ Oleksij Rempel]
>=20
> Hi,
>=20
> Am 2022-08-26 11:11, schrieb Divya.Koppera@microchip.com:
> >> > Supports SQI(Signal Quality Index) for lan8814 phy, where it has
> >> > SQI index of 0-7 values and this indicator can be used for cable
> >> > integrity diagnostic and investigating other noise sources.
> >> >
> >> > Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
>=20
> ..
>=20
> >> > +#define LAN8814_DCQ_CTRL_CHANNEL_MASK
> GENMASK(1,
> >> 0)
> >> > +#define LAN8814_DCQ_SQI                                      0xe4
> >> > +#define LAN8814_DCQ_SQI_MAX                          7
> >> > +#define LAN8814_DCQ_SQI_VAL_MASK                     GENMASK(3, 1)
> >> > +
> >> >  static int lanphy_read_page_reg(struct phy_device *phydev, int
> >> > page,
> >> > u32 addr)  {
> >> >       int data;
> >> > @@ -2927,6 +2934,32 @@ static int lan8814_probe(struct phy_device
> >> *phydev)
> >> >       return 0;
> >> >  }
> >> >
> >> > +static int lan8814_get_sqi(struct phy_device *phydev) {
> >> > +     int rc, val;
> >> > +
> >> > +     val =3D lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL);
> >> > +     if (val < 0)
> >> > +             return val;
> >> > +
> >> > +     val &=3D ~LAN8814_DCQ_CTRL_CHANNEL_MASK;
> >>
> >> I do have a datasheet for this PHY, but it doesn't mention 0xe6 on
> >> EP1.
> >
> > This register values are present in GPHY hard macro as below
> >
> > 4.2.225       DCQ Control Register
> > Index (In Decimal):   EP 1.230        Size:   16 bits
> >
> > Can you give me the name of the datasheet which you are following, so
> > that I'll check and let you know the reason.
>=20
> I have the AN4286/DS00004286A ("LAN8804/LAN8814 GPHY Register
> Definitions"). Maybe there is a newer version of it.
>=20

I just looked into it, it doesn't have SQI registers. I requested internal =
team to add SQI register set in published document.

> >
> >> So I can only guess that this "channel mask" is for the 4 rx/tx pairs
> >> on GbE?
> >
> > Yes channel mask is for wire pair.
> >
> >> And you only seem to evaluate one of them. Is that the correct thing
> >> to do here?
> >>
> >
> > I found in below link is that, get_SQI returns sqi value for 100
> > base-t1 phy's
> > https://lore.kernel.org/netdev/20200519075200.24631-2-
> o.rempel@pengutronix.de/T/
>=20
> That one is for the 100base-t1 which has only one pair.
>=20
> > In lan8814 phy only channel 0 is used for 100base-tx. So returning SQI
> > value for channel 0.
>=20
> What if the other pairs are bad? Maybe Oleksij has an opinion here.
>=20
> Also 100baseTX (and 10baseT) has two pairs, one for transmitting and one
> for receiving. I guess you meassure the SQI on the receiving side. So is
> channel 0 correct here?
>=20

Yes Channel 0 is correct.

> Again this is the first time I hear about SQI but it puzzles me that
> it only evaluate one pair in this case. So as a user who reads this
> SQI might be misleaded.
>=20

Yeah, It needs uAPI extension.

> -michael
