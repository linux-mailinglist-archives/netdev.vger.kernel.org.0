Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFCF2348F2
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 18:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbgGaQMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 12:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730550AbgGaQMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 12:12:23 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232C3C061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 09:12:23 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id j8so19820116ioe.9
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 09:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Z7peyZr6hzG7Ltk4e6jEID+TRCIFtbbqTh/SKpxhQQ=;
        b=pp0ouXSW3DBo2qlf5LqBLtvjfnCL8Nh3XNbtg/y/qXI9fqus1WpO+oi2nBWt5aEj5f
         M1LeqsRFmzA7UGkDkuUp0lf3kl1S8946emTK6IBBzoCd5E+VKX7g65nBwLg3D8ahqg35
         XT1TV3Y0HlF+gmvKopwHAdEHYuw0n0nUKoPgVpWb/SNuMymGo4uRLHqgzhXVAnz2pcb4
         LeQkGK44CLDzGX71z4mOuttaZPtg1tGm8Byt8EQbfVWW0vMHIHyuS52fvoiFSzOHEHQP
         LAfMuI4u2d4mheEFu1hiuCuILEKK/cDUTCrAWo1GzFFCnhy6rIxODr6mia3+SN/IUiB8
         cBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Z7peyZr6hzG7Ltk4e6jEID+TRCIFtbbqTh/SKpxhQQ=;
        b=TVYO0bOMKIQ0nYThrtwHsLRPrBSgH1UVDGASDcUwjJgYZwt2PN2LKeCm33twY6K0DM
         0kO3p00XHOXV8giMWW0flGPIf6eeShiNFUkeaz6Ouu4PctH8HnVg6S9HLT/b3bvyFaf7
         d/nAbJJRDvRzULXzY1zsX0MHyPtrYGycEE9wfFLVv8B6B1hEDdXMIgBl3+iCz6HGyN39
         tKTnGMnnZOGzGLpqaz8TsmSRm99O4nU4CQ0NWT/OzfmcJH6FXIIyNIc64edf72g3aTol
         psg93r+pPAX1+ogK4FtybscLLuG5OLGTCQk/OxRCvcTI8OCP5CWE5R7MC9PBzU4LdvML
         Nj4Q==
X-Gm-Message-State: AOAM533NRRjovBkBS+xu2Ew51WgPXbcFHO7OkFg6kZRHEEjU5O6FDXrF
        v9FE2BBUSHXIUWpyaxR+K2PW9AXpD9VahaDMB3ONhA==
X-Google-Smtp-Source: ABdhPJzcfhEk02l/8toMRM7GW6eB2VPS6KC3lzeMoMCRXHU1BX1y7oZp/aU1ezPS5W6rqAezaPS5Go5SwW7EsFi6k98=
X-Received: by 2002:a6b:b356:: with SMTP id c83mr3874404iof.99.1596211942230;
 Fri, 31 Jul 2020 09:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200730205657.3351905-1-kafai@fb.com> <20200730205723.3353838-1-kafai@fb.com>
In-Reply-To: <20200730205723.3353838-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Jul 2020 09:12:10 -0700
Message-ID: <CANn89i+f4se896OPGx6dPKZuObeJR2gaTExqoAHmDK=r7cTmaw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/9] tcp: Add unknown_opt arg to tcp_parse_options
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 1:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> In the latter patch, the bpf prog only wants to be called to handle
> a header option if that particular header option cannot be handled by
> the kernel.  This unknown option could be written by the peer's bpf-prog.
> It could also be a new standard option that the running kernel does not
> support it while a bpf-prog can handle it.
>
> In a latter patch, the bpf prog will be called from tcp_validate_incoming()
> if there is unknown option and a flag is set in tp->bpf_sock_ops_cb_flags.
>
> Instead of using skb->cb[] in an earlier attempt, this patch
> adds an optional arg "bool *unknown_opt" to tcp_parse_options().
> The bool will be set to true if it has encountered an option
> that the kernel does not recognize.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c |  2 +-
>  include/net/tcp.h                |  3 ++-
>  net/ipv4/syncookies.c            |  2 +-
>  net/ipv4/tcp_input.c             | 40 +++++++++++++++++++++-----------
>  net/ipv4/tcp_minisocks.c         |  4 ++--
>  net/ipv6/syncookies.c            |  2 +-
>  6 files changed, 34 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 30e08bcc9afb..dedca6576bb9 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -3949,7 +3949,7 @@ static void build_cpl_pass_accept_req(struct sk_buff *skb, int stid , u8 tos)
>          */
>         memset(&tmp_opt, 0, sizeof(tmp_opt));
>         tcp_clear_options(&tmp_opt);
> -       tcp_parse_options(&init_net, skb, &tmp_opt, 0, NULL);
> +       tcp_parse_options(&init_net, skb, &tmp_opt, 0, NULL, NULL);
>
>         req = __skb_push(skb, sizeof(*req));
>         memset(req, 0, sizeof(*req));
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 895e7aabf136..d49d8f1c961a 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -413,7 +413,8 @@ int tcp_mmap(struct file *file, struct socket *sock,
>  #endif
>  void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
>                        struct tcp_options_received *opt_rx,
> -                      int estab, struct tcp_fastopen_cookie *foc);
> +                      int estab, struct tcp_fastopen_cookie *foc,
> +                      bool *unknown_opt);
>  const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
>

Instead of changing signatures of many functions (and make future
stable backports challenging)
how about adding a field into 'struct tcp_options_received' ?

Sorry for not suggesting this earlier :/
