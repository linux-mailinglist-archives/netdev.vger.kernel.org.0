Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61F96937D9
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 16:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBLPBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 10:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBLPBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 10:01:53 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C1212067
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 07:01:52 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id 81so1095227ybp.5
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 07:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gys7w0n9m2yh6JmNfvzB5DScmKgaE88Zz996Shd4K9I=;
        b=2EYT3zmVIEaZt7eeyzYKMTC2DC7A8eUBwvlQC4o3neI2C9K6HElr3V4nSYsrrc4vpq
         D2VRUoot+0unANHIoqLYH11yDyeGg3P6FGpIfTn0XBUNgKtJNSyOBYShfnzy5d5dMrVt
         sg60bp5j1yM9uzH255BrHyB1P/wxSUCloSSoq6NJuztQADJS3GxvnjHEnogFmmMZ6qNS
         a+Cf3uxY21fmLlsVsdHnyrfxEpdSUZukutJRK+mft7arI/iaX6hdHLZUiIfauzcVCe6M
         8qziklWc0B0BUHaI++YhT1n/ZbcKpxggB6mttdDnFRP/9VaGiGLIrQet8zXXT/KzwLgN
         eoNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gys7w0n9m2yh6JmNfvzB5DScmKgaE88Zz996Shd4K9I=;
        b=SC+XkCcmjPaFVSU6Qc/TwIhuDaPKpFxqDACDy5uE1oleUKZQH8BrJWnT7I0ONCfPyZ
         0nEKRKUR0UIAEbvBjoFLmQGy6QH9YP1e+X1AOZTub4m+/8EBBcoAxU1Njfs54+M4/PLE
         5ex/HrR8zWzQS3MMlP3/f75X2Nf+fiwlTcvvUMo4OqkyEvJaoM7kjxXkGlwtNleAmCXr
         DAIxAWokEEHaeo76ZC9xQo9qoac1BQDUK/6sQs0FI2fhz/v5oQOqIoxrwStPUTOKhn66
         WybiHvHrFaPFSalG1iJb2GmDU+AWW6OU4H0faGdleJR91POp8V9jbOdHdIwg4JeA4l4v
         8RkQ==
X-Gm-Message-State: AO0yUKWz+AY7qQZYrhGBpDMiO28Ac8q3Y/b9OnWeJLPDUxiogTdguyUN
        ixIzsWHXcJAHGFHf+kX4b3dHOiW2erMwX6FxSnalRQ5PHckx7fUU
X-Google-Smtp-Source: AK7set8nS1OV+i7P9PWghDKPM+LXRkH0q7qNz2ZzCtZgOWOVccz+ZV3oTojicAu+OVk9K5UbsHx9ecxHauHlLVagCwE=
X-Received: by 2002:a25:9f12:0:b0:8c3:7bc8:7f0e with SMTP id
 n18-20020a259f12000000b008c37bc87f0emr1437766ybq.588.1676214111362; Sun, 12
 Feb 2023 07:01:51 -0800 (PST)
MIME-Version: 1.0
References: <20230212132520.12571-1-ozsh@nvidia.com> <20230212132520.12571-4-ozsh@nvidia.com>
In-Reply-To: <20230212132520.12571-4-ozsh@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 12 Feb 2023 10:01:40 -0500
Message-ID: <CAM0EoMkx=fpYP4rhkLBMSghSMpMT2g4dMVgVdaxYCBTpdc9q-g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/9] net/sched: pass flow_stats instead of
 multiple stats args
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 12, 2023 at 8:26 AM Oz Shlomo <ozsh@nvidia.com> wrote:
>
> Instead of passing 6 stats related args, pass the flow_stats.
>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
> ---
>  include/net/pkt_cls.h    | 11 +++++------
>  net/sched/cls_flower.c   |  7 +------
>  net/sched/cls_matchall.c |  6 +-----
>  3 files changed, 7 insertions(+), 17 deletions(-)
>
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index cd410a87517b..bf50829d9255 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -294,8 +294,7 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>
>  static inline void
>  tcf_exts_hw_stats_update(const struct tcf_exts *exts,
> -                        u64 bytes, u64 packets, u64 drops, u64 lastuse,
> -                        u8 used_hw_stats, bool used_hw_stats_valid)
> +                        struct flow_stats *stats)
>  {
>  #ifdef CONFIG_NET_CLS_ACT
>         int i;
> @@ -306,12 +305,12 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>                 /* if stats from hw, just skip */
>                 if (tcf_action_update_hw_stats(a)) {
>                         preempt_disable();
> -                       tcf_action_stats_update(a, bytes, packets, drops,
> -                                               lastuse, true);
> +                       tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
> +                                               stats->lastused, true);
>                         preempt_enable();
>
> -                       a->used_hw_stats = used_hw_stats;
> -                       a->used_hw_stats_valid = used_hw_stats_valid;
> +                       a->used_hw_stats = stats->used_hw_stats;
> +                       a->used_hw_stats_valid = stats->used_hw_stats_valid;
>                 }
>         }
>  #endif
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 0b15698b3531..cb04739a13ce 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -502,12 +502,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
>         tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
>                          rtnl_held);
>
> -       tcf_exts_hw_stats_update(&f->exts, cls_flower.stats.bytes,
> -                                cls_flower.stats.pkts,
> -                                cls_flower.stats.drops,
> -                                cls_flower.stats.lastused,
> -                                cls_flower.stats.used_hw_stats,
> -                                cls_flower.stats.used_hw_stats_valid);
> +       tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
>  }
>
>  static void __fl_put(struct cls_fl_filter *f)
> diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
> index 705f63da2c21..b3883d3d4dbd 100644
> --- a/net/sched/cls_matchall.c
> +++ b/net/sched/cls_matchall.c
> @@ -331,11 +331,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
>
>         tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
>
> -       tcf_exts_hw_stats_update(&head->exts, cls_mall.stats.bytes,
> -                                cls_mall.stats.pkts, cls_mall.stats.drops,
> -                                cls_mall.stats.lastused,
> -                                cls_mall.stats.used_hw_stats,
> -                                cls_mall.stats.used_hw_stats_valid);
> +       tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats);
>  }
>
>  static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
> --
> 1.8.3.1
>
