Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1B73F24F3
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 04:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237810AbhHTCrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 22:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbhHTCrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 22:47:52 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13599C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 19:47:14 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k14so7779375pga.13
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 19:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=G6eBU5JCWXp3ZTP8kOVJU4zSe5j2nKrSfOnGQW6XlnY=;
        b=lm0/C4iJwNYnCK0GVhCYfW8M+jEuOMMopU9h2cXeL9uyflW0hV4XPCHVfNZqOYLQOq
         uqFMnjCYRJnWJc//LgLM4bwK60e9XHK0msNvpT5xKn+TidftpfM4MLpbcCPYBytGVkQp
         YTdspIPeFauf6H6mV986bRfMnD4DgnLTJ+mZTHc98dV7Iz86QYQSC0DAoe4oj4qnRDYO
         1oIk1dEsFXCbNIQdSiSwV+Y3N3F4I+QOlKM7EQmaz1owKBtghXYDK5suRONaBHwapYtJ
         CeU/w75bSPxCm/Y5rDMgxTcN1A1BVfvCT9/+s/cFVGRd3zo8R+1iNhM6e1IQSEsxeZ17
         NeWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=G6eBU5JCWXp3ZTP8kOVJU4zSe5j2nKrSfOnGQW6XlnY=;
        b=c6lIhiDSUoS0RB+ahR1n2u53Ar59RmVFc2pA+3BsB03NROdgAtCcxe/pkcBnjq6uRg
         2bmKhXRnUbxLosgWGUbhcRPqURjt45plHqq5ZzeaGss/sXCeNbTIh/KLPtPHtZ98RyTq
         OGPvQt1cSRMa/HYIZQmHPyFkVneCgfhQ/fa4owYJUWJuQ7WOdRpOkm+x36pn4I/Bav+n
         /1aofdygZsIiLjwm+e5hf3EhWj0Fykn22P7GUmmAtT+yxTk7PKQh+PDWlqOJB7fIJnYL
         sgjS1AIpWvfsvMF/wzZF0n+850/SaARx793C/GBdFQrKlPAPjiKo7svRWJMG8s9arW/I
         KVig==
X-Gm-Message-State: AOAM532pdp/tyIeUMhfKsHWYFi91ENsISrnrsTSPp3PIU4ZBB3pPyKdh
        zRZu2j27oS7djGSbn0BTnxLqTg==
X-Google-Smtp-Source: ABdhPJy4Cc/BoD3VMxRSAwn9uuwIHHaOVkRHwfqQJLcjUZ0TxpAaya0OAavyVqqz4HcfFoB3BRIS/Q==
X-Received: by 2002:a62:1443:0:b029:3e0:77ce:accf with SMTP id 64-20020a6214430000b02903e077ceaccfmr17087920pfu.27.1629427633633;
        Thu, 19 Aug 2021 19:47:13 -0700 (PDT)
Received: from [10.254.58.101] ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id v1sm5354411pgj.40.2021.08.19.19.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 19:47:13 -0700 (PDT)
Subject: Re: [External] Re: [PATCH] ixgbe: Fix NULL pointer dereference in
 ixgbe_xdp_setup
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, jeffrey.t.kirsher@intel.com,
        magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, zhouchengming@bytedance.com,
        chenying.kernel@bytedance.com, zhengqi.arch@bytedance.com,
        wangdongdong.6@bytedance.com, jesse.brandeburg@intel.com
References: <20210817075407.11961-1-zhoufeng.zf@bytedance.com>
 <20210817111047.GA8143@ranger.igk.intel.com>
 <5bddff53-9b78-99db-1d8e-23b3d38167a1@bytedance.com>
 <20210819101619.GE32204@ranger.igk.intel.com>
From:   zhoufeng <zhoufeng.zf@bytedance.com>
Message-ID: <879c4cf5-1b63-229f-2d99-6fdfdbce05cc@bytedance.com>
Date:   Fri, 20 Aug 2021 10:47:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210819101619.GE32204@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/8/19 下午6:16, Maciej Fijalkowski 写道:
> On Wed, Aug 18, 2021 at 04:30:15PM +0800, zhoufeng wrote:
>>
>>
>> 在 2021/8/17 下午7:10, Maciej Fijalkowski 写道:
>>> On Tue, Aug 17, 2021 at 03:54:07PM +0800, Feng zhou wrote:
>>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>>
>>>> The ixgbe driver currently generates a NULL pointer dereference with
>>>> some machine (online cpus < 63). This is due to the fact that the
>>>> maximum value of num_xdp_queues is nr_cpu_ids. Code is in
>>>> "ixgbe_set_rss_queues"".
>>>
>>> That's a good catch, but we should fix set channels callback so that it
>>> will not allow a setting of queues to be higher than the
>>> num_online_cpus().
>>>
>>> Please also include the tree in the patch subject that you're directing
>>> the patch to.
>>>
>>
>> Ok, Besides it, I will add more code in "ixgbe_set_channels":
>> /* verify the number of channels does not exceed num_online_cpus */
>> if (count > num_online_cpus())
>> 	return -EINVAL;
>> If user want set queues num to be higher than the num_online_cpus(),
>> return error(-EINVAL).
>>
>> What do you think?
> 
> Yes, in general you can refer to
> drivers/net/ethernet/intel/ice/ice_ethtool.c and in particular:
> 
> /**
>   * ice_get_max_rxq - return the maximum number of Rx queues for in a PF
>   * @pf: PF structure
>   */
> static int ice_get_max_rxq(struct ice_pf *pf)
> {
> 	return min3(pf->num_lan_msix, (u16)num_online_cpus(),
> 		    (u16)pf->hw.func_caps.common_cap.num_rxq);
> }
> 
> 

