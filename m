Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8126161A38B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiKDVpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiKDVpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:45:22 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F942A941;
        Fri,  4 Nov 2022 14:45:21 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id s20so3914578qkg.5;
        Fri, 04 Nov 2022 14:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7oLqHaYLF1PV2f1LvUIG3iOG6FofvlQJ6c3hA3fRLN0=;
        b=ABWr+xz2w5CiXhslo0iICXqZWx4ruH2v3opMgab4fgRBNS5LfcETT3ykUlF5zVlmfB
         /Nq44jS4+NB87Gr4ycN9z15E0Zi/e4y1QnN+N1dCH3om4l2a8bnatWiEr7rdVMPV/8bZ
         XkDUhjsvuQKIlomA5NVHSvj32z6sydXQML8aPtjrqCGJV3feJPSpmoJMu7jkw1HvLSo+
         mQcAK72PVqsUkK4Y+S7dN0ZpQqz2VM5tqY/WkihwMjPvzpQQtkkAdXWYnxnr+WHwEZ+K
         VbimA5tJzYyjDXyZN3OMuGLqp4SzlVZ6+okcudis5TD6d+nN/YH8tnfo3jqczPKcPc+c
         2QSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7oLqHaYLF1PV2f1LvUIG3iOG6FofvlQJ6c3hA3fRLN0=;
        b=0c6OwIO+WSilFZBHYlr0NK4WT6bcyWZp2lPcu4yAZVG94C133ZFlGy9YDLYzBM4SKc
         r9SfMqJzJRqCXYhH/W9+ak90r6vhior6eJGDFqG0eTWZCo+IOR/bEIHSEFq+u50X317n
         g5mB2yJOa6hPgcLgZ8rXs267A7SztOYGPahybFRo+jECPQ6GSJMyHA731rH0HExFrqYG
         0Ipfdsz5mYBpDsmq/6suGxkYX8nWxlzPCg5Xh4ilq/HfqeWWmo2cjnAmcI9lJ31ZjHKP
         SqbOcVB6zMycs1Ep+/CJAPoP4mHvatQWDxOiqYBOV9JidOyKsxS3Q5vdKsDGnp6lNs/i
         yPAg==
X-Gm-Message-State: ACrzQf1Th47NbdoENeUm/uC/D4F4eVR54vbSbpuchbfDXyw63uv8ImM2
        fzq36enF/brToq5PuhMeSgdsQ1HaJfQqxA==
X-Google-Smtp-Source: AMsMyM44ufR+INCyIT8lgkXw5bqzu03XAIWNpNyPDhK3IRdoSEbF/4/BiPGrIqjBu0K/Lgv8R1/NSg==
X-Received: by 2002:ae9:df86:0:b0:6fa:774:16e3 with SMTP id t128-20020ae9df86000000b006fa077416e3mr348271qkf.46.1667598320452;
        Fri, 04 Nov 2022 14:45:20 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id k1-20020ac81401000000b003434d3b5938sm366185qtj.2.2022.11.04.14.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 14:45:20 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, chenzhen126@huawei.com,
        caowangbao@huawei.com
Subject: [PATCH net 2/2] sctp: clear out_curr if all frag chunks of current msg are pruned
Date:   Fri,  4 Nov 2022 17:45:16 -0400
Message-Id: <51dfb5a4952fb612b3d31e3d0ea62580be398509.1667598261.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1667598261.git.lucien.xin@gmail.com>
References: <cover.1667598261.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A crash was reported by Zhen Chen:

  list_del corruption, ffffa035ddf01c18->next is NULL
  WARNING: CPU: 1 PID: 250682 at lib/list_debug.c:49 __list_del_entry_valid+0x59/0xe0
  RIP: 0010:__list_del_entry_valid+0x59/0xe0
  Call Trace:
   sctp_sched_dequeue_common+0x17/0x70 [sctp]
   sctp_sched_fcfs_dequeue+0x37/0x50 [sctp]
   sctp_outq_flush_data+0x85/0x360 [sctp]
   sctp_outq_uncork+0x77/0xa0 [sctp]
   sctp_cmd_interpreter.constprop.0+0x164/0x1450 [sctp]
   sctp_side_effects+0x37/0xe0 [sctp]
   sctp_do_sm+0xd0/0x230 [sctp]
   sctp_primitive_SEND+0x2f/0x40 [sctp]
   sctp_sendmsg_to_asoc+0x3fa/0x5c0 [sctp]
   sctp_sendmsg+0x3d5/0x440 [sctp]
   sock_sendmsg+0x5b/0x70

and in sctp_sched_fcfs_dequeue() it dequeued a chunk from stream
out_curr outq while this outq was empty.

Normally stream->out_curr must be set to NULL once all frag chunks of
current msg are dequeued, as we can see in sctp_sched_dequeue_done().
However, in sctp_prsctp_prune_unsent() as it is not a proper dequeue,
sctp_sched_dequeue_done() is not called to do this.

This patch is to fix it by simply setting out_curr to NULL when the
last frag chunk of current msg is dequeued from out_curr stream in
sctp_prsctp_prune_unsent().

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: Zhen Chen <chenzhen126@huawei.com>
Tested-by: Caowangbao <caowangbao@huawei.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/outqueue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index c99fe3dc19bc..20831079fb09 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -403,6 +403,11 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 		sout = SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 		sout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
 
+		/* clear out_curr if all frag chunks are pruned */
+		if (asoc->stream.out_curr == sout &&
+		    list_is_last(&chk->frag_list, &chk->msg->chunks))
+			asoc->stream.out_curr = NULL;
+
 		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		sctp_chunk_free(chk);
 		if (msg_len <= 0)
-- 
2.31.1

