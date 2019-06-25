Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E39555873
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfFYULb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:11:31 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45224 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYULa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:11:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id bi6so27627plb.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RVMTwPnPyoI1x5PBBVvlZKHhj4J2rdMINoyfeiNoRY4=;
        b=FRyHpRmkxt71INP82A8ah4MgAo7Th9CdpqzkqW2xdbJbIPXQF68XgUIyzGOKwu18kx
         yc2g+7oRI4BePn8XfMtvVIXy0pHrz79lKjk9eihEU8wUpu1TY5b6NNjC8e21uJ2gYtFi
         wZwx36f/ZSayt9JlOD5d3m+5mS+eAbIV5OxDA/cY7mYRcFbch5Px7QvYIp2bFB6fWqQB
         oc+aALQ+69JY/UVMmezRJXWLh6po64mKIPjsIDExstXtPAwGeIax6GvIN58HjFHqSC7L
         I1iMZ4g19zmP7/3RaY2AoeUmAqD30BKWaAZXi4wvNoOA21qoI/yl3qOT0IiH9Psta84J
         TA9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RVMTwPnPyoI1x5PBBVvlZKHhj4J2rdMINoyfeiNoRY4=;
        b=PI7QwzefYWhqfYCl3cQjmNe8hNNC2ucbOUSZX4LrTJVczeQhusiu2b+QHNj8iVtIwq
         C/DhChRD9QbnBHd/Iz1QAp4xn4bmAYxveF+rrO/8A5U3WA5P3Lhj8LwbvYgTgjDhCYpy
         kBLsgTNPSVq9K7yrUCVbJoWbrc7lACjnu+J4p+2kXiYXiYZnoFCxMuQsfa+//jU/xaJZ
         O+ac2UrDgJ0LpLNN7EjaeE97M/2vmexuolT2y9VBfEeG0X+IRBNgvrx5VVdrCo+fP8JL
         0QITasM/fBSRZOBwL0Ea6mcY95GVl4z1/aEWtWPby2/zgr5pNOF+KZk+FJYn02hAgMEf
         I0KA==
X-Gm-Message-State: APjAAAVDh7uEcRDUbnPYS+ImcdXdp2sBuPd5c24DHsFhZDAlmUCaamUT
        rTpvb7e3OowNuSQJT82G4kRcgA==
X-Google-Smtp-Source: APXvYqzP91UuoJ1RRHZvpsFCC/BkmvOplcm/iCR+4qrcFFDEU4x1/YF+WhtlAuCVyRzydSPK20b+Xw==
X-Received: by 2002:a17:902:1003:: with SMTP id b3mr581592pla.172.1561493489997;
        Tue, 25 Jun 2019 13:11:29 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id bo20sm67487pjb.23.2019.06.25.13.11.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 13:11:29 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:11:26 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Phil Sutter <phil@nwl.cc>, David Ahern <dsahern@gmail.com>,
        Andrea Claudi <aclaudi@redhat.com>
Subject: Re: [PATCH iproute2] ip/iptoken: fix dump error when ipv6 disabled
Message-ID: <20190625131126.6a7121b4@hermes.lan>
In-Reply-To: <20190625093550.7804-1-liuhangbin@gmail.com>
References: <20190625093550.7804-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 17:35:50 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> When we disable IPv6 from the start up (ipv6.disable=1), there will be
> no IPv6 route info in the dump message. If we return -1 when
> ifi->ifi_family != AF_INET6, we will get error like
> 
> $ ip token list
> Dump terminated
> 
> which will make user feel confused. There is no need to return -1 if the
> dump message not match. Return 0 is enough.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  ip/iptoken.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/ip/iptoken.c b/ip/iptoken.c
> index f1194c3e..dfd22734 100644
> --- a/ip/iptoken.c
> +++ b/ip/iptoken.c
> @@ -59,13 +59,9 @@ static int print_token(struct nlmsghdr *n, void *arg)
>  	if (len < 0)
>  		return -1;
>  
> -	if (ifi->ifi_family != AF_INET6)
> -		return -1;
> -	if (ifi->ifi_index == 0)
> -		return -1;
> -	if (ifindex > 0 && ifi->ifi_index != ifindex)
> -		return 0;
> -	if (ifi->ifi_flags & (IFF_LOOPBACK | IFF_NOARP))
> +	if (ifi->ifi_family != AF_INET6 || ifi->ifi_index == 0 ||
> +	    (ifindex > 0 && ifi->ifi_index != ifindex) ||
> +	    (ifi->ifi_flags & (IFF_LOOPBACK | IFF_NOARP)))
>  		return 0;

Please don't combine all the conditions, it is simpler as:

	if (ifi->ifi_family != AF_INET6)
		return 0;

	
