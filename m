Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9EFF63D68
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbfGIViG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:38:06 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34028 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGIViF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:38:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so11807pfo.1
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 14:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C5FAI3uOM7Lx28/LeozDIkvJkk2FSYuAG2vHEiv5SWs=;
        b=A4TMOOTFBdxCNOvd7o4YhULAq6wc4x8qnKYF81+EqEwYlnjXFQ0h79UPIIhL2BOsDs
         4lGaRGmB5KqJtJlZjqerulkmlwFzKR0P5okWyEy1KoTPg3Ck6PrMfdP1BNNi5RJEolQK
         HUGQxKpEWcipI5qdheMBKtDpnuNJ98omwzFCGZqnlg0sSZIHR3GYITLZFAKIRA06JhDQ
         v7KC10x1xzbIig9Yxm/8zkmkMxLy2YDZFzEG0vbyYIPyIl3yLOCR+W2Eg+hqNN3MPYSd
         JlRJ+mXW3uA4+qrpdzG0SYz4QdrgC/UVeOYMr/e6zUcmfexSgojgVo+wjLbjU2D5+aEt
         CMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C5FAI3uOM7Lx28/LeozDIkvJkk2FSYuAG2vHEiv5SWs=;
        b=WZhspkjnFwNaTzL38syhweSFmcT3ZddoNfc00XAWRF26O5kh7I5ay2aQwNLNJq9A7C
         am5Uud0UE7XZ5UKpK0xvIOcT0UTO52bJzwApgi0XoFulIbFdPnDQ/eUqW9z10q2I3qkK
         1JL/Hke1ct1cPXjO+dH6J7XwLO7MaatIo1uyxvcjrNZeFnhqOeMbPtRrKZiH7A4anqZB
         s2okwsminalMWcMxZr6/JQZl0Rmqaw0BrfojdwYyGX8PtRSkdcmMKqKGKe/UJtRBItPT
         YvGH/OHRxc1ZJYq8eS1wFIePwN+6UzGmY11uHUckJjrQXBBXKBj8MKLiPNzAEHpVRhnf
         KHcA==
X-Gm-Message-State: APjAAAXwjgNG5qg95akMrk9S32kR/Unlrjtc+AM8w6ouIDY0GGTWg+bs
        ljFw3AVhohcfZk1MbTkq6TKfOA==
X-Google-Smtp-Source: APXvYqzkXrG6M031yt9wEPhjs/RVygNeXUXzqJxdvz270JxY3JH+U0Ru4qHAkwc9T8ITDEaVtTvPzg==
X-Received: by 2002:a63:5045:: with SMTP id q5mr32231977pgl.380.1562708284885;
        Tue, 09 Jul 2019 14:38:04 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v22sm31308pgk.69.2019.07.09.14.38.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 14:38:04 -0700 (PDT)
Date:   Tue, 9 Jul 2019 14:37:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2] utils: don't match empty strings as prefixes
Message-ID: <20190709143758.695a65bc@hermes.lan>
In-Reply-To: <20190709204040.17746-1-mcroce@redhat.com>
References: <20190709204040.17746-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Jul 2019 22:40:40 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> iproute has an utility function which checks if a string is a prefix for
> another one, to allow use of abbreviated commands, e.g. 'addr' or 'a'
> instead of 'address'.
> 
> This routine unfortunately considers an empty string as prefix
> of any pattern, leading to undefined behaviour when an empty
> argument is passed to ip:
> 
>     # ip ''
>     1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>         inet 127.0.0.1/8 scope host lo
>            valid_lft forever preferred_lft forever
>         inet6 ::1/128 scope host
>            valid_lft forever preferred_lft forever
> 
>     # tc ''
>     qdisc noqueue 0: dev lo root refcnt 2
> 
>     # ip address add 192.0.2.0/24 '' 198.51.100.1 dev dummy0
>     # ip addr show dev dummy0
>     6: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
>         link/ether 02:9d:5e:e9:3f:c0 brd ff:ff:ff:ff:ff:ff
>         inet 192.0.2.0/24 brd 198.51.100.1 scope global dummy0
>            valid_lft forever preferred_lft forever
> 
> Rewrite matches() so it takes care of an empty input, and doesn't
> scan the input strings three times: the actual implementation
> does 2 strlen and a memcpy to accomplish the same task.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  include/utils.h |  2 +-
>  lib/utils.c     | 14 +++++++++-----
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/include/utils.h b/include/utils.h
> index 927fdc17..f4d12abb 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -198,7 +198,7 @@ int nodev(const char *dev);
>  int check_ifname(const char *);
>  int get_ifname(char *, const char *);
>  const char *get_ifname_rta(int ifindex, const struct rtattr *rta);
> -int matches(const char *arg, const char *pattern);
> +int matches(const char *prefix, const char *string);
>  int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits);
>  int inet_addr_match_rta(const inet_prefix *m, const struct rtattr *rta);
>  
> diff --git a/lib/utils.c b/lib/utils.c
> index be0f11b0..73ce19bb 100644
> --- a/lib/utils.c
> +++ b/lib/utils.c
> @@ -887,13 +887,17 @@ const char *get_ifname_rta(int ifindex, const struct rtattr *rta)
>  	return name;
>  }
>  
> -int matches(const char *cmd, const char *pattern)
> +/* Check if 'prefix' is a non empty prefix of 'string' */
> +int matches(const char *prefix, const char *string)
>  {
> -	int len = strlen(cmd);
> +	if (!*prefix)
> +		return 1;
> +	while(*string && *prefix == *string) {
> +		prefix++;
> +		string++;
> +	}
>  
> -	if (len > strlen(pattern))
> -		return -1;
> -	return memcmp(pattern, cmd, len);
> +	return *prefix;
>  }
>  
>  int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits)

ERROR: space required before the open parenthesis '('
#134: FILE: lib/utils.c:895:
+	while(*string && *prefix == *string) {

total: 1 errors, 1 warnings, 30 lines checked

The empty prefix string is a bug and should not be allowed.
Also return value should be same as old code (yours isn't).



