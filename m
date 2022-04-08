Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F214C4F9E6C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbiDHUy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiDHUy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:54:57 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5E660C6
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:52:53 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r10so11380427eda.1
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 13:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Xuy5nyThQZEOcTuXAOvcq1XiCD79HnE36b0ex0234bw=;
        b=xICSXrqz2MXxMUHJ0Rx9jPRwVKPofZ8CNC3DQKaMKuQ49f/FyjTQYhOfnVhjdp/MC4
         UBUA9+J2V+vW52X4Q3FZMKeIuLsJ4MBuSAC60dRMv9v21jd3EjbPxusN723yD6j3NQbP
         TA7Azx+dKttUwj/uZquWnQKk51pT79IBxl4g30Dv6rqbQhJUpTHI46kfSCpk96RF0RB4
         Xz2xB1+yzXujVc0VpesDw4Jah0483xb5mhwdbZc7J4SNhTp9CeBciTqCsAa2DjSoIUYE
         mK75/Twyzl/SINIWaCE7wKO3+GGI9FcE5qbGsNtXT6eGDMyPkpqN67xRSs5qcU48Ujbr
         nmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Xuy5nyThQZEOcTuXAOvcq1XiCD79HnE36b0ex0234bw=;
        b=lEkXLM3hYeG2Tgsu81gx+Zmo2M47GHlodBUrm8/PIaiET1sttWt7oRn+HHdGZDGedG
         UBdYJ1iVhg2CB23mh3PLqbJu6dJWVexS+m5R9zrOaGOmSSVHjVc8VqI+Evyuvl4aGYSZ
         Ddl3542I/LAa9cQb+6AG5fk+SYVl56zq8gBQXi9RPCFqjOSAoP2u1f2xSjmALm1kcrjz
         27SBmzyqdBQX2oYsIzrm2bj2dGhhKE03astm+p/LnSmTR4oAl0+oJwHH1AqBxJzD96cK
         XdEpZiukS9eQe9T8eNawnpIL2OIWd4Km2p6Dd1XxaEk73hDHh2tO9Uyzj3Ws+yZIqohN
         GeLQ==
X-Gm-Message-State: AOAM530DfIexwA/2/jqUqeU3Y+SgwSpAJMLnau17AFeG40Eg1bLhidDI
        rh2D/fweDTg7fduAf90NqHxxiA==
X-Google-Smtp-Source: ABdhPJwMabksP4E0VnnFxRhb1F7cFT9eMkW+dmZDd4b2hG9+JuobYLXV9l1fmlD3dYy1J6UtxNxhpw==
X-Received: by 2002:a50:c3c6:0:b0:416:293f:1f42 with SMTP id i6-20020a50c3c6000000b00416293f1f42mr21203146edf.187.1649451171359;
        Fri, 08 Apr 2022 13:52:51 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id jl28-20020a17090775dc00b006e05cdf3a95sm9066361ejc.163.2022.04.08.13.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 13:52:50 -0700 (PDT)
Message-ID: <809561da-0433-297a-2dd0-9be9b5e3c65a@blackwall.org>
Date:   Fri, 8 Apr 2022 23:52:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
 <20220408201407.cl6juslapnwx73bo@skbuf>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220408201407.cl6juslapnwx73bo@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/04/2022 23:14, Vladimir Oltean wrote:
> On Fri, Apr 08, 2022 at 11:03:31PM +0300, Vladimir Oltean wrote:
>> For this patch series to make more sense, it should be reviewed from the
>> last patch to the first. Changes were made in the order that they were
>> just to preserve patch-with-patch functionality.
>>
>> A little while ago, some DSA switch drivers gained support for
>> IFF_UNICAST_FLT, a mechanism through which they are notified of the
>> MAC addresses required for local standalone termination.
>> A bit longer ago, DSA also gained support for offloading BR_FDB_LOCAL
>> bridge FDB entries, which are the MAC addresses required for local
>> termination when under a bridge.
>>
>> So we have come one step closer to removing the CPU from the list of
>> destinations for packets with unknown MAC DA. What remains is to check
>> whether any software L2 forwarding is enabled, and that is accomplished
>> by monitoring the neighbor bridge ports that DSA switches have.
>>
>> With these changes, DSA drivers that fulfill the requirements for
>> dsa_switch_supports_uc_filtering() and dsa_switch_supports_mc_filtering()
>> will keep flooding towards the CPU disabled for as long as no port is
>> promiscuous. The bridge won't attempt to make its ports promiscuous
>> anymore either if said ports are offloaded by switchdev (this series
>> changes that behavior). Instead, DSA will fall back by its own will to
>> promiscuous mode on bridge ports when the bridge itself becomes
>> promiscuous, or a foreign interface is detected under the same bridge.
>>
>> Vladimir Oltean (6):
>>   net: refactor all NETDEV_CHANGE notifier calls to a single function
>>   net: emit NETDEV_CHANGE for changes to IFF_PROMISC | IFF_ALLMULTI
>>   net: dsa: walk through all changeupper notifier functions
>>   net: dsa: track whether bridges have foreign interfaces in them
>>   net: dsa: monitor changes to bridge promiscuity
>>   net: bridge: avoid uselessly making offloaded ports promiscuous
>>
>>  include/net/dsa.h  |   4 +-
>>  net/bridge/br_if.c |  63 +++++++++++--------
>>  net/core/dev.c     |  34 +++++-----
>>  net/dsa/dsa_priv.h |   2 +
>>  net/dsa/port.c     |  12 ++++
>>  net/dsa/slave.c    | 150 ++++++++++++++++++++++++++++++++++++++++++---
>>  6 files changed, 215 insertions(+), 50 deletions(-)
>>
>> -- 
>> 2.25.1
>>
> 
> Hmm, Nikolay's address bounced back and I didn't notice the MAINTAINERS
> change. Updated the CC list with his new address.
> 
> Nikolay, if you want to take a look the patches are here, I hope it's
> fine if I don't resend:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220408200337.718067-1-vladimir.oltean@nxp.com/

That's ok, I'll check them out tomorrow. Thanks!

