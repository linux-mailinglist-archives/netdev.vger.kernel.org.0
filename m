Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A164C6F6
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 07:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731203AbfFTF4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 01:56:52 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:33650 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbfFTF4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 01:56:52 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5K5scqg001135;
        Wed, 19 Jun 2019 22:56:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=QrB6/Bd5JTBdsW37ZH+JnM4cL33bTB1CqmrE3shCL/0=;
 b=V3TjHCDbq8ndXp5hdTSNtevXIoev5dA+FuemRq2mmRtTw7gko6GoD6fbzDW+hZWz4BJ3
 5AX6Arx4PfZhwCHhaZAeNDWLIMeHr0fwbtZYdXD6cajKo9OcKvNW4tUQk54KU4VS6HIf
 iCLiOv+ZCuXw/rd5R8TVCap84qBLH0H6aPnDcdPVOIKrwrh5UTpsNm9/NJApqQZr4Oc5
 /WDtMQrhifomvEM3YTpXde1NDYGfRJuweL5VfwclTwpqQ9ahnBDBxEeOcHm9BZOLhojK
 8CVJmeOvebLj55AsyGWVFdhagNSAm9poN9yX4hFF+nNvQfBue30AMyRm+UgedKvAxthw jw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2059.outbound.protection.outlook.com [104.47.37.59])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t7byx5w9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 22:56:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrB6/Bd5JTBdsW37ZH+JnM4cL33bTB1CqmrE3shCL/0=;
 b=HmEQel9CDu/zbBT2NUYetzTNVSfV42jCFMR5dqTR1Cd3y3rLJndaVbYg07RBTvweUd1YxElbPedvxsdZ47/U3tQbUzFkf8rum5EZ9SPfsNDhQFhzxkAg/+Fnfh6Q3Svcl0lu3LDD2ELvLTM/2+vKpVzp0Pyh+WMfVHI98hvA73Q=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2677.namprd07.prod.outlook.com (10.166.93.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Thu, 20 Jun 2019 05:56:32 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 05:56:32 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH v2 2/5] net: macb: add support for sgmii MAC-PHY interface
Thread-Topic: [PATCH v2 2/5] net: macb: add support for sgmii MAC-PHY
 interface
Thread-Index: AQHVJnr0drBG2PH/rUy05pV+jK9MiqaitqoAgAAZ8dCAABhxAIABFcIg
Date:   Thu, 20 Jun 2019 05:56:32 +0000
Message-ID: <CO2PR07MB24693905766BD027DB972761C1E40@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
 <1560933646-29852-1-git-send-email-pthombar@cadence.com>
 <20190619093146.yajbeht7mizm4hmr@shell.armlinux.org.uk>
 <CO2PR07MB24695C706292A16D71322DB5C1E50@CO2PR07MB2469.namprd07.prod.outlook.com>
 <20190619123206.zvc7gzt4ewxby2y2@shell.armlinux.org.uk>
