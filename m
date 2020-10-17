Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDCD2914E2
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 00:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439682AbgJQWNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 18:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439503AbgJQWNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 18:13:39 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFE4C061755
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 15:13:39 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id b23so3629565pgb.3
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 15:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P5VHnhbF7rKTAZONz08ayvMtjx6bisUYA9zZwSDJ5Co=;
        b=Tx24uvZYdQAALcLh5X+d+KWxs5plK5o+GIbn2PQGVQY9SFpjW3ex+zGpGIPp94p8ws
         J1JT0k6TPUqQVdrQzLX4PMSLYKlvwKRmoo4pdJpVD6J7j5Kyzi4KWTv7ZrZeFtTwDgHD
         RJmkF4zgK151gpK5x6SGQh1uASyuNSruStFBFeAXiH1TVBEoTQXnjNE9oc3OSRJ78mTO
         KD0/6Aa0yZYAs2AcANhoY84zg9AE/oHzYOgSyB5amTfPrnLnhrzYU4zKIhl3TpBNGgCH
         zDPfAARAkyWro7r7eiZCzLZtANtuxtVeOAnXmx35a0gcORWwhbr/FbNP2H6wAy03t6dW
         3iAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P5VHnhbF7rKTAZONz08ayvMtjx6bisUYA9zZwSDJ5Co=;
        b=UPwTNeUnPygdlDpUh4xT6Yxj+tYEhVAgnpQyEOF+gkfRL1lKB2eeCYNhJSiAij+uEj
         SsvvbKAJknKQk/ylyHtDs+yWQ7v+6BKbGLDg0GCs7t49ifP3uMqSJCxUuiK5euulhmid
         qvnwi3CDreW6Rai1kD8ryizk4q4aMfZs6ohjCY7k6lPyTyRLGNncByIXZYcxf1w4HgmL
         grlNSk0aMz2B6t+KUOrkz9xRrcrz1kKPsjqw9c/WxwN8r7Yyezs9ZvRqId6TgEyfklNo
         6nWZYmvvcAoOrAsqWQ1Em1iw/4bczGrFGmF+rnTXNs6h7w04AXaZvGyi/EFAPt7FZhp+
         Kqaw==
X-Gm-Message-State: AOAM530MgRE8Vv2S0q9uxbeG2ks42jiT2lQqeGG6WnPPbpBRjLCj8SxX
        xryz65Mr201vZOUgWfiBpcs=
X-Google-Smtp-Source: ABdhPJxqsURya/M+r+XXWspzuQ1eUugmFrChNgjZRrlFEZeiI2c1hBI6mnuA8fOLybzCBjZ/Lu4FEw==
X-Received: by 2002:a63:ff5d:: with SMTP id s29mr8881154pgk.442.1602972819186;
        Sat, 17 Oct 2020 15:13:39 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y126sm6601928pgb.40.2020.10.17.15.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 15:13:38 -0700 (PDT)
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d79510cf-f3d8-453b-124e-491b8430b9a1@gmail.com>
Date:   Sat, 17 Oct 2020 15:13:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201017213611.2557565-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/17/2020 2:35 PM, Vladimir Oltean wrote:
> DSA needs to push a header onto every packet on TX, and this might cause
> reallocation under certain scenarios, which might affect, for example,
> performance.
> 
> But reallocated packets are not standardized in struct pcpu_sw_netstats,
> struct net_device_stats or anywhere else, it seems, so we need to roll
> our own extra netdevice statistics and expose them to ethtool.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
