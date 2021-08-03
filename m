Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D37B3DE357
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 02:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhHCADU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 20:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhHCADS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 20:03:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E206AC06175F;
        Mon,  2 Aug 2021 17:03:07 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so1443426pjs.0;
        Mon, 02 Aug 2021 17:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8/q4C1bwlgB68t92asml5IhaRoB/GuHV7IviWSKcBGg=;
        b=pkgId/O8dOIgWQYV8LeIUsXWg43hnj4kmjrpusRJEDNgZwVoexR9fJ98vVjyvgdhLN
         i8OEihmGulpvailYIIeNRw0uxqGbAih/BzzL6rJi9qmrX7NiGRkqFs32NPepZIEazcou
         8TTpJKyEyTOYWs8ceLjCHwf2FIel9exgSwN3ZchQgbBqrE2SP61yUB2t1UcP1WByekvd
         KqezjOqH96akdkIXiJvQ9ElJ8kDqK1+HZYVh3r/fczOQsgAnleUaLp/s4hEg2men0Z0F
         FMSXlykixNY5opLFE81fp40kYdP2aNuKtDo5sWOro4ZUYokgvWWJ8RUTZ5iPj60fCueE
         nbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8/q4C1bwlgB68t92asml5IhaRoB/GuHV7IviWSKcBGg=;
        b=EpCGTmjEw286pLDPU+dqPtRdkSF0Yr5W3rx4MMveyFlOuX+5VfdqpAUHEGIMGsx8c6
         dLFxtGYPvDDCQ/EYnQhxjtTE9VdDZ84/25KC+BGog3ibQrMmZqaKwwUHNpVn8ILEwWXe
         tfLj4MEkGN6WmV4Z8dQgj/Zwol/MJqWPdMZTc4TjnWxfvJeSel3FT8Qlu/5BkIovonz5
         zRUUMtQsgNVrjMtZ8Edx3gy/nmiVFSJva9NjV5VVgIqFBCzGVqdSOgJx/HJgK0HdxFhc
         9x1AY/55rCycWbRH8oK+BS8T2JwdPoMjZAUe+a1GLaiKwOC0pthgVo8WERwslvWn0h4K
         Vacg==
X-Gm-Message-State: AOAM530YEy+Sv+5JEgIimIG0UdHevcFPIK0as9hnMANlfXwuQVavpuXF
        uouVZiUG4PpOm+wNtSfmGsA=
X-Google-Smtp-Source: ABdhPJy5vhcjJPVyM5rzN3CyVwIuiVCNmYRHO+711Nw8B8gB1aaeoc3HF06VT9Ak/yKjNyW72SemGA==
X-Received: by 2002:a05:6a00:1390:b029:32a:e2a2:74de with SMTP id t16-20020a056a001390b029032ae2a274demr19136371pfg.6.1627948987452;
        Mon, 02 Aug 2021 17:03:07 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id r3sm11683878pjj.0.2021.08.02.17.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 17:03:06 -0700 (PDT)
Date:   Mon, 2 Aug 2021 17:03:04 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Message-ID: <20210803000304.GA19119@hoboy.vegasvil.org>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <20210802230921.GA13623@hoboy.vegasvil.org>
 <CO1PR11MB508917A17F68DD927CD26A82D6EF9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB508917A17F68DD927CD26A82D6EF9@CO1PR11MB5089.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:45:09PM +0000, Keller, Jacob E wrote:
> Ok, so basically: if any driver that needs PTP core is on, PTP core is on, with no way to disable it.

Right.  Some MAC drivers keep the PTP stuff under a second Kconfig option.

IIRC, we (davem and netdev) decided not to do that going forwards.  If
a MAC has PTP features, then users will sure want it enabled.

So, let the MACs use "depends" or "select" PTP core.  I guess that
"select" is more user friendly.

And Posix timers: never disable this.  After all, who wants an
embedded system without timer_create()?  Seriously?

Thanks,
Richard