In-Reply-To: <20190619123206.zvc7gzt4ewxby2y2@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0yMjlkZGQ1Ny05MzIwLTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcMjI5ZGRkNTktOTMyMC0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSI1ODkzIiB0PSIxMzIwNTQ4Mzc4NTA2ODgwMjYiIGg9IktzNTN5a2lDNnR0b3d6UTB6a2pLLzhjNXYzbz0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51a44a8f-68b9-4ca0-bdcb-08d6f5440be2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2677;
x-ms-traffictypediagnostic: CO2PR07MB2677:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CO2PR07MB267780078E49677CED3D510BC1E40@CO2PR07MB2677.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(39860400002)(346002)(366004)(396003)(36092001)(199004)(189003)(53936002)(6306002)(9686003)(68736007)(186003)(54906003)(7696005)(55236004)(86362001)(8936002)(66066001)(66476007)(107886003)(11346002)(446003)(73956011)(76176011)(64756008)(66556008)(8676002)(5660300002)(102836004)(66446008)(4326008)(81166006)(52536014)(2906002)(26005)(6116002)(66946007)(78486014)(3846002)(76116006)(6916009)(14444005)(256004)(14454004)(25786009)(99286004)(966005)(6246003)(81156014)(305945005)(33656002)(6506007)(229853002)(74316002)(486006)(476003)(55016002)(6436002)(316002)(7736002)(71190400001)(71200400001)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2677;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /WjayXgmGSy2k503wcqJBnBRbPVxtpCCdSA/cYzrZsPkhOIhe2JbvSzN2bpNgMqhDDRGJloggVYKkwyB3q5U+lBPfPkOX1sAQq/rQT8quuHSk6op8Q9L+H1hC6chhKuYha2ykEefA5UT6EQ97j0jtHA55L+wj/1jsWFr3xPCRo11h1ZT9CgsTlAyRmF8WcbIi+EA0Pun1b48AuFUuSg+XlMrsuhr1r6MHCrXqliRWelQX+dre25gguv+JhQBswcFpuav3bihZrVGml/FEpEHvBinHIYWwxbVsiiBO2nu/e3zhMqSPzQvJp4jxUrZhDxSsgiXplYzPCleSzInxnwN6LHVcAWa/QNAfEcgXPx87C5Qpa8IoPO4ntWVcBSiBcJTgF/UTpO+Poo9QpWFbULREARtp75RMA6aziJlU5TcGNI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a44a8f-68b9-4ca0-bdcb-08d6f5440be2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 05:56:32.4203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2677
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200047
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
>
>On Wed, Jun 19, 2019 at 11:23:01AM +0000, Parshuram Raju Thombare wrote:
>
>> >From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
>
>> >
>
>> >On Wed, Jun 19, 2019 at 09:40:46AM +0100, Parshuram Thombare wrote:
>
>> >
>
>> >> This patch add support for SGMII interface) and
>
>> >
>
>> >> 2.5Gbps MAC in Cadence ethernet controller driver.
>
>>
>
>> >>  	switch (state->interface) {
>
>> >
>
>> >> +	case PHY_INTERFACE_MODE_SGMII:
>
>> >
>
>> >> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
>
>> >
>
>> >> +			phylink_set(mask, 2500baseT_Full);
>
>> >
>
>> >
>
>> >
>
>> >This doesn't look correct to me.  SGMII as defined by Cisco only
>
>> >supports 1G, 100M and 10M speeds, not 2.5G.
>
>>
>
>> Cadence MAC support 2.5G SGMII by using higher clock frequency.
>
>
>
>Ok, so why not set 2.5GBASE-X too?  Does the MAC handle auto-detecting
>
>the SGMII/BASE-X speed itself or does it need to be programmed?  If it
>
>needs to be programmed, you need additional handling in the validate
>
>callback to deal with that.

No, currently MAC can't auto detect it, it need to be programmed.
But I think programming speed/duplex mode is already done for non in-band
modes in mac_config.
For in band mode, I see two places to config MAC speed
and duplex mode, 1. mac_link_state 2. mac_link_up. In mac_link_up, though s=
tate
read from mac_link_state is passed, it is only used for printing log and up=
dating
pl->cur_interface, so if configuring MAC speed/duplex mode in mac_link_up i=
s correct,=20
these parameters will need to read again from HW.

>> >> +	case PHY_INTERFACE_MODE_2500BASEX:
>
>> >
>
>> >> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
>
>> >
>
>> >> +			phylink_set(mask, 2500baseX_Full);
>
>> >
>
>> >> +	/* fallthrough */
>
>> >
>
>> >> +	case PHY_INTERFACE_MODE_1000BASEX:
>
>> >
>
>> >> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
>
>> >
>
>> >> +			phylink_set(mask, 1000baseX_Full);
>
>> >
>
>> >> +		break;
>
>> >
>
>> >
>
>> >
>
>> >Please see how other drivers which use phylink deal with the validate()
>
>> >format, and please read the phylink documentation:
>
>> >
>
>> > * Note that the PHY may be able to transform from one connection
>
>> > * technology to another, so, eg, don't clear 1000BaseX just
>
>> > * because the MAC is unable to BaseX mode. This is more about
>
>> > * clearing unsupported speeds and duplex settings.
>
>> >
>
>>
>
>> There are some configs used in this driver which limits MAC speed.
>
>> Above checks just to make sure this use case does not break.
>
>
>
>That's not what I'm saying.
>
>
>
>By way of example, you're offering 1000BASE-T just because the MAC
>
>connection supports it.  However, the MAC doesn't _actually_ support
>
>1000BASE-T, it supports a connection to a PHY that _happens_ to
>
>convert the MAC connection to 1000BASE-T.  It could equally well
>
>convert the MAC connection to 1000BASE-X.
>
>
>
>So, only setting 1000BASE-X when you have a PHY connection using
>
>1000BASE-X is fundamentally incorrect.
>
>
>
>For example, you could have a MAC <-> PHY link using standard 1.25Gbps
>=09
>SGMII, and the PHY offers 1000BASE-T _and_ 1000BASE-X connections on
>
>a first-link-up basis.  An example of a PHY that does this are the
>
>Marvell 1G PHYs (eg, 88E151x).
>
>
>
>This point is detailed in the PHYLINK documentation, which I quoted
>
>above.
Ok, I will not clear 1000/2500BASE-T for PHY connection is just 1000/2500BA=
SE-X
Also I will keep 1000/2500BASE-X link modes for SGMII/GMII modes.

>
>
>> >> @@ -506,18 +563,26 @@ static void gem_mac_config(struct phylink_confi=
g
>
>> >*pl_config, unsigned int mode,
>
>> >>  		switch (state->speed) {
>
>> >> +		case SPEED_2500:
>
>> >> +			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
>
>> >> +				   gem_readl(bp, NCFGR));
>
>> >>  		}
>
>> >> -		macb_or_gem_writel(bp, NCFGR, reg);
>
>> >>
>
>> >>  		bp->speed =3D state->speed;
>
>> >>  		bp->duplex =3D state->duplex;
>
>> >
>
>> >
>
>> >
>
>> >This is not going to work for 802.3z nor SGMII properly when in-band
>
>> >negotiation is used.  We don't know ahead of time what the speed and
>
>> >duplex will be.  Please see existing drivers for examples showing
>
>> >how mac_config() should be implemented (there's good reason why its
>
>> >laid out as it is in those drivers.)
>
>> >
>
>> Ok, Here I will configure MAC only for FIXED and PHY mode.
>
>
>
>As you are not the only one who has made this error, I'm considering
>
>splitting mac_config() into mac_config_fixed() and mac_config_inband()
>
>so that it's clearer what is required.  Maybe even taking separate
>
>structures so that it's impossible to access members that should not
>
>be used.
>
For in band mode, I see two places to config MAC speed
and duplex mode - 1. mac_link_state 2. mac_link_up.=20
In mac_link_up, though state read from mac_link_state is passed,=20
it is only used for printing log and updating pl->cur_interface,=20
so if configuring MAC speed/duplex mode in mac_link_up is correct,=20
these parameters will need to read again from HW.
>
>--
>
>RMK's Patch system: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
>3A__www.armlinux.org.uk_developer_patches_&d=3DDwIBAg&c=3DaUq983L2pue2F
>qKFoP6PGHMJQyoJ7kl3s3GZ-_haXqY&r=3DGTefrem3hiBCnsjCOqAuapQHRN8-
>rKC1FRbk0it-LDs&m=3DqYg0cUy9RXzvJcQIwLNjHCC8tbUg_-
>k2oqUIMDpStiA&s=3DxUkYplnpxrywxVfsk-J5c2Z6_K96ELTBkgC5g37OXTE&e=3D
>
>FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps=
 up
>
>According to speedtest.net: 11.9Mbps down 500kbps up

Regards,
Parshuram Thombare
