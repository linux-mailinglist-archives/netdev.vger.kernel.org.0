Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A092CC105
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgLBPiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgLBPh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 10:37:59 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAA2C0613CF;
        Wed,  2 Dec 2020 07:37:18 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f23so5049229ejk.2;
        Wed, 02 Dec 2020 07:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WXVdNum5aCsi+xpDAEKp6eQg6/NaKHf/om7tKOnDBFM=;
        b=iURZkBK/Ga5ZV1Rku6aiTwucrB0Rp0yGK9YG9PlbL7cMv/cOEaV2vBt7dZi9IaJjEz
         1CyDSzr4TZ83x1Rxv5WVoqelKOtvtZCoe2tIj/NsJSf1W3Ru16JS12n0Bh1iFRYtgfmE
         JHTHVgUWPNxNjvBnRBEG6PUI5Cx8CfpyuLv/aCEVjCtN4Arj0Krm7TvZRpfQJnu/e6T0
         n3bf03Wi8KdpHfek4UzsoMg+wbkVUM0ZqLcI0CqtZjl8kVlNrSRjPGKM1KC/0uV3Suam
         SBEPb+xtUcv2sw6o7SWOgqhd78YDQKPGiGHr4LeoyOU6XUiMxbuZho/3DvioVwTfXYA5
         R7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WXVdNum5aCsi+xpDAEKp6eQg6/NaKHf/om7tKOnDBFM=;
        b=qe6zQM1aS7P5supF+/ZO6DmKamqaZJwMiWzzGjIvyrvjodx7LAFje176COSR6lYVRq
         dipxfCgN9fT75l24NypjlgTc53tfYP/1JGos5Oal6Fj0YITgN12+Tmxzq4ceyLQv8j/p
         WNBgOPvoKj2Ot9GOWQblUi2Tcifs81tboIghDNWDHpf3C8Y2v/3fSeaTqWjFnaPYeKHJ
         SwY1JONt0hXkRoIHKHGoFjSV93GPUmz63k0XX874g1DyjkL7UjnVctj8liAbdKTCXJVs
         9vglGu2z5pkE2XxlY3p23ruNVGgATwRlgew2pg4qXQXB1E8jMmH3QEy6JUixuNihrVP+
         Xshw==
X-Gm-Message-State: AOAM532bbgnlLKP5gMsS2NSDtd0f4evG9waFgC3ffUBhS3KAANjvR1lo
        pYzWECAJ3dl8DVYKhBQ+GsY=
X-Google-Smtp-Source: ABdhPJx+nmE7a2UsJp94TWOrJ2VJvCj/6AK9Qu45dEc1Vhm9jsM3zOFtLgDPtNx+kS2cK91adUAL3g==
X-Received: by 2002:a17:906:7c45:: with SMTP id g5mr326380ejp.502.1606923437262;
        Wed, 02 Dec 2020 07:37:17 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id n14sm201181edw.38.2020.12.02.07.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 07:37:16 -0800 (PST)
Date:   Wed, 2 Dec 2020 17:37:15 +0200
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
Subject: Re: [PATCH v2 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201202153715.f54tsktvvjr3bwxv@skbuf>
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
 <20201202120712.6212-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202120712.6212-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 01:07:12PM +0100, Oleksij Rempel wrote:
> Add stats support for the ar9331 switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

With Andrew's feedback applied:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
