Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F348A5A422B
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 07:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiH2FXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 01:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH2FXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 01:23:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7131B44575;
        Sun, 28 Aug 2022 22:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661750593; x=1693286593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1VoKOGVvnoARM3BCLq8TKNo1wcOrVHviwmCIActkRcM=;
  b=KQeWnCbn/VW/oTSqZJjKWoTv3I0ScY6tICORqDXiBHJcyEY1sWKN7/Wi
   fia3RFrgSDVyi968G4PFEXKhtkwO05XXRUwiDW/+OEGj/UWkCL66eX9n6
   bp5m5Fm7V1aUXtApDvf6X2ipdFLn2Z+CM6VOOkQcYuP/aVZ3/v0OysWgN
   vHNWTDawC/BC9oYeqQKP1vkc+eHUzxCdytsFPp56AF+HX7PJucz320Nr2
   ZVbiLcWgexLRaZSLsHj+W7M9Jc/0ztvkuHVGqkBHXRKj0ezOaZD/Tl5Eq
   rlT3WBiaZ56n0pab9N9pNRkrJno/GDU7pSq4+lN9tA6wA0yZzhijT5Nav
   w==;
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="188426666"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Aug 2022 22:23:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 28 Aug 2022 22:23:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Sun, 28 Aug 2022 22:23:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfLvbU9BqAqONpk18gpxm70aXCBnk00IKG1SoQVkESl9kmu2eFhL3Pi1uUbsFHJ88Sw/bvHL/afddvb3qCKxYEgequFJIaxWTCzCIHUGF8c1X4sMhYAyuXuEWorwpLonQ4QdqHJLopDl/sbHkL6s8JWwyOEcDGQESZHL0xM4o7H2YNng07O04IGtDTxRs4zqdQ/o+tGKq4aUIfLK5sw4FfzvvrQe6nfhK2s7PJ78GPDihSmT5gFRJ6iW6ew6xgV9k4xe4qhssF/4jKrRLTxBRrHeRRAZLxWnH5f/FpOeTnNQmNvoUrflvYtBVI8NOnRGZgLJN+TE/+Zj49+BsWe+pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S47MdNya3MZWvUWCc+Vjre0YHNH4Ml64xR9PjuRMc7s=;
 b=lFLoKmfINfWUx8QLtWuuljcgC9WsaLZw10uOHU1Ei20ZVFG2TyoT26olI8mcsR5W6+z5jVLv+7wPlOpq4MXivOoKk/Y1FoOlyaByeQ86+Od8+P6jXD+jHV/H2Gw7B504whf1rCwzsEnv5ALvXvZDule+d5WH3B95kaNsP+QPQcLEZtDFx2Viskw+lGd18coBTWCGjnyCbkPZfNqJMLDMBa1aSulGoQ6XfcJD6aY3yzbwKjVBolwz0xH4ZvpNAYOHZGM0K2hyaexWGKv/uIlOqB/Mu1r6fZ+AIh0fAIzCCSTphJlwu7eSYwJpzC+apLV6F2587xRME7xcg9bx3jS51g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S47MdNya3MZWvUWCc+Vjre0YHNH4Ml64xR9PjuRMc7s=;
 b=ouGjbcO+/RHdo3J1XZ7Ub4sKdcl7xgt9cQEro05XzgCiebQ/2Y3diyWeJLz0xORLMToW8NKjRbSG7+JSupP2EEbLgS4QtJ9fZXMzBVxtY7eNjEkZq8otRUNra0W3IS144nWO5A4Vlyx0tsC5PhyF1ccngLLzg3dmXmaNUzl8+xE=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by SJ0PR11MB5679.namprd11.prod.outlook.com (2603:10b6:a03:303::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 05:23:07 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::955:c58c:4696:6814]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::955:c58c:4696:6814%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 05:23:07 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] net: phy: micrel: Adding SQI support for lan8814
 phy
