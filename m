Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1AD3E06BF
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 19:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239948AbhHDR2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 13:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239975AbhHDR2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 13:28:48 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFE5C06179A;
        Wed,  4 Aug 2021 10:28:33 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id a5-20020a05683012c5b029036edcf8f9a6so2337772otq.3;
        Wed, 04 Aug 2021 10:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1gu89wY9LreYODHlzcyea31Rq8lJ9lifCsibkahK734=;
        b=twallvAmbFxBl9Z6qyLi8tqJmCVWfRSu/r/bTsFejuxvtLNsGrdH36quktEn8bDI+f
         gDUiowVe2a0q9gRWDDvzbWNLcm0YPIHYtEcKjx3LWpHkjO1VMuXLmq1JGO8Wbh08dPuU
         WijtEETtWIn8YQmPUOaTBpfBLNnFlD0us43hrTvzZe12eO8kkPqBTfFEMkP9SoZksxfw
         mFpegkN7IiZ2ZzbSWutYBzy9TESGxJC5cr0ITIkkuyY+WPUbdtDzUlLPmjPuVt8jbTuc
         TTlAd7VxK0h+dgZHGDQt/wHli10k0oluN271z2YqbNgFZ56E+kmYRNNR6KOq/mgAMO8A
         NOyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1gu89wY9LreYODHlzcyea31Rq8lJ9lifCsibkahK734=;
        b=lFsm9OMPE2+KSGlQo5AGyDn+YvA+bC5TZqpbtHkrTvJOIrOoGhvNaPMSvCxPqMvFZt
         M2b/pvyykxt+ITQbX+n2nqDCx3xNJPqNs64ZedD0OHiaOIah2qOK9sdO0n3k8Rk6BVcz
         AkQckkoT4pf3lOqVCJZ1f6qR4Tcctlt/mJ0f5WoH6KhDD11hcr99XEYrBPtx77/w4YgA
         2zEjtiyrR1VrYY52Uk2jAuTnjDUnFagacT+bsQfp5lA1U5nMhLU2+xFgd1wE21OnvF0s
         83MF7+TFAo/UZDgrJSGWl16tfKdh1wsyQMdcq6S01b+Ai7N53blrUAHI3qPTzcKgZdXr
         8y9g==
X-Gm-Message-State: AOAM532cAm5HA4xAEnECrz0SQHscoAR5FHa1ZWQwyc+EoWLsKg1T8DWd
        UL3xgAgLKZxtGCdLg1LaFKzy3IjdMxR2Og==
X-Google-Smtp-Source: ABdhPJxfTJB+1amIiaMzKYuEzbZBRIy7VzQ7/+ItNJE/ANxFmOKfDrAXgp4L0cILRQmu/1zpKeW+wA==
X-Received: by 2002:a9d:7550:: with SMTP id b16mr623424otl.309.1628098112834;
        Wed, 04 Aug 2021 10:28:32 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id r25sm418421oos.24.2021.08.04.10.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 10:28:32 -0700 (PDT)
Subject: Re: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP
 statistics
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
 <20210803163641.3743-4-alexandr.lobakin@intel.com>
 <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org>
 <20210804053650.22aa8a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <43e91ce1-0f82-5820-7cac-b42461a0311a@gmail.com>
 <20210804094432.08d0fa86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d21933cb-9d24-9bdd-cf18-e5077796ddf7@gmail.com>
Date:   Wed, 4 Aug 2021 11:28:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804094432.08d0fa86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/21 10:44 AM, Jakub Kicinski wrote:
> On Wed, 4 Aug 2021 10:17:56 -0600 David Ahern wrote:
>> On 8/4/21 6:36 AM, Jakub Kicinski wrote:
>>>> XDP is going to always be eBPF based ! why not just report such stats
>>>> to a special BPF_MAP ? BPF stack can collect the stats from the driver
>>>> and report them to this special MAP upon user request.  
>>> Do you mean replacing the ethtool-netlink / rtnetlink etc. with
>>> a new BPF_MAP? I don't think adding another category of uAPI thru 
>>> which netdevice stats are exposed would do much good :( Plus it 
>>> doesn't address the "yet another cacheline" concern.
>>>
>>> To my understanding the need for stats recognizes the fact that (in
>>> large organizations) fleet monitoring is done by different teams than
>>> XDP development. So XDP team may have all the stats they need, but the
>>> team doing fleet monitoring has no idea how to get to them.
>>>
>>> To bridge the two worlds we need a way for the infra team to ask the
>>> XDP for well-defined stats. Maybe we should take a page from the BPF
>>> iterators book and create a program type for bridging the two worlds?
>>> Called by networking core when duping stats to extract from the
>>> existing BPF maps all the relevant stats and render them into a well
>>> known struct? Users' XDP design can still use a single per-cpu map with
>>> all the stats if they so choose, but there's a way to implement more
>>> optimal designs and still expose well-defined stats.
>>>
>>> Maybe that's too complex, IDK.  
>>
>> I was just explaining to someone internally how to get stats at all of
>> the different points in the stack to track down reasons for dropped packets:
>>
>> ethtool -S for h/w and driver
>> tc -s for drops by the qdisc
>> /proc/net/softnet_stat for drops at the backlog layer
>> netstat -s for network and transport layer
>>
>> yet another command and API just adds to the nightmare of explaining and
>> understanding these stats.
> 
> Are you referring to RTM_GETSTATS when you say "yet another command"?
> RTM_GETSTATS exists and is used by offloads today.
> 
> I'd expect ip -s (-s) to be extended to run GETSTATS and display the xdp
> stats. (Not sure why ip -s was left out of your list :))

It's on my diagram, and yes, forgot to add it here.

> 
>> There is real value in continuing to use ethtool API for XDP stats. Not
>> saying this reorg of the XDP stats is the right thing to do, only that
>> the existing API has real user benefits.
> 
> RTM_GETSTATS is an existing API. New ethtool stats are intended to be HW
> stats. I don't want to go back to ethtool being a dumping ground for all
> stats because that's what the old interface encouraged.

driver stats are important too. e.g., mlx5's cache stats and per-queue
stats.

> 
>> Does anyone have data that shows bumping a properly implemented counter
>> causes a noticeable performance degradation and if so by how much? You
>> mention 'yet another cacheline' but collecting stats on stack and
>> incrementing the driver structs at the end of the napi loop should not
>> have a huge impact versus the value the stats provide.
> 
> Not sure, maybe Jesper has some numbers. Maybe Intel folks do?

I just ran some quick tests with my setup and measured about 1.2% worst
case. Certainly not exhaustive. Perhaps Intel or Mellanox can provide
numbers for their high speed nics - e.g. ConnectX-6 and a saturated host.

> 
> I'm just allergic to situations when there is a decision made and 
> then months later patches are posted disregarding the decision, 
> without analysis on why that decision was wrong. And while the
> maintainer who made the decision is on vacation.
> 

stats is one of the many sensitive topics. I have been consistent in
defending the need to use existing APIs and tooling and not relying on
XDP program writers to add the relevant stats and then provide whatever
tool is needed to extract and print them. Standardization for
fundamental analysis tools.
