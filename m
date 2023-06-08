Return-Path: <netdev+bounces-9302-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C09367285F8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBFF21C20BB9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4CF19911;
	Thu,  8 Jun 2023 17:08:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BA5182DA
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:08:37 +0000 (UTC)
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB0F2136
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:08:35 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-bb1f7c5495dso946138276.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 10:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686244115; x=1688836115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxyC+RS44UxMAlB5syapo/ejzzpJ3Tx9+tfTfv1MFhw=;
        b=P01SlFxcBoIk4VY1+Q0mwrrN+pGDHEzR9S5MGnD92PoKaHTRXa2PYcWq1nE7/c4RGQ
         8qoYIhKf5oxXcSKqR3bV7Rb8Acd+BuFRYCFJOcWxtQa667tZ9pAiyIYdZicOa2gIM/v2
         dY8r2Ti0+F0z3068TP944j3/KWpCEqnmDLjM7Iz2Zy4R44rJS0WdMua+DmK1BB2dE+va
         5iCOqtezKV3oLiLGddqTmQ711VWsAHyO/eA6A3iA3A4YDUMmDYLim237O34fYYgGEvLZ
         NcdOheYRj39tVM+6BhFtdX/2NojwBxwonQY8Fl3UZ54Dw+NZf3mqALhVfPdkUQ+oF5Qn
         8s+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686244115; x=1688836115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxyC+RS44UxMAlB5syapo/ejzzpJ3Tx9+tfTfv1MFhw=;
        b=hmK6x+wCRq2v5UwX8P/V8rIQg+ecltdZH2Lit+4In6uqaO176XkOhkVH8u1iBnZ7Cj
         VBIBiBZIs5kxKEgEilI6dZehvAB/NKE+4Up8lBTYEZ1gyf9uytbP4Yfj9OBYmiNhh6CF
         wvN0NbbmPLw6dXXZBQiO5WQBK4pnuhaueGe0pxI6Zoqn1rgaf/vOJt5f/1fGaYCtTjm9
         OxrPmePEs+2nnYuQFb0FEx4TpSyK4fuIJ4qr032rhcFTM8WgQEOJFpC/+w5sMSLaeuab
         uQT0DJ5AtBQkAOXhyn8xKvOs/ZYPHMK8s3egmTICvxfXV8HiVQ0mnSu8/5wZfbebvmST
         S6Nw==
X-Gm-Message-State: AC+VfDzsoqCwsYmeTI6xLw+EnmHXEM5Zp5qpqdWvBmT7JYOafO1p3eg7
	PkrWOIZpr4pLtK44/YAiSAzxNNQEGq4Klj3qF+VCsA==
X-Google-Smtp-Source: ACHHUZ7+Tjkt+U9Q1WeKF1Em4vGXxkZnZcs7nsaxw/5BbDAtF0ml5DjY9yRnj8sAx8MlISlwHeCcHex7OddfVAoUMNs=
X-Received: by 2002:a0d:df41:0:b0:567:2891:a2ec with SMTP id
 i62-20020a0ddf41000000b005672891a2ecmr317689ywe.22.1686244114870; Thu, 08 Jun
 2023 10:08:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608140246.15190-1-fw@strlen.de> <20230608140246.15190-3-fw@strlen.de>
In-Reply-To: <20230608140246.15190-3-fw@strlen.de>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 8 Jun 2023 13:08:23 -0400
Message-ID: <CAM0EoMkDHQYdL+0cgOzbEemAOfFXPJSe-z0Bgez=YbyQ56iLoQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] net/sched: act_ipt: add sanity checks on skb
 before calling target
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, xiyou.wangcong@gmail.com, 
	jiri@resnulli.us, Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 10:03=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Netfilter targets make assumptions on the skb state, for example
> iphdr is supposed to be in the linear area.
>
> This is normally done by IP stack, but in act_ipt case no
> such checks are made.
>
> Some targets can even assume that skb_dst will be valid.
> Make a minimum effort to check for this:
>
> - Don't call the targets eval function for non-ipv4 skbs.
> - Don't call the targets eval function for POSTROUTING
>   emulation when the skb has no dst set.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Other than the comment from Davide (which makes sense) I would say:
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal


> ---
>  v2: add Fixes tag, diff unchanged.
>
>  net/sched/act_ipt.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
> index ea7f151e7dd2..2f0b39cc4e37 100644
> --- a/net/sched/act_ipt.c
> +++ b/net/sched/act_ipt.c
> @@ -230,6 +230,26 @@ static int tcf_xt_init(struct net *net, struct nlatt=
r *nla,
>                               a, &act_xt_ops, tp, flags);
>  }
>
> +static bool tcf_ipt_act_check(struct sk_buff *skb)
> +{
> +       const struct iphdr *iph;
> +       unsigned int nhoff, len;
> +
> +       if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> +               return false;
> +
> +       nhoff =3D skb_network_offset(skb);
> +       iph =3D ip_hdr(skb);
> +       if (iph->ihl < 5 || iph->version !=3D 4)
> +               return false;
> +
> +       len =3D skb_ip_totlen(skb);
> +       if (skb->len < nhoff + len || len < (iph->ihl * 4u))
> +               return false;
> +
> +       return pskb_may_pull(skb, iph->ihl * 4u);
> +}
> +
>  TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb,
>                                   const struct tc_action *a,
>                                   struct tcf_result *res)
> @@ -244,9 +264,22 @@ TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *sk=
b,
>                 .pf     =3D NFPROTO_IPV4,
>         };
>
> +       if (skb->protocol !=3D htons(ETH_P_IP))
> +               return TC_ACT_UNSPEC;
> +
>         if (skb_unclone(skb, GFP_ATOMIC))
>                 return TC_ACT_UNSPEC;
>
> +       if (!tcf_ipt_act_check(skb))
> +               return TC_ACT_UNSPEC;
> +
> +       if (state.hook =3D=3D NF_INET_POST_ROUTING) {
> +               if (!skb_dst(skb))
> +                       return TC_ACT_UNSPEC;
> +
> +               state.out =3D skb->dev;
> +       }
> +
>         spin_lock(&ipt->tcf_lock);
>
>         tcf_lastuse_update(&ipt->tcf_tm);
> --
> 2.40.1
>

