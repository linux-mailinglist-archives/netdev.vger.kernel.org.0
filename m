Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35ECB2D1BEE
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgLGVUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgLGVUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:20:37 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2567CC061749
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 13:19:51 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id d20so20099631lfe.11
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 13:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=4YzUWzpEKxj8hl0RiN0rUDzUMdrebWVYVhABeQn/IbI=;
        b=a656DVxAsXrCO3Hk0Rrob3FAcA/Kbe7b4pxjLNgU7sVSzW7iayw2nbxAY0BziekQNj
         z/K2Bv598xVd2EZlYcGSEgdo53zNnQRtbhDtocVYmi3eEVq8meoUSApoVTW9jzozXytg
         7A2veqcrJ0DZv5yXz0SjK5z9VgRCKsuycdwdfCSIbYuDojdbC6SkKjOaA/H36JeOioPW
         G3fcj6A6jxmF+1cbPGhRyRQ6nvBhZkQeInC+HgpJIuULc5520yKcxwzTiywfQcMU6oxB
         hC0zfe4DPJsJNBRVltgWjwJ89NEkXQjS4CmbSdbuPp/yA6cngELKdi+Kmiami3oP2x3V
         4oLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4YzUWzpEKxj8hl0RiN0rUDzUMdrebWVYVhABeQn/IbI=;
        b=HpEbJMo9D+s7KZat6/Napcv6+Cu3y8m7+obV+yEqXs/d67DCpenwrheOoHXC6Sh1tH
         5bXpiwaVygxJbUf/bPp8d7H6gJ+BOIE6FCb5upVz9vzJU0udkK+i5MIGxCb1v8R7Lg0l
         EJbJM8WJR811UuS2zgm8Z4BuBnzMjDvbf+dGmE9+uTg4WyNM9EDc4G2SIbsZL+OoPwUe
         KN5katTCnVAZzMOkFbJOg6rRxyr/3m1HKia+xr93X8HiGvP8zS45zeNJZ5Zk+7/Er+EB
         Ix69cLOMvJHZH532xQkvh31a0UVjv4dfZuxR3JMnEEPE+okEEcfwQGQuiUkMryFOBoSf
         Ayzw==
X-Gm-Message-State: AOAM530HsfpxUQyNA7gNV8TPsjSa+/wNrkOISATrKBLNZSc+4fsFJ3lV
        TACsRm5TI5XG3jbO189LWZr/xuKvZesbYZ3Y
X-Google-Smtp-Source: ABdhPJwyiIxK7CSf70ohHzgrM7VbAFg4A1K5ms/nk+ADPr9BTO0xRyDpQJ8splKqB4A/5IfbX1009A==
X-Received: by 2002:a19:5012:: with SMTP id e18mr9902457lfb.401.1607375989260;
        Mon, 07 Dec 2020 13:19:49 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id s22sm2995503lfi.187.2020.12.07.13.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 13:19:48 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201204022025.GC2414548@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201204022025.GC2414548@lunn.ch>
Date:   Mon, 07 Dec 2020 22:19:47 +0100
Message-ID: <87v9dd5n64.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 03:20, Andrew Lunn <andrew@lunn.ch> wrote:
>> +static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
>> +{
>> +	struct dsa_port *dp;
>> +	unsigned int num;
>> +
>> +	list_for_each_entry(dp, &dst->ports, list)
>> +		num = dp->ds->num_lags;
>> +
>> +	list_for_each_entry(dp, &dst->ports, list)
>> +		num = min(num, dp->ds->num_lags);
>
> Do you really need to loop over the list twice? Cannot num be
> initialised to UINT_MAX and then just do the second loop.

I was mostly paranoid about the case where, for some reason, the list of
ports was empty due to an invalid DT or something. But I now see that
since num is not initialized, that would not have helped.

So, is my paranoia valid, i.e. fix is `unsigned int num = 0`? Or can
that never happen, i.e. fix is to initialize to UINT_MAX and remove
first loop?

>> +static inline bool dsa_port_can_offload(struct dsa_port *dp,
>> +					struct net_device *dev)
>
> That name is a bit generic. We have a number of different offloads.
> The mv88E6060 cannot offload anything!

The name is intentionally generic as it answers the question "can this
dp offload requests for this netdev?"

>> +{
>> +	/* Switchdev offloading can be configured on: */
>> +
>> +	if (dev == dp->slave)
>> +		/* DSA ports directly connected to a bridge. */
>> +		return true;

This condition is the normal case of a bridged port, i.e. no LAG
involved.

>> +	if (dp->lag && dev == rtnl_dereference(dp->lag->dev))
>> +		/* DSA ports connected to a bridge via a LAG */
>> +		return true;

And then the indirect case of a bridged port under a LAG.

I am happy to take requests for a better name though.

>> +	return false;
>> +}
>
>> +static void dsa_lag_put(struct dsa_switch_tree *dst, struct dsa_lag *lag)
>> +{
>> +	if (!refcount_dec_and_test(&lag->refcount))
>> +		return;
>> +
>> +	clear_bit(lag->id, dst->lags.busy);
>> +	WRITE_ONCE(lag->dev, NULL);
>> +	memset(lag, 0, sizeof(*lag));
>> +}
>
> I don't know what the locking is here, but wouldn't it be safer to
> clear the bit last, after the memset and WRITE_ONCE.

All writers of dst->lags.busy are serialized with respect to dsa_lag_put
(on rtnl_lock), and concurrent readers (dsa_lag_dev_by_id) start by
checking busy before reading lag->dev. To my understanding, WRITE_ONCE
would insert the proper fence to make sure busy was cleared before
clearing dev?

>     Andrew
