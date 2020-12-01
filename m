Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785FA2C98E8
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 09:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgLAIOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 03:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbgLAIOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 03:14:41 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7E9C0613D2
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 00:14:00 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id s9so1404015ljo.11
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 00:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=iUfrYyDWxZdH8dYKSW8w9C4lgZfZ3hJjTG2Dzt8tUC4=;
        b=fqIeGkr4BW5wKFMy7uFJ6cBKIWpEytd8+lyuCrEmQuwWKinzGL4O65jtg0P5T2MOde
         CD90giwUBRvfxpledh2dGkhhMIKWhWM54O/OBdE91cjMH3yAbWhJSsx7mZsa/TS6v5/O
         3KXOt3A8LOEzkAhy0K7QK4/ey6Zt1Eauwr96Aon2ITdRNBwqoBhqr63Uz5QZcy+gNape
         Jp5mGkNSpcy167UbP3fdvcaAaeCY/3Dy8gpa5a9/zgI5T7c9NpYW+8/f9wFVCqvERtY0
         UHZxxeMLKg1x4E2n6Bp7z/3eEoQs7JnyjeokI//y0aPZ8/RlhfXG0RgQqxTCsmyxgmn6
         wjMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iUfrYyDWxZdH8dYKSW8w9C4lgZfZ3hJjTG2Dzt8tUC4=;
        b=JgJ0vseacqjMOAlbDeoOv9nltROd89ixwJuxmPmnnXVwHMaYIaBPvdai66WUQzYiYf
         3Ze4im5tgXJY8QMrfF+jbrlcpUkH5RnPQ6+YGCicCbzt8TjT4o7RCfaZCkHgEyaJjsNp
         m7CryN1OWGjyG4Bhv1sSD5Hqw9bbTe8fZ5emCCXNxaXI9B/5BD1ePIM0il/2oYvLIctH
         dlrIGTMIH9sRSW8SaTlm0Ajn67lC5D38iPSszY/+xfajCmlr/hj4zzzwdziaXAkSQMJ1
         03F2NUd+8StQsHvYhDj8Cucb9ozpaCVZjBxQOoIxx8L0PZQRV4aA392663bvREP+OC6Y
         199A==
X-Gm-Message-State: AOAM530CpuaUVpNSIjgVb9MyWBLMyGT5bDDKt9eOomTzvfSxo18m3eiD
        uX08Pl26LYnd9JYjJcm/o5SFq48N5JssepV2
X-Google-Smtp-Source: ABdhPJwTJ1P2NMjerwStyKpzSJwqBckOZ6NMem6OvgwA9ls+lgoEzPyI17avgreG36DBQF5lcRiaKw==
X-Received: by 2002:a2e:8792:: with SMTP id n18mr714510lji.417.1606810439031;
        Tue, 01 Dec 2020 00:13:59 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 123sm119493lff.119.2020.12.01.00.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 00:13:58 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201201013706.6clgrx2tnapywgxf@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com> <20201130140610.4018-3-tobias@waldekranz.com> <20201201013706.6clgrx2tnapywgxf@skbuf>
Date:   Tue, 01 Dec 2020 09:13:57 +0100
Message-ID: <87czzu7xkq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 03:37, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Nov 30, 2020 at 03:06:08PM +0100, Tobias Waldekranz wrote:
>> +static void dsa_lag_release(struct kref *refcount)
>> +{
>> +	struct dsa_lag *lag = container_of(refcount, struct dsa_lag, refcount);
>> +
>> +	rcu_assign_pointer(lag->dev, NULL);
>> +	synchronize_rcu();
>> +	memset(lag, 0, sizeof(*lag));
>> +}
>
> What difference does it make if lag->dev is set to NULL right away or
> after a grace period? Squeezing one last packet from that bonding interface?
> Pointer updates are atomic operations on all architectures that the
> kernel supports, and, as long as you use WRITE_ONCE and READ_ONCE memory
> barriers, there should be no reason for RCU protection that I can see.
> And unlike typical uses of RCU, you do not free lag->dev, because you do
> not own lag->dev. Instead, the bonding interface pointed to by lag->dev
> is going to be freed (in case of a deletion using ip link) after an RCU
> grace period anyway. And the receive data path is under an RCU read-side
> critical section anyway. So even if you set lag->dev to NULL using
> WRITE_ONCE, the existing in-flight readers from the RX data path that
> had called dsa_lag_dev_by_id() will still hold a reference to a valid
> bonding interface.

I completely agree with your analysis. I will remove all the RCU
primitives in v3. Thank you.
