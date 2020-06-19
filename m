Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478B61FFF37
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 02:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgFSAXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 20:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgFSAXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 20:23:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C963C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 17:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=Eo2p+ghIJ+7OQkSgaH9z1liirV3pK0P8WsBP6Q+fdyE=; b=Ju68gh9UwwHvmfQwEBtCV19/G8
        VbGDYH1amkyAvM2s+A4fQnfyMHMC17pkeWgyS+HalKmLEn2HLKWsRkvcwzih5Ihy3FC+w2PQ6rQHW
        BzrD5IkbUBtuCtHQNwwqV6RvklKYmEugkBTh5AydtAZ4ZQ+I50XE95L+BnGjVG8EC9sVsUBKF3XYW
        SoywwuhvccPkGrqkE+yMchR0ec7l0gGR48VERPuIDaIxfb7djwByXnKIdWIom/k9lDKj+x1MpLKlu
        T4go95qJ2xQ0+DIeKxRgypRltm4NJt4LCBP7BIABpLz/9H/CkIDQUlipoPUn3L9r2etxCrcMPA2Lj
        3QQhmtaw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jm4ok-0005Ic-Jf; Fri, 19 Jun 2020 00:23:39 +0000
Subject: Re: af_decnet.c: missing semi-colon and/or indentation?
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <4649af05-ac31-4c57-a895-39866504b5fb@infradead.org>
 <407fa160-aec6-3135-1579-f833bebe59a2@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7f61fea2-e837-180a-1535-682baa2d0e5b@infradead.org>
Date:   Thu, 18 Jun 2020 17:23:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <407fa160-aec6-3135-1579-f833bebe59a2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/20 4:35 PM, Eric Dumazet wrote:
> 
> 
> On 6/18/20 4:19 PM, Randy Dunlap wrote:
>>
>> Please see lines 1250-1251.
>>
>>
>> 	case TIOCINQ:
>> 		lock_sock(sk);
>> 		skb = skb_peek(&scp->other_receive_queue);
>> 		if (skb) {
>> 			amount = skb->len;
>> 		} else {
>> 			skb_queue_walk(&sk->sk_receive_queue, skb)     <<<<<
>> 				amount += skb->len;                    <<<<<
>> 		}
>> 		release_sock(sk);
>> 		err = put_user(amount, (int __user *)arg);
>> 		break;
>>
>>
>>
>> or is this some kind of GCC nested function magic?
>>
> 
> I do not see a problem
> 
> for (bla; bla; bla)
>         amount += skb->len;
> 
> Seems good to me.
> 

OK, I get it (now). Thanks.

>>
>> commit bec571ec762a4cf855ad4446f833086fc154b60e
>> Author: David S. Miller <davem@davemloft.net>
>> Date:   Thu May 28 16:43:52 2009 -0700
>>
>>     decnet: Use SKB queue and list helpers instead of doing it by-hand.
>>
>>
>>
>> thanks.
>>
> 
> Also decnet should not be any of our concerns in 2020 ?

Ack.

-- 
~Randy

