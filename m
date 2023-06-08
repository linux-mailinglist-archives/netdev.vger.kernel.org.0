Return-Path: <netdev+bounces-9301-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFB097285F0
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA8A51C20B59
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8B71990D;
	Thu,  8 Jun 2023 17:06:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A10A171CB
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:06:02 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5424E210E
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:06:00 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-565cd2fc9acso7962957b3.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 10:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686243959; x=1688835959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JB0omjtmUi/Rg6T2WVdvYdMF3u/oqn2KDIpUtLQPAbY=;
        b=b0mZb9/ivmiIfYXvbLgRE4P/dpGdSsx1aAwGVq/0EEJLnlXffBwRADcOZk3TgwHFCF
         xDQjkRZFu2GoKC3K1O0gb/pYzvnboG759v9I3yX6masu7dHKV4NgEmEdKTxiPi2j0zRj
         5TNcGaMQDECj90FcVyw4BThLr11ygGYZJJzpo/aPwhZ6rl2EeuULv2a2gos6nxJs+/H0
         nfkxdp5d1s2HmY7NDOe0m84WlQn5Cx3NYc6I7ozWqSaRYjm7W9+epmdF6fGPF20H7zyP
         38xeJgkDgEFAzS6BlZHcSMH1wgPeXg3r1bi0dF45ure4AmiloZJR426xQBrGTAYg28OU
         s0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686243959; x=1688835959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JB0omjtmUi/Rg6T2WVdvYdMF3u/oqn2KDIpUtLQPAbY=;
        b=RXG3LBiFxxd9/A88P+X0Lo3HmFKIgq/Bn+224yzsKrd5O3rQ4O0W/YXwfBj9+XDoK6
         0TQxcRLRTIlnRxGq0UFma66dbzELggvRqHCEuuQSqOVcYDP81yscNylPqqYqZ5UVOdUF
         lfadjhSbBjX6Fk6juyco4+rovcfDHxvzzJ7WLLyC2+QuRzsFIKCFMCfPJ8XfkMgnffCt
         3OAbVJhOHE4LkTkNhTXJtX+XdzAJFlIQpG0x/1XB0YpFLrO/OMhV8HHQFuR8lZOHTsly
         hinJ0AllTUHKAQEL8OCXWeet5X4hZzMlmdC7Z6kTXolJx7uuX6uxzn7rwJs8j9O1qw1p
         N1KA==
X-Gm-Message-State: AC+VfDwXZ0+rKAmK0aJVxMpedg3cAk+whv7omnxhBO/k8UVpEYBx5htj
	FbBSa2TXN82gMnqEXyh8ZWUbxTULvenF6nJfeR6idA==
X-Google-Smtp-Source: ACHHUZ7dRHBpZ/5tqylZDKD/lBDjLFfUPHTPMyV7dILdOL7cusywdmoik43yZBOryD0BV3quaXfg0Ebr3V/9IHUIXB4=
X-Received: by 2002:a81:4f57:0:b0:569:51d4:e723 with SMTP id
 d84-20020a814f57000000b0056951d4e723mr284594ywb.36.1686243959542; Thu, 08 Jun
 2023 10:05:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608140246.15190-1-fw@strlen.de> <20230608140246.15190-4-fw@strlen.de>
In-Reply-To: <20230608140246.15190-4-fw@strlen.de>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 8 Jun 2023 13:05:48 -0400
Message-ID: <CAM0EoMkMxOwxNVANaYjd6GBFOkkhkNz=n9xyTnLR6=OmB9nVAw@mail.gmail.com>
Subject: Re: [PATCH net v2 3/3] net/sched: act_ipt: zero skb->cb before
 calling target
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
> xtables relies on skb being owned by ip stack, i.e. with ipv4
> check in place skb->cb is supposed to be IPCB.
>
> I don't see an immediate problem (REJECT target cannot be used anymore
> now that PRE/POSTROUTING hook validation has been fixed), but better be
> safe than sorry.
>
> A much better patch would be to either mark act_ipt as
> "depends on BROKEN" or remove it altogether. I plan to do this
> for -next in the near future.

Let me handle this part please.

> This tc extension is broken in the sense that tc lacks an
> equivalent of NF_STOLEN verdict.
> With NF_STOLEN, target function takes complete ownership of skb, caller
> cannot dereference it anymore.
>
> ACT_STOLEN cannot be used for this: it has a different meaning, caller
> is allowed to dereference the skb.
>

ACT_STOLEN requires that the target clones the packet and the caller
to free the skb.

> At this time NF_STOLEN won't be returned by any targets as far as I can
> see, but this may change in the future.
>
> It might be possible to work around this via list of allowed
> target extensions known to only return DROP or ACCEPT verdicts, but this
> is error prone/fragile.

I didnt quiet follow why ACT_STOLEN if this action frees the packet
and returns NF_STOLEN

> Existing selftest only validates xt_LOG and act_ipt is restricted
> to ipv4 so I don't think this action is used widely.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Other than that:
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

And thank you for doing this Florian.

cheers,
jamal
> ---
>  v2: add Fixes tag, fix typo in commit message, diff unchanged.
>
>  net/sched/act_ipt.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
> index 2f0b39cc4e37..ec04bcfa0f4b 100644
> --- a/net/sched/act_ipt.c
> +++ b/net/sched/act_ipt.c
> @@ -21,6 +21,7 @@
>  #include <linux/tc_act/tc_ipt.h>
>  #include <net/tc_act/tc_ipt.h>
>  #include <net/tc_wrapper.h>
> +#include <net/ip.h>
>
>  #include <linux/netfilter_ipv4/ip_tables.h>
>
> @@ -254,6 +255,7 @@ TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb=
,
>                                   const struct tc_action *a,
>                                   struct tcf_result *res)
>  {
> +       char saved_cb[sizeof_field(struct sk_buff, cb)];
>         int ret =3D 0, result =3D 0;
>         struct tcf_ipt *ipt =3D to_ipt(a);
>         struct xt_action_param par;
> @@ -280,6 +282,8 @@ TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb=
,
>                 state.out =3D skb->dev;
>         }
>
> +       memcpy(saved_cb, skb->cb, sizeof(saved_cb));
> +
>         spin_lock(&ipt->tcf_lock);
>
>         tcf_lastuse_update(&ipt->tcf_tm);
> @@ -292,6 +296,9 @@ TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb=
,
>         par.state    =3D &state;
>         par.target   =3D ipt->tcfi_t->u.kernel.target;
>         par.targinfo =3D ipt->tcfi_t->data;
> +
> +       memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
> +
>         ret =3D par.target->target(skb, &par);
>
>         switch (ret) {
> @@ -312,6 +319,9 @@ TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb=
,
>                 break;
>         }
>         spin_unlock(&ipt->tcf_lock);
> +
> +       memcpy(skb->cb, saved_cb, sizeof(skb->cb));
> +
>         return result;
>
>  }
> --
> 2.40.1
>

