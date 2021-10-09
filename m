Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31725427E09
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 01:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhJIXlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 19:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhJIXlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 19:41:22 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464FAC061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 16:39:24 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id r43-20020a05683044ab00b0054716b40005so16434704otv.4
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 16:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p/Emhr+yUSmNJoF/EGPSsnodjWMktN9GA7L6N/qIeY0=;
        b=crlmmccUFa4vt31xz7wqzsPRX8kteLpRbtjs6F6/ubMoe0yvmcFRfXwlExMWkQB1rx
         eUmq9aNuPB9u4yOD8hahr3c3wztUfHKDfyofEm1dMGy+i/kM2YEd1ptCEMWWYYZlBAjK
         X7JY4o3njXGi7Tb44Nm57O4upuxhUHrguhxDU7KnkYvkz/NF2Q3iZG21/2tmpCHgGMlA
         n1+/RTenQbSVAhBPVbNqxtSBky+/aw4aCzEb5vItx9Ky2vhTHkrPBL8+ivKO9C0RmV27
         ivmqwK7xvCafGfXB+IMkLiUVMG25iNzJSY4/Uu9UynOzP90xkJ4EsNxNDezg6Q9h/CXC
         AuAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p/Emhr+yUSmNJoF/EGPSsnodjWMktN9GA7L6N/qIeY0=;
        b=nduz4bud1BqTmXqZ7LR0aLCqPpg9UczE7VzAPaxofutRe9tNAmG3NIOQA4c8vkThby
         whErcxwbG0Y4CR6e8Az3Z3TBDlnBA0cSVxeY+00nJ0gvdYupIr3PcULO8CRuGm7xjj4W
         RaJZPvJmqG2yD16OjIDxS+pd9OGbe+e8Imkuu5PMwXJdgnlEh/Ke048ng/Ig+GzFs1vT
         4JuKxMtXrKvKqhCIiMizBmjIOeuCfajkk+ebct6HgyDSvET92C3I0tB33P5M4cTf3Mfr
         Dx4Q+aP02UGrTW4SGNonvLOn1WuFwB8Dbf0vKeWX1EkhHg0OPO2ttUFdqvlXPnMMWWWY
         xsrg==
X-Gm-Message-State: AOAM533wcM9kgMMTCL2jtGTGPXhBdhxR61cYGNz/xN3y1//IKQ89zEZo
        yEJw6KSzRM9/Aj+rG9Wr4dw=
X-Google-Smtp-Source: ABdhPJyIo8pxBrTE8CWJtqYlndpiZKzP1KNVy9x6s1HNWR0xbrWNB/3I1pz8kuq8ENcBxBbjizKQVg==
X-Received: by 2002:a9d:7594:: with SMTP id s20mr10106918otk.298.1633822762926;
        Sat, 09 Oct 2021 16:39:22 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id e12sm792274otq.4.2021.10.09.16.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 16:39:22 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 0/2] Support for IOAM encap modes
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, stephen@networkplumber.org
References: <20211005151020.32533-1-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d920c307-a04f-4fc1-0d57-cf6c2a60ecfb@gmail.com>
Date:   Sat, 9 Oct 2021 17:39:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211005151020.32533-1-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/21 9:10 AM, Justin Iurman wrote:
> v2:
>  - Fix the size of ioam6_mode_types (thanks David Ahern)
>  - Remove uapi diff from patch #1 (already merged inside iproute2-next)
> 
> Following the series applied to net-next (see [1]), here are the corresponding
> changes to iproute2.
> 
> In the current implementation, IOAM can only be inserted directly (i.e., only
> inside packets generated locally) by default, to be compliant with RFC8200.
> 
> This patch adds support for in-transit packets and provides the ip6ip6
> encapsulation of IOAM (RFC8200 compliant). Therefore, three ioam6 encap modes
> are defined:
> 
>  - inline: directly inserts IOAM inside packets (by default).
> 
>  - encap:  ip6ip6 encapsulation of IOAM inside packets.
> 
>  - auto:   either inline mode for packets generated locally or encap mode for
>            in-transit packets.
> 
> With current iproute2 implementation, it is configured this way:
> 
> $ ip -6 r [...] encap ioam6 trace prealloc [...]
> 
> The old syntax does not change (for backwards compatibility) and implicitly uses
> the inline mode. With the new syntax, an encap mode can be specified:
> 
> (inline mode)
> $ ip -6 r [...] encap ioam6 mode inline trace prealloc [...]
> 
> (encap mode)
> $ ip -6 r [...] encap ioam6 mode encap tundst fc00::2 trace prealloc [...]
> 
> (auto mode)
> $ ip -6 r [...] encap ioam6 mode auto tundst fc00::2 trace prealloc [...]
> 
> A tunnel destination address must be configured when using the encap mode or the
> auto mode.
> 
>   [1] https://lore.kernel.org/netdev/163335001045.30570.12527451523558030753.git-patchwork-notify@kernel.org/T/#m3b428d4142ee3a414ec803466c211dfdec6e0c09
> 

applied to iproute2-next. Thanks,

