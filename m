Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA6AD809D
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732404AbfJOUBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:01:36 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44467 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfJOUBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 16:01:36 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so13139748pfn.11
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 13:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=HAWpeyEf4TgH2xMeDRMI9KLDaQnbmvcU1By9C9gf7p0=;
        b=ed3SX12xIavzSbmhTl27EmLicks8/BosT+8KUqnlEjbx0un8hZ+pIGUwM302PWgTCl
         LzT3P2q4gBT30SA3lJvbVTMo/6u8Ly7jSVf0uaKaL40s0YuttSFppxr93eebYsLNN/bT
         JXxcKxnE1S/SpMzxZRl6+X1QRGCVekcAL/rjoeljN1+3lxjTV6OPyHOrNILVxVqZQwd5
         3+pTExe1LWKsNNdnvZaNjOt0DUSWm1pyUhbSfxuGbFwNUNinEXVWE7AwkNsg5vSQityG
         8v7Wshg6kzYg6ZOa2wW0uG8p6n+OirE7DNJl3wm0iHbdJsPfwsfmLZCVAHD66tvVSWXh
         C46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HAWpeyEf4TgH2xMeDRMI9KLDaQnbmvcU1By9C9gf7p0=;
        b=f8Id+Lp63/R7BqfB5theNVqtDwUEYPSGIqRGahcwf7kunrlE+J9kr19DMD1hCAl18j
         Yq7Wm1J6Q1nqDp5ZcjMyONetdCy76AikAKtx14doCCwd9NeuIW8t+kXVdYAjMaLfkas+
         y6ZOmwaWyKblHoIGGdUAhwej4ivejLGwF2OwXNTygAEVCnxXNlm9ErzcFU7t1f+mUbFt
         LNTrvXcp5llges49qEg0Yl21N3APOGH7eUW/SlDB7hPj8UCTBLLahX2DLVO8aLMIncuP
         eEzLHe/t1gDmSaDASqdVNrqT2Z26aOvuAtMvJNoo+iUKr/090hdUY41g0KSd9T8zvU1w
         ucog==
X-Gm-Message-State: APjAAAXawnEmi68OE7bem4mWy3Ic1LSbm2+FH5WB4NXHJqKyW26m9G0s
        6p71QfX2Qv1roSiwSBsO4fA=
X-Google-Smtp-Source: APXvYqyxdCIrNX59CR7GFaK57Yflwo6RWRN4zBW28JxVt51bx+DaWqJGuwgdDxeHms43hyer4pz7qA==
X-Received: by 2002:a63:e20c:: with SMTP id q12mr22454564pgh.275.1571169694943;
        Tue, 15 Oct 2019 13:01:34 -0700 (PDT)
Received: from [192.168.0.16] (97-115-119-26.ptld.qwest.net. [97.115.119.26])
        by smtp.gmail.com with ESMTPSA id x9sm149511pje.27.2019.10.15.13.01.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 13:01:34 -0700 (PDT)
Subject: Re: [PATCH net-next v3 00/10] optimize openvswitch flow looking up
To:     xiangxia.m.yue@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org
References: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <8c2d501a-f943-5ee1-e430-0c36d77a33b5@gmail.com>
Date:   Tue, 15 Oct 2019 13:01:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/11/2019 7:00 AM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This series patch optimize openvswitch for performance or simplify
> codes.
>
> Patch 1, 2, 4: Port Pravin B Shelar patches to
> linux upstream with little changes.
>
> Patch 5, 6, 7: Optimize the flow looking up and
> simplify the flow hash.
>
> Patch 8, 9: are bugfix.
>
> The performance test is on Intel Xeon E5-2630 v4.
> The test topology is show as below:
>
> +-----------------------------------+
> |   +---------------------------+   |
> |   | eth0   ovs-switch    eth1 |   | Host0
> |   +---------------------------+   |
> +-----------------------------------+
>        ^                       |
>        |                       |
>        |                       |
>        |                       |
>        |                       v
> +-----+----+             +----+-----+
> | netperf  | Host1       | netserver| Host2
> +----------+             +----------+
>
> We use netperf send the 64B packets, and insert 255+ flow-mask:
> $ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:01:00:00:00:00/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=no)" 2
> ...
> $ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:ff:00:00:00:00/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)" 2
> $
> $ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18
>
> * Without series patch, throughput 8.28Mbps
> * With series patch, throughput 46.05Mbps
>
> v2: simplify codes. e.g. use kfree_rcu instead of call_rcu, use
> ma->count in the fastpath.
> v3: update ma point when realloc mask_array in patch 5.
>
> Tonghao Zhang (10):
>    net: openvswitch: add flow-mask cache for performance
>    net: openvswitch: convert mask list in mask array
>    net: openvswitch: shrink the mask array if necessary
>    net: openvswitch: optimize flow mask cache hash collision
>    net: openvswitch: optimize flow-mask looking up
>    net: openvswitch: simplify the flow_hash
>    net: openvswitch: add likely in flow_lookup
>    net: openvswitch: fix possible memleak on destroy flow-table
>    net: openvswitch: don't unlock mutex when changing the user_features
>      fails
>    net: openvswitch: simplify the ovs_dp_cmd_new
>
>   net/openvswitch/datapath.c   |  65 +++++----
>   net/openvswitch/flow.h       |   1 -
>   net/openvswitch/flow_table.c | 315 +++++++++++++++++++++++++++++++++++++------
>   net/openvswitch/flow_table.h |  19 ++-
>   4 files changed, 328 insertions(+), 72 deletions(-)
>

Hi Tonghao,

I've tried this new patch series and it passes the kernel check test #63 
now:
## ------------------------------- ##
## openvswitch 2.12.90 test suite. ##
## ------------------------------- ##
  63: conntrack - IPv6 fragmentation + vlan           ok

## ------------- ##
## Test results. ##
## ------------- ##

1 test was successful.

So I went ahead and ran the entire check-kernel testsuite and it ran 
fine with no regressions or
other problems.

You can go ahead and add my tested by tag to your patches.
Tested-by: Greg Rose <gvrose8192@gmail.com>

Pravin's comments about the memory barrier are still valid I think.

Thanks,

- Greg

