Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1EA2E259
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfE2Qfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:35:38 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:53886 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727329AbfE2Qfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:35:37 -0400
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4TGW2h3019676;
        Wed, 29 May 2019 17:35:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=KboYt34cVwVmcoJO1lewWvI5qmxc70otFjUEif+E05A=;
 b=kSKj5BJQwzEl+4MUcROx4msMlWufPhm87ZmMBCQ/q9m0dDa0D3+cGn1ChEJdS4Og4x9x
 Tn/aZ6RDucBK7h/2WWoNy+xnoBUtms9BMXPPn50OiAHoNMSRJcKpXRGN4tC2b/4ims36
 O8dIV89hH/YZH0JfND/uv/pWZkb4wXXf6ROlgTTi2rI19I8gMe8nQRj9JuyAv4oA5ExY
 1tW5AoD6sRfOEVvuZhj4rPf30LyTOxuofmVpIPeoCfA/WQ9rSEjFqIpcNXXE2IiSyoNo
 owvAq9myhdATgu30e9M3UQq2Rp+yFzvrl5IbaFKLm3DvODlvqjglCZwK4vlNUV4iUZUB +w== 
Received: from prod-mail-ppoint4 (prod-mail-ppoint4.akamai.com [96.6.114.87] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2ssdhmk1k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 May 2019 17:35:20 +0100
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4TGW0kb009218;
        Wed, 29 May 2019 12:35:20 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint4.akamai.com with ESMTP id 2sq11vu8fc-1;
        Wed, 29 May 2019 12:35:19 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 7EF931FC72;
        Wed, 29 May 2019 16:35:18 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com, ycheng@google.com
Cc:     cpaasch@apple.com, ilubashe@akamai.com, netdev@vger.kernel.org,
        Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH net-next v2 5/6] Documentation: ip-sysctl.txt: Document tcp_fastopen_key
Date:   Wed, 29 May 2019 12:34:00 -0400
Message-Id: <19e18de8f2ad9bbba54ca9784c8d9ebc7981ae29.1559146812.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1559146812.git.jbaron@akamai.com>
References: <cover.1559146812.git.jbaron@akamai.com>
In-Reply-To: <cover.1559146812.git.jbaron@akamai.com>
References: <cover.1559146812.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290108
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add docs for /proc/sys/net/ipv4/tcp_fastopen_key

Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Cc: Jeremy Sowden <jeremy@azazel.net>
Acked-by: Yuchung Cheng <ycheng@google.com>
---
 Documentation/networking/ip-sysctl.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 14fe930..a73b3a0 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -648,6 +648,26 @@ tcp_fastopen_blackhole_timeout_sec - INTEGER
 	0 to disable the blackhole detection.
 	By default, it is set to 1hr.
 
+tcp_fastopen_key - list of comma separated 32-digit hexadecimal INTEGERs
+	The list consists of a primary key and an optional backup key. The
+	primary key is used for both creating and validating cookies, while the
+	optional backup key is only used for validating cookies. The purpose of
+	the backup key is to maximize TFO validation when keys are rotated.
+
+	A randomly chosen primary key may be configured by the kernel if
+	the tcp_fastopen sysctl is set to 0x400 (see above), or if the
+	TCP_FASTOPEN setsockopt() optname is set and a key has not been
+	previously configured via sysctl. If keys are configured via
+	setsockopt() by using the TCP_FASTOPEN_KEY optname, then those
+	per-socket keys will be used instead of any keys that are specified via
+	sysctl.
+
+	A key is specified as 4 8-digit hexadecimal integers which are separated
+	by a '-' as: xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx. Leading zeros may be
+	omitted. A primary and a backup key may be specified by separating them
+	by a comma. If only one key is specified, it becomes the primary key and
+	any previously configured backup keys are removed.
+
 tcp_syn_retries - INTEGER
 	Number of times initial SYNs for an active TCP connection attempt
 	will be retransmitted. Should not be higher than 127. Default value
-- 
2.7.4

