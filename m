Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E96052732
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731092AbfFYIzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:55:25 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:49234 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730860AbfFYIzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:55:25 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P8s4ac011120;
        Tue, 25 Jun 2019 01:55:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=QlYrbG/weV6tBLLOS7GPZBlSPBPX/zabKkyrfcLvcHc=;
 b=KzNymttpVUeSoQoxx9OaF+hLnN16nDAFbToEHigO9pg4PygtlDUkrbvjHPi5Jle0EVe5
 AUIwbfPLGRR2xMx+qp9MU1SZBevcKmVeryar0u7uAZ3/9cwInGyK6X6b+dlKBEBMrpii
 CDzpImqVetUTmbcvIKmng5Jj2ZA1XsTqhg3odclLoUYRVpvdkDTd6X/IjxuwossGxth6
 IjpExk7bIfG9cWnvf4wjsdto4qvj/i+CG0y4GAljE1gQtof+NUggUalDHtGvr/mWLD5C
 T/6xaav4VM86aUVzudN2e92nhZi8jU+dqShrjt8T3saEwJRM8Po+8IfNSgYwbv5GLer4 hQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2053.outbound.protection.outlook.com [104.47.33.53])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtvn61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 01:55:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlYrbG/weV6tBLLOS7GPZBlSPBPX/zabKkyrfcLvcHc=;
 b=ZcTmlbTw9i/UvfSbFES86J7tLaNVbKsYory458dDaLJka3weLYbRLVdXREcWuN8AD71vCLkirCHFORId1FyO3796pJ+Bk3MsH5ecPinsYaZqPK6WRMKzPI8jf7watNlgujwc9kOBIeebzps9S5aNfIoHPGamCC2vOsFfdgqrndg=
Received: from SN2PR07MB2480.namprd07.prod.outlook.com (10.166.212.14) by
 SN2PR07MB2589.namprd07.prod.outlook.com (10.167.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 08:55:14 +0000
Received: from SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba]) by SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba%10]) with mapi id 15.20.2008.014; Tue, 25 Jun
 2019 08:55:14 +0000
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
Thread-Index: AQHVKoYfMA9Li9EuT0O4O+K54hF+RKaq0c2AgAE/qaA=
Date:   Tue, 25 Jun 2019 08:55:14 +0000
Message-ID: <SN2PR07MB248006F5B8955EB7311B7DCEC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
 <1561378355-14048-1-git-send-email-pthombar@cadence.com>
 <20190624134755.u3oq3xr6uergnfs5@shell.armlinux.org.uk>
In-Reply-To: <20190624134755.u3oq3xr6uergnfs5@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1lZmUwNGIwNS05NzI2LTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcZWZlMDRiMDctOTcyNi0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSI4NDAiIHQ9IjEzMjA1OTI2NTExMDczNzMxOSIgaD0ibG53VnhlUng2YVlxcHZzY21iQ21pMVh5bnlvPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd41adc5-74b3-4d53-8b0e-08d6f94ad6be
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN2PR07MB2589;
x-ms-traffictypediagnostic: SN2PR07MB2589:
x-microsoft-antispam-prvs: <SN2PR07MB25892D8241EB2C4E3A91FB2EC1E30@SN2PR07MB2589.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(39860400002)(396003)(366004)(376002)(36092001)(189003)(199004)(446003)(4326008)(102836004)(66946007)(25786009)(478600001)(186003)(71190400001)(11346002)(3846002)(6116002)(76116006)(54906003)(8936002)(26005)(81166006)(8676002)(4744005)(71200400001)(74316002)(305945005)(73956011)(52536014)(7736002)(66556008)(66446008)(66476007)(64756008)(316002)(81156014)(476003)(9686003)(486006)(68736007)(5660300002)(78486014)(6436002)(55016002)(256004)(86362001)(107886003)(53936002)(6506007)(55236004)(14454004)(33656002)(66066001)(2906002)(99286004)(6916009)(76176011)(7696005)(229853002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2589;H:SN2PR07MB2480.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eOldQrmoQQBm85awMqCfaJyp4pGyHngzDbvcXbGLTVnk/1RqBLQUJBknvEh0qIbXAZegdTgz3oPYPW3ZJuUVQyVizl1ED3mna/GWGgMPHQPokgluoY6uGzqwt5OipNNZEu7jRGLRwc9SYPyahPp78Xh6hELaxTg8S08KfzWLTtZfu16DqluTMmZqLQ/1GL9WriQoxXdlJ0vBKCVDzVBTnOmcnkF4M5i1QahehT5Fu6y8nohn2Prj/lPDEi1YVm8lxXO/FfAHJ99D/fI8bPynHXWGUMvuUrDyjutuwVihsAnB44O2IbGupF+tzVO1OKFdEyJgReG1om8ieTzmVf/9yz7mRZFhpMN5yoYPefIcMLoFSXU9Eh5DyTMRAJk+WCCvWu0lsJl3nwiixR1ETN1qR4eRGeZL/I7avaBxOYIjzZc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd41adc5-74b3-4d53-8b0e-08d6f94ad6be
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 08:55:14.3710
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
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +static inline void gem_mac_configure(struct macb *bp, int speed)
>> +	switch (speed) {
>> +	case SPEED_1000:
>> +		gem_writel(bp, NCFGR, GEM_BIT(GBE) |
>> +			   gem_readl(bp, NCFGR));
>> +		break;
>> +	case SPEED_100:
>> +		macb_writel(bp, NCFGR, MACB_BIT(SPD) |
>> +			    macb_readl(bp, NCFGR));
>What happens to the NCFGR register if we call mac_config() first for
>a 1G speed, then 100M and finally 10M - what value does the NCFGR
>register end up with?
>
>I suspect it ends up with both the GBE and SPD bits set, and that is
>probably not what you want.

No, In gem_mac_config GBE and SPD bits are always cleared
before setting appropriate bits as per requested speed, duplex mode.


Regards,
Parshuram Thombare
