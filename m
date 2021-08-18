Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6083EFF29
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239395AbhHRIbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239554AbhHRIbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:31:00 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDEFC0617AE
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 01:30:25 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o10so1401688plg.0
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 01:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=jL/DkoxZCdzlNexUG7tJ6IG5zbZczoSvIVash/JCFrw=;
        b=mjex+yt3nPZrktov1+DZ6Bq446vp3EnZsY5Rp2Z4n5iBYWDavjtfqeXt7QZMyuGeQx
         dmQdu6z3qA1rLvrmaBhTr9RPti/HhOVCjaTV6tvJ/yTjU+xPSVxAQpRZvQwYAgUYofeO
         mmH2cRgxyDimzxfU4p2xlVikV5Eqxe3uztSntLF0ehtUzbOzCC1Otex7gfri/ddagDJv
         9dp7MYgwkA567XF/7ghDiEEu0ngZj6uWW6MzAqVr9yQGP+u2DQ2SwhCcZxAd6Jrq2EIp
         +VMMflY5XYtq41M4/KXWx2ofrDQxrH8xbTuuekFqJwiPORh37Tltgjju+vkismI+2vhj
         7XKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=jL/DkoxZCdzlNexUG7tJ6IG5zbZczoSvIVash/JCFrw=;
        b=kbu1g/Fs/KyDsqWKzosN4zsQ+u7SyRzX2AGgq3sZQDqEbdMBMfjRyiVSjFsQ5VVYyU
         51u9ydYqHfPRg6I78qOAcMEZ94ApHA7/e4QfPC6RROfbC1YKsr4tLdrLwq+E+2QjV5KC
         9X6aN5iJPtChTbAJEx3+h1i4b6Ry+Ct10FS7p8DXKWKs3WqCtlDExzeUSk1EeEO/jLvE
         HMziHDKALgWZyoCudLxhqAobf4cvmpGKPbTBPmgDJt5JCb9VWpwe8PZVBoQXb4hhMlfK
         JChEe69QwObFJ4AXQuT76uvrWH4Ix9GvX6g0FLTaPMu84rMo4mIHnYDePRopyiQlamM2
         1KEA==
X-Gm-Message-State: AOAM533vCzCX1dDho6rRvrYPwXWFwu03tZPAX3SAIhh7g5iLKa6kPxl5
        udgJ91G/eZkyiqT0pif0P5s9Tg==
X-Google-Smtp-Source: ABdhPJxad1KK36PAE+4ALDJhHQYzMsdq97PArLHgXYjcLRlD/AHutLCPOJ3acpkjSavyCEuDCIetRA==
X-Received: by 2002:a17:90b:3007:: with SMTP id hg7mr8245674pjb.66.1629275424835;
        Wed, 18 Aug 2021 01:30:24 -0700 (PDT)
Received: from [10.254.37.14] ([139.177.225.244])
        by smtp.gmail.com with ESMTPSA id 11sm5003086pfl.41.2021.08.18.01.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 01:30:24 -0700 (PDT)
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
        wangdongdong.6@bytedance.com
References: <20210817075407.11961-1-zhoufeng.zf@bytedance.com>
 <20210817111047.GA8143@ranger.igk.intel.com>
From:   zhoufeng <zhoufeng.zf@bytedance.com>
Message-ID: <5bddff53-9b78-99db-1d8e-23b3d38167a1@bytedance.com>
Date:   Wed, 18 Aug 2021 16:30:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817111047.GA8143@ranger.igk.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2021/8/17 ÏÂÎç7:10, Maciej Fijalkowski Ð´µÀ:
> On Tue, Aug 17, 2021 at 03:54:07PM +0800, Feng zhou wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> The ixgbe driver currently generates a NULL pointer dereference with
>> some machine (online cpus < 63). This is due to the fact that the
>> maximum value of num_xdp_queues is nr_cpu_ids. Code is in
>> "ixgbe_set_rss_queues"".
> 
> That's a good catch, but we should fix set channels callback so that it
> will not allow a setting of queues to be higher than the
> num_online_cpus().
> 
> Please also include the tree in the patch subject that you're directing
> the patch to.
> 

Ok, Besides it, I will add more code in "ixgbe_set_channels":
/* verify the number of channels does not exceed num_online_cpus */
if (count > num_online_cpus())
	return -EINVAL;
If user want set queues num to be higher than the num_online_cpus(),
return error(-EINVAL).

