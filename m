Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B4442AEFA
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 23:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhJLVdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 17:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbhJLVdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 17:33:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B2FC061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 14:31:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w6so609551pfd.11
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 14:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CUtGP5xXRXTxbja2BrR7716M3DIoJp7Ny781rsQTMQU=;
        b=GTPcer+UGr9p+BVgVNxdtuSfhigO/nNdPoVvLDJg0c3DKu7fDtZ5eNVBO1MRjXtmnj
         gDELHVKSLIqq5cgvNxmE6aN1QSZhaQHJzSwmavj1vJCgGPMK2sw1LeUPFSH8/7R0KfxW
         Kd6JYgf0zgkSuGS7eiwYLFKVuMIL8wZxmQmnQLskr5TKOgQFG/dYkQb50zPY3D+Z0nc/
         bmzQLrMjUe4g+vBOjXmB5kabZIFR+XDd4rtwCXxTxexllbd4AIWy6dY7lppxamGciSSh
         jPE1ce1Gk2PxJKNVjdPa0jWR9aZ230GgfNq9WCbbakMtRvGwJBG/1ORYx/L2uzwpzetS
         j+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CUtGP5xXRXTxbja2BrR7716M3DIoJp7Ny781rsQTMQU=;
        b=bEhHBZrm0a+J+YapEeUalLlZm/HAQkg9xzd0GUC8605u3zej/1xf125VefrwCgxYht
         NRnLzD0qsE0paW8Yl80q3zSiEgPG6uxzhcsIGbSBXOoZhoutkSHPN8AR1BaEeGy9tFof
         oYh/mEO02K+5rvFYnjh+yRaTAFWtbhNrs/O99Yaj21fQen1RinJcT4THladgxYhVdKq4
         3s5lf7ISjYRF9NhEl1GNrrcz4w7Sk/r2vNE43GL4DlsoPlgAQzNTjRwRVZFNRa7y4IWH
         eOdrvC85YM8gXhF+TmktWRAD25NW26V44ZTohCvRUyNprCCoNe8kSwZ7S8t+Ik+K+W4V
         Hhwg==
X-Gm-Message-State: AOAM531Jn+q4mqQJcnnUoTzrht60w5brijUzlD+RErt622zeoSAF/tHY
        evQ6Kh6uHlImSIfu/4YI8a8=
X-Google-Smtp-Source: ABdhPJwTtIjd0IR51bIezBvafG3QAn2NtCnzXkZ7XqkkvrU4epDfPFgBlXPLfwmWnJkWbllRBiRP1g==
X-Received: by 2002:a63:7d0f:: with SMTP id y15mr24625697pgc.446.1634074271234;
        Tue, 12 Oct 2021 14:31:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q21sm3655701pjg.55.2021.10.12.14.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 14:31:10 -0700 (PDT)
Subject: Re: [PATCH v2 net 10/10] net: dsa: felix: break at first CPU port
 during init and teardown
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
 <20211012114044.2526146-11-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <faca12ef-e367-4a40-04b0-67f37f9c49fd@gmail.com>
Date:   Tue, 12 Oct 2021 14:31:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012114044.2526146-11-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 4:40 AM, Vladimir Oltean wrote:
> The NXP LS1028A switch has two Ethernet ports towards the CPU, but only
> one of them is capable of acting as an NPI port at a time (inject and
> extract packets using DSA tags).
> 
> However, using the alternative ocelot-8021q tagging protocol, it should
> be possible to use both CPU ports symmetrically, but for that we need to
> mark both ports in the device tree as DSA masters.
> 
> In the process of doing that, it can be seen that traffic to/from the
> network stack gets broken, and this is because the Felix driver iterates
> through all DSA CPU ports and configures them as NPI ports. But since
> there can only be a single NPI port, we effectively end up in a
> situation where DSA thinks the default CPU port is the first one, but
> the hardware port configured to be an NPI is the last one.
> 
> I would like to treat this as a bug, because if the updated device trees
> are going to start circulating, it would be really good for existing
> kernels to support them, too.
> 
> Fixes: adb3dccf090b ("net: dsa: felix: convert to the new .change_tag_protocol DSA API")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
