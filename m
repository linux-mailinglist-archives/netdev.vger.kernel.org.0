Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDA4263616
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgIISeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgIISeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:34:06 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91421C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:34:05 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u3so1778905pjr.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HWL1mTQCjeNQIcmeCOpqWQ1gbZVuXnBNh7xBJbVhQjg=;
        b=LL/Q2edFrUDa6+IvCE5E4WqArGstZfK4RXorr7YfooIQHG9e4FNumPoLuLe1ZAbIJM
         P/3ZsBxml1IX8wxXvYDIe8jmBIwGN9uz8Lrkh1w6atQWcRFakCC4jrwwQVjCOHy97Q8x
         DaH5EnhkpVd//AWfL9WILDX2mtaXZli6J3AJVZdiFgsTU3R7P3DFOPOXZbYweTIA0PRA
         1bgvQtBGsJeQn7z9rmuzCQyVAn9gnyP7chZB60G3c0iW25L53CoJQXyKnMMsg38+PdOU
         aENZN5Xddyx1ls6irj6iohlRahGYRCaDJ1F7RYe+bdNJKv2SgXZlMEE1b2lmWGAnNfL+
         TCbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HWL1mTQCjeNQIcmeCOpqWQ1gbZVuXnBNh7xBJbVhQjg=;
        b=qjUM4elosp1XcFg/VcJbyTYI1gxkjNZagBnustHEpm9VPc330q/kDpO3N3qF+JgiI0
         Zdce5ZODS+m5fQ/Tlkb61k/l1UxlyYJ0IB+7M4ecLxfK+nClI+yl+FHws0rgRRMJsst0
         wuD2MGv+0cnpG14DBHQgFvjaOjvb2ZYdeuRUrhWBOUnO6GXbu5mzoA0vnwNPWMdVvlrg
         K4qqvbjw8JVy12G73qt9hbyNnV7U5vIrlm+fV++Ab/QhBC3XHk/ZwXmV2w8RlySJqOYZ
         EjngMrNncrt5qHb1b7yb9x4TbJngIAbtd2lqfaB3bp9bm6mAYHAF/HWfGrBjdd/YcXHD
         xA5g==
X-Gm-Message-State: AOAM530Lc0KeacZbcAfnCuFdcKss61kqUo85USzchRmpm7+cSYiWCMq0
        RUs1Jv7QIGVAOiwZIC8VuVSBGZR0spU=
X-Google-Smtp-Source: ABdhPJzO3iZ4iiwBH4CUO0Eejv/cmd+ChlPI92WxuYPe6kM3uNT3nBqhIqMdlj8hu4FTCprIvGxexQ==
X-Received: by 2002:a17:90b:3cb:: with SMTP id go11mr1746944pjb.152.1599676444391;
        Wed, 09 Sep 2020 11:34:04 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm3069328pgi.69.2020.09.09.11.34.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 11:34:03 -0700 (PDT)
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
 <a5e6cb01-88d0-a479-3262-b53dec0682cd@gmail.com>
 <f0217ae5-7897-17e2-a807-fc0ba0246c74@gmail.com>
 <20200909163105.nynkw5jvwqapzx2z@skbuf>
 <11268219-286d-7daf-9f4e-50bdc6466469@gmail.com>
 <20200909175325.bshts3hl537xtz2q@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <5edf3aa2-c417-e708-b259-7235de7bc8d2@gmail.com>
Date:   Wed, 9 Sep 2020 11:34:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200909175325.bshts3hl537xtz2q@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 10:53 AM, Vladimir Oltean wrote:
> On Wed, Sep 09, 2020 at 10:22:42AM -0700, Florian Fainelli wrote:
>> How do you make sure that the CPU port sees the frame untagged which would
>> be necessary for a VLAN-unaware bridge? Do you have a special remapping
>> rule?
> 
> No, I don't have any remapping rules that would be relevant here.
> Why would the frames need to be necessarily untagged for a VLAN-unaware
> bridge, why is it a problem if they aren't?
> 
> bool br_allowed_ingress(const struct net_bridge *br,
> 			struct net_bridge_vlan_group *vg, struct sk_buff *skb,
> 			u16 *vid, u8 *state)
> {
> 	/* If VLAN filtering is disabled on the bridge, all packets are
> 	 * permitted.
> 	 */
> 	if (!br_opt_get(br, BROPT_VLAN_ENABLED)) {
> 		BR_INPUT_SKB_CB(skb)->vlan_filtered = false;
> 		return true;
> 	}
> 
> 	return __allowed_ingress(br, vg, skb, vid, state);
> }
> 
> If I have a VLAN on a bridged switch port where the bridge is not
> filtering, I have an 8021q upper of the bridge with that VLAN ID.

Yes that is the key right there, you need an 8021q upper to pop the VLAN 
ID or push it, that is another thing that users need to be aware of 
which is a bit awkward, most expect things to just work. Maybe we should 
just refuse to have bridge devices that are not VLAN-aware, because this 
is just too cumbersome to deal with.

> 
>> Initially the concern I had was with the use case described above which was
>> a 802.1Q separation, but in hindsight MAC address learning would result in
>> the frames going to the appropriate ports/VLANs anyway.
> 
> If by "separation" you mean "limiting the forwarding domain", the switch
> keeps the same VLAN associated with the frame internally, regardless of
> whether it's egress-tagged or not.

True, so I am not sure what I was thinking back then.

> 
>>>
>>>> Tangentially, maybe we should finally add support for programming the CPU
>>>> port's VLAN membership independently from the other ports.
>>>
>>> How?
>>
>> Something like this:
>>
>> https://lore.kernel.org/lkml/20180625091713.GA13442@apalos/T/
> 
> I need to take some time to understand what's going on there.
> 

-- 
Florian
