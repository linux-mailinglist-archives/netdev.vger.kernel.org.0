Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322906EE438
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 16:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbjDYOsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 10:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbjDYOsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 10:48:01 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A738B55AF
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 07:47:58 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6a5dd070aa1so2296431a34.3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 07:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682434078; x=1685026078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MlX+YkI7D1Xho4C4JDUmc95/1mrxitzENKBQAehchsw=;
        b=KQym+ch72ik4LagcLSnKwkn9DHaihhxjEoEtHFxU0pKd8dXEwAoM80HvyprIeDQKLF
         Ec+F7FhCFK60kapOH/93oyfg3pFk0pWRjTy+3hoL3N7z/zUh6Kj2gPqYWat/IRmcbUec
         ZN/CE0jNcaD0oj7oa6Qk86iNdD+o9HWMKOvAp/TiKu36QNBdqRfLx2dXzT501isv1n6P
         Y9+Ow81HJAgz7f/h7V6ZC3bHAhGIpL03IG0bvhlPvX6k2BNHG2vDchEOYKCBewi/cVr6
         AoEoAG2cBKesvy4+WCoqgers54I706oecvUX6EZQ39PbPeWh92jCwzauAOxtFvbkTYv8
         jPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682434078; x=1685026078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MlX+YkI7D1Xho4C4JDUmc95/1mrxitzENKBQAehchsw=;
        b=RpuYdoFC6Cbhq6aU5mCoi3lkFzkerEr73WLQlufIKu8ohfPB9DMyYbmPLDhMWoqL+5
         d6xLsPlN3RerwkpeQiPuqGPI8IIhLjo72IcP06oNrrUE9kEkkXk/cJm6nPqcCqFkhRlQ
         vTW2VYJFziE/9SgE6HEFyl8e/JQ21xlAOjCXc14JFdJ8VIj2AAxzB7aIrCHM6zZKK4gg
         Kohuvm+UEc/HX94dYNT3PdLlhXf7kAHtarbVAkygA/DDlAbq9CBJ9gop86NzBrDpQZQP
         bwcUWtBXbCGba20DwzedsV8YqeaOkt1N1wrdLOp9Eq04ipMN1jkWrQRHQOYQnrA1NDpH
         ACRw==
X-Gm-Message-State: AAQBX9eYcMaB36mM1dwa/8gVnosbokkyDdSklQsX60uoEkSm3C9CwRUl
        yxv97NzddJFXN4UOGc5X0zYl4QzhUNL4G/nhDGo=
X-Google-Smtp-Source: AKy350YMnuszTlaxzdogRvRbbqLMM75GcF0KYCE2d+SigTEmWz6+GPImamlI3OjQOAbVxxpR/4H4qQ==
X-Received: by 2002:a9d:7347:0:b0:6a4:319a:6d7f with SMTP id l7-20020a9d7347000000b006a4319a6d7fmr9730036otk.9.1682434077883;
        Tue, 25 Apr 2023 07:47:57 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:8626:e4ab:d4a8:f0f])
        by smtp.gmail.com with ESMTPSA id m7-20020a0568301e6700b006a5e0165d3esm5862657otr.19.2023.04.25.07.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 07:47:57 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net-next] net/sched: act_pedit: free pedit keys on bail from offset check
Date:   Tue, 25 Apr 2023 11:47:25 -0300
Message-Id: <20230425144725.669262-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel reports a memleak on a syzkaller instance:
   BUG: memory leak
   unreferenced object 0xffff88803d45e400 (size 1024):
     comm "syz-executor292", pid 563, jiffies 4295025223 (age 51.781s)
     hex dump (first 32 bytes):
       28 bd 70 00 fb db df 25 02 00 14 1f ff 02 00 02  (.p....%........
       00 32 00 00 1f 00 00 00 ac 14 14 3e 08 00 07 00  .2.........>....
     backtrace:
       [<ffffffff81bd0f2c>] kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
       [<ffffffff81bd0f2c>] slab_post_alloc_hook mm/slab.h:772 [inline]
       [<ffffffff81bd0f2c>] slab_alloc_node mm/slub.c:3452 [inline]
       [<ffffffff81bd0f2c>] __kmem_cache_alloc_node+0x25c/0x320 mm/slub.c:3491
       [<ffffffff81a865d9>] __do_kmalloc_node mm/slab_common.c:966 [inline]
       [<ffffffff81a865d9>] __kmalloc+0x59/0x1a0 mm/slab_common.c:980
       [<ffffffff83aa85c3>] kmalloc include/linux/slab.h:584 [inline]
       [<ffffffff83aa85c3>] tcf_pedit_init+0x793/0x1ae0 net/sched/act_pedit.c:245
       [<ffffffff83a90623>] tcf_action_init_1+0x453/0x6e0 net/sched/act_api.c:1394
       [<ffffffff83a90e58>] tcf_action_init+0x5a8/0x950 net/sched/act_api.c:1459
       [<ffffffff83a96258>] tcf_action_add+0x118/0x4e0 net/sched/act_api.c:1985
       [<ffffffff83a96997>] tc_ctl_action+0x377/0x490 net/sched/act_api.c:2044
       [<ffffffff83920a8d>] rtnetlink_rcv_msg+0x46d/0xd70 net/core/rtnetlink.c:6395
       [<ffffffff83b24305>] netlink_rcv_skb+0x185/0x490 net/netlink/af_netlink.c:2575
       [<ffffffff83901806>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:6413
       [<ffffffff83b21cae>] netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
       [<ffffffff83b21cae>] netlink_unicast+0x5be/0x8a0 net/netlink/af_netlink.c:1365
       [<ffffffff83b2293f>] netlink_sendmsg+0x9af/0xed0 net/netlink/af_netlink.c:1942
       [<ffffffff8380c39f>] sock_sendmsg_nosec net/socket.c:724 [inline]
       [<ffffffff8380c39f>] sock_sendmsg net/socket.c:747 [inline]
       [<ffffffff8380c39f>] ____sys_sendmsg+0x3ef/0xaa0 net/socket.c:2503
       [<ffffffff838156d2>] ___sys_sendmsg+0x122/0x1c0 net/socket.c:2557
       [<ffffffff8381594f>] __sys_sendmsg+0x11f/0x200 net/socket.c:2586
       [<ffffffff83815ab0>] __do_sys_sendmsg net/socket.c:2595 [inline]
       [<ffffffff83815ab0>] __se_sys_sendmsg net/socket.c:2593 [inline]
       [<ffffffff83815ab0>] __x64_sys_sendmsg+0x80/0xc0 net/socket.c:2593

The recently added static offset check missed a free to the key buffer when
bailing out on error.

Fixes: e1201bc781c2 ("net/sched: act_pedit: check static offsets a priori")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index fb93d4c1faca..fc945c7e4123 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -258,7 +258,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		if (!offmask && cur % 4) {
 			NL_SET_ERR_MSG_MOD(extack, "Offsets must be on 32bit boundaries");
 			ret = -EINVAL;
-			goto put_chain;
+			goto out_free_keys;
 		}
 
 		/* sanitize the shift value for any later use */
@@ -291,6 +291,8 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 
 	return ret;
 
+out_free_keys:
+	kfree(nparms->tcfp_keys);
 put_chain:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-- 
2.34.1

