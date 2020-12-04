Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34B72CE6DC
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 05:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgLDEFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 23:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbgLDEFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 23:05:30 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94812C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 20:04:50 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id 4so2391508plk.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 20:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D2AEUQPA79DQs3CdXYnQRUAAuj6SQOZ429G/jMZ5h40=;
        b=Oun5DaU5Cgc+p1cEnkHZcwyQk+sUYpWii8wKzB6uyGju1+Dvr2RWPLglQGlt41/uxz
         KgMUKgkz7+ci3QeLl0qzJYedzTGH3BIbZJAl0aOvDei6+bGypl5LRn16/Rcme8PRarVR
         cCvtZez0352cgHMXAsm9tYXvzzgQowz70SfqxRTZjfubgG9fMercuHoaPxjl7M/Evm0r
         QNq9LiDdQeZWWm9cEAwtbmY2BU4US2faYel0K8jbPE12IJWi1pl5oVv0nyoWpjVYXvFv
         zq1pzrSoSEB/P1gOJVX9s8xjtrhLUvWWnQd+m33pFG/dzzXfOXwpPWoubQ3VHQnX672p
         mGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D2AEUQPA79DQs3CdXYnQRUAAuj6SQOZ429G/jMZ5h40=;
        b=oJLBCaFt9lRSxyY9BlMQZOM9NbZRLtj0VjFQivQs82uGTrUfuDkjjsh8Urt6jr01bg
         PcgRx9j8ueoDkCu8xD7L9nr3ZjAU5NPeBIpPhtBEOUq51d1lEzPHkYctViofGyxz1pNB
         F5m3t9tThuwjXwehxUtlhqG9KnzKQKlCIpuheI1mpL1HC+5bYrkUeKxHOx3V5ZYluLiy
         /uS7A3MuaStVltZugeqfmjl+jJ7GFGK+nEX8onjk5nN6pYdz1nDy8T9nRkV9EkqA1Mec
         zmANtGEHzEIyxoNgU9fQC8TH8M1M3KRLiaEIj8B1m0GxD3SU+SGl2vR6a1JwIn/+bwuI
         /eGQ==
X-Gm-Message-State: AOAM533VE7E76asxvVNE8N00Vry9ZZpgbhqndXW3FstH1kT+trvUTSIn
        dYOqEXdhKJMVjSdM/avt6dtkaYyloR8=
X-Google-Smtp-Source: ABdhPJwoBpYP8m0VLrLM4pWFr42yf71u7dlUfrszLaG+iCgqTi0ilJNgPpEsZAaNeQBYDyL9ThcsYg==
X-Received: by 2002:a17:90b:d95:: with SMTP id bg21mr2315596pjb.73.1607054689690;
        Thu, 03 Dec 2020 20:04:49 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h12sm2419182pgf.49.2020.12.03.20.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 20:04:48 -0800 (PST)
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f158d504-4247-8156-97c2-11a6049d4af3@gmail.com>
Date:   Thu, 3 Dec 2020 20:04:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201202091356.24075-3-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2020 1:13 AM, Tobias Waldekranz wrote:
> Monitor the following events and notify the driver when:
> 
> - A DSA port joins/leaves a LAG.
> - A LAG, made up of DSA ports, joins/leaves a bridge.
> - A DSA port in a LAG is enabled/disabled (enabled meaning
>   "distributing" in 802.3ad LACP terms).
> 
> Each LAG interface to which a DSA port is attached is represented by a
> `struct dsa_lag` which is globally reachable from the switch tree and
> from each associated port.
> 
> When a LAG joins a bridge, the DSA subsystem will treat that as each
> individual port joining the bridge. The driver may look at the port's
> LAG pointer to see if it is associated with any LAG, if that is
> required. This is analogue to how switchdev events are replicated out
> to all lower devices when reaching e.g. a LAG.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Vladimir and Andrew have already spotted what I was going to comment on,
just a few suggestions below:
[snip]

> +struct dsa_lag {
> +	struct net_device *dev;
> +	int id;

unsigned int?

> +
> +	struct list_head ports;
> +
> +	/* For multichip systems, we must ensure that each hash bucket
> +	 * is only enabled on a single egress port throughout the
> +	 * whole tree, lest we send duplicates. Therefore we must
> +	 * maintain a global list of active tx ports, so that each
> +	 * switch can figure out which buckets to enable on which
> +	 * ports.
> +	 */
> +	struct list_head tx_ports;
> +	int num_tx;

unsigned int?

Which if you change the type would require you to also change the types
of some iterators you used.
-- 
Florian
