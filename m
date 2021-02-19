Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8646B31F964
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 13:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBSMZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 07:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhBSMZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 07:25:07 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F68AC061788
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 04:24:12 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id c8so19195658ljd.12
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 04:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wHrYkCK1zLRD6wByIwlBLFI5CiL9tLM6cLoCKLmdSfI=;
        b=f5UVscClc1+dxFKiSTb8GrmugqWtOiZ6ciLfydsqvbi99dBTBjorDFqJxkYoWViwZD
         P6ASCmD4/Vpg1ph9hfJuG7LUAkj76GXyJbONNkZrCxxCcDh5UOc/gfCQHeWSUatEBUKT
         VU0rheK34iG4itgCQE1tCMbDk819CRQol7y0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wHrYkCK1zLRD6wByIwlBLFI5CiL9tLM6cLoCKLmdSfI=;
        b=QbE+pOIHYm9arAh/d7ZRvdESnY6KaMz4t6r3uwpc9amiTXMuFiymb6jLc1VzDqp8+W
         UxcsgGsT8Whmn5pmy1wEkhBhP27TK7ca4Lidlf+7gnH29YLq2l5W1m/8IoOvAhkgUeyu
         ePGgCTwS44DJz5W41DnqbpF4siYDDbhpSf+IQMwd7k7dc5B7e7QC0UkWIKRmQ+EM84f3
         lnTBeONVVx6wn18oAcZzsE6WDoC1yztCQx7uUp9D3ZgPF54tf9vECjess0gvtK+4GPUq
         5qwoiMMl2eyu0gfa3yv9alXa0K5nbZmWL+5ShtXVJ1zP0hOW6qEeYQ/DAj3CpYRstW6L
         F43A==
X-Gm-Message-State: AOAM532SmCdmYS9X/Ktb6bJTQeYB/apEPdhCymn+v6e/FQced74nDqxB
        816XQq5GJB4fkzG08hMFvAHVd2IfL9Lz9+UcCjnP6Q==
X-Google-Smtp-Source: ABdhPJwwyMd6Srv1DZ/UHrUroAn7W8bc+ka6yIQG/53X01Z8QDbMzTzc7XlBvAdwOD6l4D+anWou6oFsLd5xyaNpb3c=
X-Received: by 2002:a2e:8846:: with SMTP id z6mr210646ljj.376.1613737450639;
 Fri, 19 Feb 2021 04:24:10 -0800 (PST)
MIME-Version: 1.0
References: <20210219095149.50346-1-lmb@cloudflare.com> <20210219095149.50346-2-lmb@cloudflare.com>
 <00f63863-34ae-aa25-6a36-376db62de510@gmail.com>
In-Reply-To: <00f63863-34ae-aa25-6a36-376db62de510@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 19 Feb 2021 12:23:59 +0000
Message-ID: <CACAyw9_kY9fPdC5DLz4GKiBR8B4mCCnknB2xY1DSKYwkridgFQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/4] net: add SO_NETNS_COOKIE socket option
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Feb 2021 at 11:49, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> > +     case SO_NETNS_COOKIE:
> > +             lv = sizeof(u64);
> > +             if (len < lv)
> > +                     return -EINVAL;
>
>         if (len != lv)
>                 return -EINVAL;
>
> (There is no reason to support bigger value before at least hundred years)

Sorry that was copy pasta from SO_COOKIE which uses the same check. I'll
change it to your suggestion. Want me to fix SO_COOKIE as well?

>
> > +#ifdef CONFIG_NET_NS
> > +             v.val64 = sock_net(sk)->net_cookie;
> > +#else
> > +             v.val64 = init_net.net_cookie;
> > +#endif
> > +             break;
> > +
>
> Why using this ugly #ifdef ?
>
> The following should work just fine, even if CONFIG_NET_NS is not set.
>
> v.val64 = sock_net(sk)->net_cookie;

I looked at sock_net and didn't understand how it avoids a compile error
so I didn't use it, thanks for pointing this out.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
