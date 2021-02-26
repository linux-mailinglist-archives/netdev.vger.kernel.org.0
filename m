Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F58E326965
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhBZV00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhBZV0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 16:26:22 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A815BC061756
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:25:41 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id lr13so17069819ejb.8
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OplF9d/MZZ+m2xkq5e4GHGohtNSi63wOh5KKKchJDFQ=;
        b=E1pDl4RMJ71HW2byrOAQa8FRaCX/RKhU9u7wO9Z4+B6i5BvG9wmsJa9ulaC8iBcFNX
         Bx8TKgELDm/sRer50q/ZTb1FFzRJeYnVWCsv0S8wQg/Hv1hZqp7ME0TErel72xBeh1dT
         ZSC+MsYkdZoW4WrfOy0K73Zi2b1Tio/6JgTUSVhqQUU5zfyX2U9n1CNwqHJ/ldeBJi9n
         v/1yn+JxDXZgcOEC4x9LUvU7NlI9rVSsiZYmJNxyGsejA4aTkLZG+2p+wbNH0Y6kyvU1
         sGxToOLTLwim5VoW0Y4RtxpyWXXmMrDRvmdWbLDsjfGwlDQ6H1iX4pB8vyNXHD3kLOtp
         mQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OplF9d/MZZ+m2xkq5e4GHGohtNSi63wOh5KKKchJDFQ=;
        b=dNDVtW5ed/oh5JKgVTjJsA2Eldg4ImalorMFcGLnniXgY9g57NZ+QDHYyIGReoENTw
         a03d9iU/ZSy+b6o/VCsxQL3n31b/EQsQQA4vNQHwAIVQlvxuxCumgMbk/gfkH4D6zcPH
         KeINIlJS6UmH3QNHUmEdBNHRVcoeY1JwBpQy43n6+SaLU2pLLiWNWrnDrMDp4/Y72d1r
         Wmtc50fe3wCDXXD6YsYrIoLqkvb2bZ4P7i3xU1sVQIWW+JU/RfflshRqDR4Lf8roziTl
         yPkSM0ggWGsyNqdu2sbqmXIXReK9egk/vE4cjzTGqWACyKeRMysZ91UMM0KHGjP+C2Xm
         eKOg==
X-Gm-Message-State: AOAM533yjq8pTYrRJF6BieBwkETMTQOpp5hdzg6NJiqYmMFtc9uoRZ/U
        Yrw4iGIrsaPNhwH1/GTJQfPYAo6u72g=
X-Google-Smtp-Source: ABdhPJwer2LoD9N+yTjxNLDe3929Ti5wM/i8A9vui6Z7WKytBwXbdghrYUiuAl0EibLNHerxhNCJCQ==
X-Received: by 2002:a17:906:4094:: with SMTP id u20mr5280490ejj.525.1614374740226;
        Fri, 26 Feb 2021 13:25:40 -0800 (PST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id l6sm6926417edn.82.2021.02.26.13.25.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 13:25:39 -0800 (PST)
Received: by mail-wr1-f42.google.com with SMTP id l12so9902422wry.2
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:25:39 -0800 (PST)
X-Received: by 2002:a5d:4b84:: with SMTP id b4mr5263208wrt.50.1614374739458;
 Fri, 26 Feb 2021 13:25:39 -0800 (PST)
MIME-Version: 1.0
References: <20210225234631.2547776-1-Jason@zx2c4.com>
In-Reply-To: <20210225234631.2547776-1-Jason@zx2c4.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 26 Feb 2021 16:25:01 -0500
X-Gmail-Original-Message-ID: <CA+FuTScmM12PG96k8ZjGd1zCjAaGzjk3cOS+xam+_h6sx2_HDA@mail.gmail.com>
Message-ID: <CA+FuTScmM12PG96k8ZjGd1zCjAaGzjk3cOS+xam+_h6sx2_HDA@mail.gmail.com>
Subject: Re: [PATCH] net: always use icmp{,v6}_ndo_send from ndo_start_xmit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 6:46 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> There were a few remaining tunnel drivers that didn't receive the prior
> conversion to icmp{,v6}_ndo_send. Knowing now that this could lead to
> memory corrution (see ee576c47db60 ("net: icmp: pass zeroed opts from
> icmp{,v6}_ndo_send before sending") for details), there's even more
> imperative to have these all converted. So this commit goes through the
> remaining cases that I could find and does a boring translation to the
> ndo variety.
>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Using a stack variable over skb->cb[] is definitely the right fix for
all of these. Thanks Jason.

Only part that I don't fully know is the conntrack conversion. That is
a behavioral change. What is the context behind that? I assume it's
fine. In that if needed, that is the case for all devices, nothing
specific about the couple that call icmp(v6)_ndo_send already.
