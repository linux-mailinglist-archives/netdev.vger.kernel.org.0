Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D25B2626
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 21:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388358AbfIMThR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 15:37:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27586 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388245AbfIMThQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 15:37:16 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DJYBeT003393;
        Fri, 13 Sep 2019 12:37:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=us1REin37ugd1NymlNtZICvJQDla4PW+cHLr1mBd6YQ=;
 b=Sc9oVHUP9UYwXFHrITvjlGZKHfPZCJWpVb7SWZqTahDvmZKBKAojYQCfKLCU0O3dN9zd
 WZJATSrzrJpt2XOE0m4TiE/P1TC1oMw5H6bf8JZC05sa2P9PrpDSrbmPUZJDB6uB8pCe
 w5/SMJ9acbjCRK683E0RDf8mtj8WvhmzBew= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uytd6nhy5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Sep 2019 12:37:11 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Sep 2019 12:36:54 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 12:36:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9dGvnUr//V/Zo2y7nDoGHmJWFXuUpL3nQgbv5gptdVrK15DtkBzTX2dBXYDfT+8ZUxGp0p/BvnG1ioSFbPZgoB00BDRxGgwXD4uNRK/v62SNzaejuVj2xIy5Y8ZFaWDXc3dkQvtFjyHlj82Gh7W3GDT4sLt2aC07CtvUrwZsLFQJ9fSi9r7zGFnATWJcD35+wvGOw17l3wr6ijgAtufjveG5h9h+kAbtpfnQy/Ki8R7E0yPASIdMwVV7gP7JlsfKt0W6W+EeoCdT61yADgE6+eiuzPnWoeE/77SJ4g5tY7Uu+U4igL6DsMJRctcusth5ewlAMRl7WpV9uX/6GP/dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us1REin37ugd1NymlNtZICvJQDla4PW+cHLr1mBd6YQ=;
 b=W9EU/21B3HfAf94lDQ9FWK+cUwT7bPHPVJU3guuLhThzinED6RZjv5gBFgAFIsEop74Zn/OVuFqybL8gEGVZI4luvJZff0mw+JK+r+wIbx435BUhpW0mAwwvcTVbnNv4yQ8XQwJsCnEqQ6OtKjiuIfhaxFVtZRoG1tU/Yjt5u8H9vgJxWZVqw00+zjUhszZWj4U+yH3gl1+rs7O8eeH/6n7XgV7OKk96gUngJrUsAerkrT4x6KiE1U81FhJoa31dj33y+VVP7kjYUic6iP1K26ZL+7RLETXgn5Drs8nzqNgBnBSaipgofUxUZrTojkeJX3M6Jwk972X5ZyjdGTwwHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us1REin37ugd1NymlNtZICvJQDla4PW+cHLr1mBd6YQ=;
 b=CiJzugsPwx8dG+LNfJZe5Gu28nm/vaiL7Aj537DBlNsX84QLTMX7LL74SrBSiDt0OE8PDeHxP/kieID3HbigNbQvMCs0EWz0H6Uun/8UjTd61rGPRR3yMPA9uTMVIF94Ol+lwF9s+CcZrhlhW+NMLCMHcQDlx/VFfU5us6qNgXQ=
Received: from CY4PR15MB1207.namprd15.prod.outlook.com (10.172.180.17) by
 CY4PR15MB1174.namprd15.prod.outlook.com (10.172.176.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Fri, 13 Sep 2019 19:36:39 +0000
Received: from CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3]) by CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3%6]) with mapi id 15.20.2241.025; Fri, 13 Sep 2019
 19:36:39 +0000
From:   Thomas Higdon <tph@fb.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jonathan Lemon <jonathan.lemon@gmail.com>, Dave Jones <dsj@fb.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Dave Taht" <dave.taht@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        "Soheil Hassas Yeganeh" <soheil@google.com>
Subject: [PATCH v4 1/2] tcp: Add TCP_INFO counter for packets received
 out-of-order
Thread-Topic: [PATCH v4 1/2] tcp: Add TCP_INFO counter for packets received
 out-of-order
