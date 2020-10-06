Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FEF284CCB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgJFOBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgJFOBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:01:07 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4C2C061755;
        Tue,  6 Oct 2020 07:01:07 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id 33so13647639edq.13;
        Tue, 06 Oct 2020 07:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pWzTzItFMGquZ9N6WRVzwFoGPMpIgrJK7QQeAOkDiPE=;
        b=Yxt7ComHPrYsEFGeYm918+o3bwnCYsjcgk/G6HNF9NtX3L1Be3zoVtXMtuZ9E46qkw
         h+knokkUfc+05uRrFfdNXJGgGxN2sHUsFMdwY6HPR/H1Mkj6Yc5fhbrTBOTPSAKb0GNd
         y8BY1FAzP3jyKZb4eKZIIF2tjJkfx/hm7njK3e5fP5mtKmUb+JerlYtc7tVVWqOZvuhR
         zlAQHAAXZjUNtUYfv9GBJK+987Rtcx89WFPdsHcSKps6jNfkd8m/plTt+A+rzr4DDFE0
         p1cBYuOrBhtFwSUEiLur+LEMYHIvqsNMJGSjaCpJlAWwfbHUrwAykOEdVz9B7+Qzv8ZP
         GF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pWzTzItFMGquZ9N6WRVzwFoGPMpIgrJK7QQeAOkDiPE=;
        b=sQPTeQbbx4eL2mljgBBfQfhhxJ1UVcDZbvVQu+5NV6naLuVCiNtKSElk6tR60wcsDG
         FqqTWar/x0pQHXQzPzuU8UBI6/FoMdlesjhGiQqHWAMvwHOKPTkUjqcmnj0ml8+11npX
         iSUv8f934UUxgut+bsr9c0rjwm5vIltIlLVdL9LOkHAuagxY7laUEbLr2hIvHNZbIa5q
         ySYIDQ37p0v1nhFx8eGMwuH56sMzv3f49FrWDFfVGaqsKy9h2qDRrkG9FV9EkwhbhW6n
         8Hy+ddWpyGjYo/k0ZEVag1NOtcIbTPgjPmC07weYSjhUpcbVOuexB0wjG5hTGVngXHqC
         038A==
X-Gm-Message-State: AOAM532havSQDE4+elomkvMhr0a+0lQbIc60ENiZrKAQLFlXYg7IeysW
        VQGhDGgPt4zrTX7FBjjIypE=
X-Google-Smtp-Source: ABdhPJwnCMo0DagOwfhno9ZjV6kDRoNM/laQzOuhcaRPEJTDc8rVkskaQzz/lCaZjd82Ne1NppuB3Q==
X-Received: by 2002:a05:6402:709:: with SMTP id w9mr5552917edx.326.1601992865873;
        Tue, 06 Oct 2020 07:01:05 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id q1sm2284655ejy.37.2020.10.06.07.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 07:01:04 -0700 (PDT)
Date:   Tue, 6 Oct 2020 17:01:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
Message-ID: <20201006140102.6q7ep2w62jnilb22@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-5-kurt@linutronix.de>
 <20201004143000.blb3uxq3kwr6zp3z@skbuf>
 <87imbn98dd.fsf@kurt>
 <20201006072847.pjygwwtgq72ghsiq@skbuf>
 <87tuv77a83.fsf@kurt>
 <20201006133222.74w3r2jwwhq5uop5@skbuf>
 <87r1qb790w.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1qb790w.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 03:56:31PM +0200, Kurt Kanzenbach wrote:
> On Tue Oct 06 2020, Vladimir Oltean wrote:
> > On Tue, Oct 06, 2020 at 03:30:36PM +0200, Kurt Kanzenbach wrote:
> >> That's the point. The user (or anybody else) cannot disable hardware
> >> stamping, because it is always performed. So, why should it be allowed
> >> to disable it even when it cannot be disabled?
> >
> > Because your driver's user can attach a PTP PHY to your switch port, and
> > the network stack doesn't support multiple TX timestamps attached to the
> > same skb. They'll want the TX timestamp from the PHY and not from your
> > switch.
> 
> Yeah, sure. That use case makes sense. What's the problem exactly?

The SO_TIMESTAMPING / SO_TIMESTAMPNS cmsg socket API simply doesn't have
any sort of identification for a hardware TX timestamp (where it came
from). So when you'll poll for TX timestamps, you'll receive a TX
timestamp from the PHY and another one from the switch, and those will
be in a race with one another, so you won't know which one is which.
