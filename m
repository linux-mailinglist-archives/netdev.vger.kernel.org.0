Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CA0616647
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiKBPe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiKBPez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:34:55 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5444722BE8
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 08:34:54 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id g15-20020a4a894f000000b0047f8e899623so2533166ooi.5
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 08:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lvE5dZWqhAlWk9Q0CEk4889/YQZi8Yrr9UnqaTklI8A=;
        b=A3tLLKdL7l1yQgbCZAICGhPY/NCEyKSZuTHud9wtI0JjBoVPbEV/Ly7Pxsg7USG+f2
         sHD7oFL0G9BDHR92mL3U0XyMMjgtdmCeV5b78uaWUxuEVZA7Ocy00oYzIWKNR3lo2zJv
         biMBFGEoi5ZK1d6B4Hdyo7eUZHdlEUqWgCKp01LujUAFmQrsT/t/YP8/0ImTZJSs1+nv
         uXRyYvDKH2Mg3C5LH9/vDLx7k0rQ6nSc4G/g0FGnFVodN8xOEFLEFIVr2E19WSKx303z
         gzY5W7K9sBSF3e7rWoRlNfL3rhlIZ4Jf3Zsd9x3rSzouhkWOUBYOruQHh+sC2ROqKMzB
         p8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lvE5dZWqhAlWk9Q0CEk4889/YQZi8Yrr9UnqaTklI8A=;
        b=O+ysprnU9RfsRR4ouurn6mvZXmOgTNqpQsAkqt2WQAQ8TSbJ4rrfuluRtgbobzkdxW
         CGjtv8UBjCwqATm4MDhKScjH3Jtnf+1wma5TaLsNVT5Ohx6XdjdcjWOL3tzue9/qyoWq
         bm5LX6yGtimT1bwuNnLS5zRMYNb01uqvMRuUpQujjEjL8/p/12Hvl4Q9+M8fe2iJmYoo
         iPKhabDpS7cC0T3O32euJnElryU6tc8CIop4Mt06938kESs2YufqFoGJ7Qbcj1z62w0S
         9B0l37R+Ap+t/y+krW2b1mPnzgZyryr5Uan7j9jFDbN3EBbr320Wu+qV9vKagFmi3FRd
         OBMw==
X-Gm-Message-State: ACrzQf22aKLUiKCBwJwZEZUokb+qg0ZRjiHWWlnW0LGkzoAWc4f1CfVS
        XNJ8bPEH04UtHJ/i7vmy0P+KGnD9O6YUwvxt7HOmQw==
X-Google-Smtp-Source: AMsMyM4nA3xKNg1c0OIpA5l9Dnp835zPHI4rLoG6ZgSyxiMh4kp/ianB7AaokDVXDQW0JxStXV8v89DejGPW+hQZgPA=
X-Received: by 2002:a4a:55d6:0:b0:49b:e94b:2e34 with SMTP id
 e205-20020a4a55d6000000b0049be94b2e34mr4057008oob.46.1667403293641; Wed, 02
 Nov 2022 08:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <0b153a5ab818dff51110f81550a4050538605a4b.1667252314.git.dcaratti@redhat.com>
In-Reply-To: <0b153a5ab818dff51110f81550a4050538605a4b.1667252314.git.dcaratti@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 2 Nov 2022 11:34:41 -0400
Message-ID: <CAM0EoMnpx1Ziuy_S72fr0N0iFsW1dQMPj35OQ-0SRwzLeGKyZQ@mail.gmail.com>
Subject: Re: [RFC net-next] net/sched: act_mirred: allow mirred ingress
 through networking backlog
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jiri@resnulli.us, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, wizhao@redhat.com,
        xiyou.wangcong@gmail.com, peilin.ye@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This version looks sane to me. Cong?

cheers,
jamal

