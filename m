Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A1D4542C3
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 09:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhKQIj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 03:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhKQIj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 03:39:56 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BE8C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 00:36:58 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id n29so3019475wra.11
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 00:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WrPEvEbWf6Wc0DXft8xWpwNHryeVDMkAQS+5Bf1seZQ=;
        b=Rd51I7u6tzAIugOkmci8FtxptCl14VCBCDb6jJFoovrmWDH0iwZXNjmaPZnEmwGHB7
         w72ZBxf27jaCOtqb58DxUYnlcqiVFDRteNX2hZjDkqikexdq9zY8qFmJL60i0CYki3QD
         X9AUTtQ7351p7c+fOqHxRmC9YJy6mOquiKUw6didobc2+/sMQSG35P0qyqB1PAPtnYu6
         lniKzdhUFjxVi2BurMR1evX1WltkWpjTQHo60fKPgciofbGIRdLywt8znfsPKg9Q/OAC
         A/zLFZV3heNlL2xnW+IVAZjbMw9m+vYJXrcyDLH9/h1WCxh44tFaiO0oG38pzlCK9LII
         q+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WrPEvEbWf6Wc0DXft8xWpwNHryeVDMkAQS+5Bf1seZQ=;
        b=aqiiXbfaDi2BVpaL/c4YCB8XOLIlsEilU/xQJA2EUtTtZ1ICmZs5+Mnz5ip9XTgW/8
         TfH1Li73Fko0GAJzkLnPHz3OvKjLQlyGO6noay95SO/0L7nb4wPUxg4Z7p0jf2ZbPLR4
         cagztxcDIb28w08oOu9oBAExbpN07D1Cbm4GDPay+Y3QnjqTr5DpbLPp23e/h2szsUNw
         nFFUvn07JQXclGt+FbnNAtkzT5IcV3ViHV/kW5FkBjjuGJqlgLMK2rITeaOacjbtzEWL
         d2jOkHSQN+9ESrfccjYvr6Moa+B/PNa3E7YPEYvty4YbjJ8cMVScMNsoYxFYhk60xbLE
         VrTQ==
X-Gm-Message-State: AOAM531DYcNBsmLPr9aPYS829LA6eKVHnVj8zsdsuuu3RGupRUyBU0sw
        l2In+mRHSviaSHG6uTlY45No7JspSWn8vH2evklSXg==
X-Google-Smtp-Source: ABdhPJyttg1bVl2qBGNNhXrWHmcwegsT28FZnB6NKWXtHkaTk8EOWeGGvP1WXHR4QqR/ZZ1eg9EHTJJxDmxDy6c+SF4=
X-Received: by 2002:a5d:6d07:: with SMTP id e7mr17009629wrq.311.1637138216539;
 Wed, 17 Nov 2021 00:36:56 -0800 (PST)
MIME-Version: 1.0
References: <CAKD1Yr02W-WuLx8ouvP+wTtkxeyTBW_dp1deo9sim7wfLA2LXQ@mail.gmail.com>
 <20211117071732.7455-1-rocco.yue@mediatek.com>
In-Reply-To: <20211117071732.7455-1-rocco.yue@mediatek.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Wed, 17 Nov 2021 17:36:44 +0900
Message-ID: <CAKD1Yr3CMPWMmNNU6YvpBiaXVttS9T8qGVgmddijYfLSfK-Rog@mail.gmail.com>
Subject: Re: [PATCH net-next] ipv6: don't generate link-local addr in random
 or privacy mode
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     dsahern@gmail.com, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, yanjie.jiang@mediatek.com,
        kuohong.wang@mediatek.com, Zhuoliang.Zhang@mediatek.com,
        maze@google.com, markzzzsmith@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 4:22 PM Rocco Yue <rocco.yue@mediatek.com> wrote:
> Disabling the kernel's automatic link-local address generation
> doesn't mean that it violates RFC 4291, because an appropriate
> link-local addr can be added to the cellulal NIC through ioctl.

Well, it would mean that the kernel requires additional work from
userspace to respect the RFC.

> The method you mentioned can also solve the current problem, but it
> seems to introduce more logic:
>   (1) set the cellular interface addr_gen_mode to RANDOM_LL_TOKEN or PRIVACY_LL_TOKEN;
>   (2) set the cellular interface up;
>   (3) disable ipv6 first;

I don't think you need to set the interface up to disable IPv6. Also I
think that if the interface is down autoconf won't run so you don't
actually need to do this.

>   (4) set token addr through netlink;

Can't 4 be the same as 3? The same netlink message can configure both
the addr_gen_mode and the token, no?

It seems to me that the following should work, and would be much simpler.

1. Bring the interface down. All addresses are deleted.
2. Send a netlink request to set addr_gen_mode RANDOM_LL_TOKEN or
PRIVACY_LL_TOKEN and set the token.
3. Bring the interface up. Autoconf runs. The link-local address is
generated from the token. An RS is sent. When the RA is received, the
global address is generated using RFC 7217 or randomly.

Cheers,
Lorenzo