What do you think?

> I'd be also thankful if you Cc me on Intel XDP related patches.
> Thanks!
> 

Ok, of course.


>>
>> Here's how the problem repeats itself:
>> Some machine (online cpus < 63), And user set num_queues to 63 through
>> ethtool. Code is in the "ixgbe_set_channels",
>> adapter->ring_feature[RING_F_FDIR].limit = count;
>> It becames 63.
>> When user use xdp, "ixgbe_set_rss_queues" will set queues num.
>> adapter->num_rx_queues = rss_i;
>> adapter->num_tx_queues = rss_i;
>> adapter->num_xdp_queues = ixgbe_xdp_queues(adapter);
>> And rss_i's value is from
>> f = &adapter->ring_feature[RING_F_FDIR];
>> rss_i = f->indices = f->limit;
>> So "num_rx_queues" > "num_xdp_queues", when run to "ixgbe_xdp_setup",
>> for (i = 0; i < adapter->num_rx_queues; i++)
>> 	if (adapter->xdp_ring[i]->xsk_umem)
>> lead to panic.
>> Call trace:
>> [exception RIP: ixgbe_xdp+368]
>> RIP: ffffffffc02a76a0  RSP: ffff9fe16202f8d0  RFLAGS: 00010297
>> RAX: 0000000000000000  RBX: 0000000000000020  RCX: 0000000000000000
>> RDX: 0000000000000000  RSI: 000000000000001c  RDI: ffffffffa94ead90
>> RBP: ffff92f8f24c0c18   R8: 0000000000000000   R9: 0000000000000000
>> R10: ffff9fe16202f830  R11: 0000000000000000  R12: ffff92f8f24c0000
>> R13: ffff9fe16202fc01  R14: 000000000000000a  R15: ffffffffc02a7530
>> ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>>   7 [ffff9fe16202f8f0] dev_xdp_install at ffffffffa89fbbcc
>>   8 [ffff9fe16202f920] dev_change_xdp_fd at ffffffffa8a08808
>>   9 [ffff9fe16202f960] do_setlink at ffffffffa8a20235
>> 10 [ffff9fe16202fa88] rtnl_setlink at ffffffffa8a20384
>> 11 [ffff9fe16202fc78] rtnetlink_rcv_msg at ffffffffa8a1a8dd
>> 12 [ffff9fe16202fcf0] netlink_rcv_skb at ffffffffa8a717eb
>> 13 [ffff9fe16202fd40] netlink_unicast at ffffffffa8a70f88
>> 14 [ffff9fe16202fd80] netlink_sendmsg at ffffffffa8a71319
>> 15 [ffff9fe16202fdf0] sock_sendmsg at ffffffffa89df290
>> 16 [ffff9fe16202fe08] __sys_sendto at ffffffffa89e19c8
>> 17 [ffff9fe16202ff30] __x64_sys_sendto at ffffffffa89e1a64
>> 18 [ffff9fe16202ff38] do_syscall_64 at ffffffffa84042b9
>> 19 [ffff9fe16202ff50] entry_SYSCALL_64_after_hwframe at ffffffffa8c0008c
>>
>> Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for
>> AF_XDP")
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>> ---
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>> index 14aea40da50f..5db496cc5070 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>> @@ -10112,6 +10112,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>>   	struct ixgbe_adapter *adapter = netdev_priv(dev);
>>   	struct bpf_prog *old_prog;
>>   	bool need_reset;
>> +	int num_queues;
>>   
>>   	if (adapter->flags & IXGBE_FLAG_SRIOV_ENABLED)
>>   		return -EINVAL;
>> @@ -10161,11 +10162,14 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>>   	/* Kick start the NAPI context if there is an AF_XDP socket open
>>   	 * on that queue id. This so that receiving will start.
>>   	 */
>> -	if (need_reset && prog)
>> -		for (i = 0; i < adapter->num_rx_queues; i++)
>> +	if (need_reset && prog) {
>> +		num_queues = min_t(int, adapter->num_rx_queues,
>> +			adapter->num_xdp_queues);
>> +		for (i = 0; i < num_queues; i++)
>>   			if (adapter->xdp_ring[i]->xsk_pool)
>>   				(void)ixgbe_xsk_wakeup(adapter->netdev, i,
>>   						       XDP_WAKEUP_RX);
>> +	}
>>   
>>   	return 0;
>>   }
>> -- 
>> 2.11.0
>>
