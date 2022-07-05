Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C987566722
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 11:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbiGEJzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 05:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiGEJzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 05:55:19 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16331266B
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 02:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657014860; x=1688550860;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=gIcwHGzRZyNR/0x67X3V9Z1F/C2CvuH2v4w728BkwJg=;
  b=Xi7XKi6Uj2noZTHRiah1mpDn8Xk1VoLCh5azQMdWn9ehhVqniy8WTvKZ
   NAphCj1qqzs5lIasWYizHprclSvagRY7zTzSw83pHofiDLT30axZwwLQx
   w4Z80mPditUDOr+Q+V+TMxe7MowgOVomgsGNBk9mJZ/VHq4fh+hWqLeLz
   hMGtVSn7asUc4tHwAqXEdx/WpzHivSeph8WqoeRSDBde1hYOdrrmG0Ion
   ma7Mk84mON5/TqbqcgXWw1SltydZs9KQUTufrMWaEuXQTHVj/1+1tt5QG
   6ZdtI3YS9Jskn7fYOc0FWnrCsdcZ6/sfaXCCNAtAOv48pKVvpf4C2ChH3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="308850019"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="308850019"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 02:54:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="682458557"
Received: from mszycik-mobl.ger.corp.intel.com (HELO [10.249.130.161]) ([10.249.130.161])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 02:54:14 -0700
Message-ID: <7aa3a974-6575-ade6-b863-feb25736ec0f@linux.intel.com>
Date:   Tue, 5 Jul 2022 11:54:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next v3 4/4] ice: Add support for PPPoE hardware
 offload
Content-Language: en-US
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
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
 <7a706a7e-d3bd-b4da-fa68-2cabf3e75871@linux.intel.com>
In-Reply-To: <7a706a7e-d3bd-b4da-fa68-2cabf3e75871@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01-Jul-22 18:12, Marcin Szycik wrote:
> 
> 
> On 01-Jul-22 01:12, Guillaume Nault wrote:
>> On Wed, Jun 29, 2022 at 04:38:59PM +0200, Marcin Szycik wrote:
>>> Add support for creating PPPoE filters in switchdev mode. Add support
>>> for parsing PPPoE and PPP-specific tc options: pppoe_sid and ppp_proto.
>>>
>>> Example filter:
>>> tc filter add dev $PF1 ingress protocol ppp_ses prio 1 flower pppoe_sid \
>>>     1234 ppp_proto ip skip_sw action mirred egress redirect dev $VF1_PR
>>>
>>> Changes in iproute2 are required to use the new fields.
>>>
>>> ICE COMMS DDP package is required to create a filter as it contains PPPoE
>>> profiles. Added a warning message when loaded DDP package does not contain
>>> required profiles.
>>>
>>> Note: currently matching on vlan + PPPoE fields is not supported. Patch [0]
>>> will add this feature.
>>>
>>> [0] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220420210048.5809-1-martyna.szapar-mudlaw@intel.com
>>
>> Out of curiosity, can ice direct PPPoE Session packets to different
>> queues with RSS (based on the session ID)?
> 
> Hardware should support it, but I'm not sure if it's possible with the current driver and how to configure it. I'll try to find out.

From what I understand, currently it's not possible to configure RSS for PPPoE session id, because ethtool does not support PPPoE.
