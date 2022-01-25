Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AF649B7BA
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 16:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376478AbiAYPf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 10:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350112AbiAYPdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 10:33:39 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4C9C06176F
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 07:22:55 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e2so5153225wra.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 07:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cG/42W/iCx6VSeDO0kv9NR+h9YB1RdbhOInMmW4LKb8=;
        b=yIgZcv3zFq8CZzLy/y2G41X1Du0nBHCXnyBd0kodJAZWXeIJxWmtRz+tv/qA4ZwDsc
         PU2bv6FdEcBbQELDUnxlR38i/pHnTXwZiU2m18q2rUol+prUGPAkxA1ynNNAw3zn+99D
         snAxqMdkBQbH+sa5NOqz6xDaZ9maMVd3n/a78f7y2tvnb8/e2wl5rZRyYQAWj5UbDWS2
         xtFskQchbnzhDSuTx3xSQHdnVmqniLAA9n6HXKOxipNdVg7zfnuDptnn02Oh/oZaeGR+
         JCdqFhy4MtimBoXWY7UgwpVLx29n5UhtZ4mJ5wqbuF+ojgPEJFbE2lWjKclgj02Tq9zs
         tMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cG/42W/iCx6VSeDO0kv9NR+h9YB1RdbhOInMmW4LKb8=;
        b=4zZzj5dRdLg8ESpXPn+uD+cWYvRLezwybpS6R1dXuaSZFJhnpyWEpfW8KlOsnswhaU
         wXpqRgLGMaWmEtiSm6/DE3jTucSJP2R+NTXcGyL/v0lssyZJdbXXXP+4/gpmgkk5MEWN
         tOt5r8dExHH1HXO7Du6RciponPqQgCEvcBh6G+IbT+y+pM8JfokFzyzE85+I4tSyNCSU
         lT5QcltzyMVKOCpUvUUicRkSpD/qE3BAK/7cTcZ2Pe2uSfhep3O5ofX/gvk/B21fg8TC
         6o8Gbd711BRmeyohv6UnqmzLB1XEdqvsoiBcDnvCnH7WB5lEZgT9HQTnqh4zSp5npGZX
         gDSQ==
X-Gm-Message-State: AOAM53376CbvDrRJRSI5RwtYjaiVukeKG5a3MSXTa4WixiRTcLGa/8pL
        EG/1E8D9z5YYcXNJhWHXPIyhLUzed7l0Blbf8lUF3NbcCnWkgMgu
X-Google-Smtp-Source: ABdhPJxwwTqmrLx+MIQWggb0oFQRdgGwJXfmZI6d5R30HZdgSnKu50nfGGqFRZfdP2Ai1+R5zpOflX/StrPk+KQmZCk=
X-Received: by 2002:adf:9148:: with SMTP id j66mr19240606wrj.434.1643124173614;
 Tue, 25 Jan 2022 07:22:53 -0800 (PST)
MIME-Version: 1.0
References: <1643106363-20246-1-git-send-email-baowen.zheng@corigine.com>
In-Reply-To: <1643106363-20246-1-git-send-email-baowen.zheng@corigine.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Tue, 25 Jan 2022 12:22:42 -0300
Message-ID: <CA+NMeC_BK65Oej=tL0ooyBhhEk6wK73HOaV5LR3QQkzXpbzNgQ@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v1] tc: add skip_hw and skip_sw to control
 action offload
To:     Baowen Zheng <baowen.zheng@corigine.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baowen,

I applied your patch, ran tdc.sh and in particular the vlan tests broke.

cheers,
Victor

