Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB983347FC
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhCJTcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbhCJTcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:32:00 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC6CC061760;
        Wed, 10 Mar 2021 11:31:59 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id h13so1380977qvu.6;
        Wed, 10 Mar 2021 11:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6v601w2whp5h3eZk9WOM8NIBFfSAfNFUUoB88kQgXr0=;
        b=m0m0c6+nmNoh/5E084U7CL0XYtkCOKaR0cyPKbATQpSTBG91EOdhfyjFq2571ZLDXk
         3ZksiUrEPa9dKiX9JvtfJRARNzSla/M0jCckVdQJikTwu+SewcLjjjec+aAN6wDG50K7
         448fvgmyvt5iMk7fWhcH5V5mtyjF4sCqfvQFUOCiUwqLVOJw5F5z7izWmVVaQ3TCH47j
         Yqg/D0jyrzy24rNmuy9/G/FyuaJ0SP2h/Zv1lZY4ZkAEBgKp5PF8kuEpMS0fn3+mgPGk
         keetPZ2Y1Y3N2XMMxObtpHVLdUs4UumEE+Dh7r5sqcG9MWv+8Kok4RNxZUAdghJeSmiA
         ERrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6v601w2whp5h3eZk9WOM8NIBFfSAfNFUUoB88kQgXr0=;
        b=B4ZVuu8uNBWSd6KBh/ilnSG2KymUf8oiYOu7pDgZGk2UN8FW727UTk/OEcdhv/EuP9
         qZ73Sjg+/jgFqYBesXE7gyTp8WuhMxBG+cPQs+nKLqJ0AYHgpfsi93oMfojdzpSEyMAJ
         v+zSkxj4xxMBVbmFGr4QZbSGG8yXXbY2YfLhuoEeQXjq2/gOA4CfdWM+Ea4FAdtBJd3Z
         Mas9kUTweMfyuMQ02jl7g07Uq4qOAUpSAx9Yz/cYYSizAHHETo4AuvFokb6MjJj2Vw/m
         AItlxbWEGHvEOPUF78BHOWXYoMP1EIG/SIsO4iQftNq4HDZ9loV/vKQ2o5M0GAwbaK90
         KX3g==
X-Gm-Message-State: AOAM530nfU3qcFiAE4XqgTbE6JRNfw6R9xBv+BrNT3yYoTDFXIXjDYAJ
        wuOLl2c/5IF2DGMr4rbNiOq64Y9OKgA=
X-Google-Smtp-Source: ABdhPJzCVq094LFpkCsHo3gKTWg994vqiG47QfWkySbVU4QzPTLwBOZiQqKJXURUHDhVaMKDO1P09w==
X-Received: by 2002:a05:6214:1a4a:: with SMTP id fi10mr4379189qvb.5.1615404719065;
        Wed, 10 Mar 2021 11:31:59 -0800 (PST)
Received: from ?IPv6:2620:10d:c0a8:1102::1844? ([2620:10d:c091:480::1:d0a0])
        by smtp.gmail.com with ESMTPSA id l6sm218540qke.34.2021.03.10.11.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 11:31:58 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
To:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305094850.GA141221@embeddedor>
 <871rct67n2.fsf@codeaurora.org> <202103101107.BE8B6AF2@keescook>
Message-ID: <2e425bd8-2722-b8a8-3745-4a3f77771906@gmail.com>
Date:   Wed, 10 Mar 2021 14:31:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <202103101107.BE8B6AF2@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 2:14 PM, Kees Cook wrote:
> On Fri, Mar 05, 2021 at 03:40:33PM +0200, Kalle Valo wrote:
>> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
>>
>>> In preparation to enable -Wimplicit-fallthrough for Clang, fix
>>> multiple warnings by replacing /* fall through */ comments with
>>> the new pseudo-keyword macro fallthrough; instead of letting the
>>> code fall through to the next case.
>>>
>>> Notice that Clang doesn't recognize /* fall through */ comments as
>>> implicit fall-through markings.
>>>
>>> Link: https://github.com/KSPP/linux/issues/115
>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>
>> It's not cool that you ignore the comments you got in [1], then after a
>> while mark the patch as "RESEND" and not even include a changelog why it
>> was resent.
>>
>> [1] https://patchwork.kernel.org/project/linux-wireless/patch/d522f387b2d0dde774785c7169c1f25aa529989d.1605896060.git.gustavoars@kernel.org/
> 
> Hm, this conversation looks like a miscommunication, mainly? I see
> Gustavo, as requested by many others[1], replacing the fallthrough
> comments with the "fallthrough" statement. (This is more than just a
> "Clang doesn't parse comments" issue.)
> 
> This could be a tree-wide patch and not bother you, but Greg KH has
> generally advised us to send these changes broken out. Anyway, this
> change still needs to land, so what would be the preferred path? I think
> Gustavo could just carry it for Linus to merge without bothering you if
> that'd be preferred?

I'll respond with the same I did last time, fallthrough is not C and
it's ugly.

Instead of mutilating the kernel, Gustavo should invest in fixing the
broken clang compiler.

Thanks,
Jes

