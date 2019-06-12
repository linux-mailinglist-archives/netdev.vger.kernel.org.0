Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D8C41C1B
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 08:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730860AbfFLGTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 02:19:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45680 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfFLGTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 02:19:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id w34so8317603pga.12
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 23:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8fDg97cABUEsmmHCw4XgwA/mqDJ2jPlB+O0dIORq5TE=;
        b=ls7SdbodKDxCL2qemsLR5JgLhCvVR30n2dd4YrDKbFYnckF1XQGmIu+LL/XWlw3BOa
         BYhiiWs6i8+GHdrR2+VUlVulrxRKTgAsw/jhwJEl0oEAlcIQl6U7ndkmyEeit4+3Xiel
         1bcZt9mgoxBwJCef5p98eKmjIjD+CarLnXFa0xa1BqOM18VXEwCkeG3LsKGvI9NGKKv3
         tSyint4V+QMw3/D6K1RGSqL4At5c4cFceORTXZVglVCEE4L+1/TX5ISZlVh/2emThZsW
         Bi84rQWAzCLS9V39+ax2Z1CjLw0VwYkRHVUqo6sY4Aawiwsc8zQpjwDIVv7FRdiYpbS1
         PH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8fDg97cABUEsmmHCw4XgwA/mqDJ2jPlB+O0dIORq5TE=;
        b=GBxIrLdXEapGGqrIjwrnKJAITaPP38+HticlN4BJJZ3V5c7PHoczDiNO8TMtCmE803
         IxEj/lg7K5GSvB4D06ArT3rh0lXlhI/wMcPRSlZPvbjadGOT8AlfnP4rB+FxaO2FVwn1
         4fHDfyy6lS694Qlu6sLosGI2rDqSWuWfJiYxD4fiPI4oHDDyvfMTugASwmCK75DB0P2u
         FVZ5y32NxssVpQ3pYQyhUs/CCxTdtbUnv0h7h9jId1gK4baVvAui9oelAcdXq+XRcUYl
         qzBzk7l+K9tEGw5HNlR81lxkoD1kHlt3rt4FPRQlw1f9X5uDHSQIml/tX/QAV07J8dG6
         4i6w==
X-Gm-Message-State: APjAAAWi4zRfFlAnFtFSd0PEDyUq8sdIr+BCSioMPUVOhOhjTi4lB8mD
        2CbvHV6Yldtxzoiy84b61Pc=
X-Google-Smtp-Source: APXvYqyzsngpQUq2Dx1mkQjVLvEwD/4ynXo3s1cAig9OM70gx/8YIziujbFLO1JxICcA4mEClA5L/A==
X-Received: by 2002:a62:2ccc:: with SMTP id s195mr21667329pfs.256.1560320391950;
        Tue, 11 Jun 2019 23:19:51 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id 137sm21145082pfz.116.2019.06.11.23.19.50
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 23:19:51 -0700 (PDT)
Subject: Re: [PATCH RESEND net] net: handle 802.1P vlan 0 packets properly
To:     "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>,
        "Christian Benvenuti (benve)" <benve@cisco.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "govind.varadar@gmail.com" <govind.varadar@gmail.com>,
        "ssuryaextr@gmail.com" <ssuryaextr@gmail.com>
References: <20190610183122.4521-1-gvaradar@cisco.com>
 <13332a7b-bd3d-e546-27d1-402ed8013f41@gmail.com>
 <06ef881af6480794610b5db215168bfc5000acf2.camel@cisco.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <7ee0a162-664e-bb6c-52b5-b1ce02911d78@gmail.com>
