Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FB6563785
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiGAQNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiGAQNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:13:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C379737AB6
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656692028; x=1688228028;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IUQRxQu2xAb1KnXk54DHDPqMr5bFMKNCKsEmTDz48TA=;
  b=Y5D+2rphNf1FkP01YYmi6BPdzqY0wHXHRIM9eFdt+pkVtoeFg1NmaYWu
   aB8Czha0TCZf7cn4OLrvaleQ5MTq/nli8FztOuLYADHL4CM3unpy3whOp
   IzU8oJYM5rej2ENNwlBr71K/uio805squQTCyMRPk/LKKe+cP72G/MXJA
   LZrSlg6GpGaYn0HC0UFT1BNsZVytjAUaYQoZyhNMAo8I9YyJe/hqWf/Yq
   7kf+8GXfS35c2YSo8rOzmvl3DIq8IVS1NKj6GamXazR5NriSGA81wYXaZ
   YoBusZnQ9XWpz34jFmsgo12JPHpcKy1Lkpk1vRjoPvPnrL6YtG0rT/+l6
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10395"; a="344369672"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="344369672"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 09:13:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="648400615"
Received: from mszycik-mobl.ger.corp.intel.com (HELO [10.249.159.254]) ([10.249.159.254])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 09:13:42 -0700
Message-ID: <7a706a7e-d3bd-b4da-fa68-2cabf3e75871@linux.intel.com>
Date:   Fri, 1 Jul 2022 18:12:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH net-next v3 4/4] ice: Add support for PPPoE hardware
 offload
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        davem@davemloft.net, xiyou.wangcong@gmail.com,
        jesse.brandeburg@intel.com, gustavoars@kernel.org,
        baowen.zheng@corigine.com, boris.sukholitko@broadcom.com,
        edumazet@google.com, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, kurt@linutronix.de, pablo@netfilter.org,
        pabeni@redhat.com, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com, mostrows@earthlink.net,
        paulus@samba.org
References: <20220629143859.209028-1-marcin.szycik@linux.intel.com>
 <20220629143859.209028-5-marcin.szycik@linux.intel.com>
 <20220630231244.GC392@debian.home>
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
In-Reply-To: <20220630231244.GC392@debian.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01-Jul-22 01:12, Guillaume Nault wrote:
> On Wed, Jun 29, 2022 at 04:38:59PM +0200, Marcin Szycik wrote:
>> Add support for creating PPPoE filters in switchdev mode. Add support
>> for parsing PPPoE and PPP-specific tc options: pppoe_sid and ppp_proto.
>>
>> Example filter:
>> tc filter add dev $PF1 ingress protocol ppp_ses prio 1 flower pppoe_sid \
>>     1234 ppp_proto ip skip_sw action mirred egress redirect dev $VF1_PR
>>
>> Changes in iproute2 are required to use the new fields.
>>
>> ICE COMMS DDP package is required to create a filter as it contains PPPoE
>> profiles. Added a warning message when loaded DDP package does not contain
>> required profiles.
>>
>> Note: currently matching on vlan + PPPoE fields is not supported. Patch [0]
>> will add this feature.
>>
>> [0] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220420210048.5809-1-martyna.szapar-mudlaw@intel.com
> 
> Out of curiosity, can ice direct PPPoE Session packets to different
> queues with RSS (based on the session ID)?

Hardware should support it, but I'm not sure if it's possible with the current driver and how to configure it. I'll try to find out.
