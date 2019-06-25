Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F96A55813
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfFYTqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:46:05 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32913 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbfFYTqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:46:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so10036006pfq.0;
        Tue, 25 Jun 2019 12:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=CvpGRQIfyA4kHAw6O6Qm/lsMzBb8T0R2UCjutO7iey0=;
        b=o+aJk9f2CxqvUgKZvbf5ajY+7guRRvKlqLWkhdQ7mXYjuusbCSXWsMdm6Li1wiQL2B
         rzsNK2NEDBvMcsqbycYMZ/lI0AAXMLnX+ZPMp3xMRtiEraYIv6sI18zlGzACRMtjTsOO
         3UnnBDNA1twSyoWr3r9PwGm5IGtp2hYOG+VB8cAOIjIoGs001qOBb3TQAno0pGjDyEx9
         f/28iSWq9i05wGwiqD025BC/fovzAVEeCiBzVu3UQ570iS1vnTx3nnAizQeTG2TKf2MS
         tGHUHl7DyfYkokex0VoE4Ec4LCZK4AQy2hmM/xxcAemMIZ8eq6EXtLwPS90kPmvH4YIg
         Qq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=CvpGRQIfyA4kHAw6O6Qm/lsMzBb8T0R2UCjutO7iey0=;
        b=lnCL80EUrwetP9u12n9pWBzCo6Rk1BtKsG4qmRvwCOCbeBgXCGRvzp28m19Sluv6lW
         tEH6bPR6IeRAq/DNCUdjBHHZ8dymJQHSJTnfz+KH8vWgzAVFxGPVgmQkvJ+XArkIoTGH
         rUXOqt5rrL4WzVe2L4ORBlv00E5EL31ejlwHpHVA7JiXnfDlEkdWbwA9AljcbObr2qy8
         cNOsxzAQRyein4C59G6LRw4qs69kzOE1CdYNwqIE2/GlGQjfWShsDa/E6DrJRYYQ6TDg
         8CKbdeLWubdrfb27A3JtgEi7kJicgsQDtPvq/SpqIJESHsKQ/mIF/MxMpb6/to04b+zH
         W5BA==
X-Gm-Message-State: APjAAAWYA7j0m2rbnHINEPT4cg8vCPskOM3IIfBlGnNCtMYyiwlywTQy
        I1fu2YrIt8lHPkHcqAHhvkM=
X-Google-Smtp-Source: APXvYqx8sY3iFA0v3H9RPqWYjbhv8UDOaU+yy0WLBP2zSAq6krunuMWOTMLZpAKJ35iE6riRZqKQTg==
X-Received: by 2002:a17:90a:2163:: with SMTP id a90mr575441pje.3.1561491964038;
        Tue, 25 Jun 2019 12:46:04 -0700 (PDT)
Received: from [172.20.52.61] ([2620:10d:c090:200::3:e848])
        by smtp.gmail.com with ESMTPSA id 133sm17098349pfa.92.2019.06.25.12.46.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 12:46:03 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Nathan Chancellor" <natechancellor@gmail.com>
Cc:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        "Nathan Huckleberry" <nhuck@google.com>
Subject: Re: [PATCH] xsk: Properly terminate assignment in
 xskq_produce_flush_desc
Date:   Tue, 25 Jun 2019 12:46:02 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <34F07894-FDE7-44F8-B7F2-E2003D550AD2@gmail.com>
In-Reply-To: <20190625182352.13918-1-natechancellor@gmail.com>
References: <20190625182352.13918-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25 Jun 2019, at 11:23, Nathan Chancellor wrote:

> Clang warns:
>
> In file included from net/xdp/xsk_queue.c:10:
> net/xdp/xsk_queue.h:292:2: warning: expression result unused
> [-Wunused-value]
>         WRITE_ONCE(q->ring->producer, q->prod_tail);
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/compiler.h:284:6: note: expanded from macro 'WRITE_ONCE'
>         __u.__val;                                      \
>         ~~~ ^~~~~
> 1 warning generated.
>
> The q->prod_tail assignment has a comma at the end, not a semi-colon.
> Fix that so clang no longer warns and everything works as expected.
>
> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/544
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Nice find.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>


> ---
>  net/xdp/xsk_queue.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index 88b9ae24658d..cba4a640d5e8 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -288,7 +288,7 @@ static inline void xskq_produce_flush_desc(struct 
> xsk_queue *q)
>  	/* Order producer and data */
>  	smp_wmb(); /* B, matches C */
>
> -	q->prod_tail = q->prod_head,
> +	q->prod_tail = q->prod_head;
>  	WRITE_ONCE(q->ring->producer, q->prod_tail);
>  }
>
> -- 
> 2.22.0