Date:   Wed, 12 Jun 2019 15:19:46 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <06ef881af6480794610b5db215168bfc5000acf2.camel@cisco.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/12 6:57, Govindarajulu Varadarajan (gvaradar) wrote:
> @On Tue, 2019-06-11 at 13:34 +0900, Toshiaki Makita wrote:
>> On 2019/06/11 3:31, Govindarajulu Varadarajan wrote:
>>> When stack receives pkt: [802.1P vlan 0][802.1AD vlan 100][IPv4],
>>> vlan_do_receive() returns false if it does not find vlan_dev. Later
>>> __netif_receive_skb_core() fails to find packet type handler for
>>> skb->protocol 801.1AD and drops the packet.
>>>
>>> 801.1P header with vlan id 0 should be handled as untagged packets.
>>> This patch fixes it by checking if vlan_id is 0 and processes next vlan
>>> header.
>>>
>>> Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
>>> ---
>>>    net/8021q/vlan_core.c | 24 +++++++++++++++++++++---
>>>    1 file changed, 21 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
>>> index a313165e7a67..0cde54c02c3f 100644
>>> --- a/net/8021q/vlan_core.c
>>> +++ b/net/8021q/vlan_core.c
>>> @@ -9,14 +9,32 @@
>>>    bool vlan_do_receive(struct sk_buff **skbp)
>>>    {
>>>    	struct sk_buff *skb = *skbp;
>>> -	__be16 vlan_proto = skb->vlan_proto;
>>> -	u16 vlan_id = skb_vlan_tag_get_id(skb);
>>> +	__be16 vlan_proto;
>>> +	u16 vlan_id;
>>>    	struct net_device *vlan_dev;
>>>    	struct vlan_pcpu_stats *rx_stats;
>>>    
>>> +again:
>>> +	vlan_proto = skb->vlan_proto;	
>>> +	vlan_id = skb_vlan_tag_get_id(skb);
>>>    	vlan_dev = vlan_find_dev(skb->dev, vlan_proto, vlan_id);
>>> -	if (!vlan_dev)
>>> +	if (!vlan_dev) {
>>> +		/* Incase of 802.1P header with vlan id 0, continue if
>>> +		 * vlan_dev is not found.
>>> +		 */
>>> +		if (unlikely(!vlan_id)) {
>>> +			__vlan_hwaccel_clear_tag(skb);
>>
>> Looks like this changes existing behavior. Priority-tagged packets will be
>> untagged
>> before bridge, etc. I think priority-tagged packets should be forwarded as
>> priority-tagged
>> (iff bridge is not vlan-aware), not untagged.
> 
> Makes sense to me. If rx_handler is registered to the device, pkt should be sent
> untagged to rx_handler.
> 
> 
> I would like to get some clarification on few more cases before I change the
> code. In the setup:
> 
>                  br0
>                   |
>    vlan 100       |
>     |(802.1AD)    |
>     |             |
> +--------------------+
> |        eth0        |
> +--------------------+
> 
> Case 1: [802.1P vlan0] [IP]
> Current behaviour: pkt is sent to br0 with priority tag. i.e we should not remove
> the 802.1P tag.
> This patch: removes the 802.1P tag and br0 receives untagged packet. This is
> wrong.
> Expected behaviour: Should be same as current behaviour.
> 
> Case 2: [802.1AD vlan 100] [IP]
> Current behaviour: pkt is sent to vlan 100 device.
> This patch: same as current behaviour.
> Expected behaviour: same as current behaviour
> 
> Case 3: [802.1P vlan 0] [802.1AD vlan 100] [IP]
> Current behaviour: Pkt is sent to br0 rx_handler. This happens because
> vlan_do_receive() returns false (vlan 0 device is not present). Stack does not go
> through inner headers.
> This patch: pkt is sent to vlan 100 device. Because vlan_do_receive() strips vlan
> 0 header and finds vlan 100 device.
> Expected behaviour: ?
> IMO: Pkt should be sent to vlan 100 device because 802.1P should be treated as
> priority tag and not as vlan tagged pkt. Since vlan 100 device is present, it
> should be sent to vlan 100 device.

Maybe yes, maybe no. There is no standard about that. Your opinion is consistent
behavior between untagged and priority-tagged. OTOH, it changes existing behavior.
We basically try to keep existing behavior even if the behavior looks odd in some
way in order not to break existing users. So I would choose the other option, send
packets to br0.

> 
> Case 4: [802.1AD vlan 200] [802.1AD vlan 100] [IP]
> Current behaviour: Pkt is sent to br0 since vlan 200 device is not found.
> This patch: same as current behaviour.
> Expected behaviour: Same as current behaviour.
> 
> Is my understanding correct?

Agree except case 3.

Toshiaki Makita
