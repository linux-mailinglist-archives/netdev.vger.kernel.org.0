Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AFB6C6144
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjCWID3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjCWID1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:03:27 -0400
Received: from outbound-ip23a.ess.barracuda.com (outbound-ip23a.ess.barracuda.com [209.222.82.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA67BDE0
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 01:03:13 -0700 (PDT)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104]) by mx-outbound12-205.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Mar 2023 08:02:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFBwXpIeGIpFwNcDxT6Gm/HTqkWzBZpBM/pFELyx+9TqWzNyg6awefRMvlcYnkfOULEBi0mUUSqLfDqLmeK88jgtgNhcdsMl9YdTYTsc6l6GxuzcBCZ+IF371ck8eW71LOJxyYfx07vnJlxwxwzMc78jzhhDUI/gAiXTffDV06dwvyHFihmbKndYfii5x058FN1Hhox0nrkQLckFugrrzUl0VMGkLQbqKj8ao3uzPhwjQB8yYGNA8TngzGJ40vVUreQblBOrhGqLk6ItzJZy6jEDR12G3GFM+2KiCa42CgI17+VnR3aE/fl/FEfaaMrOsBJ+ZWb8CF4ukNWgJ51rlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDO2sIIUiGiJiBPXXZBy0jpiEuuPLhTaXu97vcKB6P8=;
 b=eUqNDiDm6ZOAKsVXxnISDtEf3lb3XTQpJbiB/ICii00pjgSPxvDyDYsCi6hC0Yl5lfARi0wHlRDiY8bwctUMMrqWMElXYZzBCEkAuvBikJwufy8Uoe+jZ5Ma/QmTAmQSkVB9fuA46MHjAe6yTgtIVq9e62KDp1UEEetDzS1zV93uQFZPkmKEa01Bq+2Wl6KNR8xu6LNQ+xTXNsrpq8ckQCaRdlx5GMwUUGNnth/EhqWQfNkGJypI4cVqjL+QGlfttXBy3hBs6eGnb24ptgxCFQWBtqPwku/sP7YfKWc0k1HtYbApQpCJ9e6gxnC4D9x1Y0qvHiv/8wHVxhN+0uDguA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDO2sIIUiGiJiBPXXZBy0jpiEuuPLhTaXu97vcKB6P8=;
 b=XcL/exfqWkKE6+IU4yCUDOSqdJypUGs8p+khelUlEZfv1ZpibhmYvH9B9NT4ny+iuc21exdHrM/bpDi3aHT43vFWuhnTlC7o3Gtvg40No82swOIWrCAbI9JztWyoYCZTYIfFyTaJbrq56kPKH+S0MYQGIX1Kq7sr7QbyEoHzYpDH/cPrLVvbxmA96u6dMlJBxuVSHMb1kqIc2Zx5inX/++uXJSPVdwEq4IJmymzqqej9fiJEwztBRY/VfQHEjBLHCCPyJo11E3b6ONVjw2SeHeTxyr49AviS+ZUYSMSVQ2W7d7bfmc77QUyn84IvenND+TXniyBpgkXosu7srthfSA==
Received: from DS7PR10MB4926.namprd10.prod.outlook.com (2603:10b6:5:3ac::20)
 by CO1PR10MB4514.namprd10.prod.outlook.com (2603:10b6:303:9d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 08:02:44 +0000
Received: from DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::9ee4:1e8a:76b6:959b]) by DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::9ee4:1e8a:76b6:959b%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 08:02:44 +0000
From:   "Buzarra, Arturo" <Arturo.Buzarra@digi.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: RE: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Thread-Topic: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Thread-Index: AQHZWP1FSdAaHxazwkKnE2fAhKZFWq8DUXYQgABD0YCAAEfQAA==
Date:   Thu, 23 Mar 2023 08:02:43 +0000
Message-ID: <DS7PR10MB49260FFA60F0B3A5AB7AD69EFA879@DS7PR10MB4926.namprd10.prod.outlook.com>
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
 <3e904a01-7ea8-705c-bf7a-05059729cebf@gmail.com>
 <DS7PR10MB4926EBB7DAA389E69A4E2FC1FA809@DS7PR10MB4926.namprd10.prod.outlook.com>
 <74cef958-9513-40d7-8da4-7a566ba47291@lunn.ch>
