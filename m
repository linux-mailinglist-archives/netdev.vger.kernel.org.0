Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9833FC091
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 03:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239318AbhHaBtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 21:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbhHaBtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 21:49:35 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18792C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 18:48:41 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id ay33so17905101qkb.10
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 18:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JJmI5mK+jgyzTJYv4o1eDjhVgfvl672giklaPLLT7BY=;
        b=APQohBbfCnA63vQShLWj6mpIrNJBPrRyaiCNp8mxV0JzqN4szyEDafqrRKnK9cZiFC
         3Ue4CrL12s1hDDtjmujtlWC0jCYSOCBSfEPGW7rg3Vb3khsQILTwDKNNw55M/56DzsO2
         /13217oVKaIRsL+la3HDshO9YU50Jar4BDJmVfzXt27QH6/KVNqajui2O/NZgJglJbG7
         EeMW5NBOr0y9dJ8Su4GPMwTemw8rYOhj/z98wrvoh2D6l9ias2qwNTMvjM6hrPC56rWX
         woTIwZ6CCLKmOJ15K0aIM2kJJx8j3yATrEGrgTzp5arZ2549wZxh/LcAcmv06oEppBRF
         NuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JJmI5mK+jgyzTJYv4o1eDjhVgfvl672giklaPLLT7BY=;
        b=b7W4iWOEz1jEYVX/ZJhXf9OFkGzvL51dNq4OqAWHGttDbSgmwAtpE0lGLTdVkui63A
         /Zf6qGdmJQU4iNX1CIG43Ihz1vzi3iHoty0a+4zCPCHN1hWFRxzT014fBGaqC9KLP90d
         SUVq/y128JuNNdWZgEKsHisGzgucJt+y0RK6C/o+iZI1a8hGeIXg5O8pAYYd3OS04Aph
         XLfLNWXuSdK+UxgOthkD9PH2P/EpsKNX05aDn+D8YMxnsEqpLA980vRsJ7kwrce7C+fO
         hj6RPozz5jF+7wzPvI9A2gp1z9n2P2QlWPaRWAVYaHRgtCMrZQXpXED3zq3LZ0XoI/4p
         Nh3A==
X-Gm-Message-State: AOAM532rXCPzevELEvOF96eAsd6/BPEyL+vhONQM7I2JIvNCipl4ho5R
        EkrYl4dUk44zH6rtx0S7FEhxNQ==
X-Google-Smtp-Source: ABdhPJyjX41s6KOhkkleqfJ1O76Pgnmf0n5n0pPUkPQyajgKCy+HUq2QWJUp1q4i4Ava4ar/RUgZ/w==
X-Received: by 2002:a05:620a:220b:: with SMTP id m11mr671273qkh.320.1630374520282;
        Mon, 30 Aug 2021 18:48:40 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id a15sm9584444qtp.19.2021.08.30.18.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 18:48:39 -0700 (PDT)
Subject: Re: [PATCH net-next] net/sched: cls_flower: Add orig_ethtype
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        tom Herbert <tom@sipanda.io>,
        Felipe Magno de Almeida <felipe@expertise.dev>,
        Pedro Tammela <pctammela@mojatatu.com>
References: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b05f2736-fa76-4071-3d52-92ac765ca405@mojatatu.com>
Date:   Mon, 30 Aug 2021 21:48:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-30 4:08 a.m., Boris Sukholitko wrote:
> The following flower filter fails to match packets:
> 
> tc filter add dev eth0 ingress protocol 0x8864 flower \
>      action simple sdata hi64
> 
> The protocol 0x8864 (ETH_P_PPP_SES) is a tunnel protocol. As such, it is
> being dissected by __skb_flow_dissect and it's internal protocol is
> being set as key->basic.n_proto. IOW, the existence of ETH_P_PPP_SES
> tunnel is transparent to the callers of __skb_flow_dissect.
> 
> OTOH, in the filters above, cls_flower configures its key->basic.n_proto
> to the ETH_P_PPP_SES value configured by the user. Matching on this key
> fails because of __skb_flow_dissect "transparency" mentioned above.
> 
> Therefore there is no way currently to match on such packets using
> flower.
> 
> To fix the issue add new orig_ethtype key to the flower along with the
> necessary changes to the flow dissector etc.
> 
> To filter the ETH_P_PPP_SES packets the command becomes:
> 
> tc filter add dev eth0 ingress flower orig_ethtype 0x8864 \
>      action simple sdata hi64

Where's "protocol" on the above command line is. Probably a typo?

The main culprit is clearly the flow dissector parsing. I am not sure
if in general flowdisc to deal with deeper hierarchies/tunnels
without constantly adding a lot more hacks. Imagine if you had an
ethernet packet with double vlan tags and encapsulating a pppoe packet
(i.e 3 or more layers of ethernet) - that would be a nightmare.
IMO, your approach is adding yet another bandaid.

Would it make sense for the setting of the
skb_key.basic.n_proto  to be from tp->protocol for
your specific case in classify().

Which means your original setup:
  tc filter add dev eth0 ingress protocol 0x8864 flower \
      action simple sdata hi64

should continue to work if i am not mistaken. Vlans would
continue to be a speacial case.

I dont know what that would break though...

cheers,
jamal
