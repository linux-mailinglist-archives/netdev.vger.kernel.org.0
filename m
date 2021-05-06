Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F7D375A6F
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 20:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhEFSvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 14:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhEFSvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 14:51:53 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38686C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 11:50:54 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a4so6699396wrr.2
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 11:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WM4s9yl6xXVA0FpRxfm/TR7P2RTq06SULrlWBV/Om1Q=;
        b=Dlk0u/4Nf5cjyBFgYY30fGnfGc0GEokj5cA5vWXYwzISehsvdcvtaL/Td1NygSb0XQ
         a2CB40PEPiYu9oa8seucY6IYlaBUl1BPAaW9MEa5AXivniCAgqc3KW90KC2s69FHSS1h
         iOYvF3VjuouIWygGj8WGx3okBmIZZNizzvRNW9j0PD4M+f8/BVY9JjKsszwCxsx322CP
         v6iL3MhRCmWGq0/emnDc2gKxSvgPzO2Ko81D02RD2WLHZq4Z0VRj2CUNs6TMShWRo3Lq
         Is2wtE6rZ9QPOfmU/1ojR+EK/IBLAroSkN+O3NZugaj3fYu47PE0VqjqmnIfm5xjtEqI
         73NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WM4s9yl6xXVA0FpRxfm/TR7P2RTq06SULrlWBV/Om1Q=;
        b=Epn31nuGrnj+n/IUy9yUOtDMHwyQG1mrS1zwT9s/dQoKCnSTZ1d763QMyUyyj+WGVf
         jDh2JLpOpOQ6Z7oA7CKLBomNPPCsjtpznlX94Qt4eSYJCntidERmaet4Cw6f+zWImI5K
         3CtYoe2u8UwzVqdQDk6F7BOopB3tNMVU/IBEcweDRQjK0JPBgpqeV7fDRfkfvRb072jU
         EILaElMko+spVbNI4ixLneykBhsHGwe8wXX+4fpBrdOTeKhkIaTUnH5+rPZR4StjCacZ
         dB8zWsSu4YDkjXSEUSE4IK4pyjh3Zm+rjYv/Q82rvHZ7CFgKP7IPOYL3Bz6zS9WQXvys
         zw3A==
X-Gm-Message-State: AOAM531OrN9CC4/OxYCP3SGX5ps6lAIbRvxSoft7NL3TjmK1vZkNTYtx
        NTLTVcyN9+F0NXGSj3CEBzc2M2hBQdZBrLLpBYp8JA==
X-Google-Smtp-Source: ABdhPJz/Aoq1r92RIE/Ig/ybB6CNUmsO6M74EmunXhnktMFZzJnAXlfh3zHnFNH4ZhXLk5DKzHL1RUQU5eA12q3ZD7s=
X-Received: by 2002:a05:6000:1290:: with SMTP id f16mr7213124wrx.52.1620327052421;
 Thu, 06 May 2021 11:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210506184300.2241623-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20210506184300.2241623-1-arjunroy.kdev@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 6 May 2021 14:50:16 -0400
Message-ID: <CACSApvaVXdNAg+nqDgngPdBbBbP9T0=BXt5NPEDjiBsitPiMcg@mail.gmail.com>
Subject: Re: [net] tcp: Specify cmsgbuf is user pointer for receive zerocopy.
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Arjun Roy <arjunroy@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 2:43 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
>
> From: Arjun Roy <arjunroy@google.com>
>
> A prior change introduces separate handling for ->msg_control
> depending on whether the pointer is a kernel or user pointer. However,
> it does not update tcp receive zerocopy (which uses a user pointer),
> which can cause faults when the improper mechanism is used.
>
> This patch simply annotates tcp receive zerocopy's use as explicitly
> being a user pointer.
>
> Fixes: 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for ->msg_control")
> Signed-off-by: Arjun Roy <arjunroy@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for the fix!

> ---
>  net/ipv4/tcp.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e14fd0c50c10..f1c1f9e3de72 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2039,6 +2039,7 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
>                 (__kernel_size_t)zc->msg_controllen;
>         cmsg_dummy.msg_flags = in_compat_syscall()
>                 ? MSG_CMSG_COMPAT : 0;
> +       cmsg_dummy.msg_control_is_user = true;
>         zc->msg_flags = 0;
>         if (zc->msg_control == msg_control_addr &&
>             zc->msg_controllen == cmsg_dummy.msg_controllen) {
> --
> 2.31.1.607.g51e8a6a459-goog
>
