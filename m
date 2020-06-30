Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CAA20F8DA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389775AbgF3Pvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 11:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389772AbgF3Pvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 11:51:45 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4348C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 08:51:44 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o11so20715752wrv.9
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 08:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H9WitW+vcaubqVQO0yzfpoVeH4pHd0QpeThFCwJ1nWU=;
        b=b9x6gaKmo+qUD8bmmSTKgUS97vo7ReMSXicVPp9c1+McWCO9ULbsUOhje3rJI1+/zM
         YPDwNM/4DbvJtTsr057rioMJVcNvscBixx/QhY2D0grQgI2R6v6Uh+aUac4dL4hVRCge
         ulO9d9Qf2y3CUivcdevFDUZP2MYAIHOhDrlEKKMkwonovbDFIHxnPDrT8xA3+F7PVmNC
         4yFv7DG1mdvuRtDJ5HAnNk227pXdtSwgFLNAI0FEk12WekePkn1CUtSsEXlTrVI04MH/
         EmPa01Ev+GprN6rJkIZCOqV+FMDO3mrh2FIRSNkaVSpLR0gRT1gw+g5K7BwanZZ1RL/G
         5zfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=H9WitW+vcaubqVQO0yzfpoVeH4pHd0QpeThFCwJ1nWU=;
        b=RekTGK+eRPlFW0dxh0yoiLw0S1h+QDUUhr8dFmPWUhgcqf63Nz7HlpYlzK/FLohEoR
         /97f0iVVHdshc6hhPtn3iHzq0LG8CDtRCwStHGdMOqIrcRbF4196XzimSr2ZOGjUdBbF
         29sYD24ZV5yYUAXbb/F3QDM++3CvRJzJ+yPkeoBhlVRbcuv/luTlcIgbam7fDGQxmTeO
         hTL1HleVTqInqFxycAPb+NFKU5NEEmeixcdzahEU41MucJMf1h97HaeDF4NosFvIplMu
         1xCTFUhOx54FjXClZj9M2qC8tIPV1n/K06/fjOotaLqEMu6A/ECg4KL4AmhqUFvsunk2
         bkLA==
X-Gm-Message-State: AOAM530zWtA2hHIvIN9zC/vH0L+kU+nTZTiU8v5ZJfqPOq2ceV7/kISE
        CJqfuih+mVAsMKpZoYiw1JbalxXq4oO0Vg==
X-Google-Smtp-Source: ABdhPJw7O4lUep/KG7cOex+EzsCQbm8nkOxQFIYNAQXWpvFMcit/C7ENtXIaQM1G7lJkYnp0vUhZTw==
X-Received: by 2002:adf:fa8b:: with SMTP id h11mr22411875wrr.391.1593532303406;
        Tue, 30 Jun 2020 08:51:43 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:981f:ef60:cbba:acb2? ([2a01:e0a:410:bb00:981f:ef60:cbba:acb2])
        by smtp.gmail.com with ESMTPSA id d18sm4432294wrj.8.2020.06.30.08.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 08:51:42 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v3] IPv4: Tunnel: Fix effective path mtu calculation
To:     Jakub Kicinski <kuba@kernel.org>,
        Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
References: <20200625224435.GA2325089@tws>
 <20200629232235.6047a9c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <99564f5c-07e4-df0d-893d-40757a0f2167@6wind.com>
Date:   Tue, 30 Jun 2020 17:51:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629232235.6047a9c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 30/06/2020 à 08:22, Jakub Kicinski a écrit :
[snip]
> My understanding is that for a while now tunnels are not supposed to use
> dev->hard_header_len to reserve skb space, and use dev->needed_headroom, 
> instead. sit uses hard_header_len and doesn't even copy needed_headroom
> of the lower device.

I missed this. I was wondering why IPv6 tunnels uses hard_header_len, if there
was a "good" reason:

$ git grep "hard_header_len.*=" net/ipv6/
net/ipv6/ip6_tunnel.c:                  dev->hard_header_len =
tdev->hard_header_len + t_hlen;
net/ipv6/ip6_tunnel.c:  dev->hard_header_len = LL_MAX_HEADER + t_hlen;
net/ipv6/sit.c:         dev->hard_header_len = tdev->hard_header_len +
sizeof(struct iphdr);
net/ipv6/sit.c: dev->hard_header_len    = LL_MAX_HEADER + t_hlen;

A cleanup would be nice ;-)
