Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC15284FC6
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgJFQYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgJFQYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 12:24:40 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1F6C061755;
        Tue,  6 Oct 2020 09:24:40 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id l17so14175746edq.12;
        Tue, 06 Oct 2020 09:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PNhxeCuyNFBdBGInaH8ev8Srj6p1W2m97GeyV41AyQI=;
        b=sle4UsdqcBRbvIj6a4BJZzp2B9PJVjlFFNxpHUCvK30/0zWRVH5yohBu9lQxEv23xA
         L2aFHJzQBXphiyKnaE60arHMc7JBHVaqVYvr2i3OYi1GFAE5Vd2VKqeTqWWtYmXfRrgX
         HboxO9hP7+Unao8UAoVSAkKT1eBjtxR66unwxWPX2rh7BHBFPYrNII99XH4seKAlEqmd
         bVNUkiWKrmeeOuLrQHLoKPEP3l7qkCCTvNNMLlMK+iFLc7PK3EviCRDaifnZ9ONkXPTF
         gncwE2hqv0IpSJbDLuqedAWOCnT20Xhaf5duJaII9cev+ozFBmOmAO7IlHPNb8yYffU3
         tJOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PNhxeCuyNFBdBGInaH8ev8Srj6p1W2m97GeyV41AyQI=;
        b=ufNUSnuuvA4eadOOrnsk34bIqSsa1X2FR6GQuboZKpYAjLyoE9rBSl4Y8nj+/gCy/K
         BhWArg1eEJvE81qVo5eKqSjZ2Cya+sXbJPvslnGQME0kfYBbk8RZsICyZTZWUUP9lWxW
         QoWJ/4uuxd7ZoJxFnUY9rTKM2SiY8RrhhwP9Gax+LMxykLNzQf85yThVRt6ElWr9VmJM
         xooVCsHOEIazC0YlorJRtWKZTKu3EAHUqPnT+mbYVOi8CyDGCBtEvx6buAGvUh3t07BH
         qKLRYMTmz0KsK2llLU7AmQ0zE+qjkQ4wmXpZn9kNQWdHTEC+Xy/4PUu5seJroM34EG+/
         5rGQ==
X-Gm-Message-State: AOAM531rD9iKOlZzTsjwoc/Lumjk2e9VK5qKZfGktLAJfFc9hq6yHdcR
        JrDQ39PLQpHiOrWnWGfMUbkT6HWozls=
X-Google-Smtp-Source: ABdhPJyFcYCaMMn0It9YzEmn+OCvvN5eA+pkzBCkSiXCrnmNQXSMHgh9sq+WMX1SIHTbBMs9hEb8yg==
X-Received: by 2002:aa7:d891:: with SMTP id u17mr6287457edq.188.1602001478377;
        Tue, 06 Oct 2020 09:24:38 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id l26sm2403503ejc.96.2020.10.06.09.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 09:24:37 -0700 (PDT)
Date:   Tue, 6 Oct 2020 19:24:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net v2] net: dsa: microchip: fix race condition
Message-ID: <20201006162436.ri5ifcqr5xsec3m3@skbuf>
References: <20201006155651.21473-1-ceggers@arri.de>
 <20201006162125.ulftqdiufdxjesn7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006162125.ulftqdiufdxjesn7@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 07:21:25PM +0300, Vladimir Oltean wrote:
> You forgot to copy Florian's review tag from v1.

Ah, Florian did not leave a review tag in v1. Just a comment:

> don't you need to pair the test for dev->mib_read_internal being non
> zero with setting it to zero in ksz_switch_unregister()?

I may be wrong, but I don't think that setting the interval to zero in
unregister() would change anything.
