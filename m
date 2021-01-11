Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4116A2F1B8F
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389152AbhAKQyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387574AbhAKQyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 11:54:05 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966EFC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 08:53:24 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id h16so432995edt.7
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 08:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vf6gteHMrB+m3Yaows6edx6TCQ/Dhz5FVQIxd4SFyeQ=;
        b=i7MwGzSHz5ArRgDUlpx/EitfPGaKHoXcdUogcgmVt2ae9FJXxU9Hv72EwQmo8bEIbl
         e4hjgkvazI0bmlMWHWLi1j12bX7Sjy8MJ5h2Kak/RAtJBWqEYQO06hzdKWQtm3B9L5ev
         Ng248hZb5zZLesF9iZ6LVV0eiC/U246jUEAm02V0z8m5ng2p1Pu6dOoRAvuwJhrZEHX8
         oDEUTFqn/bxyWX+Rxb562VqLHkrwJcFRumvYpfvUAGLJ0aB7UIqZP43t14+MPjBZ204W
         LSxIRYC5tXazdoWhSzqJb48BGw3hm7wSoMnqx0r5n6aqPGoOMjSnmIyK9dhYVvEzClnC
         vqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vf6gteHMrB+m3Yaows6edx6TCQ/Dhz5FVQIxd4SFyeQ=;
        b=OrqqBWDcGiL8UY7dzw9wymRz6ZbSINplRsraTvYupTVvUpE01eh05S4xKTtMCIT49b
         /RWqqg/PbpbzQUoOw3N1TBsj66kSx8F5FdYkdTZYkzrIh8JTTxky8BkzS4mNWy4yOcR4
         BFjvgxNYUOSom598etuxzL5uxzwDY+OGX7Quy3OX1/TT0A3jHAXCjEtgiSOR6Kc91pva
         ge1281GzaFwuQ0oIXoYSc+MBGyre/wQNYHOdS4tAfJ/tiDLY0IDHgD/O6bl2Vft0Oj6S
         7QlzoLvQHtJhtM+O6dHNC4jaE42D6ZcO9HiLSjxRsSkUWZtaSJq2SCjo/jpXSqJhA5Sh
         0pWQ==
X-Gm-Message-State: AOAM530zM9t2Au2xApu1xHgmOZbxgeVuHPq7j8GW4dfsba3dJ3PEeOzy
        gNp7i8LvZKB+62NV0lJCUmU=
X-Google-Smtp-Source: ABdhPJxTaU4dOl1VbICiBd/jAMWfa4cd5/v73ae8jnpyXJ9ciahRQ0RkgSNSpE5m6T1BV+JuZL2KRQ==
X-Received: by 2002:aa7:cb12:: with SMTP id s18mr202158edt.125.1610384003361;
        Mon, 11 Jan 2021 08:53:23 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id ak17sm64508ejc.103.2021.01.11.08.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 08:53:22 -0800 (PST)
Date:   Mon, 11 Jan 2021 18:53:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 02/10] net: mscc: ocelot: add ops for
 decoding watermark threshold and occupancy
Message-ID: <20210111165321.p5v5y4btwohl4hc6@skbuf>
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-3-olteanv@gmail.com>
 <20210109172046.635e4456@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109172046.635e4456@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 09, 2021 at 05:20:46PM -0800, Jakub Kicinski wrote:
> On Fri,  8 Jan 2021 19:59:42 +0200 Vladimir Oltean wrote:
> > +	*inuse = (val & GENMASK(23, 12)) >> 12;
> 
> FWIW FIELD_GET()

Do you mind if I don't use it? I don't feel that:
	*inuse = FIELD_GET(GENMASK(23, 12), val);
looks any better.
