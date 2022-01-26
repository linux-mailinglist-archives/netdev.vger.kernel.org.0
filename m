Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AB649C0E1
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 02:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbiAZBtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 20:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236005AbiAZBtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 20:49:03 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D96C06174E;
        Tue, 25 Jan 2022 17:48:58 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id d10so35051753eje.10;
        Tue, 25 Jan 2022 17:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dPBEV0U/t+nROk+shzA6Wefz8zNhH3ImNVNgEo2wSCc=;
        b=O6leYA64jUSyOyMmEaK9Zv2Tz3/keIgW4/6KDhXXjrETQwiC4+C63ZL4PvQ7URNskc
         Q9BF3Se1fGd2MsjRIcKJOOd5Xg+LuDfbIPtyn9A4W7oHNB/7sCEMz7PkV5t2cJXINkA0
         a80TGsk8euoyW0a36A3zWOOeUJcU83175xI9JthEXF/vNECV/GNSt2M7C495h16OUz3o
         XlJ6Os16ojwM+uNPCV8gCjKZxU1uCcJBGvHqQY1a2QOmtf9+a9+R29TgpM7YWkGxzO9V
         OEwU0ViknxxcxJQ/910Uxura7Fxl3SOOD7PG0vIXKD6IGSJ6eQ/nuy8zun4ljlkx1MqF
         cz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dPBEV0U/t+nROk+shzA6Wefz8zNhH3ImNVNgEo2wSCc=;
        b=ZcjnPjFL6nGyyKNUZIqILoVIHwvDEYRebkRR0PnqroACeqjm0rIc6pE0B+2n4baEnF
         uxNkA7h4KsB/zXCHfBoaizMrw+Rkx62EjCYYAcKT/t0LaaL9mpXgTTqiR6pJd9fdmxS3
         aw4FAKN48QlaQZleNaFgfTcsLrnYUS/BycwKSN/c7qbeW0hFAzlb2UmKBl9Fak8uqk+b
         RbAsU5hvEG7C+jHwkpLQZtGm8i0C4KSVxN7pvF93jLQRCrPuuKxXKCOrYq+3GBMf1ukw
         WbDUyUgANlAcviHWdOO+voEv0Fm6/Sem+bJCgwDsr/1bVvNz7irCYULkyNoXL/6VdkU5
         P0Lw==
X-Gm-Message-State: AOAM532ESNvNG2llqyAzdLxCT02BOhstMdDeT92OO4rggMKoqIz8aijg
        NG6RxDhA/yUuYph5s+LpBGw=
X-Google-Smtp-Source: ABdhPJwplcVZ5sPhmZFE89f0ZJutlg+cWUr2NOewKJ1+Scex7lhbOJl+mXkuj3j0gIQEq9TfA4Xjag==
X-Received: by 2002:a17:907:e8b:: with SMTP id ho11mr10218258ejc.686.1643161736831;
        Tue, 25 Jan 2022 17:48:56 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id g27sm9056918edj.79.2022.01.25.17.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 17:48:56 -0800 (PST)
Date:   Wed, 26 Jan 2022 03:48:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 12/16] net: dsa: qca8k: add support for phy
 read/write with mgmt Ethernet
Message-ID: <20220126014854.opnyrd56nsrk7udp@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-13-ansuelsmth@gmail.com>
 <20220125150355.5ywi4fe3puxaphq3@skbuf>
 <61f08471.1c69fb81.a3d6.4d94@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61f08471.1c69fb81.a3d6.4d94@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 12:14:55AM +0100, Ansuel Smith wrote:
> > At some point, you'll have to do something about those sequence numbers.
> > Hardcoding 200 and 400 isn't going to get you very far, it's prone to
> > errors. How about dealing with it now? If treating them as actual
> > sequence numbers isn't useful because you can't have multiple packets in
> > flight due to reordering concerns, at least create a macro for each
> > sequence number used by the driver for packet identification.
> 
> Is documenting define and adding some inline function acceptable? That
> should make the separation more clear and also prepare for a future
> implementation. The way I see an use for the seq number is something
> like a global workqueue that would handle all this stuff and be the one
> that handle the seq number.
> I mean another way would be just use a counter that will overflow and
> remove all this garbage with hardcoded seq number.
> (think will follow this path and just implement a correct seq number...)

Cleanest would be, I think, to just treat the sequence number as a
rolling counter and use it to match the request to the response.
But I didn't object to your use of fixed numbers per packet type, just
to the lack of a #define behind those numbers.

> > > +	mutex_lock(&phy_hdr_data->mutex);
> > 
> > Shouldn't qca8k_master_change() also take phy_hdr_data->mutex?
> > 
> 
> Is actually the normal mgmg_hdr_data. 
> 
> phy_hdr_data = &priv->mgmt_hdr_data;
> 
> Should I remove this and use mgmt_hdr_data directly to remove any
> confusion? 

I am not thrilled by the naming of this data structure anyway
(why "hdr"?), but yes, I also got tricked by inconsistent naming.
Please choose a consistent name and stick with it.
