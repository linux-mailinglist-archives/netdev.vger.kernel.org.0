Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F65B1C3FDE
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgEDQaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 12:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729425AbgEDQaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 12:30:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A345C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 09:30:11 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n14so84684qke.8
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 09:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=onechronos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7fujQkxKz3m2CAOMYyor2I1084L31B3K7d8W3Sk7fe0=;
        b=fOVQFR2mffIFtRo9aW+OETI4VmBUZBMCWccGFbsdJAxiJf3KQAJcrqqMwPn+JMHQdW
         v8e4frm5ZhTaCsHc//NFAXnWNEoWVZDG4cuuJyQbPVr0Aj521GsNNPRSD0t4+CziFR8/
         6kGucnhBWV12bMYt0aQa4cLHC48R/Fiz9ehk/nfhlU/o9LDtb7PVV7ka9Uml3rrfN4Hq
         rMOPF0XMWaKHG/PUCNciOHYrGPy1A7kNzEw8xLQQ5hlx0I56uoyRAgNVV2r8ib5xWS+O
         2Sk5eiw3KyKn+COGwN1xxvIcgkgGw+ewf1IEj9sBFqMhsgZwbu0EFmbDUKs5uZB3tjgU
         kwng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7fujQkxKz3m2CAOMYyor2I1084L31B3K7d8W3Sk7fe0=;
        b=Zqbxi4D9MUkMVwha6SCHfWJJ+C4CfartxeHkormOiYJ8ZnJBgZ0kDJmT8X9aJXNgK+
         ndFg+D5EHk1HX+17RaP1k6s9eO+0LJTQEcl3mANiHEGw93d5wn6kUPzLj60r4Qv8fuHF
         J0qu6ZhZUKG6tftSrXJSJoSHIsi8LkGMqmRTwTLCEFFzFp/YhFq1bLBGuY2FHNBKWyLL
         /TSGHz6hc0rgG7GfOECFGfl0l8wKj5zT0XDBjN5ZMNQc4KU2sUlocbpWQR05ftKl6P5d
         kfqNxb+qbxIshxxyTs5yUvGy8mOlMDERPZH9aTxIBqhSTPx2pRv4uobb9vjgOVElW4Bw
         pHAQ==
X-Gm-Message-State: AGi0Puav/24Pp4iZe85oB8kttCyBFz7ntQ/gNi9TCKtsq+sWvEWES48A
        kOjYx+AhLaLHQom5jz+Z40SCq2Lv94xCN0mJPWuEbaiXBgmIdvy+oKhvwG0VWcOgPuH7sZF7+5I
        fIUT+TUvh07IK/mEa+hrTRdQG1QCGp6MlM/qDAGpMNoY6it4YE5wMBleNpcpjoLiRCSSyDTPEtG
        bub2+KPRNw94qMWvO+fthJQEDo9ZikomCLOJeLcIIwXCdreJrC9/DMrA==
X-Google-Smtp-Source: APiQypJ4PpXSZzpP3LJ/ZpZUdWztL2KQVPr5mm3qd8T9S0hCmpLrtnujviUlKTmWwQM97CAFJyE9+A==
X-Received: by 2002:a37:7e01:: with SMTP id z1mr16593408qkc.433.1588609810095;
        Mon, 04 May 2020 09:30:10 -0700 (PDT)
Received: from localhost.net (c-98-221-91-232.hsd1.nj.comcast.net. [98.221.91.232])
        by smtp.gmail.com with ESMTPSA id o43sm11284743qtc.23.2020.05.04.09.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 09:30:09 -0700 (PDT)
From:   Kelly Littlepage <kelly@onechronos.com>
To:     dumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Kelly Littlepage <kelly@onechronos.com>,
        Iris Liu <iris@onechronos.com>
Subject: [PATCH] net: tcp: fix rx timestamp behavior for tcp_recvmsg
Date:   Mon,  4 May 2020 16:29:48 +0000
Message-Id: <20200504162948.4146-1-kelly@onechronos.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Timestamping cmsgs are not returned when the user buffer supplied to
recvmsg is too small to copy at least one skbuff in entirety. Support
for TCP rx timestamps=C2=A0came from commit 98aaa913b4ed ("tcp: Extend
SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which noted that the cmsg
should "return the timestamp corresponding to the highest sequence
number data returned." The commit further notes that when coalescing
skbs code should "maintain the invariant of returning the timestamp of
the last byte in the recvmsg buffer."

This is consistent with Section 1.4 of timestamping.txt, a document that
discusses expected behavior when timestamping streaming protocols. It's
worth noting that Section 1.4 alludes to a "buffer" in a way that might
have resulted in the current behavior:

> The SO_TIMESTAMPING interface supports timestamping of bytes in a
bytestream. Each request is interpreted as a request for when the entire
contents of the buffer has passed a timestamping point....In practice,
timestamps can be correlated with segments of a bytestream consistently,
if both semantics of the timestamp and the timing of measurement are
chosen correctly....For bytestreams, we chose that a timestamp is
generated only when all bytes have passed a point.

An interpretation of skbs as delineators for timestamping points makes
sense for tx timestamps but poses implementation challenges on the rx
side. Under the current API unless tcp_recvmsg happens to return bytes
copied from precisely one skb there's no useful mapping from bytes to
timestamps. Some sequences of reads will result in timestamps getting
lost and others will result in the user receiving a timestamp from the
second to last skb that tcp_recvmsg copied from instead of the last. The
proposed change addresses both problems while remaining consistent with
1.4 and the wording of commit 98aaa913b4ed ("tcp: Extend
SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg").

Co-developed-by: Iris Liu <iris@onechronos.com>
Signed-off-by: Iris Liu <iris@onechronos.com>
Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
---
 net/ipv4/tcp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6d87de434377..e72bd651d21a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2154,13 +2154,15 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg=
, size_t len, int nonblock,
 			tp->urg_data =3D 0;
 			tcp_fast_path_check(sk);
 		}
-		if (used + offset < skb->len)
-			continue;
=20
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
 			tcp_update_recv_tstamps(skb, &tss);
 			cmsg_flags |=3D 2;
 		}
+
+		if (used + offset < skb->len)
+			continue;
+
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 			goto found_fin_ok;
 		if (!(flags & MSG_PEEK))
--=20
2.26.2


--=20
This email and any attachments thereto may contain private, confidential,=
=20
and privileged material for the sole use of the intended recipient. If you=
=20
are not the intended recipient or otherwise believe that you have received=
=20
this message in error, please notify the sender immediately and delete the=
=20
original. Any review, copying, or distribution of this email (or any=20
attachments thereto) by others is strictly prohibited. If this message was=
=20
misdirected, OCX Group Inc. does not waive any confidentiality or privilege=
.
