Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D490EB0593
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 00:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfIKWca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 18:32:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18364 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbfIKWc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 18:32:29 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8BMUPWJ021599;
        Wed, 11 Sep 2019 15:32:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ivSO9qNspP4q4SX6kCzKKmgOvsH2yFLdU/t8Oh3IKD8=;
 b=N+eV0mJqvyXgan3zT7U2C1UEQsWulW+coKUhl2VnaxnNq0e0ISqJHGpDPG3U5X33tInp
 VfZXyhs04chw1zqO9Z1iO32aHvVi9l1blEPts11XXTTbagNyxJKMeJtjVdQVe06oa6FG
 rbQX2gRaIsOkC7MhjYiD8jdaiCsAwLjypQs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uy6exs0r5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Sep 2019 15:32:25 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Sep 2019 15:31:53 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Sep 2019 15:31:53 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Sep 2019 15:31:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8wjom1PIAU5YPb4WJJFirZrjczLMPR/cSkjVbM6hiZIT1/fQyQXM8OyG/zgj7kdjRpoG9EUyENIufhtFd0BxACJA9OP0/4kLjA7uUN5TLdNRcoC9oIsS0pEJMu3+BXxn7jgVW6aK5sVmTRySY4/fJCDo5rKjJOVVovZJ6lED8GGKj4wfS1Mhoif9wuiDecy0hkqtipXo7dBob2cOLBQFm1d2RvW7efS26frEa29zW7AJ9YeIWoq2XicorqItbHaTr6sAxiRzfbGmLtRKYuYlnvp3B8KUcqqiUoF/wlXSrJDqn5teJDMkr1p3UNOz4gDZi/T/NF6s0E6itRPGgGUQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivSO9qNspP4q4SX6kCzKKmgOvsH2yFLdU/t8Oh3IKD8=;
 b=nklI8QplXCl1fFMgIFvssYA06Z/fNSroRA0/wRt79zH9QQNGzUnMua/9xa8XtJoYcPiZMk8R/viLeoIJYvM9TI9YAQmjRMlr1JHt7FTLIYk52+Ofb34TFS2WgtWpC/dKAdxqKWN6SjcGvIxNCTcqZ/QOvjT51wmZUvGFnR5z9ISBnbj0w4OCbHAkIFk94DOfvpBZNHHtesPadpGHqY85jKsCMvuJwZeXIrcyL2JV4ryMqHULWOgXJRXNDIj2jQjIpNJ3hDc8Sch7GlkoItD6MMSZCNnI3ZT9uwxbX+n/Woo3+ppYj7+WsVRBgj1L1l3Tn91hPyn5jmkaXtYdn+FFdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivSO9qNspP4q4SX6kCzKKmgOvsH2yFLdU/t8Oh3IKD8=;
 b=LCjA1d4gAvQ5hSdw4/9zL7oouLlzsQru7Oma1PE0SmxM5vpjjxdGRYdh0sHYwjjgfYv4EPSzBWL9BWgssK6MP22PqkSw1v1scf7u+DE0LRKU5m+WMcDeDczN3FwizojGjkqXZjiAR6TDD8hacvAifGdplMgsTS6xCI0czIsXYRg=
