Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55342FAB4A
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388547AbhARUUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394166AbhARUTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 15:19:54 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904D6C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 12:19:14 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id o19so25875165lfo.1
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 12:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=+veugtHxvnSxzGDuzi3pScwWXhq85cAx+Mwod0bKbCA=;
        b=1178nX4yYZ8h0d4DxvlYiGyxqZheskrgm+BMQ5eLbgJ8HQRt3IBIEKQvXOjH1WGPBn
         fD2yXuxbkV7u5kGwfU6VgrCSQDCQAJ9A3eaBWDZJwBGO9mWcF2BY/J01+tClYgEj7Erx
         yTTm4i2SwqkllNO4CNkxXgnE3mTAaRpBBz0E8lm6xNm7WTCwGB58WC3YBA9guL9jEzL/
         mmyBwFotu7iCWzzDofYWl+pdkSDP5xwc24mu+441oz3HgGQVx8EHJjT44uTJHZBbI4jS
         f7+YHrl1CCJ9jR58SL99Xscpt80CJz7keevAazGOCtxasrCO2p1S/8l7VPECnRqRn91R
         DGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+veugtHxvnSxzGDuzi3pScwWXhq85cAx+Mwod0bKbCA=;
        b=t01N+TAJm1fAOyfSvYWjlA4RBySSjk86A8WG98DZMMwKTuTiTqT+tn9LNFok9Ybymg
         15ccKMtq41gOGpbO3w0fVoRIpFn+TbPy4YISBUtS3ZEZbfZUy74QX6welrhQZLW545nr
         8EiJ/jpJlfjQyNu+uqiEE5xu+ehYky3A2o7k0cYhDlBuAJUo65ZrFxKe92cJVDx9mkzO
         NhqgNVoRvx2EVpp7KqYzjAnuyFEwE9gtqJIb6PqiuwnlAvA6OPF1sTYTu0ssr1FnfiJr
         u2Kq+BfUKnYNeCZlSHKf/CGLTc0vx1KTLhC6dFalJapphUBMsgfYW6/Q/KyGS0Ai3iiB
         LcQg==
X-Gm-Message-State: AOAM533Ze40emqWp5/SyTXXWI9wfx1Pkb7ZoxU5r01Tt8yRs8Ga9v5y5
        vZhduTVhnQkBzZHmjcQX3COhwA==
X-Google-Smtp-Source: ABdhPJzUJZi8IzsBOGSdnAeLzsBu3HALGUcNz4J1mi1BF62HOQzE5JMcxCqKRIPCVc/Mp8AWZMiFuw==
X-Received: by 2002:ac2:5451:: with SMTP id d17mr353591lfn.222.1611001153059;
        Mon, 18 Jan 2021 12:19:13 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id z14sm2068204lfq.130.2021.01.18.12.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:19:12 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, netdev@vger.kernel.org, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in FDB notifications
In-Reply-To: <20210118192757.xpb4ad2af2xpetx3@skbuf>
References: <20210116012515.3152-1-tobias@waldekranz.com> <20210116012515.3152-3-tobias@waldekranz.com> <20210117193009.io3nungdwuzmo5f7@skbuf> <87turejclo.fsf@waldekranz.com> <20210118192757.xpb4ad2af2xpetx3@skbuf>
Date:   Mon, 18 Jan 2021 21:19:11 +0100
Message-ID: <87o8hmj8w0.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 21:27, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Jan 18, 2021 at 07:58:59PM +0100, Tobias Waldekranz wrote:
>> Ah I see, no I was not aware of that. I just saw that the entry towards
>> the CPU was added to the ATU, which it would in both cases. I.e. from
>> the switch's POV, in this setup:
>> 
>>    br0
>>    / \ (A)
>> swp0 dummy0
>>        (B)
>> 
>> A "local" entry like (A), or a "static" entry like (B) means the same
>> thing to the switch: "it is somewhere behind my CPU-port".
>
> Yes, except that if dummy0 was a real and non-switchdev interface, then
> the "local" entry would probably break your traffic if what you meant
> was "static".

