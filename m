Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661D311D805
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 21:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbfLLUoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 15:44:46 -0500
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:25606 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730834AbfLLUoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 15:44:46 -0500
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id xBCKOJqx019022;
        Thu, 12 Dec 2019 20:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=XzP3tuBKBhwBopP1mUtiC7Fjv89V2NWKK1/4jJau3uY=;
 b=KUzAHKFdj6n4b7Ptr8t7EZBHH9IINFeIdHRpqNctd5xBXds2oybvx/h2487fBxKfYRbD
 NlCxiBeVyYCUCxCiz0dmAl7pRhX+Pf6NLXI8gKmZvkc1oBbD829UR0B60f1KI6EHztkK
 2T5V1UgVe2rFIWD5SU+XsDUtQE9wQ8Ry0VoIHKalmUgeyJk1YwRaC0rBBRUuTw0t3/V+
 +P3WYkRk4uGNCFnHkNhpCLKqZy2pAX1HpnJyq0XMjcYI5x++2v/R9tVRU8PrqbSZTdVa
 JANwyAVugGuW0HOlPneZJ4EgbX9HoCvY95q7FpCI/B08lNVZ341IaAZfeMpCM+jtZXsc Bg== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 2wr47ur0n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 20:44:20 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id xBCKfKxr004238;
        Thu, 12 Dec 2019 15:44:18 -0500
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2wr8a1d04y-1;
        Thu, 12 Dec 2019 15:44:18 -0500
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id DF4451FC6A;
        Thu, 12 Dec 2019 20:44:17 +0000 (GMT)
Subject: Re: crash in __xfrm_state_lookup on 4.19 LTS
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
References: <0b3ab776-2b8b-1725-d36e-70af66c138da@akamai.com>
 <20191212132132.GL8621@gauss3.secunet.de>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <c328f835-6eb7-3ab9-1f7c-dc565634f8bd@akamai.com>
