Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E742CBD9D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgLBNAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727713AbgLBNAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 08:00:41 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2064DC0613CF;
        Wed,  2 Dec 2020 05:00:01 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id jx16so4070136ejb.10;
        Wed, 02 Dec 2020 05:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QZTchEjCOZdcPKcqinGlzZCfx24eOr/wps07PHz4GN0=;
        b=i6PXxQBvF8Np1s+1Iwtf73kM+xpl/Y8Udcr5fEbzm2HIpGifB9BIncJv2bR3fs4eVX
         ITzDl35MibEjCEwLEzejmNF+ddS9BJ/Ym0QpmE0N0DOGJ1xDEh7OkvArGnWqBs0hOSlW
         jzbd6fLOKAWZK0AYBHQdr23IFtl5Ysdg76bBCuYalMvElWzd8TiR6ube2UIoSrmNCpxl
         LQw5FhxWLLtIOKVSiciFKmyyKolRc71nsB62aq6FM6oDm/ORmnHQC2lx6h5mCjkYWIWA
         5zgZ/1PzosbxBwSKv7f4LQYNkVe2SmTUi3LMfj7xE+CYnpZIIcuc69IH3zV8kMGf4PZb
         JHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QZTchEjCOZdcPKcqinGlzZCfx24eOr/wps07PHz4GN0=;
        b=QTUWFjCT1i9pSADOe3RmEkrF+/AARjPPu3SPK2XD6cV5KMEyIdeETQEYmV4PWHBOaH
         9RByzFA0+A5611GueaprUegQiA7De4rcV9RiTlCNuysU2oGtRIo+86LiaDer5QUCvn2d
         v2piztdJBbByYLu+t3HBeeDyevQYheAlL1I126H2HGpwnvKgsBjJoc5I5ny1EjnRfCHw
         J2C/oDlWEL65Sm3p32zooOF0+purdZpuB3r9z4euR0gtx8lPb6Lxg6DyfMCeoJYhRScm
         wEee7OON5yINLUWO+srJHuxU41bLC1drmR9JvEiSjFl6pXTMuirlleA3gS9YvwqhaGM/
         o8wA==
X-Gm-Message-State: AOAM533rOKp4Ly1rinDrehCgW7P759CYgPMsh0IEqAm/kfBGkAEeiiA5
        PfQBOBKSK3Ms+A53Y5+0/NM=
X-Google-Smtp-Source: ABdhPJx9DNaccyM2Zfm+YU4qzmWnlatBgrng5Y+FiZiVgfO3QjB5SoFMxh6bM3x0v65hV/+Fm/k7/A==
X-Received: by 2002:a17:906:2932:: with SMTP id v18mr2159927ejd.144.1606913999841;
        Wed, 02 Dec 2020 04:59:59 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id w3sm1156303edt.84.2020.12.02.04.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 04:59:59 -0800 (PST)
Date:   Wed, 2 Dec 2020 14:59:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: dsa: add optional stats64 support
Message-ID: <20201202125958.ntgidhgsk4pdw5y3@skbuf>
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
 <20201202120712.6212-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202120712.6212-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 01:07:11PM +0100, Oleksij Rempel wrote:
> Allow DSA drivers to export stats64
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
