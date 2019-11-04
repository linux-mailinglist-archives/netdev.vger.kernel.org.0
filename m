Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69EBFEE519
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 17:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfKDQtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 11:49:51 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42137 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfKDQtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 11:49:51 -0500
Received: by mail-ed1-f65.google.com with SMTP id m13so7356864edv.9
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 08:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g+SMsGrRa1GeZMM6c/PNZdwLwZhhXORlRu1w4rThXjY=;
        b=OrB9fsccC7ysQoKq4VhCPssZ2hjSXn7liy9P/9ymVOe878R5Bko8USOSCbTQVt/Kse
         ML3bFKx4FNzuuXSHKjKeseUMg86PqX0bH9tWeuOkHXJvmXpZrUVV/Y302cfDCVwCVrwn
         uer0Xho8y4cOC/ZnaOJN2Dp1X+hLaVrOJ1U/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g+SMsGrRa1GeZMM6c/PNZdwLwZhhXORlRu1w4rThXjY=;
        b=A8VLsUGR7bWeAlj5SbFrVXSeQKEfPMhGXZUKIMYQr/6rR19BIpncPmeVxcoLB8aGDJ
         LRTPW4ngDYTfkLdqjRiXVoFT3rLylJ86nJJqzDhTl7p7I8FZC/AK9Pac2gnoNZnaRUZ6
         62ApFt8hE5H8CdOmZld4EzmX0xlQdggRNa9Zx3+NnEn/+I687hX0Off0nmT/zyQB7cQQ
         xB1M+ak6cIXvoUG4t9JbGkmLDIqm9EFL7mGhLW4GdTGOfKe8A3NlBBY1ERHwUaPt6f+J
         REkwkpQsk34URLoZrmU5mk2V6S53zC8wDTVT9AmIPyo4h5CzvAb7o6jPJmDDblD95gSL
         LMqQ==
X-Gm-Message-State: APjAAAWQLNROHHfFaBKnETHVcznxsDCASOzdA0Lok4FfuJEjRz9Llltw
        oSQY6610re/H46CPLLhVEV3klOSCRY3khZTSeQnymw==
X-Google-Smtp-Source: APXvYqyZc/zcJPzTpd+tZZvjHW2JxUA09n5E+qBIBy4fY15N8fg096WvIK2OWOoHMdgiuGUJSjpRJ87iK/kIRGKGwJY=
X-Received: by 2002:aa7:c343:: with SMTP id j3mr8835955edr.4.1572886188950;
 Mon, 04 Nov 2019 08:49:48 -0800 (PST)
MIME-Version: 1.0
References: <20191030140907.18561-1-vladbu@mellanox.com> <20191030142040.19404-1-vladbu@mellanox.com>
In-Reply-To: <20191030142040.19404-1-vladbu@mellanox.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 4 Nov 2019 08:49:37 -0800
Message-ID: <CAJieiUiemsOJ6YkerOCA5XwduRLDEKZeHgXNpy0K3S9fXcm=tQ@mail.gmail.com>
Subject: Re: [PATCH iproute2 net-next v2] tc: implement support for action flags
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 7:20 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>
> Implement setting and printing of action flags with single available flag
> value "no_percpu" that translates to kernel UAPI TCA_ACT_FLAGS value
> TCA_ACT_FLAGS_NO_PERCPU_STATS. Update man page with information regarding
> usage of action flags.
>
> Example usage:
>
>  # tc actions add action gact drop no_percpu
>  # sudo tc actions list action gact
>  total acts 1
>
>         action order 0: gact action drop
>          random type none pass val 0
>          index 1 ref 1 bind 0
>         no_percpu

would be nice to just call it no_percpu_stats to match the flag name ?.
Current choice of word leaves room for possible conflict with other
percpu flags in the future..


