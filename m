Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2352C50282
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 08:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfFXGsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 02:48:01 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:41316 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726416AbfFXGsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 02:48:01 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5O6bIk6031683;
        Sun, 23 Jun 2019 23:47:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=2avDEnYKRK7mhfM7SsiMF04K3wliSvm5Ulug0rPG8Lo=;
 b=ealxeIkqndyEo4nINtBOLwfr8WLBS537LgX8riTqdk8ejN+6Bl5b/byFQNU1+zpMPQf/
 ybTCIQ/3Adf+DOU4u62S5SKWOUPchYCDsOclQ7lrnqhiE3Pd0GifJ6UIfuakMlFMPfd5
 t7Mug2Z0bM5yVdPk4iwp5i/bbvQdOt8OtN/qMc/27mqtNEJbxobNPOHfP0r3aJAdorj9
 hwb2wRKICwYzLFkIByo8gvFac2NgmBBmqspRuFAqPy7bh3VXKxQylmIpVNdt4dDraK4Y
 VLOHoJe402MuNJ+iprQNlafdNvHihQ7HyiX8oRCunQBOUc+nnxMZDrgdltjDBVJzvIZs /Q== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2059.outbound.protection.outlook.com [104.47.33.59])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvs60nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Jun 2019 23:47:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2avDEnYKRK7mhfM7SsiMF04K3wliSvm5Ulug0rPG8Lo=;
 b=ZOdUzn5xCHAXjl0zGL9aunpbGclwIrFrX0YjR7CkeX6FbK2g31ddq9fHsby0ZAt1ws6hT4KMrftkmXcnHQfmPOsZJr6MuLITKUoMR+u2v2Sm/3PvFVIE1ttEKiKyMsjUdkBv6mRYxiNnMhleMjWWN3zyeAkSAeDLVx18Wd6SaZ8=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2646.namprd07.prod.outlook.com (10.166.200.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 06:47:48 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Mon, 24 Jun 2019
 06:47:48 +0000
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
Thread-Index: AQHVKaVPGC45x6EWd0uJPVpf/aeuSqapBSQAgAFXn5A=
Date:   Mon, 24 Jun 2019 06:47:48 +0000
Message-ID: <CO2PR07MB24695E11E3931BE2E5664054C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281797-13796-1-git-send-email-pthombar@cadence.com>
 <20190623101252.olfxbls3phgxttcb@shell.armlinux.org.uk>
In-Reply-To: <20190623101252.olfxbls3phgxttcb@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1mODJiNGIzYy05NjRiLTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcZjgyYjRiM2UtOTY0Yi0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSI0MDciIHQ9IjEzMjA1ODMyNDY1MTk2MDg2MyIgaD0iaHc3ZmZrZzVXZ0RrQVRaS2RPT2x2NEx1dHpZPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ff51698-6cce-457e-8c15-08d6f86fdee6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2646;
x-ms-traffictypediagnostic: CO2PR07MB2646:
x-microsoft-antispam-prvs: <CO2PR07MB26465CA9410122B1A9F41BC2C1E00@CO2PR07MB2646.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(346002)(376002)(136003)(199004)(189003)(36092001)(66946007)(73956011)(76116006)(66556008)(64756008)(66476007)(66446008)(476003)(486006)(11346002)(4326008)(52536014)(33656002)(186003)(5660300002)(4744005)(2906002)(102836004)(256004)(55236004)(6506007)(76176011)(26005)(74316002)(478600001)(66066001)(446003)(25786009)(6436002)(9686003)(78486014)(8936002)(305945005)(7736002)(99286004)(86362001)(14454004)(7696005)(229853002)(53936002)(6246003)(68736007)(71200400001)(71190400001)(107886003)(6916009)(54906003)(3846002)(316002)(55016002)(81166006)(81156014)(8676002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2646;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B0o9CubzCS9rGeAaHiIeMOn24zIVG5g6UROdsut8S7UYcs7gVHtGI2hk0p7s7uIhDGJhbl/TNYwlIHdtKcgFGoHfb3P5cUcCpJe51FAQDui42KLCKISvzo+7aR1Qd020AwKZBOrTNmaW20ZKSJ/xNZ7eA5RR3zGgG3lopZv/oRRQtRToqukjrgezSSZR7jiRy2AGdL+tDXEenCRQ7syEEblj5RnLKc2526f6qOrzenjwoB8YtLOM9iudSuF7Ehh0cLGoFRewExWu8JDU1dzgujXwIKhdlXKqfB/WwQ938+YJwE6jFP3tCIpYpgRacwflhKDVH0R5iKESjG4KvwJn453aFR9RDqU6yZYFbJ8Jwq+v0zjpatC0+J3iYDxcI6vs+WAF07b/aZ9Al+T7aZupNC5uG7OCTrJQTyYa0JNUvf8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ff51698-6cce-457e-8c15-08d6f86fdee6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 06:47:48.2391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2646
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
 mlxlogscore=779 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240056
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Which Clause 45 PHY are you using?

I am using emulated PHY in our CSP environment.
This is using 10G generic PHY driver, with PHY having compatible =3D "ether=
net-phy-ieee802.3-c45"

Hi Andrew,
Can I add your "Reviewed-by" tag for this patch. You added it to this patch=
 in last series.

Regards,
Parshuram Thombare
