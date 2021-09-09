Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0B040458F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 08:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352543AbhIIGWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 02:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351103AbhIIGWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 02:22:15 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE66C061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 23:21:06 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id m9so854844wrb.1
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 23:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T/P5hwYJvg55379EY5nkL2g9RcUJ4Qk0S6irJ7oXfp8=;
        b=W+UD259EkPe7yVYD54ZeuUDK2XXtVw69FdeGCgGEBFc1CDLvunR753GUf7WT+iFzR1
         xKkUS2lpR6AbLXNiuWQgOD2aXBsGT3nBfpYjCUFVAzKHREzhUg5++GCq2MsukyfSBP7b
         fFxDJeEUkHnMc8wr3sq2R49fFTTHOnO2wTn9hQAhEYiqz1YEkTAKWCLklcErvSthgQgA
         VgnyeoAC0pWRRqLkHxcpUjba7yBB42qYhy/UwLJsXITFm/G0vNpwoPqszFJrkRIIWHPc
         Ev3bQPSU9UB7aIrWBNw/99QF9jmLn9igvp0kXG2pJUOVVqjwd05txfn2cKz5S3xQoJ+Y
         U0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T/P5hwYJvg55379EY5nkL2g9RcUJ4Qk0S6irJ7oXfp8=;
        b=wyRjVNappeiqJRMZb9qFHma9YetCnT1dmxQH6YUQ1HhJqLJXJQP1Ehuf7f5xKiubqA
         81OVGm7JO/rT1oZ0IBZUVvFLm0DGeSaZyC6tv7x5TGEgraWsfGFCLXnFl3CrQlmlpA2y
         qypDhegywovxrvqpDVQt7veOxD/nKABjroHIkmA6GkKbbnAfFkfKrv5/gLQRK/7BSLSn
         yRmGLb3pauclmLrsNLXUEZT4PsTaEvdHFUD40Vp+hwG2gWOqNOu44M7qFQIVFYOLmngR
         i30+lChH3aa+x2Ln9aCJGRFiHz79lYfWQk5iP/BdpSKietlSc6cQ4+XWzX61bzKgEXD6
         6uOw==
X-Gm-Message-State: AOAM5339lGvs9AnSJ3E9IToSijkst9WuhD8nh/m0/ibf2ns2N8gwi7ri
        J73Bw9XyH+RdblkDKj7Ggfy8jKC7dOV2+A9BBGJyFg==
X-Google-Smtp-Source: ABdhPJxyurFAMG5Msr0Cn839JPUJCDt89L5/yYp8G5tPTW+OD2dBuR/hhgmhcIWQX75+UQqZ+PPPAmO3vMDP4BklB9M=
X-Received: by 2002:adf:fc0e:: with SMTP id i14mr1427926wrr.173.1631168464833;
 Wed, 08 Sep 2021 23:21:04 -0700 (PDT)
MIME-Version: 1.0
References: <46a9dbf2-9748-330a-963e-57e615a15440@gmail.com>
 <20210701085117.19018-1-rocco.yue@mediatek.com> <62c9f5b7-84bd-d809-4e33-39fed7a9d780@gmail.com>
In-Reply-To: <62c9f5b7-84bd-d809-4e33-39fed7a9d780@gmail.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Thu, 9 Sep 2021 15:20:51 +0900
Message-ID: <CAKD1Yr2aijPe_aq+SRm-xv0ZPoz_gKjYrEX97R1NJyYpSnv4zg@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: don't generate link-local address in any addr_gen_mode
To:     David Ahern <dsahern@gmail.com>
Cc:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com, chao.song@mediatek.com,
        =?UTF-8?B?S3VvaG9uZyBXYW5nICjnjovlnIvptLsp?= 
        <kuohong.wang@mediatek.com>,
        =?UTF-8?B?Wmh1b2xpYW5nIFpoYW5nICjlvKDljZPkuq4p?= 
        <zhuoliang.zhang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David,

sorry for reviving this discussion, but it felt better than starting a
new thread about this. We (Android) added a vendor hook for this, but
IMO that's the wrong solution and I think we'd still like to see this
fixed the right way.

> I think another addr_gen_mode is better than a separate sysctl. It looks
> like IN6_ADDR_GEN_MODE_STABLE_PRIVACY and IN6_ADDR_GEN_MODE_RANDOM are
> the ones used for RAs, so add something like:
>
> IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA,
> IN6_ADDR_GEN_MODE_RANDOM_NO_LLA,

I think the real requirement here (which wasn't clear in this thread)
is that the network needs to control the interface ID (i.e., the
bottom 64 bits) of the link-local address, but the device is free to
use whatever interface IDs to form global addresses. See:
https://www.etsi.org/deliver/etsi_ts/129000_129099/129061/15.03.00_60/ts_129061v150300p.pdf

How do you think that would best be implemented?

1. The actual interface ID could be passed in using IFLA_INET6_TOKEN,
but there is only one token, so that would cause all future addresses
to use the token, disabling things like privacy addresses (bad).
2. We could add new IN6_ADDR_GEN_MODE_STABLE_PRIVACY_LL_TOKEN,
IN6_ADDR_GEN_MODE_RANDOM_LL_TOKEN, etc., but we'd need to add one such
mode for every new mode we add.
3. We could add a separate sysctl for the link-local address, but you
said that per-device sysctls aren't free.
4. We could change the behaviour so that if the user configures a
token and then sets IN6_ADDR_GEN_MODE_*, then we use the token only
for the link-local address. But that would impact backwards
compatibility.

Thoughts?

Cheers,
Lorenzo
