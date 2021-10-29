Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E83943FD9A
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhJ2N4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhJ2N4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 09:56:00 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55F1C061570;
        Fri, 29 Oct 2021 06:53:31 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id kd16so6375631qvb.0;
        Fri, 29 Oct 2021 06:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z+CF8McLJtZXo6SHz1nxgycF8ae/xOR5hUS+LP7jGG8=;
        b=UN0Z0M+dhBwkt6q37PI/52rAjqga+C+ztLmr82Rnux6+JemIk7iBqqZlTOpuQA44kf
         /ihey/8C7DeRqq3u4bOtR/iow4iYRLK6QIOzy2E0YiZUzPRwSXh+FTrQH+3eQxdLkQki
         tsJJgLocQLDYzDkzWaEJtNHpXXjZw1bI2mVTjuWLozUFtRIu31vmFk90dW9vLncfRRkF
         z5+S3uATHVZnnAYYEPiaef5n2uOA0s+69QRMlxdjiG4kl7bk1mHOKRnArPt4P4Q9ZNSj
         gipG3c4clyWVBlDj5ZScf54k5GvPN4CD0Hwb8c/35NKoS6tQ6659IPSviBT+z7fxLLUG
         rwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z+CF8McLJtZXo6SHz1nxgycF8ae/xOR5hUS+LP7jGG8=;
        b=KZJHKlD/6QJ3XH8MZ0dIQEN9l5U1ckrTcD8PavyU3rJ64VeMfqW/cio16Vx3QMez3c
         BGMQdyBOGLo5iUbcOZyf1wcbxDmIURL36bhHUHfiNbLlz65+RWlHgR/TQp2tQYG27j8s
         Fj85K2d97tDE6hSDF70HwbOBuGPTAn2ueRK/7nV2ktV0biEotXc7l8yVKgtUlTPiBjiq
         TIH0mag6iLhAnm6wCYRKm8gDSbZ7evl+p3fy8NfqZs/Ow4Pg+SYvO43rRe8q+I5U/nM3
         hm/hamxspzUb1DzyQ4k/rClTycbmFV4P0JWjLFJhZJDKahG+PqpdV+6pHHVS8qpqJCt3
         MGkg==
X-Gm-Message-State: AOAM532AojaSCtlEPS8HYNg6CUip5p/R/e2Nk1+/lekv7cq3EPkcrSBq
        galaYg+Kw8lNTWLhh1AoZ3w=
X-Google-Smtp-Source: ABdhPJx6gNizjT3moPdCwjo/KPDiRGAqujQKL/z/JSuLaswrwaTXrXIMdIdAYHKSiSONMNxlBVRKyw==
X-Received: by 2002:a05:6214:dcf:: with SMTP id 15mr11015072qvt.23.1635515611085;
        Fri, 29 Oct 2021 06:53:31 -0700 (PDT)
Received: from Zekuns-MBP-16.fios-router.home (cpe-74-73-56-100.nyc.res.rr.com. [74.73.56.100])
        by smtp.gmail.com with ESMTPSA id u6sm444100qtc.86.2021.10.29.06.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 06:53:30 -0700 (PDT)
Date:   Fri, 29 Oct 2021 09:53:28 -0400
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Pontus Fuchs <pontus.fuchs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ar5523: Fix null-ptr-deref with unexpected
 WDCMSG_TARGET_START  =?ISO-8859-1?Q?=20reply=1B?=
Message-ID: <YXv82KfKCW3eHhE6@Zekuns-MBP-16.fios-router.home>
References: <YXsmPQ3awHFLuAj2@10-18-43-117.dynapool.wireless.nyu.edu>
 <87tuh0xz9h.fsf@tynnyri.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tuh0xz9h.fsf@tynnyri.adurom.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 06:53:30AM +0300, Kalle Valo wrote:
> Zekun Shen <bruceshenzk@gmail.com> writes:
> 
> > Unexpected WDCMSG_TARGET_START replay can lead to null-ptr-deref
> > when ar->tx_cmd->odata is NULL. The patch adds a null check to
> > prevent such case.
> >
> > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> >  ar5523_cmd+0x46a/0x581 [ar5523]
> >  ar5523_probe.cold+0x1b7/0x18da [ar5523]
> >  ? ar5523_cmd_rx_cb+0x7a0/0x7a0 [ar5523]
> >  ? __pm_runtime_set_status+0x54a/0x8f0
> >  ? _raw_spin_trylock_bh+0x120/0x120
> >  ? pm_runtime_barrier+0x220/0x220
> >  ? __pm_runtime_resume+0xb1/0xf0
> >  usb_probe_interface+0x25b/0x710
> >  really_probe+0x209/0x5d0
> >  driver_probe_device+0xc6/0x1b0
> >  device_driver_attach+0xe2/0x120
> >
> > Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
> 
> How did you test this?
I found the bug using a custome USBFuzz port. It's a research work
to fuzz USB stack/drivers. I modified it to fuzz ath9k driver only,
providing hand-crafted usb descriptors to QEMU.

After fixing the code (fourth byte in usb packet) to WDCMSG_TARGET_START, 
I got the null-ptr-deref bug. I believe the bug is triggerable whenever
cmd->odata is NULL. After patching, I tested with the same input and no
longer see the KASAN report.
> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
