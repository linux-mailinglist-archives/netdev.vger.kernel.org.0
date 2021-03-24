Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE543482DD
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhCXUYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbhCXUYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:24:52 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFACAC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 13:24:52 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id t6so172850ilp.11
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 13:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oSF3N/PH0kOtyh42OF9N3rLs5Ahl2D+S4Yo0yG5+qc0=;
        b=q0xMVM2+Ju1GJ+pFZ9cOMpYN+XumJT/zbyr9iB3mKaIMj/ldFe7gjwptlApAyIJHzZ
         f9NUpQciOgSVMMTdF68spMOAO0OgVYQREr+QJZr0I5+5Q/1dxqDu4NLFsUFYSB8TOPmO
         DbjL7eggfyXgdJR6At5Ey+MM4436huGhoDbnhBN+uSo2El4zWaDml1EGdLmhEcVPmKZc
         9CvaP8RACQiOnmJNA7x3n9sboXeyr9uw9OUB9jVKnUU9A8zKgA4rgcD3Vk91x0mle6h/
         kN/e83D/aSa3EAY9uzbD8UiVQTYcezI+iPNqJvf+TzE2QiuaJ3rPjrAuxPKa1dHOVWcx
         dtlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oSF3N/PH0kOtyh42OF9N3rLs5Ahl2D+S4Yo0yG5+qc0=;
        b=o2DhuFBL9mIwqX30SolxX1mLyBnstcT3NG9ZvkG7C2jwimgoPurty8duJt660Bdadt
         kqSbgQA+KRg855uG/oex3v0T7krmIFyzJXULUbvfEa5wEcCDQ1nxCnyonwmhMvSszsAt
         6EsZ0WriIdwspGM/fbPl8rFEqAIeACDA2x6QeYDinoPFYBDSKLZoFDuRyWOVtjmzT6QI
         vWFoQJG0TKTWaFDMd84hYEFZdLVIkXwk0nyjQtcJtrv9FIYVZ9h20n7GDSkTYEtYRmQp
         NaenP2FrcTaE/+6sUZlM/d3vK0hi+n3uFLse96qe4E3s0+gCgalazL5FlUJB+OXKAjiF
         Q68Q==
X-Gm-Message-State: AOAM533/8LTORI0uzsSlHdBoCV42k0fRbwTObGCHT1rVWmptM/wsZ8TO
        Zb4UEG0vxOx3J3EVU3yDsnw=
X-Google-Smtp-Source: ABdhPJzeRVkkUEmlTJyCRiZkdx661EuIffN5BvD/oCBhwvm8F49vWs3I1TEbXx5GdPSEH0JuAFkEuA==
X-Received: by 2002:a92:c883:: with SMTP id w3mr4351605ilo.212.1616617492246;
        Wed, 24 Mar 2021 13:24:52 -0700 (PDT)
Received: from ?IPv6:2601:681:8800:baf9:1ee4:d363:8fe6:b64f? ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.gmail.com with ESMTPSA id j6sm1217690ila.31.2021.03.24.13.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 13:24:52 -0700 (PDT)
Message-ID: <2cbb962675f646454f19e08e3c86e1b8ff09300c.camel@gmail.com>
Subject: Re: [PATCH net-next V5 6/6] icmp: add response to RFC 8335 PROBE
 messages
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Date:   Wed, 24 Mar 2021 15:24:51 -0500
In-Reply-To: <ce5b1c2f-1b88-d4c8-2afd-867db9092606@gmail.com>
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
         <77658f2ff9f9de796ae2386f60b2a372882befa6.1616608328.git.andreas.a.roeseler@gmail.com>
         <ce5b1c2f-1b88-d4c8-2afd-867db9092606@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-03-24 at 20:47 +0100, Eric Dumazet wrote:
> 
> 
> On 3/24/21 7:18 PM, Andreas Roeseler wrote:
> > Modify the icmp_rcv function to check PROBE messages and call
> > icmp_echo
> > if a PROBE request is detected.
> > 
> 
> 
> ...
> 
> > @@ -1340,6 +1440,7 @@ static int __net_init icmp_sk_init(struct net
> > *net)
> >  
> >         /* Control parameters for ECHO replies. */
> >         net->ipv4.sysctl_icmp_echo_ignore_all = 0;
> > +       net->ipv4.sysctl_icmp_echo_enable_probe = 0;
> >         net->ipv4.sysctl_icmp_echo_ignore_broadcasts = 1;
> >  
> >         /* Control parameter - ignore bogus broadcast responses? */
> > 
> 
> Where is sysctl_icmp_echo_enable_probe defined ?

It is defined in patch 3 of this patchset.

> 
> Please include a cover letter, also add proper documentation for any
> new sysctl
> in Documentation/networking/ip-sysctl.rst
> 

Will do.

