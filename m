Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CF05AB3E5
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbiIBOns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 10:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236709AbiIBOnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 10:43:23 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EC71306D5
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 07:04:31 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-11edd61a9edso4929459fac.5
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 07:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=jIBNSs6rCdRbAOJ9teFT4Fa6Go/jLzDgKCj8WaZAwnE=;
        b=U8lzxY0La7Ryyn+89TY3W4YJJ8+Qglm91u53fh+r9mWOSL7H4cjD/kzZMoMuJv1Nxl
         uIP1Hm73Rh4a0VGLhFXCgK5uxT8CGWC7Xbc1C0Cw7h2OJNPq/gmRkW25sz5hsMEQ70CV
         lAxlfvDAmHECaSRBAbYnL48o7LzKCpjIz9IRru3DhmJ9jjopPjUdE1YUibGHm+ZDEwlN
         hJ5GnAHeGaXoV7gZx2nheEGMCcSYXB45vQNaVaAhMHcMZ514BS9YVMdS+DvvGi9j0QWo
         VnyAkGgS5T1KIWU3fsKLNnfcZcsW4JtcR0pZXk/Ftcb+iqdT/v/OiTrUsnLET1Y//JgT
         ON1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=jIBNSs6rCdRbAOJ9teFT4Fa6Go/jLzDgKCj8WaZAwnE=;
        b=zU61E+GiQP+zOrRpCSv45OtsYuyziC/8afmw3DCwHfKr0wgY/Vpv5rO2zxalCL5Dnu
         IbACFucCTPLaPFabdPBJL/q52t//pp1jv8WQsf0PtktBMFkx3Te0dJ4CpkmFyf0aYMrx
         szlBe7xx91iAjJwrhqiATV7Gra7J9Y88Bz1FU+DMrz91ei2QdGbx0xpuC+tes4dKaUbH
         DIk9fYicd4JGBDL38WgSosIEqBU/61yzekhN/D8T0orbFX3NVoE2TfhYmqcvaiyRm0vn
         LhuQlJaNMxCNZ4w+dAvTqMjZ7gc56AX36MG1vD1L82ezW77nQevMf/GybCs2ds5UgD4u
         v40g==
X-Gm-Message-State: ACgBeo0zKUnUpX+dRYaXNk0HaeA3+U78uXEBfn8PzHGyksze9gpC/nWc
        6bMFPuzVN6JZI5gPV+INfOPGRxlRlfnCqQU0YvyHBQ==
X-Google-Smtp-Source: AA6agR6p0s7s90tmpd903kZy/GHcgaYZ9iZQBMhOKJ59MgpASAzcegVkj930C4T2jWUObCZOA+gBI4p00FV4w56pE4M=
X-Received: by 2002:a05:6870:d393:b0:11f:4eb6:705e with SMTP id
 k19-20020a056870d39300b0011f4eb6705emr2357099oag.106.1662127406444; Fri, 02
 Sep 2022 07:03:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220902112446.29858-1-shaozhengchao@huawei.com> <20220902112446.29858-23-shaozhengchao@huawei.com>
In-Reply-To: <20220902112446.29858-23-shaozhengchao@huawei.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 2 Sep 2022 10:03:15 -0400
Message-ID: <CAM0EoMnbSAgjxxyUuP2C-YZVDL-ydQJex=Xc_ZMzL5P9SHv9FQ@mail.gmail.com>
Subject: Re: [PATCH net-next 22/22] net: sched: act: remove redundant code in act_api
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 2, 2022 at 7:22 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> Based on previous patches of this patchset, the walk and lookup hooks in
> the tc_action_ops structure are no longer used, and redundant code logic
> branches should be removed. tcf_generic_walker() and tcf_idr_search() are
> also used only in the act_api.c, change them to static.
>

All the rest look good.
It is possible to have extra computation for a lookup/walk depending on the
action complexity. That was the point of those APIs; however, we could argue
that if a user shows up with those demands then we'll add them then.
If you want to remove the callbacks, why not do them in the first patch?

cheers,
jamal

> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  include/net/act_api.h | 10 ----------
>  net/sched/act_api.c   | 42 ++++++++++++------------------------------
>  2 files changed, 12 insertions(+), 40 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index a79d6e58519e..ebd84ef06b5b 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -118,15 +118,10 @@ struct tc_action_ops {
>                        struct tcf_result *); /* called under RCU BH lock*/
>         int     (*dump)(struct sk_buff *, struct tc_action *, int, int);
>         void    (*cleanup)(struct tc_action *);
> -       int     (*lookup)(struct net *net, struct tc_action **a, u32 index);
>         int     (*init)(struct net *net, struct nlattr *nla,
>                         struct nlattr *est, struct tc_action **act,
>                         struct tcf_proto *tp,
>                         u32 flags, struct netlink_ext_ack *extack);
> -       int     (*walk)(struct net *, struct sk_buff *,
> -                       struct netlink_callback *, int,
> -                       const struct tc_action_ops *,
> -                       struct netlink_ext_ack *);
>         void    (*stats_update)(struct tc_action *, u64, u64, u64, u64, bool);
>         size_t  (*get_fill_size)(const struct tc_action *act);
>         struct net_device *(*get_dev)(const struct tc_action *a,
> @@ -178,11 +173,6 @@ static inline void tc_action_net_exit(struct list_head *net_list,
>         rtnl_unlock();
>  }
>
> -int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
> -                      struct netlink_callback *cb, int type,
> -                      const struct tc_action_ops *ops,
> -                      struct netlink_ext_ack *extack);
> -int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index);
>  int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
>                    struct tc_action **a, const struct tc_action_ops *ops,
>                    int bind, bool cpustats, u32 flags);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 7063d2004199..2d26aec25e3a 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -636,10 +636,10 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
>         return ret;
>  }
>
> -int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
> -                      struct netlink_callback *cb, int type,
> -                      const struct tc_action_ops *ops,
> -                      struct netlink_ext_ack *extack)
> +static int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
> +                             struct netlink_callback *cb, int type,
> +                             const struct tc_action_ops *ops,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct tcf_idrinfo *idrinfo = tn->idrinfo;
>
> @@ -653,9 +653,8 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
>                 return -EINVAL;
>         }
>  }
> -EXPORT_SYMBOL(tcf_generic_walker);
>
> -int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index)
> +static int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index)
>  {
>         struct tcf_idrinfo *idrinfo = tn->idrinfo;
>         struct tc_action *p;
> @@ -674,7 +673,6 @@ int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index)
>         }
>         return false;
>  }
> -EXPORT_SYMBOL(tcf_idr_search);
>
>  static int __tcf_generic_walker(struct net *net, struct sk_buff *skb,
>                                 struct netlink_callback *cb, int type,
> @@ -945,8 +943,7 @@ int tcf_register_action(struct tc_action_ops *act,
>         struct tc_action_ops *a;
>         int ret;
>
> -       if (!act->act || !act->dump || !act->init ||
> -           (!act->net_id && (!act->walk || !act->lookup)))
> +       if (!act->act || !act->dump || !act->init || !act->net_id)
>                 return -EINVAL;
>
>         /* We have to register pernet ops before making the action ops visible,
> @@ -1658,16 +1655,10 @@ static struct tc_action *tcf_action_get_1(struct net *net, struct nlattr *nla,
>                 goto err_out;
>         }
>         err = -ENOENT;
> -       if (ops->lookup) {
> -               if (ops->lookup(net, &a, index) == 0) {
> -                       NL_SET_ERR_MSG(extack, "TC action with specified index not found");
> -                       goto err_mod;
> -               }
> -       } else {
> -               if (__tcf_idr_search(net, ops, &a, index) == 0) {
> -                       NL_SET_ERR_MSG(extack, "TC action with specified index not found");
> -                       goto err_mod;
> -               }
> +
> +       if (__tcf_idr_search(net, ops, &a, index) == 0) {
> +               NL_SET_ERR_MSG(extack, "TC action with specified index not found");
> +               goto err_mod;
>         }
>
>         module_put(ops->owner);
> @@ -1730,12 +1721,7 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
>                 goto out_module_put;
>         }
>
> -       if (ops->walk) {
> -               err = ops->walk(net, skb, &dcb, RTM_DELACTION, ops, extack);
> -       } else {
> -               err = __tcf_generic_walker(net, skb, &dcb, RTM_DELACTION, ops, extack);
> -       }
> -
> +       err = __tcf_generic_walker(net, skb, &dcb, RTM_DELACTION, ops, extack);
>         if (err <= 0) {
>                 nla_nest_cancel(skb, nest);
>                 goto out_module_put;
> @@ -2153,11 +2139,7 @@ static int tc_dump_action(struct sk_buff *skb, struct netlink_callback *cb)
>         if (nest == NULL)
>                 goto out_module_put;
>
> -       if (a_o->walk)
> -               ret = a_o->walk(net, skb, cb, RTM_GETACTION, a_o, NULL);
> -       else
> -               ret = __tcf_generic_walker(net, skb, cb, RTM_GETACTION, a_o, NULL);
> -
> +       ret = __tcf_generic_walker(net, skb, cb, RTM_GETACTION, a_o, NULL);
>         if (ret < 0)
>                 goto out_module_put;
>
> --
> 2.17.1
>
