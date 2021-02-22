Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E926D32228F
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 00:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhBVXLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 18:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhBVXLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 18:11:42 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4047C061786;
        Mon, 22 Feb 2021 15:11:01 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id n1so24005912edv.2;
        Mon, 22 Feb 2021 15:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GdNyYSieHSaiPrVeA7xGe4FuuX5KcxMXSC/IiyRe8pc=;
        b=OPVJKCZ+LxQN2P9cqoK+/QTRQ6DVKDWQLtDQWx16kmL+GOapjecDVhSgOAqwrbvYym
         /pU5jxTD1eBtpzhJEfqNDZqI6uCHK95+Pf+Vhnofr9Vnz8S8NkXMwsNnwds8oAxaP4Oc
         gXbwT/L7h02clM6/aTR8cbrw5pe8qq32oHooPFwUHi1T/zg1GEPAremUa6MCH+DTv7wi
         EI9O7WQ+J8e35o4ui8bR1zCTt0cEHFG1b+zKQbtciQSQZ6gg6+8eQNUUKqrZdvQ3kvVG
         weA68nx4SLeSEW3UdOVaBG04TeLsbz3FAN5UqYgfAO0BT74q79BpYqav/yH3f/OLZBBV
         +fHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GdNyYSieHSaiPrVeA7xGe4FuuX5KcxMXSC/IiyRe8pc=;
        b=T934k413YX+Av1bj1fPkbmBtVYxh2G/aZw2Uft+mkTJHxnOAciZP0w9CKWn/dDoeUO
         eSvTRISvVrCDPlHnbDK1EvmWZ0dN0CzY/jShclpSPFXFzZZHxEIzbMQfrf0Z+5Iot5/7
         p6JfEOhKDU8t0MLIxIHB4hyXe6NMrN+JdA5Zl+BZzd6SdwVdm18GILEIJ+/aLOlKqeio
         y5UVHbK4CDLDQAiIlQ7O2q5gAunlFc6eMaZ/7YS24vBfGBAPfVvI6DGDjT3ibIjMmorD
         MRdS4IrfmEPMbwHcCiWoM2yS9eKU/bHo9kMLu7YD1bxfWbwQ3PZ4MSlyl7akSF+Xjj92
         TqAQ==
X-Gm-Message-State: AOAM533uSmtz1N6chKi2vBja+sNVun+paVbv/zZDJKs4gn3n7jG5VZfH
        qicJNB1khfEMkblEZPe9bR8=
X-Google-Smtp-Source: ABdhPJy+hs3FIl8YvsUiJg9vFmY6CcPIlaEJprGjOQ5j1F8gzQU54pbEA5v8Zaww+HRJXc1RJoNjKQ==
X-Received: by 2002:a05:6402:c9a:: with SMTP id cm26mr11055639edb.133.1614035460413;
        Mon, 22 Feb 2021 15:11:00 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id s12sm13007411edu.28.2021.02.22.15.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 15:10:59 -0800 (PST)
Date:   Tue, 23 Feb 2021 01:10:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 1/2] net: dsa: bcm_sf2: Wire-up br_flags_pre,
 br_flags and set_mrouter
Message-ID: <20210222231058.q5mrpvfibjvw7jki@skbuf>
References: <20210222223010.2907234-1-f.fainelli@gmail.com>
 <20210222223010.2907234-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222223010.2907234-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 02:30:09PM -0800, Florian Fainelli wrote:
> Because bcm_sf2 implements its own dsa_switch_ops we need to export the
> b53_br_flags_pre(), b53_br_flags() and b53_set_mrouter so we can wire-up
> them up like they used to be with the former b53_br_egress_floods().
> 
> Fixes: a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

To be clear, I did not miss migrating .port_egress_floods towards
.port_bridge_flags, I just migrated what existed, and sf2 didn't have
it. So from a blame perspective, this patch should have:

Fixes: 53568438e381 ("net: dsa: b53: Add support for port_egress_floods callback")

However, your fix cannot be backported past the patch you blamed, so in
practice it makes no difference.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
