Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D931ADC2
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 20:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhBMTXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhBMTXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:23:15 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420CCC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:22:35 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id z18so2281571ile.9
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sf3OeMOqBUCD+g+EgISR8G9DvFzoAvJZrDQA5hNAGCg=;
        b=u3B9Cqkw8LDmwVQBnCLT1bAkg6cO2CYNim60vlE4SxKeO8Tnq9/QFl+FTfcpGtr3ek
         cJZM6g5UJLGWrbaH9uiFxZps4sb6zrcqfeGAXYHfWaXc+RtXdLuE6F9rXPeJabs4pp7D
         cYmx73EK40ewBssVHEbTv7+bsEcyyyZxb+eKQvcOc0phtHc7qvseZDMrOsoFroK/kBQy
         aMWt4Fds1JNJivwgjQaQMj33Bx7EmQ929HAG1KpZLR53eXwsw51/W4aHrfrfOnJ7Vp1L
         Vk69OqhVkkR+BaifDoKjDGzVycBYoWjyTxQzd68hH3S7lI1/mP+AXIqsA8rhrQFhUSH5
         ga+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sf3OeMOqBUCD+g+EgISR8G9DvFzoAvJZrDQA5hNAGCg=;
        b=N9G3a4DzyJ8cVdyLuoL+bex6Ws5m3wl72XN0ogCa+Orbs9kgnvOQ/cxnibtUPtzZCz
         a+XpL53eAKqOfs8YHp0i13wZkNSDXtDbJaXI9O2qfDpeiCYa2r6k/Xsrhkzmr8W/Znp5
         lBkQeBtq4cQkNBAG3Zfb2MgVkmoYR1ZoHHxF41hm1z4J/BAmawvaaUMRrs4SDAwcwWtG
         CYo+2eK5SO9s2x+Vj8aCRsp0e7ExIWhTzAo4JK8HkLT5F8LzafR+HeBJN5BRNF5b7W6k
         rbrHZmoOgRhJIl1TDm0V6+wqaoHl6LVzm9mMqQH0T7vwM8TiEHjWANTbyM8cupkLU8Od
         fBmw==
X-Gm-Message-State: AOAM531dBHyw87aRNJjFYglj2pDqvRGvCO6L4igmk6H21Q0ZylijSmEu
        G5hR9duYWf5OU5eFj6oih40=
X-Google-Smtp-Source: ABdhPJzQGZDSB78ntJX7ZZbjvS8dmBjoAyBuDFvx9eaZmkCPfY2y7CHq1BhEcvZ5rmSM5yreBwCgjg==
X-Received: by 2002:a92:6b0f:: with SMTP id g15mr7549087ilc.144.1613244154797;
        Sat, 13 Feb 2021 11:22:34 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id b8sm6047484iow.44.2021.02.13.11.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 11:22:34 -0800 (PST)
Subject: Re: [RFC PATCH 04/13] nexthop: Add implementation of resilient
 next-hop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1612815057.git.petrm@nvidia.com>
 <dec388d80b682213ed2897d9f4ae40c2c2dd9eb8.1612815058.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9bd96142-9dce-efb5-8ac6-d4aa62441fa4@gmail.com>
Date:   Sat, 13 Feb 2021 12:22:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <dec388d80b682213ed2897d9f4ae40c2c2dd9eb8.1612815058.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 1:42 PM, Petr Machata wrote:
> @@ -212,7 +254,7 @@ static inline bool nexthop_is_multipath(const struct nexthop *nh)
>  		struct nh_group *nh_grp;
>  
>  		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
> -		return nh_grp->mpath;
> +		return nh_grp->mpath || nh_grp->resilient;

That pattern shows up multiple times; since this is datapath, it would
be worth adding a new bool for it (is_multipath or has_nexthops or
something else along those lines)

