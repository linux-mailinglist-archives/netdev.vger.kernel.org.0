Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413BA314D6
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfEaSiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:38:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41917 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfEaSiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:38:54 -0400
Received: by mail-pf1-f193.google.com with SMTP id q17so6709440pfq.8
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ozTqVFQntp4n5Wt/pyD4VEsaqR1R7tPWNcOmKDfhyFA=;
        b=fks+/tpC1luckRVcC5tDhRTfHxquyukNkTdwg+qnyqX5jXrd8GW/z9sxxSvmXsaLJR
         MrjYEON3rfSd9/D1C2BOvQxqE/rfWib0aFy/iLmLF2fclPYSRY2t4ClvungJ0rm4RWhk
         y3GGEXZppSvxQP9RmGQwxm0PSzXjeYxCzJopmqsphWk676rW0eP/GcLlhHLJ7eAn4l2+
         6Gfzr6FSw/hnmzDYJ/uu/FFVxoofbtghXh2Sd1epkiiAZjyUNbuzolBWllI/1TrpLYkU
         Due/AmkMlNEUENRhQ/2JszsEauwgdIQMYrzzP/S15ekbeOBu3s5D7zXPUj9abAJp6O3M
         q+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ozTqVFQntp4n5Wt/pyD4VEsaqR1R7tPWNcOmKDfhyFA=;
        b=BuM9J69FFom08aX0qxAHLPfXS+eT0DhXOo6Kzgu6fSa0PTxzZVROmsKIFpKPsvPk2P
         W8DYyC/m4XwvZ9CLaY8FnGhDARGHyrsI7JnA/R82QXvoVqA6Ro6WUVDEnncKVfC2qWAc
         bpgqGjF3pX6C4k14tZwsQi8TSpLvMo6qkxRcCltQVBF5C/Sp+/f7amvui7kA6N95aHaF
         Ej3iaJkwuaHa3DC427MVdSBhjwfWG3OtD3APGT3RClFyoNMOFZ/4GAm4SxRELMm6UQ1J
         0924gu2fgLfoSh7ZmgfpvlmXwFZVsTGH7FFIvaJBjKUXzPauDv8zt9Aqutt8oTlQ/Im6
         QdWg==
X-Gm-Message-State: APjAAAXc0hVrtfq/0RNqd8plC9Dk8u3TrTVvIVYvAWhSiFHYoHEZQ1W6
        kj17laVhy3kYf2UF3ExlQXHSWNlFYtQgH2b6F+E=
X-Google-Smtp-Source: APXvYqyNQfYELr0ihDAFUZ5UkA5xzDjI1iCoMKPjstO6kab1bx6f8SF3P1P+cCYEigvtzjcOKlZ2v6hkS+pOh5p6H1A=
X-Received: by 2002:a63:6f8e:: with SMTP id k136mr10946678pgc.104.1559327933825;
 Fri, 31 May 2019 11:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559322531.git.dcaratti@redhat.com> <a773fd1d70707d03861be674f7692a0148f6bb40.1559322531.git.dcaratti@redhat.com>
In-Reply-To: <a773fd1d70707d03861be674f7692a0148f6bb40.1559322531.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 31 May 2019 11:38:41 -0700
Message-ID: <CAM_iQpW68XR3Y6gyb0zyd3qooCwPHBM1Fm+THcS=migSNsHMzA@mail.gmail.com>
Subject: Re: [PATCH net v3 1/3] net/sched: act_csum: pull all VLAN headers
 before checksumming
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Eli Britstein <elibr@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:26 AM Davide Caratti <dcaratti@redhat.com> wrote:
> diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
> index 14bb525e355e..e8308ddcae9d 100644
> --- a/net/sched/act_csum.c
> +++ b/net/sched/act_csum.c
> @@ -574,7 +574,6 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
>                         struct tcf_result *res)
>  {
>         struct tcf_csum *p = to_tcf_csum(a);
> -       bool orig_vlan_tag_present = false;
>         unsigned int vlan_hdr_count = 0;
>         struct tcf_csum_params *params;
>         u32 update_flags;
> @@ -604,17 +603,8 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
>                 break;
>         case cpu_to_be16(ETH_P_8021AD): /* fall through */
>         case cpu_to_be16(ETH_P_8021Q):
> -               if (skb_vlan_tag_present(skb) && !orig_vlan_tag_present) {
> -                       protocol = skb->protocol;
> -                       orig_vlan_tag_present = true;
> -               } else {
> -                       struct vlan_hdr *vlan = (struct vlan_hdr *)skb->data;
> -
> -                       protocol = vlan->h_vlan_encapsulated_proto;
> -                       skb_pull(skb, VLAN_HLEN);
> -                       skb_reset_network_header(skb);
> -                       vlan_hdr_count++;
> -               }
> +               if (tc_skb_pull_vlans(skb, &vlan_hdr_count, &protocol))
> +                       goto drop;
>                 goto again;

Why do you still need to loop here? tc_skb_pull_vlans() already
contains a loop to pop all vlan tags?



>         }
>
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index d4699156974a..382ee69fb1a5 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3300,6 +3300,28 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>  }
>  EXPORT_SYMBOL(tcf_exts_num_actions);
>
> +int tc_skb_pull_vlans(struct sk_buff *skb, unsigned int *hdr_count,
> +                     __be16 *proto)


It looks like this function fits better in net/core/skbuff.c, because
I don't see anything TC specific.


> +{
> +       if (skb_vlan_tag_present(skb))
> +               *proto = skb->protocol;
> +
> +       while (eth_type_vlan(*proto)) {
> +               struct vlan_hdr *vlan;
> +
> +               if (unlikely(!pskb_may_pull(skb, VLAN_HLEN)))
> +                       return -ENOMEM;
> +
> +               vlan = (struct vlan_hdr *)skb->data;
> +               *proto = vlan->h_vlan_encapsulated_proto;
> +               skb_pull(skb, VLAN_HLEN);
> +               skb_reset_network_header(skb);

Any reason not to call __skb_vlan_pop() directly?


> +               (*hdr_count)++;
> +       }
> +       return 0;
> +}


Thanks.
