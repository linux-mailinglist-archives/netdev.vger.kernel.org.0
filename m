Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B424BEAE2
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiBUSab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:30:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbiBUS3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:29:50 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0CECDF
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:28:58 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id j12so36127131ybh.8
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d9PRkAnu4rWgkNf7FMpG/2aRjthJJP/oay+IMr9qlso=;
        b=h3a9qey6Rf4dTVze8rQGdhclm6vibCyCiZrqdTsDvKU/a29mtdlDJGjg/a9KrJb/+9
         Sldi+zsLepOlitgV6isaU5ca26ImxtLydIdtGTmOdbuf6pualqJLDqH6+ewJDOHK6BPY
         5ljFUAV/8LiixoYIqanmKETtU84mdJmsdjyWaGQIzFsSpFjV/E5rZMaZxksisRI+xbhh
         CHLUJKPt9RY3JrXeoUTek88KiZKH/+sL8d8eeFKS99LnNwKF+uE46LXEbVPmtLhiMNYU
         5CwXu9YS9qgITWH6zwn5fl0WWmaqtpbpW3slNbWiNS4kCQBtBav/Y8znw4NCmIciPgpC
         SdlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d9PRkAnu4rWgkNf7FMpG/2aRjthJJP/oay+IMr9qlso=;
        b=uOVShS4xhUCNQ0vcU09cscv8K03A+qBjRcesBphEYydMl74tpYdfu+MkeB2yjF9Nn8
         l6d/pobHV+yjSsQ37k0E2kMDtxZ3W/VsuhWBuG8yUxqakxIr0UGDkUkCgZcZ7NnvQBQ4
         4nFMs5Z4vB7e29CceGQKHi3Do84E6NKU3Lv6dfnFrfsmISSeIIhEajF96Hf0a3iR1Tgu
         QEEEaotNdLdMQYuP3J4M6E+qw42mZxy76XK8RXtEh9TGbuuMf+M9td7ZSnojMU9R50Xb
         f8n++BQIhtXwwHfmEixj7LLV317TekMfoug/sK7OL56dzM+NS8Nsqsj5laS9PKZ/AToM
         KhTw==
X-Gm-Message-State: AOAM533tlyIMn0qNQGGl6LgK2ft1zQ9/kNnNbBNC/vXu+IhSGMV+iPmm
        TIJZX3tCzY4qE7flUc1zAySO+EhDc3znj99qzmZrUw==
X-Google-Smtp-Source: ABdhPJwNsokvzVCETZiA+pXCIHC4BZaoSZMPWKx3mOto+E3tTumxE6L4EmjC4Z+RCNEwPML3MlNIPsNrfUTzH1bspDQ=
X-Received: by 2002:a5b:7c6:0:b0:60b:a0ce:19b with SMTP id t6-20020a5b07c6000000b0060ba0ce019bmr19355803ybq.407.1645468137290;
 Mon, 21 Feb 2022 10:28:57 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wgsMMuMP9_dWps7f25e6G628Hf7-B3hvSDvjhRXqVQvpg@mail.gmail.com>
 <8f331927-69d4-e4e7-22bc-c2a2a098dc1e@gmail.com> <CAHk-=wiAgNCLq2Lv4qu08P1SRv0D3mXLCqPq-XGJiTbGrP=omg@mail.gmail.com>
 <CANn89iJkTmDYb5h+ZwSyYEhEfr=jWmbPaVoLAnKkqW5VE47DXA@mail.gmail.com>
 <CAHk-=wigDNpiLAAS8M=1BUt3FCjWNA8RJr1KRQ=Jm_Q8xWBn-g@mail.gmail.com>
 <CANn89iJ2tmou5RNqmL22EHf+D2dptJPgpOVufSFEyoeJujw1cw@mail.gmail.com> <YhPZNLWkxH21uDAq@salvia>
In-Reply-To: <YhPZNLWkxH21uDAq@salvia>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Feb 2022 10:28:46 -0800
Message-ID: <CANn89i+72dv1AaeE1ThkceMVBHGCh3P49hOwuCkMSb1Y6U=hmg@mail.gmail.com>
Subject: Re: Linux 5.17-rc5
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Woody Suwalski <wsuwalski@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 10:25 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Mon, Feb 21, 2022 at 10:21:16AM -0800, Eric Dumazet wrote:
> > On Mon, Feb 21, 2022 at 10:08 AM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > On Mon, Feb 21, 2022 at 10:02 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > I am pretty sure Pablo fixed this one week ago.
> > >
> > > .. looks about right. Apart from the "it was never sent to me, so -rc5
> > > ended up showing the problem" part.
> > >
> >
> > Indeed, I personally these kinds of trivial fixes should be sent right away,
> > especially considering two bots complained about it.
>
> I did not consider this so important, that was my fault.

Well, I was the one adding this compile error ;)

Testing CONFIG_IPV6=n builds is not my top priority.