On Mon, Oct 31, 2022 at 5:44 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> using TC mirrred in the ingress direction, packets are passed directly
> to the receiver in the same context. There are a couple of reasons that
> justify the proposal to use kernel networking backlog instead:
>
> a) avoid the soft lockup observed with TCP when it sends data+ack after
>    receiving packets through mirred (William sees them using OVS,
>    something similar can be obtained with a kselftest [1)]
> b) avoid packet drops caused by mirred hitting MIRRED_RECURSION_LIMIT
>    in the above scenario
>
> however, like Cong pointed out [2], we can't just change mirred redirect to
> use the networking backlog: this would break users expectation, because it
> would be impossible to know the RX status after a packet has been enqueued
> to the backlog.
>
> A possible approach can be to extend the current set of TC mirred "eaction",
> so that the application can choose to use the backlog instead of the classic
> ingress redirect. This would also ease future decisions of performing a
> complete scrub of the skb metadata for those packets, without changing the
> behavior of existing TC ingress redirect rules.
>
> Any feedback appreciated, thanks!
>
> [1] https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
> [2] https://lore.kernel.org/netdev/YzCZMHYmk53mQ+HK@pop-os.localdomain/
>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/net/tc_act/tc_mirred.h        |  3 ++-
>  include/uapi/linux/tc_act/tc_mirred.h |  1 +
>  net/sched/act_mirred.c                | 29 +++++++++++++++++++++------
>  3 files changed, 26 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/tc_act/tc_mirred.h b/include/net/tc_act/tc_mirred.h
> index 32ce8ea36950..9e10ad1adb57 100644
> --- a/include/net/tc_act/tc_mirred.h
> +++ b/include/net/tc_act/tc_mirred.h
> @@ -37,7 +37,8 @@ static inline bool is_tcf_mirred_ingress_redirect(const struct tc_action *a)
>  {
>  #ifdef CONFIG_NET_CLS_ACT
>         if (a->ops && a->ops->id == TCA_ID_MIRRED)
> -               return to_mirred(a)->tcfm_eaction == TCA_INGRESS_REDIR;
> +               return (to_mirred(a)->tcfm_eaction == TCA_INGRESS_REDIR ||
> +                       to_mirred(a)->tcfm_eaction == TCA_INGRESS_BACKLOG);
>  #endif
>         return false;
>  }
> diff --git a/include/uapi/linux/tc_act/tc_mirred.h b/include/uapi/linux/tc_act/tc_mirred.h
> index 2500a0005d05..e5939a3c9d86 100644
> --- a/include/uapi/linux/tc_act/tc_mirred.h
> +++ b/include/uapi/linux/tc_act/tc_mirred.h
> @@ -9,6 +9,7 @@
>  #define TCA_EGRESS_MIRROR 2 /* mirror packet to EGRESS */
>  #define TCA_INGRESS_REDIR 3  /* packet redirect to INGRESS*/
>  #define TCA_INGRESS_MIRROR 4 /* mirror packet to INGRESS */
> +#define TCA_INGRESS_BACKLOG 5 /* packet redirect to INGRESS (using Linux backlog) */
>
>  struct tc_mirred {
>         tc_gen;
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index b8ad6ae282c0..9526bc0ee3d2 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -33,7 +33,13 @@ static DEFINE_PER_CPU(unsigned int, mirred_rec_level);
>
>  static bool tcf_mirred_is_act_redirect(int action)
>  {
> -       return action == TCA_EGRESS_REDIR || action == TCA_INGRESS_REDIR;
> +       switch (action) {
> +       case TCA_EGRESS_REDIR:
> +       case TCA_INGRESS_REDIR:
> +       case TCA_INGRESS_BACKLOG:
> +               return true;
> +       }
> +       return false;
>  }
>
>  static bool tcf_mirred_act_wants_ingress(int action)
> @@ -44,6 +50,7 @@ static bool tcf_mirred_act_wants_ingress(int action)
>                 return false;
>         case TCA_INGRESS_REDIR:
>         case TCA_INGRESS_MIRROR:
> +       case TCA_INGRESS_BACKLOG:
>                 return true;
>         default:
>                 BUG();
> @@ -130,6 +137,7 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
>         case TCA_EGRESS_REDIR:
>         case TCA_INGRESS_REDIR:
>         case TCA_INGRESS_MIRROR:
> +       case TCA_INGRESS_BACKLOG:
>                 break;
>         default:
>                 if (exists)
> @@ -205,14 +213,23 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
>         return err;
>  }
>
> -static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
> +static int tcf_mirred_forward(int eaction, struct sk_buff *skb)
>  {
>         int err;
>
> -       if (!want_ingress)
> +       switch (eaction) {
> +       case TCA_EGRESS_MIRROR:
> +       case TCA_EGRESS_REDIR:
>                 err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
> -       else
> +               break;
> +       case TCA_INGRESS_MIRROR:
> +       case TCA_INGRESS_REDIR:
>                 err = netif_receive_skb(skb);
> +               break;
> +       case TCA_INGRESS_BACKLOG:
> +               err = netif_rx(skb);
> +               break;
> +       }
>
>         return err;
>  }
> @@ -305,7 +322,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>
>                 /* let's the caller reinsert the packet, if possible */
>                 if (use_reinsert) {
> -                       err = tcf_mirred_forward(want_ingress, skb);
> +                       err = tcf_mirred_forward(m_eaction, skb);
>                         if (err)
>                                 tcf_action_inc_overlimit_qstats(&m->common);
>                         __this_cpu_dec(mirred_rec_level);
> @@ -313,7 +330,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>                 }
>         }
>
> -       err = tcf_mirred_forward(want_ingress, skb2);
> +       err = tcf_mirred_forward(m_eaction, skb2);
>         if (err) {
>  out:
>                 tcf_action_inc_overlimit_qstats(&m->common);
> --
> 2.37.3
>
