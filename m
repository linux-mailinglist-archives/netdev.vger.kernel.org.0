Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539134CC160
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 16:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiCCPee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 10:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiCCPec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 10:34:32 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01136141E34
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 07:33:45 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id 185so4165877qkh.1
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 07:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ig9NGme6dunkp+n7dkfisBk2ONzUXxQk28VQCuHiDnQ=;
        b=gaYbBK/nWwqBWs6yfsGlZUVA5MB+JwE+ZRFqJusdJ3ZcCFYEKJzHxv4XlqIEcYRGDp
         XaQ2tOXjfPMpXm8K3lxwgBl214MGsKB3saSLfW8H9+WU37inMjZL60y3w5lPyyS1UitC
         0S5JAiBpz0l5SmbbaF0kJmALC6Ty3bPbhK6+yKNwajYJn0xKLiR2wGPITR+9J1c3Gu6p
         u9aGlIjYun0Bbv9MZU2IT4cspwVQ3qvTC9rG2KncwB+FUJKLf6sHeuVSBKrGQOtRUoJv
         bf8MC0bkaF1H+5a1nH7tK0PbeRgVvS8NAebMKqf5POe97RLcWHZjbazlOtGZxTd6GWDO
         ss/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ig9NGme6dunkp+n7dkfisBk2ONzUXxQk28VQCuHiDnQ=;
        b=vzB7XotrPS68Y2dtwOUv/bwWVxBVyWkRc6E/u4QMsLfXw90Nd2Tcl3TdFUTKfhwMeq
         KIKMV8IS+k7DYzcoTGMWEoC17FDWsCSF/UVvpSBmUkrSSBwmFp2JfIniyV/CW6d9htPU
         ny6benMZpG+ynMZjkerGn5my6UoBHJfqY1zUGSBY5lsjp1GrG04SAkUJMSXZbOEEfx28
         O317yypq/gwQnwqG8rSqS/vPMiAXldjGfOE5i/j2nGR7ddyovPjwkI0LEHNTl7YVMK/4
         aJ4bIs1ptRgZHaJOgYfTR0pAXilR2ZcBHNdE62+HgGZ9jOZDczX1LOOqssX0khz3TKg8
         UmpQ==
X-Gm-Message-State: AOAM532l0zTCXbyiuf5x3BLN1kwX67uQVh87nMvs/OImR4L7RJWUGMMG
        s9CUjGBv/5vf9S+mBjpPanlzo1dH1gXxDLop0gGPS4ci12WN2A==
X-Google-Smtp-Source: ABdhPJx3m2CIRaGY5rtWvQOlDPTXq2KsgpdanJ33r8tVA20c/W7IHxQ9LO/QW+Fn5FRdTkNKAGKFcPOH3fD8ydBNJqQ=
X-Received: by 2002:a05:620a:15b9:b0:508:1a13:c3ce with SMTP id
 f25-20020a05620a15b900b005081a13c3cemr18807668qkk.296.1646321624886; Thu, 03
 Mar 2022 07:33:44 -0800 (PST)
MIME-Version: 1.0
References: <01806a230fab4a6122f407fe96486cee2f6318dd.1646317132.git.dcaratti@redhat.com>
In-Reply-To: <01806a230fab4a6122f407fe96486cee2f6318dd.1646317132.git.dcaratti@redhat.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 3 Mar 2022 10:33:28 -0500
Message-ID: <CADVnQy=LVAmN-vQ9OxryquBLsZOfhjv7JUEim96-5Cwq-7b5dA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2] ss: display advertised TCP receive
 window and out-of-order counter
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, sbrivio@redhat.com,
        tph@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 10:19 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> these members of TCP_INFO have been included in v5.4.
>
> tested with:
>  # ss -nti
>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  misc/ss.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/misc/ss.c b/misc/ss.c
> index f7d369142d93..5e7e84ee819e 100644
> --- a/misc/ss.c
> +++ b/misc/ss.c
> @@ -854,6 +854,8 @@ struct tcpstat {
>         unsigned int        reord_seen;
>         double              rcv_rtt;
>         double              min_rtt;
> +       unsigned int        rcv_ooopack;
> +       unsigned int        snd_wnd;
>         int                 rcv_space;
>         unsigned int        rcv_ssthresh;
>         unsigned long long  busy_time;
> @@ -2654,6 +2656,10 @@ static void tcp_stats_print(struct tcpstat *s)
>                 out(" notsent:%u", s->not_sent);
>         if (s->min_rtt)
>                 out(" minrtt:%g", s->min_rtt);
> +       if (s->rcv_ooopack)
> +               out(" rcv_ooopack:%u", s->rcv_ooopack);
> +       if (s->snd_wnd)
> +               out(" snd_wnd:%u", s->snd_wnd);
>  }
>
>  static void tcp_timer_print(struct tcpstat *s)
> @@ -3088,6 +3094,8 @@ static void tcp_show_info(const struct nlmsghdr *nlh, struct inet_diag_msg *r,
>                 s.reord_seen = info->tcpi_reord_seen;
>                 s.bytes_sent = info->tcpi_bytes_sent;
>                 s.bytes_retrans = info->tcpi_bytes_retrans;
> +               s.rcv_ooopack = info->tcpi_rcv_ooopack;
> +               s.snd_wnd = info->tcpi_snd_wnd;
>                 tcp_stats_print(&s);
>                 free(s.dctcp);
>                 free(s.bbr_info);
> --

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks for adding these!

neal
