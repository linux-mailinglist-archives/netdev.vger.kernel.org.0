Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E955A2932F4
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 04:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgJTCLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 22:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729915AbgJTCLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 22:11:51 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B32AC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 19:11:50 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id y14so69294pgf.12
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 19:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=icbuceNSeGG63fMeOSI2Qo5a+POoLWAhxVhsL4pUmQk=;
        b=eKkJZdy2u5dWW1r9dtcNjq8lkeBmpMMlPz9vxqSiEBqyOumSL0IL0fajiX8KLc9098
         ZiCDqjGlxVKFmOKQ9nXUklwNUCtAC4n12hnKEDND3wZf6RfLBQ7UZGKR9AE+B71TyVAU
         4oLuXhRLng/DJD9Zj6MZ9C6Y+M5vWwhPTX1CF7t913XPHPY5Wttuj4dE1DEZ2+K5Hakt
         XcfhFXxdbkI1ctauN8RZfejwpJWHnqWRuMe9ToOwn9vVZc5CJNWXI+iAUTiccKly97KR
         IjzvNUXD1C/BttGuHfJq14zi3Wq4PIfSa5iZtNuFqikPDC3bLCo4Z+zBjzkpwR2uV8d9
         V/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=icbuceNSeGG63fMeOSI2Qo5a+POoLWAhxVhsL4pUmQk=;
        b=MMW9sNLw5kw1dWa6BhTbFTZ4ZJ9Y5moTAlftrmrTyG9199z81O/Q38H229h5/LPYA2
         IanIvfUbprWazl3qzPgpALxYCVrzPXannenI3hS+v7XMmk1tcuag0jgE4YFY0tbDMoSb
         dfErXvp3Sz6VGIb8a+XFfnLO1FWWiH55ztjfKoJjFW6ecfs3HPZ7allSjSqEvMEU8Vxt
         H8Ly2q2q4mWz8XgpNFOjnx3Ur2PH3DJbFitW/6QIVicirBqB1bClCF5PCq1WyL5HWApx
         zZPQLLKHxh6yKw09Wg3vZQiQe2OhmM+N3JKNEjHgjfxEBGGXcjNBz3F8nOYO+nwmz64d
         MmsQ==
X-Gm-Message-State: AOAM530FC2M5lwzLfsw5iCmOuJvS/vU3wuiNloRBPbDZFK27D+VWGDVQ
        aV5YhxbopZDNrTu25fu5nUg=
X-Google-Smtp-Source: ABdhPJxOh1cJ8zSFEEtEAaVYRjCDeca4Euz2YpMqRjRhHpuugTJtfCIc/9srXLvqkG2lUbSWIdA3Wg==
X-Received: by 2002:a63:4661:: with SMTP id v33mr734509pgk.163.1603159909751;
        Mon, 19 Oct 2020 19:11:49 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z12sm240371pfr.197.2020.10.19.19.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 19:11:48 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: reference count the host mdb addresses
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com
References: <20201015212711.724678-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f48587de-f42b-760b-cbd2-675f2096609e@gmail.com>
Date:   Mon, 19 Oct 2020 19:11:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201015212711.724678-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/15/2020 2:27 PM, Vladimir Oltean wrote:
> Currently any DSA switch that implements the multicast ops (properly,
> that is) gets these errors after just sitting for a while, with at least
> 2 ports bridged:
> 
> [  286.013814] mscc_felix 0000:00:00.5 swp3: failed (err=-2) to del object (id=3)
> 
> The reason has to do with this piece of code:
> 
> 	netdev_for_each_lower_dev(dev, lower_dev, iter)
> 		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
> 
> called from:
> 
> br_multicast_group_expired
> -> br_multicast_host_leave
>     -> br_mdb_notify
>        -> br_mdb_switchdev_host
> 
> Basically, that code is correct. It tells each switchdev port that the
> host can leave that multicast group. But in the case of DSA, all user
> ports are connected to the host through the same pipe. So, because DSA
> translates a host MDB to a normal MDB on the CPU port, this means that
> when all user ports leave a multicast group, DSA tries to remove it N
> times from the CPU port.
> 
> We should be reference-counting these addresses.
> 
> Fixes: 5f4dbc50ce4d ("net: dsa: slave: Handle switchdev host mdb add/del")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This looks good to me, just one possible problem below:

[snip]

> +
> +	a = kzalloc(sizeof(*a), GFP_KERNEL);
> +	if (!a)
> +		return -ENOMEM;

I believe this needs to be GFP_ATOMIC if we are to follow 
net/bridge/br_mdb.c::br_mdb_notify which does its netlink messages 
allocations using GFP_ATOMIC. On a side note, it woul dbe very helpful 
if we could annotate all bridge functions accordingly with their context 
(BH, process, etc.).
-- 
Florian
