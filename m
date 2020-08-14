Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8C6244C1E
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 17:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgHNP2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 11:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbgHNP2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 11:28:05 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC705C061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 08:28:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s15so4695045pgc.8
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 08:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c7uNM8Gy1kbQT64V2s6Yo+EyqpoCo3FsPH5b97bLSdc=;
        b=lPSFT9SiJvDSCnjFe/xx10qnx5K8l8Af40U9kpab/GlJuUaXO/cMylzlZL0VgmYaQq
         AcsgXVS76/J8ZlwpKbSkWGspyJ/VvXOTPmt5Z5L4znYPIgT5icLbmTbsiE80+lFeQx/9
         0NaeSwvCDgGTVeTmawk1/ZtCpl6E79+Lr+M0HB1ZjfJopq0Fb24/thp9RfWO87nQwr0I
         d/o/FGtF94GA/ZkwJnKyAnhtF+1LZ7XWJc9DM3sLy9RLrrzBsxM07iEu7GReMnZa8hSk
         Qum4fHn4JTMxW1zRVbzv5JCh50DYdRhli9bLXtqVoD7ijBTCIOquaMSGIMyrLoS+UfZq
         1ThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c7uNM8Gy1kbQT64V2s6Yo+EyqpoCo3FsPH5b97bLSdc=;
        b=SmGKTTi5skRjUNWYk719hP6ycuZMsNCXJfZ/YuNTVnr/aOGcy5k6c5eOSq1z7cU14e
         eWljURlC+r4Zf6ryyXQAicUzNHGqOek7mzhl7kQUZaqfHi7hf27SlKB+HcWC/+Q7u0GV
         66bxZHyVTPK3cPTrUZysplkCJ0GxT/2HcPgD/3O2Wq3ObMhNnibW90FYwaTUxMjm11bO
         yjb1cqwOqLCM4urs5w2QNrsGUpLrdAVun+5HupKtmEJ2Hpv1FdLxZ/uda1hxeEmwcE4D
         4tpIG2CXJgpWIgcFNKvECpVxMXuVlElL3BmqhBF01ynm055dj0SzbhLCDRkKwN2qvG6a
         YAbQ==
X-Gm-Message-State: AOAM533FCdGW9ui4/ZpJcBDg1T0nMzITKTJwOlAOdSd5BKawbfCg7pYQ
        +dPsNyRBXTcf7BjP7S/B6o0n7+9J3bTSnw==
X-Google-Smtp-Source: ABdhPJyyvv1XrOxvuVNb+j1mQt3Eg4zUVp81Q2iuZvC7fWXX5XqHxZXtI4wNg8tWYXcIYtwagtMGyQ==
X-Received: by 2002:a62:7794:: with SMTP id s142mr2108759pfc.99.1597418885149;
        Fri, 14 Aug 2020 08:28:05 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a4sm8600039pju.49.2020.08.14.08.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 08:28:04 -0700 (PDT)
Date:   Fri, 14 Aug 2020 08:27:56 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] iproute2: ip maddress: Check multiaddr length
Message-ID: <20200814082756.18888961@hermes.lan>
In-Reply-To: <20200814084626.22953-1-s.hauer@pengutronix.de>
References: <20200814084626.22953-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Aug 2020 10:46:26 +0200
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> ip maddress add|del takes a MAC address as argument, so insist on
> getting a length of ETH_ALEN bytes. This makes sure the passed argument
> is actually a MAC address and especially not an IPv4 address which
> was previously accepted and silently taken as a MAC address.
> 
> While at it, do not print *argv in the error path as this has been
> modified by ll_addr_a2n() and doesn't contain the full string anymore,
> which can lead to misleading error messages.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  ip/ipmaddr.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/ip/ipmaddr.c b/ip/ipmaddr.c
> index 3400e055..9979ed58 100644
> --- a/ip/ipmaddr.c
> +++ b/ip/ipmaddr.c
> @@ -291,7 +291,7 @@ static int multiaddr_modify(int cmd, int argc, char **argv)
>  {
>  	struct ifreq ifr = {};
>  	int family;
> -	int fd;
> +	int fd, len;
>  
>  	if (cmd == RTM_NEWADDR)
>  		cmd = SIOCADDMULTI;
> @@ -313,9 +313,12 @@ static int multiaddr_modify(int cmd, int argc, char **argv)
>  				usage();
>  			if (ifr.ifr_hwaddr.sa_data[0])
>  				duparg("address", *argv);
> -			if (ll_addr_a2n(ifr.ifr_hwaddr.sa_data,
> -					14, *argv) < 0) {
> -				fprintf(stderr, "Error: \"%s\" is not a legal ll address.\n", *argv);
> +			len = ll_addr_a2n(ifr.ifr_hwaddr.sa_data, 14, *argv);

While you are at it, get rid of the hard code 14 here and use sizeof(ifr.ifr_hwaddr.sa_data)?
