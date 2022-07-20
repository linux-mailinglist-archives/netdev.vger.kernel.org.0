Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606DB57B34F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiGTI5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiGTI5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:57:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F10F6B26E
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658307419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0PlCq6ajL/Z4I1TluumiywIvpa4NQvyOba7zhGyb68U=;
        b=ebBkxX3IjlOBd2+hIVkw77iyTufI9P9wdSFPQm7ZYvtq5167aEB3sTo/VtlnpGPNMBOqcQ
        0wUj+XDqXyF23xhAfFF7xxGZbmC5P+mWOwZshzxm0mG+6GL372MeOePsdJsgellyHaCxjf
        /iRs026U6mNgaKGS9SbdeYBhzpadbEY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-9ERMYyNPNTadTPZBNqvbVw-1; Wed, 20 Jul 2022 04:56:57 -0400
X-MC-Unique: 9ERMYyNPNTadTPZBNqvbVw-1
Received: by mail-qt1-f200.google.com with SMTP id u12-20020a05622a010c00b0031ef5b46dc0so4375114qtw.16
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=0PlCq6ajL/Z4I1TluumiywIvpa4NQvyOba7zhGyb68U=;
        b=DyARUdCG9WHA8Ffc+5HkYZlNuoK9UoFnymkDC98lbmJ49yOS1+IHX67YD/QG5zd9u/
         pnU6M7WX3meJW8QYUUnCJFZ7K7dtK8Fd3qGPdVZITNEBPGB4vVHcdnC0trXTFJ1dZAm7
         lDJeLOaFXwkpmw29OJfMK9YgkLIvg39wa39ez70xUfDbp+eMzV2ideBQgYmMFVDnOYdT
         0BjKgk8u0nMiSB2m+Fw7Qe7343yz97WE4RfY2tGkZBJS9R7PsIN/E/+tpbD7hbl+DGqW
         r8hsQdkkn1E12ir9j5R6r71qWGBDKwnbeiEogb1u7w1RV3yX993GyV4EYJcYgRYo3Izx
         Mudg==
X-Gm-Message-State: AJIora+16rHtnGZlwj4gTuxh/yTT/O7q8r3s7UbLggeTlLgvKG2tuylG
        RJ1kJjD2NgstVxIP5n34Ao5jCjAIbzEFfPQ9NNlIFymTmyVi5BgyXJk3TS26bSVsi/Qo4ep8LeV
        M2bQuxBCFPc/CEXKx
X-Received: by 2002:a0c:8c89:0:b0:470:9ab6:bb27 with SMTP id p9-20020a0c8c89000000b004709ab6bb27mr28764652qvb.118.1658307417213;
        Wed, 20 Jul 2022 01:56:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uUEd8wd9tFBWjZIynLvqe+YW58v3ThG/Igh7FbI5iMXJ4uDVuxP2SQYrdm0ppCHCoqmP9x8A==
X-Received: by 2002:a0c:8c89:0:b0:470:9ab6:bb27 with SMTP id p9-20020a0c8c89000000b004709ab6bb27mr28764632qvb.118.1658307416999;
        Wed, 20 Jul 2022 01:56:56 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id bn10-20020a05622a1dca00b0031ece6e0f17sm3229189qtb.71.2022.07.20.01.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 01:56:56 -0700 (PDT)
Date:   Wed, 20 Jul 2022 10:56:49 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 3/3] vsock_test: POLLIN + SO_RCVLOWAT test.
Message-ID: <20220720085649.6pqj55hmkxlamxjq@sgarzare-redhat>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <df70a274-4e69-ca1f-acba-126eb517e532@sberdevices.ru>
 <20220719125227.bktosg3yboeaeoo5@sgarzare-redhat>
 <ea414c31-741f-6994-651a-a686cba3d25e@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea414c31-741f-6994-651a-a686cba3d25e@sberdevices.ru>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 05:46:01AM +0000, Arseniy Krasnov wrote:
>On 19.07.2022 15:52, Stefano Garzarella wrote:
>> On Mon, Jul 18, 2022 at 08:19:06AM +0000, Arseniy Krasnov wrote:
>>> This adds test to check, that when poll() returns POLLIN and
>>> POLLRDNORM bits, next read call won't block.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> tools/testing/vsock/vsock_test.c | 90 ++++++++++++++++++++++++++++++++
>>> 1 file changed, 90 insertions(+)
>>>
>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>> index dc577461afc2..8e394443eaf6 100644
>>> --- a/tools/testing/vsock/vsock_test.c
>>> +++ b/tools/testing/vsock/vsock_test.c
>>> @@ -18,6 +18,7 @@
>>> #include <sys/socket.h>
>>> #include <time.h>
>>> #include <sys/mman.h>
>>> +#include <poll.h>
>>>
>>> #include "timeout.h"
>>> #include "control.h"
>>> @@ -596,6 +597,90 @@ static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opt
>>>     close(fd);
>>> }
>>>
>>> +static void test_stream_poll_rcvlowat_server(const struct test_opts *opts)
>>> +{
>>> +#define RCVLOWAT_BUF_SIZE 128
>>> +    int fd;
>>> +    int i;
>>> +
>>> +    fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>>> +    if (fd < 0) {
>>> +        perror("accept");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    /* Send 1 byte. */
>>> +    send_byte(fd, 1, 0);
>>> +
>>> +    control_writeln("SRVSENT");
>>> +
>>> +    /* Just empirically delay value. */
>>> +    sleep(4);
>>
>> Why we need this sleep()?
>Purpose of sleep() is to move client in state, when it has 1 byte of rx data
>and poll() won't wake. For example:
>client:                        server:
>waits for "SRVSENT"
>                               send 1 byte
>                               send "SRVSENT"
>poll()
>                               sleep
>...
>poll sleeps
>...
>                               send rest of data
>poll wake up
>
>I think, without sleep there is chance, that client enters poll() when whole
>data from server is already received, thus test will be useless(it just tests

Right, I see (maybe add a comment in the test).

>poll()). May be i can remove "SRVSENT" as sleep is enough.

I think it's fine.

An alternative could be to use the `timeout` of poll():

client:                        server:
waits for "SRVSENT"
                                send 1 byte
                                send "SRVSENT"
poll(, timeout = 1 * 1000)
                                wait for "CLNSENT"
poll should return 0
send "CLNSENT"

poll(, timeout = 10 * 1000)
...
poll sleeps
...
                                send rest of data
poll wake up


I don't have a strong opinion, also your version seems fine, just an 
alternative ;-)

Maybe in your version you can add a 10 sec timeout to poll, to avoid 
that the test stuck for some reason (failing if the timeout is reached).

Thanks,
Stefano

