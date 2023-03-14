Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF4E6BA291
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 23:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCNWfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 18:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjCNWfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 18:35:43 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DEF4DBC1
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 15:35:41 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id e71so8960692ybc.0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 15:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678833341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3kHYHaMBUsQ8ol3KE2txBOwU0rGyUL19muFlhmsXqs=;
        b=EAdVbhPvDdttf+y1eocZissyFjp+g0VGVuVKu32WtVtItvEjhtu5LJjALH+FpT8skG
         6lGHqNmkUsdmf9gFCuz38tdgHfQwjEGYSkiqoPR2uqObiLYYb3mWNiNjjnjQZTfcxxy/
         xGr1YPD3tg2+fgmz+zU98zcoftV0fao9NJ8Ka4tx5yM4LiwZ2anyuQL8SQYJeoGLBH5K
         edXrCMTASgy8IlCMisD592Ojq+tcIrFaH5nAbkbwgKeHHd0Lceyji2p//pBhGi2m4qqj
         SLAuBKy26M4a39r+qYrMq0y+SyIyKlus+r0DjVs+fNKEca1ShkKTnGF2Yi0T3/ww8W1p
         yahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678833341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C3kHYHaMBUsQ8ol3KE2txBOwU0rGyUL19muFlhmsXqs=;
        b=NUACg/XSv3pHc4g+ZTJADG2IxjAgP/X+frIoq2JRwZTya0/9Xw9F7Rx8uexoHucmIG
         OLn76TBtvm0R3xxtFilsm+R/OI/nesTEUn8gKPBROo3pL/MHmFJXT2nNNDRPXn5VzOMe
         Hif/UT7qbmX/f5JbVwAk/R4GJ99Pzi29Cj95T8zvXnXOlmLNNPTS8R/w98xOIXtNqIVz
         amXkMcx7onpmdcNm+Zhr3ULtEyvrjXTpFYX3y++jAcmkVp4BAqmt4H8hRomhT14U9fHI
         X7wKJJ3y7E0aIdPCU/MuJoVR9VXIx21HVvuQo5DFwe+3EamMoJZ/EjBXnUmaTLHP9SMB
         nTDw==
X-Gm-Message-State: AO0yUKVO6bdRakG2O1GIk4jCVk4ApTlS+El/DZs3ZYhGqjCw4VTvUkfn
        Rer4AqPIy/Ls8I/6VPCQy/TXlQ+bISvS2YEOU/R0Lw==
X-Google-Smtp-Source: AK7set8ERfSTRNn9/QqvQpLSGCnU9Ra/t0DcDmJJ7zYlqNB8tCqcqzgAbJyeI4NZOqDhGHecPH8cYC/XiTKITHp3Ccc=
X-Received: by 2002:a05:6902:208:b0:a98:bd27:91de with SMTP id
 j8-20020a056902020800b00a98bd2791demr24528728ybs.7.1678833340921; Tue, 14 Mar
 2023 15:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230314065802.1532741-1-liuhangbin@gmail.com> <20230314065802.1532741-3-liuhangbin@gmail.com>
In-Reply-To: <20230314065802.1532741-3-liuhangbin@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 14 Mar 2023 18:35:29 -0400
Message-ID: <CAM0EoM=mcejihaG5KthJyXqjPiPiTWvhgLFNqZCthE8VJ23Q9w@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: act_api: add specific EXT_WARN_MSG for
 tc action
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

On Tue, Mar 14, 2023 at 2:58=E2=80=AFAM Hangbin Liu <liuhangbin@gmail.com> =
wrote:
>
> In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG=
 to
> report tc extact message") I didn't notice the tc action use different
> enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action=
.
> Let's add a TCA_ACT_EXT_WARN_MSG for tc action specifically and put this
> param before going to the TCA_ACT_TAB nest.
>
> Fixes: 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG to report tc e=
xtact message")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/uapi/linux/rtnetlink.h | 1 +
>  net/sched/act_api.c            | 8 ++++----
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlin=
k.h
> index 25a0af57dd5e..5ad3448a1fa7 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -789,6 +789,7 @@ enum {
>         TCA_ROOT_FLAGS,
>         TCA_ROOT_COUNT,
>         TCA_ROOT_TIME_DELTA, /* in msecs */
> +       TCA_ACT_EXT_WARN_MSG,
>         __TCA_ROOT_MAX,
>  #define        TCA_ROOT_MAX (__TCA_ROOT_MAX - 1)
>  };
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index fce522886099..f960cb534ca0 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1589,6 +1589,10 @@ static int tca_get_fill(struct sk_buff *skb, struc=
t tc_action *actions[],
>         t->tca__pad1 =3D 0;
>         t->tca__pad2 =3D 0;
>
> +       if (extack && extack->_msg &&
> +           nla_put_string(skb, TCA_ACT_EXT_WARN_MSG, extack->_msg))
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

Sorry, only thing i should have mentioned earlier - not clear from here:
Do you get two ext warns now in the same netlink message? One for the
action and one for the cls?
Something to check:
on terminal1 > tc monitor
on terminal2 > run a command which will get the offload to fail and
see what response you get

My concern is you may be getting two warnings in one message.

cheers,
jamal
> --
> 2.38.1
>