>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> ---
>
> Notes:
>     Changes V1 -> V2:
>
>     - Rework the change to use action API TCA_ACT_FLAGS instead of
>       per-action flags implementation.
>
>  include/uapi/linux/pkt_cls.h |  5 +++++
>  man/man8/tc-actions.8        | 14 ++++++++++++++
>  tc/m_action.c                | 19 +++++++++++++++++++
>  3 files changed, 38 insertions(+)
>
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index a6aa466fac9e..c6ad22f76ede 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -16,9 +16,14 @@ enum {
>         TCA_ACT_STATS,
>         TCA_ACT_PAD,
>         TCA_ACT_COOKIE,
> +       TCA_ACT_FLAGS,
>         __TCA_ACT_MAX
>  };
>
> +#define TCA_ACT_FLAGS_NO_PERCPU_STATS 1 /* Don't use percpu allocator for
> +                                        * actions stats.
> +                                        */
> +
>  #define TCA_ACT_MAX __TCA_ACT_MAX
>  #define TCA_OLD_COMPAT (TCA_ACT_MAX+1)
>  #define TCA_ACT_MAX_PRIO 32
> diff --git a/man/man8/tc-actions.8 b/man/man8/tc-actions.8
> index f46166e3f685..bee59f7247fa 100644
> --- a/man/man8/tc-actions.8
> +++ b/man/man8/tc-actions.8
> @@ -47,6 +47,8 @@ actions \- independently defined actions in tc
>  ] [
>  .I COOKIESPEC
>  ] [
> +.I FLAGS
> +] [
>  .I CONTROL
>  ]
>
> @@ -71,6 +73,10 @@ ACTNAME
>  :=
>  .BI cookie " COOKIE"
>
> +.I FLAGS
> +:=
> +.I no_percpu
> +
>  .I ACTDETAIL
>  :=
>  .I ACTNAME ACTPARAMS
> @@ -186,6 +192,14 @@ As such, it can be used as a correlating value for maintaining user state.
>  The value to be stored is completely arbitrary and does not require a specific
>  format. It is stored inside the action structure itself.
>
> +.TP
> +.I FLAGS
> +Action-specific flags. Currently, the only supported flag is
> +.I no_percpu
> +which indicates that action is expected to have minimal software data-path
> +traffic and doesn't need to allocate stat counters with percpu allocator.
> +This option is intended to be used by hardware-offloaded actions.
> +
>  .TP
>  .BI since " MSTIME"
>  When dumping large number of actions, a millisecond time-filter can be
> diff --git a/tc/m_action.c b/tc/m_action.c
> index 36c744bbe374..4da810c8c0aa 100644
> --- a/tc/m_action.c
> +++ b/tc/m_action.c
> @@ -250,6 +250,16 @@ done0:
>                                 addattr_l(n, MAX_MSG, TCA_ACT_COOKIE,
>                                           &act_ck, act_ck_len);
>
> +                       if (*argv && strcmp(*argv, "no_percpu") == 0) {
> +                               struct nla_bitfield32 flags =
> +                                       { TCA_ACT_FLAGS_NO_PERCPU_STATS,
> +                                         TCA_ACT_FLAGS_NO_PERCPU_STATS };
> +
> +                               addattr_l(n, MAX_MSG, TCA_ACT_FLAGS, &flags,
> +                                         sizeof(struct nla_bitfield32));
> +                               NEXT_ARG_FWD();
> +                       }
> +
>                         addattr_nest_end(n, tail);
>                         ok++;
>                 }
> @@ -318,6 +328,15 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
>                                            strsz, b1, sizeof(b1)));
>                 print_string(PRINT_FP, NULL, "%s", _SL_);
>         }
> +       if (tb[TCA_ACT_FLAGS]) {
> +               struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_ACT_FLAGS]);
> +
> +               if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS)
> +                       print_bool(PRINT_ANY, "no_percpu", "\tno_percpu",
> +                                  flags->value &
> +                                  TCA_ACT_FLAGS_NO_PERCPU_STATS);
> +               print_string(PRINT_FP, NULL, "%s", _SL_);
> +       }
>
>         return 0;
>  }
> --
> 2.21.0
>
