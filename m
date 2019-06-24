Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0A45021D
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 08:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfFXGU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 02:20:26 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:20896 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726351AbfFXGUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 02:20:25 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5O6IebC019638;
        Sun, 23 Jun 2019 23:20:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=z3ILgSACcvAXJI3EvRsZLbRSZTtFOdIrxCAjErwZB7g=;
 b=SYnMEoOxSHBMbtAufTM/oeKKRR0wcI0Kyq64uLlW+uY4vi6cte4MRVgJochmhfIWEVGQ
 XWnpKLt72myxc2h8vMWkAMAVXdCRhRj/62GyQeqfLZXFyd2lziVkLTlfNMrOjuchq+zf
 OV7tOYNiwqCHm8JhsLHBq27Wii2+YIUZGmCZ34Acp4XRq0Q0p5M54KV6DQMO+EA/e2Pu
 y3P1PpOtA9ePjMDYPP7RRhj1al3J1yg3DBMONWj+MkSQK8vGRPIZ5BIa3rahXiOCMiG5
 jLCsvzsHMa9DsuL14bz73BOSccRVShSqsitth/ZjCX1sMwOfBk3fQWS5CmjmrlkNdG0o Dg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2057.outbound.protection.outlook.com [104.47.36.57])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtpe39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Jun 2019 23:20:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3ILgSACcvAXJI3EvRsZLbRSZTtFOdIrxCAjErwZB7g=;
 b=VdYSDDmRePHniwnh5n9/Xaio5JdclZWNbIgCeWaTqJ21dMMoim44skh/VINrZlDtz5n/08IlfJpPB8RANDN6P3u+TKnFtmdeJcRmAJxQ27qM3erBJ59iUS4XYouGGJ06sWeVAyE5VJiU96vd5jzYnGCNUTb/IT2q2yFLLyRyjkg=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2712.namprd07.prod.outlook.com (10.166.214.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Mon, 24 Jun 2019 06:20:08 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Mon, 24 Jun 2019
 06:20:08 +0000
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
Subject: RE: [PATCH v4 1/5] net: macb: add phylink support
Thread-Topic: [PATCH v4 1/5] net: macb: add phylink support
Thread-Index: AQHVKaSN3qrqEsWli063GBHHwWl8xKapA+YAgAFSgZA=
Date:   Mon, 24 Jun 2019 06:20:08 +0000
Message-ID: <CO2PR07MB246976240B2635F4E9C027A5C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281457-6886-1-git-send-email-pthombar@cadence.com>
 <20190623100824.3xlmkofiqebdf4sa@shell.armlinux.org.uk>
In-Reply-To: <20190623100824.3xlmkofiqebdf4sa@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0xYTExZTM5OS05NjQ4LTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcMWExMWUzOWItOTY0OC0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSIxMDEyIiB0PSIxMzIwNTgzMDgwNDEwMTE2NTMiIGg9ImZkUVhoT1lKR2JyRGdDMDJrbGxiSTBvZGpwWT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90edc05b-e7bc-4465-dd89-08d6f86c0165
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2712;
x-ms-traffictypediagnostic: CO2PR07MB2712:
x-microsoft-antispam-prvs: <CO2PR07MB27128A8FB15B45B9ECBA7F9AC1E00@CO2PR07MB2712.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(366004)(346002)(376002)(36092001)(199004)(189003)(316002)(55016002)(73956011)(81166006)(7736002)(68736007)(3846002)(476003)(8676002)(11346002)(186003)(86362001)(76176011)(66066001)(14444005)(102836004)(9686003)(76116006)(54906003)(71200400001)(478600001)(55236004)(71190400001)(6506007)(229853002)(6436002)(99286004)(2906002)(5660300002)(26005)(53936002)(6246003)(81156014)(64756008)(446003)(7696005)(8936002)(4326008)(33656002)(14454004)(66556008)(78486014)(74316002)(305945005)(107886003)(52536014)(66946007)(256004)(6116002)(66476007)(6916009)(25786009)(486006)(66446008)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2712;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qONOKQpcRIq8m7Y+GLM1GJ1eiKXouR8gy5gdgg/gECVAoK+YjnQOnk2t7T1RmeRDsAYVn6yORtDXeaYcrIB8YNGyz+pMVAhN1qL0Ju3QOMbX11Ax9ukIqt4mOY/6d+/w786skQn3pRSIvk+xRYhvNx67EAB6QeqCT3oep90T0qe0vpSCd64iCJFWhuaBtTeY1MQlynYZZZrHoI9J9oEAeqVSEGlvJGNAwXiBbJvYQZ5rIBUIsiKbTIg5KBzm5bHBBGG3TECfhaUOZdicebnndkFL7uGb1UQBHaEVlk8a6P7dpW+4oW11XKRfsKkylt7SOQMfftR/l4UvxKGWUcA0OIGZHSRUT1DyhCEtD0DdGQtPAxgoEbJ77SVyS4RTl0X/sbwfim3auPgQjvxTIsW49Opy2vAq8FP7xhy00LumHVg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90edc05b-e7bc-4465-dd89-08d6f86c0165
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 06:20:08.1141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2712
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
 mlxlogscore=822 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240053
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
>On Sun, Jun 23, 2019 at 10:17:37AM +0100, Parshuram Thombare wrote:
>> +	switch (state->interface) {
>> +	case PHY_INTERFACE_MODE_GMII:
>> +	case PHY_INTERFACE_MODE_RGMII:
>> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
>> +			phylink_set(mask, 1000baseT_Full);
>> +			phylink_set(mask, 1000baseX_Full);
>> +			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF)) {
>> +				phylink_set(mask, 1000baseT_Half);
>> +				phylink_set(mask, 1000baseT_Half);
>I think this can be cleaned up.
Ok, I will remove duplicate 1000baseT_Half

>> -	spin_lock_irqsave(&bp->lock, flags);
>> +	linkmode_and(supported, supported, mask);
>> +	linkmode_and(state->advertising, state->advertising, mask);
>You remove this blank line in the next patch, so given that this is a
>new function, you might as well clean that up in this patch.
Ok
Regards,
Parshuram Thombare
