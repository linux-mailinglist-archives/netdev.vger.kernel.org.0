Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14EE1A6289
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 07:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgDMFll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 01:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgDMFlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 01:41:37 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FEEC008677
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 22:22:15 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id np9so3414629pjb.4
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 22:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZO5kKSC4h32FwDfD7Q6VHkrIHHXtV1u/sKV+ex5uMtg=;
        b=0xnfSz4UbFRCWoxazvrNDbnyZhjYfPXo9pRDtsz4UOH8v4LDLfDt+s/cyIQqsqOUd1
         I5VsoZvKDmGO+A2ry+zdwNTpkO/VkpRgpw/484oLrZBS9WGRyJhU49tvckYF0uAJ5AT5
         O7RfPfPKKs9bbtcd8JH83+6yc/ayg06y497mrnB4Q36djztZv3/BkrxHCiJuWrC3SxJM
         2abrqO2SmnAHBWcVZS+tO4AZb0vj0ZnqZ2PrchztBA6y91ShKwhNmBV4B4TUFeY+GI1M
         54fBkefRSIfABIoFsbs7L0co80Wqgs0oJPimgewv9zIjhRkQc4N3dAAbmuzYWmVPv1u7
         WeTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZO5kKSC4h32FwDfD7Q6VHkrIHHXtV1u/sKV+ex5uMtg=;
        b=Fs5Ud4Ev8/Be3S9Uq2R/JWAHm2cJUiT33YaZ9UlIju+pVu6/DVv6wOOJ6IDs5VNqAS
         rmEnNmucw++meTlZQR3blHNQjqexdP9I6uqP17ZsOFMf1Iy9qQusn3C0wsmoAX3L1FdV
         T94MDlKlPiEicKuFZ3BNptPHCCCjmr9otC6e5co6GTxNofq8LEYyJyRPDTkB0V8WR6pJ
         IMsZe0JX+jvAQgK3KvNOZ/yBu7gUvm+yFd56WCcBVuPaljpB7sebZoJmgcB1qjaLyFEo
         /z77RS4xPNI6hY1lKpWp7WnuESlk/V1RtvrhP0UnjRzgK4wcI0FJ3ms45HhcOzv2KAW1
         UacQ==
X-Gm-Message-State: AGi0PuY1NGqfUcCQ3jNnU645ZA3GlxwZObIubkOVTFPLj0ZDjH7c3uSu
        gM34O2G3dToKU11qwzpqtJqVpA==
X-Google-Smtp-Source: APiQypLTEWNLQOPahKbZTj9Km5RcpCf9ZaUZ4ohK3E+VaXFHfJ98rTIoDpoAqV8U4yIlF7FaNC82Bg==
X-Received: by 2002:a17:902:b283:: with SMTP id u3mr15475592plr.311.1586755335271;
        Sun, 12 Apr 2020 22:22:15 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c59sm8347331pje.10.2020.04.12.22.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 22:22:14 -0700 (PDT)
Date:   Sun, 12 Apr 2020 22:22:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Fernando Gont <fgont@si6networks.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] Implement draft-ietf-6man-rfc4941bis
Message-ID: <20200412222205.04cb37cc@hermes.lan>
In-Reply-To: <20200408104458.GA15473@archlinux-current.localdomain>
References: <20200408104458.GA15473@archlinux-current.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020 07:44:58 -0300
Fernando Gont <fgont@si6networks.com> wrote:

> Implement the upcoming rev of RFC4941 (IPv6 temporary addresses):
> https://tools.ietf.org/html/draft-ietf-6man-rfc4941bis-09
> 
> * Reduces the default Valid Lifetime to 2 days
>   This reduces stress on network elements, among other things
> 
> * Employs different IIDs for different prefixes
>   To avoid network activity correlation among addresses configured
>   for different prefixes
> 
> * Uses a simpler algorithm for IID generation
>   No need to store "history" anywhere
> 
> Signed-off-by: Fernando Gont <fgont@si6networks.com>
> ---
>  Documentation/networking/ip-sysctl.txt |  2 +-
>  include/net/addrconf.h                 |  2 +-
>  include/net/if_inet6.h                 |  1 -
>  net/ipv6/addrconf.c                    | 85 +++++++++++---------------
>  4 files changed, 38 insertions(+), 52 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index ee961d322d93..db1ee7340090 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -1807,7 +1807,7 @@ use_tempaddr - INTEGER
>  
>  temp_valid_lft - INTEGER
>  	valid lifetime (in seconds) for temporary addresses.
> -	Default: 604800 (7 days)
> +	Default: 172800 (2 days)

You can't change defaults for existing users without a really good
argument.
