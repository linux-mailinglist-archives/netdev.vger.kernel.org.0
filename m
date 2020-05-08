Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6F01CB0FB
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 15:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgEHNvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 09:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726904AbgEHNvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 09:51:43 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F23AC05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 06:51:43 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c10so1564413qka.4
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 06:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4rjmf0HiWsNkEuyKdmRN/KU2HIDzCJFo+pFGzbQdFlg=;
        b=USzjpXXlVw9+JUGUd5u1/Nd7NL1Mh+Xc+ctZEwg3ULkYwUFDjtxN5XCr76H745DuL6
         axftEDyTvpelDIkneiBErRLHWG0YtiQBRdUY8WU314kbk2goO0ZHhBpkctUmTlb+Hcgl
         t+FtpkMM35SlEvaVVtPN4Lv/hjbXxFmd7l7ESUYFWfkNzXVbHawe21/SIDxJpTeDm/UP
         VxYINHdR/IiMRAPBmMLYxZiEcKhKBtDAElin99hKtLxA+onF1ucIsLePux2zkvcgr019
         tG/ChLQevkYR7UzQpBub9TrjT+6wi4bMz5QvQnpzAs5XfCNDBv6kdbpo/e5veIGmzBlb
         twCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4rjmf0HiWsNkEuyKdmRN/KU2HIDzCJFo+pFGzbQdFlg=;
        b=nlIA/e8B9I8pxGrCRItvkyh0GI24+Elw9nzroM04QmrfKJb78MwbQGfyxvrzZcV4nW
         Hiq74VEnU5CwjfGkotYfbtAX9NuX8zbP1Hpkb3LLF9W/PyUxMU7JjWiX+WpFxniio5OR
         ITaqdND0BgxoVgQtOkYJ0qBHGhczGLQeV04cdYP/p4DnaWG53Md0bLQU/1uWrL6/oon+
         JHER3gzz22htecZcET2zP02Aml8+XmaiqpHGKJqE4q2SnI2qPuzLs74h003WsWE0NWo1
         cXVyStc5fUwSWgfXrMaMEkkS35kDb9Cw1TN2oLdBn7wOuaX0qSRe57RL5gWA2/nskIXk
         4SYg==
X-Gm-Message-State: AGi0PubKmzAo+0q83Uz66R6wviUXPwJSWgTKhz6Umx7AMI+rfGLPF59p
        OHbNQgeCpOfi85MKtga30uM3MWbG
X-Google-Smtp-Source: APiQypKcCYjuitDxaR0VCHrGYxRffv0QFAjythsxBbJk9mxZS9vwwUPl35iW1w4jizhWfB5GbT79iA==
X-Received: by 2002:a05:620a:1521:: with SMTP id n1mr2945057qkk.430.1588945902330;
        Fri, 08 May 2020 06:51:42 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id u190sm1137993qkb.102.2020.05.08.06.51.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 06:51:41 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id c2so959144ybi.7
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 06:51:40 -0700 (PDT)
X-Received: by 2002:a25:3187:: with SMTP id x129mr5028349ybx.428.1588945899597;
 Fri, 08 May 2020 06:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSeDRPh2XEa6QnKYX-ROdBEhaQ0W-ak9z3npZKn7mQuHyA@mail.gmail.com>
 <20200508005021.9998-1-kelly@onechronos.com>
In-Reply-To: <20200508005021.9998-1-kelly@onechronos.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 8 May 2020 09:51:03 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfCfK049956d6HJ-jP5QX5rBcMCXm+2qQfQcEb7GSgvsg@mail.gmail.com>
Message-ID: <CA+FuTSfCfK049956d6HJ-jP5QX5rBcMCXm+2qQfQcEb7GSgvsg@mail.gmail.com>
Subject: Re: [PATCH v2] net: tcp: fixes commit 98aaa913b4ed ("tcp: Extend
 SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg")
To:     Kelly Littlepage <kelly@onechronos.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Iris Liu <iris@onechronos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Mike Maloney <maloney@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 7, 2020 at 9:18 PM Kelly Littlepage <kelly@onechronos.com> wrote:
>
> The stated intent of the original commit is to is to "return the timestamp
> corresponding to the highest sequence number data returned." The current
> implementation returns the timestamp for the last byte of the last fully
> read skb, which is not necessarily the last byte in the recv buffer. This
> patch converts behavior to the original definition, and to the behavior of
> the previous draft versions of commit 98aaa913b4ed ("tcp: Extend
> SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which also match this
> behavior.
>
> Co-developed-by: Iris Liu <iris@onechronos.com>
> Signed-off-by: Iris Liu <iris@onechronos.com>
> Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
> ---
> Thanks and credit to Willem de Bruijn for the revised commit language

Thanks for resubmitting. I did not mean to put the Fixes tag in the
subject line.

The Fixes tag goes at the top of the block of signs-offs. If unclear,
please look at a couple of examples on the mailing list or in git log.

The existing subject from v1 was fine. It is now too long. Could you
resubmit a v3?

Thanks




>
>  net/ipv4/tcp.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 6d87de434377..e72bd651d21a 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2154,13 +2154,15 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
>                         tp->urg_data = 0;
>                         tcp_fast_path_check(sk);
>                 }
> -               if (used + offset < skb->len)
> -                       continue;
>
>                 if (TCP_SKB_CB(skb)->has_rxtstamp) {
>                         tcp_update_recv_tstamps(skb, &tss);
>                         cmsg_flags |= 2;
>                 }
> +
> +               if (used + offset < skb->len)
> +                       continue;
> +
>                 if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
>                         goto found_fin_ok;
>                 if (!(flags & MSG_PEEK))
> --
> 2.26.2
>
>
> --
> This email and any attachments thereto may contain private, confidential,
> and privileged material for the sole use of the intended recipient. If you
> are not the intended recipient or otherwise believe that you have received
> this message in error, please notify the sender immediately and delete the
> original. Any review, copying, or distribution of this email (or any
> attachments thereto) by others is strictly prohibited. If this message was
> misdirected, OCX Group Inc. does not waive any confidentiality or privilege.
