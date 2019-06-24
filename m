Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183B65089C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbfFXKTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:19:15 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:45346 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729400AbfFXKTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:19:15 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OAIdkY007722;
        Mon, 24 Jun 2019 03:19:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=g8/H8c55eFuiumdincuibm2IYtX75b4d0bKGDijdr+s=;
 b=t41nle2iNN7shIpGe1j6I2IHipSYh8tcWEbMey3b8zSslH6hmP71FAzak4fD82TgeGAv
 0JF0FSgCFgW0viKw/LSjcTXpfN79MNyZuHc8QmJpLMf5ENliDj/BoamQRlrpMpUxJmlq
 BSJDY0BJRIdrpGP9hPVlP+Qty5NQDyK4U8WHQAEfWwO6bs17MID90fSpRvQWc7afa2Ui
 loR75PPX8pD9GDTmnxNhEze1qQmJXGI4pF9PDooEjr/9j9YyTO4OcjPXSovI9EXivava
 2pGmscipqQV0KUTDvNkADKTSH5Tm6xIwJ6e+uAQoitAU1mW9q9mmak9r2u1BI7ZBfqZ3 DA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2053.outbound.protection.outlook.com [104.47.46.53])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtqeq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 03:19:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8/H8c55eFuiumdincuibm2IYtX75b4d0bKGDijdr+s=;
 b=Rtzmv2W6Kki10fpmmZhPh1R8e7AdzFVPN7ba6PPDH0xaypn94CIpwa4XyQ9nm6+AUnowW+9Z5/dCrCdd3hOCBVe4yyNrGpsIWo6DBFE3LYSfmMt28yvbLuujquQrTRHy1SiXnWI27SPidvIhS2zttg9RWbN72Gk8GPI3fCeJpJ0=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2520.namprd07.prod.outlook.com (10.166.95.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 10:19:03 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Mon, 24 Jun 2019
 10:19:03 +0000
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
Subject: RE: [PATCH v4 3/5] net: macb: add support for c45 PHY
Thread-Topic: [PATCH v4 3/5] net: macb: add support for c45 PHY
Thread-Index: AQHVKaVPGC45x6EWd0uJPVpf/aeuSqapBSQAgAFXn5CAADI9gIAACRZw
Date:   Mon, 24 Jun 2019 10:19:03 +0000
Message-ID: <CO2PR07MB2469305C663FE90BC75E0AAFC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281797-13796-1-git-send-email-pthombar@cadence.com>
 <20190623101252.olfxbls3phgxttcb@shell.armlinux.org.uk>
 <CO2PR07MB24695E11E3931BE2E5664054C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
 <20190624094233.3xick3snqbcm55gu@shell.armlinux.org.uk>
In-Reply-To: <20190624094233.3xick3snqbcm55gu@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy03YjIzZTk5Ni05NjY5LTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcN2IyM2U5OTgtOTY2OS0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSI0MzkiIHQ9IjEzMjA1ODQ1MTQwMzM2MzkzNyIgaD0iNWFEUUtha3p5dU13RnlwZERZN2VsL1VvVFZjPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9259f529-51e1-4806-1038-08d6f88d61f7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2520;
x-ms-traffictypediagnostic: CO2PR07MB2520:
x-microsoft-antispam-prvs: <CO2PR07MB2520A55CC8A830BCAF29C69DC1E00@CO2PR07MB2520.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39860400002)(136003)(396003)(346002)(199004)(189003)(36092001)(26005)(7736002)(81156014)(81166006)(7696005)(99286004)(8936002)(55236004)(256004)(33656002)(305945005)(76176011)(6506007)(186003)(6116002)(74316002)(486006)(73956011)(6916009)(446003)(11346002)(3846002)(229853002)(476003)(6436002)(66066001)(478600001)(5660300002)(52536014)(55016002)(102836004)(8676002)(53936002)(71200400001)(71190400001)(4326008)(6246003)(78486014)(54906003)(25786009)(76116006)(2906002)(66556008)(9686003)(86362001)(4744005)(66446008)(64756008)(66476007)(14454004)(66946007)(68736007)(107886003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2520;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UUeQQCMWqcgmH170a5v/R9u3q+A8ICI3oG5UPfv+yJrNRKBW5aCut/RUXL6xMgBKjrcsNYh2fwa0PI380qiIEsdDCJYP+oFh78h8ck7ShyYBva+EGLRMCAhcRpkjSzUnkshC0wJDFN77WtJSFW5ngKcQp7z2kz5tXh62693bvIqF9PaDdX1gCFGX8wreIHcX455+g2VhD0Oa24g9vA0SjyTDAdf0JLCIsjn0uFZsemtfOHsGSBjeHHBb8911Bp1K2CVmAiYWx7bVaFt0rmpi/Sm21DSYqneK3sJb2hiyuW5z1pJT3f48urCfw4L/4WvGhLjTV0cfSfneWsmp2DRYLpLQy8Bot8FOAR3Lf9tI1hp87SmSGatTqprFoa18RgUWbGXlK7tcmRV49/3C1A3kCji8F2TaMREzTVkC+TlN5pw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9259f529-51e1-4806-1038-08d6f88d61f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 10:19:03.5571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2520
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=677 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>However, it seems from that comment that you're not talking about real
>hardware.  Is there no real hardware out there supporting 10G mode with
>these proposed driver changes yet?
I think there are some 10GBaseT PHY out there, but I don't have any test
setup with those. This patch is tested on emulation test setup.=20

Regards,
Parshuram Thombare
