Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232D7986FA
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 00:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731056AbfHUWJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 18:09:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22964 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729121AbfHUWJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 18:09:27 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LM7Xc3018877;
        Wed, 21 Aug 2019 15:09:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=Osh/bHjjLw2nr3rh79U62Ku2VBxW5YvK8dbZMcmGHSA=;
 b=BfcmJk2MQrAmenFytCAMYS2B8ys0w9F7tQBHpqVYO1e2rGmfwz8HTqaKGCheFyQ6u9Rj
 99EQmyjzq6/QWMOowUq5JK6SD9RPlfXP3ZVY+EmJQ8f3hm7HtR2MVZXv4B3wppg63xbU
 xWIJ7tSvk0jveko9SipuPKygk6pfFnE4tns= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uh8ecsuyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Aug 2019 15:09:12 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 21 Aug 2019 15:09:11 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 21 Aug 2019 15:09:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvaYJOkun7Wtp9KscIeKBc0F5sFUy3QlH9GOZsP4TT5c3BgCfN1OqR3lj3lXvkmW6RuAXWyDZzi0OEl46+JHMvcw9DzCEbC8Um6tQAQ3yC4voi8ooC1wuX/ONuT3pkzUWK0pVAnXwSINlmGL5kATp47TkVC09AvlXftEbVcBwF3lo1Z7OQ19dim7vyT/V7vR8Pc1MUoINprC6H7oKKVWIUj2hCaYhanKeDd1jOgJKXVti6iltT60floEcwo4JOxi53OS7CHkaQcV7Op4DmyzfnVxhhj9Ol3yFQdjx93QTd2V6RkOFrTmP9tXAZ8aJCA54g1m0JnYJ36lOWEM/a20pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Osh/bHjjLw2nr3rh79U62Ku2VBxW5YvK8dbZMcmGHSA=;
 b=DUKGCulZN9HfCDZ8U77NWOKtiINByu1QzICh4g1168zMOxgkHxQlEqJz/NGgQUkxpnS/EvU1NLDk+95uSCXdMcpg7FfpfD+liMZSJkPiGJ8J23GZaRY8MJ587SUVfUyoay4KMeaepKHWuDDBWf6denPhNhqccwaS5HcrhVsqBZ4Ta5LPgwsPAu6UM9GwSIUMqNIAX5f+V2LcMeLTPrvRSF7z2Am4TMRcUB9CGOhcUbD1b0puBuNolomB5XEiN2AO0pQObVk5U9KhPXfDFsWVUJjpURZTyLDxo4bBVWsOyMStfzqoZNdkVrcHTuks/bb6bYcTP2xDC9r6heB8z8N00Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Osh/bHjjLw2nr3rh79U62Ku2VBxW5YvK8dbZMcmGHSA=;
 b=fqd735h35pTVzrubEVXbEJfuKZ1ctr94t74DA0lce7k5Dgk/+PDzcqD/A8nrjLbUuwfDa9od2YllFqWoBj+045BEx/uh7R2PrxXX46ng2+eFiGZw7b9ziEydS412IKcrQ/ZwKg8LyK7DuLwUurGn2pmeVLRWR9rYeOsQMxcx7ac=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3687.namprd15.prod.outlook.com (52.132.229.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 22:08:49 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c%5]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 22:08:49 +0000
From:   Ben Wei <benwei@fb.com>
To:     "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
CC:     Ben Wei <benwei@fb.com>
Subject: [PATCH net-next] net/ncsi: update response packet length for
 GCPS/GNS/GNPTS commands
Thread-Topic: [PATCH net-next] net/ncsi: update response packet length for
 GCPS/GNS/GNPTS commands