Thread-Index: AQHVamqPQx8kMyn2fkOgETf9f87OhA==
Date:   Fri, 13 Sep 2019 19:36:38 +0000
Message-ID: <20190913193629.55201-1-tph@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR1801CA0010.namprd18.prod.outlook.com
 (2603:10b6:405:5f::23) To CY4PR15MB1207.namprd15.prod.outlook.com
 (2603:10b6:903:110::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.16.2
x-originating-ip: [163.114.130.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 742f7191-4e16-4bed-9404-08d73881b206
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1174;
x-ms-traffictypediagnostic: CY4PR15MB1174:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB11746864870E95EB6613B7EBDDB30@CY4PR15MB1174.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(346002)(376002)(366004)(199004)(189003)(71190400001)(7736002)(305945005)(66476007)(478600001)(6486002)(2616005)(4326008)(6436002)(25786009)(66946007)(2351001)(5640700003)(66446008)(66556008)(102836004)(86362001)(6512007)(53936002)(50226002)(2501003)(6916009)(71200400001)(6116002)(36756003)(186003)(64756008)(476003)(52116002)(14444005)(99286004)(486006)(54906003)(3846002)(256004)(1076003)(26005)(316002)(6506007)(1730700003)(8676002)(5660300002)(66066001)(8936002)(81156014)(81166006)(14454004)(2906002)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1174;H:CY4PR15MB1207.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Nw3eom3nXmyn9XNAg2z/aqj2625pXAUTAaJhOJ6L6UwaOPhFOEjM3UzuNJZpWkGvL7ILuKsS3rsKbVAfeMw13Rntkd98GvWz60qqnr2g4DV2TEUxmidCueMXyiTXgiU0ZD+YSEgOd1/JhFMDtOOGuehlxKf8xmeHIhQdtlBrDlvEQH2A6OSTrjAagnRVa+OPPrJyOA8Kp+aDTxvHTxpXzQgVSZmygBeHa3Pyo4xVqRBU3KC87EelSjgsiPUVVBvOBx9g7Q/JctPKPHciDXmFpqsCmWnFXWojrtC9I+hA+UhLfpkv+xsgSjPc2YiLG/iDFu4ecLAjk+n+Wg4t0v0xWZUQu15tRBb8ArXRfOxiGr+nCmlE9Nz+zxKMSNtZ0PdPzvDxo7O2my4KJFjSWeyCiVGrHWzfdMpKhUuQduui3Wk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 742f7191-4e16-4bed-9404-08d73881b206
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:36:38.7925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EacPm5x50tRpOwVWUYkdVcXA9CRgJKk/BHA7LuocHpD1gf0HSq55vjVuxpmQCCx8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1174
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_09:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=665 spamscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909130200
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For receive-heavy cases on the server-side, we want to track the
connection quality for individual client IPs. This counter, similar to
the existing system-wide TCPOFOQueue counter in /proc/net/netstat,
tracks out-of-order packet reception. By providing this counter in
TCP_INFO, it will allow understanding to what degree receive-heavy
sockets are experiencing out-of-order delivery and packet drops
indicating congestion.

Please note that this is similar to the counter in NetBSD TCP_INFO, and
has the same name.

Signed-off-by: Thomas Higdon <tph@fb.com>
---

no changes from v3

 include/linux/tcp.h      | 2 ++
 include/uapi/linux/tcp.h | 2 ++
 net/ipv4/tcp.c           | 2 ++
 net/ipv4/tcp_input.c     | 1 +
 4 files changed, 7 insertions(+)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index f3a85a7fb4b1..a01dc78218f1 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -393,6 +393,8 @@ struct tcp_sock {
 	 */
 	struct request_sock *fastopen_rsk;
 	u32	*saved_syn;
+
+	u32 rcv_ooopack; /* Received out-of-order packets, for tcpinfo */
 };
=20
 enum tsq_enum {
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index b3564f85a762..20237987ccc8 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -270,6 +270,8 @@ struct tcp_info {
 	__u64	tcpi_bytes_retrans;  /* RFC4898 tcpEStatsPerfOctetsRetrans */
 	__u32	tcpi_dsack_dups;     /* RFC4898 tcpEStatsStackDSACKDups */
 	__u32	tcpi_reord_seen;     /* reordering events seen */
+
+	__u32	tcpi_rcv_ooopack;    /* Out-of-order packets received */
 };
=20
 /* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 94df48bcecc2..4cf58208270e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2653,6 +2653,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->rx_opt.saw_tstamp =3D 0;
 	tp->rx_opt.dsack =3D 0;
 	tp->rx_opt.num_sacks =3D 0;
+	tp->rcv_ooopack =3D 0;
=20
=20
 	/* Clean up fastopen related fields */
@@ -3295,6 +3296,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *i=
nfo)
 	info->tcpi_bytes_retrans =3D tp->bytes_retrans;
 	info->tcpi_dsack_dups =3D tp->dsack_dups;
 	info->tcpi_reord_seen =3D tp->reord_seen;
+	info->tcpi_rcv_ooopack =3D tp->rcv_ooopack;
 	unlock_sock_fast(sk, slow);
 }
 EXPORT_SYMBOL_GPL(tcp_get_info);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 706cbb3b2986..2ef333354026 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4555,6 +4555,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struc=
t sk_buff *skb)
 	tp->pred_flags =3D 0;
 	inet_csk_schedule_ack(sk);
=20
+	tp->rcv_ooopack +=3D max_t(u16, 1, skb_shinfo(skb)->gso_segs);
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFOQUEUE);
 	seq =3D TCP_SKB_CB(skb)->seq;
 	end_seq =3D TCP_SKB_CB(skb)->end_seq;
--=20
2.17.1

