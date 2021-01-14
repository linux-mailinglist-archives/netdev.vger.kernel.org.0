Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491CA2F614B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 13:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbhANMzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 07:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbhANMzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 07:55:50 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7049DC061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 04:55:10 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id c12so3276251pfo.10
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 04:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9IX90Y5k78sPwXuBqN8BS+ueGMmHGt30Db1KTLFlVAA=;
        b=FAPN6WVXJgGXHrZKPGT+mshy7QsgbGsfsNGqkktkDPDY8h0VF4ULVjhdB2SXlVs4iJ
         WKHKtbhOxW9LyxOJoWpnDt3XzXqLaK8jstL5I1TqLYE2gGQITUrXid0N/KmpnIGfAyc6
         qAbeTdyM4T+Kw+6OuG9AfOYZhabiIocejoAO7A3ACWtRvpDZUSiZw2nhs/UPNkwzDCmE
         Tzg6xal3r/mfdJqRKzEKVxoHkCKn9hPqb6xvIUoztaROWmyBfwPazeLl/yLbv0iXS2yr
         yRLPUd7vu+/9CmKovbrJJDTbNV+dNP6PM4EU8s4wJx9Icm3QaEz9RLJXQiYsphg7g6O2
         U/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9IX90Y5k78sPwXuBqN8BS+ueGMmHGt30Db1KTLFlVAA=;
        b=TDJgBuqTipOfPoNN+EWQXsL3a3YZtThvyOGsmUwEzl7dXEIitnguPVPzrpFZyw1bWB
         J8ve/iNf+VKhHl8+odFogI9sybEhyqtOsWl09D3aZUTOSJC4Uzhj2K2NrA9697c6kSSa
         +WuCkLQHuixFOf49IQjzLC5lBEehu42YtKhjldlYHUfx25p9geDMOI2XcjGy5y3wO7Fy
         HVSJP61DC7cWGQtekhl0kc6POkvlZhjmF9156LHuVBL50OxUuj/M4VanxqOOB8Q853gE
         1NaYL97TXVewHn4bkuFsC0gbb7SJFiy5wYdAutLJ280ZwNOqT9FZFxT17iAisz0FMRc5
         foAQ==
X-Gm-Message-State: AOAM533PBi/P9Uy8gpSq2IG2ZF/NQpOHoUu068XRiuqYhrb5I9ylgxH6
        w1m19d33T9VXTaSGwWkqFu4=
X-Google-Smtp-Source: ABdhPJywCiRDitbh5LvJUrU1gfyU+rERxy1o+CFOdjKl/x1TVaqKT8B1RXh/0Ai86o60lC/y+J3veg==
X-Received: by 2002:a63:4404:: with SMTP id r4mr7388249pga.149.1610628910046;
        Thu, 14 Jan 2021 04:55:10 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id c5sm5632069pgt.73.2021.01.14.04.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 04:55:09 -0800 (PST)
Date:   Thu, 14 Jan 2021 04:55:06 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210114125506.GC3154@hoboy.vegasvil.org>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 11:13:44AM +0000, Russell King wrote:
> This allows network drivers such as mvpp2 to use their more accurate
> timestamping implementation than using a less accurate implementation
> in the PHY. Network drivers can opt to defer to phylib by returning
> -EOPNOTSUPP.

My expectation is that PHY time stamping is more accurate than MAC
time stamping.
 
> This change will be needed if the Marvell PHY drivers add support for
> PTP.

Huh?  The mvpp2 appears to be a MAC.  If this device has integrated
PHYs then I don't see the issue.  If your board has the nvpp2 device
with the dp83640 PHYTER, then don't you want to actually use the
PHYTER?

From my observation of the product offerings, I have yet to see a new
PHY (besides the dp83640 PHYTER) that implement time stamping.  The
PHYTER is 100 megabit only, and my understanding that it is too
difficult or even impossible to provide time stamps from within a
gigabit+ PHY.  So you needn't fear new time stamping PHYs to spoil
your setup!

> Note: this may cause a change for any drivers that use phylib and
> provide get_ts_info(). It is not obvious if any such cases exist.

Up until now, the code always favored PHY devices and devices external
to the MAC that snoop on the MII bus.  The assumption is that anyone
who builds a board with such specialty devices really wants to use
them.

Thanks,
Richard
