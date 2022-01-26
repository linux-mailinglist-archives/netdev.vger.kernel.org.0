Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C3D49C1FB
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbiAZDSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237229AbiAZDSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:18:05 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A078C06161C;
        Tue, 25 Jan 2022 19:18:04 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id a18so66626814edj.7;
        Tue, 25 Jan 2022 19:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nGwKJWYONIElZDTFR99HkZ3dGKG6mpKfNsXZp31Ut3E=;
        b=f4maGwavYSH1ugNaxseEKuv79y5ex54drx/p9lD2G9Fiu9K5ajRXEp+R72M5HBA1at
         o24cZVNmk6eoK81cgRXNpfkMoij7I29Hz0Y24PhySUZqqVPHUv1VAqAyLTEIW1aiBikc
         DTrbjaoxwFbUMcJ9PKNWB6xpjBY83hkzGSVmd2e2Jt/VRGuePq0AV2U9RZtZD4BuIM82
         XSo30ca8XkyC2nzmKGWjoZwlYaR3PWB77GLMtVaj8L5/J/XF32RTVZ89FqtJfN2k60mB
         g8paoeDwpM92zXB/yd2gG4E1OdIdOAnMnrkokNudxg2Lwn71qNH5+50ur2+18QDFtbZw
         jrAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nGwKJWYONIElZDTFR99HkZ3dGKG6mpKfNsXZp31Ut3E=;
        b=4OwPkzWamfdLFXMK8C/pwm3TmPOI7lpc/fi8UMdz/iZ8AEK24EAzA3wI+Tdlh/8uuz
         5YtA79bodNjIsCBKBacXQ7wHWHWI6to9Q4+FgwCFS34Zs6knef7JSzQ1w9ehxFYHxCKc
         5gLNowh43LtPvy2kO9R7DzwL2K/+wQld5iuk5L8tZcVMUA2rD0d+orPJ1IGK6X5PoZp/
         ry/9iFZn6cqOIZHSEU+gNvyb2YGQJphvJq5JCkbuLHwP1ZUJ/E6a3rr53jdoNUWCXr1h
         azOwYwuX2kQbmnVwE7V6UJKiD7vQmQM6cJtFT2i7X4DobNWwcExaz3NbQisQGVYyOiuQ
         PZcw==
X-Gm-Message-State: AOAM530F9OhkO8oZD1Nxu6lc0ivWpVess6FFeLquOg7Vax6A+KAbhRGj
        RHYQjkgTe33KsSJH3LZBLBqvcGS+xDhD9hHXHv4=
X-Google-Smtp-Source: ABdhPJxgFkyj1zvsBe7fIwyDUghW8HcgNWcznQZiYp3Hf5SBqM5nN32i8nIqMCR/bBLgT5HK+hmKayduOmwYrB3+sBs=
X-Received: by 2002:aa7:d949:: with SMTP id l9mr10167058eds.137.1643167083224;
 Tue, 25 Jan 2022 19:18:03 -0800 (PST)
MIME-Version: 1.0
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-4-imagedong@tencent.com> <5201dd8b-e84c-89a0-568f-47a2211b88cb@gmail.com>
 <CADxym3YpyWh59cjtUqxGXxpb2+2Ywb-n4Jpz1KJG3AYRf5cenA@mail.gmail.com> <926e3d3d-1af0-7155-e0ac-aee7d804a645@gmail.com>
In-Reply-To: <926e3d3d-1af0-7155-e0ac-aee7d804a645@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 26 Jan 2022 11:13:35 +0800
Message-ID: <CADxym3Y5Ld-BcM4-Y=vJZiwsCEfRZpBqd1oj6ct+Xeu8F=wXew@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Paolo Abeni <pabeni@redhat.com>,
        talalahmad@google.com, haokexin@gmail.com,
        Kees Cook <keescook@chromium.org>, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 10:57 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/25/22 7:36 PM, Menglong Dong wrote:
> > Is't it meaningful? I name it from the meaning of 'ip route lookup or validate
> > failed in input path', can't it express this information?
>
>
> ip_route_input_noref has many failures and not all of them are FIB
> lookups. ip_route_input_slow has a bunch of EINVAL cases for example.
>
> Returning a 'reason' as the code function name has no meaning to a user
> and could actually be misleading in some cases. I would skip this one
> for now.

Yeah, the real reason can be complex. I'll skip this case for now.
