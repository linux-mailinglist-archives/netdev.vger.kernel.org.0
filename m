Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057006B3B2C
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjCJJp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCJJpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:45:40 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10AE59803;
        Fri, 10 Mar 2023 01:45:21 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id CAF465FD11;
        Fri, 10 Mar 2023 12:45:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678441518;
        bh=EW36SNWQvg1BKtDD9gJdvaX8Y04wId0Q4TebP8o6aG8=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=qpTnxxJ3A26CAzrY/8l0xEMzJ4Ka+FFE5sAMhsIWrlfK9f0J+a/fdgtmnEVELAUeo
         OAxM7IIRT5T1RIULDjO+25D4XN8VZsBdz4moBuxetLZ+Rhq0X+w2NKruLUS6IFL0Ub
         8TfTd5/NiHUDAcNDI4SX2MjS/x847wP6UvzSe+PtQGv5w7N9gCVV0FB3ubAfqLsSFx
         ebA9lJMGDA85eX6hCkTqz0r2T8YCJzDeVoUcbHIU8GY+bBgKS96cc8t4camZ7Sywh1
         UfmMdKnZtV3ipENkf8RG08PRX7D1+i3fT52dgQzC80egH5nPY8BHlrTdYcTV018xi8
         Zod2LN/kB6Lcg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Fri, 10 Mar 2023 12:45:15 +0300 (MSK)
Message-ID: <15b9df26-bdc1-e139-8df7-62f966c719ed@sberdevices.ru>
Date:   Fri, 10 Mar 2023 12:42:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v4 0/4] several updates to virtio/vsock
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <1804d100-1652-d463-8627-da93cb61144e@sberdevices.ru>
 <20230310090937.s55af2fx56zn4ewu@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230310090937.s55af2fx56zn4ewu@sgarzare-redhat>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/10 04:38:00 #20931247
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10.03.2023 12:09, Stefano Garzarella wrote:
> Hi Arseniy,
> 
> On Thu, Mar 09, 2023 at 11:24:42PM +0300, Arseniy Krasnov wrote:
>> Hello,
>>
>> this patchset evolved from previous v2 version (see link below). It does
>> several updates to virtio/vsock:
>> 1) Changes 'virtio_transport_inc/dec_rx_pkt()' interface. Now instead of
>>   using skbuff state ('head' and 'data' pointers) to update 'fwd_cnt'
>>   and 'rx_bytes', integer value is passed as an input argument. This
>>   makes code more simple, because in this case we don't need to update
>>   skbuff state before calling 'virtio_transport_inc/dec_rx_pkt()'. In
>>   more common words - we don't need to change skbuff state to update
>>   'rx_bytes' and 'fwd_cnt' correctly.
>> 2) For SOCK_STREAM, when copying data to user fails, current skbuff is
>>   not dropped. Next read attempt will use same skbuff and last offset.
>>   Instead of 'skb_dequeue()', 'skb_peek()' + '__skb_unlink()' are used.
>>   This behaviour was implemented before skbuff support.
>> 3) For SOCK_SEQPACKET it removes unneeded 'skb_pull()' call, because for
>>   this type of socket each skbuff is used only once: after removing it
>>   from socket's queue, it will be freed anyway.
> 
> thanks for the fixes, I would wait a few days to see if there are any
> comments and then I think you can send it on net without RFC.
> 
> @Bobby if you can take a look, your ack would be appreciated :-)
Ok, thanks for review. I'll wait for several days and also wait until
net-next will be opened. Then i'll resend this patchset with net-next

Thanks, Arseniy
> 
> Thanks,
> Stefano
> 