On Tue, Jan 25, 2022 at 7:35 AM Baowen Zheng <baowen.zheng@corigine.com> wrote:
>
> Add skip_hw and skip_sw flags for user to control whether
> offload action to hardware.
>
> Also we add hw_count to show how many hardwares accept to offload
> the action.
>
> Change man page to describe the usage of skip_sw and skip_hw flag.
>
> An example to add and query action as below.
>
> $ tc actions add action police rate 1mbit burst 100k index 100 skip_sw
>
> $ tc -s -d actions list action police
> total acts 1
>     action order 0:  police 0x64 rate 1Mbit burst 100Kb mtu 2Kb action reclassify overhead 0b linklayer ethernet
>     ref 1 bind 0  installed 2 sec used 2 sec
>     Action statistics:
>     Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>     backlog 0b 0p requeues 0
>     skip_sw in_hw in_hw_count 1
>     used_hw_stats delayed
>
> Signed-off-by: baowen zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  man/man8/tc-actions.8 | 24 ++++++++++++++++++++
>  tc/m_action.c         | 63 +++++++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 77 insertions(+), 10 deletions(-)
>
> diff --git a/man/man8/tc-actions.8 b/man/man8/tc-actions.8
> index 6f1c201..5c399cd 100644
> --- a/man/man8/tc-actions.8
> +++ b/man/man8/tc-actions.8
> @@ -52,6 +52,8 @@ actions \- independently defined actions in tc
>  .I HWSTATSSPEC
>  ] [
>  .I CONTROL
> +] [
> +.I SKIPSPEC
>  ]
>
>  .I ACTISPEC
> @@ -99,6 +101,11 @@ Time since last update.
>  .IR reclassify " | " pipe " | " drop " | " continue " | " ok
>  }
>
> +.I SKIPSPEC
> +:= {
> +.IR skip_sw " | " skip_hw
> +}
> +
>  .I TC_OPTIONS
>  These are the options that are specific to
>  .B tc
> @@ -270,6 +277,23 @@ Return to the calling qdisc for packet processing, and end classification of
>  this packet.
>  .RE
>
> +.TP
> +.I SKIPSPEC
> +The
> +.I SKIPSPEC
> +indicates how
> +.B tc
> +should proceed when executing the action. Any of the following are valid:
> +.RS
> +.TP
> +.B skip_sw
> +Do not process action by software. If hardware has no offload support for this
> +action, operation will fail.
> +.TP
> +.B skip_hw
> +Do not process action by hardware.
> +.RE
> +
>  .SH SEE ALSO
>  .BR tc (8),
>  .BR tc-bpf (8),
> diff --git a/tc/m_action.c b/tc/m_action.c
> index b16882a..b9fed6f 100644
> --- a/tc/m_action.c
> +++ b/tc/m_action.c
> @@ -51,9 +51,10 @@ static void act_usage(void)
>                 "       FL := ls | list | flush | <ACTNAMESPEC>\n"
>                 "       ACTNAMESPEC :=  action <ACTNAME>\n"
>                 "       ACTISPEC := <ACTNAMESPEC> <INDEXSPEC>\n"
> -               "       ACTSPEC := action <ACTDETAIL> [INDEXSPEC] [HWSTATSSPEC]\n"
> +               "       ACTSPEC := action <ACTDETAIL> [INDEXSPEC] [HWSTATSSPEC] [SKIPSPEC]\n"
>                 "       INDEXSPEC := index <32 bit indexvalue>\n"
>                 "       HWSTATSSPEC := hw_stats [ immediate | delayed | disabled ]\n"
> +               "       SKIPSPEC := [ skip_sw | skip_hw ]\n"
>                 "       ACTDETAIL := <ACTNAME> <ACTPARAMS>\n"
>                 "               Example ACTNAME is gact, mirred, bpf, etc\n"
>                 "               Each action has its own parameters (ACTPARAMS)\n"
> @@ -210,12 +211,14 @@ int parse_action(int *argc_p, char ***argv_p, int tca_id, struct nlmsghdr *n)
>         struct rtattr *tail, *tail2;
>         char k[FILTER_NAMESZ];
>         int act_ck_len = 0;
> +       __u32 flag = 0;
>         int ok = 0;
>         int eap = 0; /* expect action parameters */
>
>         int ret = 0;
>         int prio = 0;
>         unsigned char act_ck[TC_COOKIE_MAX_SIZE];
> +       int skip_loop = 2;
>
>         if (argc <= 0)
>                 return -1;
> @@ -314,13 +317,27 @@ done0:
>                         }
>
>                         if (*argv && strcmp(*argv, "no_percpu") == 0) {
> +                               flag |= TCA_ACT_FLAGS_NO_PERCPU_STATS;
> +                               NEXT_ARG_FWD();
> +                       }
> +
> +                       /* we need to parse twice to fix skip flag out of order */
> +                       while (skip_loop--) {
> +                               if (*argv && strcmp(*argv, "skip_sw") == 0) {
> +                                       flag |= TCA_ACT_FLAGS_SKIP_SW;
> +                                       NEXT_ARG_FWD();
> +                               } else if (*argv && strcmp(*argv, "skip_hw") == 0) {
> +                                       flag |= TCA_ACT_FLAGS_SKIP_HW;
> +                                       NEXT_ARG_FWD();
> +                               }
> +                       }
> +
> +                       if (flag) {
>                                 struct nla_bitfield32 flags =
> -                                       { TCA_ACT_FLAGS_NO_PERCPU_STATS,
> -                                         TCA_ACT_FLAGS_NO_PERCPU_STATS };
> +                                       { flag, flag };
>
>                                 addattr_l(n, MAX_MSG, TCA_ACT_FLAGS, &flags,
>                                           sizeof(struct nla_bitfield32));
> -                               NEXT_ARG_FWD();
>                         }
>
>                         addattr_nest_end(n, tail);
> @@ -396,13 +413,39 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
>                                            strsz, b1, sizeof(b1)));
>                 print_nl();
>         }
> -       if (tb[TCA_ACT_FLAGS]) {
> -               struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_ACT_FLAGS]);
> +       if (tb[TCA_ACT_FLAGS] || tb[TCA_ACT_IN_HW_COUNT]) {
> +               bool skip_hw = false;
> +               if (tb[TCA_ACT_FLAGS]) {
> +                       struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_ACT_FLAGS]);
> +
> +                       if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS)
> +                               print_bool(PRINT_ANY, "no_percpu", "\tno_percpu",
> +                                          flags->value &
> +                                          TCA_ACT_FLAGS_NO_PERCPU_STATS);
> +                       if (flags->selector & TCA_ACT_FLAGS_SKIP_HW) {
> +                               print_bool(PRINT_ANY, "skip_hw", "\tskip_hw",
> +                                          flags->value &
> +                                          TCA_ACT_FLAGS_SKIP_HW);
> +                               skip_hw = !!(flags->value & TCA_ACT_FLAGS_SKIP_HW);
> +                       }
> +                       if (flags->selector & TCA_ACT_FLAGS_SKIP_SW)
> +                               print_bool(PRINT_ANY, "skip_sw", "\tskip_sw",
> +                                          flags->value &
> +                                          TCA_ACT_FLAGS_SKIP_SW);
> +               }
> +               if (tb[TCA_ACT_IN_HW_COUNT] && !skip_hw) {
> +                       __u32 count = rta_getattr_u32(tb[TCA_ACT_IN_HW_COUNT]);
> +                       if (count) {
> +                               print_bool(PRINT_ANY, "in_hw", "\tin_hw",
> +                                          true);
> +                               print_uint(PRINT_ANY, "in_hw_count",
> +                                          " in_hw_count %u", count);
> +                       } else {
> +                               print_bool(PRINT_ANY, "not_in_hw",
> +                                          "\tnot_in_hw", true);
> +                       }
> +               }
>
> -               if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS)
> -                       print_bool(PRINT_ANY, "no_percpu", "\tno_percpu",
> -                                  flags->value &
> -                                  TCA_ACT_FLAGS_NO_PERCPU_STATS);
>                 print_nl();
>         }
>         if (tb[TCA_ACT_HW_STATS])
> --
> 1.8.3.1
>
