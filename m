Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5DF2BA09C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 03:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgKTCnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 21:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgKTCnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 21:43:42 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728E2C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 18:43:42 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t37so5952005pga.7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 18:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i3bd5w7GzRneLzcROTo1nSsOPh49W/4XKgcH/lZF7jc=;
        b=PuEbMwQSjswkkoPJ+tBI22315T/j21sjChTh3CSlYX9yoNROacY7Zie6YCNENex3lf
         WlNRGquj8Q9uiLA1U8uYGak/qHkPlcRjN6oj6J+zcpnpy984gvSLrbIKZbrtAhg5Exow
         2ThAz2H7XjFStkC1h0qcFW+Z/W9q+rjZzlmc9t4x0zM7Ao8+mILUqR9LbrgQJ7jwKzgV
         3CldbknKqh1cD9nzw7U+JbdMgM5q/w3ftrt97Dd9aEJA/KLoVVm6KE63xrX89OFuXy+w
         /kR2kZm7RrfMteV1+ArEFFD1vFYio9dpl2fQSdp1jy12ldSaDeDsFpd4O9X4a65MlvFt
         XI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i3bd5w7GzRneLzcROTo1nSsOPh49W/4XKgcH/lZF7jc=;
        b=HjejoF4Og1ZoT5oHGnAEKZtlQCsayRA8Kn/eg8+5RVqCO8i+KFeA74MNFcd+lHxspR
         uJxo8LfYhBi2pzwpKgD+MkaR+6/s8xvFy83Ek0ayNf28b1e0XV/uuXVWnwlLPBlVOHG8
         7cX8rlDP4iQLKREvVkVi0IGEKxgIU2MmfY1LatXOVwq9t/yCxYaepw35Yg9EqX6o8YyQ
         RkXUBv+IMfx9CHKH/eNueq/uWslk60+Rk9nz4gvs7869ed+/b09A0C69h76z91rVdk5I
         GMZmkm38Tb0TZoTBgs3JmSeBGjKrhgtL6ajdJZ4W4xilrR5f500QbmzTmv3ydtMigDPe
         OjUA==
X-Gm-Message-State: AOAM531X9bCvYZ+/+SAkLdWosDOUHBfRu5MwXH5WHKRCUKAJrHme5fc/
        fYwt/YLh6XMioGzbgpYq0139ByATv8I=
X-Google-Smtp-Source: ABdhPJxmxHb2isuq2aaeXTRyzRvPNfJWyxX+NOQIMIyUfppSVv2zirau8AVIcf48lTqEteEUmdXrgQ==
X-Received: by 2002:a17:90a:e28a:: with SMTP id d10mr7492445pjz.70.1605840221472;
        Thu, 19 Nov 2020 18:43:41 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g4sm1151549pgu.81.2020.11.19.18.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 18:43:40 -0800 (PST)
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
To:     Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
References: <20201119144508.29468-1-tobias@waldekranz.com>
 <20201119144508.29468-3-tobias@waldekranz.com>
 <20201120003009.GW1804098@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5e2d23da-7107-e45e-0ab3-72269d7b6b24@gmail.com>
Date:   Thu, 19 Nov 2020 18:43:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201120003009.GW1804098@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/2020 4:30 PM, Andrew Lunn wrote:
>> +static struct dsa_lag *dsa_lag_get(struct dsa_switch_tree *dst,
>> +				   struct net_device *dev)
>> +{
>> +	unsigned long busy = 0;
>> +	struct dsa_lag *lag;
>> +	int id;
>> +
>> +	list_for_each_entry(lag, &dst->lags, list) {
>> +		set_bit(lag->id, &busy);
>> +
>> +		if (lag->dev == dev) {
>> +			kref_get(&lag->refcount);
>> +			return lag;
>> +		}
>> +	}
>> +
>> +	id = find_first_zero_bit(&busy, BITS_PER_LONG);
>> +	if (id >= BITS_PER_LONG)
>> +		return ERR_PTR(-ENOSPC);
>> +
>> +	lag = kzalloc(sizeof(*lag), GFP_KERNEL);
>> +	if (!lag)
>> +		return ERR_PTR(-ENOMEM);
> 
> Hi Tobias
> 
> My comment last time was to statically allocated them at probe
> time. Worse case scenario is each port is alone in a LAG. Pointless,
> but somebody could configure it. In dsa_tree_setup_switches() you can
> count the number of ports and then allocate an array, or while setting
> up a port, add one more lag to the list of lags.

The allocation is allowed to sleep (have not checked the calling context
of dsa_lag_get() whether this is OK) so what would be the upside of
doing upfront dsa_lag allocation which could be wasteful?
-- 
Florian
