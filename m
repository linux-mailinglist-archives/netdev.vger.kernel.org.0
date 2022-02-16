Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA414B7EB1
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344357AbiBPDg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:36:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344387AbiBPDgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:36:25 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD87FFFAF
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 19:36:14 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id p5so2039446ybd.13
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 19:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vMCZxnRD6TLaVH1MVTjvvBQOAFZ6f2bTNtI/eV2sq4Y=;
        b=NcvQ2xdnteQaxFYpopb+0cyzX8QIHurPnVCl+V5dSmn45ae4mE8AIgt8Y3KNYryEs8
         mRZL1YcNoPauIbr4kBhQJuZ1yqdKZ8iXGrDcf2DL7zcMmEWJnfYNaoELJHfWLc4v9W4K
         Xn7Tcjx6WxMubSQ7864J9D4P7VOOD+0II9kWlOaeF4JJoGTEj+b/YakIVcY0b+Ez3LpD
         VRHfM9+U4VQVxjM8kipVjYRr9xA1WFKq8fdK81FTK2tCatMWaaZHsEltGKYZZ8LSE0J6
         zt0VK1RHYeLUgsNRWDASlX7pkZ4Ziq9sqltmvkIneOS7UJtniqSMxTu87i3zULcYo0FE
         fWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vMCZxnRD6TLaVH1MVTjvvBQOAFZ6f2bTNtI/eV2sq4Y=;
        b=gz3RdbXXpHuCjgG/CtfLeXH9/xogs8CSMsuooDNbnyQ6RNdqToNurtdFC5LZjDNiXP
         6TG6Hez5gEHMJ66BS5trRs0ovMD/gx0CNh6u2mR0oVMRZb9YqULHgrmfm1W4vWdtmzfF
         bDj1s/+DlRYh5fXFt5DQCKkxPLs5LtEoDwJ13AN3ZQN3/oja75OjLDtFyC5JfFJeIAXT
         LjIXdl5s9iIp6/DyBR678C/MYiwwFoCJ3AaIgKzXQMqGcTsycafkKHOHrcm0GNMPSNpb
         KbzRlojOard6KH2E0yMg/arYeGDCJWUWpwBHL82+NtR4ydfKkKJu1NNW1hF6k0umZSvy
         OUlQ==
X-Gm-Message-State: AOAM533xuNAMrQelQJ9gLUxU1SjsxqbKM4bhDz6HAu2x/EkVln2eVmZH
        0TjBKCwvGY8HTIpDseoCIOwEI3dly15glZyUtw==
X-Google-Smtp-Source: ABdhPJynRV/Mw9wWm/C42cQItg9ce2stOjq/KTiNNVddI6Aim4/6tJBF/V/wNLSSxs5c+tbtzkpYfgD61UHnhZhxKOs=
X-Received: by 2002:a81:6c8f:0:b0:2d6:4130:a420 with SMTP id
 h137-20020a816c8f000000b002d64130a420mr733941ywc.365.1644982573573; Tue, 15
 Feb 2022 19:36:13 -0800 (PST)
MIME-Version: 1.0
References: <CAA-qYXgrcXsgHMoDyTR74bryDsofzPajTfT6WZHGH-vaDixDwA@mail.gmail.com>
 <3cb2f39c-b46a-d012-721b-d40285a75aee@gmail.com>
In-Reply-To: <3cb2f39c-b46a-d012-721b-d40285a75aee@gmail.com>
From:   Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Date:   Wed, 16 Feb 2022 11:36:02 +0800
Message-ID: <CAA-qYXiVqh4LU+7Qv1_RFUgUM4Ph6LWdC0tqS4CTFqtSPu_LZA@mail.gmail.com>
Subject: Re: A missing check bug and an inconsistent check bug
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     isdn@linux-pingi.de, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        shenwenbosmile@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

I guess the bug fix has a problem.
I check the stable version 5.16.9, base_sock_create() uses capable(),
the code is same as v5.10.7.
Should it use ns-aware check, ns_capable()?
Because capable() checks init_user_ns, not the current namespace.

Thanks again!

Best regards,
Jinmeng Zhou

On Wed, Feb 16, 2022 at 5:54 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
> On 2/15/22 04:30, Jinmeng Zhou wrote:
> > Dear maintainers,
> >
> > Hi, our tool finds a missing check bug(v4.18.5),
> > and an inconsistent check bug (v5.10.7) using static analysis.
> > We are looking forward to having more experts' eyes on this. Thank you!
> >
> > Before calling sk_alloc() with SOCK_RAW type,
> > there should be a permission check, ns_capable(ns,CAP_NET_RAW).
> >
> > In kernel v4.18.5, there is no check in base_sock_create().
> > However, v5.10.7 adds a check.  (1) So is it a missing check bug?
>
> Same answer, v4.18 is not a stable kernel, not sure why anyone would
> care about v4.18.5
>
>
>
