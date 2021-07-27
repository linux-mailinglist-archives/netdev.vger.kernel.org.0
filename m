Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4E23D8362
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 00:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbhG0Wp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 18:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbhG0Wp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 18:45:26 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624B7C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 15:45:26 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f13so315521plj.2
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 15:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c1rNywmSdGGjGqVOum2VanmkhITHWhYb0J24So7djoA=;
        b=TtkGy7LcJ0WaUCyu8a042D7dQ5rVq9C9zu07do3LnWSBuJ5oCbUqsDiU7RUSneJ/s6
         ZH5v/8j9GH6ylGb4tQt/VqKvcFv/GAAG8YDIJWQqTBskmZukEkA+CGu8EFtyHO6bZJrg
         EPlodJpw0j7mGTlbwWK0YXKvfQaTUJulof0zg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c1rNywmSdGGjGqVOum2VanmkhITHWhYb0J24So7djoA=;
        b=QTaNvKhjgkp1c8owW72zUaDiz7K5O+6BQIDbjyHY8N8nb6yhWp5ArdQL143AqQGi/1
         e50MipWIwzCXVNciaykzaoHxmJMGiYaLskMgzn/5tu7C9QX41CDEI/HC7RG9hJ7pUlri
         sbpbEymXesFlNk6CXRTa4IxGNqnqBIFG66Ds5K7fRrCjeQbVbYk4OxKEeTLLkphTTOMg
         niIy4vrCQBsbGEVO8+QsB3rbzuTToR4Jzyj6HuCC9EvENKQQnjLfkdSbLJ8BEgEjC8AV
         B62PKWKFT8HAkaBMrkvNU2lrOvvuHcvONEuEJMgYdaneEdkWSFFu+1dPbXTmQ0sdBOIy
         WG5A==
X-Gm-Message-State: AOAM531Umfy6ZfSIO8A9eMYzpmm6OVgkYTKUhjIQ4BX/25qRGIIuJE5H
        MH//1qJ6Y3OTbYib1f2gjP7n1DBnxMs5ZGOrKhIEfQ==
X-Google-Smtp-Source: ABdhPJwuBW1u+RvaSDnnOQwgWCiGU3dOFFm7AXmwt8lUWMZ3xtjeLMUpHyNxEFomuxPLlrfXGToVv2Xas45ir3vVhhw=
X-Received: by 2002:a17:902:e84d:b029:12b:b2aa:5266 with SMTP id
 t13-20020a170902e84db029012bb2aa5266mr20457222plg.65.1627425925801; Tue, 27
 Jul 2021 15:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210727190001.914-1-kbowman@cloudflare.com> <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia> <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia> <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
In-Reply-To: <20210727215240.GA25043@salvia>
From:   Alex Forster <aforster@cloudflare.com>
Date:   Tue, 27 Jul 2021 17:45:09 -0500
Message-ID: <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
Subject: Re: [PATCH] netfilter: xt_NFLOG: allow 128 character log prefixes
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, you can update iptables-nft to use nft_log instead of xt_LOG,
> that requires no kernel upgrades and it will work with older kernels.

I've always been under the impression that mixing xtables and nftables
was impossible. Forgive me, but I just want to clarify one more time:
you're saying we should be able to modify iptables-nft such that the
following rule will use xt_bpf to match a packet and then nft_log to
log it, rather than xt_log as it does today?

    iptables-nft -A test-chain -d 11.22.33.44/32 -m bpf --bytecode
"1,6 0 0 65536" -j NFLOG --nflog-prefix
"0123456789012345678901234567890123456789012345678901234567890123456789"

We had some unexplained performance loss when we were evaluating
switching to iptables-nft, but if this sort of mixing is possible then
it is certainly worth reevaluating.
