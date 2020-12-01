Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB8B2CB00E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgLAWby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgLAWbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:31:45 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E8BC0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 14:31:05 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id f18so5918489ljg.9
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 14:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=6JE1FrxD03IKGkihuf9eOUF0HXfRQsJ1jr5f8JN0ceY=;
        b=IEs+LKU6Dy8pONqi/ubJJO+ERuo1WU20pb3GnKoBvNwJaYN3/X2M01z9Qd+a8UHADi
         r2OafWMrq+IK4sw56Z3/ZdG7dwYyPCHVZJDB+alXqO4NV4d+qlhsC9tiJ/uEXE54HPu4
         oSfYr+QnZBgtp6frOBu4KRNBcFLqZ3Do9Qz9OxLn574xstjCoGAx52SAMHssP7KffTcz
         a89UUTVgjTEsaZs4SrW8Rbp5fbVfYqDGO8h8GXSzjPhTCu3z3TQLCg23ZtYkxr7IvId4
         c1s4WS6nGj+qaGLmyalEq4syll/GUzlUhrpNObrd9zuWYZJRg8tdtG/NiAFjrMqIpeMe
         APqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6JE1FrxD03IKGkihuf9eOUF0HXfRQsJ1jr5f8JN0ceY=;
        b=PsLWPH3kLjksQ0HYghrhqB1Q/H4V6VxiZKztijGJ/XAN4m4mV6bXiwmtnvQBAVedYt
         mo3i/ZjDntTQnC4co39QdWKLTnwkZ7tREzA7ZsSj9B+xMP8IpW5xtJEGCohO97zW7rcv
         WT/czBTywRhmPGAB7y7rw4HGpnZfU16h8FCuY50mQdZfL7JCleRKfQWrk6cH6b6ewVub
         ishzxZy2CRxI4OjHOeXJBHxALJCJ1t6AtgMoR+NLkNZ3CPRB2dp1q8z/hTC8Yyvipipm
         pokcE42O5bBYf+I3qlkO+9H0+7bVXwagRSh9+MiNoCHkoiHfCkjtSLp3cO7txT24fnRf
         /04w==
X-Gm-Message-State: AOAM5323RtG3pf0EHVE9SwZc3RJkKL8lXqhryFTfkE7HYy+3LO1Fsm8l
        bGVasRXJ4ueJFPlNVX6HcoHV/DNnMXuUPOg7
X-Google-Smtp-Source: ABdhPJzGnR1FO/FLUbWCG+oG1n31FpMZFDkQlFNUVWqS2oKU49kR87J5ol3Rz6p/IUzJFLRi6YDmUw==
X-Received: by 2002:a05:651c:1032:: with SMTP id w18mr2191007ljm.359.1606861863325;
        Tue, 01 Dec 2020 14:31:03 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id i19sm127303lfj.212.2020.12.01.14.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 14:31:02 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: tag_dsa: Support reception of packets from LAG devices
In-Reply-To: <20201201212427.sewnqf7muxwisbcm@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com> <20201130140610.4018-5-tobias@waldekranz.com> <20201201212427.sewnqf7muxwisbcm@skbuf>
Date:   Tue, 01 Dec 2020 23:31:02 +0100
Message-ID: <87sg8p6tw9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 23:24, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Nov 30, 2020 at 03:06:10PM +0100, Tobias Waldekranz wrote:
>> Packets ingressing on a LAG that egress on the CPU port, which are not
>> classified as management, will have a FORWARD tag that does not
>> contain the normal source device/port tuple. Instead the trunk bit
>> will be set, and the port field holds the LAG id.
>> 
>> Since the exact source port information is not available in the tag,
>> frames are injected directly on the LAG interface and thus do never
>> pass through any DSA port interface on ingress.
>> 
>> Management frames (TO_CPU) are not affected and will pass through the
>> DSA port interface as usual.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  net/dsa/dsa.c     | 12 +++++++++++-
>>  net/dsa/tag_dsa.c | 17 ++++++++++++++++-
>>  2 files changed, 27 insertions(+), 2 deletions(-)
>> 
>> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
>> index a1b1dc8a4d87..7325bf4608e9 100644
>> --- a/net/dsa/dsa.c
>> +++ b/net/dsa/dsa.c
>> @@ -219,11 +219,21 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>>  	}
>>  
>>  	skb = nskb;
>> -	p = netdev_priv(skb->dev);
>>  	skb_push(skb, ETH_HLEN);
>>  	skb->pkt_type = PACKET_HOST;
>>  	skb->protocol = eth_type_trans(skb, skb->dev);
>>  
>> +	if (unlikely(!dsa_slave_dev_check(skb->dev))) {
>> +		/* Packet is to be injected directly on an upper
>> +		 * device, e.g. a team/bond, so skip all DSA-port
>> +		 * specific actions.
>> +		 */
>> +		netif_rx(skb);
>> +		return 0;
>
> netif_rx returns an int code, it seems odd to ignore it.

This is exactly the same treatment that the return code from
gro_cells_receive gets just a few lines down. They return the same set
of codes (NET_RX_{SUCCESS,DROP}).

Looking through the source base, there are a few callers that look at
the return value (the overwhelming majority ignore it). Actions vary
from printing warnings (without rate-limit, yikes), setting variables
that are otherwise unused, or bumping a counter (the only reasonable
thing I have seen).

But looking through enqueue_to_backlog, it seems like there already is a
counter for this that is accessible from /proc/net/softnet_data.

>> +	}
>> +
>> +	p = netdev_priv(skb->dev);
>> +
>>  	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
>>  		nskb = dsa_untag_bridge_pvid(skb);
>>  		if (!nskb) {
