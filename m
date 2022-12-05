Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952CE6425EE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiLEJju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiLEJjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:39:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49BB18351
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670233128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+fbDbQQPxO62jOc30ZCiGvrM9jORKTwJPATgGVcGw/4=;
        b=aZZ/9uT675CFPIjv+V3iL8i7WRnI7pI5MT8HeqLtoOipYnSeQEuVulaQWYPu1MEChyfSEr
        F4tIXlUnTZ//pN4Z1VdpmvwRsDybGwgQXDcEQgwKGkWaN5KkyEyfsIiBx2JV3+j0LyTHMG
        0OjgsT0UuVJmHOc+bad7/FKQRYnJkfE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-44-sADKH42cNHGj47UIqFCnAw-1; Mon, 05 Dec 2022 04:38:47 -0500
X-MC-Unique: sADKH42cNHGj47UIqFCnAw-1
Received: by mail-qk1-f199.google.com with SMTP id h13-20020a05620a244d00b006fb713618b8so16293174qkn.0
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 01:38:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+fbDbQQPxO62jOc30ZCiGvrM9jORKTwJPATgGVcGw/4=;
        b=ys0UaWg1fdrwoPBh2TGYVnoSn1kg7+LyLbh43ikYw0fsgSAqBs9jL5E7JcSLmXHjcg
         utp3hQJzUgxtoAg0webvA2gc1u7d08u552qvxUNbOZ0RzKOd0rsNKKKEpSQnXpwK6n9w
         Zq5HGLrZbQCZVwBVeiLEPoT+/Az5Vv2auN7ZmyaNitH3CpZcewwnbUiFhkAA0U2Fjhc5
         RKX/5+PsBG9wdd13j4C2epyGvvBGk6n2tIOkzMLitku+tgcEiFFWNgsASgOqNkLCt7Ne
         W7RI14aZRm47Y7YdEVpVFephJL7B1706jaxKOEqYPtztGiaoVYWZ/eltW46JFYVo0nLp
         dYlw==
X-Gm-Message-State: ANoB5pktedbyIXBDhc7FlrdPQ4FcSX0WpM5fi0vLN3WVRBsS3e5btwMi
        WTcsW+YR6JfxqKvHLKAe6YTUu/BRmYyYbpIChfeapebLZtHrkpfsoiEGtNb/I+7Dqx9aaq7sH+g
        OygcEsluVZ1zXCuxc
X-Received: by 2002:a05:6214:348a:b0:4c7:53a9:9093 with SMTP id mr10-20020a056214348a00b004c753a99093mr8233893qvb.79.1670233126801;
        Mon, 05 Dec 2022 01:38:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6tHHotrSA8b/cA8OdX2reWyR5JpmHe9IB3vPxBjfFYu5K8xypQAG0C+aqEeW0Vinl/4QRK4A==
X-Received: by 2002:a05:6214:348a:b0:4c7:53a9:9093 with SMTP id mr10-20020a056214348a00b004c753a99093mr8233877qvb.79.1670233126520;
        Mon, 05 Dec 2022 01:38:46 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id s18-20020a05620a29d200b006f9ddaaf01esm12476510qkp.102.2022.12.05.01.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:38:46 -0800 (PST)
Date:   Mon, 5 Dec 2022 10:38:37 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 5/6] test/vsock: add big message test
Message-ID: <20221205093837.2aag3xnvqviyxbqv@sgarzare-redhat>
References: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
 <2634ad7f-b462-5c69-8aa1-2f200a6beb20@sberdevices.ru>
 <20221201094541.gj7zthelbeqhsp63@sgarzare-redhat>
 <2694faa5-c460-857d-6ca9-a6328530ff23@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2694faa5-c460-857d-6ca9-a6328530ff23@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 11:44:39AM +0000, Arseniy Krasnov wrote:
>On 01.12.2022 12:45, Stefano Garzarella wrote:
>> On Fri, Nov 25, 2022 at 05:13:06PM +0000, Arseniy Krasnov wrote:
>>> This adds test for sending message, bigger than peer's buffer size.
>>> For SOCK_SEQPACKET socket it must fail, as this type of socket has
>>> message size limit.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> tools/testing/vsock/vsock_test.c | 69 ++++++++++++++++++++++++++++++++
>>> 1 file changed, 69 insertions(+)
>>>
>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>> index 12ef0cca6f93..a8e43424fb32 100644
>>> --- a/tools/testing/vsock/vsock_test.c
>>> +++ b/tools/testing/vsock/vsock_test.c
>>> @@ -569,6 +569,70 @@ static void test_seqpacket_timeout_server(const struct test_opts *opts)
>>>     close(fd);
>>> }
>>>
>>> +static void test_seqpacket_bigmsg_client(const struct test_opts *opts)
>>> +{
>>> +    unsigned long sock_buf_size;
>>> +    ssize_t send_size;
>>> +    socklen_t len;
>>> +    void *data;
>>> +    int fd;
>>> +
>>> +    len = sizeof(sock_buf_size);
>>> +
>>> +    fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>>> +    if (fd < 0) {
>>> +        perror("connect");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    if (getsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>>> +               &sock_buf_size, &len)) {
>>> +        perror("getsockopt");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    sock_buf_size++;
>>> +
>>> +    data = malloc(sock_buf_size);
>>> +    if (!data) {
>>> +        perror("malloc");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    send_size = send(fd, data, sock_buf_size, 0);
>>> +    if (send_size != -1) {
>>> +        fprintf(stderr, "expected 'send(2)' failure, got %zi\n",
>>> +            send_size);
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    if (errno != EMSGSIZE) {
>>> +        fprintf(stderr, "expected EMSGSIZE in 'errno', got %i\n",
>>> +            errno);
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>
>> We should make sure that this is true for all transports, but since now only virtio-vsock supports it, we should be okay.
>Hm, in general: I've tested this test suite for vmci may be several months ago, and found, that some tests
>didn't work. I'm thinking about reworking this test suite a little bit: each transport must have own set of
>tests for features that it supports. I had feeling, that all these tests are run only with virtio transport :)
>Because for example SEQPACKET mode is suported only for virtio.

Yep, when we developed it, we added the "--skip" param for that.
Ideally there should be no difference, but I remember VMCI had a 
different behavior and we couldn't change it for backward compatibility, 
so we added "--skip".

Thanks,
Steano

