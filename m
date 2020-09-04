Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3207825D400
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 10:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgIDIzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 04:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgIDIzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 04:55:13 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327AEC061244;
        Fri,  4 Sep 2020 01:55:10 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 185so5832637oie.11;
        Fri, 04 Sep 2020 01:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i+gOyPCdIyGCm4XMv5Y3cKmm1nxzeoFv/Hh57QwfVj4=;
        b=ScIzy1nhKlV3F2Tnu3jZgvIaz0RTIooDM05bAi/PWHDYgGW+I/IgcPwVQNNs6Ottru
         nUnFxgJC1cvUUfAX7wbltNg5KLWFmbu+L46Hm2l+y5sPdeMZTiVM1O2pXLmtrS3t/r2D
         Jr2EzfsBTA4eYS4D+/qIB6jTiFJou/EtB53eOi90gHLMxZ7q+2XsduAC2Gr1nqzEVtnC
         MG+RSYe1z1mQ+KMuSc+HkZfHwWLGAwwv5TOOyEcbej+2Ynhx/J/auACABASdpHM+ACXY
         8VBbfL1EzZxTIe1sf+6E0VqbeisXrEUZk98eyVgPU4jyYr3STL0/0auGwk7tS7XQtdy9
         v6dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i+gOyPCdIyGCm4XMv5Y3cKmm1nxzeoFv/Hh57QwfVj4=;
        b=gtE7Q6d9O7IJ0SauwgbEuLggdCuaceBgb0408iiNVzE8iFe5/OfEy1Hm8uxpPLg7NU
         zLLi1k6RMAvt8YoQwo/k8m0dm+SMMa9qLdVbEkV9bE91TJSZg6SB/IBlKrtPNuvvXQCI
         EflPpH9R5Vti8zifZcy4VaoLo5txl12ZqYO8sQrCai/HPw5bxaan8Oy2Da9CunsOZq+o
         8FP2QtVMtdoxxCY14CjYdkUG6ibdpnqwg4gaM3Yseb6XSCfMryb86+MjPqS86brAh+AO
         GCYdOQ3KlrqVLklz+6FvpxWwL4kijmyYML0jdODb8Pn5yWgypJSU/n9gImmGcoN0rloT
         qqog==
X-Gm-Message-State: AOAM533jlo8PJyfb2KI7G/v/bNbQuQva/9lyNp/W8tmav11VsIennTLb
        gYCmGtLUUup4cz/HQzj06fjhpbV4wE95QM9FDek=
X-Google-Smtp-Source: ABdhPJzEiFuPI1OFwRYsp+/tEOqrOi8oM7RVs/uMXwK21j/4KnLgFhXkk5nXeFSxaSrreUgF2hBjRwYgjZfhyp/RvSM=
X-Received: by 2002:a54:4688:: with SMTP id k8mr4608943oic.163.1599209709924;
 Fri, 04 Sep 2020 01:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1598517739.git.lukas@wunner.de> <d2256c451876583bbbf8f0e82a5a43ce35c5cf2f.1598517740.git.lukas@wunner.de>
 <5f49527acaf5d_3ca6d208e3@john-XPS-13-9370.notmuch> <5f5078705304_9154c2084c@john-XPS-13-9370.notmuch>
In-Reply-To: <5f5078705304_9154c2084c@john-XPS-13-9370.notmuch>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Fri, 4 Sep 2020 10:54:58 +0200
Message-ID: <CAF90-WgMiJkFsZaGBJQVVrmQz9==cq22NErpcWuE7z-Q+A8PzQ@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Sep 3, 2020 at 7:00 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
[...]
>
> I don't think it actualy improves performance at least I didn't observe
> that. From the code its not clear why this would be the case either. As
> a nit I would prefer that line removed from the commit message.
>

It hasn't been proven to be untrue either.


[...]
>
> Do you have plans to address the performance degradation? Otherwise
> if I was building some new components its unclear why we would
> choose the slower option over the tc hook. The two suggested
> use cases security policy and DSR sound like new features, any
> reason to not just use existing infrastructure?
>

Unfortunately, tc is not an option as it is required to interact with
nft objects (sets, maps, chains, etc), more complex than just a drop.
Also, when building new features we try to maintain the application
stack as simple as possible, not trying to do ugly integrations.

I understand that you measure performance with a drop, but using this
hook we reduce the datapath consistently for these use cases and
hence, improving traffic performance.

Thank you for your time!
