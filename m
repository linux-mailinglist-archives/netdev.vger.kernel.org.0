Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7278651C66
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 09:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiLTIeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 03:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiLTIeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 03:34:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED350178AF
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 00:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671525205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3bSjHn3a3hvKLyvcCrRE0qPqm28ju8MVOgmbyDKX+PI=;
        b=TEDbvmUwq9Z6pqWBWIkGNbFIO9cBIJK2Bx+lo/L9eJMmTg9qaNOlYjyYyP863rZcP8l8WD
        BkN916C/XyGf7/ECRfJpYXn7++TdWJazQ7mUgc75x6G6QL4Ot1dbjV9SuNIxVt+JDbaemn
        DWaqdFq7pz6+jPOijSEfI7pl+5cCvCI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-381-G8Qro8ZuP7asXm2G50TN4A-1; Tue, 20 Dec 2022 03:33:21 -0500
X-MC-Unique: G8Qro8ZuP7asXm2G50TN4A-1
Received: by mail-qt1-f199.google.com with SMTP id bt4-20020ac86904000000b003a96b35e7a8so5177205qtb.8
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 00:33:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3bSjHn3a3hvKLyvcCrRE0qPqm28ju8MVOgmbyDKX+PI=;
        b=kAhiTeREw5x1Dt6KlvPr+6ECrLaGaxMKJ83dBG99ILXP9/bVXLNTvQNl+UcKXBMS/v
         TpwbusP9pWchtgpKTIZUeEk0x6/zBgjTxa05iSPc1ro3ZEf2pw4eaZvNt7FHCEEplovx
         ZrL5tin1rqKZuPQUYXnqMubahEohXzKgsmjozSc0yutQ3+A39699qFBSDGWA3bSOfbK/
         b2MNzsfvc91P4LtrF48jfK1rmz+b9B24PASLM9Ot7HyHpgRxghW0DKSrSi8q2d5vU2XI
         kB77a6ehE8f0LWICZ3KQssTzDk2ENt5qsstSkrkfH6goNxHN+o5XKakRtsXoDpS2RTfk
         eShg==
X-Gm-Message-State: ANoB5plwzcSo0i/5mw7061jH0KfWBd8ACzk/DlM2tvuNvXgF1wY9M2Oi
        5rFjTGjrdmjmAe7fACP5cwUWhtx8edsmH6lKpC3mysoxGtM75jP3kCK1BxuL6AUXNYNgJVN3CqY
        BX4b2bEAgjAo6DToj
X-Received: by 2002:a05:622a:581b:b0:39c:da1f:f817 with SMTP id fg27-20020a05622a581b00b0039cda1ff817mr60895004qtb.61.1671525201406;
        Tue, 20 Dec 2022 00:33:21 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4ve/d+0DDMyGhpz1aVQZE7nDpZoLr+/LoGDbriBQXg8eTnb92+kKWzJtB2dHCjem4WX45Zdg==
X-Received: by 2002:a05:622a:581b:b0:39c:da1f:f817 with SMTP id fg27-20020a05622a581b00b0039cda1ff817mr60894981qtb.61.1671525201136;
        Tue, 20 Dec 2022 00:33:21 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id fx11-20020a05622a4acb00b003a6934255dasm7445601qtb.46.2022.12.20.00.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 00:33:20 -0800 (PST)
Date:   Tue, 20 Dec 2022 09:33:13 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 0/2] virtio/vsock: fix mutual rx/tx hungup
Message-ID: <20221220083313.mj2fd4tvfoifayaq@sgarzare-redhat>
References: <39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru>
 <CAGxU2F4ca5pxW3RX4wzsTx3KRBtxLK_rO9KxPgUtqcaSNsqXCA@mail.gmail.com>
 <2bc5a0c0-5fb7-9d0e-bd45-879e42c1ea50@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2bc5a0c0-5fb7-9d0e-bd45-879e42c1ea50@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 07:14:27AM +0000, Arseniy Krasnov wrote:
>On 19.12.2022 18:41, Stefano Garzarella wrote:
>
>Hello!
>
>> Hi Arseniy,
>>
>> On Sat, Dec 17, 2022 at 8:42 PM Arseniy Krasnov <AVKrasnov@sberdevices.ru> wrote:
>>>
>>> Hello,
>>>
>>> seems I found strange thing(may be a bug) where sender('tx' later) and
>>> receiver('rx' later) could stuck forever. Potential fix is in the first
>>> patch, second patch contains reproducer, based on vsock test suite.
>>> Reproducer is simple: tx just sends data to rx by 'write() syscall, rx
>>> dequeues it using 'read()' syscall and uses 'poll()' for waiting. I run
>>> server in host and client in guest.
>>>
>>> rx side params:
>>> 1) SO_VM_SOCKETS_BUFFER_SIZE is 256Kb(e.g. default).
>>> 2) SO_RCVLOWAT is 128Kb.
>>>
>>> What happens in the reproducer step by step:
>>>
>>
>> I put the values of the variables involved to facilitate understanding:
>>
>> RX: buf_alloc = 256 KB; fwd_cnt = 0; last_fwd_cnt = 0;
>>     free_space = buf_alloc - (fwd_cnt - last_fwd_cnt) = 256 KB
>>
>> The credit update is sent if
>> free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE [64 KB]
>>
>>> 1) tx tries to send 256Kb + 1 byte (in a single 'write()')
>>> 2) tx sends 256Kb, data reaches rx (rx_bytes == 256Kb)
>>> 3) tx waits for space in 'write()' to send last 1 byte
>>> 4) rx does poll(), (rx_bytes >= rcvlowat) 256Kb >= 128Kb, POLLIN is set
>>> 5) rx reads 64Kb, credit update is not sent due to *
>>
>> RX: buf_alloc = 256 KB; fwd_cnt = 64 KB; last_fwd_cnt = 0;
>>     free_space = 192 KB
>>
>>> 6) rx does poll(), (rx_bytes >= rcvlowat) 192Kb >= 128Kb, POLLIN is set
>>> 7) rx reads 64Kb, credit update is not sent due to *
>>
>> RX: buf_alloc = 256 KB; fwd_cnt = 128 KB; last_fwd_cnt = 0;
>>     free_space = 128 KB
>>
>>> 8) rx does poll(), (rx_bytes >= rcvlowat) 128Kb >= 128Kb, POLLIN is set
>>> 9) rx reads 64Kb, credit update is not sent due to *
>>
>> Right, (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) is still false.
>>
>> RX: buf_alloc = 256 KB; fwd_cnt = 196 KB; last_fwd_cnt = 0;
>>     free_space = 64 KB
>>
>>> 10) rx does poll(), (rx_bytes < rcvlowat) 64Kb < 128Kb, rx waits in poll()
>>
>> I agree that the TX is stuck because we are not sending the credit
>> update, but also if RX sends the credit update at step 9, RX won't be
>> woken up at step 10, right?
>
>Yes, RX will sleep, but TX will wake up and as we inform TX how much
>free space we have, now there are two cases for TX:
>1) send "small" rest of data(e.g. without blocking again), leave 'write()'
>   and continue execution. RX still waits in 'poll()'. Later TX will
>   send enough data to wake up RX.
>2) send "big" rest of data - if rest is too big to leave 'write()' and TX
>   will wait again for the free space - it will be able to send enough data
>   to wake up RX as we compared 'rx_bytes' with rcvlowat value in RX.

Right, so I'd update the test to behave like this.
And I'd explain better the problem we are going to fix in the commit 
message.

>>
>>>
>>> * is optimization in 'virtio_transport_stream_do_dequeue()' which
>>>   sends OP_CREDIT_UPDATE only when we have not too much space -
>>>   less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE.
>>>
>>> Now tx side waits for space inside write() and rx waits in poll() for
>>> 'rx_bytes' to reach SO_RCVLOWAT value. Both sides will wait forever. I
>>> think, possible fix is to send credit update not only when we have too
>>> small space, but also when number of bytes in receive queue is smaller
>>> than SO_RCVLOWAT thus not enough to wake up sleeping reader. I'm not
>>> sure about correctness of this idea, but anyway - I think that problem
>>> above exists. What do You think?
>>
>> I'm not sure, I have to think more about it, but if RX reads less 
>> than
>> SO_RCVLOWAT, I expect it's normal to get to a case of stuck.
>>
>> In this case we are only unstucking TX, but even if it sends that single
>> byte, RX is still stuck and not consuming it, so it was useless to wake
>> up TX if RX won't consume it anyway, right?
>
>1) I think it is not useless, because we inform(not just wake up) TX that
>there is free space at RX side - as i mentioned above.
>2) Anyway i think that this situation is a little bit strange: TX thinks that
>there is no free space at RX and waits for it, but there is free space at RX!
>At the same time, RX waits in poll() forever - it is ready to get new portion
>of data to return POLLIN, but TX "thinks" exactly opposite thing - RX is full
>of data. Of course, if there will be just stalls in TX data handling - it will
>be ok - just performance degradation, but TX stucks forever.

We did it to avoid a lot of credit update messages.
Anyway I think here the main point is why RX is setting SO_RCVLOWAT to 
128 KB and then reads only half of it?

So I think if the users set SO_RCVLOWAT to a value and then RX reads 
less then it, is expected to get stuck.

Anyway, since the change will not impact the default behaviour 
(SO_RCVLOWAT = 1) we can merge this patch, but IMHO we need to explain 
the case better and improve the test.

>
>>
>> If RX woke up (e.g. SO_RCVLOWAT = 64KB) and read the remaining 64KB,
>> then it would still send the credit update even without this patch and
>> TX will send the 1 byte.
>
>But how RX will wake up in this case? E.g. it calls poll() without timeout,
>connection is established, RX ignores signal

RX will wake up because SO_RCVLOWAT is 64KB and there are 64 KB in the 
buffer. Then RX will read it and send the credit update to TX because
free_space is 0.

Thanks,
Stefano