Date:   Thu, 12 Dec 2019 12:44:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191212132132.GL8621@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-12-12_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120159
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_06:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912120157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/19 5:21 AM, Steffen Klassert wrote:
> On Wed, Dec 11, 2019 at 02:52:41PM -0800, Josh Hunt wrote:
>> We've hit the following crash on a handful of machines recently running
>> 4.19.55 LTS and strongswan. The kernels running on these machines do have
>> some patches on top of 4.19 LTS, but nothing in the area of xfrm/ipsec:
>>
>> [54284.354997] general protection fault: 0000 [#1] SMP PTI
>> [54284.355504] CPU: 6 PID: 11937 Comm: charon Tainted: G           O L
>> 4.19.55-4.19.2.4-amd64-2b86b5ea31726254 #1
>> [54284.356382] Hardware name: Ciara Technologies 1x8-X6 SSD 32G
>> 10GE/CangJie, BIOS CC1F110D 08/12/2014
>> [54284.357322] RIP: 0010:__xfrm_state_lookup+0x7f/0x110
>> [54284.357856] Code: d0 4a 8d 04 c0 48 8b 00 48 85 c0 74 68 41 89 cf 49 89
>> d6 41 89 f5 eb 09 48 8b 43 28 48 85 c0 74 54 48 83 e8 28 48 89 c3 74 4b <66>
>> 3b a8 d2 00 00 00 75 e5 44 3b 78 50
>>   75 df 44 3a 60 54 75 d9 66
>> [54284.359190] RSP: 0018:ffffab5043d93ad0 EFLAGS: 00010212
>> [54284.359748] RAX: 6174735f79636e3d RBX: 6174735f79636e3d RCX:
>> 0000000064959bc7
>> [54284.360219] RDX: ffff9bb0593c3380 RSI: 0000000000000000 RDI:
>> ffffffff951071c0
>> [54284.360713] RBP: 0000000000000002 R08: 0000000000000010 R09:
>> 00000000001b950d
>> [54284.361209] R10: 000000000000003f R11: 0000000096001849 R12:
>> 0000000000000032
>> [54284.361755] R13: 0000000000000000 R14: ffff9bb0593c3380 R15:
>> 0000000064959bc7
>> [54284.362255] FS:  00007facd7b01700(0000) GS:ffff9bb07fb80000(0000)
>> knlGS:00000000000000000
>> [54284.363198] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [54284.363687] CR2: 00007f99250e89e0 CR3: 00000007e1078006 CR4:
>> 00000000001606e0
>> [54284.364156] Call Trace:
>> [54284.364642]  xfrm_state_add+0x108/0x290
>> [54284.365113]  xfrm_add_sa+0x9e6/0xb28 [xfrm_user]
>> [54284.365580]  ? xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
>> [54284.366077]  xfrm_user_rcv_msg+0x183/0x1a0 [xfrm_user]
>> [54284.366543]  ? xfrm_dump_sa_done+0x30/0x30 [xfrm_user]
>> [54284.367040]  netlink_rcv_skb+0xde/0x110
>> [54284.367504]  xfrm_netlink_rcv+0x30/0x40 [xfrm_user]
>> [54284.368000]  netlink_unicast+0x191/0x230
>> [54284.368463]  netlink_sendmsg+0x2c4/0x390
>> [54284.368958]  sock_sendmsg+0x36/0x40
>> [54284.369449]  __sys_sendto+0xd8/0x150
>> [54284.369940]  ? kern_select+0xb9/0xe0
>> [54284.370405]  __x64_sys_sendto+0x24/0x30
>> [54284.370946]  do_syscall_64+0x4e/0x110
>> [54284.383941]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [54284.384497] RIP: 0033:0x7face4679ad3
>>
>> (gdb) list *(__xfrm_state_lookup+0x7f)
>> 0xffffffff8271beaf is in __xfrm_state_lookup (net/xfrm/xfrm_state.c:841).
>> warning: Source file is more recent than executable.
>> 836	{
>> 837		unsigned int h = xfrm_spi_hash(net, daddr, spi, proto, family);
>> 838		struct xfrm_state *x;
>> 839	
>> 840		hlist_for_each_entry_rcu(x, net->xfrm.state_byspi + h, byspi) {
>> 841			if (x->props.family != family ||
>> 842			    x->id.spi       != spi ||
>> 843			    x->id.proto     != proto ||
>> 844			    !xfrm_addr_equal(&x->id.daddr, daddr, family))
>> 845				continue;
>>
>> The above looks similar to these very old reports:
>> https://wiki.strongswan.org/issues/2147
>> https://bugzilla.kernel.org/show_bug.cgi?id=84961
>>
>> Prior to the crash we are seeing softlockups and rcu stalls (see attached
>> netconsole log file.) The RIP in those stalls/lockups appears to be in the
>> same area as the crash reported above, lines 840 and 841.
>>
>> I've tried reproducing the problem in our lab, but have been unsuccessful so
>> far and running the latest upstream kernel in production to see if that
>> resolves the issue is not possible at the moment. It's very possible this
>> crash was happening on earlier kernel versions in our network, I just don't
>> have any data to confirm that.
> 
> Do you have any possibility to reproduce this on v4.19.55?
> __xfrm_state_lookup() is called from process context and protected
> by rcu_read_lock(). But updates to the above list can happen in
> softirq context, so seems like we should disable BHs to prevent
> beeing interrupted by a softirq that updates the list.
> 

Hey Steffen

I really appreciate you looking into this. This kernel is pretty close 
to v4.19.55. The patches that it has are not in/around this code and 
given the older reports (linked above) I feel like this crash is 
representative of what you would see on a v4.19.55 vanilla kernel.

Unfortunately I cannot deploy a vanilla 4.19.55 on these boxes to see if 
the problem reproduces, but I can attempt to reproduce in my lab. Do you 
have an idea on how to trigger the issue? I'd be happy to test it.

As far as disabling BHs, do you mean something like this?
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index f3423562d933..c3d7df1387c8 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1730,9 +1730,9 @@ xfrm_state_lookup(struct net *net, u32 mark, const 
xfrm_address_t *daddr, __be32
  {
         struct xfrm_state *x;

-       rcu_read_lock();
+       spin_lock_bh(&net->xfrm.xfrm_state_lock);
         x = __xfrm_state_lookup(net, mark, daddr, spi, proto, family);
-       rcu_read_unlock();
+       spin_unlock_bh(&net->xfrm.xfrm_state_lock);
         return x;
  }
  EXPORT_SYMBOL(xfrm_state_lookup);

Josh
