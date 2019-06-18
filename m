Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664BF4A9A5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbfFRSSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:18:48 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:58194 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727616AbfFRSSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:18:48 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5II4VVp012908;
        Tue, 18 Jun 2019 11:18:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=RzrCS1OwqoNqrmvKiuHnh0Dhh+gbECiwl0Wsc74rUho=;
 b=BfCnxGFHnnW1/CuLEeUKZZtARFdwylgCpuNCsAeejisFSGvwNxLNWPy9dOfg2xLlCE2f
 TT5N6fcmTk90lrwIrTAgRI8IfyV134jKmvBRjWHLPUgufksR/Jd6gu9YPOgCkF93LynS
 nLO4T7kWW+S/0OHOtp1iPs+2L/Xddt8QoISGuafJmPCghnUT9AfcSzigZRWZNvKMGrkD
 vKbih/dIcN/ztvWIu82u/OP0+DU8shZqRSRO6sNMDrdwRsW9FjSV8BMJQdryLLDuctm5
 UyDzLLGcWnux5Cp9s0qkbRQ+64N5qOtlpTFNmqkHVHwqiOkG4KvRBOo9AaH64bb9P79l pA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2054.outbound.protection.outlook.com [104.47.50.54])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8wd96h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 11:18:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzrCS1OwqoNqrmvKiuHnh0Dhh+gbECiwl0Wsc74rUho=;
 b=cuGUiR0/Ms+vh1avldQb73O6csMrKNq4S3bXMNfSxP5ynhTS3kSjxW4SA+OODi36EBi6hZh3PoACfJJZGb56B0N5LSuN8RkVhdmJLX4SpY610pJPqSIcDrahQItRfoxkbODhGngennIpH/uwi4YhHpb/VWUMXR4N30XoXYk8owQ=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2694.namprd07.prod.outlook.com (10.166.94.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 18 Jun 2019 18:18:39 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 18:18:39 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH 5/6] net: macb: add support for high speed interface
Thread-Topic: [PATCH 5/6] net: macb: add support for high speed interface
Thread-Index: AQHVI9Tcs6+lUTl1w0O0SmweHVE36Kaf+HCAgAHDnxA=
Date:   Tue, 18 Jun 2019 18:18:39 +0000
Message-ID: <CO2PR07MB24690446678E7040DEC3FB2DC1EA0@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560642481-28297-1-git-send-email-pthombar@cadence.com>
 <1560642512-28765-1-git-send-email-pthombar@cadence.com>
 <20190617151927.GI25211@lunn.ch>
