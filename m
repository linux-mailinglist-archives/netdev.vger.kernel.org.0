Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D056111B3
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJ1Mkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 08:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJ1Mkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 08:40:51 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41F289937
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 05:40:50 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id n130so5949148yba.10
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 05:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d5qpLLU9ealz0k8qQMMTyV56YTc5b0apoIByczFtzmg=;
        b=eANACC4xiHYJE6fFPT82kV6FN7SzHJX8A02ky39653ph7kxPqSll4DnYeRsW2TGb1L
         18IyEmaURS2lyHtYp6HRX2doKdjX07Yp9m6lwz4KK5Iao6A/U8h5Y2OzUbH/ZpYkuSsy
         Z7JmI7RCutczyGWDU2EdHdha5Gkz2GKIe5qsng+V/ibZsjcZvecf0i/XXRsfgn8eQKvU
         Sw2p8OqXTn6j6BAHfH4KSdaweKinoKk8xYSUGZqcDtJYhpwQ2UoXHiFwEC1VZTpp8/Nb
         smMe5cNiwqf61UPS6ySf+A33jNMV2HOpu0N1Nxw9ZZKxtPaVZFr1caQ6UiojMXiDP13q
         ww2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d5qpLLU9ealz0k8qQMMTyV56YTc5b0apoIByczFtzmg=;
        b=ZHhvlUaSzZFekO9cVsO/WEKjBq6wRNZ0FG+c1hgETKJQ/B+68L0qbLClWQqToretAh
         jjiMpDq1N0o/blrutFQF+z+9vQVLWHFjX3Xhum7uGOtQcnjK3x/aktgkqjXNbO8DJuUF
         BNqICGvsh2AEahLMILOqmbLS+E0hrdqS/k+O10o2L11PhZtEj9PA7XEMZ0iuYxo1Vrgf
         EVYcRueTxzA0eY6EgNWzUPswCn0BIABgBTWSTdU4RGHA4mTmJKcDcBr+W8ulqK3dnyi/
         9FXoVfixD8PI68thdzFbbgGK4aTjNkRIbfy8kkWZ2XS6woQXkS96hxIWu3uQGwdHudMY
         05+A==
X-Gm-Message-State: ACrzQf0QlXRGSSBTKORhnU8jG4lDo6fjlquGFxivt9YAqWNSBCi+mfEY
        o+VvNw82XVZnYs75MEF+59hooOMdTcFISuiTA3KLpA==
X-Google-Smtp-Source: AMsMyM6fzlWHqOO55M6DkkRJ3hpXgCc9vncKmeY0LuaFkAM9OAG7r1AJq3cjAzhHnAoQuKVck2MYFVhFMORLQZCVJhY=
X-Received: by 2002:a25:3187:0:b0:6c1:822b:eab1 with SMTP id
 x129-20020a253187000000b006c1822beab1mr46975206ybx.427.1666960849872; Fri, 28
 Oct 2022 05:40:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221027102449.926410-1-william.xuanziyang@huawei.com>
 <CANn89iJkKJ3-b8vncrxgawWTtaLphYERhVma7+1qgdSEXn8tiQ@mail.gmail.com>
 <8523b754-992d-0d72-ecd1-4f076e57ebde@huawei.com> <CANn89i+FYGkR5_-C3wp7GdpW=JT8V5LELwMNcHg9Gt6=e877JA@mail.gmail.com>
 <4ce1a942-db88-3d20-b377-ade9b4fc997d@huawei.com>
In-Reply-To: <4ce1a942-db88-3d20-b377-ade9b4fc997d@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 28 Oct 2022 05:40:38 -0700
Message-ID: <CANn89iLtMK7uRaXJai3-PocJnuOrB5KMS=L=sbF7egUB-d_6UQ@mail.gmail.com>
Subject: Re: [PATCH net] ipv6/gro: fix an out of bounds memory bug in ipv6_gro_receive()
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 3:11 AM Ziyang Xuan (William)
<william.xuanziyang@huawei.com> wrote:
> Hi Eric,
>
> Thank you for your suggestion.
>
> I have analyzed the problem more deeply. The odd IPv6 packet and
> big packet length value(IPv6 payload length more than 65535)
> together cause the problem.
>
> skb->network_header and skb->transport_header are all u16 type.
> They would occuer overflow errors during ipv6_gro_receive() processing.
> That cause the value error for __skb_push(skb, value).
>
> So the problem is a bug in tun device.
>
> I will combine my previous problem "net: tun: limit first seg size to avoid oversized linearization"
> together to give the fix patch later.

SGTM, thanks !
