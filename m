Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BDE41B017
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 15:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbhI1Ncn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 09:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240833AbhI1Ncn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 09:32:43 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0014C061575;
        Tue, 28 Sep 2021 06:31:03 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k24so21210369pgh.8;
        Tue, 28 Sep 2021 06:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xLOZrMV7SZ4/3ZGTCH14BX3P2qTZZoEv4iZ55d85Xp0=;
        b=lySMMtWyy8WhWQmn/AnBA9kOwpRg7qC6LyxGUMtSEuD0de58zD9pxCEXZJ/AAgdnip
         UCf7fyG2DHOOJQpRzNcTFWE+WcrybWHRRG3XVD8YzWqOQkHH/OZdB3oXhBeL8nWyMzb7
         5cn9fWPs0ZZXG1kpEOv2S+SKRBEjuEP8NT2ZxjvPsWdj4+IvSruh3zlAh4RLIeju4gqn
         xmo0f7mYIp5Mi1Wu67lEqUtC/O6eohvnMuEIClJYD6/JGhF9B8QORd6Drl69zaF+5q1M
         X8pjpF2yjfYKQgmYtoj+O1ICskhFrbWzYkoePFPt+WpkCi4lcMENuShljImLS1h4rwSI
         P21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xLOZrMV7SZ4/3ZGTCH14BX3P2qTZZoEv4iZ55d85Xp0=;
        b=kzOwbeUg/ZZCbnarSiWBWc564TDNm8PZ/XLAcr+WoHy42vnCfodDF8AKOsNQiXqGn8
         AQcTYNYxqW24GoDW/8482K+FeqTAM+NhduarHVawmOI2NWTq0ysqR9g2Cn6c/Eg213mQ
         2ykFKPh+cFvfuyGnk33IJsEeEOokC4eMxJI6cp5/R8+QqKzAy6WxAJMsKBhoRffbKtaT
         bi8sMt+ZakNaXQfU4FH5ZsblTRW7ODLhxgMwtWOAfaFKWCktYUguOhndVNJUGVyA2UxE
         n1Pc6oWLRCfEXD1kI+Qn5md56P7S8UNI65y2b9HsIe3wxYRrf4wIu6sp2CnKPxPn3/PE
         SzUg==
X-Gm-Message-State: AOAM532QBNE2er/9uvmPYjIj8vdnSy4YaM0QhZVAXZX99T2td+K1ZkAz
        VepTmdXDe1MAdjkvwY3TKI0=
X-Google-Smtp-Source: ABdhPJyqZ5QI74WJ80gMMzLr2peSwdD/lbpPr9cjATAn3mhq5TDWBrFRH7CmJC7VqAW/XyoKn5pjbw==
X-Received: by 2002:a63:f84f:: with SMTP id v15mr4626646pgj.204.1632835863255;
        Tue, 28 Sep 2021 06:31:03 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x8sm2845374pjf.43.2021.09.28.06.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 06:31:02 -0700 (PDT)
Date:   Tue, 28 Sep 2021 06:31:00 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20210928133100.GB28632@hoboy.vegasvil.org>
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
 <20210927145916.GA9549@hoboy.vegasvil.org>
 <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
 <20210927202304.GC11172@hoboy.vegasvil.org>
 <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 01:50:23PM +0200, Sebastien Laveze wrote:
> Yes that would do it. Only drawback is that ALL rx and tx timestamps
> are converted to the N domains instead of a few as needed.

No, the kernel would provide only those that are selected by the
program via the socket option API.

> Before going in this direction, is this a change that you really see as
> worthwile for virtual clocks and timetamping support ?

Yes, indeed.

> What approach do you have in mind for multi-domain support with the
> common CMLDS layer ?

Okay, so I briefly reviewed IEEE Std 802.1AS-2020 Clause 11.2.17.

I think what it boils down to is this:  (please correct me if I'm wrong)

When running PTP over multiple domains on one port, the P2P delay
needs only to be measured in one domain.  It would be wasteful to
measure the peer delay in multiple parallel domains.

linuxptp already provides PORT_DATA_SET.peerMeanPathDelay via management.
The only things missing AFAICT are:

1. neighborRateRatio - This can be provided via a new custom
   management message.

2. Inhibiting the delay mechanism as a per-port option.


All you need to implement CMLDS correction is:

1. nRR from one port, read by other ports via management.

2. periodic clock_gettime() on both ports to figure the rate
   difference between the two ports.

Having said that, because the NR differences will be tiny, and the p2p
message delay so short (like 100 nanoseconds or less), it is
practically worthless to apply the correction.  I personally wouldn't
bother, unless you can prove by measurement that the correction makes
a difference in the synchronization quality.

Thanks,
Richard
