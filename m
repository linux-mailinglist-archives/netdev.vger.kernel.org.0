Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DF32C9023
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgK3VmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgK3VmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 16:42:07 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0C0C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 13:41:27 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id s63so10888515pgc.8
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 13:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/66KycfDuJ4iQrviEddUKKGhdqc8PmfjAOsXXwQ2xLc=;
        b=PTXjDi7dpNQiMuQ1rqC7aehLerXOYUVUZejHxjFTOs/qCNm0Y1spjgPP77GzMSDyFM
         +DmzvYxxIul6S6v/OO155E5vPaZRDIiL8z/il/jUIwOhEm1N+Mreurxi8O5uQO6AKSk6
         Nq1BhW7r+LfiGYSMSt8eiMEhH1kAHw/8Tq2haljCtMoS3dZn1VukPj3fp/5DFfZ0MJ9K
         CrJ0GXBctDXUkuDnxFEe+rql8IT3UITjjhRru3lcKNoPO3ajJNGXHIYDaQgyz/VwX+fU
         OkeHGqULpoCpenjYLwJQ56azA7H9f035mkNvHhBXOhVoRJEosv/xYrRUvfRRy1uq+Sgq
         D1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/66KycfDuJ4iQrviEddUKKGhdqc8PmfjAOsXXwQ2xLc=;
        b=f4kNSbj9FCE/5BCM/BzkrI0DOxuZuayeRPIgeA+fIbafqGDSunvEjGYJ8bqNZH/Awj
         m8g67LN02UO2N4RhN4W4VIkoMh3w7624X9B2lF3PESZEElqlZxyxcV7XuHCBf0utzmtx
         p3ojedY6eo/baTo8VTJSOiVUOYDcBmoUsoazml3XfqkI05OLAk32tsS8er3CgLlPihOk
         LS9XT2UlzvkPVdmVQUwHKk+N37B9hl3BMQldgK8WQ7Wz1E2sBzI8cUleSrMrCmxE3LMW
         BTbbITwZF8j+uGdnbWscsD1O3K+k6Qq112ZhLCNQgw5bcoCGSe19jJ2ZiUH5LAIi7JDL
         A2Hg==
X-Gm-Message-State: AOAM5315hUM+TNRq/HTex8v/tY5YSNvxjR9CXQrToYs2nicvBwnzv4fh
        aeJQ0HsxLKsjJZDvnIQ5tGGPxd+ezFQ=
X-Google-Smtp-Source: ABdhPJxg/3gKv5bYX/zzK93uv5xpmD0qX2eyYo9sLeZ3vOlwAPGlGAMwBJonMJq7XFMF+yqArdfApg==
X-Received: by 2002:a63:4d07:: with SMTP id a7mr19993187pgb.274.1606772486032;
        Mon, 30 Nov 2020 13:41:26 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm16864768pgv.91.2020.11.30.13.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 13:41:25 -0800 (PST)
To:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
 <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local>
 <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf>
 <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf>
 <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
 <20201130193230.f5aopdmcc5x3ldey@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <e5bff49b-7daa-a765-c510-88ecc1a0c8f2@gmail.com>
Date:   Mon, 30 Nov 2020 13:41:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130193230.f5aopdmcc5x3ldey@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/2020 11:32 AM, Vladimir Oltean wrote:
> -----------------------------[cut here]-----------------------------
> From 93ffc25f30849aaf89e50e58d32b0b047831f94d Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Mon, 30 Nov 2020 02:49:25 +0200
> Subject: [PATCH] parisc/led: retrieve device statistics under RTNL, not RCU
> 
> In the effort of making .ndo_get_stats64 be able to sleep, we need to
> ensure the callers of dev_get_stats do not use atomic context.
> 
> The LED driver for HP-PARISC workstations uses a workqueue to
> periodically check for updates in network interface statistics, and
> flicker when those have changed (i.e. there has been activity on the
> line). Honestly that is a strange idea even when protected by RCU, but
> now, the dev_get_stats call can sleep, and iterating through the list of
> network interfaces still needs to ensure the integrity of list of
> network interfaces. So that leaves us only one locking option given the
> current design of the network stack, and that is the RTNL mutex. In the
> future we might be able to make this a little bit less expensive by
> creating a separate mutex for the list of network interfaces.

We have a netdev LED trigger under drivers/leds/trigger/ledtrig-netdev.c
that appears to be nicely duplicating this LED driver.
-- 
Florian
