Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3CFB0590
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 00:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfIKWb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 18:31:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60044 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726525AbfIKWb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 18:31:57 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8BMS6ab015655;
        Wed, 11 Sep 2019 15:31:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=TVluisnjJzEAAhPaEqVfoac5tObJFWCpqCnfiQ5twGI=;
 b=PfgnTRdCXgdtgcDQIA1HIr7Jhk2UjZ/lm83uEaKQ6jk3NAsj7Ig4yrZfux7lM4PZh0Rq
 MIPMf8FO1kvKBE/Jhg3S2TabmBuE9zNTGDqk2wXqOLhfSHB3oKX21SLCEK8u6YWqvPzg
 VYbSkNzdHgFNYBfZ5/yUjKTxMQ2EJYVvZs0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uxnub5886-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Sep 2019 15:31:53 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Sep 2019 15:31:52 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Sep 2019 15:31:51 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Sep 2019 15:31:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvU4gOc9PDkYibMmkK6lf2CRzPAXo7FMH0IJNaf7Ot8uigc7H4rXstbGL3w/qtpfjHHiCIEOr9CSeMtIdMHozSV8Be5q4TGlREW+ITMHsvFDp4Aj9kiHxFreoFUsv9cUM0tr0lArf+rHTk7C9I8O4pzJWQnChIpTvyx9vBVCBTzKx5t0F0JJRdpN7k9fz5+zbsg1A5ESyVTJUSyNz85Zd9TTW/BBl/PU/DIkqWQH8QTIeF9bLlHV2tTvON9BSEdD6LmqBJhKwbvZvTSZBBFWBoio+wkcVX16r/eFHNi3sAGLVF576Zi0XL2ANniPqEio+QafRWjFPIGLqW9FwUexww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVluisnjJzEAAhPaEqVfoac5tObJFWCpqCnfiQ5twGI=;
 b=Qm2kGa9KQ1mYGgv3WXPx83R/vwOl/I07H0c4qFDFjckErZmKBDGrMDkeBLRsKhqK8sKhSyhe+cmAoe0+qXAPQlfGJhU4KDJ2B1aVS9046BKD0DxBaRYPzZ8vyM1rAgQGZP7y83gnn+odDBxZbuX/WLrcbTJhv8JlAVJbG8NSQmhK0MakSagW5264VDId+NadX9Km0gOKXnZXLJWsdxM7yo3a9flB9c2LQ1XZ3MZthJXOF8jY9136Q2zIEkNy32v5+YfLsIYibiMSFNbYBbJjX84TT16boVPpif9Jnex0pQhmCL1RiJSct6ZM4vji4oydJf0tMEVHry7/6ViFz1phrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVluisnjJzEAAhPaEqVfoac5tObJFWCpqCnfiQ5twGI=;
 b=CxymmElSUxYbs2QUNTFtrrHawIK2wlCQlMhTY+sJVL+TRsFdSjJBxlRFj9btUEJH9EiH9QcHIOM6Tx1wWCqq9QR6HqXf/p03LjpGkw91F/zD+XeMnKLPT1Qa1DZOT7TUHKg2UlKsQghss/sjGXEBkVQ2IXwIYAbEObgMbEh0+zA=
Received: from CY4PR15MB1207.namprd15.prod.outlook.com (10.172.180.17) by
 CY4PR15MB1655.namprd15.prod.outlook.com (10.175.119.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 22:31:51 +0000
Received: from CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3]) by CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3%6]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 22:31:51 +0000
From:   Thomas Higdon <tph@fb.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jonathan Lemon <jonathan.lemon@gmail.com>, Dave Jones <dsj@fb.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v3 1/2] tcp: Add TCP_INFO counter for packets received
 out-of-order
Thread-Topic: [PATCH v3 1/2] tcp: Add TCP_INFO counter for packets received
 out-of-order
Thread-Index: AQHVaPC0TVChvVjQ0kqs4Qesz9ukFg==
Date:   Wed, 11 Sep 2019 22:31:50 +0000
Message-ID: <20190911223148.89808-1-tph@fb.com>
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
x-ms-office365-filtering-correlation-id: 052a8df5-0e39-43cc-5dc3-08d73707d6fb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1655;
x-ms-traffictypediagnostic: CY4PR15MB1655:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB165577E319E8B9204B645841DDB10@CY4PR15MB1655.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(346002)(396003)(366004)(189003)(199004)(66556008)(14454004)(476003)(50226002)(66476007)(53936002)(8676002)(3846002)(8936002)(6916009)(66066001)(6116002)(2906002)(99286004)(86362001)(4326008)(316002)(256004)(25786009)(5660300002)(2501003)(478600001)(14444005)(36756003)(81156014)(102836004)(52116002)(6506007)(386003)(54906003)(26005)(71200400001)(6486002)(71190400001)(7736002)(186003)(66946007)(6512007)(81166006)(66446008)(64756008)(305945005)(5640700003)(1076003)(6436002)(2351001)(2616005)(486006)(1730700003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1655;H:CY4PR15MB1207.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: M0tYVKy9jaDgGDYxrdwgjMSxLEeOU3pc/cMuJcLO1+6SNwjWGyjMPXmswVXNBzudXbDZO226Ljoz7FhoCPEDSiKjMrsJWsHPU5gzAM7P2GvLOe9bWrn38fWIsr1UMfRgRRyXqf0YPGMTMdb5rVteoQRcXEFlvDwkgD9ncxOPY7X4JwUmqt7gan8CEYrX0fHHKz1cfXqxjdOWv3Q9iwZr2CWnxkcuxixjKaShwxjY4GttZapF1TrsoQh9Qs47PLiXqlGwuKwpofGZV1WyscLVVHDMNOtMM/6kVjMXWf+Wkkhn1Lq+vcQ/s0KkwhaB7Lu+4dmWIo3YdtzDzb4RhAzcHGl3IOuCiw1PzXo+kRaeXQrXtrsewTkzSgEWOYQxMnlWvcGeTCy7Ot+j8oFIRyyo6zZZjgAg9R/TBCmgyeGZvIs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 052a8df5-0e39-43cc-5dc3-08d73707d6fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 22:31:51.0409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5OdioIaFyL9HNpb7hvFeKLKddmhh2NfY/0VxCCrGJRr1XdaaiwF9wB6zddqUF0Mp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1655
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-11_10:2019-09-11,2019-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=695
 adultscore=0 clxscore=1011 malwarescore=0 phishscore=0 spamscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909110199
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

