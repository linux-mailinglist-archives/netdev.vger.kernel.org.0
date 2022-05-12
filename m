Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEE0525804
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 00:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359325AbiELWxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 18:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350110AbiELWxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 18:53:12 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A997626865A
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 15:53:08 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v10so5841558pgl.11
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 15:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+VaX5bEkt76Upj3MV7wwCv/6t4DebBt0Na7sEL1aFWk=;
        b=RLIUxCf7DyHsfTc9r+srDbeWsNAe7EbL+jFZYOZRR4BWW+qLVAuoHKGuWgN/hyuWSh
         XqGnKskIo2YPhI43QZSG0tP+o/2rDa+mHXKqbquaFpk5J+QzlCr+uiLn2DlvD54vaeol
         RRsMufH6It/H/btgUCKnq7wQ4dOP5Bq0BUSjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+VaX5bEkt76Upj3MV7wwCv/6t4DebBt0Na7sEL1aFWk=;
        b=Xfr9DhVBvUZoVF1ZV3sdfOvrC7QAtquxYnKPouK3Okd0xAmnKvLQMv20iZT9m37GiL
         HEYmrFVJ0yCwNIYga3iCNGzLqeGt0cG7elj0MfaCgQQkbbDMUQQJMovsQhGIqSuJwuMm
         oLYzgM/XP3yVus7APYtAVvDtp11EpQitxqaUw3NrSshZ99eHVP5qMBA1r1HfLGY9/HE2
         rcLj9Sk20bYmabvk0Avbkb3jMLWCwJ7wb4hZDTbvfPX9+33NK1yi5jBng9j9HZPxnUGa
         DzD+10hjqXpKcK80gbuKsmAY0nRi6jpxXKOIZpJPWZ4n+cxuKyxG8lvewZzs2a8kjZmB
         JZCA==
X-Gm-Message-State: AOAM530hFckXGUd7sjEpfKcKpBM1qkTf5/e65V4PVMcEeyYqDSZ5MhG6
        WY4RRgOvwArPMB9nqpF6nGhomg==
X-Google-Smtp-Source: ABdhPJw8D9Yn2NvhdDbwVV4UNIZuZQOhxhAbXeSXhinVOmBc47nuHD4rdSNx10K2su40x/WsCjhq2Q==
X-Received: by 2002:a63:a553:0:b0:3db:48a0:f506 with SMTP id r19-20020a63a553000000b003db48a0f506mr1444062pgu.456.1652395988124;
        Thu, 12 May 2022 15:53:08 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id w20-20020a170902ca1400b0015f391f56b7sm358600pld.305.2022.05.12.15.53.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 May 2022 15:53:07 -0700 (PDT)
Date:   Thu, 12 May 2022 15:53:05 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC,net-next,x86 0/6] Nontemporal copies in unix socket write
 path
Message-ID: <20220512225302.GA74948@fastly.com>
References: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
 <20220511162520.6174f487@kernel.org>
 <20220512010153.GA74055@fastly.com>
 <20220512124608.452d3300@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512124608.452d3300@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 12:46:08PM -0700, Jakub Kicinski wrote:
> On Wed, 11 May 2022 18:01:54 -0700 Joe Damato wrote:
> > > Is there a practical use case?  
> > 
> > Yes; for us there seems to be - especially with AMD Zen2. I'll try to
> > describe such a setup and my synthetic HTTP benchmark results.
> > 
> > Imagine a program, call it storageD, which is responsible for storing and
> > retrieving data from a data store. Other programs can request data from
> > storageD via communicating with it on a Unix socket.
> > 
> > One such program that could request data via the Unix socket is an HTTP
> > daemon. For some client connections that the HTTP daemon receives, the
> > daemon may determine that responses can be sent in plain text.
> > 
> > In this case, the HTTP daemon can use splice to move data from the unix
> > socket connection with storageD directly to the client TCP socket via a
> > pipe. splice saves CPU cycles and avoids incurring any memory access
> > latency since the data itself is not accessed.
> > 
> > Because we'll use splice (instead of accessing the data and potentially
> > affecting the CPU cache) it is advantageous for storageD to use NT copies
> > when it writes to the Unix socket to avoid evicting hot data from the CPU
> > cache. After all, once the data is copied into the kernel on the unix
> > socket write path, it won't be touched again; only spliced.
> > 
> > In my synthetic HTTP benchmarks for this setup, we've been able to increase
> > network throughput of the the HTTP daemon by roughly 30% while reducing
> > the system time of storageD. We're still collecting data on production
> > workloads.
> > 
> > The motivation, IMHO, is very similar to the motivation for
> > NETIF_F_NOCACHE_COPY, as far I understand.
> > 
> > In some cases, when an application writes to a network socket the data
> > written to the socket won't be accessed again once it is copied into the
> > kernel. In these cases, NETIF_F_NOCACHE_COPY can improve performance and
> > helps to preserve the CPU cache and avoid evicting hot data.
> > 
> > We get a sizable benefit from this option, too, in situations where we
> > can't use splice and have to call write to transmit data to client
> > connections. We want to get the same benefit of NETIF_F_NOCACHE_COPY, but
> > when writing to Unix sockets as well.
> > 
> > Let me know if that makes it more clear.
> 
> Makes sense, thanks for the explainer.
> 
> > > The patches look like a lot of extra indirect calls.  
> > 
> > Yup. As I mentioned in the cover letter this was mostly a PoC that seems to
> > work and increases network throughput in a real world scenario.
> > 
> > If this general line of thinking (NT copies on write to a Unix socket) is
> > acceptable, I'm happy to refactor the code however you (and others) would
> > like to get it to an acceptable state.
> 
> My only concern is that in post-spectre world the indirect calls are
> going to be more expensive than an branch would be. But I'm not really
> a mirco-optimization expert :)

Makes sense; neither am I, FWIW :)

For whatever reason, on AMD Zen2 it seems that using non-temporal
instructions when copying data sizes above the L2 size is a huge
performance win (compared to the kernel's normal temporal copy code) even
if that size fits in L3.

This is why both NETIF_F_NOCACHE_COPY and MSG_NTCOPY from this series seem
to have such a large, measurable impact in the contrived benchmark I
included in the cover letter and also in synthetic HTTP workloads.

I'll plan on including numbers from the benchmark program on a few other
CPUs I have access to in the cover letter for any follow-up RFCs or
revisions.

As a data point, there has been similar-ish work done in glibc [1] to
determine when non-temporal copies should be used on Zen2 based on the size
of the copy. I'm certainly not a micro-arch expert by any stretch, but the
glibc work plus the benchmark results I've measured seem to suggest that
NT-copies can be very helpful on Zen2.

Two questions for you:

 1. Do you have any strong opinions on the sendmsg flag vs a socket option?

 2. If I can think of a way to avoid the indirect calls, do you think this
    series is ready for a v1? I'm not sure if there's anything major that
    needs to be addressed aside from the indirect calls.

I'll include some documentation and cosmetic cleanup in the v1, as well.

Thanks,
Joe

[1]: https://sourceware.org/pipermail/libc-alpha/2020-October/118895.html
