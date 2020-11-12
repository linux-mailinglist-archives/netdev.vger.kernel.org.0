Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8402C2B088A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgKLPiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgKLPiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:38:09 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECD7C0613D1;
        Thu, 12 Nov 2020 07:38:08 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id me8so8439613ejb.10;
        Thu, 12 Nov 2020 07:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MXQPhtQt49WN9AzFMXPyAMM7lL9ypZIAmnmHVvj/Rn4=;
        b=crkQyLivBOzwc1ulOjNO/HXjGyk/BHDHn7aEw2ssInKQUN4APA+SGnfiocox8sbUKs
         Ph6jHxrXWsCWMjHVJvujfCbLQP+OwiX+NWP8gwDit1hwLTDdz9VwoUr8nsY0eDJ5rJeW
         5wO90x4ctUdJHIRoq8kyOZldeWE2XSm+6a/ywOP/pqLM3/8B25yOXos5wOr22sn0j6k8
         9gzS1MN6jDmKtpvZyaBV20e3VJv4kJ1uOxy5r6Q+9+1OJuBfdw2gM0jDw9BVfEMLzDEI
         Ow2H7rgka2U3sHUEJ6KTHHw+pCqW4sERdqv12bufRI36qkCT2xWr4Weo95sMekWKuASk
         0h+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MXQPhtQt49WN9AzFMXPyAMM7lL9ypZIAmnmHVvj/Rn4=;
        b=U/nvQK4pD238kyuquF+KHHaz3LkcFl8dEAepXzKRkk9YcvlJ3b1NsyzaiklU23Pmg8
         4ml5MbSsa1wQUFeXQ4xjcEffiZpes96FVvINVWwQOZqC1p/8b5BL/N9lPTQPSX6dfwoK
         VSEj95QxeMDmj0yQoVrZgjqxIkFt+yRwvGQZj9GPoUUHSljUl4wvo8NBq57VuQ+Eqzf1
         4o5RwW2EBPUxABO+305au8muONFAqUeLNYIG7T99V60qmHf5rbpeiPjK8gNlQPfLoPWY
         VX5KVrj0IF3ywEX3INVrxwVgquhP14uodtJQHMFqTTDEYHrY+KN+EgoT4IPqQU8JUU76
         xHNg==
X-Gm-Message-State: AOAM530/6m8AUCV+YYEU5PbDjojT7Jy0myOO5NGnyE5QY2NbRI1Mfixh
        LJp6CC1rtB8NiteZHeBiHV0=
X-Google-Smtp-Source: ABdhPJzQoA7dUAly8+fiES0ft2NsEiD8lYL593aNstumsLPQA5FZpZ8oI3inMO+dRBaBlWAecCDHOA==
X-Received: by 2002:a17:906:9902:: with SMTP id zl2mr30284396ejb.510.1605195487579;
        Thu, 12 Nov 2020 07:38:07 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id p1sm2289366ejd.33.2020.11.12.07.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:38:06 -0800 (PST)
Date:   Thu, 12 Nov 2020 17:38:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201112153804.es56e6ym6h2i4oxx@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201110164045.jqdwvmz5lq4hg54l@skbuf>
 <20201110193245.uwsmrqzio5hco7fb@skbuf>
 <2477133.fPTnnZM2lx@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2477133.fPTnnZM2lx@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:28:44PM +0100, Christian Eggers wrote:
> the invalid values in the correction field were caused because much
> more seconds were subtracted on rx than added on tx.
[...]
> v2 is on the way...

Alright :)
