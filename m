Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75784C40DD
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238756AbiBYJD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiBYJD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:03:26 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B021B8CDB5;
        Fri, 25 Feb 2022 01:02:54 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id bx9-20020a17090af48900b001bc64ee7d3cso4244962pjb.4;
        Fri, 25 Feb 2022 01:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ducc7JXZKPilbiGQb9maeoCw4VcQthlM/33tFBDDEXY=;
        b=LXxI6oEAqREMBDL8LgEQdui6E2TZcGhmYxgWhOkc6Tozq2/M+EEAiDVhrbhLwLrRbo
         kuzQdUX+yM8MDIdMaesD0zLI0Y5PdQopdzQOyJAESekaamPrTOgwlJsh8foVRiOqRpWk
         7eDKJg4b97CSTKGZkZ2u6fC8+2GZrMsIdUJlb8bjiOspJAMfhVaZJDLz/IXKDrL0lEwA
         12+udt6Isx4rIyzg8BBY6kUaHDZ3WVNqjrzsfKK05FTGOx/VaQSHbsb+zng+7HIsoN1J
         fZTD7E1fiwoKOtvUJ5a2WJHNI4lbqJ31n5OGDQX4S/uBAMk2g4wxAhwbFOffoQSAV7ym
         2dqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ducc7JXZKPilbiGQb9maeoCw4VcQthlM/33tFBDDEXY=;
        b=ppCx2hpqXobdvFbRZlAESdfwYklfjNEYlDwHwyNwX0L5hYMT0Ktx8mgvf9YtYH2bvu
         nC7s953UiRmlFzAh5afHnENZOe7bWae/xDt6BHKyCVMq903SAUOxORmQpMf3xXdyq1rs
         1aDFEcOjdE3314EHn6GXHJh0xGf05ygrdoN9DehDl/z5xxMZUerfuEggRHrFanfdfCf4
         T6fU0MNMG8xAMwJPzvgxcAyS9yVeEU9fXhcmJOWIxkwolvrCNvVLJOB0ElgRG6UuYvWj
         wnRJQdqsaYSLckkUTuo8BbUUDey+SDqqxO+iLYiYEmoit82Gp7F//shRmCXyY6c2Ii6v
         Ko+Q==
X-Gm-Message-State: AOAM533+xL1ay6jsWkteNUPkcY6ohR+j15Z8gVyv8gYnDGGfsBHoTPVT
        FXvZQJ8gwpwYBVxQqBQt+VcryDOsc12idXqi
X-Google-Smtp-Source: ABdhPJylz7bTsGKWA+YqwJVquOZ29LPKyAFu7GqCfzGA8fDlTPSCwefNlBPiXAIqtgZZmbbPXw3W9w==
X-Received: by 2002:a17:90a:8a14:b0:1bc:1d5e:d852 with SMTP id w20-20020a17090a8a1400b001bc1d5ed852mr2234799pjn.76.1645779774010;
        Fri, 25 Feb 2022 01:02:54 -0800 (PST)
Received: from localhost.localdomain ([157.255.44.217])
        by smtp.gmail.com with ESMTPSA id p1-20020a056a000b4100b004e13df16962sm2406744pfo.217.2022.02.25.01.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 01:02:53 -0800 (PST)
From:   Harold Huang <baymaxhuang@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jasowang@redhat.com, pabeni@redhat.com,
        Harold Huang <baymaxhuang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path))
Subject: [PATCH net-next v2] tun: support NAPI for packets received from batched XDP buffs
Date:   Fri, 25 Feb 2022 17:02:23 +0800
Message-Id: <20220225090223.636877-1-baymaxhuang@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220224103852.311369-1-baymaxhuang@gmail.com>
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tun, NAPI is supported and we can also use NAPI in the path of
batched XDP buffs to accelerate packet processing. What is more, after
we use NAPI, GRO is also supported. The iperf shows that the throughput of
single stream could be improved from 4.5Gbps to 9.2Gbps. Additionally, 9.2
Gbps nearly reachs the line speed of the phy nic and there is still about
15% idle cpu core remaining on the vhost thread.

