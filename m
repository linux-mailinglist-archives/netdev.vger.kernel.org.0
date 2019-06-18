Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7629B49C22
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 10:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfFRIhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 04:37:25 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:37406 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729208AbfFRIhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 04:37:20 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5I8TG55029724;
        Tue, 18 Jun 2019 01:37:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=xsJK1veAyact+tOtxqOT3AXuOrU8Gz22Iw7I0SueNUY=;
 b=HM+GTwFleSGLHr/ZdE5YQM1StMBty3YrSImW/83uz2eVpFdNt5xjARWW5NtsjkTy5Dao
 fVT5nC0j8yKfW1Jfd9TTYRNuWnEKRyiFX64UDIW8EuIEAJKEGHzYnlAF96G0Z12P1t1b
 mGK/t7M2TboQNNTx8iO7hpjyR1+SILgww6vwFrdlhMBpK0Ddypv95Rr6lbK07N0y/YoH
 urZxO99HvNG776Q3zgIqs0Jb9lv1wTfwvKaPZeQT3hmJ8TT51/DWo1N+2iJ1HA+RDmIk
 xx+bJIVNDuYGTyxbU6sRkukBi/+T8w9npjSGb12UuhUT25yo8kN9uy0m7CudAGvgMTSJ Fw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2050.outbound.protection.outlook.com [104.47.49.50])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8wb337-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 01:37:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsJK1veAyact+tOtxqOT3AXuOrU8Gz22Iw7I0SueNUY=;
 b=XcePlsSAWuonokP/J7P82bxY7b5eENX1FI57P5RFWFfGflHjiIjwhQqFfCy7LPofMFvHHqlTES3qx+kfJTL7ekqtwtI9cIi7r1tjqIXX7asCC4JMfE9TeDrhQvgV0OTWAtkm8zIEC0CKKaPIvmYShUJpKHjfhueBn/1Zu/0Gz+4=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2695.namprd07.prod.outlook.com (10.166.94.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Tue, 18 Jun 2019 08:37:06 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 08:37:06 +0000
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
Subject: RE: [PATCH 2/6] net: macb: add support for sgmii MAC-PHY interface
Thread-Topic: [PATCH 2/6] net: macb: add support for sgmii MAC-PHY interface
Thread-Index: AQHVI9SfpVQt7BW65k+gCU7i2ymGM6af83+AgAEl0tA=
Date:   Tue, 18 Jun 2019 08:37:05 +0000
Message-ID: <CO2PR07MB2469F4019870B9F7B49F46C9C1EA0@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560642367-26425-1-git-send-email-pthombar@cadence.com>
 <1560642409-27074-1-git-send-email-pthombar@cadence.com>
 <20190617150145.GF25211@lunn.ch>
In-Reply-To: <20190617150145.GF25211@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0zZGEyNzA1NC05MWE0LTExZTktODRmNy0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcM2RhMjcwNTYtOTFhNC0xMWU5LTg0ZjctMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSI0MTc1IiB0PSIxMzIwNTMyMDYyMTY0NjUwODMiIGg9IitYKzlka2JYMnZqNzFZb2lDaUhyTGpGOVA0RT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b267479-87d3-4f55-7251-08d6f3c82532
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2695;
x-ms-traffictypediagnostic: CO2PR07MB2695:
x-microsoft-antispam-prvs: <CO2PR07MB2695636D7CA96DA081E23361C1EA0@CO2PR07MB2695.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(39850400004)(346002)(376002)(36092001)(189003)(199004)(78486014)(229853002)(86362001)(74316002)(33656002)(26005)(54906003)(486006)(66476007)(66946007)(64756008)(66556008)(68736007)(66066001)(76116006)(25786009)(476003)(7736002)(81166006)(4326008)(81156014)(107886003)(305945005)(52536014)(6246003)(446003)(11346002)(256004)(73956011)(66446008)(76176011)(53936002)(14454004)(102836004)(316002)(55236004)(9686003)(7696005)(8676002)(5660300002)(186003)(8936002)(71200400001)(55016002)(2906002)(6916009)(6506007)(6436002)(99286004)(71190400001)(6116002)(3846002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2695;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I6byrzikAI9hdilrHeJ6S1cLgc4Nzt2BdxYTKd8cTnP3Yc8F0UmLy3cxmRZWvq32zE7tIMCRg9UeZMXazIckvmHQSkb2RcMcAVvsSySWKObbyoMq8kHELoitm8NrQ+mVt8fWJuuIuziLWZz6G5BdC3kiOvy6/jBER+xuNY9Ka7n17cC6Qv+neOvMnf00Q/vYRaQpdBl79ozGKfpp145IjpCGwvQI6L5esnt6x5a8VHZvBWsMbER/GzdgX3eLI5eT4084WB/KjWM1o+q6wXp0u6aHmVX4P5FYgXGx8uPnX34AU2sLV9hocdfAdaAAim2DIAkmXsgyhRmOdH8hfh/AHdl0sUqn5J9bujiasES795Y4EUW1fKlUV+DRvlabnTJYEKlie3qSpKWA5AMgphkGHCpHcKSuyDBd2Eh1ZAg6p6I=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b267479-87d3-4f55-7251-08d6f3c82532
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 08:37:06.1174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2695
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180071
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> @@ -159,6 +160,9 @@
>>  #define GEM_PEFTN		0x01f4 /* PTP Peer Event Frame Tx Ns */
>>  #define GEM_PEFRSL		0x01f8 /* PTP Peer Event Frame Rx Sec Low */
>>  #define GEM_PEFRN		0x01fc /* PTP Peer Event Frame Rx Ns */
>> +#define GEM_PCS_CTRL		0x0200 /* PCS Control */
>> +#define GEM_PCS_STATUS          0x0204 /* PCS Status */
>> +#define GEM_PCS_AN_LP_BASE      0x0214 /* PCS AN LP BASE*/
>
>It looks like there are some space vs tab issues here and else where.
Ok, I will fix space vs tab issue.
>
>>  static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
>>  				      struct phylink_link_state *state)  {
>> +	u32 status;
>>  	struct net_device *netdev =3D to_net_dev(pl_config->dev);
>>  	struct macb *bp =3D netdev_priv(netdev);
>
>Reverse christmas tree please, here and everywhere you add new variables.
>
Yes, sure. I will make take change.
>>
>> -	state->speed =3D bp->speed;
>> -	state->duplex =3D bp->duplex;
>> -	state->link =3D bp->link;
>> +	if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII) {
>> +		status =3D gem_readl(bp, PCS_STATUS);
>> +		state->an_complete =3D GEM_BFEXT(PCS_STATUS_AN_DONE,
>status);
>> +		status =3D gem_readl(bp, PCS_AN_LP_BASE);
>> +		switch (GEM_BFEXT(PCS_AN_LP_BASE_SPEED, status)) {
>> +		case 0:
>> +			state->speed =3D 10;
>> +			break;
>> +		case 1:
>> +			state->speed =3D 100;
>> +			break;
>> +		case 2:
>> +			state->speed =3D 1000;
>> +			break;
>> +		default:
>> +			break;
>
>It would be nice to use SPEED_10, SPEED_100, etc.
>
Yes, sure. I will make take change.
>> @@ -494,17 +551,23 @@ static void gem_mac_config(struct phylink_config
>*pl_config, unsigned int mode,
>>  		reg &=3D ~(MACB_BIT(SPD) | MACB_BIT(FD));
>>  		if (macb_is_gem(bp))
>>  			reg &=3D ~GEM_BIT(GBE);
>> -
>>  		if (state->duplex)
>>  			reg |=3D MACB_BIT(FD);
>> -		if (state->speed =3D=3D SPEED_100)
>> -			reg |=3D MACB_BIT(SPD);
>> -		if (state->speed =3D=3D SPEED_1000 &&
>> -		    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
>> -			reg |=3D GEM_BIT(GBE);
>> -
>>  		macb_or_gem_writel(bp, NCFGR, reg);
>>
>> +		if (state->speed =3D=3D SPEED_2500) {
>> +			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
>> +				   gem_readl(bp, NCFGR));
>> +			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
>> +				   gem_readl(bp, NCR));
>> +		} else if (state->speed =3D=3D SPEED_1000) {
>> +			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
>> +				   gem_readl(bp, NCFGR));
>> +		} else if (state->speed =3D=3D SPEED_100) {
>> +			macb_writel(bp, NCFGR, MACB_BIT(SPD) |
>> +				    macb_readl(bp, NCFGR));
>> +		}
>
>Maybe a switch statement?
>
This suggested to be part of helper function in other patch.
I will add switch in helper inline function replacement of this code.

>> @@ -4232,11 +4327,37 @@ static int macb_probe(struct platform_device
>*pdev)
>>  	}
>>
>>  	err =3D of_get_phy_mode(np);
>
>The following code would be more readable if you replaced err with phy_mod=
e,
>or interface.
>
Ok, sure.
>> -	if (err < 0)
>> +	if (err < 0) {
>>  		/* not found in DT, MII by default */
>>  		bp->phy_interface =3D PHY_INTERFACE_MODE_MII;
>> -	else
>> +	} else if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL) {
>> +		u32 interface_supported =3D 1;
>> +
>> +		if (err =3D=3D PHY_INTERFACE_MODE_SGMII ||
>> +		    err =3D=3D PHY_INTERFACE_MODE_1000BASEX ||
>> +		    err =3D=3D PHY_INTERFACE_MODE_2500BASEX) {
>> +			if (!(bp->caps & MACB_CAPS_PCS))
>> +				interface_supported =3D 0;
>> +		} else if (err =3D=3D PHY_INTERFACE_MODE_GMII ||
>> +			   err =3D=3D PHY_INTERFACE_MODE_RGMII) {
>> +			if (!macb_is_gem(bp))
>> +				interface_supported =3D 0;
>> +		} else if (err !=3D PHY_INTERFACE_MODE_RMII &&
>> +			   err !=3D PHY_INTERFACE_MODE_MII) {
>> +			/* Add new mode before this */
>> +			interface_supported =3D 0;
>> +		}
>> +
>> +		if (!interface_supported) {
>> +			netdev_err(dev, "Phy mode %s not supported",
>> +				   phy_modes(err));
>> +			goto err_out_free_netdev;
>> +		}
>> +
>>  		bp->phy_interface =3D err;
>> +	} else {
>> +		bp->phy_interface =3D err;
>> +	}
>
>  Andrew

Regards,
Parshuram Thombare
