Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B06C1E4AF7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbgE0QuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730993AbgE0QuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:50:12 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30160C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:50:12 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 23so12045500pfy.8
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QmerZ6zfORjEPxfrN/UgjjeBC/u4zEEQZFJoWufWlcw=;
        b=oD99m5bMfMK7zBnEU/SmUYuuXG9C8wgzkKnYHTNCRhL+xTyTYe+3/EogtANtI1NHct
         c/V+eh3hFUyk2WjORdl9JevNMrE1LxFi2YTRgln1mHPq8J9TVtEbI6p9qsFdZek9D/OQ
         7ikkXqmJoJfFvRAeGk9XxdsUXveG+IOxidaDv46c8TXbXmIxGTDtLwswdqZfF3nvOFNq
         9phjlfHxqrY8pLXLhNW3veK1aSJvBbRW8GB4FtWFrQECk4LRJ7EDjJ0HkIS+gfMOYhHP
         YXI7PpVrDgkSV1qevzdqOb2561FbLUf4WA3/t7ylesE86VW9JZ8Cg+GMQ8ynvyMEqLxc
         mxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QmerZ6zfORjEPxfrN/UgjjeBC/u4zEEQZFJoWufWlcw=;
        b=TZzNF9LEwhpgeNBtbIMu111fR/ZiEDqwL0e6/buGgISrCCC1uEkPic1P3hrOOyHZV6
         VAaC6bpsPpcQ0VaWhqbVnw6KVKcnC6BC4aW0YgGUSfNvad5QQcwkH6ZYQTgWKlP0O6MU
         lxZyQwTS8m4nM9VMit9AuwqRlAeyFsPRD2BHbmyFHqXg11Mjz/en4Pzuq8J59fdVw+NP
         qQK5/GCGMvxBD8S7QCVQeXKPD9XJ8frbsbNDfHshTg8CvZ9ImICGMfWOiHU5u0zUXqTm
         22o2x3qpj1JXYI5uc6sJ6GLWV7hLpw0br5FDhqgHr9HD+cag/+jZQCvof0FFVpNx/iBi
         /XAQ==
X-Gm-Message-State: AOAM530+qz2mg6wRgpJzot+TM+l3isGNRnkvHIvIzAmxGcUsq7RItjsa
        rDfVSQSGEDj4xnQoAfbt3sFBNxET
X-Google-Smtp-Source: ABdhPJxqoTSrmvG0YX7qZdi8C0DMgEICeqdDCRAa7+pp7ca8wD/IBFaHOffExJRT5s5iaIWjjcTFKg==
X-Received: by 2002:a63:fd15:: with SMTP id d21mr4691872pgh.31.1590598210912;
        Wed, 27 May 2020 09:50:10 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z20sm3150410pjn.53.2020.05.27.09.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:50:10 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: felix: send VLANs on CPU port as
 egress-tagged
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20200527164803.1083420-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e585473b-08b4-86b1-47ad-142951619e7a@gmail.com>
Date:   Wed, 27 May 2020 09:50:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200527164803.1083420-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2020 9:48 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As explained in other commits before (b9cd75e66895 and 87b0f983f66f),
> ocelot switches have a single egress-untagged VLAN per port, and the
> driver would deny adding a second one while an egress-untagged VLAN
> already exists.
> 
> But on the CPU port (where the VLAN configuration is implicit, because
> there is no net device for the bridge to control), the DSA core attempts
> to add a VLAN using the same flags as were used for the front-panel
> port. This would make adding any untagged VLAN fail due to the CPU port
> rejecting the configuration:
> 
> bridge vlan add dev swp0 vid 100 pvid untagged
> [ 1865.854253] mscc_felix 0000:00:00.5: Port already has a native VLAN: 1
> [ 1865.860824] mscc_felix 0000:00:00.5: Failed to add VLAN 100 to port 5: -16
> 
> (note that port 5 is the CPU port and not the front-panel swp0).
> 
> So this hardware will send all VLANs as tagged towards the CPU.
> 
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
