Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E7C6BA895
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjCOHDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjCOHDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:03:13 -0400
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2961A26CF6;
        Wed, 15 Mar 2023 00:03:09 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-03 (Coremail) with SMTP id rQCowADX3gqdaRFkK73DDw--.42013S2;
        Wed, 15 Mar 2023 14:45:50 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     simon.horman@corigine.com
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: Re: [PATCH] Bluetooth: 6LoWPAN: Add missing check for skb_clone
Date:   Wed, 15 Mar 2023 14:45:48 +0800
Message-Id: <20230315064548.48951-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowADX3gqdaRFkK73DDw--.42013S2
X-Coremail-Antispam: 1UD129KBjvJXoW7XrW5ZFW7KF15Wry3uF4Uurg_yoW8JF1Dpr
        45GF98GF4kG3W7Cr1Iva1ruFy0vr1q9ry3Gr4v934fXr98Kr93CrW5K345Wr18CrZru340
        yF4rW3ZxKF95CFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
        1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
        8cxan2IY04v7MxkIecxEwVAFwVW8AwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
        67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
        IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JU-J5rUUUUU=
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:58:23PM +0800, Simon Horman wrote:
>On Mon, Mar 13, 2023 at 05:03:46PM +0800, Jiasheng Jiang wrote:
>> Add the check for the return value of skb_clone since it may return NULL
>> pointer and cause NULL pointer dereference in send_pkt.
>> 
>> Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>> ---
>>  net/bluetooth/6lowpan.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
>> index 4eb1b3ced0d2..bf42a0b03e20 100644
>> --- a/net/bluetooth/6lowpan.c
>> +++ b/net/bluetooth/6lowpan.c
>> @@ -477,6 +477,10 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
>>  			int ret;
>>  
>>  			local_skb = skb_clone(skb, GFP_ATOMIC);
>> +			if (!local_skb) {
>> +				rcu_read_unlock();
>> +				return -ENOMEM;
>> +			}
> 
> Further down in this loop an error is handled as follows,
> I wonder if that pattern is appropriate here too.
> 
> 			ret = send_pkt(pentry->chan, local_skb, netdev);
> 			if (ret < 0)
> 				err = ret;
> 

I think it should be better to return error here in order to avoid the
error being overwritten.
I will submit a v2 to modify the error handling here.

Thanks,
Jiang

