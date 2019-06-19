Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB754B6F9
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 13:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbfFSLXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 07:23:17 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:4948 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726826AbfFSLXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 07:23:16 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5JBJGfe008832;
        Wed, 19 Jun 2019 04:23:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=vFycM8YBU6oguC3IDt5lWy+WhVZtapspCBlOVL4Vk+M=;
 b=XundU8IPfE83BwWfxxMCspS2eSCUuA7PMu3eewUFBdE0WVlB71yXjIDBJnKHo4QMdaug
 1TouAkq4HyKaK9U47JUnp0l1drQDmHtlutDHuKyfk5x1X9v1/+P4NMfj8mOOmmvMeP0s
 Td7XAofbi0Tf3k/BsyNBiuHmEXsb/Nt33zihjkHmYI261gST7VS8ZW3iUsB36RpvxTHW
 4PTWaw2koDjf7y2jzL0E5nrkchEPXEUDoBljN9ulyz0vzK6nYKPGgezs4BuQjIhoZKb5
 E+6vJQUWBrzsISwfg1t6U9/ximaGEMQmuLd96wFfnPl4iUiUx1CrMyK5oQldOFJLD1CO 6w== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2057.outbound.protection.outlook.com [104.47.32.57])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t7805b2h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 04:23:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFycM8YBU6oguC3IDt5lWy+WhVZtapspCBlOVL4Vk+M=;
 b=DbANt5t58NZczC7RScKIzFhojkf6bjnIupvzW8+KgeSpNsZRVg+VYQIf5jKfsiszBtPvCGJCagMGP01VBVr6kogxUS3bNNVWIfd/54HT05pp3ZUnxhDdJtwQvjMsF5jchQUH1IntF1F5JcsMn230yZ8KMC1BGRusUTnb1yqFYpc=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2616.namprd07.prod.outlook.com (10.166.213.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Wed, 19 Jun 2019 11:23:01 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 11:23:01 +0000
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
Thread-Index: AQHVJnr0drBG2PH/rUy05pV+jK9MiqaitqoAgAAZ8dA=
Date:   Wed, 19 Jun 2019 11:23:01 +0000
Message-ID: <CO2PR07MB24695C706292A16D71322DB5C1E50@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
 <1560933646-29852-1-git-send-email-pthombar@cadence.com>
 <20190619093146.yajbeht7mizm4hmr@shell.armlinux.org.uk>
In-Reply-To: <20190619093146.yajbeht7mizm4hmr@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy05NjMzMDNhZi05Mjg0LTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcOTYzMzAzYjAtOTI4NC0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSI2MjU1IiB0PSIxMzIwNTQxNjk3NzUxOTQzODIiIGg9IkFrUmdYK0tmYkovN3hMSnQ1YWFEMi9FeFdUWT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8bcde7c1-78f9-4d8b-6b7e-08d6f4a87d40
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2616;
x-ms-traffictypediagnostic: CO2PR07MB2616:
x-microsoft-antispam-prvs: <CO2PR07MB261638907FC6F9970B6A0B32C1E50@CO2PR07MB2616.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(396003)(366004)(376002)(39860400002)(346002)(199004)(189003)(36092001)(76176011)(99286004)(486006)(256004)(305945005)(102836004)(476003)(6916009)(7696005)(11346002)(71190400001)(316002)(71200400001)(81166006)(6246003)(33656002)(14444005)(8676002)(5660300002)(14454004)(74316002)(446003)(508600001)(6116002)(78486014)(3846002)(25786009)(6506007)(229853002)(66556008)(66476007)(2906002)(9686003)(52536014)(53936002)(4326008)(76116006)(73956011)(81156014)(7736002)(66946007)(66446008)(6436002)(107886003)(64756008)(8936002)(54906003)(55016002)(186003)(26005)(86362001)(68736007)(66066001)(55236004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2616;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /f9HvLtg4KM78eHb0hhAfqtNG6P63pX6B+Eq/Kd6XqW5i+cJl+ZiTsknC6sC3A2AbJ5lkizrPd6gu7OXfqveIGET6TXE0wdJxNjnDwDdIeqVeRJyYNnWTU3UsZuH7agiH4hyeaMg0lseW8PLqG/HxltBYBTv6ydP5ikeeGzKMq5YZnrLzaQW8qsYqhSEYNATJsmfS4gfubVJIB3JQ9YJO3CWPS4esEpwrx/vXndKm1egQr1BdX1+ZQk2z5FVsMjCXWrSIu8bkCHR0T31Q1g7+mGOsqEtKzydToZrs7gJCwJLJ6U5wkpkiHm5pa2DQ7duR7bm5HbjghlttEvTe2mxDOPHC9GLzk4BuD/VfF+wBacberSKndW6HoJneGiV9IYmmToFIHuG0/VqAbcOdwcx+Dpt2vgaMgSETW0Hn0EMKpo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bcde7c1-78f9-4d8b-6b7e-08d6f4a87d40
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 11:23:01.1029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2616
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
>
>On Wed, Jun 19, 2019 at 09:40:46AM +0100, Parshuram Thombare wrote:
>
>> This patch add support for SGMII interface) and
>
>> 2.5Gbps MAC in Cadence ethernet controller driver.

>>  	switch (state->interface) {
>
>> +	case PHY_INTERFACE_MODE_SGMII:
>
>> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
>
>> +			phylink_set(mask, 2500baseT_Full);
>
>
>
>This doesn't look correct to me.  SGMII as defined by Cisco only
>supports 1G, 100M and 10M speeds, not 2.5G.

Cadence MAC support 2.5G SGMII by using higher clock frequency.
Even=20
>
>Even so, SGMII is not limited to just base-T - PHYs are free to offer
>base-X to SGMII conversion too.

Ok, I will make change to allow 1000BASE-X and 2500BASE-X
In SGMII mode.

>> +	case PHY_INTERFACE_MODE_2500BASEX:
>
>> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
>
>> +			phylink_set(mask, 2500baseX_Full);
>
>> +	/* fallthrough */
>
>> +	case PHY_INTERFACE_MODE_1000BASEX:
>
>> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
>
>> +			phylink_set(mask, 1000baseX_Full);
>
>> +		break;
>
>
>
>Please see how other drivers which use phylink deal with the validate()
>format, and please read the phylink documentation:
>
> * Note that the PHY may be able to transform from one connection
> * technology to another, so, eg, don't clear 1000BaseX just
> * because the MAC is unable to BaseX mode. This is more about
> * clearing unsupported speeds and duplex settings.
>

There are some configs used in this driver which limits MAC speed.
Above checks just to make sure this use case does not break.


>> +		state->duplex =3D MACB_BFEXT(DUPLEX, macb_readl(bp,
>NSR));
>> +		state->link =3D MACB_BFEXT(NSR_LINK, macb_readl(bp, NSR));
>> +	} else if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_2500BASEX) {
>> +		state->speed =3D SPEED_2500;
>> +		state->duplex =3D MACB_BFEXT(DUPLEX, macb_readl(bp,
>NSR));
>> +		state->link =3D MACB_BFEXT(NSR_LINK, macb_readl(bp, NSR));
>> +	} else if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_1000BASEX) {
>> +		state->speed =3D SPEED_1000;
>> +		state->duplex =3D MACB_BFEXT(DUPLEX, macb_readl(bp,
>NSR));
>> +		state->link =3D MACB_BFEXT(NSR_LINK, macb_readl(bp, NSR));
>> +	}
>
>
>
>So if the phy_interface type is not one listed, we leave state alone?
>That doesn't seem good.  It looks like you should at least simply set
>state->duplex and state->link according to the NSR register content,
>and always derive the speed.

