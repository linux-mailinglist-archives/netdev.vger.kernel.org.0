Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BED35E62A
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345825AbhDMSTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:19:41 -0400
Received: from mx0b-00169c01.pphosted.com ([67.231.156.123]:22104 "EHLO
        mx0b-00169c01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237951AbhDMSTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 14:19:40 -0400
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 14:19:40 EDT
Received: from pps.filterd (m0048188.ppops.net [127.0.0.1])
        by mx0b-00169c01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DI4rp9011330
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 11:10:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paloaltonetworks.com; h=from : to :
 cc : subject : date : message-id : mime-version :
 content-transfer-encoding; s=PPS12012017;
 bh=wZH+66svz49eAS0BHBu3YKga7B8VsRYU0/MlZLKZ4fQ=;
 b=dxCDtxEKDEsHzluS2mIg8mEo//U8V5yYs5Be+vb8E+N+5cjgeAaGyjMim0k0vksiLHig
 le/Pfva8iI04IiBawTHCu0B6TWa3Wb5kHZcayBf/ne6EH6vWa0zSj9Ek10Q16F00EJmJ
 N2R88CiMKOj3FxkOpsvmmLb6MOGEF4/9DBwzb+uygVmOX3KkSim3zR/rdvnn1JhGec9J
 vvniJrLXqvOU30PyssbDYl6Zq7fdtGdOP4O8rQJUruPHu+UeVHlGRLGb66h3fJo3whPO
 OBdmE5/rPrvXNHWL1fBjhb6aW8V1oUuQ9p+kmt1WaAEu+emZulhbbzy9EfAM8Td2oGTe Zw== 
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        by mx0b-00169c01.pphosted.com with ESMTP id 37vgx6hny5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 11:10:38 -0700
Received: by mail-wm1-f71.google.com with SMTP id o3-20020a1c75030000b029010f4e02a2f2so1460395wmc.6
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 11:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paloaltonetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wZH+66svz49eAS0BHBu3YKga7B8VsRYU0/MlZLKZ4fQ=;
        b=Lxg493MpL13gKfM/jG0KSwRdzh7N9ydU1+xQ6OL6sD3P4GGX8GwNoIcjqsckpYqWnw
         nlz5xeqnol6bRKAIanyOwot/NNkITIEu83bEvEp+K1sdz1/kZKEDQrKAedLBImXHJFoO
         QHFImI5EBS94dg+Dejk1LD2jQkyUKwSGoztlFixJE3QA9nC73yJELJZ/Xo6hCWYu/Nr7
         wJnwDzm1KGnDNitT+DY7LouFPCWI/0k2QL3YBEf/5ghMZY9vp/+qBXoS5C2YOB9RsXsd
         ZoX4uP/72Cl2TwdcLF9F/nU9naD6Uhne/H/0QBXvxdCu9L8nq6CfslvKK9IQMad7FGUQ
         q4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wZH+66svz49eAS0BHBu3YKga7B8VsRYU0/MlZLKZ4fQ=;
        b=OlB8EscjI7S484m6wtgK5TTrLlAyOVe7zDQOznW9WQJpfeVL2DGIo3R+QI7Q1J5vBB
         NMP1RT9qa85y3DdCjf/8GBSTKoS2RNqQ5P6m5ta4Nq1w4rCoLTtIAARShGOBI9eIm6K1
         tdbffJL56ZWKAfqlOS2cQqWocCNR3DHsKoYo2jxrpHi8iXZIY51JFw7cEecTfVCBQhF9
         7aUNRMvquRfJJhd+xZ1x+RYOmtVBLwC/hph1Iilrb1hWsXmUslFRjFNxhShD7oq6yKIC
         sFX+B4ltezmV8lbc0kwJOXOfIcKaKceincfIPXzWy0V8m6JeJ4WUMeDLW/HB3O/u4ewp
         n+dg==
X-Gm-Message-State: AOAM532PxwVeeICSSPdVPd0Rr5HHklDjKvazV0I8VZwh0QqF4fk1Xgtl
        zZn8rxiWUTGAtkWhCeJAh7py2wLReiZYPT+J5lNPMUVdSmY+Q8Gc74sLoU1ltBvhn/kNlsOeYYR
        hpOw8xJISr40f0w098K0s0lrbCwDe2bEYc7MnCaBZzQzYu5sLxO6HMnSXkZzjyKMjCdiDvGmW5C
        8MuhzK
X-Received: by 2002:a1c:a78b:: with SMTP id q133mr1286147wme.68.1618337435400;
        Tue, 13 Apr 2021 11:10:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZuqfuwYeWANy29RTRjtYSnrQmHCujmfwZs8cwpAlneCTG3DsWK2PmBqK2yJ6+pe9vY0BV5Q==
X-Received: by 2002:a1c:a78b:: with SMTP id q133mr1286110wme.68.1618337435022;
        Tue, 13 Apr 2021 11:10:35 -0700 (PDT)
Received: from localhost.localdomain (bzq-79-181-151-86.red.bezeqint.net. [79.181.151.86])
        by smtp.gmail.com with ESMTPSA id v3sm3065407wmj.25.2021.04.13.11.10.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Apr 2021 11:10:34 -0700 (PDT)
From:   Or Cohen <orcohen@paloaltonetworks.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, lucien.xin@gmail.com
Cc:     nmarkus@paloaltonetworks.com,
        Or Cohen <orcohen@paloaltonetworks.com>
Subject: [PATCH v2] net/sctp: fix race condition in sctp_destroy_sock
Date:   Tue, 13 Apr 2021 21:10:31 +0300
Message-Id: <20210413181031.27557-1-orcohen@paloaltonetworks.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 149E6B6qemrr2AhEPKxHP8z4DIxpfhMn
X-Proofpoint-GUID: 149E6B6qemrr2AhEPKxHP8z4DIxpfhMn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_12:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 mlxlogscore=468
 priorityscore=1501 clxscore=1015 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If sctp_destroy_sock is called without sock_net(sk)->sctp.addr_wq_lock
held and sp->do_auto_asconf is true, then an element is removed
from the auto_asconf_splist without any proper locking.

This can happen in the following functions:
1. In sctp_accept, if sctp_sock_migrate fails.
2. In inet_create or inet6_create, if there is a bpf program
   attached to BPF_CGROUP_INET_SOCK_CREATE which denies
   creation of the sctp socket.

The bug is fixed by acquiring addr_wq_lock in sctp_destroy_sock
instead of sctp_close.

This addresses CVE-2021-23133.

Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Fixes: 610236587600 ("bpf: Add new cgroup attach type to enable sock modifications")
Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
---
Changes in v2:
	- Removed a comment in sctp_init_sock.
	- Added a CVE number.

 net/sctp/socket.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a710917c5ac7..b9b3d899a611 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1520,11 +1520,9 @@ static void sctp_close(struct sock *sk, long timeout)
 
 	/* Supposedly, no process has access to the socket, but
 	 * the net layers still may.
-	 * Also, sctp_destroy_sock() needs to be called with addr_wq_lock
-	 * held and that should be grabbed before socket lock.
 	 */
-	spin_lock_bh(&net->sctp.addr_wq_lock);
-	bh_lock_sock_nested(sk);
+	local_bh_disable();
+	bh_lock_sock(sk);
 
 	/* Hold the sock, since sk_common_release() will put sock_put()
 	 * and we have just a little more cleanup.
@@ -1533,7 +1531,7 @@ static void sctp_close(struct sock *sk, long timeout)
 	sk_common_release(sk);
 
 	bh_unlock_sock(sk);
-	spin_unlock_bh(&net->sctp.addr_wq_lock);
+	local_bh_enable();
 
 	sock_put(sk);
 
@@ -4993,9 +4991,6 @@ static int sctp_init_sock(struct sock *sk)
 	sk_sockets_allocated_inc(sk);
 	sock_prot_inuse_add(net, sk->sk_prot, 1);
 
-	/* Nothing can fail after this block, otherwise
-	 * sctp_destroy_sock() will be called without addr_wq_lock held
-	 */
 	if (net->sctp.default_auto_asconf) {
 		spin_lock(&sock_net(sk)->sctp.addr_wq_lock);
 		list_add_tail(&sp->auto_asconf_list,
@@ -5030,7 +5025,9 @@ static void sctp_destroy_sock(struct sock *sk)
 
 	if (sp->do_auto_asconf) {
 		sp->do_auto_asconf = 0;
+		spin_lock_bh(&sock_net(sk)->sctp.addr_wq_lock);
 		list_del(&sp->auto_asconf_list);
+		spin_unlock_bh(&sock_net(sk)->sctp.addr_wq_lock);
 	}
 	sctp_endpoint_free(sp->ep);
 	local_bh_disable();
-- 
2.7.4

