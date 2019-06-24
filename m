Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A445026E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 08:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfFXGgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 02:36:02 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:14072 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbfFXGgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 02:36:02 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5O6VkTL026986;
        Sun, 23 Jun 2019 23:35:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=AQ4H9uaYGF71LOGrIlYzKFZuvlHnBiu6MVo+x8icqo0=;
 b=j0cww7/4SwwbLLaWI0bllPkR3uNBmkRAR/p7dRliC64X/ebVbrvkPujDSif6BOmm87jE
 912TYtCR+IEbHi8GN7QQB1f+fsaCn6+wE/UpMZnlRifOeWfCbbxeg4ytU3oWdOi25TWZ
 R/1h6jOG8rpoh6cuA9SHEq+gfamUhKb1y7Ri3+UvtxCrSUYZ8aNtIU7FeFBYRbyaVw3r
 lHcfA3IMoX8rT/ySfXg2dxvZUvm0/WKo/01Tp4b0V80CXVgmIP1oTZi267/Nss5njBl9
 CyX7fw8vtbbYx/5yBmDXCOCCl3g+HJOZ2iGuF33JW0E0Kkr8P/3/a0tNVHD4EzVElZmX tA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2053.outbound.protection.outlook.com [104.47.45.53])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvs5y80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Jun 2019 23:35:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQ4H9uaYGF71LOGrIlYzKFZuvlHnBiu6MVo+x8icqo0=;
 b=sLB2g8s5wPr6af0zRiNdYQmmueF+vREqJvj7JiNA8BbW1TGfTi7KGPQPZIJwPhCsLPzbVu8CyUFcGoXYY6eAgLrgYgNGdGbaSuaCaReahl2Qv22P3bSkQk+m2Qm6KfXG5HcZAGsy5cfCuMkTM9tWLy+CyiQe5ejO6Pbo6LAvDKc=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2726.namprd07.prod.outlook.com (10.166.201.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Mon, 24 Jun 2019 06:35:44 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Mon, 24 Jun 2019
 06:35:44 +0000
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
Subject: RE: [PATCH v4 2/5] net: macb: add support for sgmii MAC-PHY interface
Thread-Topic: [PATCH v4 2/5] net: macb: add support for sgmii MAC-PHY
 interface
Thread-Index: AQHVKaVHMt019Pka20mPugoFl8ah06apBQMAgAFRdiA=
Date:   Mon, 24 Jun 2019 06:35:44 +0000
Message-ID: <CO2PR07MB246931C79F736F39D0523D3BC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281781-13479-1-git-send-email-pthombar@cadence.com>
 <20190623101224.nzwodgfo6vvv65cx@shell.armlinux.org.uk>
In-Reply-To: <20190623101224.nzwodgfo6vvv65cx@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy00OGU1MmYyYi05NjRhLTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcNDhlNTJmMmMtOTY0YS0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSIyNTU5IiB0PSIxMzIwNTgzMTc0MTY2NjEwMzIiIGg9InQya3BnV1kwbm83UlJ3dG41LzNsZEthQ2JuUT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f81ee8c-8a8d-46dc-b55a-08d6f86e2f5f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2726;
x-ms-traffictypediagnostic: CO2PR07MB2726:
x-microsoft-antispam-prvs: <CO2PR07MB2726A11418566BC2DEB49603C1E00@CO2PR07MB2726.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39860400002)(376002)(396003)(346002)(36092001)(189003)(199004)(66556008)(11346002)(76176011)(478600001)(76116006)(305945005)(3846002)(71200400001)(33656002)(6436002)(66946007)(2906002)(8676002)(55016002)(74316002)(25786009)(229853002)(4326008)(66476007)(53936002)(68736007)(81156014)(99286004)(52536014)(316002)(73956011)(6116002)(71190400001)(8936002)(6506007)(6246003)(86362001)(107886003)(9686003)(66446008)(64756008)(6916009)(81166006)(78486014)(486006)(7696005)(66066001)(5660300002)(14454004)(54906003)(186003)(7736002)(256004)(476003)(26005)(446003)(102836004)(55236004);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2726;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zKA8Hespm6ospKv5SOkGP9AEUfHfNPhgiX3a819xkoWggG3hHtIHzaJeqnFwq+yzvQWF8fV8YuLLD7UgWziZIaIVjlJ3aORDuJ5DuIxXwugE3K1bamcrJl4nd2YWEg4DyN70XaDTWQlITy62eN1SaVnE/JQ95F0HDoJML7hlAZ90a+q6LhOUgtrx6xYrWbwNwfLMAd8KpsWEik5sGUX6fq0+DE5AuEFBHN2jzx9eJQh24dALy+HmKIeBmhYkieN32A4R4YYo7wpDF4m2IAh2VY2XxL3yKKxkwuPRjYt0FmXDFFoz8BmUwVmaGqfGhzzrq+iSyOD81qw5qOp63iPatww++l8k7b+VZGo3xZxslC0bNeakEAsaKYh/oIsz1qQtuEp3kwJV218/h+B/7gOlt/KorE35iR7O80+goxi5GTA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f81ee8c-8a8d-46dc-b55a-08d6f86e2f5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 06:35:44.2144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2726
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> +	if (change_interface) {
>> +		if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII) {
>> +			gem_writel(bp, NCFGR, ~GEM_BIT(SGMIIEN) &
>> +				   ~GEM_BIT(PCSSEL) &
>> +				   gem_readl(bp, NCFGR));
>> +			gem_writel(bp, NCR, ~GEM_BIT(TWO_PT_FIVE_GIG) &
>> +				   gem_readl(bp, NCR));
>> +			gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
>> +				   GEM_BIT(PCS_CTRL_RST));
>> +		}
>I still don't think this makes much sense, splitting the interface
>configuration between here and below.
Do you mean splitting mac_config in two *_configure functions ?
This was done as per Andrew's suggestion to make code mode readable
and easy to manage by splitting MAC configuration for different interfaces.

