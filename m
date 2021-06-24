Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25B33B3790
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 22:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhFXUKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 16:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhFXUKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 16:10:17 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B288C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 13:07:58 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id s19so9801061ioc.3
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 13:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qz6S88JwspsIJOU6srz7SjZZfMOghWPodV7th4gTqJI=;
        b=DBe5RqaWh60s4URJNHa/A9dkeUzH+4ew9K5BnJsTe0X5FMouEsLt0FSHrWnQBWKcis
         J4Qh1u4Ru9w6VRWma4Kjx/5rHRh4RKQGMjx/L3VU8yKSab0GTwG9eo6H0Gd1Rcyex7YG
         tcnl47DhQM11j+BXAX/ehshk9JcJgytDlReUHiD6YsTWn9Vtq8aCIaXrJ7RKevC9EK73
         MOFMNqaGGZT4IS6AFf4GI5JbirBtvEupPTTXayexssstN28rV3nKNdnbrHJja83y4+GT
         BlNkHLNh2OycJNytkhO2riQj/Zg+AzTEs4/CKeq5DmlQkysvjEaTttGfalLKfHJTdWC/
         iBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qz6S88JwspsIJOU6srz7SjZZfMOghWPodV7th4gTqJI=;
        b=B7RoEA61ee9MQ/Nzvi/rgHhGcDvSC/fv+a/NbGOzl/nVqN8x9HNFFjbfgY79WwKk+/
         9veuBlDIBSSG7Mp6ljGNJOaab2QgLQwbv+6zdk3RZrWu3aidnlIZq7ccRWUFeRYn2z+6
         d5RUL0b5w22q9CCvqHqSQR5HXF6qeRmdyX8q3qZW2c6pi0ykAt12K0PSL3z83qZZBzB2
         df8lVtWCKsSLgusf7Dgh/YduGOduEkCtC17e7NEmbMCX7mPLbRYmZzM4TuYARshlKfQt
         57ERqAIfrvAgjxyqaqeXOJE00Tne5jNOqs6sZgOLIS7NGsSQR1bNfHCGty17dfGm7xOh
         eP/Q==
X-Gm-Message-State: AOAM532lLlPZuhRwRJqbLChj9DbcDp6/IfJEMz6ca2KQJfq1HuIzPggG
        hhFNPFsGttJbINxqwd50MwrNieEYZK1w0Q==
X-Google-Smtp-Source: ABdhPJyieK5EKt5gwlKUEbGLKNxa2pw84fYucqWXtwHbZqsf2/1Z5JHipcN4YExhEj4U7yoGn9A4HQ==
X-Received: by 2002:a05:6638:3d3:: with SMTP id r19mr6302403jaq.78.1624565278051;
        Thu, 24 Jun 2021 13:07:58 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-24-174-92-115-23.dsl.bell.ca. [174.92.115.23])
        by smtp.googlemail.com with ESMTPSA id c3sm2293979ils.54.2021.06.24.13.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 13:07:57 -0700 (PDT)
Subject: Re: [PATCH net-next] net/sched: cls_flower: fix resetting of ether
 proto mask
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiri@resnulli.us, idosch@idosch.org, ilya.lifshits@broadcom.com
References: <20210617161435.8853-1-vadym.kochan@plvision.eu>
 <20210617164155.li3fct6ad45a6j7h@skbuf>
 <20210617195102.h3bg6khvaogc2vwh@skbuf> <20210621083037.GA9665@builder>
 <f18e6fee-8724-b246-adf9-53cc47f9520b@mojatatu.com>
 <20210622131314.GA14973@builder>
 <451abd22-4c81-2821-e8d4-4f305697890c@mojatatu.com>
 <20210622152218.GA1608@noodle>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7d0367ab-22e4-522a-11ef-8fb376672b54@mojatatu.com>
Date:   Thu, 24 Jun 2021 16:07:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622152218.GA1608@noodle>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Boris,

Apologies for the latency.

On 2021-06-22 11:22 a.m., Boris Sukholitko wrote:
> On Tue, Jun 22, 2021 at 10:17:45AM -0400, Jamal Hadi Salim wrote:

[..]

>>> Do you by any chance have some naming suggestion? Does
>>> vlan_pure_ethtype sound ok? What about vlan_{orig, pkt, raw, hdr}_ethtype?
>>>
>>
>> The distinction is in getting the inner vs outer proto, correct?
> 
> Yes. To be more explicit: the outer protocol (ETH_P_PPP_SES in this case) is
> invisible to the user due to __skb_flow_dissect drilling down
> to find the inner protocol.

Ok, seems this is going to be problematic for flower for more than
just ETH_P_PPP_SES, no? i.e anything that has an inner proto.
IIUC, basically what you end up seeing in fl_classify() is
the PPP protocol that is extracted by the dissector?

> Yes. Talking specifically about flower's fl_classify and the following
> rule (0x8864 is ETH_P_PPP_SES):
> 
> tc filter add dev eth0 ingress protocol 0x8864 flower action simple sdata hi6
> 
> skb_flow_dissect sets skb_key.basic.n_proto to the inner protocol
> contained inside the PPP tunnel. fl_mask_lookup will fail finding the
> outer protocol configured by the user.
> 

For vlans it seems that flower tries to "rectify" the situation
with skb_protocol() (that why i pointed to that function) - but the
situation in this case cant be rectified inside fl_classify().

Just quick glance of the dissector code though seems to indicate
skb->protocol is untouched, no? i.e if you have a simple pppoe with
ppp protocol == ipv4, skb->protocol should still be 0x8864 on it
(even when skb_key.basic.n_proto has ipv4).


> It looks to me that there is no way to match on outer protocol such as
> ETH_P_PPP_SES at least in flower. Although other filters (e.g. matchall)
> will work, VLAN packets containing ETH_P_PPP_SES will require flower and
> still will not match.

This is a consequence of flower using flow_dissector and flow
dissector loosing information..

>> This is because when vlan offloading was merged it skewed
>> things a little and we had to live with that.
>>
>> Flower is unique in its use of the dissector which other classifiers
>> dont. Is this resolvable by having the fix in the  dissector?
> 
> Yes, the solution suggested by Vladimir and elaborated by myself
> involves extending the dissector to keep the outer protocol and having
> flower eth_type match on it. This is the "plan" being quoted above.
> 
 >
> I believe this is the solution for the non-vlan tagged traffic. For the
> vlans we already have [c]vlan_ethtype keys taken. Therefore we'll need
> new [c]vlan_outer_ethtype keys.
> 

I think that would work in the short term but what happens when you
have vlan in vlan carrying pppoe? i.e how much max nesting can you
assume and what would you call these fields?

cheers,
jamal

