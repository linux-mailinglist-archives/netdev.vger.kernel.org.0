Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C97927F692
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731708AbgJAARC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729980AbgJAARC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 20:17:02 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4F5C0613D0;
        Wed, 30 Sep 2020 17:17:01 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u24so2427845pgi.1;
        Wed, 30 Sep 2020 17:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WqcMmMBNNOIzGt7x1JA06HdtMKTkJlzsGJR/X1W+/9A=;
        b=qkr/7oaI1LyoLrsxZnebU4g615j4NsvO+jwltcKIUFvNknV8nhhrwqu3kyTq6T0D1T
         BKBhfX3DY526jjZsKjQPZa4MtzsFDZ7pv32AvzPs375CDFm19DNSiw7+ez3afCK23OS+
         zIkOxn4kF1TCKFO3eyeWv6w5239jNLG4yrdstgVY+R/C6CZISRpi8grXb0ntwPQMWhO6
         3yCKu3afIB90kK9LI0+JoFTYlAGRBNSooB2YM/TgHeWThTKygDbMB4hJEZB9vgUkxEmP
         WlGktQ2iU8jRTeZUWv5tJG4f7SkIWoHhXu29DMH4WzjRj5X53TswTIphzhFt58Z2t0Zi
         5u0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WqcMmMBNNOIzGt7x1JA06HdtMKTkJlzsGJR/X1W+/9A=;
        b=eJ+tr+u/ZAxNsgSJTK0VEUibSMdJ02SzUfPi1a1+aPBjq8lzaPfKxGGKyouOG9r08p
         gpvqcOFDLz/gY+wXUKN4qaLovjnAYM3xtw7KWeYwJKyMxxAmubeSfFGpCovp0uNW8M/W
         9nfkTterdqz7B1EA9KEPS/17aLiZNJl428qrnX+eNvNSwEWonF3TRonA/VS0V+r4i7J4
         a7rJaLZ1J+mX0cq94C6GVCdFH2NDDSOJCQd3imA4cjS8y0Umu4S0U2IEOpuny3JQ+PR/
         e5LzfcL2JkOqVBWHhrBl8L0l0kYPxb6ws3d+mnvXgJs/XojACdSfqyDeWdXNy8C6Wxq5
         3dSg==
X-Gm-Message-State: AOAM53157qjnqvV+pp2fV9C7pAtlpksqO6Q0iwGJBfUzdJhq2erpq4cO
        a2fC2nKkWGbta/q0H7B/LJGWRwqfT0qVIw==
X-Google-Smtp-Source: ABdhPJwX1+0gsnkqUhoqdO6SrJH9Lb9QfpxuuBi40yDN94OHgYw2Ab0XXHLflVFPUaPhqcN0f9Hc0w==
X-Received: by 2002:a17:902:9f8f:b029:d3:8e2a:192e with SMTP id g15-20020a1709029f8fb02900d38e2a192emr296926plq.20.1601511421026;
        Wed, 30 Sep 2020 17:17:01 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s19sm4171253pfc.69.2020.09.30.17.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 17:17:00 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: Support bridge 802.1Q while untagging
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200930203103.225677-1-f.fainelli@gmail.com>
 <20200930204358.574xxijrrciiwh6h@skbuf>
 <89404248-f8ea-b5f5-12c5-a19392397222@gmail.com>
Message-ID: <30265d9b-fb50-16a7-fb08-1199762a14b3@gmail.com>
Date:   Wed, 30 Sep 2020 17:16:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <89404248-f8ea-b5f5-12c5-a19392397222@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/2020 4:29 PM, Florian Fainelli wrote:
> 
> 
> On 9/30/2020 1:43 PM, Vladimir Oltean wrote:
>> On Wed, Sep 30, 2020 at 01:31:03PM -0700, Florian Fainelli wrote:
>>> While we are it, call __vlan_find_dev_deep_rcu() which makes use the
>>> VLAN group array which is faster.
>>
>> Not just "while at it", but I do wonder whether it isn't, in fact,
>> called "deep" for a reason:
>>
>>         /*
>>          * Lower devices of master uppers (bonding, team) do not have
>>          * grp assigned to themselves. Grp is assigned to upper device
>>          * instead.
>>          */
>>
>> I haven't tested this, but I wonder if you could actually call
>> __vlan_find_dev_deep_rcu() on the switch port interface and it would
>> cover both this and the bridge having an 8021q upper automatically?
> 
> Let me give this a try.

We hit the if (vlan_info) branch and we do not recurse through the 
upper_dev because of that.

I still need to send a v2 to remove the now unused 'iter' variable and 
fix up the bridge iproute2 command (there is no vlan_filtering=0 it is 
vlan_filtering 0).
-- 
Florian
