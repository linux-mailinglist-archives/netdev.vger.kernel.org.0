Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276D7275E3D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIWRHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIWRHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:07:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A89C0613CE;
        Wed, 23 Sep 2020 10:07:00 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d19so60162pld.0;
        Wed, 23 Sep 2020 10:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A5qasqcEMgqLNyJX2lVqm6x3hBYgaK7GDkCHFQcHr8k=;
        b=fRQErVsHGTAw8YxfYVpeWtEm3sSO+47s1BoDnlkvvBFUTCPOMZutkFgCB1b8AS9IE9
         x+f6gahMY0/3KMR1fBnpYTD5DvG1z/IUduvnHBZxctv3K7cWADyruNjYxinj9R7ns8vG
         C1FWNh7GGL39c/HdG2R3Ufp9bT+LCQX6+i7gvtAlh7f7NrQYgeyyDc6t1SXQFzpLOXpL
         XZV5O9fA1wL8bsec+i2BsTJBo6ZoU4wI68sedZP4stCD8AWXq2xTS/Hn+RyImORKMPMp
         /ep24iWNZni+SgOiN6WZGSajhH+WZKkL3o2TOzXUL0E1oUCOOsp5iIShx0eb2i9EAdgv
         PL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=A5qasqcEMgqLNyJX2lVqm6x3hBYgaK7GDkCHFQcHr8k=;
        b=SFYOWqPtenEDPzulAM3+/DIjrZ9fomnyUsd1AWAOskZfi1MoAuXYwPSF5d+BB5TmZv
         gO56Z13BLS95jm7FVU4p9vIxqFnz06UvlcX9T2AEKrh4xWcxCUaiVXcOZFjmazrtHl/m
         hZvOfblJ8n65/v/xOMyGgxh4J0uHIJSxJp+zTBgbmcwKpmJykPkINSorEA1sWhel4WCF
         ZkC7o2DZvEGCmLAXMrvvfew1w9g0M8sMqqLgjcLDl/eiLlGmNfFecHVZ1/sZlefIjR+x
         QhRRGs+FTz7kNUtxr+CV+awGsdM/vy2wvf4c3zypDGtJyrnbCqCSlDxH0EhgSE7cDRj9
         eD6A==
X-Gm-Message-State: AOAM532lY74WO1YDbc7Smfx49626xUkvzHpKlgOZ3x4LbhoVWmI6vT9O
        FUbSzMPc+SCnbTG8RzbZopk=
X-Google-Smtp-Source: ABdhPJw3viIg2IFyDYvjGGJe54ofa3hB5VTwEinFGeto0xAbGWHYenQ8PWDukVUMkfCthZUIZs9htw==
X-Received: by 2002:a17:902:e9d2:b029:d1:e5e7:be63 with SMTP id 18-20020a170902e9d2b02900d1e5e7be63mr702196plk.61.1600880820162;
        Wed, 23 Sep 2020 10:07:00 -0700 (PDT)
Received: from [10.67.49.188] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 17sm265547pfi.55.2020.09.23.10.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 10:06:59 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: dsa: untag the bridge pvid from rx skbs
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
References: <20200923031155.2832348-1-f.fainelli@gmail.com>
 <20200923031155.2832348-2-f.fainelli@gmail.com>
 <20200923081450.2ghr6am4vjci6cd4@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <60a01fb2-422b-54e4-3353-3766b1a10059@gmail.com>
Date:   Wed, 23 Sep 2020 10:06:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200923081450.2ghr6am4vjci6cd4@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/20 1:14 AM, Vladimir Oltean wrote:
> On Tue, Sep 22, 2020 at 08:11:54PM -0700, Florian Fainelli wrote:
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index d16057c5987a..b539241a7533 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -301,6 +301,14 @@ struct dsa_switch {
>>  	 */
>>  	bool			configure_vlan_while_not_filtering;
>>  
>> +	/* If the switch driver always programs the CPU port as egress tagged
>> +	 * despite the VLAN configuration indicating otherwise, then setting
>> +	 * @untag_bridge_pvid will force the DSA receive path to pop the bridge's
>> +	 * default_pvid VLAN tagged frames to offer a consistent behavior
>> +	 * between a vlan_filtering=0 and vlan_filtering=1 bridge device.
>> +	 */
>> +	bool			untag_bridge_pvid;
>> +
>>  	/* In case vlan_filtering_is_global is set, the VLAN awareness state
>>  	 * should be retrieved from here and not from the per-port settings.
>>  	 */
>> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
>> index 5c18c0214aac..dec4ab59b7c4 100644
>> --- a/net/dsa/dsa.c
>> +++ b/net/dsa/dsa.c
>> @@ -225,6 +225,15 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>>  	skb->pkt_type = PACKET_HOST;
>>  	skb->protocol = eth_type_trans(skb, skb->dev);
>>  
>> +	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
>> +		nskb = dsa_untag_bridge_pvid(skb);
>> +		if (!nskb) {
>> +			kfree_skb(skb);
>> +			return 0;
>> +		}
>> +		skb = nskb;
>> +	}
>> +
>>  	s = this_cpu_ptr(p->stats64);
>>  	u64_stats_update_begin(&s->syncp);
>>  	s->rx_packets++;
> 
> I was thinking a lot simpler. Maybe you could just tail-call
> dsa_untag_bridge_pvid(skb) at the end of your .rcv function instead of
> putting it in the common receive path. I specifically wrote it to look
> at hdr->h_vlan_proto instead of skb->protocol, so it wouldn't depend on
> eth_type_trans().

Yes, good point, there is no point in promoting this to the main receive
path until we have a second user of that facility, v2 coming shortly.
-- 
Florian
