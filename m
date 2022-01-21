Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C883A4958BC
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 05:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiAUEFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 23:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiAUEFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 23:05:12 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FB3C061574;
        Thu, 20 Jan 2022 20:05:12 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id p125so7174859pga.2;
        Thu, 20 Jan 2022 20:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PXjzs2ORwNdG7MiCJrx7cQxN5MdTrOLJkoufb+btUjY=;
        b=OT1Twxo4gieLaNzM8Jo6wtoGAKsVj/cMffoFSqf+MtOFGT+4xm9DVXYxBBwyHN3f3R
         Fxu3poB2HImt13TgzfhsFPiuqxu4Rsa6ggglb2GVFYxPvDFFh3k/5WGnG+bajf2nifSE
         VlngnsQNnOxs5LqCjFrGip2/RV9zS5jhjFcMB61SqX3+drZrkdcYMUoDuUoHyeFkLF6E
         8GjhIQhWp6tQQyT0bvJZ7hwfbCavwIb0gsXzfYmrkRbZsm5YEmFAcFxN1K19671CgZ7d
         uN8o2xyXSsLCIfr9ztFaZHXbz4NiDgKkHPWfnd88kcA4FHsAppV/mCm6D3mlsBp8Pb+Z
         xEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PXjzs2ORwNdG7MiCJrx7cQxN5MdTrOLJkoufb+btUjY=;
        b=SmCKe3GbdTWg4XuJ069sTqGz/jb7XlXKXG5G3xz9MlPtneVeQe/ii5QL9w1V6R/bvz
         5zn3UJVvsjh/lL6XmLaW0J8fJ5YG8gY0WORNfT80rrKKGm27lYXpnpWEerjtk6KLlO/v
         xWv9RTa0eeiX4HGs6oJmU1xsaFPB2WgcO3Nn6Yy7AK99VHNi+nfre/LlMvTf8C0Yr6Bj
         LUj5pcHNF6S6rvSf1SgjJFPQ8DDTTX+MBnZo16Nu89zsDUZdYj/Tmxiqh1acNSlZUfoS
         fZvpdv0/+/2vE3Kt17dpSKG5UWSyop7PJ+84TvNmvs3+UCpYla9s9b0WrPy9y70NtuGs
         O2MA==
X-Gm-Message-State: AOAM532ZzMeDrz0De2bEXpHabJVs5NlGIlxJss3P8Ky3ZGkjkkF+rxb8
        d7GlAuugfls26+AsDykIEJo=
X-Google-Smtp-Source: ABdhPJxsIrAwQLT5vKIUdy2z0rmKcpsFY+qjwmtwc0TE4iahtr4b86iCSZKz++wUTd21sM58KvPQbw==
X-Received: by 2002:a63:81c8:: with SMTP id t191mr1638088pgd.135.1642737911690;
        Thu, 20 Jan 2022 20:05:11 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z17sm5214946pfe.10.2022.01.20.20.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 20:05:11 -0800 (PST)
Date:   Thu, 20 Jan 2022 20:05:08 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <20220121040508.GA7588@hoboy.vegasvil.org>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf>
 <Yeoqof1onvrcWGNp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yeoqof1onvrcWGNp@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 04:38:09AM +0100, Andrew Lunn wrote:

> So in the extreme case, you have 7 time stamps, 3 from MACs and 4 from
> PHYs!

:^)
 
> I doubt we want to support this, is there a valid use case for it?

Someday, someone will surely say it is important, but with any luck
I'll be dead by then...

Cheers,
Richard
