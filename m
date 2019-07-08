Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90A1B620D5
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731994AbfGHOqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:46:44 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42515 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731924AbfGHOqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 10:46:43 -0400
Received: by mail-ed1-f67.google.com with SMTP id v15so8170339eds.9;
        Mon, 08 Jul 2019 07:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5eQOVvdsTaaanCiXUg5m0ecZfqkTs7/uYhCRVIzkQcY=;
        b=ho5fb5e98j7lt1EqeRVgFK9P2ThmVuNWY/IsNL32+L6vGvmk6b6O/bdL1Yanif0Ozb
         C+14ZlVaESAoumg1W88RpiOB+W8BfJ2H/bsHXNRP4oLpbwZzgBdgPq0Bp1hRpJv5YFT4
         WDHyzTLj8VC4p0fVvhyzGuAsTu+ztmqL3oC2L+mhVQ+lE4l3Y0p4pN9mbV+dBye4sIjb
         2gpvmBV2IMoHL6cl7qtkVIK/elGiX/5uPqRAU3xMsXVGRY76vEnTcLP2P1DHQ1SD2kFZ
         ESdKiA0/5bbWCBsdv0374XyjD05TZ6hgkjvFlYOximPS0FPAfpRsfSPK3110UeYli4Vr
         eBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5eQOVvdsTaaanCiXUg5m0ecZfqkTs7/uYhCRVIzkQcY=;
        b=ZKH/guiJd0QkgdpSFzp7NfU6qHTEj15DXkCFKzsEJY69BDXJpn4GFPeOOjg7bWucNg
         eqnwr9/E2hZiexrhDb7aZfGbwn0a2oph/92DXXpEvk5+iKOaw4ITG190VC6JDREUJTGE
         IPq7AX94y6JCy3NCJ2QpzgbcbXc9pdMC+9iVWpppRmNhOXZWjwh4zn3HCgCJz+HSNyPx
         xIsgQF+wfLqLTQzKEeyDEpSBnQ0Mra9iegLqdQP8FKOIaClIGxx50NwBnQK3T9aaMSLS
         EIiMCZVQnQJa6drpaJ1uJ5F+gdQRtqgndlxmkBvUnCfLD6M8G8bzvutx8SB4rmwT1ez2
         QxIQ==
X-Gm-Message-State: APjAAAWum3iyNSTW5HMzHGJcm0TvOi/APX4ccfeTX9wxWobGUTDDVMsE
        Z8+vjHVZN7fK919pQzBNWpPtmhPfLuTZKA==
X-Google-Smtp-Source: APXvYqzsH/zRjVF76SiNwOOyuGr87Edn3PdTFH2U9QMtHFyQ3k6tAFR2z82Bhu61OHAzBrKaNrhaUA==
X-Received: by 2002:a17:906:454d:: with SMTP id s13mr17053544ejq.255.1562597201565;
        Mon, 08 Jul 2019 07:46:41 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id j7sm5767060eda.97.2019.07.08.07.46.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 07:46:40 -0700 (PDT)
Date:   Mon, 8 Jul 2019 07:46:38 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Pradeep kumar Chitrapu <pradeepc@codeaurora.org>,
        Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ath10k: work around uninitialized vht_pfr variable
Message-ID: <20190708144638.GA43693@archlinux-epyc>
References: <20190708125050.3689133-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708125050.3689133-1-arnd@arndb.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 02:50:06PM +0200, Arnd Bergmann wrote:
> As clang points out, the vht_pfr is assigned to a struct member
> without being initialized in one case:
> 
> drivers/net/wireless/ath/ath10k/mac.c:7528:7: error: variable 'vht_pfr' is used uninitialized whenever 'if' condition
>       is false [-Werror,-Wsometimes-uninitialized]
>                 if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7551:20: note: uninitialized use occurs here
>                 arvif->vht_pfr = vht_pfr;
>                                  ^~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7528:3: note: remove the 'if' if its condition is always true
>                 if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7483:12: note: initialize the variable 'vht_pfr' to silence this warning
>         u8 vht_pfr;
> 
> Add an explicit but probably incorrect initialization here.
> I suspect we want a better fix here, but chose this approach to
> illustrate the issue.

Yup, I reached out to the maintainers when this issue first cropped up,
should have taken your approach though.

https://lore.kernel.org/lkml/20190702181837.GA118849@archlinux-epyc/

Initializing to zero is better than uninitialized.

> 
> Fixes: 8b97b055dc9d ("ath10k: fix failure to set multiple fixed rate")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
