Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1F4311F4A
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 19:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhBFSOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 13:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhBFSOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 13:14:20 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01893C06174A
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 10:13:40 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id s77so10371695qke.4
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 10:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f5R2rssNoiQT9VPIkeOUCJpaZtFefLBij2PMIMDaWag=;
        b=qgbXFjM9OF9IFV4KEblcrJUn6Y1BayjjVcawUv37Ia+jTiH94ukJlyhzk0bAe9ze6i
         f5UDUQDnFuOUpgNqdYyntmZxOYKAxNpa/3ii0CN8fo9kAPvhrpTTeie6RjtdaIeDzo4i
         OAuo/FZ8UhVM4wd8Ztoz5WAfCoxrx5QIL4/aZz7vJp1NPxqbAvCb7+rhmmDuTkcBM9QR
         M1LNrg8BEwCWxjEUCYeVGqwSJfbmFZitGFMxzHbrgNP8kYqtHCaw68qNM/cG9CPgG1Ci
         JkUK8vCtFubWOYUPAU/47iD/dcRFZIMXWAGK77zGlBxP3IPzg5bYQvSiHhjRrc1nSpsU
         oHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f5R2rssNoiQT9VPIkeOUCJpaZtFefLBij2PMIMDaWag=;
        b=b3iUyXGhkkZdV3bzqvM7BPu6+aeus5OgNVi2w8h7ua3KrDTdcZluARZwJqpRiwBn3o
         2JImFeZIknlxxjFWbjnmWLMh1RjzRFk2/KhKDQxkUE8PQiNvoWHAxJRQJN1kAZx8m1TW
         WEda5sQOHG/INiUH7VUMu97O0yR4tTheHmfFVJ2oCSirpqKtYfSKT+Vy5OK3NkLUdxIr
         MbM947w0pB9WFdEzzWbFefEOmeGFmbwcgJQxuoXp+W1Ensp/FlBwJQ8SUaZtXteHjpVx
         /Onkqf+3vxHuk83vU42qpOx0T1qXA7NCUzg2zbuosVgvXHYMNE9s5TVfatVrUHTALr2q
         7Lkg==
X-Gm-Message-State: AOAM5327RwAvgvAcUSaszHsQxlUCsNIJVk2do9YWYGtxJC3SpetgrhK6
        sFpI6F0xgVwyw7CA4G+Fpfg=
X-Google-Smtp-Source: ABdhPJzUymOjwZO4EVV+YrkFNKPy67W+8NEdEzCgpw5eobMCiMGPieh2MWlJMonvkylctbOY7NTWZg==
X-Received: by 2002:a05:620a:16d9:: with SMTP id a25mr10155956qkn.75.1612635218935;
        Sat, 06 Feb 2021 10:13:38 -0800 (PST)
Received: from horizon.localdomain ([177.220.174.167])
        by smtp.gmail.com with ESMTPSA id v15sm13001835qkv.36.2021.02.06.10.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 10:13:38 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 58BE2C13A6; Sat,  6 Feb 2021 15:13:35 -0300 (-03)
Date:   Sat, 6 Feb 2021 15:13:35 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
Message-ID: <20210206181335.GA2959@horizon.localdomain>
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210206050240.48410-2-saeed@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I didn't receive the cover letter, so I'm replying on this one. :-)

This is nice. One thing is not clear to me yet. From the samples on
the cover letter:

$ tc -s filter show dev enp8s0f0_1 ingress
filter protocol ip pref 4 flower chain 0
filter protocol ip pref 4 flower chain 0 handle 0x1
  dst_mac 0a:40:bd:30:89:99
  src_mac ca:2e:a7:3f:f5:0f
  eth_type ipv4
  ip_tos 0/0x3
  ip_flags nofrag
  in_hw in_hw_count 1
        action order 1: tunnel_key  set
        src_ip 7.7.7.5
        dst_ip 7.7.7.1
        ...

$ tc -s filter show dev vxlan_sys_4789 ingress
filter protocol ip pref 4 flower chain 0
filter protocol ip pref 4 flower chain 0 handle 0x1
  dst_mac ca:2e:a7:3f:f5:0f
  src_mac 0a:40:bd:30:89:99
  eth_type ipv4
  enc_dst_ip 7.7.7.5
  enc_src_ip 7.7.7.1
  enc_key_id 98
  enc_dst_port 4789
  enc_tos 0
  ...

These operations imply that 7.7.7.5 is configured on some interface on
the host. Most likely the VF representor itself, as that aids with ARP
resolution. Is that so?

Thanks,
Marcelo
