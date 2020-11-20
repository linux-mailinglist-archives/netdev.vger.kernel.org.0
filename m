Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D1D2BAB65
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgKTNh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbgKTNh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:37:26 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8D8C0613CF;
        Fri, 20 Nov 2020 05:37:26 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id b3so4852003pls.11;
        Fri, 20 Nov 2020 05:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n6R3cMz6omhOAvz8CiMkGHAuvWiXe6mVts5SfsAyuIk=;
        b=tIIHixZbZ27sxFyPBuVo4aNkvYBvUhgLWWwvlPy4yDe2SB4H28o0lUxjwKKgGV10+d
         Nb8yHbGbY4/kaiPwM+exFRD2XCYGjxux2BMkvQA3vVuq+XbNRp2YUhzj2X/yNlvHjpAv
         FBB1preOvldSs9giReMFPdZJG2qi507pC3usOuMhEKhDxP4QWnE4ifVHwvviCpRGWQ0z
         e/nXBsbreIhgyRXFbsyCXWPmlyi/18EWvoaBmCEVpehNZ6BDzkBr9NtSfbF+fv0ZHe1z
         hq+oLQhv6UtK0KRqfhDkyXvBDtBh+zsWSBy5b32Z838ud4hHBibuvvwVicsR7p85Sbx8
         gP0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n6R3cMz6omhOAvz8CiMkGHAuvWiXe6mVts5SfsAyuIk=;
        b=qxZpnP1q98kAztHa6MBp+AqbJsCTflIrTvt8RFu5KCxmgwlbTjwuM+/0VnAeTNEVOk
         DcBmUH7bhwGsKeLbZ4IQkNI7oGiPHYcbko0Z4A1QY2pXEXu60O4MSKAo8MlugaVJKHHp
         gv7CGhumQNu1aes0FEzgmV6C6eRcp301Fi/J7RpKwB+/9JS9rgbNQkHxFGXnC5KNISIB
         Myfim8iiJKpRoaWN0AMb7mDwt0GDJj1/bt71AYT59GU0Xvm76zjhdJFLYj3EIXKCxEe1
         kasM8zC4IvgCAc0lx7SyUVsxSNfWmwlOIuIkAGrEkh5fQFQ5geJRUTqIUpW1mkriOu59
         bdnQ==
X-Gm-Message-State: AOAM533FDbLzMANolC9iVW7gcJ3urFyYCVpYX6NlXm9XBBUt+b8P5kDQ
        rygTFjD8+w/jWY1AHpWEXhs=
X-Google-Smtp-Source: ABdhPJyHAn2w9eY4sS2nsQfEZLVDLForkZ/CI/Uajqh398xrcLjRrJeUFmYX0tdil5eG4zJLHIx5pA==
X-Received: by 2002:a17:902:7486:b029:d9:d4aa:e033 with SMTP id h6-20020a1709027486b02900d9d4aae033mr9321488pll.16.1605879445922;
        Fri, 20 Nov 2020 05:37:25 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id ha21sm3808332pjb.2.2020.11.20.05.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 05:37:25 -0800 (PST)
Date:   Fri, 20 Nov 2020 05:37:22 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] net: ptp: introduce common defines for
 PTP message types
Message-ID: <20201120133722.GB7027@hoboy.vegasvil.org>
References: <20201120084106.10046-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120084106.10046-1-ceggers@arri.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 09:41:03AM +0100, Christian Eggers wrote:
> This series introduces commen defines for PTP event messages. Driver
> internal defines are removed and some uses of magic numbers are replaced
> by the new defines.

Nice cleanup!

Reviewed-by: Richard Cochran <richardcochran@gmail.com>

Thanks,
Richard