In-Reply-To: <20190617151927.GI25211@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy03YjVkODUwNi05MWY1LTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcN2I1ZDg1MDgtOTFmNS0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSIzNTk0IiB0PSIxMzIwNTM1NTUxNDQ2MDk0NzAiIGg9IldyZXFaM0N2ZGlSb3hvcC9XaFR0cTVoU0xyWT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [59.145.174.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5d0a154-42b8-4246-a174-08d6f419630a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2694;
x-ms-traffictypediagnostic: CO2PR07MB2694:
x-microsoft-antispam-prvs: <CO2PR07MB2694D08A5F79EA0484C22F46C1EA0@CO2PR07MB2694.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(136003)(346002)(376002)(36092001)(189003)(199004)(66556008)(186003)(14444005)(6436002)(66476007)(6916009)(86362001)(66946007)(76116006)(4326008)(53936002)(66446008)(5660300002)(107886003)(68736007)(73956011)(64756008)(66066001)(99286004)(3846002)(478600001)(6506007)(2906002)(76176011)(7696005)(14454004)(6246003)(26005)(446003)(305945005)(6116002)(476003)(9686003)(11346002)(102836004)(256004)(52536014)(229853002)(7736002)(55016002)(81166006)(81156014)(8676002)(486006)(33656002)(8936002)(74316002)(316002)(71200400001)(71190400001)(54906003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2694;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5T4otxUIj7u8p8lsKT+lhCNtapBGhy47AaG+i1+ygzYeiPLbpsfT52NZwQQ6WOIti6/f+nnni6A/E4pbPWyims/LKCAHeHw03CeybJT3YjWqnALBv/Qeb6KkK4DvM9NfHpeyragpBmoViC+fo0Utn2ihOULRYS5Qdu1N2/tqQh/5/Dp2SXY5/O2AZs2eAkqSfBDlCYwOYhG5en4vOjoUpeR7B6W8J77ngCZanH5VW6KUsEm+BjxzaVbHQbnt0Skl9kASboRb7o+V4D+gTQ7nHenVz86STUnTdpjVyUFcJ7/n/SyX7G2RPG9kbAMmYTjQMyzZwy0AfyeIaVrAFjUW8E15tyDw3Dw4/RkHNHDf/wwYKQGbJ9sPwOHAepxCQyoUOffcCMkbLdQRBznfPC8f6dnNsd+3jBQwpMTSpUJDChI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d0a154-42b8-4246-a174-08d6f419630a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 18:18:39.1653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2694
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
>>  	switch (state->interface) {
>> +	case PHY_INTERFACE_MODE_NA:
>
>I would not list PHY_INTERFACE_MODE_NA here.
>
This was to experiment in band mode with sfp.=20
phylink_sfp_module_insert call phylink_validate with interface set to PHY_I=
NTERFACE_MODE_NA
, if it is not listed in validate method supported bitmask will be empty. =
=20
But anyway since I am configuring fixed mode, removing this case.

>> +	case PHY_INTERFACE_MODE_USXGMII:
>> +	case PHY_INTERFACE_MODE_10GKR:
>> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
>> +			phylink_set(mask, 10000baseCR_Full);
>> +			phylink_set(mask, 10000baseER_Full);
>> +			phylink_set(mask, 10000baseKR_Full);
>> +			phylink_set(mask, 10000baseLR_Full);
>> +			phylink_set(mask, 10000baseLRM_Full);
>> +			phylink_set(mask, 10000baseSR_Full);
>> +			phylink_set(mask, 10000baseT_Full);
>> +			phylink_set(mask, 5000baseT_Full);
>> +			phylink_set(mask, 2500baseX_Full);
>> +			phylink_set(mask, 1000baseX_Full);
>> +		}
>> +		/* Fall-through */
>>  	case PHY_INTERFACE_MODE_SGMII:
>>  		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
>>  			phylink_set(mask, 2500baseT_Full); @@ -594,17 +639,55
>@@ static
>> void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
>>  			reg |=3D MACB_BIT(FD);
>>  		macb_or_gem_writel(bp, NCFGR, reg);
>>
>> -		if (state->speed =3D=3D SPEED_2500) {
>> -			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
>> -				   gem_readl(bp, NCFGR));
>> -			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
>> -				   gem_readl(bp, NCR));
>> -		} else if (state->speed =3D=3D SPEED_1000) {
>> -			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
>> -				   gem_readl(bp, NCFGR));
>> -		} else if (state->speed =3D=3D SPEED_100) {
>> -			macb_writel(bp, NCFGR, MACB_BIT(SPD) |
>> -				    macb_readl(bp, NCFGR));
>> +		if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_USXGMII) {
>> +			u32 speed;
>> +
>> +			switch (state->speed) {
>> +			case SPEED_10000:
>> +				if (bp->serdes_rate =3D=3D
>> +				    MACB_SERDES_RATE_10_PT_3125Gbps) {
>> +					speed =3D HS_MAC_SPEED_10000M;
>> +				} else {
>> +					netdev_warn(netdev,
>> +						    "10G not supported by HW");
>> +					netdev_warn(netdev, "Setting speed to
>1G");
>> +					speed =3D HS_MAC_SPEED_1000M;
>> +				}
>> +				break;
>> +			case SPEED_5000:
>> +				speed =3D HS_MAC_SPEED_5000M;
>> +				break;
>> +			case SPEED_2500:
>> +				speed =3D HS_MAC_SPEED_2500M;
>> +				break;
>> +			case SPEED_1000:
>> +				speed =3D HS_MAC_SPEED_1000M;
>> +				break;
>> +			default:
>> +			case SPEED_100:
>> +				speed =3D HS_MAC_SPEED_100M;
>> +				break;
>> +			}
>> +
>> +			gem_writel(bp, HS_MAC_CONFIG,
>> +				   GEM_BFINS(HS_MAC_SPEED, speed,
>> +					     gem_readl(bp, HS_MAC_CONFIG)));
>> +			gem_writel(bp, USX_CONTROL,
>> +				   GEM_BFINS(USX_CTRL_SPEED, speed,
>> +					     gem_readl(bp, USX_CONTROL)));
>> +		} else {
>> +			if (state->speed =3D=3D SPEED_2500) {
>> +				gem_writel(bp, NCFGR, GEM_BIT(GBE) |
>> +					   gem_readl(bp, NCFGR));
>> +				gem_writel(bp, NCR,
>GEM_BIT(TWO_PT_FIVE_GIG) |
>> +					   gem_readl(bp, NCR));
>> +			} else if (state->speed =3D=3D SPEED_1000) {
>> +				gem_writel(bp, NCFGR, GEM_BIT(GBE) |
>> +					   gem_readl(bp, NCFGR));
>> +			} else if (state->speed =3D=3D SPEED_100) {
>> +				macb_writel(bp, NCFGR, MACB_BIT(SPD) |
>> +					    macb_readl(bp, NCFGR));
>> +			}
>
>Maybe split this up into two helper functions?
Ok=20
>
>      Andrew


Regards,
Parshuram Thombare
