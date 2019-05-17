Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C0621D15
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 20:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfEQSHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 14:07:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36737 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfEQSHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 14:07:05 -0400
Received: by mail-pl1-f193.google.com with SMTP id d21so3701932plr.3
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 11:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5J9gcie1Z3U0pcnDnyJYuT1zOmLabdsmrTYt+C5O32I=;
        b=epxAPApDVqTkUG7JCwE4LcKl97Hrq+Kk8rFZKmsNmXjldx4VOFbSjpFgr6MnioQ7bF
         wuY/WfZr0ABOzoDCdbM9rpuKZKOMcl2pEGhO13wS3YBO8aTJJeDQE5pfaJcbeNOot9sO
         6LeXA3cTfVWoDiTp+IAwGuP7WJmWK1bgiWqKD1hoddDzyT6mMysHuHIVZNYInvR3l/Z5
         URyEZFZ30pyOUeluUAwWo+TAnRoAC+JQz82AGUMPay+h1V2dLlgPUQ2JkiA890azyn5f
         jkpMsu13i0YKZedC88MQXdCTWSCgLDwjfMAJrCVXH2COX2q56hlS+ZfoWivS8W7BFx2w
         ku3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5J9gcie1Z3U0pcnDnyJYuT1zOmLabdsmrTYt+C5O32I=;
        b=JYqs6vRVOKPbE237/R1Hw11x6cesHhpadHruiEFnkxe5jrPm0lQTK3XsPpvPyJ98bv
         OfVw58oidIStSF3DJwUCSZH6zyr6WTT0DUJwYmCBOy80n+R7L8EyGcNtNyVg6IN88mpV
         LVsnxvE9LekZHD/m3tkx8Hud4geypLo20hQHdzSzUecCkpKmTY+U5OJBloguGz/v1XJp
         rzYfKbzPt2CIsPov2pRulKFRLnKhEGhNirrkLtMYes51jsKzMeLRqn5ivf0GKiN9lzHX
         +MDMG+C34SaNlD01aRWNxM61CTpHrDrSXXDlYn72qy9hNuSc6Ow+xoxAuy6XCk55jXAA
         uzkQ==
X-Gm-Message-State: APjAAAUyeaFhIAtxt3kimzWbVgqC5pIqsgtMox1aELQHbafyyfJpkYgA
        YV918yKk324JDk/5SdM9eiOc1Q==
X-Google-Smtp-Source: APXvYqwaBToyzPl0rGFdGbDp7oo5ruZZ7/VSnevNrTiPPtNm1/pIyOYruPIiS5D1amm9gAo7fSqo1w==
X-Received: by 2002:a17:902:347:: with SMTP id 65mr45713388pld.232.1558116424997;
        Fri, 17 May 2019 11:07:04 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s19sm8949180pfh.176.2019.05.17.11.07.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 11:07:04 -0700 (PDT)
Date:   Fri, 17 May 2019 11:06:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, Jason@zx2c4.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] ip route: Set rtm_dst_len to 32 for all ip
 route get requests
Message-ID: <20190517110658.544d3986@hermes.lan>
In-Reply-To: <20190517175913.20629-1-dsahern@kernel.org>
References: <20190517175913.20629-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 May 2019 10:59:13 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dsahern@gmail.com>
> 
> Jason reported that ip route get with a prefix length is now
> failing:
>     $ 192.168.50.0/24
>     RTNETLINK answers: Invalid argument
> 
> iproute2 now uses strict mode and strict mode in the kernel
> requires rtm_dst_len to be 32. Non-strict mode ignores the
> prefix length, so this allows ip to work without affecting
> existing users who add a prefix length to the request.
> 
> Fixes: aea41afcfd6d6 ("ip bridge: Set NETLINK_GET_STRICT_CHK on socket")
> Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  ip/iproute.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/ip/iproute.c b/ip/iproute.c
> index 2b3dcc5dbd53..d980b86ffd42 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -2035,7 +2035,11 @@ static int iproute_get(int argc, char **argv)
>  			if (addr.bytelen)
>  				addattr_l(&req.n, sizeof(req),
>  					  RTA_DST, &addr.data, addr.bytelen);
> -			req.r.rtm_dst_len = addr.bitlen;
> +			/* kernel ignores prefix length on 'route get'
> +			 * requests; to allow ip to work with strict mode
> +			 * but not break existing users, just set to 32
> +			 */
> +			req.r.rtm_dst_len = 32;
>  			address_found = true;
>  		}
>  		argc--; argv++;

I don't like silently ignoring things. It was wrong before and it
is trapped now.

Probably better to error out in iproute2 if any prefix is given.
