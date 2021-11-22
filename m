Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EE54587C6
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhKVBgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhKVBgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:36:44 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C866EC061574;
        Sun, 21 Nov 2021 17:33:38 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x6so57928063edr.5;
        Sun, 21 Nov 2021 17:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gXpHZJwJDWKbvv70bGAkshFgWIdTC5hHCzGXFH42fUU=;
        b=UrRLPlxhwZdYlYz4fh/jjJjokyOwUqh9gI+qlkkBpfz15drwNj4kg4ehs/5X0zWPiM
         lFblbtJg3M75v5C1GRsJWfWz390+hzBgg2Q/fyrimuG45/qPiG+loVyz+o6B/AVKfKMi
         0vMTiVhqUVs7xnxQ8xi5scoBXlXjXhxU3/XhmknEx/fJ042l4gdyHgOfdRMk9dsnpq1a
         V79kZ0/8Rg5IwntnbjbKYDTY4A0B39bmsTYfouVmz2yzRJ0VQKW3eGmO18/QoNukKO6U
         R3EtgOw53FBD+ErTTe6ASs+ac8p/QwLdlP6fFWHCZet3xvcMBDGNDYSJBGW+BzMFkj7Y
         7+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gXpHZJwJDWKbvv70bGAkshFgWIdTC5hHCzGXFH42fUU=;
        b=lbHY4bxSWjcp51IrVHv8MuYIqP+l5ZQh3KpBmNBUUi6j9q86P9FWtugvR9R9XhcSpx
         VZ2g5YLjYfnM4ClWertntQxdg+YgOWFCJ18eCXDQ30qjBL7PJ7QBamh2I4NRh/fBqva2
         pJBeeBGMAoPeMDnnTMIZWib9W5xmDVsqBpRQ5+/uYilrDMbV41a1Vs2RAQ5ZSwUSJQrJ
         ZqerYEbCU8lAeOKhEiRDUfiyGVXo9ND0KRpQ5fUx9O/EdQxDpj9sjVh8DawjGux1HMUZ
         Le7WDBV2hFIMaGyDpFSZvShuTTwWKS6hON3e5pkmJpqWWhtLqMhre6lwCSbpOMfx+vM9
         /b+A==
X-Gm-Message-State: AOAM5329s+UJA4Xr1WgxLCYNIRU8GZhKl0Ht2Y0B6p+ELmlHQtUo5HsV
        rqDt6MR0pb7XVHqMwzbXHY8=
X-Google-Smtp-Source: ABdhPJw0HPLnRqi0KfmYKkz1p2vwX4gr2EbyeESENd1jMIr3PYLZ/jZrseq3XtQIDKC8fTdAH40opg==
X-Received: by 2002:a17:906:3c46:: with SMTP id i6mr33843238ejg.371.1637544817452;
        Sun, 21 Nov 2021 17:33:37 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id qb28sm2986434ejc.93.2021.11.21.17.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:33:37 -0800 (PST)
Date:   Mon, 22 Nov 2021 03:33:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 4/9] net: dsa: qca8k: move regmap init in
 probe and set it mandatory
Message-ID: <20211122013336.c7dzjbx6qmoajvbu@skbuf>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
 <20211122010313.24944-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122010313.24944-5-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 02:03:08AM +0100, Ansuel Smith wrote:
> In preparation for regmap conversion, move regmap init in the probe
> function and make it mandatory as any read/write/rmw operation will be
> converted to regmap API.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
