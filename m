Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939CA6BCB32
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjCPJlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjCPJlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:41:10 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA632B9F1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:41:04 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id n125so1094136ybg.7
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678959663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQtCXBZaIMf8ugkDZeSvcU5gsvHtSe18+cbSeHsMKZo=;
        b=s+lwn+NP7xizub/BQy01eZ3gzh6HmKccm9G2Kife88f/IeJ/Wz9x4K5O+bDBiOd19g
         O/AbOpLA1B5/jSWfEeroUOEDFhVnimfMB9CXtGYGUnAIBS4nlPniKo9Fnktfp3kNsRRv
         685rcHeTnkKjpXxG4/WM2joINF7VDK8SB+VDKNdFGjGEGJ+uYxDFzrjov8WB4WvKRHiA
         JRELesHJTVXxwRj3E7jhz0rIaraAUaXi8EqSLzqQ8953Znvz4IM+Ly7aGcnIiGG75Uv+
         j93s/AKLQLycoUwRC+ur/069lwiWdCnoTuB0JeIFyimGF6ZSusD6+PimXyvE4qV8S6K9
         uqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678959663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hQtCXBZaIMf8ugkDZeSvcU5gsvHtSe18+cbSeHsMKZo=;
        b=1h0iZOJxEsM7zelroa6p+JNkUPEJfCKVysxg47/Ex/aK5tDQEiIkIjSNdNKHjB/QVI
         nS0AdKnWf+7t8voO4sC6RvqExl2fa311PxuGeFZ/1sylV1u1/G5a/vbjeuKVgLoCqt17
         KIHU2AAo74X0om0IkpNOD0LlZ1jhqfexEAZsftJDgexZpDagfK7DT8hK7I0WT52FmLAn
         cwsjZENwLBD5IkYWGVMy/EE4otgcqGw2gf/FjyL7qUZowtlRohWN+j7sYuhQL9yH8xC1
         WK9pYV8a6B26ITwpTdJyhlQfR3e4s4qLo6jLbqqYFIeTdSlBo/WG/nX1/Kpxmj6Djwcz
         RrCA==
X-Gm-Message-State: AO0yUKXfMfMY6oonIVWZS0DQN/Fb6LKaDEdXVIXOuf8ACsw1pkqLZU8y
        gkWoYB2kXFi0IhVau4jJLQkCOW0l9ERPmwO/KYnrNA==
X-Google-Smtp-Source: AK7set/whDi08nldGHa0JAJWi/pyKtjehoDBEzWbcjIfisiPzJHWN2wkucBmJNUiWKP2BLf9FYatIqZEAX0jJnXra34=
X-Received: by 2002:a05:6902:208:b0:acd:7374:f154 with SMTP id
 j8-20020a056902020800b00acd7374f154mr28005351ybs.7.1678959663367; Thu, 16 Mar
 2023 02:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230316033753.2320557-1-liuhangbin@gmail.com> <20230316033753.2320557-2-liuhangbin@gmail.com>
In-Reply-To: <20230316033753.2320557-2-liuhangbin@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 16 Mar 2023 05:40:52 -0400
Message-ID: <CAM0EoMmxDT3gVQ7J61rRcg9ObdQtNWUk7ZM1gEZCTx79m=7wzA@mail.gmail.com>
Subject: Re: [PATCHv2 net 1/2] Revert "net/sched: act_api: move
 TCA_EXT_WARN_MSG to the correct hierarchy"
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 11:38=E2=80=AFPM Hangbin Liu <liuhangbin@gmail.com>=
 wrote:
>
> This reverts commit 923b2e30dc9cd05931da0f64e2e23d040865c035.
>
> This is not a correct fix as TCA_EXT_WARN_MSG is not a hierarchy to
> TCA_ACT_TAB. I didn't notice the TC actions use different enum when addin=
g
> TCA_EXT_WARN_MSG. To fix the difference I will add a new WARN enum in
> TCA_ROOT_MAX as Jamal suggested.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/sched/act_api.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 34c508675041..fce522886099 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1596,12 +1596,12 @@ static int tca_get_fill(struct sk_buff *skb, stru=
ct tc_action *actions[],
>         if (tcf_action_dump(skb, actions, bind, ref, false) < 0)
>                 goto out_nlmsg_trim;
>
> +       nla_nest_end(skb, nest);
> +
>         if (extack && extack->_msg &&
>             nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
>                 goto out_nlmsg_trim;
>
> -       nla_nest_end(skb, nest);
> -
>         nlh->nlmsg_len =3D skb_tail_pointer(skb) - b;
>
>         return skb->len;

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> 2.38.1
>