Agreed.

>> > So I think there is a very real issue in that the FDB entries with the
>> > is_local bit was never specified to switchdev thus far, and now suddenly
>> > is. I'm sorry, but what you're saying in the commit message, that
>> > "!added_by_user has so far been indistinguishable from is_local" is
>> > simply false.
>> 
>> Alright, so how do you do it? Here is the struct:
>> 
>>     struct switchdev_notifier_fdb_info {
>> 	struct switchdev_notifier_info info; /* must be first */
>> 	const unsigned char *addr;
>> 	u16 vid;
>> 	u8 added_by_user:1,
>> 	   offloaded:1;
>>     };
>> 
>> Which field separates a local address on swp0 from a dynamically learned
>> address on swp0?
>
> None, that's the problem. Local addresses are already presented to
> switchdev without saying that they're local. Which is the entire reason
> that users are misled into thinking that the addresses are not local.
>
> I may have misread what you said, but to me, "!added_by_user has so far
> been indistinguishable from is_local" means that:
> - every struct switchdev_notifier_fdb_info with added_by_user == true
>   also had an implicit is_local == false
> - every struct switchdev_notifier_fdb_info with added_by_user == false
>   also had an implicit is_local == true
> It is _this_ that I deemed as clearly untrue.
>
> The is_local flag is not indistinguishable from !added_by_user, it is
> indistinguishable full stop. Which makes it hard to work with in a
> backwards-compatible way.

This was probably a semantic mistake on my part, we meant the same
thing.

>> Ok, so just to see if I understand this correctly:
>> 
>> The situation today it that `bridge fdb add ADDR dev DEV master` results
>> in flows towards ADDR being sent to:
>> 
>> 1. DEV if DEV belongs to a DSA switch.
>> 2. To the host if DEV was a non-offloaded interface.
>
> Not quite. In the bridge software FDB, the entry is marked as is_local
> in both cases, doesn't matter if the interface is offloaded or not.
> Just that switchdev does not propagate the is_local flag, which makes
> the switchdev listeners think it is not local. The interpretation of
> that will probably vary among switchdev drivers.
>
> The subtlety is that for a non-offloading interface, the
> misconfiguration (when you mean static but use local) is easy to catch.
> Since only the entry from the software FDB will be hit, this means that
> the frame will never be forwarded, so traffic will break.
> But in the case of a switchdev offloading interface, the frames will hit
> the hardware FDB entry more often than the software FDB entry. So
> everything will work just fine and dandy even though it shouldn't.

Quite right.

>> With this series applied both would result in (2) which, while
>> idiosyncratic, is as intended. But this of course runs the risk of
>> breaking existing scripts which rely on the current behavior.
>
> Yes.
>
> My only hope is that we could just offload the entries pointing towards
> br0, and ignore the local ones. But for that I would need the bridge

That was my initial approach. Unfortunately that breaks down when the
bridge inherits its address from a port, i.e. the default case.

When the address is added to the bridge (fdb->dst == NULL), fdb_insert
will find the previous local entry that is set on the port and bail out
before sending a notification:

	if (fdb) {
		/* it is okay to have multiple ports with same
		 * address, just use the first one.
		 */
		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
			return 0;
		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
		       source ? source->dev->name : br->dev->name, addr, vid);
		fdb_delete(br, fdb, true);
	}

You could change this so that a notification always is sent out. Or you
could give precedence to !fdb->dst and update the existing entry.

> maintainers to clarify what is the difference between then, as I asked
> in your other patch.

I am pretty sure they mean the same thing, I believe that !fdb->dst
implies is_local. It is just that "bridge fdb add ADDR dev br0 self" is
a new(er) thing, and before that there was "local" entries on ports.

Maybe I should try to get rid of the local flag in the bridge first, and
then come back to this problem once that is done? Either way, I agree
that 5/7 is all we want to add to DSA to get this working.