>> +		bp->phy_interface =3D state->interface;
>> +	}
>> +
>>  	if (!phylink_autoneg_inband(mode) &&
>>  	    (bp->speed !=3D state->speed ||
>> -	     bp->duplex !=3D state->duplex)) {
>> +	     bp->duplex !=3D state->duplex ||
>> +	     change_interface)) {
>>  		u32 reg;
>>
>>  		reg =3D macb_readl(bp, NCFGR);
>>  		reg &=3D ~(MACB_BIT(SPD) | MACB_BIT(FD));
>>  		if (macb_is_gem(bp))
>>  			reg &=3D ~GEM_BIT(GBE);
>> +		macb_or_gem_writel(bp, NCFGR, reg);
>> +
>> +		if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII)
>> +			gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
>> +				   GEM_BIT(PCSSEL) |
>> +				   gem_readl(bp, NCFGR));
>This will only be executed when we are not using inband mode, which
>basically means it's not possible to switch to SGMII in-band mode.
SGMII is used in default PHY mode. And above code is to program MAC to=20
select PCS and SGMII interface.

>> +
>> +		if (!interface_supported) {
>> +			netdev_err(dev, "Phy mode %s not supported",
>> +				   phy_modes(phy_mode));
>> +			goto err_out_free_netdev;
>> +		}
>> +
>>  		bp->phy_interface =3D phy_mode;
>> +	} else {
>> +		bp->phy_interface =3D phy_mode;
>> +	}
>If bp->phy_interface is PHY_INTERFACE_MODE_SGMII here, and mac_config()
>is called with state->interface =3D PHY_INTERFACE_MODE_SGMII, then
>mac_config() won't configure the MAC for the interface type - is that
>intentional?
In mac_config configure MAC for non in-band mode, there is also check for s=
peed, duplex
changes. bp->speed and bp->duplex are initialized to SPEED_UNKNOWN and DUPL=
EX_UNKNOWN
values so it is expected that for non in band mode state contains valid spe=
ed and duplex mode
which are different from *_UNKNOWN values.

Regards,
Parshuram Thombare
