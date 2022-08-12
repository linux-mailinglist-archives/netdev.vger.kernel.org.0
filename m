Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C32F591692
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 23:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiHLVEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 17:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbiHLVEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 17:04:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D716CB440B;
        Fri, 12 Aug 2022 14:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63FD8B82440;
        Fri, 12 Aug 2022 21:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE55AC433C1;
        Fri, 12 Aug 2022 21:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660338280;
        bh=Wu/Fe5PtFXEUQP9G8z5TOGhYqD7CJDN7ROGX/QlPWBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U+kryXSh74RjZMPWvB3mUiBaLIVY/1D5u6APiJeXByTIAN51gN0QIpW/1/y5++8yw
         pHycLKgNWYgeqApN9FUOBvntQFzEIrllqqRUP+WGshYtAjFBNej4psO0XYWR7gSGAS
         oABaJcZYw+lGRznhvglB4sUIUUGZXanx/jhmGKoC3zUyhghYhCCoFs7X49f6RzjiHP
         5X4JPHdzR7TrLucdMrU6fwVRLBOTCqV2se4waPw7addnlYcgT1Zw6bQys4yFwAzUPj
         hzKqX/B98vYXdmlMhsFsUdsOAgxfai0wAGZDUeJDwRtgelJzvT8afVzANJBkcWN3s5
         xuf9A/GzrSQfg==
Date:   Fri, 12 Aug 2022 14:04:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] memory leak in netlink_policy_dump_add_policy
Message-ID: <20220812140439.6bb2bb17@kernel.org>
In-Reply-To: <0000000000003fcafc05e60e466e@google.com>
References: <0000000000003fcafc05e60e466e@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/639sy1KJ9WxF2xFSvzLooDv"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/639sy1KJ9WxF2xFSvzLooDv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, 12 Aug 2022 10:04:26 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4e23eeebb2e5 Merge tag 'bitmap-6.0-rc1' of https://github...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=165f4f6a080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3a433c7a2539f51c
> dashboard link: https://syzkaller.appspot.com/bug?extid=dc54d9ba8153b216cae0
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1443be71080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e5918e080000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com

Let's see if attaching a patch works...

#syz test

--MP_/639sy1KJ9WxF2xFSvzLooDv
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-net-genl-fix-error-path-memory-leak-in-policy-dumpin.patch

From 7b3f410d5c49568deffcc8ee9881a7d3de730699 Mon Sep 17 00:00:00 2001
From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 12 Aug 2022 13:56:48 -0700
Subject: [--remember tree name--] net: genl: fix error path memory leak in
 policy dumping

If construction of the array of policies fails when recording
non-first policy we need to unwind.

Reported-by: syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
Fixes: 50a896cf2d6f ("genetlink: properly support per-op policy dumping")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 1afca2a6c2ac..57010927e20a 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1174,13 +1174,17 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 							     op.policy,
 							     op.maxattr);
 			if (err)
-				return err;
+				goto err_free_state;
 		}
 	}
 
 	if (!ctx->state)
 		return -ENODATA;
 	return 0;
+
+err_free_state:
+	netlink_policy_dump_free(ctx->state);
+	return err;
 }
 
 static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
-- 
2.37.1


--MP_/639sy1KJ9WxF2xFSvzLooDv--
