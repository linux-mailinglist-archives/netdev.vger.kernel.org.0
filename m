Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48BE5EBF99
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiI0KVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiI0KVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:21:21 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD84B7EFA
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:21:20 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id w2so9324155pfb.0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=S+G0MRT32SoDiUVIZflc92r1aW0BhhClqRB+1x0Qh4E=;
        b=MWzweLGAmda0Ks2p0At788LlCaIA1OPT3nlf/vPeoGBYRALaz8hueBt5bVfwXjRa1S
         SVGavVSrnV/4BaBldWgqrGeCQxjz+oQnAphK3xbxwUYZt9KecG2qTImoe94Fk0sj6M2+
         1cPB4PGgXARGGVYMJfHyQo4Q+d7SZPh6fza5swQdvYV5o+wi8L4lPoyZlCVxnfjXCM9d
         fmUpwVtW2YFNvcSk50HibbEuEYxvl4jVcYRSIV5Li6dYCjVqicZUUi0aaGDVOOMBwBnR
         JpKnuMG6eRWHKLFBqBk9DeWwkg+U34lAr8TXfdJJCZdQdhf7mUOkPA1zYeMWz+G1m9sa
         Vjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=S+G0MRT32SoDiUVIZflc92r1aW0BhhClqRB+1x0Qh4E=;
        b=IaudJuIYsbTlnWLNwD4CXJvnOt0BzUShJ11qMl+b3+NK6NCSGKYQFOUdwTFtF4Wg/5
         VdKeLw3wKwWIMFb8Urt3r3ua21zmbrk0FpcqxoBSkI0J3O7AVeRFhek9FhoNHzCQsqS3
         tG5Ta/w1I6FVdY0qIV5LFPQW3A4wDCEiYkXU/0nk0hYYOjAJIjB2d1FSiTvpBdyWWl3V
         hNKhBRcrKimH4MDF2O78J/bC46m/G2zNJozicw8igGq9sXyjM6oQIp8dTJYUgZhBAjKQ
         U598OmMkCgfpiEH5KMBbvtQJVxuflZ4uRbmJdwlWZZv40up6ZlGpeiyr/LB6BVgeqcdZ
         MqCg==
X-Gm-Message-State: ACrzQf3HPGsArEcBODHqju3Yce4vCQX45SuUxID11WiypbLVMaRylY4V
        F/l0rTAeBvpjt/WzkUs+QLb01WCp2I6cmg==
X-Google-Smtp-Source: AMsMyM7oLSyKfXpzZhPLtWXxG4TuPQ6YTwLmBOrpvuxn/Z82knVIWd4L9N9gpkpwUM+q3f9e4vyUFA==
X-Received: by 2002:a63:4752:0:b0:439:5dcc:fd78 with SMTP id w18-20020a634752000000b004395dccfd78mr23189756pgk.104.1664274079479;
        Tue, 27 Sep 2022 03:21:19 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902e54700b001768517f99esm1132258plf.244.2022.09.27.03.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 03:21:19 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next 2/2] tc/tc_monitor: print netlink extack message
Date:   Tue, 27 Sep 2022 18:21:07 +0800
Message-Id: <20220927102107.191852-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220927101755.191352-1-liuhangbin@gmail.com>
References: <20220927101755.191352-1-liuhangbin@gmail.com>
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

Upstream commit "sched: add extack for tfilter_notify" will make
tc event contain extack message, which could be used for logging
offloading failures. Let's print the extack message in tc monitor.
e.g.

  # tc monitor
  added chain dev enp3s0f1np1 parent ffff: chain 0
  added filter dev enp3s0f1np1 ingress protocol all pref 49152 flower chain 0 handle 0x1
    ct_state +trk+new
    not_in_hw
          action order 1: gact action drop
           random type none pass val 0
           index 1 ref 1 bind 1

  Warning: mlx5_core: matching on ct_state +new isn't supported.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tc/tc_monitor.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tc/tc_monitor.c b/tc/tc_monitor.c
index f8816cc5..c279a4a1 100644
--- a/tc/tc_monitor.c
+++ b/tc/tc_monitor.c
@@ -42,6 +42,9 @@ static int accept_tcmsg(struct rtnl_ctrl_data *ctrl,
 	if (timestamp)
 		print_timestamp(fp);
 
+	if (n->nlmsg_type == NLMSG_DONE)
+		nl_dump_ext_ack_done(n, 0, 0);
+
 	if (n->nlmsg_type == RTM_NEWTFILTER ||
 	    n->nlmsg_type == RTM_DELTFILTER ||
 	    n->nlmsg_type == RTM_NEWCHAIN ||
-- 
2.37.2

