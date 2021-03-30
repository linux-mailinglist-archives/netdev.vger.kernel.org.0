Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862D934EF28
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhC3RP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232457AbhC3RPA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:15:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8DF36196C;
        Tue, 30 Mar 2021 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617124500;
        bh=zFd4Zy9omtYczkx8Q+u+p99RL4k+y2CVgywzbgmq3CQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NH4+8ibub3gj+9Z9u3GOr74NH3ciLFEQ4gjcAdTfLKmWdFW02zspzXUHkjbs7qDqR
         ANVhxneXAfVr0lFmFDJhm1GAGYNvyG2BmNzFNNLht+IxJXbIhDYE1MAeUtCgEoBs5w
         6jF6XyZszHMoW70Gs5CPNs/6MNlh06x8a896fBAA=
Date:   Tue, 30 Mar 2021 19:14:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alaa Emad <alaaemadhossney.ae@gmail.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com,
        syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] wireless/nl80211.c: fix uninitialized variable
Message-ID: <YGNckfKCPuS5g5UX@kroah.com>
References: <20210330163705.8061-1-alaaemadhossney.ae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330163705.8061-1-alaaemadhossney.ae@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 06:37:05PM +0200, Alaa Emad wrote:
> This change fix  KMSAN uninit-value in net/wireless/nl80211.c:225 , That
> because of `fixedlen` variable uninitialized,So I initialized it by zero.
> 
> Reported-by: syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
> Signed-off-by: Alaa Emad <alaaemadhossney.ae@gmail.com>
> ---
> Changes in v2:
>   - Make the commit message more clearer.
> ---
>  net/wireless/nl80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 775d0c4d86c3..b87ab67ad33d 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -210,7 +210,7 @@ static int validate_beacon_head(const struct nlattr *attr,
>  	const struct element *elem;
>  	const struct ieee80211_mgmt *mgmt = (void *)data;
>  	bool s1g_bcn = ieee80211_is_s1g_beacon(mgmt->frame_control);
> -	unsigned int fixedlen, hdrlen;
> +	unsigned int fixedlen = 0 , hdrlen;

Please always use scripts/checkpatch.pl before sending out patches.  It
would have pointed out that this line is incorrect and needs to be fixed
up  :(

thanks,

greg k-h
