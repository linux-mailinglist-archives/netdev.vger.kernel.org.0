Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1BE4DD278
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 02:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiCRBjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 21:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiCRBjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 21:39:17 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C18C24C;
        Thu, 17 Mar 2022 18:37:59 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id yy13so14297697ejb.2;
        Thu, 17 Mar 2022 18:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xy2Q2Ue/KklDEi6z566ViH4Y8J5Z1q1fJZAWJc4JMgU=;
        b=ecwRSfmyboG6qLlpsV4wIve+3AlUsx9E4zhRGLe161LtK9wC+PYJaXDxkyfUWPm3Rm
         +OGaobSRjME3m6XEv7F2ihDKmfJJ5Yk2P1jpyesMwHuQ8G1jD3SFbfYe1rHp/buTwg4f
         4YDx0EjKZlSlHtNvWNeL/IbFZur1NOS5cV/3nmQXp5HRqI3sWjKbd+y811SeRiL9RXGw
         c/plOll+n+oO/OImBW8kFHtCr1U1G/TJanrQhQp3XBsY588hQSOrIDFc0g42JxOC9ZMe
         yT56w4uvEpXdzAHTGWa+4YQ5wwWLHuuAZL4Z9BnwAqLgMzSV4GD6fwnHGPISxxPf6gXF
         9L8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xy2Q2Ue/KklDEi6z566ViH4Y8J5Z1q1fJZAWJc4JMgU=;
        b=YDGqSJQuOuyp+5OqCIwkm9nR/R1TqM1XCOQ1YGlcsvgS3oIza9o6G1AVCe1VTdSLmu
         CMy2JqvrLavxxziQocEpeKZ5Q4qIywXb5Ii5T8/jCGOEleo/igUBaAru8xCnMKdIzoqm
         5fSgwUft0a5Tqni3gQvRVCCz4tUrDpesV/ucgyvEobeEH4MUF65uKchw6waucc2w9JSU
         /dO7tZYuENssxJtnfvXDH8E7szmAKCx0GJ2PhJH6ucoIqksEtlw+GI+CY2xVy3ea1Lvp
         BRc/ZtbiBZHdD+WIMvsXdPrAhVSq+mrqsgXHTOjWK75oWct5ZIy0VbwQ0uJ5p0cLxKdB
         tVCA==
X-Gm-Message-State: AOAM531AMXRy7Bdw6fE4E74PLB/5bi3MlB/7+1NyYmh7+2YlNJTGbUdJ
        L31d3pV+kK8oBocFO7kUdc3vmkotiAAnOb/4hEs=
X-Google-Smtp-Source: ABdhPJx6K82eDPGSM9hAMmNfp+1jYyAofOk0/ybN3/8UEqP048C3ImbVEbLom7Ie7PHnzPWOtgd1pv5Popy7RrHYckc=
X-Received: by 2002:a17:906:6a11:b0:6d7:76cc:12f6 with SMTP id
 qw17-20020a1709066a1100b006d776cc12f6mr7021314ejc.456.1647567477544; Thu, 17
 Mar 2022 18:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-4-imagedong@tencent.com> <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4315b50e-9077-cc4b-010b-b38a2fbb7168@kernel.org> <20220316210534.06b6cfe0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f787c35b-0984-ecaf-ad97-c7580fcdbbad@kernel.org>
In-Reply-To: <f787c35b-0984-ecaf-ad97-c7580fcdbbad@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 18 Mar 2022 09:37:46 +0800
Message-ID: <CADxym3YM9FMFrTirxWQF7aDOpoEGq5bC4-xm2p0mF8shP+Q0Hw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
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

On Thu, Mar 17, 2022 at 10:48 PM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/16/22 10:05 PM, Jakub Kicinski wrote:
> > On Wed, 16 Mar 2022 21:35:47 -0600 David Ahern wrote:
> >> On 3/16/22 9:18 PM, Jakub Kicinski wrote:
> >>>
> >>> I guess this set raises the follow up question to Dave if adding
> >>> drop reasons to places with MIB exception stats means improving
> >>> the granularity or one MIB stat == one reason?
> >>
> >> There are a few examples where multiple MIB stats are bumped on a drop,
> >> but the reason code should always be set based on first failure. Did you
> >> mean something else with your question?
> >
> > I meant whether we want to differentiate between TYPE, and BROADCAST or
> > whatever other possible invalid protocol cases we can get here or just
> > dump them all into a single protocol error code.
>
> I think a single one is a good starting point.

Ok, I'll try my best to make a V4 base this way...Is there any inspiration?

Such as we make SKB_DROP_REASON_PTYPE_ABSENT to
SKB_DROP_REASON_L2_PROTO, which means the L2 protocol is not
supported or invalied.

And use SKB_DROP_REASON_L4_PROTO for the L4 protocol problem,
such as GRE version not supported, ICMP type not supported, etc.

Sounds nice, isn't it?
