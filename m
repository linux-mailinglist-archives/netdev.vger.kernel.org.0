Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B065B28DB
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 01:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404345AbfIMXXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 19:23:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44920 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390498AbfIMXXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 19:23:40 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8DNKKx9020684;
        Fri, 13 Sep 2019 16:23:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=Bk8ydwPg36cOB43Kw2b+/lEW6SGWJoytMvbqXPARhJQ=;
 b=Ny/fp0301IiCtDz+H6XWAncKIMRQYq+z+3JgXTRJns3DXh41btls4weMmvWqsTn2IAAC
 mESu0WJ8N5YfbhHiK7f4u6KEB8/9DI88Mr8kzMEVF1+GaJTufRbO5fLpETAbnI4UL7q3
 S3PyXEhCRdEAW1tw94Eoa1KbwHAKq2M751o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2uytd96awh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Sep 2019 16:23:36 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Sep 2019 16:23:35 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 16:23:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTmzPX0a4+OsLFWAJacqIaJys0FeNm7d8k1HNeILIZ9LXWQC19XzGHU4LOnZX1xiFXa6Abn44k1LxWoog17LIaxOskzp59Pcon/XDmXLP0sa5OsBzVciWH4gStCaJRa1NrtfrEv6Ta+RkK7CSz7PX8mL2GLVLMxswh+PC/qru+CYG8sABBLKxf4DZwFdUQQJRtLT1T30g5tQm2C2VBdXvsu2ZJNKY2SDg0ZHY2XBbHfmUKuXShnxuFTEBHburyyVWaJvwqi3Op3lxuHYVz+3LuuZ9C9x4zG+4LnK6IYROyuuXBf37lSXFWB9UI+gAAkrqvaGZJdVCYWwHNQ/PSztyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bk8ydwPg36cOB43Kw2b+/lEW6SGWJoytMvbqXPARhJQ=;
 b=TPK7laVU9pQMT72p3RcHewPAlHrY4J1hpDpExMLIqCpJdnBZHImJbjTqgEwBosavHDLbBn5qMo+D5wAkNSyQJTY5qtBLyFLPCKPVIS6LK25sk/Hi8MNqcQsVUpiL4WJbAkxaeGiha9QtsFB9cs/T7c1peXi3NehGzynRa772VS3vczqNOF/0yHhZ+KDNGt3Oat2id+FEPvFv1RcOyAruMUae1SS80lNnZrbEr+Q5XRf2a0Jl93EJavRQKPfjHz6TO2CinbCr/fWvmlhFhZVkjYh7DNnzJ850f/YF22xTBwPPrvWW/wXhIM21GWueeBy0jgDaBnl26l8rDvExMjINEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bk8ydwPg36cOB43Kw2b+/lEW6SGWJoytMvbqXPARhJQ=;
 b=PAO0bGiANQt+pLEPch7T5lRdjBu/O62ba0tzrEvPJV3p0w2o6bnGpPYg4L+Hic8spzhYbSAvqzOAWlCmbA4u3IVRtWHl1o0HCNewBrLqWSI2EAqPeoAZUKsOFxLEPIntpHVHxANb0+P7RZS0QQNfDnZ7odLd+VvIc8J2PUFDDng=
Received: from CY4PR15MB1207.namprd15.prod.outlook.com (10.172.180.17) by
 CY4PR15MB1685.namprd15.prod.outlook.com (10.175.120.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Fri, 13 Sep 2019 23:23:34 +0000
Received: from CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3]) by CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3%6]) with mapi id 15.20.2241.025; Fri, 13 Sep 2019
 23:23:34 +0000
From:   Thomas Higdon <tph@fb.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jonathan Lemon <jonathan.lemon@gmail.com>, Dave Jones <dsj@fb.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Dave Taht" <dave.taht@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        "Soheil Hassas Yeganeh" <soheil@google.com>
Subject: [PATCH v5 1/2] tcp: Add TCP_INFO counter for packets received
 out-of-order
Thread-Topic: [PATCH v5 1/2] tcp: Add TCP_INFO counter for packets received
 out-of-order
Thread-Index: AQHVaopDJcZ18s3ro0Kvu9zbXZ4gtA==
Date:   Fri, 13 Sep 2019 23:23:34 +0000
Message-ID: <20190913232332.44036-1-tph@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:208:120::42) To CY4PR15MB1207.namprd15.prod.outlook.com
 (2603:10b6:903:110::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.16.2
x-originating-ip: [163.114.130.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc1e0f1a-98ff-4987-0403-08d738a165e0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1685;
x-ms-traffictypediagnostic: CY4PR15MB1685:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB168518905A72920E515CAD99DDB30@CY4PR15MB1685.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(66446008)(66556008)(64756008)(66946007)(66476007)(2501003)(486006)(3846002)(14454004)(4326008)(6116002)(2351001)(478600001)(7736002)(25786009)(305945005)(6436002)(5640700003)(6486002)(1076003)(53936002)(6512007)(6916009)(54906003)(71200400001)(71190400001)(66066001)(2906002)(5660300002)(86362001)(14444005)(8936002)(36756003)(186003)(52116002)(8676002)(2616005)(6506007)(476003)(1730700003)(81156014)(386003)(81166006)(50226002)(256004)(102836004)(99286004)(26005)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1685;H:CY4PR15MB1207.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8Mf7d8rTDhLIY29+fO6HgDN2vR5wuJXDJOf+AeJgFc3JM1IAI5vI/uvyuHFUbY/STF3pVV3HQBryNLTd7T71DwT1BziiIrCPagfoecEvc4f6ciOBGIPbQRQ8638CgGo27jwYYWtUQ+UQYM5PMnUwA4b8P2Br4hhneBFExK1aqaxTFI2oKJbZ9xulZMLcqlOVTArYgIiXEEHzdp6eZ6NKggqUB6TdGBuY5zpLu05bXnXe3y+qCS7Q6HlJMYif5NJL31ufwKVL/jxI+Io/rsobfbsijuSFEBRSD9Z1EhChUZDSn9t0QzMYSbSm3PvvSqObf3HyCoCRIL/qy8gk82eluv4vKzoNiUZRuNQNueFInYiofxjhdYXeher36kLiiXL7Tgmqdw+1hJYjduBdhCxizdfeZAg9mW+9Um9LoJawc/I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc1e0f1a-98ff-4987-0403-08d738a165e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 23:23:34.8093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TnnAeaLLaLbzQDA1LSPLuj1wUr++zsNoyBFq3ZO4vr/4qNM97Xbk0Y773yjglsi4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1685
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_11:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=581 spamscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130227
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

Also note that we avoid increasing the size of the tcp_sock struct by
taking advantage of a hole.

Signed-off-by: Thomas Higdon <tph@fb.com>
---
changes since v4:
 - optimize placement of rcv_ooopack to avoid increasing tcp_sock struct
   size

 include/linux/tcp.h      | 2 ++
 include/uapi/linux/tcp.h | 2 ++
 net/ipv4/tcp.c           | 2 ++
 net/ipv4/tcp_input.c     | 1 +
 4 files changed, 7 insertions(+)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index f3a85a7fb4b1..99617e528ea2 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -354,6 +354,8 @@ struct tcp_sock {
 #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) 0
 #endif
=20
+	u32 rcv_ooopack; /* Received out-of-order packets, for tcpinfo */
+
 /* Receiver side RTT estimation */
 	u32 rcv_rtt_last_tsecr;
 	struct {
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

