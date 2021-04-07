Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E10D3574A3
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355490AbhDGS4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355476AbhDGS4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 14:56:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66835C061762
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 11:56:08 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso1799596pji.3
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 11:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bUFX8OZjFldaYb/6zcLiSui0pTc7lp3Q3DWh7esaF8g=;
        b=a1xRCOqlDFc7fMaWuNejJHG4Uwf7By9zy2OKAtPQ27xGklMzMvChcENop0/v+mOMEx
         MW6+86rti2fEGc6b+oX4cnfwPSqf7GbCQ41o+BKscycaOnSgArho8f9BO6FrTo4gYnow
         aM5rfU2N378Fjx1Amj6OkdpP5/Dtb0+r7QDOA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bUFX8OZjFldaYb/6zcLiSui0pTc7lp3Q3DWh7esaF8g=;
        b=jTG+rAnfbSrzTn0LKtUrpdz6WESu29HxFYBgpqsAwbfx1RzJOZr0to5mHSTuS4jY7H
         wp05lHEL0idPWI7B3KSbg1dYp9Ko+IuSvvC4u/i0rpiClRke3eFRi43xBkp3iPHL2mf8
         FR6NI0DI88xMXaXK9WoPU9SZCYhizH6Lb8QUAzsVX3TJfPW4US9OdbdiPSZAAFLYcUBj
         n3bqKHgvNggKkChmKAXmrQWNS1V8BWLR713kuyNOR8NBKvYPxs7fO3iSmF5GYKKwjPAQ
         hEyh5DK+wG8VuSnj+mPAlglP5IHa2ZiH45QINiMAe/1jEarJzepzre/T4Cd30Imd6rIO
         iEmg==
X-Gm-Message-State: AOAM53312ZddRD16LCKBBR2ncA9wMXx18IXLSC0eBzmkD9+KunkSwaSy
        U13BRV+L2UbsRewTTWfTqiNtdQ==
X-Google-Smtp-Source: ABdhPJyqOjE2YRcwObcLLiGu2bq48+Q2tF9rRkC6ywJ1L+rDrieu6AYwkNRmg39F3ypuOEZU45TvvA==
X-Received: by 2002:a17:90a:a389:: with SMTP id x9mr3803993pjp.232.1617821767869;
        Wed, 07 Apr 2021 11:56:07 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h19sm22438097pfc.172.2021.04.07.11.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 11:56:07 -0700 (PDT)
Date:   Wed, 7 Apr 2021 11:56:06 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 1/2][next] wl3501_cs: Fix out-of-bounds warning in
 wl3501_send_pkt
Message-ID: <202104071154.49B15A3AB4@keescook>
References: <cover.1617226663.git.gustavoars@kernel.org>
 <e03d36114bcbcf814ad13deb7812b0b5c196dadb.1617226663.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e03d36114bcbcf814ad13deb7812b0b5c196dadb.1617226663.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 04:44:29PM -0500, Gustavo A. R. Silva wrote:
> Fix the following out-of-bounds warning by enclosing
> structure members daddr and saddr into new struct addr:
> 
> arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [18, 23] from the object at 'sig' is out of the bounds of referenced subobject 'daddr' with type 'u8[6]' {aka 'unsigned char[6]'} at offset 11 [-Warray-bounds]
> 
> Refactor the code, accordingly:
> 
> $ pahole -C wl3501_md_req drivers/net/wireless/wl3501_cs.o
> struct wl3501_md_req {
> 	u16                        next_blk;             /*     0     2 */
> 	u8                         sig_id;               /*     2     1 */
> 	u8                         routing;              /*     3     1 */
> 	u16                        data;                 /*     4     2 */
> 	u16                        size;                 /*     6     2 */
> 	u8                         pri;                  /*     8     1 */
> 	u8                         service_class;        /*     9     1 */
> 	struct {
> 		u8                 daddr[6];             /*    10     6 */
> 		u8                 saddr[6];             /*    16     6 */
> 	} addr;                                          /*    10    12 */
> 
> 	/* size: 22, cachelines: 1, members: 8 */
> 	/* last cacheline: 22 bytes */
> };
> 
> The problem is that the original code is trying to copy data into a
> couple of arrays adjacent to each other in a single call to memcpy().
> Now that a new struct _addr_ enclosing those two adjacent arrays
> is introduced, memcpy() doesn't overrun the length of &sig.daddr[0],
> because the address of the new struct object _addr_ is used as
> destination, instead.
> 
> Also, this helps with the ongoing efforts to enable -Warray-bounds and
> avoid confusing the compiler.
> 
> Link: https://github.com/KSPP/linux/issues/109
> Reported-by: kernel test robot <lkp@intel.com>
> Build-tested-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/lkml/60641d9b.2eNLedOGSdcSoAV2%25lkp@intel.com/
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks, this makes the code much easier for the compiler to validate
at compile time. These cross-field memcpy()s are weird. I like the
solution here.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
