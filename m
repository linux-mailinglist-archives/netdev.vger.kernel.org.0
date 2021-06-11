Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BBA3A496C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhFKT0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhFKT0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:26:32 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A60EC061574;
        Fri, 11 Jun 2021 12:24:20 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id k7so6077709ejv.12;
        Fri, 11 Jun 2021 12:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QVn2XpNydMMfSU7bRQCNWOFOmVIdLgML4UEm0EkT7pQ=;
        b=TXuWpJuPWpt3qqHX5SFrlDo4EPqrxK8R5S4Jw5oPL5VNKvPgjsBnWabOjL9ew29gW0
         jsCdhhjq42JIFokffm2W5W/mLfk1L0B8jq1EWjz5/EuZ9pTpGPpbCHo4Di0gWaaYz9k8
         R7PbGeQKW36hxl6us6bshYAzeLw3GdCAXYVRHgE4IYUyd4N7a6fkcR8k86G1Y5xRCTRX
         4EvKl+Dw9aeFDUf9c7F7I4xANM0d9Va7nA/yL7YuAVvyPDDwdoEpFJzFSuXxvPsWTjbA
         JmBeAn2I+3orMj0x3xSkNzk1GtvnIPA9NE6eo+3MREA2rL0lr2JMyeuit+tlZs/4ZiSN
         luiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QVn2XpNydMMfSU7bRQCNWOFOmVIdLgML4UEm0EkT7pQ=;
        b=bO39r+KBQ225TUjxhFNg/DImOyFCOt6A6A9dqL2RzRFyHUjRWWE3yNq6K/R/9ILC1M
         wnXIrUUTinEDlKx8p+W5j0DATM+Bj9QzDtEOmILuNrkeTLPl3FgTCTb3ej+qpXIhMtKY
         T/Ej+3ygHfIPA/Wcjbtl4CeVsVfhohbueyXne2LHCwUBmkUf84xGASIYj+KuZH3gLoWp
         r0l1cbA5+TvhhXac9myA4dH80vUFMbXtnEt5vnF3oleHi5KqrH9163R+LSwD71eJUMtj
         ty+mg0yRaz7161s9nfn0aIPkzFQUSOhISEMTzsYN1dp2aWUqIuYg4UiTeIAuatVGKTjE
         SbOg==
X-Gm-Message-State: AOAM531iNoG/Wh8VwAuy5gqj/9QONLYBAGAGQIfBEWkuuYVXLjL2MHhG
        ZNhSfZJoa54YSq7mtgYxw43elH8Rtmk=
X-Google-Smtp-Source: ABdhPJz46iCdebyRYDndYc2A5VY55T92JgyLWmkTWxaliADt8/+l924Qc5JLRa3CFWLcc+MZ/FIgzw==
X-Received: by 2002:a17:906:1806:: with SMTP id v6mr4994778eje.454.1623439458835;
        Fri, 11 Jun 2021 12:24:18 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id f12sm2887977edf.72.2021.06.11.12.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:24:18 -0700 (PDT)
Date:   Fri, 11 Jun 2021 22:24:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v4 8/9] net: dsa: dsa_slave_phy_connect():
 extend phy's flags with port specific phy flags
Message-ID: <20210611192417.gvfxi2kbfjx4jv3d@skbuf>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-9-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611071527.9333-9-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 09:15:26AM +0200, Oleksij Rempel wrote:
> This patch extends the flags of the phy that's being connected with the
> port specific flags of the switch port.
> 
> This is needed to handle a port specific erratum of the KSZ8873 switch,
> which is added in a later patch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

What happens differently between having this patch and not having it?
