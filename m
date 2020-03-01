Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD77174D43
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 13:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCAMWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 07:22:15 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41402 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgCAMWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 07:22:15 -0500
Received: by mail-pl1-f196.google.com with SMTP id t14so3067617plr.8;
        Sun, 01 Mar 2020 04:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Nl6uqiUH7qk6Y6MADMhhMgJO0FCDRVW4SJPmE5qRI4E=;
        b=ZqQ7Elr8poJVF7IVcgELGLcCETsfugqQdMvBQXb9PNKtiDOc+PCWno2GNyPp5z819v
         fi11MCioI7kYhxXsuGqEiRctov8qIHp5LHxQdVx0S8Q9K3rR5I57+ukymnPCa6wTUVx3
         8U/SWFgJQceYLLKncqhIYJM8D+HyVS28Q+ABVo+yn35zqNeaflPb5SQTGg9Yl+8eLjB7
         QVlTwLaU0NXlQ2DzZ5KSS/VCQuDvNw7oa97xKL2CbRSlDfBqmZCZvZVCT+fZF/LS1/fZ
         HuWJ/uqrK2i7ZKeJtmfiKgqeU2sVnj+pQ276PEpYURX5Bo9lhb0J9KMhUgvjM48coBzI
         1icQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Nl6uqiUH7qk6Y6MADMhhMgJO0FCDRVW4SJPmE5qRI4E=;
        b=CsrNReh78cZXvpb7cCpErKaOUr+LzMFwMgNtqgEmtgv/pfqU0+JocpLWfiQvrrH3Pq
         G3n8ANXnmhtrwKgMQXmRyltMWxymbrlTPJOYNllmqWZxxGL7Erriisx3oMA1db0pHBnI
         gABGsI4kPOMvDUYnoNeAzb07vggB4C3clucYg/mQffE6WI5UZ3ZCaaQeQCJk6E/TYuO4
         +6Ne5FMFtK5JXYA/FBNCzjnHJUbhsp6sOzVhncTi/CHTkQ70j6p33fnpUAlZo8skoxXO
         f7qqRaH6vRtOluW8YGEdlTKjInfzmJURoiGYRb+C42tJBAJsqlEvQbRFDmX4ic2d/RoZ
         pyMw==
X-Gm-Message-State: APjAAAXKnJ2ZN7nYFGrsaHAlL61wrLKTNpplYmyQxiupokXKITT/v1vU
        zRz0C3FDNRlaZQjHy81vg9M=
X-Google-Smtp-Source: APXvYqzKnidncZJnTITfWPjqSK7bearuseLOfLxHjtrYw3tP28IlmIGi9T2rckRfHbwcf3T1d3ACFQ==
X-Received: by 2002:a17:90a:77c3:: with SMTP id e3mr15535343pjs.143.1583065333982;
        Sun, 01 Mar 2020 04:22:13 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q8sm16955436pfs.161.2020.03.01.04.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 04:22:13 -0800 (PST)
Date:   Sun, 1 Mar 2020 04:22:11 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 2/2] net: phy: at803x: add PTP support for AR8031
Message-ID: <20200301122211.GA32253@localhost>
References: <20200228180226.22986-1-michael@walle.cc>
 <20200228180226.22986-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228180226.22986-3-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 07:02:26PM +0100, Michael Walle wrote:

> +static int at8031_rtc_adjust(struct phy_device *phydev, s64 delta)
> +{
> +	struct timespec64 ts = ns_to_timespec64(delta);
> +	int ret;

Here the 'ts' is written in multiple steps,

> +	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
> +			    AT8031_MMD3_RTC_OFFSET_SEC_2,
> +			    (ts.tv_sec >> 32) & 0xffff);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
> +			    AT8031_MMD3_RTC_OFFSET_SEC_1,
> +			    (ts.tv_sec >> 16) & 0xffff);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
> +			    AT8031_MMD3_RTC_OFFSET_SEC_0,
> +			    ts.tv_sec & 0xffff);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
> +			    AT8031_MMD3_RTC_OFFSET_NSEC_1,
> +			    (ts.tv_nsec >> 16) & 0xffff);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
> +			    AT8031_MMD3_RTC_OFFSET_NSEC_0,
> +			    ts.tv_nsec & 0xffff);
> +	if (ret)
> +		return ret;
> +
> +	return phy_write_mmd(phydev, MDIO_MMD_PCS, AT8031_MMD3_RTC_ADJUST,
> +			     AT8031_RTC_ADJUST);
> +}

...

> +static int at8031_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> +{
> +	struct at803x_priv *priv =
> +		container_of(ptp, struct at803x_priv, ptp_info);
> +	struct phy_device *phydev = priv->phydev;
> +
> +	return at8031_rtc_adjust(phydev, delta);
> +}

... and here there is no locking.  You would need a mutex here and
elsewhere to prevent multiple readers/writers from accessing the
device registers asynchronously.

(I know this is a just a RFC and that there are bigger problems with
the HW, but just saying.)

Thanks,
Richard


