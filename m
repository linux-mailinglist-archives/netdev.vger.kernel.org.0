Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694CD265491
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgIJV6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgIJV6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 17:58:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43CDC061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 14:58:11 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d6so5581105pfn.9
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 14:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LOVmtayLZVDC0i4i/v+QCm0s/AOKCftxydTn4EE85Ic=;
        b=JPZG9xM2ax4GCSSi0cSDqBGa6zQbEdVviFSKWrAhBoPmYP1M8DJ4T/AIn6W54bKjFo
         X8Dk6CldRYjJ2OmEmPJsL0B3Ej7n4p/s0x7ENTdU/71fXFAMqoXrsx+b/6wEHnP1OLGL
         xiRSrXRZbngla/JCm4Pqst8cqwybSzpHedCCTIkh5QEIJdTMB0S8ZflMrMkGj/qrQ7a4
         +Blr43FD3rZ4o9ZZ6CZGoo2yysXZp0yFHzxxEWM22M9M8z4zzjUEXKhzi5KsQCSj0gac
         fa5Fhv4gAckJr6Oa36cAlBvpZnTqN7Q4iCnqBltogsgTU7wIA8qRqa2js5R3jb7XNg4F
         7Big==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOVmtayLZVDC0i4i/v+QCm0s/AOKCftxydTn4EE85Ic=;
        b=cgn+AyLUDloWCZcZ2LchbrF31y3a/Oo9HbFvyrL0seoPFYhuQZ4ax3Flys0xaiCCR+
         aJiFIgev065yfjpA19EVgThZO23MPFybvAow5qMMnivH/gq0t+m0zD7X8XHkP3jo4wGi
         8NhVzUficje5FXIQbRDNwLdOAKN0ZLzC4wYDG8RN/eDWft5P6Yg0YtTkReHtvl/8/6FY
         AZKUE3vUMs+txZndjeC4GNkbvyZgAVUa7YWj15uAy2k8GWqVkAszBQsaDo4qRNqFz7nv
         3b9PDHd0eHKleDReW1trepWsn1580qE8RKfQYTLX14b8+uiMnumErXDmDlATFNOOM4YP
         rskA==
X-Gm-Message-State: AOAM530Kebq+HPiYM3DWoPVdTkU2GHJDMD+l9nHow2RzKnIX9UmRLiS0
        SEi49xc+FV4afQj2zJDBxxwLzqc+4+I=
X-Google-Smtp-Source: ABdhPJzvVaHfj1P9EDREOu38USS9I9dBkoZH/KqdYWFTG47oseNaroIgTqHXco3JxekVAtC30uEuww==
X-Received: by 2002:a62:1b15:0:b029:13c:e701:5113 with SMTP id b21-20020a621b150000b029013ce7015113mr7361707pfb.3.1599775090851;
        Thu, 10 Sep 2020 14:58:10 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m20sm60323pfa.115.2020.09.10.14.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 14:58:10 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
From:   Florian Fainelli <f.fainelli@gmail.com>
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
 <5edf3aa2-c417-e708-b259-7235de7bc8d2@gmail.com>
Message-ID: <7e45b733-de6a-67c8-2e28-30a5ba84f544@gmail.com>
Date:   Thu, 10 Sep 2020 14:58:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <5edf3aa2-c417-e708-b259-7235de7bc8d2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 11:34 AM, Florian Fainelli wrote:
> 
> 
> On 9/9/2020 10:53 AM, Vladimir Oltean wrote:
>> On Wed, Sep 09, 2020 at 10:22:42AM -0700, Florian Fainelli wrote:
>>> How do you make sure that the CPU port sees the frame untagged which 
>>> would
>>> be necessary for a VLAN-unaware bridge? Do you have a special remapping
>>> rule?
>>
>> No, I don't have any remapping rules that would be relevant here.
>> Why would the frames need to be necessarily untagged for a VLAN-unaware
>> bridge, why is it a problem if they aren't?
>>
>> bool br_allowed_ingress(const struct net_bridge *br,
>>             struct net_bridge_vlan_group *vg, struct sk_buff *skb,
>>             u16 *vid, u8 *state)
>> {
>>     /* If VLAN filtering is disabled on the bridge, all packets are
>>      * permitted.
>>      */
>>     if (!br_opt_get(br, BROPT_VLAN_ENABLED)) {
>>         BR_INPUT_SKB_CB(skb)->vlan_filtered = false;
>>         return true;
>>     }
>>
>>     return __allowed_ingress(br, vg, skb, vid, state);
>> }
>>
>> If I have a VLAN on a bridged switch port where the bridge is not
>> filtering, I have an 8021q upper of the bridge with that VLAN ID.
> 
> Yes that is the key right there, you need an 8021q upper to pop the VLAN 
> ID or push it, that is another thing that users need to be aware of 
> which is a bit awkward, most expect things to just work. Maybe we should 
> just refuse to have bridge devices that are not VLAN-aware, because this 
> is just too cumbersome to deal with.

With the drivers that you currently maintain and with the CPU port being 
always tagged in the VLANs added to the user-facing ports, when you are 
using a non-VLAN aware bridge, do you systematically add an br0.1 upper 
802.1Q device to pop/push the VLAN tag?

I am about ready to submit the changes we discussed to b53, but I am 
still a bit uncomfortable with this part of the change because it will 
make the CPU port follow the untagged attribute of an user-facing port.

@@ -1444,7 +1427,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
                         untagged = true;

                 vl->members |= BIT(port);
-               if (untagged && !dsa_is_cpu_port(ds, port))
+               if (untagged)
                         vl->untag |= BIT(port);
                 else
                         vl->untag &= ~BIT(port);
@@ -1482,7 +1465,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
                 if (pvid == vid)
                         pvid = b53_default_pvid(dev);

-               if (untagged && !dsa_is_cpu_port(ds, port))
+               if (untagged)
                         vl->untag &= ~(BIT(port));

-- 
Florian