In-Reply-To: <74cef958-9513-40d7-8da4-7a566ba47291@lunn.ch>
Accept-Language: es-ES, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=digi.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB4926:EE_|CO1PR10MB4514:EE_
x-ms-office365-filtering-correlation-id: 81bce545-83db-4937-c9e2-08db2b74fb7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AiOLokxZFGR1WvjDrLpBL+UTfqnAKtg8Aymcv5heGdUsy526vu30BYafDPodfzGODB6oFIHfS05KxCaLDaS04LnHcpg4CxMJTv/+iCVBi0aTUZaKONI/8rsYXrX/K0wk8Ic+jJUpw8iwxkdePVsFFzlYWA/5caQuxYWUjYbThWC4fVEMbRsm0tnNsmCRXsJTdIHPzRTlxAVSiuqoYfG9ur/XIwhWrQoil+Z9ErsKQHsVyLU2puUrcSmAF0d6/K9F1L+LzoKHBKUqWYcJUXL0305q1frz4jMyrVyQ2e4ZO4zyeRYxtCo3o9NN1iGvhaqXeoLykE/hHxoucrZVkUYpHjW1X3D9Qu3ZmoBlMRYHdRCdaYaE3GDHVvwPtlw6F5QDw+bIj1ZVCmuR5rrASlSLmDokE5JqFk0J3nV70iOXkuz7rz/f+1P7QSDs8b8te96wgO0QtWM4OViCbiJtluahhmRhsRF0AJNS1baPwtARcTsGxfbJSpUHHt/0Cq1lF91Y93M1cT8RtVQaKQiIpQ/atjMCU1eDjARpiTsf/sYukiaQY1DYmq1PUf1seBRd2Wq8elTRjYOL8QmSNqj7oyOaiPXrgMwXtnVrJ5XxYE1kMAtSDVsiHjjVqU6Eqy+I3dY/+GSrQcEWWVVryVCFjmlWbSFeH8vbREkw/ENQno4kbHscP1lv5j0rs9wEM/LcMzLdW8is7iF5PDJNCWEdVHrLPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4926.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(366004)(39850400004)(376002)(451199018)(38100700002)(38070700005)(55016003)(2906002)(66899018)(71200400001)(83380400001)(478600001)(9686003)(186003)(33656002)(86362001)(7696005)(316002)(54906003)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(6916009)(76116006)(52536014)(8936002)(53546011)(26005)(6506007)(122000001)(5660300002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UK8GshCr6wdnupUHTO+Dq8U49hY/I/Cd7P0xDXWGQXDJM2fpMkCCekqwSCTt?=
 =?us-ascii?Q?96qDbNbv5DHrlxUYI5mBH1Kzq7gSb88WtaZUNICRNcPecH0xKvZjNjb6iKaa?=
 =?us-ascii?Q?uGm0iOYWF4eDLIHO6NNawqXR9MrSEgaolrHq2h9by+DFBpcaa24FpnYtYywk?=
 =?us-ascii?Q?sXDUN+41hGgqO/va5pjOMvk04xy1qQ5hrhMrn1uzgmuZXAbi3ToLGvWDJ91B?=
 =?us-ascii?Q?kyLWXXk7IlRl77J4a6h56OwC4hYScOkQq8G6VtfSzml5oq7vcVqb6jGz/gag?=
 =?us-ascii?Q?B99WPjIhO7cLbQt4/zttyLtiCXAkxcLPMIbmK+kLD5dnVfdl+mzF07ijIExL?=
 =?us-ascii?Q?qVmxXJI5golRsRw2NpGXMxufe5yJFHr3a/hcY2aXLk8gSHnGWd/A10XstaXY?=
 =?us-ascii?Q?64eea1wJ7DAE7OIY8Uweq9fSru+Q/lRtwS+Qs/dzSf15nmHd+1KYCCP4QRlK?=
 =?us-ascii?Q?UMefFu5GxJOiSF1lpOGtOabcWSh5dq1RF24a9puEkQBuHkFKv2rv4jhOj0rm?=
 =?us-ascii?Q?24OE9w8iabm3x1e38lkZC+36GpBGYFtvUfR5j/5mNIJrhB/d2dL3IlQD6DP7?=
 =?us-ascii?Q?VBQyUJ1I3bYKdDLK1e0GHoVAhyWRdXkx5XB5rRb2bM8+J1a/ogUHgjzK3oGZ?=
 =?us-ascii?Q?OQ+04hpJdFeXQNXohXAaFd92J5lsHEr6bL1EC0FcmrC/OV3XegtfoO1To7Hz?=
 =?us-ascii?Q?ivWSG2L76+BzGHsq7SeqBYuwZgJSvDC6M1EKCJc4S9CGQlC6PEazCUzV4iU3?=
 =?us-ascii?Q?KsShGv41J10SBLhK/NEDTGcniOkBVW1tTs3xQrq9Echf/Bx6Q0hUabnb0vZC?=
 =?us-ascii?Q?Y78+IMt/j5dESiHgeJv1KtfXOi2WGccH81N07gDASNDQDpNCDWeiAvmd82k+?=
 =?us-ascii?Q?XGEvRNLpXEvwLWs6oSrCvkjU9cUQIYCMzmO+Sg3g4LuNC6GsG24Bc3rEYMiO?=
 =?us-ascii?Q?vxPjQZuq092eyGDDQTKGa1l+sE71+KGu8F4cNFQn3fm23wIiIMUy5q5rAksO?=
 =?us-ascii?Q?u4aX3Uk4wd7BcX6raAEN5IooDd30DRMht+Qo6qALQjzoHDndmKQkOUfBJ5bY?=
 =?us-ascii?Q?v/KFhraRBEkcb39T0RSCJ60Ixsvfvge0bmDMgOqrVoFVliDJMz/vltbAaBFe?=
 =?us-ascii?Q?KAuT0hbcLcWmZCgHxOQBUOFrJnHVSBfa42LKoRHv5b3cx1hbQVY7Q3MHq72w?=
 =?us-ascii?Q?b+OcedBOVTnVgdg64dljD9HTVeNtiZlbfjPZboDcVtxIkQOyVVnXkEi+zx34?=
 =?us-ascii?Q?X+V9T2wQW96kwBccKuQdt1ll+Z3Qt5flGIvf/RJbr+iR4mMre2QMewxkwTpe?=
 =?us-ascii?Q?Lefeb/hsdwTIPiO20NgfAs4LWIHrvbOxa1ZRO8mSjJwc5o0G5eHBzEXOWoAz?=
 =?us-ascii?Q?KamA/MF9i0VI0nwf1EY9kjZ7Hu8IB8kqBUQoQj/3SWzJe0xAZrrx02O9ruOF?=
 =?us-ascii?Q?RMQzyG4xXMsKN+whgEYVp41nCN6H1eVGTQtFWbZUMT+F4PRGeeouAE+et+Er?=
 =?us-ascii?Q?2sYm1DCWQYfG6EF22hmgQ4lL9wkGDY5kFGwvO3FylhUumENQmLfaKMwdJyg3?=
 =?us-ascii?Q?r7uW7YJp3Sgw7EIrC+wr+mdGoDingDZFtroiZ4lH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4926.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81bce545-83db-4937-c9e2-08db2b74fb7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 08:02:43.8245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yfdBrfZq5wf1SyW1uSG/CxaQGDC9C4IBJs+0+AQhsgRJ0V/u9Ie7FQowiv+QeekIM9vWBEenhqrUZaLu2ZK0fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4514
X-BESS-ID: 1679558568-103277-5654-10400-1
X-BESS-VER: 2019.1_20230317.2229
X-BESS-Apparent-Source-IP: 104.47.70.104
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuamZgZAVgZQ0MDEINncLNHAKD
        XRIjXN1Mw42dgy2SLNyNI8xSQ10SxZqTYWAGntwXxBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.246985 [from 
        cloudscan20-160.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.50 BSF_RULE7568M          META: Custom Rule 7568M 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

" You have two MACs. Do you have two MDIO busses, with one PHY on each bus,=
 or do you have just one MDIO bus in use, with two PHYs on it?"
I have two Ethernet MACs, with one MDIO bus connected to two different PHYs

"There is a pull up on the MDIO data line, so that if nothing drives it low=
, it reads 1. This was one of Florian comments. Have you check the value of=
 that pull up resistor?"
Yes, but with/without this pull-up we obtain the same behavior

"Which is odd, because the MDIO bus probe code would assume there is no PHY=
 there given those two values, and then would not bother trying to read the=
 abilities. So you are somehow forcing the core to assume there is a PHY th=
ere. Do you have the PHY ID in DT?"
Yes, we have both PHYs defined in the DT

"Where is the clock coming from? Does each PHY have its own crystal? Is the=
 clock coming from one of the MACs? Is one PHY a clock source and the other=
 a clock sync?"
Gigabit PHY has its own Crystal, however the 10/100 PHY uses a clock from t=
he CPU and it is the root cause of the issue because when Linux asks the PH=
Y capabilities the clock is not ready yet.

"We first want to understand the problem before adding such hacks. It reall=
y sounds like something the PHY needs is missing, a clock, time after a res=
et, etc. If we can figure that out, we can avoid such hacks"
We have identified the root cause of the 0xFFFF issue, it is because the tw=
o PHYs are defined in the same MDIO bus node inside the first Ethernet MAC =
node, and when the 10/100 PHY is probed the PHY Clock from the CPU is not r=
eady, this is the DT definition:
---------
/* Gigabit Ethernet */
&eth1 {
	status =3D "okay";
	pinctrl-0 =3D <&eth1_rgmii_pins>;
	pinctrl-names =3D "default";
	phy-mode =3D "rgmii-id";
	max-speed =3D <1000>;
	phy-handle =3D <&phy0_eth1>;

	mdio1 {
		#address-cells =3D <1>;
		#size-cells =3D <0>;
		compatible =3D "snps,dwmac-mdio";

		phy0_eth1: ethernet-phy@0 {
			reg =3D <0>;
			compatible =3D "ethernet-phy-id0141.0dd0"; /* PHY ID for Marvell 88E1512=
 */
			reset-gpios =3D <&gpioi 2 (GPIO_ACTIVE_LOW | GPIO_PULL_UP)>;
			reset-assert-us =3D <1000>;
			reset-deassert-us =3D <2000>;
		};

		phy0_eth2: ethernet-phy@1 {
			reg =3D <1>;
			compatible =3D "ethernet-phy-id0007.c0f0"; /* PHY ID for SMSC LAN8720Ai =
*/
			reset-gpios =3D <&gpioh 7 (GPIO_ACTIVE_LOW | GPIO_PULL_UP)>;
			interrupt-parent =3D <&gpioh>;
			interrupts =3D <2 IRQ_TYPE_LEVEL_LOW>;
		};
	};
};

/* 10/100 Ethernet */
&eth2 {
	status =3D "okay";
	pinctrl-0 =3D <&eth2_rmii_pins>;
	pinctrl-names =3D "default";
	phy-mode =3D "rmii";
	max-speed =3D <100>;
	phy-handle =3D <&phy0_eth2>;
	st,ext-phyclk;
};
---------
This is the power-up sequence:
- ST MAC driver (dwmac-stm32.c) initializes the first Ethernet interface in=
 RGMII mode
- Linux kernel perform the Gigabit PHY probe
- Linux kernel perform the 10/100 PHY probe ( and reads a wrong value from =
the MII_BMSR register because the PHY clock from the CPU is not ready)
- ST MAC driver (dwmac-stm32.c) initializes the second Ethernet interface i=
n RMII mode (Here the CPU initializes the PHY Clock)

So the 10/100 PHY is probed BEFORE the PHY Clock is initialized.

In spite of this corner case issue that we have with our particular setup, =
I think that consider a 0x0000 or 0xFFFF read value as a valid value is wro=
ng. For our issue I have several fixes: hardcoded the PHY capabilities in t=
he smsc.c driver with " .features  =3D PHY_BASIC_FEATURES" , another fix is=
 in the same driver adding a custom function for " .get_features" where if =
I read 0xFFFF or 0x0000 return a EPROBE_DEFER. But the real motivation to s=
end that patch was that after review several drivers that also checks the r=
esult of read MII_BMSR against 0x0000 and 0xFFFF , I tried to send a common=
 fix in the PHY core, to avoid maintain this verification in different driv=
ers.

Thanks,

Arturo.

-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch>=20
Sent: lunes, 20 de marzo de 2023 13:01
To: Buzarra, Arturo <Arturo.Buzarra@digi.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>; netdev@vger.kernel.org; Florian=
 Fainelli <f.fainelli@gmail.com>; Russell King - ARM Linux <linux@armlinux.=
org.uk>
Subject: Re: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible

[EXTERNAL E-MAIL] Warning! This email originated outside of the organizatio=
n! Do not click links or open attachments unless you recognize the sender a=
nd know the content is safe.



On Mon, Mar 20, 2023 at 09:45:38AM +0000, Buzarra, Arturo wrote:
> Hi,
>
> I will try to answer all your questions:
>
> - "We need more specifics here, what type of PHY device are you seeing th=
is with?"
> - " So best start with some details about your use case, which MAC, which=
 PHY, etc"
> I'm using a LAN8720A PHY (10/100 on RMII mode) with a ST MAC ( in particu=
lar is a stm32mp1 processor).
> We have two PHYs one is a Gigabit PHY (RGMII mode) and the another one is=
 a 10/100 (RMII mode).

Where is the clock coming from? Does each PHY have its own crystal? Is the =
clock coming from one of the MACs? Is one PHY a clock source and the other =
a clock sync?

> In the boot process, I think that there is a race condition between=20
> configuring the Ethernet MACs and the two PHYs. At same point the=20
> RGMII Ethernet MAC is configured and starts the PHY probes.

You have two MACs. Do you have two MDIO busses, with one PHY on each bus, o=
r do you have just one MDIO bus in use, with two PHYs on it?

Please show us your Device Tree description of the hardware.

> When the 10/100 PHY starts the probe, it tries to read the
> genphy_read_abilities() and always reads 0xFFFF ( I assume that this=20
> is the default electrical values for that lines before it are=20
> configured).

There is a pull up on the MDIO data line, so that if nothing drives it low,=
 it reads 1. This was one of Florian comments. Have you check the value of =
that pull up resistor?

> - " Does the device reliably enumerate on the bus, i.e. reading registers=
 2 and 3 to get its ID?"
> Reading the registers PHYSID1 and PHYSID2 reports also 0xFFFF

Which is odd, because the MDIO bus probe code would assume there is no PHY =
there given those two values, and then would not bother trying to read the =
abilities. So you are somehow forcing the core to assume there is a PHY the=
re. Do you have the PHY ID in DT?

> - " If the PHY is broken, by some yet to be determined definition of brok=
en, we try to limit the workaround to as narrow as possible. So it should n=
ot be in the core probe code. It should be in the PHY specific driver, and =
ideally for only its ID, not the whole vendors family of PHYs"
> I have several workarounds/fixed for that, the easy way is set the PHY ca=
pabilities in the smsc.c driver " .features  =3D PHY_BASIC_FEATURES" like i=
n the past and it works fine. Also I have another fix in the same driver ad=
ding a custom function for " get_features" where if I read 0xFFFF or 0x0000=
 return a EPROBE_DEFER. However after review another drivers (net/usb/pegas=
us.c , net/Ethernet/toshiba/spider_net.c, net/sis/sis190.c, and more...)  t=
hat also checks the result of read MII_BMSR against 0x0000 and 0xFFFF , I t=
ried to send a common fix in the PHY core. From my point of view read a 0x0=
000 or 0xFFFF value is an error in the probe step like if the phy_read() re=
turns an error, so I think that the PHY core should consider return a EPROB=
E_DEFER to at least provide a second try for that PHY device.

We first want to understand the problem before adding such hacks. It really=
 sounds like something the PHY needs is missing, a clock, time after a rese=
t, etc. If we can figure that out, we can avoid such hacks.

        Andrew
