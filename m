Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477B731738B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhBJWlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhBJWl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:41:26 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056ECC061574;
        Wed, 10 Feb 2021 14:40:46 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 190so3246817wmz.0;
        Wed, 10 Feb 2021 14:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zTAnaXv80Jrj13McVbpo/waLZEYPfQh2VpZ0xxunb5k=;
        b=aI9WOtE2S8F3czMI4IXa98s+pntBCpqM4bQTJel01qrg4Ygg6TprymA1F/zOMv96ji
         39SKI5C0U4GDVVUIMsDiNM5jcKVUNJ/Kpa8GR3mgs4C5gVElfi3GcYec/B0OowYOG63z
         2uCmMguM5L3m7bUZraJGCK1xd3UqaD8bVoi8AKKhP6HnFq4IhF77uJVVL6crwQKaoRPG
         ncZBPx8n8fbj7y/U/Rx/EJICPfGT0oRv2BoF7aXvJTdlFnRiCn1/eeymirKvqPnHssnZ
         pnTMMzxNL0N0MwAWVGLZ2oE1GRvNBLH3Uw+no8BHifxrYvS8vc6MJmhtAG2BhieeNcHn
         pOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zTAnaXv80Jrj13McVbpo/waLZEYPfQh2VpZ0xxunb5k=;
        b=h7Z+UFHQDjJjx8Be6l1V48rW/JJE5zBuWS0AvCxlZ5vXBoSeF9lOdmV/6jYaCPquhc
         RbLBXHcveg2qFWOZwnqnT6smWyisnzA1d5K2FKKz4Jn7aUWCjNNO5j1pEjqXs5ldYcYb
         M6rk5/RhbYQQUsKB5mHdy3BpXX9t/LsL/u4aKBuSoyhjookLn6mz6oHdVdb/QV+clmNd
         AGoGoDdEjgqemcGW3rvpgo+0Dt9pJppSC7nE+Muv5M24NCP6rIhglJb0NehR4mMKiT1S
         3xaTupd+gQdVm+lhjdc9mk/3jpRn5+ficH81m/OjpM9ZMWxQ1y8IMPOsHJRgSrccT2W+
         HUNQ==
X-Gm-Message-State: AOAM533Z8T4yZunD+heH3+3GhFmry0DIjQfaO2W/XAGKyPMW2S1MOkNB
        JpUGqvDYP2h2sBZ7g51oeUc=
X-Google-Smtp-Source: ABdhPJzbC6jDXekBNTo90N0KnOWgApxPP+O+Nq/4p+cT4sjMBjOXhtgS9ET1f0zKIvraB9G+0rvC2g==
X-Received: by 2002:a1c:6208:: with SMTP id w8mr1322176wmb.99.1612996844728;
        Wed, 10 Feb 2021 14:40:44 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:b0ff:e539:9460:c978? (p200300ea8f1fad00b0ffe5399460c978.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:b0ff:e539:9460:c978])
        by smtp.googlemail.com with ESMTPSA id l1sm4490285wmi.48.2021.02.10.14.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 14:40:44 -0800 (PST)
Subject: Re: phy_attach_direct()'s use of device_bind_driver()
To:     Saravana Kannan <saravanak@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Android Kernel Team <kernel-team@android.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <bb9ea9ed-cbf1-0712-2322-1373a7b01fca@gmail.com>
Date:   Wed, 10 Feb 2021 23:40:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.02.2021 23:13, Saravana Kannan wrote:
> Hi,
> 
> This email was triggered by this other email[1].
> 
> Why is phy_attach_direct() directly calling device_bind_driver()
> instead of using bus_probe_device()? I'm asking because this is
> causing device links status to not get updated correctly and causes
> this[2] warning.
> 

The genphy driver is a fallback if no dedicated PHY driver matches the
PHY device. It doesn't match any device, therefore it needs to be
explicitly bound.

> We can fix the device links issue with something like this[3], but
> want to understand the reason for the current implementation of
> phy_attach_direct() before we go ahead and put in that fix.
> 
> Thanks,
> Saravana
> 
> [1] - https://lore.kernel.org/lkml/e11bc6a2-ec9d-ea3b-71f7-13c9f764bbfc@nvidia.com/#t
> [2] - https://lore.kernel.org/lkml/56f7d032-ba5a-a8c7-23de-2969d98c527e@nvidia.com/
> [3] - https://lore.kernel.org/lkml/6a43e209-1d2d-b10a-4564-0289d54135d3@nvidia.com/
> 

