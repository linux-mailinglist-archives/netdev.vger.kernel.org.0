Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5B32DC42A
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgLPQ2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgLPQ2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:28:22 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2639C0611CB
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:27:14 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id d17so33608021ejy.9
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zVkAYI5+gmYsjm5QszUkRPwrU9l/MVvXiR8eMuB7qxo=;
        b=ckdJf3qDcCcAocnMOeRtNm41ifmFUcxQwt4neYTkLx/n76LcQDB+VEuKglKhcycYgn
         9z5FfpKPYhi9XcEawsMZCLEQ/4Po0hQCoi4Wmr4lIiMOu6RdO3bX7UaSe2vuT6xY4PSc
         SBb0zzjJtb1T+gCQURXXCiZ0msjNtjv7NCzwH2XiqMOO7101jX56Ax9MPD1RyjSIDz+s
         68edk7aX7+5FUh23bpil/a2/DF7aacuhhFMKAd85Bj3Q1xt6Ei/cm3eWybRMWz4hjpXC
         gIurOIRjHNGLEb+BaT/NgNWC8LcV1lop4uQWDQzNIyDJzxFYmo9maygdtu+GRYQBBQeT
         oLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zVkAYI5+gmYsjm5QszUkRPwrU9l/MVvXiR8eMuB7qxo=;
        b=hyA6BtVcg87q12fK4pDw0gZ92iRvmi2zMAeOm0sYw2g7SpO+S62sCZzjOmeg1Amd5r
         vRzvhYfGhTsA/nSbfghHn1UkSnZBJSHKv9Ja3g3YQW9wQtdUw17fTViUZuC7rcDhR37Z
         e2iDvJjEmI7+BnuAR2MLCj32TzAS/j7DZs0l6Ne0skL8WpDw7ArjKWdPBxeFNzBL3Mef
         mq0tN7nveHkHYjZY0y6a8U7GmAkIKF6w+pfqFCXiWqMqRrwz4+JZiYcJ9aAeSHRlfyst
         harWJc8WeQfwS6cyD5VKiYwIWLyT0RMt/JjR4SO6ghfEvvaP5BGcyQikpo+RbUgHUCrV
         JEew==
X-Gm-Message-State: AOAM530Jgd1CHatIz/SxpOzhneVDsetimFqh1cLNEiJPb1bF2uzSl3h3
        xZaCYY3RfNEMT2IvX8d2Dpw=
X-Google-Smtp-Source: ABdhPJzIVkJ3pL/4AZoBGRhbdRLreeKIqfi6j4YQlfJS/xcOO8Xl1KlOa3nKeAZmOmlsc0HxL3vMxw==
X-Received: by 2002:a17:906:e206:: with SMTP id gf6mr31933486ejb.342.1608136033566;
        Wed, 16 Dec 2020 08:27:13 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id j22sm1716035ejy.106.2020.12.16.08.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:27:12 -0800 (PST)
Date:   Wed, 16 Dec 2020 18:27:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 2/5] net: dsa: Don't offload port attributes
 on standalone ports
Message-ID: <20201216162711.3nhq3lktadyzksoh@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com>
 <20201216160056.27526-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216160056.27526-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 05:00:53PM +0100, Tobias Waldekranz wrote:
> In a situation where a standalone port is indirectly attached to a
> bridge (e.g. via a LAG) which is not offloaded, do not offload any
> port attributes either. The port should behave as a standard NIC.
> 
> Previously, on mv88e6xxx, this meant that in the following setup:
> 
>      br0
>      /
>   team0
>    / \
> swp0 swp1
> 
> If vlan filtering was enabled on br0, swp0's and swp1's QMode was set
> to "secure". This caused all untagged packets to be dropped, as their
> default VID (0) was not loaded into the VTU.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/dsa/slave.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 4a0498bf6c65..faae8dcc0849 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -274,6 +274,9 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  	int ret;
>  
> +	if (attr->orig_dev != dev)
> +		return -EOPNOTSUPP;
> +

Should this not be:

	if (!dsa_port_offloads_netdev(dp, attr->orig_dev))
		return -EOPNOTSUPP;

?

>  	switch (attr->id) {
>  	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
>  		ret = dsa_port_set_state(dp, attr->u.stp_state, trans);
> -- 
> 2.17.1
> 
