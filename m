Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D73A6BCB35
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjCPJlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjCPJlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:41:39 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948DC5D474
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:41:38 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id r1so1102442ybu.5
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678959698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmOqI1m6p0B/FzSBzUQ3//Vzf9daQzkFv9z8HjztKfc=;
        b=W0kOOR8R4zu2t+jLuunNtRLi3lgpYSfoilKcZJrArBYQeh4wpspGSSY5/3SW/miPlE
         7nls77TUd7xWc2/ucgQL9h2NqESMI0ij+MQ+Q/aN0pqW5Ca80TCU840yYazS9aGP19CW
         0BDmm7PS9y07hGfdbHAAm2dOnO1MP5SM/OHylu1P06KRTRKkwfodAXaYSOvOM7Xq95vH
         3n4T5Qvz0RV+1S32icqXWQT2/+LpstDi6rXuRqoJ8R4OwQ13P8A/QI/WqAFfCRMufQFT
         /usUVsPcoye+uaLlD2S8II+fR74hyULIswyQaXGdO7QaMs1xghkVl4lYqF94MXJWyUH7
         VgUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678959698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QmOqI1m6p0B/FzSBzUQ3//Vzf9daQzkFv9z8HjztKfc=;
        b=xpltMntZLOZsF8HY5+3VpzZe8qPEi0rE8ldvH2bT76ipiC4moCHvqrsnQn51StquPc
         HDLD3wBr2YH4sjlixNjKDwch/+l69hU2NxIYb91hdlfTLLRdkWASu7GlUizy01swZsfL
         1JjCYtiBw5r6qJsQIsIE+xz4fpbJKQ95OZLPK4L1sVU4cAAO4U3b5PToedbCCtOfdEp5
         ivzfJIF7Vo/EngPCm1qtgkQfFI7RW1wQrv/8IinCi//+P6MzWg6wvlwcmoWF7BkmSvOe
         +Zib7VlEDY4X/2TktBtIoTqt6lcy9/M7EiHe5LyL3IE2R2oQsvS2MOXFFJDvbcAYLrDz
         8zMg==
X-Gm-Message-State: AO0yUKXmD0JcLn1gJ1JZqaA9/3ICZZ6A7OMoKuQ+uIPw1tUcr3gGZf8f
        b626kEbGXj7r0I30lTU9t959Kt0Wl3ZTgkMBKR/I4xJRudrHASI+EEY=
X-Google-Smtp-Source: AK7set+jIEADGcBj9TiaLmcHhxVfNAnQQswyn8UbsBpaczAdHYRaaSGCGDrzlW0nKC0yGTV/KHc1A+UnE0XHPWExRFo=
X-Received: by 2002:a5b:cd1:0:b0:a48:4a16:d85e with SMTP id
 e17-20020a5b0cd1000000b00a484a16d85emr27614867ybr.7.1678959697836; Thu, 16
 Mar 2023 02:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230316033753.2320557-1-liuhangbin@gmail.com> <20230316033753.2320557-3-liuhangbin@gmail.com>
In-Reply-To: <20230316033753.2320557-3-liuhangbin@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 16 Mar 2023 05:41:26 -0400
Message-ID: <CAM0EoMnx=NY4hJAcSu2ri0KTjsyobVVJKf5E-AXcHBBM6oj9tA@mail.gmail.com>
Subject: Re: [PATCHv2 net 2/2] net/sched: act_api: add specific EXT_WARN_MSG
 for tc action
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
> In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG
> to report tc extact message") I didn't notice the tc action use different
> enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action=
.
> Let's add a TCA_ROOT_EXT_WARN_MSG for tc action specifically and put this
> param before going to the TCA_ACT_TAB nest.
>
> Fixes: 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG to report tc e=
xtact message")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
> ---
> v2: rename TCA_ACT_EXT_WARN_MSG to TCA_ROOT_EXT_WARN_MSG
> ---
>  include/uapi/linux/rtnetlink.h | 1 +
>  net/sched/act_api.c            | 8 ++++----
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlin=
k.h
> index 25a0af57dd5e..51c13cf9c5ae 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -789,6 +789,7 @@ enum {
>         TCA_ROOT_FLAGS,
>         TCA_ROOT_COUNT,
>         TCA_ROOT_TIME_DELTA, /* in msecs */
> +       TCA_ROOT_EXT_WARN_MSG,
>         __TCA_ROOT_MAX,
>  #define        TCA_ROOT_MAX (__TCA_ROOT_MAX - 1)
>  };
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index fce522886099..296fc1afedd8 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1589,6 +1589,10 @@ static int tca_get_fill(struct sk_buff *skb, struc=
t tc_action *actions[],
>         t->tca__pad1 =3D 0;
>         t->tca__pad2 =3D 0;
>
> +       if (extack && extack->_msg &&
> +           nla_put_string(skb, TCA_ROOT_EXT_WARN_MSG, extack->_msg))
> +               goto out_nlmsg_trim;
> +
>         nest =3D nla_nest_start_noflag(skb, TCA_ACT_TAB);
>         if (!nest)
>                 goto out_nlmsg_trim;
> @@ -1598,10 +1602,6 @@ static int tca_get_fill(struct sk_buff *skb, struc=
t tc_action *actions[],
>
>         nla_nest_end(skb, nest);
>
> -       if (extack && extack->_msg &&
> -           nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
> -               goto out_nlmsg_trim;
> -
>         nlh->nlmsg_len =3D skb_tail_pointer(skb) - b;
>
>         return skb->len;
> --
> 2.38.1
>
