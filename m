Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0C83A4953
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhFKTOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:14:55 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:36683 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbhFKTOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:14:55 -0400
Received: by mail-ed1-f41.google.com with SMTP id w21so38235156edv.3;
        Fri, 11 Jun 2021 12:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xbysLR2vUz9qO4asGfEaHtsWqTNJbiOOCY9MlaCXyEE=;
        b=hcH7N73KbKsPZBBQuaXo3M0iigENRTu+KC2ZnNrWi7MJJv775iJBbIgjGJ553LFJvu
         KNi5VK98tKMCnbdnEF9a7NRPqkI6LpoBC4ECIPIOVhJoGQ0gSqUUxEYu7UPHXA4q4sm1
         tdq4lnyIr2xFkWUemwPDEPSWkcnVGO4hESDSNMbHPkuUFiF5GbluaVweSyOVOcwQ9Yqr
         ARrjAUHKsCxHi+rdNQIRoLdJ0WvVwEelZPsdgFat7N2FlHzwEB7FQd4WfiTHwFJwY5H0
         eB2c8krYqARc8KbY+6ZTr41c2KTVz0KQUB7T4R0Ik6Lqcew8Aj4z6CJQb61dAX8Tm1Nm
         o/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xbysLR2vUz9qO4asGfEaHtsWqTNJbiOOCY9MlaCXyEE=;
        b=uc4zbplDSzKeQ1/VFkCVGgQZr9y+mfX6sslwmmcjas+Ppur/pt7+5yBFet7NsZd3gA
         ZyIM/30pyPxT7IurX6/M6K+Jq105QTLmKTujPbjbTojF5owyR4H29PWlJVsy6MZgvxIE
         1P7LhRaUKqWU/88OHmsBuwKCFIAY3FWWbCQwvWf1bZUlQ4OxEvb/lwV9v8PAHcE7lN6X
         6Nf7EmsiVvjaN1BSNs3SBM6XRrH3wFB/Y/QlPasqsL6BSzSrT9Ue2WzHKtnYDLapLqm6
         PtVkXaRA4MC/gta2SFNHIn72f2oGfbRp6ix9Knp38i2eb6ZRX+d1PtFZTjs6iaSbVYBb
         RLFQ==
X-Gm-Message-State: AOAM530myKaLQEE5u1Dm113lyrO+pLOK+O8jquNhqmsRFUEnKyuz8U7l
        ayVMJx6F16GgCn9xtxy/dIU=
X-Google-Smtp-Source: ABdhPJy3TJTl76z/cOndPza7eJno1DZsBm750RQt7qBrZnkeRsTiMKEmwh7WObJA6cxk2yJSgTKBWQ==
X-Received: by 2002:aa7:c0cb:: with SMTP id j11mr5233327edp.177.1623438715444;
        Fri, 11 Jun 2021 12:11:55 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm2385049ejb.16.2021.06.11.12.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:11:54 -0700 (PDT)
Date:   Fri, 11 Jun 2021 22:11:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v4 2/9] net: dsa: microchip: ksz8795: add
 phylink support
Message-ID: <20210611191153.aoiuueuntuflxbrt@skbuf>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611071527.9333-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 09:15:20AM +0200, Oleksij Rempel wrote:
> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> This patch adds the phylink support to the ksz8795 driver to provide
> configuration exceptions on quirky KSZ8863 and KSZ8873 ports.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

but it would be a good idea for Russell to take a look too.
