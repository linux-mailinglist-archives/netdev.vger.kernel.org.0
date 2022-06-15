Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB7954CD75
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbiFOPvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiFOPvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E40192ED42
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655308280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AIOIMROOiOvW54yRJHKcdZXL+9ppiA1fBxCdrioQXGQ=;
        b=HyMTA10h0Ywn8FSi7jrVBGaPxqCdsMp2lqVKkLmx7y6kVjAtLLOXCZZEvbm/oDZWvb8NN0
        984EEUACPIEnRV3YCdsQeMwNqwgpZCiZHfmS8XRUzKaw6mzZKah+HROfBtmkIkg3gUz5nb
        VWSfSyCxUHVRGLiIUKDdgzCIqEVewx0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-pR5bAuxTOreoFsY09DXmiA-1; Wed, 15 Jun 2022 11:51:19 -0400
X-MC-Unique: pR5bAuxTOreoFsY09DXmiA-1
Received: by mail-qv1-f71.google.com with SMTP id kl30-20020a056214519e00b0046d8f1cd655so8409636qvb.19
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AIOIMROOiOvW54yRJHKcdZXL+9ppiA1fBxCdrioQXGQ=;
        b=DO2JGwnJck8R2yMmkKrpu/dDrf8vwJfJOfu74bcKUSK7t+QAtM/XujXRG8YQ5HTp9d
         EwQ03WIAsDjVk+0+hM1hv2Zz3/8ERg7K3cfATPqNzfxB178tWHcrm9c9tERbNfhpgSsL
         e9AI2KTCb3DO2Rx5FGSEkILxjuDCCeZ3CvQ9QC6Wp2KMQjMz4xLjp9y7gh9cPOMKrIHJ
         M65QjaoAK3o3XGzIO74AnIx4pLrWxfOHzF5IaFEZzNPzKq0NPeuN4AqYHot6mevw5Y3A
         c4UoKbFXfSigEOc3vZoBL36bJSoiwYhxqc9Q6LLmdtocmDYmkaHqcMG0TMcPY6ntv9I9
         erMQ==
X-Gm-Message-State: AJIora9zUFXiFlW6unMjQUD1aMBupfYophxnlQi/RrYb/BpBdppBs9K3
        gLwPJ3cNWcHSzK5H4RT9NzRTvoi9XS4FWYtA5w49lEXFgOzcb5mSdav6vcdDptR86m7dUXQwxTb
        NsiV6Jcp8WN95F8+U
X-Received: by 2002:ac8:7f0d:0:b0:304:fe93:8e77 with SMTP id f13-20020ac87f0d000000b00304fe938e77mr186081qtk.70.1655308278417;
        Wed, 15 Jun 2022 08:51:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t6B5q+eqXrmwd7GqHIKthR4shmNUMNmtfYYaeWOGNyVk1OgyQqNQR7Fb87sxDrjkPbwsYj4g==
X-Received: by 2002:ac8:7f0d:0:b0:304:fe93:8e77 with SMTP id f13-20020ac87f0d000000b00304fe938e77mr186061qtk.70.1655308278149;
        Wed, 15 Jun 2022 08:51:18 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id 3-20020ac84e83000000b002f940d5ab2csm10118267qtp.74.2022.06.15.08.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 08:51:17 -0700 (PDT)
