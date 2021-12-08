Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D861646CDBB
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239968AbhLHGb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239648AbhLHGb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:31:27 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740ADC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 22:27:56 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id x7so1251651pjn.0
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 22:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MID/BVWe+b3U+Q2AqdAL/UqeCyS3Ibj+MJeEZHSjyD8=;
        b=UQv/iBnI8E4HBpUr2UfR9ZDZuDudVb4K0fyhw4zvCYFUpVVl8hTBwS2c5qaAJO+dsD
         75rgG049ELPhMQv3dpayXojfolhtJFb3OZQjvrIL/AwHTPY/bJx/wjOiYsN6AFWzeOhM
         WeTYpLBngOaMgMO2vPpHz8HZczmlXx+HecuPJ5kvcCsCG0ZeNKXmtwKLxWNq9EknHqHi
         izl049yzbFE1ITJcD72fzRAvk7LkiIilfIHumzuu9VuT3cc4MV9EZs6e5YVfzVw2Ojtf
         5jnzPr0w3k54jW9edN39gRPTs9Z+Y1mMfBHI8Jfh6W0u368pzycH/+/mwzVlRF1DvTBs
         u7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MID/BVWe+b3U+Q2AqdAL/UqeCyS3Ibj+MJeEZHSjyD8=;
        b=lKz6P0zaWq7Gsm7MsaBD1uzTvv7J7V6K2Xq3+IDsoE0DzytdeZ+wlS/k6W3uZbGg7d
         MRPBNCvUpYgpufwn+DP/r0FDgz5aT3kAmJYb0w7SMAjQ1evOTBYE5OLaHMYevegLsXV5
         gdZDo3Zr1DAyzm4mvu50Kz2PyxmZ/ByAL5aywZpZhthRlW0Q2oXi2TJy+oUnEmGamLiu
         GwntbKKKMyhodtPfNELWinZfFYsDNuMXsJ43zpqQzp0vsMAik/Ay3cOCPMaZZGJFYgjc
         VOnxOQ5+2UBFoz2se+AyW/zfIn1Y7GU44JyHuF7rYGZjgymsGuyEfZXdBiAoxVTm7Pd5
         C7Zg==
X-Gm-Message-State: AOAM533905EgQRY0C2KfzkPq+1b0GhIQXrZSBSW1n21lGow4DXRT/6HJ
        tqXmX2+BKjeKac85BRCeLWIUvVkQVtI=
X-Google-Smtp-Source: ABdhPJwRDDGfYhpWeA0fQ5Oa/i6eFGE1WSs2xmCeSsBF4JT3HTJvhO6POeO4SAE2ULms96HODYIPEA==
X-Received: by 2002:a17:90a:fb43:: with SMTP id iq3mr4902500pjb.144.1638944875958;
        Tue, 07 Dec 2021 22:27:55 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a2sm1387556pgn.20.2021.12.07.22.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 22:27:55 -0800 (PST)
Date:   Wed, 8 Dec 2021 14:27:49 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAGS_UNSTABLE_PHC
Message-ID: <YbBQZUoQjDC6Ea23@Laptop-X1>
References: <20211208044224.1950323-1-liuhangbin@gmail.com>
 <20211208044224.1950323-2-liuhangbin@gmail.com>
 <20211207220814.0ca3403f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207220814.0ca3403f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 10:08:14PM -0800, Jakub Kicinski wrote:
> On Wed,  8 Dec 2021 12:42:23 +0800 Hangbin Liu wrote:
> > -	/* Reserved for future extensions */
> > -	if (config->flags)
> > -		return -EINVAL;
> 
> Should we do something like:
> 
> 	if (config->flags & ~PHC_DRIVER_IGNORED_FLAGS)
> 		return -EINVAL;
> 
> Or whatnot? We still want the drivers to reject bits other than the new
> flag.

How about just add the check in net_hwtstamp_validate().
I think that should be enough. e.g.

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index a81c98cfc3db..256d2e26487f 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -186,15 +186,27 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	struct hwtstamp_config cfg;
 	enum hwtstamp_tx_types tx_type;
 	enum hwtstamp_rx_filters rx_filter;
-	int tx_type_valid = 0;
+	enum hwtstamp_flags flags;
 	int rx_filter_valid = 0;
+	int tx_type_valid = 0;
+	int flags_valid = 0;
 
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
+	flags = cfg.flags;
 	tx_type = cfg.tx_type;
 	rx_filter = cfg.rx_filter;
 
+	switch (flags) {
+	case HWTSTAMP_FLAGS_UNSTABLE_PHC:
+		flags_valid = 1;
+		break;
+	case __HWTSTAMP_FLAGS_CNT:
+		/* not a real value */
+		break;
+	}
+
 	switch (tx_type) {
 	case HWTSTAMP_TX_OFF:
 	case HWTSTAMP_TX_ON:
@@ -231,7 +243,7 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 		break;
 	}
 
-	if (!tx_type_valid || !rx_filter_valid)
+	if (!flags_valid || !tx_type_valid || !rx_filter_valid)
 		return -ERANGE;
 
 	return 0;
