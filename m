Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DD71E0074
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbgEXQNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 12:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387416AbgEXQNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 12:13:05 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B628AC061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 09:13:05 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x18so5478782pll.6
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 09:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=puU+1HVRCE+9aFae7OQD7/5xEokRyuncMSLSnr9MxSQ=;
        b=llXRuaau3la5AKkyve8wvHhv/7c/qd0ffnnyQAuqckD9wA9+s0Bq2H52q1jX4eYShb
         562NHKDTKbAb5LoC58J2tP/7jK3fWfkUd1oY677Bq49GO6jc5l82oKaRWsbFt2iuVf7F
         pmQUa30+ieM5/tGIB+DQDjJMx/cFNiAoXd+GtuhIc2KlRo6OEPAo3C5X13QTMvS4iiF7
         6K/VWTY9UlW//6PZwV1e47Mfiu58/1QXAKbzLwdi9TZ3rvZSCs/1RK3T8pvt6dT6Bv3i
         9t48FC5d8G8h5eLCJ7aRNqsjYcsWMZZtP7eXBUXrBnY/3/UjlLQlie9m2N5soSA6JwmX
         lDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=puU+1HVRCE+9aFae7OQD7/5xEokRyuncMSLSnr9MxSQ=;
        b=ErqQUOBPkwnqLwUM7dXJIHrhsgFk3FUVQI1VIsPIY+vfZ3qJI2Exq9YJSlk6F3xdnl
         jnn9EKsEt03mEZInX9+SsPrYpfvnXbEHkIhFWk+vP0ZKANcT0sLMHqJnAyT7TUtBFU7W
         A0ckTyzX4KTD3FUT0I1pfemeyOO3IdFagn/XBpt3r8K9zY19Qk7U6NAtEhIK0rzcggwh
         pWcT69pVGGu0FCYYD2fA4/6d0X0mhSjW2oG/CZE1lXp9s0mu7n8e7w+3f8CkbArbNFtO
         CUjoRiugrbvcRMRLgcTCr9CpNwpvR86oLrzOzF+y1XPu3DzplAQTPdDdOljor7IaBN6x
         qtMQ==
X-Gm-Message-State: AOAM531OOIW0THZvHlE7yEuLTKCd/n90JZlaa+EbItm/aIiMVUa1nlKg
        OvwinME4M9XrZeuSexkFTxg=
X-Google-Smtp-Source: ABdhPJyLrGnZvUUq9azhwMZZxcDeA0LiwvLiSj2o4eZF45jD2llubpCWagPBKxS/dlUVEg8Mxq9rpg==
X-Received: by 2002:a17:90a:714c:: with SMTP id g12mr16707364pjs.31.1590336785035;
        Sun, 24 May 2020 09:13:05 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t2sm3015398pgh.89.2020.05.24.09.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2020 09:13:04 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
References: <20200521211036.668624-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f51e89a0-b481-e0e1-0e87-f803f116f684@gmail.com>
Date:   Sun, 24 May 2020 09:13:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 5/21/2020 2:10 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is a WIP series whose stated goal is to allow DSA and switchdev
> drivers to flood less traffic to the CPU while keeping the same level of
> functionality.
> 
> The strategy is to whitelist towards the CPU only the {DMAC, VLAN} pairs
> that the operating system has expressed its interest in, either due to
> those being the MAC addresses of one of the switch ports, or addresses
> added to our device's RX filter via calls to dev_uc_add/dev_mc_add.
> Then, the traffic which is not explicitly whitelisted is not sent by the
> hardware to the CPU, under the assumption that the CPU didn't ask for it
> and would have dropped it anyway.
> 
> The ground for these patches were the discussions surrounding RX
> filtering with switchdev in general, as well as with DSA in particular:
> 
> "[PATCH net-next 0/4] DSA: promisc on master, generic flow dissector code":
> https://www.spinics.net/lists/netdev/msg651922.html
> "[PATCH v3 net-next 2/2] net: dsa: felix: Allow unknown unicast traffic towards the CPU port module":
> https://www.spinics.net/lists/netdev/msg634859.html
> "[PATCH v3 0/2] net: core: Notify on changes to dev->promiscuity":
> https://lkml.org/lkml/2019/8/29/255
> LPC2019 - SwitchDev offload optimizations:
> https://www.youtube.com/watch?v=B1HhxEcU7Jg
> 
> Unicast filtering comes to me as most important, and this includes
> termination of MAC addresses corresponding to the network interfaces in
> the system (DSA switch ports, VLAN sub-interfaces, bridge interface).
> The first 4 patches use Ivan Khoronzhuk's IVDF framework for extending
> network interface addresses with a Virtual ID (typically VLAN ID). This
> matches DSA switches perfectly because their FDB already contains keys
> of the {DMAC, VID} form.
> 
> Multicast filtering was taken and reworked from Florian Fainelli's
> previous attempts, according to my own understanding of multicast
> forwarding requirements of an IGMP snooping switch. This is the part
> that needs the most extra work, not only in the DSA core but also in
> drivers. For this reason, I've left out of this patchset anything that
> has to do with driver-level configuration (since the audience is a bit
> larger than usual), as I'm trying to focus more on policy for now, and
> the series is already pretty huge.


First off, thank you very much for collecting the various patches and
bringing them up to date, so far I only had a cursory look at your
patches and they do look good to me in principle. I plan on testing this
next week with the b53/bcm_sf2 switches and give you some more detailed
feedback.

Which of UC or MC filtering do you value the most for your use cases?
For me it would be MC filtering because the environment is usually
Set-top-box and streaming devices.
-- 
Florian
