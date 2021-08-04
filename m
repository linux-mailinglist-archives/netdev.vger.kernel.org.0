Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B7B3E05BB
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 18:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbhHDQSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 12:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhHDQSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 12:18:15 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42463C0613D5;
        Wed,  4 Aug 2021 09:18:02 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id f20-20020a9d6c140000b02904bb9756274cso2125817otq.6;
        Wed, 04 Aug 2021 09:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qTPO93ek00ieZ4h1jlHx4mVRBJbxujN/y8xcY6o8WNU=;
        b=vOGVqPRwQG7VOW4uzaSShTmRzf9UrbcW3jjG4dVkIXUL1wcy03pjQ09wMSRwifLbt+
         jy/rgAtrflpyz0lrws8UHJ0Nqwq8VRfadft9DCEBJ/vcqBlajv4vVoNwcudF/nwLE0U4
         M0+lrv+P4KOyOXqys4GGCGizOh4PoYmtiBnyK1fWx0xN9KwQ+eSiOyqQwN2oeXnxwZfK
         T/DxACEFGQcBSrvukZlfizkVa44fLBsZdpfq7TGmgB+MMY8Iqw7J+ttwg3voOdqLB5ea
         XDqq58WpHBme8e0+ByizWvBiVy71HFEMGpogvsZ4iXz48sEEqNB5Yq2fALwRlgAAE/Wg
         2ixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qTPO93ek00ieZ4h1jlHx4mVRBJbxujN/y8xcY6o8WNU=;
        b=PxZMgZUcM4GYTLbTC7F32RcRCnkG2+ebrv6jpbwmeCgwFG1mkg2XvMo0cqVI7vyKva
         ExnRplK1m1mgPkjoA1QR/HLASiJX6URvCZKTr0fwSqlkZy1P0e6K/yMV4X2XD9inJW1C
         m070qd8N/npMY9B/xhsMh+fIh+STyby8/qnamXFRV8v3oz4fXFd6xArMaTdtmE/DdFHB
         QpB4oGUlz0J3GlLpakf8gc0KbHQSVNG0ae4F9PmeFnPcT8QCmTrHf5iGbLJcz4/X3vFN
         zbbjraU1rG4jPRCW9vJgl60Q27jg77eZlA760q0zdXDeXrK9Qh/vLDLkTZRgTYrzYHFb
         e9iQ==
X-Gm-Message-State: AOAM5308gb8tsIIq1DGzJYbSKQ4kPTHPNY13lQDf3WGWrsFRQkHHvAka
        LA+gj9zj6gx33mu/w2lSm8TWAWdvcm6gXg==
X-Google-Smtp-Source: ABdhPJwSKtdqMSiQmc6Z/AVzL+juoGVbxNK3lLBYUFOpDi9n6YEh0UcLX2VLGTRMpx9/Cpt8Q13SNg==
X-Received: by 2002:a9d:d04:: with SMTP id 4mr386968oti.251.1628093880856;
        Wed, 04 Aug 2021 09:18:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id a7sm470157oti.47.2021.08.04.09.17.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 09:18:00 -0700 (PDT)
Subject: Re: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP
 statistics
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <43e91ce1-0f82-5820-7cac-b42461a0311a@gmail.com>
Date:   Wed, 4 Aug 2021 10:17:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804053650.22aa8a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/21 6:36 AM, Jakub Kicinski wrote:
>> XDP is going to always be eBPF based ! why not just report such stats
>> to a special BPF_MAP ? BPF stack can collect the stats from the driver
>> and report them to this special MAP upon user request.
> Do you mean replacing the ethtool-netlink / rtnetlink etc. with
> a new BPF_MAP? I don't think adding another category of uAPI thru 
> which netdevice stats are exposed would do much good :( Plus it 
> doesn't address the "yet another cacheline" concern.
> 
> To my understanding the need for stats recognizes the fact that (in
> large organizations) fleet monitoring is done by different teams than
> XDP development. So XDP team may have all the stats they need, but the
> team doing fleet monitoring has no idea how to get to them.
> 
> To bridge the two worlds we need a way for the infra team to ask the
> XDP for well-defined stats. Maybe we should take a page from the BPF
> iterators book and create a program type for bridging the two worlds?
> Called by networking core when duping stats to extract from the
> existing BPF maps all the relevant stats and render them into a well
> known struct? Users' XDP design can still use a single per-cpu map with
> all the stats if they so choose, but there's a way to implement more
> optimal designs and still expose well-defined stats.
> 
> Maybe that's too complex, IDK.

I was just explaining to someone internally how to get stats at all of
the different points in the stack to track down reasons for dropped packets:

ethtool -S for h/w and driver
tc -s for drops by the qdisc
/proc/net/softnet_stat for drops at the backlog layer
netstat -s for network and transport layer

yet another command and API just adds to the nightmare of explaining and
understanding these stats.

There is real value in continuing to use ethtool API for XDP stats. Not
saying this reorg of the XDP stats is the right thing to do, only that
the existing API has real user benefits.

Does anyone have data that shows bumping a properly implemented counter
causes a noticeable performance degradation and if so by how much? You
mention 'yet another cacheline' but collecting stats on stack and
incrementing the driver structs at the end of the napi loop should not
have a huge impact versus the value the stats provide.
