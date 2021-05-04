Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5696372669
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 09:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhEDHRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 03:17:47 -0400
Received: from mx0a-00169c01.pphosted.com ([67.231.148.124]:59248 "EHLO
        mx0b-00169c01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229575AbhEDHRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 03:17:47 -0400
Received: from pps.filterd (m0045114.ppops.net [127.0.0.1])
        by mx0a-00169c01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1447AUmj021478
        for <netdev@vger.kernel.org>; Tue, 4 May 2021 00:16:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paloaltonetworks.com; h=from : to :
 cc : subject : date : message-id : mime-version :
 content-transfer-encoding; s=PPS12012017;
 bh=NqxnZs6DWOQNWcqBhA27WfqYrh1QCJtiQe+R0ao9pb8=;
 b=IDgZ9qRO0BJhoXAzKROf3S5rqxCadbrr3x/PiAeXItrMPxNurF+i5+A6WLidLkyRuLn4
 Ej2xyKD97GVyHZYi23oLMXNUCcQReWuYLUidwSBNIR3F5j6l8eGcgQ3NlTTWlBcNrdVe
 wQ3d9cYoSh1XgU9BaGWIjYE1B0tbh+FhZcp72f6t1xYM+mOYGdOwl+Laui+aAzjeT8C3
 hShBQuqkaX/59iYMdT70UosAatVP6EQUIq58QAlNXWDGaU+D2FCSIKMw4xbIU8b3GFnZ
 W/0BVUikb9wLVwOzfzKRD3cM/SZO2EpNrK5fcqj17r3/Sg74dwzBREnjvi6Jei+S0xdC qg== 
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        by mx0a-00169c01.pphosted.com with ESMTP id 38ahpgpgj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 00:16:52 -0700
Received: by mail-wr1-f72.google.com with SMTP id q18-20020adfc5120000b029010c2bdd72adso5399623wrf.16
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 00:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paloaltonetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NqxnZs6DWOQNWcqBhA27WfqYrh1QCJtiQe+R0ao9pb8=;
        b=scxwvt4K4Kw1VjYDRyXyYHrmUvXPMSz+bKGgvxbyZ7TRlnMZ1bBvF+xxLGFT/DE4UF
         QqfqeMwUSNnjtGGDAggfF3bdzG2dAYNZNY0m32H9SHDtvnEubzjBvqr1fG9xYTUuIQ8I
         z0OpA7c7LN+hhmm4jYgEy4bWuYnkuE73ZqdSPZ2SUK/L8DN4/rD4MCN/j8QiHwxfcTDW
         fayzEC/lv5Px+Y1nEprV6UzXE1vgY+j1lpWnX0EvLph88tCG7aUWEXovi81nsNp70Xzq
         qahjRiLT20BSSdnnNOD7+sO32F8AMlmG3oVTufGHxg7S2dvHqLE8RRIT/YZGv03hi3ZR
         +fFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NqxnZs6DWOQNWcqBhA27WfqYrh1QCJtiQe+R0ao9pb8=;
        b=VpUnYfI+R+WbKCt1O67HW9YzYKHYG0EzcPiBQY5pcUYgs/X3JTQVO41Bi5gQt99Xxh
         cZ3HJaI879mvYC/w408RSS+idLJDjClrVahhFNZX6A1cVjvCnoMEt43ZEq4FPqGs/17H
         74aIExeSOMVLK81MDLdpDeSxdbjP8RwbTqu8784E7Ktdf1Sq8pkwLtUzTnOX0KmvB4GE
         cQ2X3o37f2wQJGINXYEF6Qext/CMuPFQJ+ePRISZddQR9TP9PUdG9BJrj3t7xU6Ec6Ph
         LU5wtMy6zzWUdcPl8StOMeub/R3L1ug++EPliUYRXIvPHQnoL+Awud0hqfegsHhdjK6A
         aJdw==
X-Gm-Message-State: AOAM5315jRKMob/9X9E3nG8wyfN3tequnLV9F9K4qBFyhmIdQGuV5ual
        ft8Qi/a/RPMNAAE+MVAvZAmQQo+SV/laa9cqHx8vDv+wu3uWYXlkXkysaJRIs0miyE95kyNm+lc
        XhCzFHBk65h8TNBzI4GtvDBXG580kQYOMDRloS9gYNZx5VB/sEcwvQTLGR4HP3+AR29YHqr2r5Q
        aP5rcC
X-Received: by 2002:adf:cd0e:: with SMTP id w14mr30012636wrm.46.1620112610525;
        Tue, 04 May 2021 00:16:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTfLCywGXck1rXH6WM0Z11VvSMnFlRfJIyXqRNp54QXqZIozT3NrO7cXRBq//l+HQ797/elg==
X-Received: by 2002:adf:cd0e:: with SMTP id w14mr30012605wrm.46.1620112610287;
        Tue, 04 May 2021 00:16:50 -0700 (PDT)
Received: from localhost.localdomain (bzq-109-64-244-223.red.bezeqint.net. [109.64.244.223])
        by smtp.gmail.com with ESMTPSA id k16sm1652859wmi.44.2021.05.04.00.16.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 May 2021 00:16:49 -0700 (PDT)
From:   Or Cohen <orcohen@paloaltonetworks.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        nixiaoming@huawei.com, matthieu.baerts@tessares.net,
        mkl@pengutronix.de, nmarkus@paloaltonetworks.com
Cc:     Or Cohen <orcohen@paloaltonetworks.com>
Subject: [PATCH] net/nfc: fix use-after-free llcp_sock_bind/connect
Date:   Tue,  4 May 2021 10:16:46 +0300
Message-Id: <20210504071646.28665-1-orcohen@paloaltonetworks.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Qicm3p3ECiC9kh1W6cZBbDINq78bnMwv
X-Proofpoint-ORIG-GUID: Qicm3p3ECiC9kh1W6cZBbDINq78bnMwv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_02:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 mlxlogscore=720
 adultscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commits 8a4cd82d ("nfc: fix refcount leak in llcp_sock_connect()")
and c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
fixed a refcount leak bug in bind/connect but introduced a
use-after-free if the same local is assigned to 2 different sockets.

This can be triggered by the following simple program:
    int sock1 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
    int sock2 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
    memset( &addr, 0, sizeof(struct sockaddr_nfc_llcp) );
    addr.sa_family = AF_NFC;
    addr.nfc_protocol = NFC_PROTO_NFC_DEP;
    bind( sock1, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
    bind( sock2, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
    close(sock1);
    close(sock2);

Fix this by assigning NULL to llcp_sock->local after calling
nfc_llcp_local_put.

This addresses CVE-2021-23134.

Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
Reported-by: Nadav Markus <nmarkus@paloaltonetworks.com>
Fixes: c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
---
 net/nfc/llcp_sock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index a3b46f888803..53dbe733f998 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -109,12 +109,14 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 					  GFP_KERNEL);
 	if (!llcp_sock->service_name) {
 		nfc_llcp_local_put(llcp_sock->local);
+		llcp_sock->local = NULL;
 		ret = -ENOMEM;
 		goto put_dev;
 	}
 	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
 		nfc_llcp_local_put(llcp_sock->local);
+		llcp_sock->local = NULL;
 		kfree(llcp_sock->service_name);
 		llcp_sock->service_name = NULL;
 		ret = -EADDRINUSE;
@@ -709,6 +711,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
 		nfc_llcp_local_put(llcp_sock->local);
+		llcp_sock->local = NULL;
 		ret = -ENOMEM;
 		goto put_dev;
 	}
@@ -756,6 +759,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 sock_llcp_release:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);
 	nfc_llcp_local_put(llcp_sock->local);
+	llcp_sock->local = NULL;
 
 put_dev:
 	nfc_put_device(dev);
-- 
2.7.4

