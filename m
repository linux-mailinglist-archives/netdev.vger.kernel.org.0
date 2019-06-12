Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC767447CE
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfFMRCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:02:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47206 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729530AbfFLXYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 19:24:21 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CNIbQt007748
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 16:24:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=BtD7W0wv2RDXWR2irAaVpl2hKq5GGSC8OYd8JSvKc0I=;
 b=TOfDXUWS1Ns5T8etUfQl35oPoTFPXI/FXlgxYyOr4x/LKnXun9SoTdZoP+LE5QHAY+jf
 eBQtJ8Vmz7GGQd/tb2areWsDRU+dsI72mXUF553l1lqVxlGLRRnpmDpIG6ll+7hDo/MO
 OF8fZcBCbPQo77Mc7MUVnFaNH8NThhWivpw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t37588ud3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 16:24:19 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 12 Jun 2019 16:24:18 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 62B3C294308C; Wed, 12 Jun 2019 16:24:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/3] bpf: Sync asm-generic/socket.h to tools/
Date:   Wed, 12 Jun 2019 16:24:16 -0700
Message-ID: <20190612232416.3197123-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190612232412.3196844-1-kafai@fb.com>
References: <20190612232412.3196844-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=670 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SO_DETACH_REUSEPORT_BPF is needed for the test in the next patch.
It is defined in the socket.h.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/include/uapi/asm-generic/socket.h | 147 ++++++++++++++++++++++++
 1 file changed, 147 insertions(+)
 create mode 100644 tools/include/uapi/asm-generic/socket.h

diff --git a/tools/include/uapi/asm-generic/socket.h b/tools/include/uapi/asm-generic/socket.h
new file mode 100644
index 000000000000..77f7c1638eb1
--- /dev/null
+++ b/tools/include/uapi/asm-generic/socket.h
@@ -0,0 +1,147 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __ASM_GENERIC_SOCKET_H
+#define __ASM_GENERIC_SOCKET_H
+
+#include <linux/posix_types.h>
+#include <asm/sockios.h>
+
+/* For setsockopt(2) */
+#define SOL_SOCKET	1
+
+#define SO_DEBUG	1
+#define SO_REUSEADDR	2
+#define SO_TYPE		3
+#define SO_ERROR	4
+#define SO_DONTROUTE	5
+#define SO_BROADCAST	6
+#define SO_SNDBUF	7
+#define SO_RCVBUF	8
+#define SO_SNDBUFFORCE	32
+#define SO_RCVBUFFORCE	33
+#define SO_KEEPALIVE	9
+#define SO_OOBINLINE	10
+#define SO_NO_CHECK	11
+#define SO_PRIORITY	12
+#define SO_LINGER	13
+#define SO_BSDCOMPAT	14
+#define SO_REUSEPORT	15
+#ifndef SO_PASSCRED /* powerpc only differs in these */
+#define SO_PASSCRED	16
+#define SO_PEERCRED	17
+#define SO_RCVLOWAT	18
+#define SO_SNDLOWAT	19
+#define SO_RCVTIMEO_OLD	20
+#define SO_SNDTIMEO_OLD	21
+#endif
+
+/* Security levels - as per NRL IPv6 - don't actually do anything */
+#define SO_SECURITY_AUTHENTICATION		22
+#define SO_SECURITY_ENCRYPTION_TRANSPORT	23
+#define SO_SECURITY_ENCRYPTION_NETWORK		24
+
+#define SO_BINDTODEVICE	25
+
+/* Socket filtering */
+#define SO_ATTACH_FILTER	26
+#define SO_DETACH_FILTER	27
+#define SO_GET_FILTER		SO_ATTACH_FILTER
+
+#define SO_PEERNAME		28
+
+#define SO_ACCEPTCONN		30
+
+#define SO_PEERSEC		31
+#define SO_PASSSEC		34
+
+#define SO_MARK			36
+
+#define SO_PROTOCOL		38
+#define SO_DOMAIN		39
+
+#define SO_RXQ_OVFL             40
+
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS	SO_WIFI_STATUS
+#define SO_PEEK_OFF		42
+
+/* Instruct lower device to use last 4-bytes of skb data as FCS */
+#define SO_NOFCS		43
+
+#define SO_LOCK_FILTER		44
+
+#define SO_SELECT_ERR_QUEUE	45
+
+#define SO_BUSY_POLL		46
+
+#define SO_MAX_PACING_RATE	47
+
+#define SO_BPF_EXTENSIONS	48
+
+#define SO_INCOMING_CPU		49
+
+#define SO_ATTACH_BPF		50
+#define SO_DETACH_BPF		SO_DETACH_FILTER
+
+#define SO_ATTACH_REUSEPORT_CBPF	51
+#define SO_ATTACH_REUSEPORT_EBPF	52
+
+#define SO_CNX_ADVICE		53
+
+#define SCM_TIMESTAMPING_OPT_STATS	54
+
+#define SO_MEMINFO		55
+
+#define SO_INCOMING_NAPI_ID	56
+
+#define SO_COOKIE		57
+
+#define SCM_TIMESTAMPING_PKTINFO	58
+
+#define SO_PEERGROUPS		59
+
+#define SO_ZEROCOPY		60
+
+#define SO_TXTIME		61
+#define SCM_TXTIME		SO_TXTIME
+
+#define SO_BINDTOIFINDEX	62
+
+#define SO_TIMESTAMP_OLD        29
+#define SO_TIMESTAMPNS_OLD      35
+#define SO_TIMESTAMPING_OLD     37
+
+#define SO_TIMESTAMP_NEW        63
+#define SO_TIMESTAMPNS_NEW      64
+#define SO_TIMESTAMPING_NEW     65
+
+#define SO_RCVTIMEO_NEW         66
+#define SO_SNDTIMEO_NEW         67
+
+#define SO_DETACH_REUSEPORT_BPF 68
+
+#if !defined(__KERNEL__)
+
+#if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
+/* on 64-bit and x32, avoid the ?: operator */
+#define SO_TIMESTAMP		SO_TIMESTAMP_OLD
+#define SO_TIMESTAMPNS		SO_TIMESTAMPNS_OLD
+#define SO_TIMESTAMPING		SO_TIMESTAMPING_OLD
+
+#define SO_RCVTIMEO		SO_RCVTIMEO_OLD
+#define SO_SNDTIMEO		SO_SNDTIMEO_OLD
+#else
+#define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)
+#define SO_TIMESTAMPNS (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMPNS_OLD : SO_TIMESTAMPNS_NEW)
+#define SO_TIMESTAMPING (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMPING_OLD : SO_TIMESTAMPING_NEW)
+
+#define SO_RCVTIMEO (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_RCVTIMEO_OLD : SO_RCVTIMEO_NEW)
+#define SO_SNDTIMEO (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_SNDTIMEO_OLD : SO_SNDTIMEO_NEW)
+#endif
+
+#define SCM_TIMESTAMP           SO_TIMESTAMP
+#define SCM_TIMESTAMPNS         SO_TIMESTAMPNS
+#define SCM_TIMESTAMPING        SO_TIMESTAMPING
+
+#endif
+
+#endif /* __ASM_GENERIC_SOCKET_H */
-- 
2.17.1

