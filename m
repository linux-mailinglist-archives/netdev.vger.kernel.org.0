Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E127224E2C
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 23:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgGRVxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 17:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgGRVxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 17:53:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197D8C0619D2;
        Sat, 18 Jul 2020 14:53:31 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a9so2577559pjd.3;
        Sat, 18 Jul 2020 14:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pm1nXXX8xzFN8jjQn8BinHIA9aAYvACgBRFTmwZh3S8=;
        b=Pt3Dh+xbbHW054Bnch/xs0qXErgQhwS4MrmiC7JwCbdkKaUhFO/O0gZQls7CC53O2h
         +002UG455jt8LiSCNoUYkfpT55Ts6uTCm4Y/fe+Zn3ooe7ZFAb9GNmEL22qfrQZgi14X
         Q/OIsXthF5yQtTFrg7JO+s2LUsTyRA1F3h/pJPsBxtoQBL7EoDlUQj29rqURpygDXm3c
         0QGODXpgYjioa8t2nJ4nlFXAkXHZF4YGVS81m1TzPGrwG+afVnLC4dfxCxktw+rlmU93
         ZMbt8J11aF60DRGIyACYleELtXQfjV3ndd9P23C0j5PbQzuyApnEQWY0DhWQ85SLh8i8
         jLJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pm1nXXX8xzFN8jjQn8BinHIA9aAYvACgBRFTmwZh3S8=;
        b=R48Ms+AI7/wBMx+HoObVLN0Boxk7FznW6wsAly7E9qA4kLEEASx7IGYM1yWmJOC9SX
         Cvp7+IkNrK26cCH4QN2c7ChRd9Ksy86W4oYMFFPKNzdskeH6UOdgTp8B6ZqavWhI7xMu
         YGDLcT0DZ7ofdMOsknIxUiLLbLd+wWYu/TktXI6XnRqyhdxPiK2aCat5xDgJdwuVxSZc
         1kJZy7FMSVZZvF0SuqjOoL/+CnH1eFqbbqGUCwag1najHTFsFu4eePf3I6vqO99vMC/1
         ZTBUWhCKkPKKV0cjl3HYtPtYBBJpC/9Xxmyca8Pvqm2S0aHKo7r9dOWwijshS+JT6pGs
         HG+A==
X-Gm-Message-State: AOAM532m8ZeUx2qXXFRml+d/pq7mji/IUfJtXQwbLrQnO3hNfcJPz2G9
        nYZZmkSZLNosgMmpTClUVg4159f4
X-Google-Smtp-Source: ABdhPJzcMKSHZPIYhgiZ53YYyWBk1E1EoXdhxssJ7lx7i2ut4yx49QhjgZ4OZAjWoH1sJBvEOmv+4w==
X-Received: by 2002:a17:902:fe90:: with SMTP id x16mr13094212plm.307.1595109210109;
        Sat, 18 Jul 2020 14:53:30 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w18sm10209942pgj.31.2020.07.18.14.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 14:53:29 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: Call into DSA netdevice_ops wrappers
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
 <20200718030533.171556-4-f.fainelli@gmail.com>
 <20200718211805.3yyckq23udacz4sa@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d3a11ef5-3e4e-0c4a-790b-63da94a1545c@gmail.com>
Date:   Sat, 18 Jul 2020 14:53:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718211805.3yyckq23udacz4sa@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2020 2:18 PM, Vladimir Oltean wrote:
> On Fri, Jul 17, 2020 at 08:05:32PM -0700, Florian Fainelli wrote:
>> Make the core net_device code call into our ndo_do_ioctl() and
>> ndo_get_phys_port_name() functions via the wrappers defined previously
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  net/core/dev.c       | 5 +++++
>>  net/core/dev_ioctl.c | 5 +++++
>>  2 files changed, 10 insertions(+)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 062a00fdca9b..19f1abc26fcd 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -98,6 +98,7 @@
>>  #include <net/busy_poll.h>
>>  #include <linux/rtnetlink.h>
>>  #include <linux/stat.h>
>> +#include <net/dsa.h>
>>  #include <net/dst.h>
>>  #include <net/dst_metadata.h>
>>  #include <net/pkt_sched.h>
>> @@ -8602,6 +8603,10 @@ int dev_get_phys_port_name(struct net_device *dev,
>>  	const struct net_device_ops *ops = dev->netdev_ops;
>>  	int err;
>>  
>> +	err  = dsa_ndo_get_phys_port_name(dev, name, len);
> 
> Stupid question, but why must these be calls to an inline function whose
> name is derived through macro concatenation and hardcoded for 2
> arguments, then pass through an additional function pointer found in a
> DSA-specific lookup table, and why cannot DSA instead simply export
> these 2 symbols (with a static inline EOPNOTSUPP fallback), and simply
> provide the implementation inside those?

The macros could easily be changed to take a single argument list and
play tricks with arguments ordering etc. so I would decouple them from
the choice of using them.

If we have the core network stack reference DSA as a module then we
force DSA to be either built-in or not, which is not very practical,
people would still want a modular choice to be possible. The static
inline only wraps indirect function pointer calls using definitions
available at build time and actual function pointer substitution at run
time, so we avoid that problem entirely that way.
-- 
Florian