Thread-Topic: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Index: AQHYuFmMgzj2knw/J0+AGHw88JSECa3AKZiAgABiu9CAAQr4AIADwxag
Date:   Mon, 29 Aug 2022 05:23:07 +0000
Message-ID: <CO1PR11MB47712F0DBA0490570DFFB572E2769@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
 <YwfvaSFejdtPtZgK@lunn.ch>
 <CO1PR11MB4771E1680E841F91411AE6DFE2759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YwkiLoZkkl2cVcOT@lunn.ch>
In-Reply-To: <YwkiLoZkkl2cVcOT@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b512745-81c8-4108-4edd-08da897e8e8d
x-ms-traffictypediagnostic: SJ0PR11MB5679:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h+gmLllNHozDvVy8WbOJJ6Z9RQa+0/SGdwAZZWczahCBaOP+rP+N9Z5oqa4Im5wVkIlTV49coxyIrhkSzVUO1nXI+g2b+yzPvp+/zQwWsZlNQgqWpqbtG5PhMU3vuUBR13XKmoGIM6adD7lQvSKBVbm71OOxz08CAn4cNguAc8pbz/Ox6Ii6ZsmJkUIJ+Ru4Jm91GMs5Od+m9AYyAHZeOSn42NX2EJiaAJgXNB0iUD7DPuhHhb14FIbqNIW58LpTGqUvwlbJU+wdmmz4y3IOzyeqz/NERixubwxFEUwyV7Wn0CvEOdRpMn0RsvPypsW+AMPscGyPz3yNoL+CUonj+xzRx8pZC8lnuu1VOPP5yPILRYzJiYfi3xFCzioc6FxZhEudm5LllHt6KxXnM0I8Cb3Iesw8tNc9rV6j3wtcschkg79chLbsHeQml9OorHRfP/dGsWmNlMwx+q2lP7/H9OYaPlMKjOC9hVaMJ4TExAHURn3lHJCYTElYCBhTS00OiNIPnuC5dCT1MqyKEhoALeav423bHICdpFbxKtdDqfuTqaSMfABjXZ34p2duBE9B3KS+R3JvB0OEoyr8FMFueen/snAGo8Q/fGsm1awUsdiP/j6F/pcHv3cDgr0XeAqTLxu1U5oMdzheM+1oV9cT13/IAgfX2VRWopUPWzkVB3Ihi3bwb58HzGy1KHp/EKoTJUMNyiMngcLkqqbgLDg2CaooU0t0SMEVyMzgkfRYgBoogl+Bnhk+86k7ndQhR/a9DONiUzwyW9/ThraJ7Xsop+IWdjtjiKTLoKC5uYRsiR2N1EUyvmbdaoAqobGsQRJj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(366004)(346002)(39860400002)(136003)(71200400001)(54906003)(6916009)(966005)(8676002)(86362001)(4326008)(66446008)(76116006)(66946007)(66476007)(64756008)(66556008)(316002)(5660300002)(478600001)(52536014)(38070700005)(8936002)(41300700001)(107886003)(38100700002)(6506007)(122000001)(53546011)(7696005)(2906002)(83380400001)(55016003)(26005)(9686003)(186003)(33656002)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dJepmLDayu5xNOgkGZUo0B77aSOdDUs+mR6hKsSAShIwwbs5lXBcYz06C1AG?=
 =?us-ascii?Q?7uVb7gLBBa8pAkqqpVTdbX7ZUIuoebVd93yGGtERUl6EyGE/jeMpxybLCaSD?=
 =?us-ascii?Q?Hv4iI9DRL6+Xh5AMOP5hcJUNPfJQU1yC/Ipkz9d6zVe7M+4PQdQBAwQ5/JDV?=
 =?us-ascii?Q?D3WY5Bi5Ex2fW6AmvyOkoT5XryZz2zenpefubEBXuh/7ENXWsmGnLMJ5z8DO?=
 =?us-ascii?Q?7NaXV7/8dOMvC1q97x5+5LmqQvM37VOi39e2KDKqUaUyeTpcJTz9khchhbDa?=
 =?us-ascii?Q?ZQekuD6nKDNetUebVNKh+SrbQEuQ94SOMiso3HD53BHhM24TrHRTrbqtj20t?=
 =?us-ascii?Q?I4i7oJsWxN/0fC01HxPDRDQ9EZXEk5hzDO4zTq7GJCfJGYuh0Xcg8nt+Zio0?=
 =?us-ascii?Q?zkSwo8RiZy7jUaH710yMpTS2AOzsnsXkIMGP/SMQ6ej8NGzKyM80tjGKFvSj?=
 =?us-ascii?Q?T6lkATfBKk0JsOZyZaXiXEBHdEmH5inxOHwAL/5iaHOK6AbK+zGQxtyC83kn?=
 =?us-ascii?Q?yY4ykZ3a6/msRbHiRrAGE6nzcKOAYw9WCqmPgOKFlXmYaLZ/671gZ3R43eas?=
 =?us-ascii?Q?znVnmReE8WCC5i1FHDQy9LcxyM0ydV4YH9Ltc2/EWoOweznuiYvSnBuQy9PA?=
 =?us-ascii?Q?u0tcFilZsXE6LstEDGvc8OX1b1qL33/NpMhJ+Qti3YklAh7HDJXN9YbFayCn?=
 =?us-ascii?Q?ye3NO2290NS6HsClloz8HAY0dCNx8ns3P9c7d0pIQtv4geIF8MuRfDlm57t2?=
 =?us-ascii?Q?WPAnD6zoRykBVa0YT6iU6EyC3jTPbV4ejI+y+KsLhjBmx2likY9EfO46GRzc?=
 =?us-ascii?Q?fABr6exMd+KpsKggSViHNIsdR8XlQlxHc4pHYukS5k4jcebmVuPEeb96Hk4Y?=
 =?us-ascii?Q?uS0zcyfAZDYKrj1v8uIpFst+FT4v5IwGbnrKxavlJGNxNZb/9Yz7Q+0IKumW?=
 =?us-ascii?Q?y0S5mT99JkZjwqZx1guSsu5kI6gvyoH6kUEo+3jJH9awGzQ3o0oO68hEcdNM?=
 =?us-ascii?Q?m9El35xFTgvfoXRf+/S2T7ndudX70klIUbYoKmDnXo0pQ4AfdfcsMzruIlPQ?=
 =?us-ascii?Q?PbGVzR6z0l44OHW9Us7ILeIHSZ9qQ++BZqrm1SGVUHEpLPOGNtnYCOZEEPGm?=
 =?us-ascii?Q?fYN2mz3260S2b3e3vuh9BxpINJlS94+oRBLNZejdvPlQDDa0l11xbc93QyjK?=
 =?us-ascii?Q?gCiqxIy3XuXsbUx4Ul9z3GD9/qtMqi8ERO9KpDyoXenVSIBcVGKuhJ0+p/gN?=
 =?us-ascii?Q?H+h80LxsAfq05cH60exKdMyjYKDBF1JTQ42mWJElwSlasQtbJbpCcEUo4INA?=
 =?us-ascii?Q?F2KxBsxfndmdsiFdGumpCBmdR/R+3Wr2eOQSgXuD4OXC3PpseI7MwtZpUthb?=
 =?us-ascii?Q?aku7hGI1Erm7cM2dsT1DnIZN1BVYwzX9C2i8kneIy67+6gOsBtRYk2V8YLOg?=
 =?us-ascii?Q?vwxd8WS6ndGNcv6HB/pikTmTBXaWX1txj7KEVTYrTuPMr2lHeq8Bbwj/TvKN?=
 =?us-ascii?Q?64RYISs9qtwVhTRJgoJ2MBwf0NCAFYuRnPVk47HMibvUhRw/ohO6VdYPs6Ga?=
 =?us-ascii?Q?yNU52HG06gMI7ZjgxyPko9ugQYylyvbkjKQfC3GGqK7WYfZ3u3TUBML9Zg3c?=
 =?us-ascii?Q?Lg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b512745-81c8-4108-4edd-08da897e8e8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 05:23:07.6544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fhdSxOPNHB/0TdaHloDk8H+m0SX36ZxRT81hMVpNYg+A01xIbWSNXv774TsroijtZqvTazJuAacKu6qcw2DldGwvs/cVACcrxfEyrXIpqCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5679
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Saturday, August 27, 2022 1:13 AM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
> lan8814 phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> > > I just took a quick look at the datasheet. It says:
> > >
> >
> > I'm not sure the datasheet you looked into is the right one. Could you
> please crosscheck if its lan8814 or lan8841.
> > Lan8814 is quad port phy where register access are of extended page.
> Lan8841 is 1 port phy where register access are mmd access.
> >
> > > All registers references in this section are in MMD Device Address 1
> > >
> > > So you should be using phy_read_mmd(phydev,
> MDIO_MMD_PMAPMD,
> > > xxx) to read/write these registers. The datasheet i have however is
> > > missing the register map, so i've no idea if it is still 0xe6.
>=20
> https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/
> ProductDocuments/DataSheets/DS-LAN8814-00003592C.pdf
>=20
> 5.13.4 OPEN ALLIANCE TC1/TC12 DCQ SIGNAL QUALITY INDEX
>=20
> Note: All registers references in this section are in MMD Device Address =
1.
>=20

