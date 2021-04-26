Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBD336B8D6
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 20:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbhDZSYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 14:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbhDZSYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 14:24:39 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9469C061574;
        Mon, 26 Apr 2021 11:23:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id h11so8530235pfn.0;
        Mon, 26 Apr 2021 11:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8H8v2UpducE9QuEEY0YHQeEf4IX7YdyBQzYA5ag3dXk=;
        b=Vkr6EvazvRVqy8e/Q9qwKinZkRHqZYYgvJan5wKIfO41t4Zhh42jJI/6Nyda8mPqwi
         yjilBwXoie+WEwpUuoTM68mBEG+4b4DIvnNCG1Foe0A8c//r2T3r4neDz7OT72G3VHJS
         S5z+WYGunng0bXu5UFWH1bR8IjNxlB+VTAAe6sEv72sW9WvEnG4z4H40hRNju0xPc1L1
         vb+CVkHQKGyQwbY3pUBkzEdwL8FMtMtIAJLdL90+yGDIfS7T0njTGX2JTYpSflybPobb
         ccVdvY0OYcKbrKhpAj4KfKHusN2THTxS7i6lDL6jHrlpkEGNwgMZ0GNno01C0PRsoYjP
         Fw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8H8v2UpducE9QuEEY0YHQeEf4IX7YdyBQzYA5ag3dXk=;
        b=QPGZvzQe92edWnPx68vBTuRGSUWhd5vLGLpt1eQlTHem8balmAfgBvVszNQANvKH9a
         jgE2xqFHs1fFujLC8TbCSaTIpljk19BlrzLOd2+tOCegALyi0o9Nk/roOZc3FhnMIGES
         JwYi0jJRnBW0PstSCV2IpT+kIgrhFOpmg2AUaFYWktkfiH1/SC/MFtrVVNwk3imIPx8O
         1QTI3wKs6aPogm64rAk9iZ7hgV9OchcuxbMjtHmwRPz8YfU1meioqRaSIEPaRprxzZuv
         5Ah5O/wf4FGr+rlK/aHqGzqGRYzcwmMNdSHS8z3cvgVZk2f0PxcZyOwcTjegeJgbfS1c
         Xf0w==
X-Gm-Message-State: AOAM530an46bZryebk4RNAbfFQuQ/A3xaUTa+qkhnAqjAXV/wXLRN2iM
        IrB0D1Cl+xR6IUfe1nvF4oQ=
X-Google-Smtp-Source: ABdhPJzz/Uq/3Jq9dlGYcpvbe0AAXRcICcFpuXSAg+C+brFrPTPU9fRjzdClM/o9BZlDf8Fwcca9MA==
X-Received: by 2002:a63:4513:: with SMTP id s19mr17709571pga.34.1619461437034;
        Mon, 26 Apr 2021 11:23:57 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t19sm415186pjs.1.2021.04.26.11.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 11:23:56 -0700 (PDT)
Subject: Re: [PATCH net-next v7 7/9] net: phy: Add support for microchip SMI0
 MDIO bus
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
References: <20210426131911.25976-1-o.rempel@pengutronix.de>
 <20210426131911.25976-8-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <94f76086-3819-4bbb-4bc7-d917cbef01bc@gmail.com>
Date:   Mon, 26 Apr 2021 11:23:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426131911.25976-8-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/21 6:19 AM, Oleksij Rempel wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> SMI0 is a mangled version of MDIO. The main low level difference is
> the MDIO C22 OP code is always 0, not 0x2 or 0x1 for Read/Write. The
> read/write information is instead encoded in the PHY address.
> 
> Extend the bit-bang code to allow the op code to be overridden, but
> default to normal C22 values. Add an extra compatible to the mdio-gpio
> driver, and when this compatible is present, set the op codes to 0.
> 
> A higher level driver, sitting on top of the basic MDIO bus driver can
> then implement the rest of the microchip SMI0 odderties.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