Thread-Index: AdVYbQEZzjCYid+VRb6aZg2XXHH58A==
Date:   Wed, 21 Aug 2019 22:08:49 +0000
Message-ID: <CH2PR15MB3686567EBCBE71B41C5F079AA3AA0@CH2PR15MB3686.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::3:ba86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06d70a9c-6e2b-41fe-0380-08d726842543
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3687;
x-ms-traffictypediagnostic: CH2PR15MB3687:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR15MB3687647B0CFAE04189E11E5FA3AA0@CH2PR15MB3687.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:580;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(376002)(136003)(396003)(366004)(199004)(189003)(305945005)(2501003)(14454004)(478600001)(6506007)(486006)(476003)(46003)(102836004)(99286004)(186003)(7696005)(8936002)(53936002)(81156014)(8676002)(81166006)(55016002)(52536014)(71190400001)(86362001)(71200400001)(25786009)(2201001)(4326008)(256004)(14444005)(6116002)(7736002)(15650500001)(2906002)(66946007)(76116006)(110136005)(66556008)(66446008)(316002)(6436002)(9686003)(66476007)(64756008)(74316002)(5660300002)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3687;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UINubnK1HEhcN4uPro3R7hZGvyqqWC7sVUiV7HnalO0wEFekiDx53KDtWtKi7cchGCfThDHSodzuHd8F1nMXQW9rMQbQJuf0bCbeSyKPJN0EeE8UaabdEKekoaK8Ku+CxXH783InUbrIWJnhh3ijIxjpUW+/3Z+J41n9upT1sbbjSeW5j2caaqwpp5yhj+8y1MRtUtaV+YZVWqCBw1p2d905wxXQTlApcHA61v0qL5NCXyEiSCkzWRrErmABkrvJW3AYPgRyKK/LAk9oXEnXL1WvAFm2WR/rks1W7H2K+ZSaw2xUyiR1hKGytGv33EnQMB3We4cvO6OsVEqx50AIbRKvz4oObLVi6hDffr/00YlBaTkWyfVrusjIUksxoR9jzTTFAZNlAYddf0uIqcKent3gUh0OggGMyNn+9S2PefY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d70a9c-6e2b-41fe-0380-08d726842543
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 22:08:49.8012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9j3MCyMU0r8s+dPUZ1/zlgBEyd5D9vuK970Vx7KNLRI+AnfsHu6NYkD+q1XAoFY0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3687
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=890 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210217
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update response packet length for the following commands per NC-SI spec
- Get Controller Packet Statistics
- Get NC-SI Statistics
- Get NC-SI Pass-through Statistics command

Signed-off-by: Ben Wei <benwei@fb.com>
---
 net/ncsi/ncsi-rsp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c index 7581bf919885..=
5254004f2b42 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1083,9 +1083,9 @@ static struct ncsi_rsp_handler {
 	{ NCSI_PKT_RSP_GVI,    40, ncsi_rsp_handler_gvi     },
 	{ NCSI_PKT_RSP_GC,     32, ncsi_rsp_handler_gc      },
 	{ NCSI_PKT_RSP_GP,     -1, ncsi_rsp_handler_gp      },
-	{ NCSI_PKT_RSP_GCPS,  172, ncsi_rsp_handler_gcps    },
-	{ NCSI_PKT_RSP_GNS,   172, ncsi_rsp_handler_gns     },
-	{ NCSI_PKT_RSP_GNPTS, 172, ncsi_rsp_handler_gnpts   },
+	{ NCSI_PKT_RSP_GCPS,  204, ncsi_rsp_handler_gcps    },
+	{ NCSI_PKT_RSP_GNS,    32, ncsi_rsp_handler_gns     },
+	{ NCSI_PKT_RSP_GNPTS,  48, ncsi_rsp_handler_gnpts   },
 	{ NCSI_PKT_RSP_GPS,     8, ncsi_rsp_handler_gps     },
 	{ NCSI_PKT_RSP_OEM,    -1, ncsi_rsp_handler_oem     },
 	{ NCSI_PKT_RSP_PLDM,    0, NULL                     },
--
2.17.1

