Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F8860DABC
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 07:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiJZFsK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Oct 2022 01:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJZFsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 01:48:09 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AB7374BAC;
        Tue, 25 Oct 2022 22:48:06 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 29Q5jQSw9023109, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 29Q5jQSw9023109
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 26 Oct 2022 13:45:26 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 26 Oct 2022 13:46:00 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 26 Oct 2022 13:46:00 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb]) by
 RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb%5]) with mapi id
 15.01.2375.007; Wed, 26 Oct 2022 13:46:00 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "toke@kernel.org" <toke@kernel.org>,
        "alexander@wetzel-home.de" <alexander@wetzel-home.de>,
        "nbd@nbd.name" <nbd@nbd.name>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>
Subject: RE: [PATCH net,v2] wifi: mac80211: fix general-protection-fault in ieee80211_subif_start_xmit()
Thread-Topic: [PATCH net,v2] wifi: mac80211: fix general-protection-fault in
 ieee80211_subif_start_xmit()
Thread-Index: AQHY6OQ2YSFc3FHQQ06V00aJhcK/Nq4gKhgA
Date:   Wed, 26 Oct 2022 05:46:00 +0000
Message-ID: <147c69bcc88f4cb28774bd60346325ff@realtek.com>
References: <20221026024703.150668-1-shaozhengchao@huawei.com>
In-Reply-To: <20221026024703.150668-1-shaozhengchao@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/10/25_=3F=3F_10:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Zhengchao Shao <shaozhengchao@huawei.com>
> Sent: Wednesday, October 26, 2022 10:47 AM
> To: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; johannes@sipsolutions.net;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com
> Cc: toke@kernel.org; alexander@wetzel-home.de; nbd@nbd.name; weiyongjun1@huawei.com;
> yuehaibing@huawei.com; shaozhengchao@huawei.com
> Subject: [PATCH net,v2] wifi: mac80211: fix general-protection-fault in ieee80211_subif_start_xmit()
> 
> When device is running and the interface status is changed, the gpf issue
> is triggered. The problem triggering process is as follows:
> Thread A:                           Thread B
> ieee80211_runtime_change_iftype()   process_one_work()
>     ...                                 ...
>     ieee80211_do_stop()                 ...
>     ...                                 ...
>         sdata->bss = NULL               ...
>         ...                             ieee80211_subif_start_xmit()
>                                             ieee80211_multicast_to_unicast
>                                     //!sdata->bss->multicast_to_unicast
>                                       cause gpf issue
> 
> When the interface status is changed, the sending queue continues to send
> packets. After the bss is set to NULL, the bss is accessed. As a result,
> this causes a general-protection-fault issue.
> 
> The following is the stack information:
> general protection fault, probably for non-canonical address
> 0xdffffc000000002f: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000178-0x000000000000017f]
> Workqueue: mld mld_ifc_work
> RIP: 0010:ieee80211_subif_start_xmit+0x25b/0x1310
> Call Trace:
> <TASK>
> dev_hard_start_xmit+0x1be/0x990
> __dev_queue_xmit+0x2c9a/0x3b60
> ip6_finish_output2+0xf92/0x1520
> ip6_finish_output+0x6af/0x11e0
> ip6_output+0x1ed/0x540
> mld_sendpack+0xa09/0xe70
> mld_ifc_work+0x71c/0xdb0
> process_one_work+0x9bf/0x1710
> worker_thread+0x665/0x1080
> kthread+0x2e4/0x3a0
> ret_from_fork+0x1f/0x30
> </TASK>
> 
> Fixes: f856373e2f31 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
> Reported-by: syzbot+c6e8fca81c294fd5620a@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/mac80211/tx.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index a364148149f9..c38485f39d2b 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -4418,6 +4418,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	if (likely(!is_multicast_ether_addr(eth->h_dest)))
>  		goto normal;
> 
> +	if (unlikely(!ieee80211_sdata_running(sdata))) {
> +                kfree_skb(skb);
> +                return NETDEV_TX_OK;
> +        }
> +

The indent looks odd. It seems like you use spaces instead of tabs?

>  	if (unlikely(ieee80211_multicast_to_unicast(skb, dev))) {
>  		struct sk_buff_head queue;
> 
> --
> 2.17.1
> 
> 
> ------Please consider the environment before printing this e-mail.