Test topology:

[iperf server]<--->tap<--->dpdk testpmd<--->phy nic<--->[iperf client]

Iperf stream:

Before:
...
[  5]   5.00-6.00   sec   558 MBytes  4.68 Gbits/sec    0   1.50 MBytes
[  5]   6.00-7.00   sec   556 MBytes  4.67 Gbits/sec    1   1.35 MBytes
[  5]   7.00-8.00   sec   556 MBytes  4.67 Gbits/sec    2   1.18 MBytes
[  5]   8.00-9.00   sec   559 MBytes  4.69 Gbits/sec    0   1.48 MBytes
[  5]   9.00-10.00  sec   556 MBytes  4.67 Gbits/sec    1   1.33 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  5.39 GBytes  4.63 Gbits/sec   72          sender
[  5]   0.00-10.04  sec  5.39 GBytes  4.61 Gbits/sec               receiver

After:
...
[  5]   5.00-6.00   sec  1.07 GBytes  9.19 Gbits/sec    0   1.55 MBytes
[  5]   6.00-7.00   sec  1.08 GBytes  9.30 Gbits/sec    0   1.63 MBytes
[  5]   7.00-8.00   sec  1.08 GBytes  9.25 Gbits/sec    0   1.72 MBytes
[  5]   8.00-9.00   sec  1.08 GBytes  9.25 Gbits/sec   77   1.31 MBytes
[  5]   9.00-10.00  sec  1.08 GBytes  9.24 Gbits/sec    0   1.48 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  10.8 GBytes  9.28 Gbits/sec  166          sender
[  5]   0.00-10.04  sec  10.8 GBytes  9.24 Gbits/sec               receiver
....

Reported-at: https://lore.kernel.org/all/CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com
Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
---
v1 -> v2
 - fix commit messages
 - add queued flag to avoid void unnecessary napi suggested by Jason

 drivers/net/tun.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fed85447701a..c7d8b7c821d8 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2379,7 +2379,7 @@ static void tun_put_page(struct tun_page *tpage)
 }
 
 static int tun_xdp_one(struct tun_struct *tun,
-		       struct tun_file *tfile,
+		       struct tun_file *tfile, int *queued,
 		       struct xdp_buff *xdp, int *flush,
 		       struct tun_page *tpage)
 {
@@ -2388,6 +2388,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	struct virtio_net_hdr *gso = &hdr->gso;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
+	struct sk_buff_head *queue;
 	u32 rxhash = 0, act;
 	int buflen = hdr->buflen;
 	int err = 0;
@@ -2464,7 +2465,15 @@ static int tun_xdp_one(struct tun_struct *tun,
 	    !tfile->detached)
 		rxhash = __skb_get_hash_symmetric(skb);
 
-	netif_receive_skb(skb);
+	if (tfile->napi_enabled) {
+		queue = &tfile->sk.sk_write_queue;
+		spin_lock(&queue->lock);
+		__skb_queue_tail(queue, skb);
+		spin_unlock(&queue->lock);
+		(*queued)++;
+	} else {
+		netif_receive_skb(skb);
+	}
 
 	/* No need to disable preemption here since this function is
 	 * always called with bh disabled
@@ -2492,7 +2501,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	if (ctl && (ctl->type == TUN_MSG_PTR)) {
 		struct tun_page tpage;
 		int n = ctl->num;
-		int flush = 0;
+		int flush = 0, queued = 0;
 
 		memset(&tpage, 0, sizeof(tpage));
 
@@ -2501,12 +2510,15 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 
 		for (i = 0; i < n; i++) {
 			xdp = &((struct xdp_buff *)ctl->ptr)[i];
-			tun_xdp_one(tun, tfile, xdp, &flush, &tpage);
+			tun_xdp_one(tun, tfile, &queued, xdp, &flush, &tpage);
 		}
 
 		if (flush)
 			xdp_do_flush();
 
+		if (tfile->napi_enabled && queued > 0)
+			napi_schedule(&tfile->napi);
+
 		rcu_read_unlock();
 		local_bh_enable();
 
-- 
2.27.0

