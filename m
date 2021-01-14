Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE80B2F67A0
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbhANR16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbhANR14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:27:56 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31922C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 09:27:16 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id c132so4238173pga.3
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 09:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=weOqfWoM2QG0ynyeggC+bRxGohZrHDlK7Jo7hNqdNiU=;
        b=MyhxdkUiD3aDBbLK12YUPyjsK3C0fgaOJhvWBLhYUlbe1wg6dzZbltynERS/N18Mys
         nh6pX8hsZVStbG2i/Rm3XQzkvE+RnvUXYSM1IaDOnmCqN+hwnuFcUU+zuKmOUSIl6XJz
         jX0eePgdJUQmue+T/obpxQhNgEyPQ5LY1OxsJC4/3Kg0rguC8iaNTvr+LPKkgfu5UHr9
         TwyoKRhoz1UhCwaahPZwZoD2w6G6yQzPaq0JtGlYGJjimZRb4IM6s//pCpRfKG8LtsS3
         q+K0blEBKWyH37StwdW5rt+fREFve/yRI0vArNqM1LBxqTBXyAWzW47uJ3SVubFTTjml
         f7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=weOqfWoM2QG0ynyeggC+bRxGohZrHDlK7Jo7hNqdNiU=;
        b=O1ZLYKwIgWu87zXbIwGY0g/5Hf8Mz96GHpUJHxR8F/cXXiC05YDMjYHWZwJcmNCA3I
         HP5RTIKQSsSl6kaEU6ZNlQqze0ADOVKPab+fuZBYQf7STltrj88gQh8ZmPQE9mxKokTu
         l4+l0vdd21LrGAyeSij5+peHtPpLqAC8m5P0g5II5MrB3M7Sg4CBeh5/qPzYRAGJ/06/
         zjk2scDqQb70MwgNTq0bRTLyIVVWiipedwlCEvu4SGNkVSPcM8uZh8cbmiLtFl9vAumC
         gudz3wZ3CZ5gQkzIX/2YKiIJ2FB3TD+2YuBxizmPhG2xuN6cYT3KLaPgawsWymydnKz4
         hP6w==
X-Gm-Message-State: AOAM532Oynl1KXNt+hyYm4kw3DaLu+Pfan5SuKhy7LcI3Frj5ribdWsR
        vxpnbImhKpqFQMhprLtMFK0=
X-Google-Smtp-Source: ABdhPJzp9PuNQ3KUmepE7tdbdoFRXr8SFqpCIbD7174sZYNW96L4K1EUmfwT3lFOuNff20x/QqKv9g==
X-Received: by 2002:a63:6806:: with SMTP id d6mr8417561pgc.205.1610645235772;
        Thu, 14 Jan 2021 09:27:15 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id g17sm6353600pgg.78.2021.01.14.09.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 09:27:14 -0800 (PST)
Date:   Thu, 14 Jan 2021 09:27:12 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210114172712.GA13644@hoboy.vegasvil.org>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
 <20210114125506.GC3154@hoboy.vegasvil.org>
 <20210114132217.GR1551@shell.armlinux.org.uk>
 <20210114133235.GP1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114133235.GP1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 01:32:35PM +0000, Russell King - ARM Linux admin wrote:
> > We had already discussed this patch last year, and you agreed with it
> > then. What has changed?
> 
> See the discussion in this sub-thread:
> 
> https://lore.kernel.org/netdev/20200729105807.GZ1551@shell.armlinux.org.uk/

Thanks for the reminder.  We ended up with having to review the MAC
drivers that support phydev.

   https://lore.kernel.org/netdev/20200730194427.GE1551@shell.armlinux.org.uk/

There is at least the FEC that supports phydev.  I have a board that
combines the FEC with the dp83640 PHYTER, and your patch would break
this setup.  (In the case of this HW combination, the PHYTER is
superior in every way.)

Another combination that I have seen twice is the TI am335x with its
cpsw MAC and the PHYTER.  Unfortunately I don't have one of these
boards, but people made them because the cpsw MAC supports time
stamping in a way that is inadequate.

I *think* the cpsw/phyter combination would work with your patch, but
only if the users disable CONFIG_TI_CPTS at compile time.

Thanks,
Richard


