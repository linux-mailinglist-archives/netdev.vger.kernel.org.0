Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CE2214FD5
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 23:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgGEVOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 17:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbgGEVOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 17:14:36 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D97CC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 14:14:36 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d194so14087737pga.13
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 14:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=urJQg81tHzPyHCgpuThzFwOt36hRFPMTvZf4VMoNUCQ=;
        b=PK3WavhbIjCu5XCwj0KRbaN5YufP5V0mD3JOai7Pm9tYQzLedQrzdwtoLXp0BMq9wo
         L4r7WJXdptIoV8kVxbIdfx07szBcceHoEq7BDekNZ3v5nr6WyvzhLvpg/EJfvo4K1Nw7
         0VHXBr2FWz42ukMCm44PzYp3U1/4sA/uRovqGZrbFO4IDubAUEmjav5PXaYNF7cRN80X
         v5miXmU9+I9OR8RPCx+2aaoHNKECvCYdQhmLIe3PPNWx1dwCNoc2P/6yq0Z3b2diJkYD
         Aydl9jXet+hy18Jr69iTyhGk+GiTA2z/SzJYjoYyQS/eQ7BIG6Ch4hvCMkyBpMD4e7Ki
         JgSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=urJQg81tHzPyHCgpuThzFwOt36hRFPMTvZf4VMoNUCQ=;
        b=mvJOS9bhbn2JpFy4DFTCF6r/o+KQE5jvd6VFrU1G/ey3M6/TFqtRoe53OCNNYGUAFI
         dnbmC0szwko00RNT3Emtbv6iPvVOMD5rmwBL7BoIulmvhMWAWCUTNfhaITG3Jh0ubtdZ
         3RCq8PRXb/3uw/j3FeXeoOT3DTCjZKppmGW3oSuv1Mat4CQOKBxZP5mQpxXmiUsb0Jj2
         l8NRO/yZJJofHhX3Zwx/G0+cENLwM1eompWBG7wXMl5IrZ6B7e9Xdq1lg/X1+VJcI0++
         0+KErPuSeqXhMRygX8CCyAu6Zvpw6V+YHF3I+xshf3UmLhkWJHLOV5O7ybgly6+wGNjV
         janQ==
X-Gm-Message-State: AOAM530lxuaxxXizqnOXQh3I7bMHgbrjAQ2fBTZcxwrIfEpT796RouFk
        dB3iUR6/PF3BZwT77yn6gA4=
X-Google-Smtp-Source: ABdhPJwoNYpAvUGKkqJvFwTQ3MOZ5dV6f+224ANezBefO9vDB/LuLpfMq+CQ2oBlRp66l7aWO0oAHQ==
X-Received: by 2002:a63:3587:: with SMTP id c129mr38854710pga.322.1593983675896;
        Sun, 05 Jul 2020 14:14:35 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id a30sm18102254pfr.87.2020.07.05.14.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 14:14:35 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 6/6] net: dsa: felix: use resolved link config
 in mac_link_up()
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        linux@armlinux.org.uk
References: <20200705161626.3797968-1-olteanv@gmail.com>
 <20200705161626.3797968-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f0b70b3f-f62c-7e9b-5bae-f2a1dafcb4dc@gmail.com>
Date:   Sun, 5 Jul 2020 14:14:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705161626.3797968-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 9:16 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Phylink now requires that parameters established through
> auto-negotiation be written into the MAC at the time of the
> mac_link_up() callback. In the case of felix, that means taking the port
> out of reset, setting the correct timers for PAUSE frames, and
> enabling/disabling TX flow control.
> 
> This patch also splits the inband and noinband configuration of the
> vsc9959 PCS (currently found in a function called "init") into 2
> different functions, which have a nomenclature closer to phylink:
> "config", for inband setup, and "link_up", for noinband (forced) setup.
> 
> This is necessary as a preparation step for giving up control of the PCS
> to phylink, which will be done in further patch series.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
