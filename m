Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0738F52716
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbfFYIts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:49:48 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:15318 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730761AbfFYItr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:49:47 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P8naGa007262;
        Tue, 25 Jun 2019 01:49:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=3FnkCdrwTPyKJrs5J3Y5+8mua+Sh8mAPFkf77Vo78Gk=;
 b=LNgGPyb0GBLFlQ3khd80bXf+UMh2We3u4uRq/L3IHAQKrQnjqPpakOEmiIA24pYwZ64Y
 5tbSNW2b826irPjLkjt2bJixPZ/Y92s3rCmwMxUr/LBH8gCIFpdUjmeZSwljjrbQbO0f
 ncAf4gkwyLLQfA5iKge5BMG4M5jcV11N+E0/x75fUd9mS8ae/FYfjsKSjt2ZxsusTr61
 QlpWInvZ3djYMZTqFS6vyGq2MNH4dPWMyaZU1jWblMfBfZTipB38/EQR1IlC4vQZcLzF
 9BsRXSkVNWW9F5ay3Vq6Cc2APv7OLujR5b7LUAHtEGsQGQrjkHN5nP1W6k4kxC3sr8vf ng== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2058.outbound.protection.outlook.com [104.47.33.58])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtvmfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 01:49:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FnkCdrwTPyKJrs5J3Y5+8mua+Sh8mAPFkf77Vo78Gk=;
 b=ePfW1TXgfKCn3Q2vQYRDBWu+YO1TLRRLLzVyB641A25zrHjojcoQ4dmaRfWrMd+55QEFzh+kgr7vaabV6tNHuxY5YhD0WF3rtxSQHn2PPUngbX4feuSkXbJ/okFeu48jle8EG3XAvqdxX0RGmwUqGOKbY23qSPg3c/K+INyK06g=
Received: from SN2PR07MB2480.namprd07.prod.outlook.com (10.166.212.14) by
 SN2PR07MB2589.namprd07.prod.outlook.com (10.167.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 08:49:33 +0000
Received: from SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba]) by SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba%10]) with mapi id 15.20.2008.014; Tue, 25 Jun
 2019 08:49:33 +0000
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
Subject: RE: [PATCH v5 4/5] net: macb: add support for high speed interface
Thread-Topic: [PATCH v5 4/5] net: macb: add support for high speed interface
Thread-Index: AQHVKoYfMA9Li9EuT0O4O+K54hF+RKaq0c2AgAE8gRA=
Date:   Tue, 25 Jun 2019 08:49:33 +0000
Message-ID: <SN2PR07MB2480CF15E11D54DA8C3B7319C1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
 <1561378355-14048-1-git-send-email-pthombar@cadence.com>
 <20190624134755.u3oq3xr6uergnfs5@shell.armlinux.org.uk>
In-Reply-To: <20190624134755.u3oq3xr6uergnfs5@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0yNGM1MWE1Zi05NzI2LTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcMjRjNTFhNjAtOTcyNi0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIxNjAwIiB0PSIxMzIwNTkyNjE3MDM1Mzk2NzgiIGg9ImcwZnptVFRWUnBhZ3krMEVGTEtSbk5tZTFpWT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 557fc6dd-8be7-4032-b482-08d6f94a0bba
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN2PR07MB2589;
x-ms-traffictypediagnostic: SN2PR07MB2589:
x-microsoft-antispam-prvs: <SN2PR07MB25893EEB37CB0DB9CCD6598AC1E30@SN2PR07MB2589.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(376002)(136003)(346002)(199004)(189003)(36092001)(78486014)(5660300002)(68736007)(6436002)(86362001)(53936002)(107886003)(55016002)(256004)(9686003)(476003)(486006)(6916009)(99286004)(2906002)(76176011)(66066001)(6246003)(229853002)(7696005)(55236004)(6506007)(14454004)(33656002)(14444005)(186003)(478600001)(71190400001)(25786009)(3846002)(6116002)(11346002)(4326008)(446003)(102836004)(66946007)(66476007)(64756008)(81156014)(316002)(66446008)(7736002)(52536014)(66556008)(26005)(8936002)(8676002)(81166006)(76116006)(54906003)(71200400001)(74316002)(73956011)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2589;H:SN2PR07MB2480.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lulfLygIznYNL2sZyTYMbC+7MZPw+x8B8FSz7zjpJVpmSdaJaC94qTD1mbfHhiVhHWHz59vxC0TTRCjKBgSHaCafhhFJIQrGCIGNfemiw6k1BArsDuDZ+GX7G6Mq8uP84jVPi+eLEefY/jBfVM4HMSvap6hT9ujuwRHwxbFP71M5DKES5TgyQnd70lb1T8qil9eVEFopF0mDNoQHDDT9ah5J43T269CDDYwrUOrqpEfzSA7kq5jWmUzewsRPzxHtfzHOJ4lJMGR9uL8AxsNTXzwNpMBKlrXcSeXqrslhsRQu0jM3F+7YiO8wPVRPHDKrt2SdlOYfmisHWgIQZZBtQQqYKqmLCFyexrcQkr777PTXRUIRnu44l0uqRYbARnexyHUMK4lqIqCbpR2cezrkB00G3weNcPnyGiDGjjIf2WU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 557fc6dd-8be7-4032-b482-08d6f94a0bba
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 08:49:33.8004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2589
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=895 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250071
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>  	switch (state->interface) {
>>  	case PHY_INTERFACE_MODE_NA:
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
>If MACB_CAPS_GIGABIT_MODE_AVAILABLE is not set, are these interface
>modes supported by the hardware?  If the PHY interface mode is not
>supported, then the returned support mask must be cleared.[]=20
There are some configs which uses this macro to limit data rate to 100M=20
even if hardware support higher rates.
Empty link mode mask is initialized at the beginning and supported link=20
modes are added to it and at the end of this function this mask is AND'ed=20
with supported mask.

>> +static inline void gem_mac_configure(struct macb *bp, int speed)
>> +{
>> +	if (bp->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII)
>> +		gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
>> +			   GEM_BIT(PCSSEL) |
>> +			   gem_readl(bp, NCFGR));
>Is this still necessary?
Sorry, missed this. I will remove in next patch set.

Regards,
Parshuram Thombare
