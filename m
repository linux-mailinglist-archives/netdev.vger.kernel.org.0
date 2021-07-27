Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAA03D7ECF
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhG0UG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhG0UGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:06:24 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2CCC061764
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:06:22 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso6434883pjb.1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qD/PBt3CNf26h7b3FD4L2B5zkfWzkBxO/uqzlPboJk4=;
        b=RtKqi/DcgLMxnMaj3mmxGPKAlnxq8ASoHJIzENVvIf3qFiGfkOTG3XdpIhr6YpXXDj
         NIq54XP3HiGYLgLnhQCb5WsbrWd2m9bnyWVyvbsDVfIVyeGddeJXCgxZXd5HVQ/6cFFQ
         oLWOXdmGT91LEzQMFj1574ESYTGDz9iCP7LxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qD/PBt3CNf26h7b3FD4L2B5zkfWzkBxO/uqzlPboJk4=;
        b=EbTXI5gUjUbvTEwFsMqrJjQkLYMY1F43n6TRdG7gGWW4vzXPB1IqxgbsEJ0kSdITVK
         FwsoHIndH8mn3LPuEUsPX9u3f6SD+HhKxgOpTS0snt02/KfvUm5ovqiIz2Feu9Wagd5W
         yIBlFzXg3JgW0EtRkcqrjkO7IMfoo/WL+ZZjktev8LMLBLub2zioZSpdlIxBA8kVahhO
         cMMQLrVSsC0X7pCc0uIhSeJn3Pzl9YCkgYpRRC05fDYA/Zuc5Xa3awNZIxZjd/sAF6n0
         CP7gNUM5m73g/5Z7Qyb9k87Q6AhEeVMBnXm58j+IK5PXRT6Z1z9u7McBH+i5e6/gGJEs
         EVIA==
X-Gm-Message-State: AOAM533/4ZqO5jrwNLrzCoq2EdyGAXubp5RhjpX60iV90zpg5U5ZT+mO
        vAofvQAY5n3c3qXXU0ilJ2YQuHto+Hw3/wcu7sqkXw==
X-Google-Smtp-Source: ABdhPJwHwSVtXYZElTiWWA6Bv52JZubsCu2gGXGiKvvmMRBeVFTzoiIWcaSwvUKA3i3Aa/uGinn2/U6KKAmEYcASojQ=
X-Received: by 2002:a17:902:7885:b029:12c:437a:95eb with SMTP id
 q5-20020a1709027885b029012c437a95ebmr4647830pll.80.1627416381609; Tue, 27 Jul
 2021 13:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210727190001.914-1-kbowman@cloudflare.com> <20210727195459.GA15181@salvia>
In-Reply-To: <20210727195459.GA15181@salvia>
From:   Alex Forster <aforster@cloudflare.com>
Date:   Tue, 27 Jul 2021 15:06:05 -0500
Message-ID: <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
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

(And again, this time as plain-text...)

> Why do you need to make the two consistent? iptables NFLOG prefix
> length is a subset of nftables log action, this is sufficient for the
> iptables-nft layer. I might be missing the use-case on your side,
> could you please elaborate?

We use the nflog prefix space to attach various bits of metadata to
iptables and nftables rules that are dynamically generated and
installed on our edge. 63 printable chars is a bit too tight to fit
everything that we need, so we're running this patch internally and
are looking to upstream it.

Alex Forster