Ok, I will make that change

>
>It would also be good to set state->lp_advertising if you have access
>to that so ethtool can report the link partner's abilities.  Current
>Marvell drivers that use phylink don't do that because that information
>is not available from the hardware.
>
Link partner ability information is available only for SGMII, I will add=20
change to populate state->lp_ advertising for SGMII.

>> +	if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII ||
>> +	    bp->phy_interface =3D=3D PHY_INTERFACE_MODE_1000BASEX ||
>> +	    bp->phy_interface =3D=3D PHY_INTERFACE_MODE_2500BASEX) {
>> +		gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
>> +			   GEM_BIT(PCS_CTRL_RESTART_AN));
>> +	}
>This will only be called for 802.3z link modes, so you don't need these
>checks.

Ok, I will remove these checks.

>> @@ -506,18 +563,26 @@ static void gem_mac_config(struct phylink_config
>*pl_config, unsigned int mode,
>>  		switch (state->speed) {
>> +		case SPEED_2500:
>> +			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
>> +				   gem_readl(bp, NCFGR));
>>  		}
>> -		macb_or_gem_writel(bp, NCFGR, reg);
>>
>>  		bp->speed =3D state->speed;
>>  		bp->duplex =3D state->duplex;
>
>
>
>This is not going to work for 802.3z nor SGMII properly when in-band
>negotiation is used.  We don't know ahead of time what the speed and
>duplex will be.  Please see existing drivers for examples showing
>how mac_config() should be implemented (there's good reason why its
>laid out as it is in those drivers.)
>
Ok, Here I will configure MAC only for FIXED and PHY mode.

