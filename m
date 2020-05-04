Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11A01C4324
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgEDRpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729386AbgEDRpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:45:17 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD0FC061A0E;
        Mon,  4 May 2020 10:45:17 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a5so217478pjh.2;
        Mon, 04 May 2020 10:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2s0HKSDbYZQCfls10fELFqwmKEgOAIpeqz5usoPo4C0=;
        b=g/4fA1U6TvbO9g8SGDv9GgL60R0B0BYHGWxzBykqBMPixJZPEUkJykL3gXRFz3BycJ
         h4lD13nQHVFN/A8FUFm/u9+nDjpPx+i6DcqFg45WnPAWLxMUHD0jlbAK7eMY4Pfgx0h5
         3C2GPafI3xCIwcz1Yfe0V/ESc5G0FlF5nTpN87ZXOOCl4jUcxSeISzIv35p801+0Cq1S
         dSp3UnTupyjEM0/7wGjFz4xyl4iMqWAVs6Z3W/Jw9rBQkcMZCm4g5uYQdxRa2MX/2vTj
         RVKmafd1J+hYu7lokWZUzhuNFrFGfCwIHOCofBe6Sm3dYrF+TP6cQiRc7Dq5RoASg7Dg
         4Xyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2s0HKSDbYZQCfls10fELFqwmKEgOAIpeqz5usoPo4C0=;
        b=KpknbY+/nofefQPx+V/eQozlPQ9vcrTZrQ6jrA4LMCXPIsO1v0PECfq51DiKK8uHVB
         s2URUAxvYofi8hD/R5BUW4PN6XQgYSxPzf7P6pvhNDpb07nAWrsJ2y3e4dnbOOL/zqiv
         44Z1hxsqZ6SjlLt22k6QTEPNKyaKk0YoGXOAeplRKOTL/CqsfiZZ/LcCwSeWtDJf5ogz
         LTRB2IUA5HZzdQrh3l6jfClHfDXBWWkFfWovHNRtjilPoHjoxO3kRLlR5NYZLfb3rhps
         zmgndNby3Ae8Hxi7gHRiZDEoTauNlx+MuIojVb6mo/1RpVYOVHqdfARl2+DupVk47y5a
         ocWg==
X-Gm-Message-State: AGi0PuZAHT8h6LsHdi8EFIQTKFqv5DngsG8HeEBYLPjPIJoSjvCERAYh
        fWghl61im8QC4nl8DECmlpz83MPi
X-Google-Smtp-Source: APiQypJ1TXlo5ebIEETrzNeVDBC0y7QkNKSvcViP8Ys+iHpEzMNrMnbMET9A3Oz0ftwc30gsrCH+XA==
X-Received: by 2002:a17:90a:f985:: with SMTP id cq5mr69889pjb.193.1588614316940;
        Mon, 04 May 2020 10:45:16 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h8sm9262758pfo.143.2020.05.04.10.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:45:16 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: add concept of shared storage for
 PHYs
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
References: <20200504163859.10763-1-michael@walle.cc>
 <20200504163859.10763-2-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3649566c-1424-133f-fed0-b920874fb36b@gmail.com>
Date:   Mon, 4 May 2020 10:45:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504163859.10763-2-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 9:38 AM, Michael Walle wrote:
> There are packages which contain multiple PHY devices, eg. a quad PHY
> transceiver. Provide functions to allocate and free shared storage.
> 
> Usually, a quad PHY contains global registers, which don't belong to any
> PHY. Provide convenience functions to access these registers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

This looks pretty good, just a few comments below.

[snip]

> +
> +/**
> + * devm_phy_package_join - resource managed phy_package_join()
> + * @dev: device that is registering this GPIO device

You mean device registering this PHY package here?

[snip]

Might be worth a comment that this is a used as a bit number.

> +
> +#define PHY_SHARED_F_INIT_DONE 0
> +
>  /*
>   * The Bus class for PHYs.  Devices which provide access to
>   * PHYs should register using this structure
> @@ -278,6 +301,12 @@ struct mii_bus {
>  	int reset_delay_us;
>  	/* RESET GPIO descriptor pointer */
>  	struct gpio_desc *reset_gpiod;
> +
> +	/* protect access to the shared element */
> +	struct mutex shared_lock;
> +
> +	/* shared state across different PHYs */
> +	struct phy_package_shared *shared[PHY_MAX_ADDR];
>  };
>  #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
>  
> @@ -478,6 +507,10 @@ struct phy_device {
>  	/* For use by PHYs to maintain extra state */
>  	void *priv;
>  
> +	/* shared data pointer */
> +	/* For use by PHYs inside the same package and needs a shared state. */

s/and needs/that need/
-- 
Florian
