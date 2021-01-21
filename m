Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87422FF20C
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388731AbhAURfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732761AbhAUREy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 12:04:54 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE37C061786
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 09:03:53 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id g15so2065835pjd.2
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 09:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t8k86sXV0pxKDM53KaDcq3LfCYMHX8caQmr6mffk0qY=;
        b=Xq2R+C+wRJni81g/HqOpshRXV48XWXl/ddUVDftOUJNieFMzUKfPdaKnB6KxmLJvyc
         jnQcyvX+vi3kBwnp23H4KyIt1vQe8WO8n9VssL1UC7cwiK1oeKq7zEQhJcbXE6O3/GsO
         sc8akDsklW2eAMNoB2rUpQgoCup0eomCkUhqMkNneOvpJaHFNpZARiVd6crx2bALuD6W
         d6IkYj1XqfrJws0UUqJvzqHzLaAZRQxdtgxvSoKZjWR19zLC50PY+3Dd3bPXnG9veOhA
         2rRIhiXvyBc2xFUSBT8H7bWqaPNVDFc5k02kGGC0T8N3TskYRCTj+wvXfw8rRi3f85oG
         uzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t8k86sXV0pxKDM53KaDcq3LfCYMHX8caQmr6mffk0qY=;
        b=VG/tOrvUgAL7+J60nwbPSpC5hPl7sZTYQBVY8HIL3jASDG2iTkKFoJ5XYSm6KDNHlZ
         IrvGansCEt7dOGcT/7BzWmoluFPY3U8l0cKL6QEmLh+3y3hCDZ7GDOrqerlH1zIenZRI
         AJna2hP9x1sNYSlcCdRItogj252K44nqz/3wOFzAVb/fuOa4nErcQcAX69UtKAfdTLW9
         sAjWYykWvDw6H/f5FHAc8ftwOn5xz7LS+1vng4FGSLScdz+l1BKwSMvfGCkAABTllCXY
         UKgKgJqnpcOkp0p8BPxOETYEhxv237TKZtISE4o+OeWOp9FLA+Z/NO2Fv9vsV53qK+Pw
         SN3A==
X-Gm-Message-State: AOAM533/dD4KQhjQ08EYwfg7FPXjbnw0+vPAf2+gimRMmU5ZVu+h3to9
        RHQiG/YMDcY/OMVlBEaOGh2kE0uoa00=
X-Google-Smtp-Source: ABdhPJwtbMuqi0WcMZakwmf7Wm6UivkikMIfN5D7/CqQCzXWvSt74kkgs/mDpTfK1w5pa41Bk1/8rA==
X-Received: by 2002:a17:902:ea0b:b029:df:cf31:284f with SMTP id s11-20020a170902ea0bb02900dfcf31284fmr230129plg.60.1611248631307;
        Thu, 21 Jan 2021 09:03:51 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id o10sm6277612pfp.87.2021.01.21.09.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 09:03:50 -0800 (PST)
Date:   Thu, 21 Jan 2021 09:03:47 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210121170347.GA22517@hoboy.vegasvil.org>
References: <20210114125506.GC3154@hoboy.vegasvil.org>
 <20210114132217.GR1551@shell.armlinux.org.uk>
 <20210114133235.GP1605@shell.armlinux.org.uk>
 <20210114172712.GA13644@hoboy.vegasvil.org>
 <20210114173111.GX1551@shell.armlinux.org.uk>
 <20210114223800.GR1605@shell.armlinux.org.uk>
 <20210121040451.GB14465@hoboy.vegasvil.org>
 <20210121102738.GN1551@shell.armlinux.org.uk>
 <20210121150611.GA20321@hoboy.vegasvil.org>
 <YAmqTUdMXOmd/rYI@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAmqTUdMXOmd/rYI@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 05:22:37PM +0100, Andrew Lunn wrote:

> There is a growing interesting in PTP, the number of drivers keeps
> going up. The likelihood of MAC/PHY combination having two
> timestamping sources is growing all the time. So the stack needs to
> change to support the selection of the timestamp source.

Fine, but How should the support look like?

- New/extended time stamping API that delivers multiple time stamps?

- sysctl to select MAC/PHY preference at run time globally?

- per-interface ethtool control?

- per-socket control?  (probably not feasible, but heh)

Back of the napkin design ideas appreciated!

Thanks,
Richard
