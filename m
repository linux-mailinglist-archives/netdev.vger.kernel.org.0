Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A24B1DF179
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbgEVVvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:51:49 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36248 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731098AbgEVVvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:51:49 -0400
Received: by mail-pf1-f193.google.com with SMTP id e11so4846370pfn.3;
        Fri, 22 May 2020 14:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z9B4bZk+E5XNnSc8/L/uVYEy0FFzcjh8GSMiMFaQ5cU=;
        b=EC1Xbc9L/RMNKGdiQumAl346JCUKdf/G8NM7A0UWdBgT51zmwa5qg4ZjzgbP04ijZ4
         g6R2MF0jTGQ6mb1JjVWJhlazLapT+wzMFuViprghR3+h42RcvxK9+0tkrOwOsZGE3K26
         NmYwLRpmIVskWYpRq3LxOy8Ca5dfrLHKcYl0xM/+REhkX+CGf6MtZdxls7DG0HdV3AIW
         Ltqcax26CLL6F1Su/mfouhoz1nSCnOrLTbtUXxzOcpF7C9PhDa4OZZxoImcpBIwgMcWb
         cZxKWC2XglyXK+XGo4jtGACJDVL/lQ2uuYGgZqT5eSx9FHWKOFZ9G1B1hMDPcDVeHo3M
         At5g==
X-Gm-Message-State: AOAM5321n3R+TZT2sM8IJnUyG82tp0FUiKk0cdd7NL0ZZrnhS47/ffAv
        h54wDh31Okb/bKS9iCL4nlo=
X-Google-Smtp-Source: ABdhPJzcUJoVZSYg2I5qX4WrfgIvy28/Y0K9mfCZGDbP1o1kz3N2Ybs2nMxPYUjAV7xiLzsbiPVsyA==
X-Received: by 2002:a05:6a00:843:: with SMTP id q3mr5601514pfk.107.1590184307967;
        Fri, 22 May 2020 14:51:47 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id a142sm7175101pfa.6.2020.05.22.14.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 14:51:46 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id CEDDD40321; Fri, 22 May 2020 21:51:45 +0000 (UTC)
Date:   Fri, 22 May 2020 21:51:45 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, derosier@gmail.com,
        greearb@candelatech.com, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, jiri@resnulli.us,
        briannorris@chromium.org
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
Message-ID: <20200522215145.GC11244@42.do-not-panic.com>
References: <20200519010530.GS11244@42.do-not-panic.com>
 <20200519211531.3702593-1-kuba@kernel.org>
 <20200522052046.GY11244@42.do-not-panic.com>
 <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2e5199edb433c217c7974ef7408ff8c7253145b6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e5199edb433c217c7974ef7408ff8c7253145b6.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 10:46:07PM +0200, Johannes Berg wrote:
> FWIW, I still completely disagree on that taint. You (Luis) obviously
> have been running into a bug in that driver, I doubt the firmware
> actually managed to wedge the hardware.

This hasn't happened just once, its happed many times sporadically now,
once a week or two weeks I'd say. And the system isn't being moved
around.

> But even if it did, that's still not really a kernel taint. The kernel
> itself isn't in any way affected by this.

Of course it is, a full reboot is required.

> Yes, the system is in a weird state now. But that's *not* equivalent to
> "kernel tainted".

Requiring a full reboot is a dire situation to be in, and loosing
connectivity to the point this is not recoverable likewise.

You guys are making out a taint to be the end of the world. We have a
taint even for a kernel warning, and as others have mentioned mac80211
already produces these.

What exactly is the opposition to a taint to clarify that a device
firmware has crashed and your system requires a full reboot?

  Luis
