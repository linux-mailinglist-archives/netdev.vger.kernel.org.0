Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1370F4AE54
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 01:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbfFRXEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 19:04:24 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42073 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730377AbfFRXEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 19:04:24 -0400
Received: by mail-ed1-f67.google.com with SMTP id z25so24085725edq.9;
        Tue, 18 Jun 2019 16:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3TR6tEUm9Kh0gp6UR5ta5DiQqGzKi27dpCMg1A1Ozdk=;
        b=gV1UP54fKFEHi7N2gclALBWPSQb7uPABhuk3qejGCA7O5zEESpWqKRQgvyy8XqNXiL
         hMfg6/7+oVMGs4Sh405ktmvMoF1QmR9R4br71mQJpVULSL4yUUM2qb9kx37a6HrdKNHz
         eJTOgk9i8UB47DvrTtDcezGmHoJFyjfURsFExvfiGeVAs+cwjJsUAbxDOk0yHfTyvbJA
         ROKwCzKmR4bCiJwsEL5zKA4dd+iOsGFMkPTkIAUn6BJP4eOId7EXfzO3baTCMYdFe5pj
         M9Pruulp7GRapbdwh523B1ZM/ifxQ0S4/2TSeWaIY8yDMgsioKQgJMzrRsf2kUhPQWEc
         3c8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3TR6tEUm9Kh0gp6UR5ta5DiQqGzKi27dpCMg1A1Ozdk=;
        b=qiiGxNjoAcOwThgkoGXyRaxl0KabVuFqus7eQ9zRK90spdK2u5zzWd6XHcKksOAtOR
         fIXzmsCUoeA8HhGSA0K0U/JRxSNlbxHXgfCeyZzRDOAgmrTk/76Z3deWyj4RumSwYtJk
         fUmNd5wMkjZdjQqKR0gJXZwd8PfTbmjMb0s4kdCRq0KwX432gMg+W7a59lNdeo+AFX0f
         mdApU9C/PK5dsVJpZs+6EIoP1030PKKn8nmWp80W3HsplethYq71jcGwheZOzxIxkNSO
         wbqGTNP0LOlLo2OhDPMGvarKOBjffTh6PSNNTO/WAMI1ucDQ/NDy6fTJhRU+V+hHkDPq
         uHXw==
X-Gm-Message-State: APjAAAWWpoOpPJW9LRvVRKVjdnhOpF03c49eSHlTCp/iut/V1yGEbd7I
        S1V5ZAJIni6w6JDf8GJQomk=
X-Google-Smtp-Source: APXvYqz9Lz7HewPGraid664wDZ3Gui5stBAJmA5OIyNhTdb4POG0GO+D93mxbkqNOHrMG7D+4RBnog==
X-Received: by 2002:a50:86b9:: with SMTP id r54mr100907329eda.162.1560899062601;
        Tue, 18 Jun 2019 16:04:22 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id o7sm2977595ejm.67.2019.06.18.16.04.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 16:04:22 -0700 (PDT)
Date:   Tue, 18 Jun 2019 16:04:20 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
Message-ID: <20190618230420.GA84107@archlinux-epyc>
References: <20190618211440.54179-1-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618211440.54179-1-mka@chromium.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 02:14:40PM -0700, Matthias Kaehlcke wrote:
> empty_child_inc/dec() use the ternary operator for conditional
> operations. The conditions involve the post/pre in/decrement
> operator and the operation is only performed when the condition
> is *not* true. This is hard to parse for humans, use a regular
> 'if' construct instead and perform the in/decrement separately.
> 
> This also fixes two warnings that are emitted about the value
> of the ternary expression being unused, when building the kernel
> with clang + "kbuild: Remove unnecessary -Wno-unused-value"
> (https://lore.kernel.org/patchwork/patch/1089869/):
> 
> CC      net/ipv4/fib_trie.o
> net/ipv4/fib_trie.c:351:2: error: expression result unused [-Werror,-Wunused-value]
>         ++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;
> 

As an FYI, this is also being fixed in clang:

https://bugs.llvm.org/show_bug.cgi?id=42239

https://reviews.llvm.org/D63369

> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> I have no good understanding of the fib_trie code, but the
> disentangled code looks wrong, and it should be equivalent to the
> cryptic version, unless I messed it up. In empty_child_inc()
> 'full_children' is only incremented when 'empty_children' is -1. I
> suspect a bug in the cryptic code, but am surprised why it hasn't
> blown up yet. Or is it intended behavior that is just
> super-counterintuitive?
> 
> For now I'm leaving it at disentangling the cryptic expressions,
> if there is a bug we can discuss what action to take.
> ---
>  net/ipv4/fib_trie.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 868c74771fa9..cf7788e336b7 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -338,12 +338,18 @@ static struct tnode *tnode_alloc(int bits)
>  
>  static inline void empty_child_inc(struct key_vector *n)
>  {
> -	++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;
> +	tn_info(n)->empty_children++;
> +
> +	if (!tn_info(n)->empty_children)
> +		tn_info(n)->full_children++;
>  }
>  
>  static inline void empty_child_dec(struct key_vector *n)
>  {
> -	tn_info(n)->empty_children-- ? : tn_info(n)->full_children--;
> +	if (!tn_info(n)->empty_children)
> +		tn_info(n)->full_children--;
> +
> +	tn_info(n)->empty_children--;
>  }
>  
>  static struct key_vector *leaf_new(t_key key, struct fib_alias *fa)
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 