Received: from CY4PR15MB1207.namprd15.prod.outlook.com (10.172.180.17) by
 CY4PR15MB1655.namprd15.prod.outlook.com (10.175.119.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 22:31:52 +0000
Received: from CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3]) by CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3%6]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 22:31:52 +0000
From:   Thomas Higdon <tph@fb.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jonathan Lemon <jonathan.lemon@gmail.com>, Dave Jones <dsj@fb.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v3 2/2] tcp: Add rcv_wnd to TCP_INFO
Thread-Topic: [PATCH v3 2/2] tcp: Add rcv_wnd to TCP_INFO
Thread-Index: AQHVaPC1u+0FA2Nc1EGWGQFEck7I8w==
Date:   Wed, 11 Sep 2019 22:31:52 +0000
Message-ID: <20190911223148.89808-2-tph@fb.com>
References: <20190911223148.89808-1-tph@fb.com>
In-Reply-To: <20190911223148.89808-1-tph@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR10CA0036.namprd10.prod.outlook.com
 (2603:10b6:208:120::49) To CY4PR15MB1207.namprd15.prod.outlook.com
 (2603:10b6:903:110::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.16.2
x-originating-ip: [163.114.130.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7c65f7c-f42c-4c64-5c56-08d73707d79b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1655;
x-ms-traffictypediagnostic: CY4PR15MB1655:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1655F786E7FBA50BBB09F306DDB10@CY4PR15MB1655.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(346002)(396003)(366004)(189003)(199004)(66556008)(14454004)(476003)(50226002)(66476007)(53936002)(8676002)(3846002)(8936002)(6916009)(66066001)(6116002)(2906002)(99286004)(86362001)(4326008)(316002)(256004)(25786009)(5660300002)(2501003)(478600001)(14444005)(36756003)(81156014)(102836004)(52116002)(6506007)(386003)(54906003)(26005)(71200400001)(6486002)(71190400001)(11346002)(446003)(7736002)(186003)(66946007)(6512007)(76176011)(81166006)(66446008)(64756008)(305945005)(5640700003)(1076003)(6436002)(2351001)(2616005)(486006)(1730700003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1655;H:CY4PR15MB1207.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K58sujIhEkbBodVJkO1KWvxzBZ53Sh4mPlEwXv45fuX1uqCYHu+H6NMlz0PSLA7LONqBKFZCc5XA9Ij/vomfVRP5wjQKlSx7n8SwjYLKgncdopuSLksL9fqi68sArNZ1VeZg4+9jl0Bm/AR8QT57fltvRbgv6oMPZUM6Q6ek7LRrPk9oJPE6b2XijudYUQ7O98AGMBFszXVi/YRdr9atvi7Gld4sAOgf3ul6Dw2Rskczyjg4UjjhCvixE/ixbM5gHqIeaTrpyJvwhpnYgebGa8sUHWdgaZ4pnjcbb22PcLWo4z2xMeLLU1OLEZwmYOx2ewjpeo/6BjQUidV9nbbe+0FVi1dKK5KDUBTq26JNg+wIxgdVoe7Mct5OT3GSxlVVE9QzLeW3haq+izhuCbBZnN6J6tya4f0WCXa6buT8vww=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c65f7c-f42c-4c64-5c56-08d73707d79b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 22:31:52.2514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zKSwU6o9v3OTZBbXe9w7v6+D9WbFaaKjf7AnVk1OTi5y5LtQ5lDRjlffNnXyi4GS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1655
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-11_10:2019-09-11,2019-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 mlxlogscore=737 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909110200
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neal Cardwell mentioned that rcv_wnd would be useful for helping
diagnose whether a flow is receive-window-limited at a given instant.

This serves the purpose of adding an additional __u32 to avoid the
would-be hole caused by the addition of the tcpi_rcvi_ooopack field.

Signed-off-by: Thomas Higdon <tph@fb.com>
---
 include/uapi/linux/tcp.h | 1 +
 net/ipv4/tcp.c           | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 20237987ccc8..8a0d1d1af622 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -272,6 +272,7 @@ struct tcp_info {
 	__u32	tcpi_reord_seen;     /* reordering events seen */
=20
 	__u32	tcpi_rcv_ooopack;    /* Out-of-order packets received */
+	__u32	tcpi_rcv_wnd;        /* Receive window size */
 };
=20
 /* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4cf58208270e..c980145c4247 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3297,6 +3297,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *i=
nfo)
 	info->tcpi_dsack_dups =3D tp->dsack_dups;
 	info->tcpi_reord_seen =3D tp->reord_seen;
 	info->tcpi_rcv_ooopack =3D tp->rcv_ooopack;
+	info->tcpi_rcv_wnd =3D tp->rcv_wnd;
 	unlock_sock_fast(sk, slow);
 }
 EXPORT_SYMBOL_GPL(tcp_get_info);
--=20
2.17.1

