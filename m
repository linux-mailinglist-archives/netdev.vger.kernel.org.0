Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6EE62E78B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241114AbiKQWAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241092AbiKQV7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:59:53 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5B5DFEB
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 13:58:30 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id s18so3530898ybe.10
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 13:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RgumxfwxThuKjg8yg5dtYwukRopRTEm6oZ8ITbTV/uo=;
        b=n0G5zTHzacXIAgd7mjoenJz/ejLGbNkXRpZgXMFWraIDIofsRa35jrgZzI2vzpdKpL
         tV0iwsPhA5gMQ7FOJHSPGarwOvUmleFDr5vJOQUVHEndQbzY/23HGZqRQ7MJ0MhZhodb
         3cD5JxvfGWMNgJY6C14G7j6ZcaPlFnKNZSpXXSwnL/fvDjEDRdPQEHF1a4fSExQzdhWB
         Ykbq3UH4TzgdXUBNtG9af4zSV65gx/dDsE2AxLAqD5xdZQ6kNJG4OX0bnE4l4Ooho7aJ
         wjkf3TM8Pdm+YiJiF2qPaF6CcQ4kklcB0W8PHt8d+h0WmSbRsEo2r2HluVOW6J/ehPo3
         YP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RgumxfwxThuKjg8yg5dtYwukRopRTEm6oZ8ITbTV/uo=;
        b=st+sL4yxLxxx8bpMQm1vtqZ5SZOwJ3dw16QsH9lmL6kMeiOkNMbkijqunM85xMu+YK
         +8mIq1GBzyEHvBgBIjR+bSSUNCHwC1ftWMegrp/sMj6ms579aYeNfq5ytDiULrvIhoNx
         7B/ZPdFuHeMKHmEpVINh1jEGxov6P7yMgtEHhMfLQTmCaAw1JeqLAEANQM59s7Qr4Dll
         +TK0K5WGszg6mFwQhY9fbdkvCz854OScMbdMBP2bTAQpL9ZeamPPPJwhJ1+wqxVSeU0D
         9Vf+NiX8PcqxI19b85Tutga9hoz78M4cnbFvZr9XYWyKceqfyND5eNgJvBRDH4f/1wRZ
         nvHw==
X-Gm-Message-State: ANoB5plMfx3lwtYki2xFc0zbu4Ie5zs/ASKhcZ6yRa9ssS0jeCaOqdjt
        ymenpP4sd+RCju9SV64JmWn0lk8ibN4q0CDQuqGnXw==
X-Google-Smtp-Source: AA0mqf4Yigljrmxq3yh0btTQMbgwSgrKFFiBC27fc/y57fyL+Q0/akvblcaxWH12hdyVzF7CHnhhPaGMuiEHJN1pwbo=
X-Received: by 2002:a05:6902:11cd:b0:6e7:f2ba:7c0f with SMTP id
 n13-20020a05690211cd00b006e7f2ba7c0fmr2115271ybu.55.1668722309460; Thu, 17
 Nov 2022 13:58:29 -0800 (PST)
MIME-Version: 1.0
References: <20221117031551.1142289-1-joel@joelfernandes.org> <20221117031551.1142289-2-joel@joelfernandes.org>
In-Reply-To: <20221117031551.1142289-2-joel@joelfernandes.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 13:58:18 -0800
Message-ID: <CANn89iK345JjXoCAPYK6hZF99zBBWRM1z7xCWbstQJLb4aBGQg@mail.gmail.com>
Subject: Re: [PATCH rcu/dev 2/3] net: Use call_rcu_flush() for in_dev_rcu_put
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> In a networking test on ChromeOS, we find that using the new CONFIG_RCU_LAZY
> causes a networking test to fail in the teardown phase.
>
> The failure happens during: ip netns del <name>
>
> Using ftrace, I found the callbacks it was queuing which this series fixes. Use
> call_rcu_flush() to revert to the old behavior. With that, the test passes.
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  net/ipv4/devinet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index e8b9a9202fec..98b20f333e00 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -328,7 +328,7 @@ static void inetdev_destroy(struct in_device *in_dev)
>         neigh_parms_release(&arp_tbl, in_dev->arp_parms);
>         arp_ifdown(dev);
>
> -       call_rcu(&in_dev->rcu_head, in_dev_rcu_put);
> +       call_rcu_flush(&in_dev->rcu_head, in_dev_rcu_put);
>  }

For this one, I suspect the issue is about device refcount lingering ?

I think we should release refcounts earlier (and only delegate the
freeing part after RCU grace period, which can be 'lazy' just fine)

Something like:

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index e8b9a9202fecd913137f169f161dfdccc16f7edf..e0258aef4211ec6a72d062963470a32776e6d010
100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -234,13 +234,21 @@ static void inet_free_ifa(struct in_ifaddr *ifa)
        call_rcu(&ifa->rcu_head, inet_rcu_free_ifa);
 }

+static void in_dev_free_rcu(struct rcu_head *head)
+{
+       struct in_device *idev = container_of(head, struct in_device, rcu_head);
+
+       kfree(rcu_dereference_protected(idev->mc_hash, 1));
+       kfree(idev);
+}
+
 void in_dev_finish_destroy(struct in_device *idev)
 {
        struct net_device *dev = idev->dev;

        WARN_ON(idev->ifa_list);
        WARN_ON(idev->mc_list);
-       kfree(rcu_dereference_protected(idev->mc_hash, 1));
+
 #ifdef NET_REFCNT_DEBUG
        pr_debug("%s: %p=%s\n", __func__, idev, dev ? dev->name : "NIL");
 #endif
@@ -248,7 +256,7 @@ void in_dev_finish_destroy(struct in_device *idev)
        if (!idev->dead)
                pr_err("Freeing alive in_device %p\n", idev);
        else
-               kfree(idev);
+               call_rcu(&idev->rcu_head, in_dev_free_rcu);
 }
 EXPORT_SYMBOL(in_dev_finish_destroy);

@@ -298,12 +306,6 @@ static struct in_device *inetdev_init(struct
net_device *dev)
        goto out;
 }

-static void in_dev_rcu_put(struct rcu_head *head)
-{
-       struct in_device *idev = container_of(head, struct in_device, rcu_head);
-       in_dev_put(idev);
-}
-
 static void inetdev_destroy(struct in_device *in_dev)
 {
        struct net_device *dev;
@@ -328,7 +330,7 @@ static void inetdev_destroy(struct in_device *in_dev)
        neigh_parms_release(&arp_tbl, in_dev->arp_parms);
        arp_ifdown(dev);

-       call_rcu(&in_dev->rcu_head, in_dev_rcu_put);
+       in_dev_put(in_dev);
 }

 int inet_addr_onlink(struct in_device *in_dev, __be32 a, __be32 b)
