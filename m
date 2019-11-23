Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E35E107F8D
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 17:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfKWQ62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 11:58:28 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46462 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKWQ62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 11:58:28 -0500
Received: by mail-lf1-f65.google.com with SMTP id a17so7813328lfi.13
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 08:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YSheOqV8iD7jxySZ325Tj32xDvn2ymFuhmX2zrp3R38=;
        b=FNJUXy7YAwPw0tggQAcI0TVyRXBrWT/zRay/BS7Etjjbpa8ERh5oOzY9NQeIXt0DSA
         04z89UjIDido70Z5dYtdJNt1AlzH9ethfXEmOUKnlt36yXHhtjIZMItGYRkAw+UgWEfL
         pUfYc4XkIKe3/mlFrfhZEHmnW08RpsdThb0ZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YSheOqV8iD7jxySZ325Tj32xDvn2ymFuhmX2zrp3R38=;
        b=ciOPsDqi/pwPzmpKfYYPbDtNYWDEmVbsEOY+XN5rnLebscDbCwLkw7h7dhmmm7etFD
         NZbJK1tqltJ06d1naDvAlQyQGBOOOC1rbSczS6PzNTdUJIBwDJAXNrD2/+NP2igFjWs/
         oJyhfG7M2b9YmM2dgESNxVQW5VOWMOGv8ss6Vszi+xsupsYDqjE/KkL7wC+mfTACM9Nu
         oBzufQPUcjaf6teXCoTCDZJ8aRTVdwTvMpss2Kw4vUGFlM+f2b6BQXoz6GIUqchR5oMx
         MwFGGfal8jtcvJ2Iy17f+QFMQGeqw1poM7fmQgH0+rML9mkcroEtPltW0m5kSfFxvlHe
         wlIQ==
X-Gm-Message-State: APjAAAXwerMQho/68CftADF++xgC4rtDtxEGn+xh1qhte66nvpEvqzew
        iR/pm5UfNWkTTTR5aJ3xvU3rgA==
X-Google-Smtp-Source: APXvYqyN8oC6LMzVvtUeTHzNX4pEywNNQHPjBd59813r4CJj+fdz6Q53+LzfvhOA+8PbMPRqou3KVg==
X-Received: by 2002:a19:6e06:: with SMTP id j6mr15701392lfc.6.1574528305666;
        Sat, 23 Nov 2019 08:58:25 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x12sm925522lfq.52.2019.11.23.08.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 08:58:24 -0800 (PST)
Subject: Re: [PATCH net-next] net: bridge: add STP stat counters
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com
References: <20191122230742.1515752-1-vivien.didelot@gmail.com>
 <20191122152137.33f9f9d7@hermes.lan>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <dbedcfa0-4ece-2690-d93f-7601b0755b95@cumulusnetworks.com>
Date:   Sat, 23 Nov 2019 18:58:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191122152137.33f9f9d7@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2019 01:21, Stephen Hemminger wrote:
> On Fri, 22 Nov 2019 18:07:42 -0500
> Vivien Didelot <vivien.didelot@gmail.com> wrote:
> 
>> This adds rx_bpdu, tx_bpdu, rx_tcn, tx_tcn, transition_blk,
>> transition_fwd stat counters to the bridge ports, along with sysfs
>> statistics nodes under a "statistics" directory of the "brport" entry,
>> providing useful information for STP, for example:
>>
>>     # cat /sys/class/net/lan0/brport/statistics/tx_bpdu
>>     26
>>     # cat /sys/class/net/lan5/brport/statistics/transition_fwd
>>     3
>>
>> At the same time, make BRPORT_ATTR define a non-const attribute as
>> this is required by the attribute group structure.
>>
>> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> 
> Please don't add more sysfs stuff. put it in netlink.
> 

+1

You should be able to use the bridge xstats netlink infra to expose these. We already
support master and slave stats (e.g. vlan and mcast stats are retrieved through it).

>> ---
>>  net/bridge/br_private.h  |  8 ++++++++
>>  net/bridge/br_stp.c      |  8 ++++++++
>>  net/bridge/br_stp_bpdu.c |  4 ++++
>>  net/bridge/br_sysfs_if.c | 35 ++++++++++++++++++++++++++++++++++-
>>  4 files changed, 54 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>> index 36b0367ca1e0..360d8030e3b2 100644
>> --- a/net/bridge/br_private.h
>> +++ b/net/bridge/br_private.h
>> @@ -283,6 +283,14 @@ struct net_bridge_port {
>>  #endif
>>  	u16				group_fwd_mask;
>>  	u16				backup_redirected_cnt;
>> +
>> +	/* Statistics */
>> +	atomic_long_t			rx_bpdu;
>> +	atomic_long_t			tx_bpdu;
>> +	atomic_long_t			rx_tcn;
>> +	atomic_long_t			tx_tcn;
>> +	atomic_long_t			transition_blk;
>> +	atomic_long_t			transition_fwd;
>>  };
>>  
> 
> There is no these need to be atomic.
> Atomic is expensive.
> 