Ok, refer to drivers/net/ethernet/intel/ice/ice_ethtool.c:
"ice_get_max_rxq"

I think, "ixgbe_max_channels":

return max_combined;

Instead of

return min_t(int, max_combined, num_online_cpus());


>>
>>> I'd be also thankful if you Cc me on Intel XDP related patches.
>>> Thanks!
>>>
>>
>> Ok, of course.
>>
>>
>>>>
>>>> Here's how the problem repeats itself:
>>>> Some machine (online cpus < 63), And user set num_queues to 63 through
>>>> ethtool. Code is in the "ixgbe_set_channels",
>>>> adapter->ring_feature[RING_F_FDIR].limit = count;
>>>> It becames 63.
>>>> When user use xdp, "ixgbe_set_rss_queues" will set queues num.
>>>> adapter->num_rx_queues = rss_i;
>>>> adapter->num_tx_queues = rss_i;
>>>> adapter->num_xdp_queues = ixgbe_xdp_queues(adapter);
>>>> And rss_i's value is from
>>>> f = &adapter->ring_feature[RING_F_FDIR];
>>>> rss_i = f->indices = f->limit;
>>>> So "num_rx_queues" > "num_xdp_queues", when run to "ixgbe_xdp_setup",
>>>> for (i = 0; i < adapter->num_rx_queues; i++)
>>>> 	if (adapter->xdp_ring[i]->xsk_umem)
>>>> lead to panic.
>>>> Call trace:
>>>> [exception RIP: ixgbe_xdp+368]
>>>> RIP: ffffffffc02a76a0  RSP: ffff9fe16202f8d0  RFLAGS: 00010297
>>>> RAX: 0000000000000000  RBX: 0000000000000020  RCX: 0000000000000000
>>>> RDX: 0000000000000000  RSI: 000000000000001c  RDI: ffffffffa94ead90
>>>> RBP: ffff92f8f24c0c18   R8: 0000000000000000   R9: 0000000000000000
>>>> R10: ffff9fe16202f830  R11: 0000000000000000  R12: ffff92f8f24c0000
>>>> R13: ffff9fe16202fc01  R14: 000000000000000a  R15: ffffffffc02a7530
>>>> ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>>>>    7 [ffff9fe16202f8f0] dev_xdp_install at ffffffffa89fbbcc
>>>>    8 [ffff9fe16202f920] dev_change_xdp_fd at ffffffffa8a08808
>>>>    9 [ffff9fe16202f960] do_setlink at ffffffffa8a20235
>>>> 10 [ffff9fe16202fa88] rtnl_setlink at ffffffffa8a20384
>>>> 11 [ffff9fe16202fc78] rtnetlink_rcv_msg at ffffffffa8a1a8dd
>>>> 12 [ffff9fe16202fcf0] netlink_rcv_skb at ffffffffa8a717eb
>>>> 13 [ffff9fe16202fd40] netlink_unicast at ffffffffa8a70f88
>>>> 14 [ffff9fe16202fd80] netlink_sendmsg at ffffffffa8a71319
>>>> 15 [ffff9fe16202fdf0] sock_sendmsg at ffffffffa89df290
>>>> 16 [ffff9fe16202fe08] __sys_sendto at ffffffffa89e19c8
>>>> 17 [ffff9fe16202ff30] __x64_sys_sendto at ffffffffa89e1a64
>>>> 18 [ffff9fe16202ff38] do_syscall_64 at ffffffffa84042b9
>>>> 19 [ffff9fe16202ff50] entry_SYSCALL_64_after_hwframe at ffffffffa8c0008c
>>>>
>>>> Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for
>>>> AF_XDP")
>>>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>> ---
>>>>    drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 8 ++++++--
>>>>    1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>>> index 14aea40da50f..5db496cc5070 100644
>>>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>>> @@ -10112,6 +10112,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>>>>    	struct ixgbe_adapter *adapter = netdev_priv(dev);
>>>>    	struct bpf_prog *old_prog;
>>>>    	bool need_reset;
>>>> +	int num_queues;
>>>>    	if (adapter->flags & IXGBE_FLAG_SRIOV_ENABLED)
>>>>    		return -EINVAL;
>>>> @@ -10161,11 +10162,14 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>>>>    	/* Kick start the NAPI context if there is an AF_XDP socket open
>>>>    	 * on that queue id. This so that receiving will start.
>>>>    	 */
>>>> -	if (need_reset && prog)
>>>> -		for (i = 0; i < adapter->num_rx_queues; i++)
>>>> +	if (need_reset && prog) {
>>>> +		num_queues = min_t(int, adapter->num_rx_queues,
>>>> +			adapter->num_xdp_queues);
>>>> +		for (i = 0; i < num_queues; i++)
>>>>    			if (adapter->xdp_ring[i]->xsk_pool)
>>>>    				(void)ixgbe_xsk_wakeup(adapter->netdev, i,
>>>>    						       XDP_WAKEUP_RX);
>>>> +	}
>>>>    	return 0;
>>>>    }
>>>> -- 
>>>> 2.11.0
>>>>
