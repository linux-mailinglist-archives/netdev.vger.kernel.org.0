Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC0B5A26B6
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiHZLQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiHZLQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:16:04 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEC0D9EAD
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:16:03 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id s23so701366wmj.4
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=vRtP9Skqdi6VRUhZFmU/5JLtOk/HwkyzGgOrB5aVaqc=;
        b=BdK6TUPc3E95StF714NnERXWUrvaQ18TZ48qTAB6uRMvSSkzEVJKaqXmU1jlABADIn
         k3elOllRLH6zHYKRmAwge10AsGt90U/L65VKqWXeZW3722f3YNZY2M6o0H2gbn4FthOq
         9/wDAAKJfQrIXOJtNPCu+fMEUpHxgxUQLnAZWXBJD/Wpxp3u6jP3BhpdkUG+5cYGLv0M
         SietHnFquLDYnlZz24gs/eUGbfFd/mRvtsAkCQhTSptZgFuuwrQA39UkYjGUYIBD7J/U
         b7brUwjthuTOFYs7QOveQ5WljT0czxdNfL+pV+SxzidtQgnEBBW+r0I2jMyvmZkYAjF2
         6Q3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=vRtP9Skqdi6VRUhZFmU/5JLtOk/HwkyzGgOrB5aVaqc=;
        b=Z0YTRNYAWTInTDNMjZUtwr5lh2MycKZRWxOa2LxUX3lrcuD0ro0zuehEkLGNWY+cfU
         Rjr11XgmUdCkKjOy9xXx0T5muJyVBYAlvSjm/Xqt9j1i0Wc7EoB4x7pM3HEKPoOTIZ6P
         N709NdhlV7vgEnI0RmjG395jVcDHJUDqa32IGgEOTH5FPG6QNrynMI2ljt3/tHmkKeKO
         KVqJteKxTaFOELAytzUIlScP2bnj6Eh3nKGCZ4IHqUAvOpzh2ndK3c8esX4jHfLgKWbr
         vJnl5Ow1nMWefZkfhCj6Q5bM+qEwgckjMTeWAIGPAfeq3krMAMBEi6KYp4UCtZrnXUBD
         pFJw==
X-Gm-Message-State: ACgBeo16Wc2PoFPYM9ewinyyubK+SjjVgaamelSpHiufT7tXA9NTRWmi
        OhlFQvQxTbNwkwsyktf9sfn8ag==
X-Google-Smtp-Source: AA6agR4QzaWX8XmLz8SGvNyIEQsQ5GQDx172pO0aIEdni0lwQywVURMMxO00o4DMyckU7PnYyS53nA==
X-Received: by 2002:a05:600c:3048:b0:3a6:5ce0:9701 with SMTP id n8-20020a05600c304800b003a65ce09701mr4969801wmh.97.1661512562030;
        Fri, 26 Aug 2022 04:16:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h21-20020a05600c351500b003a60ff7c082sm8622454wmq.15.2022.08.26.04.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 04:16:01 -0700 (PDT)
Date:   Fri, 26 Aug 2022 13:16:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        marcin.szycik@linux.intel.com, michal.swiatkowski@linux.intel.com,
        kurt@linutronix.de, boris.sukholitko@broadcom.com,
        vladbu@nvidia.com, komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com, gnault@redhat.com
Subject: Re: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
Message-ID: <YwircDhHhOfqdHy/@nanopsycho>
References: <20220826110059.119927-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826110059.119927-1-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 26, 2022 at 01:00:54PM CEST, wojciech.drewek@intel.com wrote:
>Add support for dissecting L2TPv3 session id in flow dissector. Add support
>for this field in tc-flower and support offloading L2TPv3. Finally, add
>support for hardware offload of L2TPv3 packets based on session id in
>switchdev mode in ice driver.
>
>Example filter:
>  # tc filter add dev $PF1 ingress prio 1 protocol ip \
>      flower \
>        ip_proto l2tp \
>        l2tpv3_sid 1234 \
>        skip_sw \
>      action mirred egress redirect dev $VF1_PR
>
>Changes in iproute2 are required to use the new fields.
>
>ICE COMMS DDP package is required to create a filter in ice.

I don't understand what do you mean by this. Could you please explain
what this mysterious "ICE COMMS DDP package" is? Do I understand it
correctly that without it, the solution would not work?

>
>Marcin Szycik (1):
>  ice: Add L2TPv3 hardware offload support
>
>Wojciech Drewek (4):
>  uapi: move IPPROTO_L2TP to in.h
>  flow_dissector: Add L2TPv3 dissectors
>  net/sched: flower: Add L2TPv3 filter
>  flow_offload: Introduce flow_match_l2tpv3
>
> .../ethernet/intel/ice/ice_protocol_type.h    |  8 +++
> drivers/net/ethernet/intel/ice/ice_switch.c   | 70 ++++++++++++++++++-
> drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 27 ++++++-
> drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  6 ++
> include/net/flow_dissector.h                  |  9 +++
> include/net/flow_offload.h                    |  6 ++
> include/uapi/linux/in.h                       |  2 +
> include/uapi/linux/l2tp.h                     |  2 -
> include/uapi/linux/pkt_cls.h                  |  2 +
> net/core/flow_dissector.c                     | 28 ++++++++
> net/core/flow_offload.c                       |  7 ++
> net/sched/cls_flower.c                        | 16 +++++
> 12 files changed, 179 insertions(+), 4 deletions(-)
>
>-- 
>2.31.1
>
