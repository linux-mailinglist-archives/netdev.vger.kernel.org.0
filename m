Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F802662CC
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIKQBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgIKQBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:01:05 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53D3C061756;
        Fri, 11 Sep 2020 09:01:04 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 16so10340170qkf.4;
        Fri, 11 Sep 2020 09:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m+iVerlUNqAW5DSLfymFd18Aa+jNaCXhphLLXfU0VIA=;
        b=Sutpl+MPw6nB+6Wp5lUzwnRnbow90HU9aTTdtIg3LjT1unaleGubj6DLgjH29qJZ0T
         jMBnugheaGK51H8DSv0rwGMarn7OlqHDc7tXNfLqpKrm7lua3eEOKqIQ4qUWKse+CpMJ
         wIVx40eC9zpg9bBQBVNJ0Xre4Jvs8cNrkMzgh/6D6HQR4JEj5+tPIRQgbLtbuB5qF4Oi
         e5atLQkthHa/nAfnDCorJKsNkqIsrmVzGOEXDo5ij+9ZE1QIlj8gAPSKjjuvR7M9JUku
         t6gAApCIN4TgMEZc1j00NRxC2pTiI06jJF1ATbeDQGPWRlyi03xKmAujKHqcrYIMHpMs
         7++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m+iVerlUNqAW5DSLfymFd18Aa+jNaCXhphLLXfU0VIA=;
        b=DAI0o9EUArYnzD3SPxreVjHcnvJcMa9S6iqtqRPr5ZjMbpSzfhiyJB4ag9FYj732lw
         J7nteuzh0l4nkZTQ+bPVx/niyfsj6TjRgPhSp34AzxtQmGO1WKUSAWlgTMPb9aeCRYJD
         TsE9EdQuggExFFJNOcrx8khZQYtky5+iWXWgaW7tiyUKF1JdNtCqv5tze1bcx/bSZ9Ts
         FSJyiYqUWXmHcvhsLmpkEyoi5A33mvqpcKfgaqZL8jDZAxWweKiah56+F25WHef9Bwu0
         fLiv12YOZPyX1H0Yuy233rEvPPyzb+ITECIutgLFLfKqB0HrFZObQqfOQVFEzaVx+OUu
         qU9w==
X-Gm-Message-State: AOAM530ltPRXTW2w5eQAKoDyBjtrrxjKDJ8R7l2jk1eb8x7oRVHr0+/D
        fbqtE1GDB2isIPajECERyzw=
X-Google-Smtp-Source: ABdhPJxtro49hRqMYSXF+EANvHfvT1mDgX5lpY6eqewCbYGFFFco8K3fg4p7mB9jEDuEtQw+QyQlOQ==
X-Received: by 2002:ae9:f503:: with SMTP id o3mr1925852qkg.447.1599840063843;
        Fri, 11 Sep 2020 09:01:03 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id g25sm3061622qto.47.2020.09.11.09.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 09:01:03 -0700 (PDT)
Date:   Fri, 11 Sep 2020 09:01:01 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] net: mvpp2: Initialize link in
 mvpp2_isr_handle_{xlg,gmac_internal}
Message-ID: <20200911160101.GA4061896@ubuntu-n2-xlarge-x86>
References: <20200910174826.511423-1-natechancellor@gmail.com>
 <20200910.152811.210183159970625640.davem@davemloft.net>
 <20200911003142.GA2469103@ubuntu-n2-xlarge-x86>
 <20200911111158.GF1551@shell.armlinux.org.uk>
 <20200911082236.7dfb7937@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911082236.7dfb7937@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 08:22:36AM -0700, Jakub Kicinski wrote:
> On Fri, 11 Sep 2020 12:11:58 +0100 Russell King - ARM Linux admin wrote:
> > On Thu, Sep 10, 2020 at 05:31:42PM -0700, Nathan Chancellor wrote:
> > > Ah great, that is indeed cleaner, thank you for letting me know!  
> > 
> > Hmm, I'm not sure why gcc didn't find that. Strangely, the 0-day bot
> > seems to have only picked up on it with clang, not gcc.
> 
> May be similar to: https://lkml.org/lkml/2019/2/25/1092
> 
> Recent GCC is so bad at catching uninitialized vars I was considering
> build testing with GCC8 :/

It is even simpler than that, the warning was straight up disabled in
commit 78a5255ffb6a ("Stop the ad-hoc games with -Wno-maybe-initialized").

clang's -Wuninitialized and -Wsometimes-uninitialized are generally more
accurate but can have some false positives because the semantic analysis
phase happens before inlining and dead code elimination.

Cheers,
Nathan
