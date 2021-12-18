Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFA2479850
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhLRDKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:10:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50162 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhLRDKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:10:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 739EFB82ADB
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 03:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6140C36AE1;
        Sat, 18 Dec 2021 03:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639797008;
        bh=MrrJUvj3WlplkdaVIIezj6t6NBXvD2Wm47S3c11FS5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=grp2ezEgyKJTRBYpx17X4wx7vdFbf9EU401ylCDUi5WMXktN88vinR3ZJ+DmXYVxD
         WawCUHaXvvFoTTw5wyPUDjHrjsmIgUtxsp0uyZHvF9T55y969owEW/5BrdQOf2kk9J
         KHwNy90iyzQWmp7e1wx0ae4MJSCQOpQ+0sw4Bz0w/Z6tDFRWNjFX9a6neiovlXUgo4
         HaF3TUorMfwpEhD+D5YumGryfvIfBvYXJzipmjjNG71YUcLBOj7jRjS0ZvGwuctpdi
         yg1nbMteSMJeteTvwRY0e0gQXflnfP+8cAUYqXEtxrRZ+LMDlM+XFfI8ya1sSkhgaA
         0H0qXKD72sZvQ==
Date:   Fri, 17 Dec 2021 19:10:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH 1/5] ptp: ocp: Add ptp_ocp_adjtime_coarse for large
 adjustments
Message-ID: <20211217191006.6d1bdb1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211216200104.266433-1-jonathan.lemon@gmail.com>
References: <20211216200104.266433-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 12:01:00 -0800 Jonathan Lemon wrote:
> In ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime."), the
> ns adjustment was written to the FPGA register, so the clock could
> accurately perform adjustments.
> 
> However, the adjtime() call passes in a s64, while the clock adjustment
> registers use a s32.  When trying to perform adjustments with a large
> value (37 sec), things fail.
> 
> Examine the incoming delta, and if larger than 1 sec, use the original
> (coarse) adjustment method.  If smaller than 1 sec, then allow the
> FPGA to fold in the changes over a 1 second window.
> 
> Fixes: 2d97ed56f671 ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime.")

This SHA does not exist upstream. Please separate the fixes from the
features. Please CC Richard on the patches.