Ah.. I too looked into it. Its a mistake. I suggested for correction of doc=
ument internally. Also requested team to add=20
SQI register set in register document that is published.

> This section defines the implementation of section 6.1.2 of the TC1 and T=
C12
> specifications. This mode builds upon the OPEN Alliance
> TC1/TC12 DCQ Mean Square Error method by mapping the MSE value onto a
> simple quality index. This mode is enabled by setting the sqi_enable bit,=
 in
> the DCQ Configuration register.
>=20
> The MSE value is compared to the thresholds set in the DCQ SQI Table
> Registers to provide an SQI value between 0 (worst value) and 7 (best
> value) as follows:
>=20
> In order to capture the SQI value, the DCQ Read Capture bit in the DCQ
> Configuration register needs to be written as a high with the desired cab=
le
> pair specified in the DCQ Channel Number field of the same register. The
> DCQ Read Capture bit will immediately self-clear and the result will be
> available in the DCQ SQI register.  In addition to the current SQI, the w=
orst
> case (lowest) SQI since the last read is available in the SQI Worst Case =
field.
> The correlation between the SQI values stored in the DCQ SQI register and=
 an
> according Signal to Noise Ratio (SNR) based on Additive White Gaussian
> (AWG) noise (bandwidth of 80 MHz @ 100 Mbps / 550 MHz @ 1000 Mbps) is
> shown in Table 5-5. The bit error rates to be expected in the case of whi=
te
> noise as interference signal is shown in the table as well for informatio=
n
> purposes.
>=20
> I had a quick look at OPEN ALLIANCE specification. It seems to specify ho=
w
> each of these registers should look. It just failed to specify where in t=
he
> address map they are. So if you look at drivers implementing SQI, you see
> most poke around in MDIO_MMD_VEND1.  I wounder if we can actually
> share the implementation between drivers, those that follow the standard,
> with some paramatirisation where the registers are.
>=20

I don't think it will work, each phy may have different register set and ma=
y or may not supports SQI.
Also it contains drivers of too old and that may not support SQI.

Apart from this lan8814 is quad port phy and register set is completely dif=
ferent from other drivers.

>           Andrew

Thanks,
Divya