>
>> @@ -555,6 +620,7 @@ static void gem_mac_link_down(struct
>phylink_config *pl_config,
>
>>  static const struct phylink_mac_ops gem_phylink_ops =3D {
>
>>  	.validate =3D gem_phylink_validate,
>
>>  	.mac_link_state =3D gem_phylink_mac_link_state,
>
>> +	.mac_an_restart =3D gem_mac_an_restart,
>
>>  	.mac_config =3D gem_mac_config,
>
>>  	.mac_link_up =3D gem_mac_link_up,
>
>>  	.mac_link_down =3D gem_mac_link_down,
>
>> @@ -2248,7 +2314,9 @@ static void macb_init_hw(struct macb *bp)
>
>>  	macb_set_hwaddr(bp);
>
>>
>
>>  	config =3D macb_mdc_clk_div(bp);
>
>> -	if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII)
>
>> +	if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII ||
>
>> +	    bp->phy_interface =3D=3D PHY_INTERFACE_MODE_1000BASEX ||
>
>> +	    bp->phy_interface =3D=3D PHY_INTERFACE_MODE_2500BASEX)
>
>>  		config |=3D GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
>
>
>
>Configuration of the phy interface mode should be done in mac_config()
>as previously mentioned, some PHYs can change their link mode at run
>time.  Hotplugging SFPs can change the link mode between SGMII and
>base-X too.
Ok

>> +	if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII ||
>
>> +	    bp->phy_interface =3D=3D PHY_INTERFACE_MODE_1000BASEX ||
>
>> +	    bp->phy_interface =3D=3D PHY_INTERFACE_MODE_2500BASEX) {
>
>> +		//Enable PCS AN
>
>> +		gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
>
>> +			   GEM_BIT(PCS_CTRL_EN_AN));
>
>> +		//Reset PCS block
>
>> +		gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
>
>> +			   GEM_BIT(PCS_CTRL_RST));
>
>> +	}
>
>> +
>
>
>
>Should be in mac_config.
>
Ok

>
>> -	if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII)
>
>> +	if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII ||
>
>> +	    bp->phy_interface =3D=3D PHY_INTERFACE_MODE_1000BASEX ||
>
>> +	    bp->phy_interface =3D=3D PHY_INTERFACE_MODE_2500BASEX)
>
>>  		val |=3D GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
>
>
>
>Should be in mac_config.
>
Ok

Regards,
Parshuram Thombare
