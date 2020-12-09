Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2A62D4547
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgLIPWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbgLIPWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:22:15 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FADC0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 07:21:34 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id m25so3584505lfc.11
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 07:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=2mUmQHgZhWgf9X1bHQKHAc+RCmNh78vHhh6yP8uzVKY=;
        b=0otTGtI8kAU6XI/GCwdrdlQHwW0PVa8TuUIoi9u5pHo84LSt6zOw/im8yRNPJuxji1
         Yki+SOjSo2Y8LjluoH1jUMoynm9cWi4Fids0DNQSWsOOr9kRTVJmJ+G5rlYiqi+EBytd
         S+/1ZXJ+niQRivX9xpt1UGHDacjyy5GCm9SKRp8TUvGcePprYGTwBboUZbl7wjNwTk59
         W7juXVLke30vc6W7A1Uhg2ALJfg2EMN5nl3jvfHqVHXRc93itJaKJqQI45BSg2fwXhyE
         ENS1Gnijvadu98pHYy67swSVQlbNuulREacnIu9tkLZo5lsrAhP5cVmp4al13MBde0Xt
         8+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2mUmQHgZhWgf9X1bHQKHAc+RCmNh78vHhh6yP8uzVKY=;
        b=bECcTwM2Pkn9ZuAU2CUvHPMxG07UdyBLOKiSREYpmyRFpFtTCEAuh8vHV9CVdM9pTT
         4IsyWhLEK4hKceDNOnP589xl1433BpuZYk12Hh9O1VORLYh7pFJX5i+8ZA9vkEUzQSRK
         AB+bZnFCKtz89hglTvi/dZcr4vxwoyEfvkQDQj2f+YV0XQLSsyYPSJlq7QsW4klBrow8
         cgW2ddncG5MTbKsryNUhj5DCzxvyzZOn81hlyNt2pNnmnOVhh/GIBVQzcmweqTjzV6Im
         ZVOzqdnLiTk3LbeNNorEineUxt8Qfu8Fek1y89gN70ndikd43gZqgAP4yeRjpZMYh8XL
         X/9Q==
X-Gm-Message-State: AOAM531kNv9YHLOk/dKjDxDlfuDvPm03QLbF7PsV8YNWUZBPMs+Lk8QK
        KcpbElV0kloDa/oCwREVYh9etNaEwKElqqj4
X-Google-Smtp-Source: ABdhPJx650LOMUcsimdEggX7P7lGthY0CIjm9X9wqlayyuKiq3Inmz7lit76d01Ixt3VnJGQWZI3QQ==
X-Received: by 2002:a19:e34a:: with SMTP id c10mr1176150lfk.336.1607527293072;
        Wed, 09 Dec 2020 07:21:33 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y3sm8470lfy.73.2020.12.09.07.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 07:21:32 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201209142726.GF2611606@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201204022025.GC2414548@lunn.ch> <87v9dd5n64.fsf@waldekranz.com> <20201207232622.GA2475764@lunn.ch> <87h7ov5pcu.fsf@waldekranz.com> <20201209142726.GF2611606@lunn.ch>
Date:   Wed, 09 Dec 2020 16:21:31 +0100
Message-ID: <87blf357k4.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 15:27, Andrew Lunn <andrew@lunn.ch> wrote:
>> I disagree. A LAG is one type of netdev that a DSA port can offload. The
>> other one is the DSA port's own netdev, i.e. what we have had since time
>> immemorial.
>> 
>> dsa_port_offloads_netdev(dp, dev)?
>
> That is better.

...but there is an even better one?

> But a comment explaining what the function does might
> be useful.

This is the function body:

	/* Switchdev offloading can be configured on: */

	if (dev == dp->slave)
		/* DSA ports directly connected to a bridge. */
		return true;

	if (dp->lag && dev == dp->lag->dev)
		/* DSA ports connected to a bridge via a LAG */
		return true;

	return false;

What more is there to explain? Is it the style?  Do you prefer initial
block comments over explaining the individual statements? Is the lanuage
not up to standard?

I am sorry for the tone, I am aware of it. It is just that I really want
to contributem but I am starting to feel like a tty-over-email-proxy to
my emacs session - and an extremely unreliable one at that.