Message-ID: <2db298d5-4e3d-0e99-6ce7-6a4a0df4bb48@redhat.com>
Date:   Wed, 15 Jun 2022 11:51:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: Any reason why arp monitor keeps emitting netlink failover
 events?
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com>
 <10584.1655220562@famine> <0ea8519c-4289-c409-2e31-44574cdefde3@redhat.com>
 <8133.1655252763@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <8133.1655252763@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/22 20:26, Jay Vosburgh wrote:
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
>> On 6/14/22 11:29, Jay Vosburgh wrote:
>>> Jonathan Toppins <jtoppins@redhat.com> wrote:
>>>
>>>> On net-next/master from today, I see netlink failover events being emitted
>>> >from an active-backup bond. In the ip monitor dump you can see the bond is
>>>> up (according to the link status) but keeps emitting failover events and I
>>>> am not sure why. This appears to be an issue also on Fedora 35 and CentOS
>>>> 8 kernels. The configuration appears to be correct, though I could be
>>>> missing something. Thoughts?
>>> 	Anything showing up in the dmesg?  There's only one place that
>>> generates the FAILOVER notifier, and it ought to have a corresponding
>>> message in the kernel log.
>>> 	Also, I note that the link1_1 veth has a lot of failures:
>>
>> Yes all those failures are created by the setup, I waited about 5 minutes
>> before dumping the link info. The failover occurs about every second. Note
>> this is just a representation of a physical network so that others can run
>> the setup. The script `bond-bz2094911.sh`, easily reproduces the issue
>> which I dumped with cat below in the original email.
>>
>> Here is the kernel log, I have dynamic debug enabled for the entire
>> bonding module:
> 
> 	I set up the test, and added some additional instrumentation to
> bond_ab_arp_inspect, and what seems to be going on is that the
> dev_trans_start for link1_1 is never updating.  The "down to up"
> transition for the ARP monitor only checks last_rx, but the "up to down"
> check for the active interface requires both TX and RX recently
> ("recently" being within the past missed_max * arp_interval).
> 
> 	This looks to be due to HARD_TX_LOCK not actually locking for
> NETIF_F_LLTX devices:
> 
> #define HARD_TX_LOCK(dev, txq, cpu) {                           if ((dev->features & NETIF_F_LLTX) == 0) {                      __netif_tx_lock(txq, cpu);                      } else {                                                        __netif_tx_acquire(txq);                        }                                               }
> 
> 	in combination with
> 
> static inline void txq_trans_update(struct netdev_queue *txq)
> {
>          if (txq->xmit_lock_owner != -1)
>                  WRITE_ONCE(txq->trans_start, jiffies);
> }
> 
> 	causes the trans_start update to be skipped on veth devices.
> 
> 	And, sure enough, if I apply the following, the test case
> appears to work:
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 466da01ba2e3..2cb833b3006a 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -312,6 +312,7 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
>   static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>   {
>   	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
> +	struct netdev_queue *queue = NULL;
>   	struct veth_rq *rq = NULL;
>   	struct net_device *rcv;
>   	int length = skb->len;
> @@ -329,6 +330,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>   	rxq = skb_get_queue_mapping(skb);
>   	if (rxq < rcv->real_num_rx_queues) {
>   		rq = &rcv_priv->rq[rxq];
> +		queue = netdev_get_tx_queue(dev, rxq);
>   
>   		/* The napi pointer is available when an XDP program is
>   		 * attached or when GRO is enabled
> @@ -340,6 +342,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>   
>   	skb_tx_timestamp(skb);
>   	if (likely(veth_forward_skb(rcv, skb, rq, use_napi) == NET_RX_SUCCESS)) {
> +		if (queue)
> +			txq_trans_cond_update(queue);
>   		if (!use_napi)
>   			dev_lstats_add(dev, length);
>   	} else {
> 
> 
> 	I'm not entirely sure this is the best way to get the
> trans_start updated in veth, but LLTX devices need to handle it
> internally (and others do, e.g., tun).
> 
> 	Could you test the above and see if it resolves the problem in
> your environment as well?
> 
> 	-J
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> 

Hi Jay,

This patch appears to work, you can apply my tested-by.

Tested-by: Jonathan Toppins <jtoppins@redhat.com>

Now this exposes an easily reproducible bonding issue with 
bond_should_notify_peers() which is every second the bond issues a 
NOTIFY_PEERS event. This notify peers event issue has been observed on 
physical hardware (tg3, i40e, igb) drivers. I have not traced the code 
yet, wanted to point this out. Run the same reproducer script and start 
monitoring the bond;

[root@fedora ~]# ip -ts -o monitor link dev bond0
[2022-06-15T11:30:44.337568] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event NOTIFY PEERS \    link/ether ce:d3:22:ef:13:d0 brd 
ff:ff:ff:ff:ff:ff
[2022-06-15T11:30:45.361381] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event NOTIFY PEERS \    link/ether ce:d3:22:ef:13:d0 brd 
ff:ff:ff:ff:ff:ff
[.. trimmed ..]
[2022-06-15T11:30:56.618621] [2022-06-15T11:30:56.622657] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event NOTIFY PEERS \    link/ether ce:d3:22:ef:13:d0 brd 
ff:ff:ff:ff:ff:ff
[2022-06-15T11:30:57.647644] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event NOTIFY PEERS \    link/ether ce:d3:22:ef:13:d0 brd 
ff:ff:ff:ff:ff:ff

In another shell take down the active interface:
# ip link set link1_1 down

we get the failover below, as expected.

[2022-06-15T11:30:58.671501] [2022-06-15T11:30:58.671576] 
[2022-06-15T11:30:58.671611] [2022-06-15T11:30:58.671643] 
[2022-06-15T11:30:58.671676] [2022-06-15T11:30:58.671709] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event BONDING FAILOVER \    link/ether ce:d3:22:ef:13:d0 
brd ff:ff:ff:ff:ff:ff
[2022-06-15T11:30:58.671782] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event NOTIFY PEERS \    link/ether ce:d3:22:ef:13:d0 brd 
ff:ff:ff:ff:ff:ff
[2022-06-15T11:30:58.676862] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event NOTIFY PEERS \    link/ether ce:d3:22:ef:13:d0 brd 
ff:ff:ff:ff:ff:ff
[2022-06-15T11:30:58.676948] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event RESEND IGMP \    link/ether ce:d3:22:ef:13:d0 brd 
ff:ff:ff:ff:ff:ff

Now bring back up link1_1 and notice no more NOTIFY_PEERS event every 
second. The issue stops with the first failover just brought back up the 
primary for completeness.

# ip link set link1_1 up

[2022-06-15T11:31:01.629256] [2022-06-15T11:31:01.630275] 
[2022-06-15T11:31:01.742927] [2022-06-15T11:31:01.742991] 
[2022-06-15T11:31:01.743021] [2022-06-15T11:31:01.743045] 
[2022-06-15T11:31:01.743070] [2022-06-15T11:31:01.743094] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event BONDING FAILOVER \    link/ether ce:d3:22:ef:13:d0 
brd ff:ff:ff:ff:ff:ff
[2022-06-15T11:31:01.743151] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event NOTIFY PEERS \    link/ether ce:d3:22:ef:13:d0 brd 
ff:ff:ff:ff:ff:ff
[2022-06-15T11:31:01.746412] 9: bond0: 
<BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
group default event RESEND IGMP \    link/ether ce:d3:22:ef:13:d0 brd 
ff:ff:ff:ff:ff:ff

-Jon

