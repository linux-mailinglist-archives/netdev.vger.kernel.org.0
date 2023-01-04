Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA4B65CC5D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 05:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbjADEYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 23:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjADEYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 23:24:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19093102D
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 20:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672806196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mgnhlnuG8Qrqs2IY3wKLTrPyEJc3j7HXcojektB5wC8=;
        b=dX4OggbB1vWakCHXlWzjIO5VQatLatKpu1f22gqVi5xh4+l02F5vuRnO+n2xSSH21XisKk
        +HOw0VhxFnPa0+Gdoq/wL4sM81HxjgohYXAchD853e5Hzx92pS0PZAj018CDa+XvMwH8+4
        HHPh+qEhI9lE5INra/iwez9uMcX0Vns=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-452-LxWTR0gPMtyhDJDYD0Y6dg-1; Tue, 03 Jan 2023 23:23:14 -0500
X-MC-Unique: LxWTR0gPMtyhDJDYD0Y6dg-1
Received: by mail-pl1-f198.google.com with SMTP id z10-20020a170902ccca00b001898329db72so23430399ple.21
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 20:23:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mgnhlnuG8Qrqs2IY3wKLTrPyEJc3j7HXcojektB5wC8=;
        b=eVkUeU05F7T9565LsBjffFoK36dvQXQ5ApAx8J/hEzXN0DdDLaqCjSbzkcWbJe5sa2
         n2MuaE51o9oApdp/lAA9ckqwOzdNItcfNnwMHhHX1YJZalHUU9NxMJcwT/WPBYxwDRUR
         bIWIKV4ltNCwybVSINy7G9Gh380tgg8sNaQvzUvv75sRwKW46GkjCjRi020dL4oZpTN5
         uPNd8QvLG0qaVfYQCUtBkbSsQwHVYNTQrpDc0X911aqFIap64euHpHE2W32ankKSQYWP
         OIfJngRlR+vVYItIgM967VQ9+tnobDOtHuN85FIAGJjCC/cN2eB/iIdJ3dAcOQx8C+3p
         uA8w==
X-Gm-Message-State: AFqh2kroLHwyY4XCUfBd8L8vVhzWvwwP6Bk7pg9vvDbZ58s4LlAdhhKt
        DaQ7NYCMtuurMU27CThGLe/rTNQYYXQIjfaWeIJogJcd22khlKfhO92MTsdJpdi3zxJagv2TGOR
        o6wCnskqSemSMLp/b
X-Received: by 2002:a17:90a:a28:b0:223:f78c:15d with SMTP id o37-20020a17090a0a2800b00223f78c015dmr50555162pjo.41.1672806193512;
        Tue, 03 Jan 2023 20:23:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvowa9FjwdVvcjzcMHRWWWzT3O0PY8GaSTGVqf+/FTk/nR/PayTpQ5bku/F9FLYRf2r3tu2LQ==
X-Received: by 2002:a17:90a:a28:b0:223:f78c:15d with SMTP id o37-20020a17090a0a2800b00223f78c015dmr50555150pjo.41.1672806193244;
        Tue, 03 Jan 2023 20:23:13 -0800 (PST)
Received: from [10.72.12.120] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ml4-20020a17090b360400b00217090ece49sm20040933pjb.31.2023.01.03.20.23.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 20:23:12 -0800 (PST)
Message-ID: <50eb0df0-89fe-a5df-f89f-07bf69bd00ae@redhat.com>
Date:   Wed, 4 Jan 2023 12:23:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net V2] virtio-net: correctly enable callback during
 start_xmit
From:   Jason Wang <jasowang@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com
References: <20221215032719.72294-1-jasowang@redhat.com>
 <20221215034740-mutt-send-email-mst@kernel.org>
 <CACGkMEsLeCRDqyuyGzWw+kjYrTVDjUjOw6+xHESPT2D1p03=sQ@mail.gmail.com>
 <20221215042918-mutt-send-email-mst@kernel.org>
 <CACGkMEsbvTQrEp5dmQRHp58Mu=E7f433Xrvsbs4nZMA5R3B6mQ@mail.gmail.com>
 <CACGkMEsu_OFFs15d2dzNbfSjzAZfYXLn9CNcO3ELPbDqZsndzg@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CACGkMEsu_OFFs15d2dzNbfSjzAZfYXLn9CNcO3ELPbDqZsndzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/23 14:29, Jason Wang 写道:
> On Fri, Dec 16, 2022 at 11:43 AM Jason Wang <jasowang@redhat.com> wrote:
>> On Thu, Dec 15, 2022 at 5:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>> On Thu, Dec 15, 2022 at 05:15:43PM +0800, Jason Wang wrote:
>>>> On Thu, Dec 15, 2022 at 5:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>> On Thu, Dec 15, 2022 at 11:27:19AM +0800, Jason Wang wrote:
>>>>>> Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
>>>>>> virtqueue callback via the following statement:
>>>>>>
>>>>>>          do {
>>>>>>             ......
>>>>>>        } while (use_napi && kick &&
>>>>>>                 unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>>>>>>
>>>>>> When NAPI is used and kick is false, the callback won't be enabled
>>>>>> here. And when the virtqueue is about to be full, the tx will be
>>>>>> disabled, but we still don't enable tx interrupt which will cause a TX
>>>>>> hang. This could be observed when using pktgen with burst enabled.
>>>>>>
>>>>>> Fixing this by trying to enable tx interrupt after we disable TX when
>>>>>> we're not using napi or kick is false.
>>>>>>
>>>>>> Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
>>>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>>>> ---
>>>>>> The patch is needed for -stable.
>>>>>> Changes since V1:
>>>>>> - enable tx interrupt after we disable tx
>>>>>> ---
>>>>>>   drivers/net/virtio_net.c | 2 +-
>>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>>> index 86e52454b5b5..dcf3a536d78a 100644
>>>>>> --- a/drivers/net/virtio_net.c
>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>> @@ -1873,7 +1873,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>>>>>>         */
>>>>>>        if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
>>>>>>                netif_stop_subqueue(dev, qnum);
>>>>>> -             if (!use_napi &&
>>>>>> +             if ((!use_napi || !kick) &&
>>>>>>                    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
>>>>>>                        /* More just got used, free them then recheck. */
>>>>>>                        free_old_xmit_skbs(sq, false);
>>>>> This will work but the following lines are:
>>>>>
>>>>>                         if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
>>>>>                                  netif_start_subqueue(dev, qnum);
>>>>>                                  virtqueue_disable_cb(sq->vq);
>>>>>                          }
>>>>>
>>>>>
>>>>> and I thought we are supposed to keep callbacks enabled with napi?
>>>> This seems to be the opposite logic of commit a7766ef18b33 that
>>>> disables callbacks for NAPI.
>>>>
>>>> It said:
>>>>
>>>>      There are currently two cases where we poll TX vq not in response to a
>>>>      callback: start xmit and rx napi.  We currently do this with callbacks
>>>>      enabled which can cause extra interrupts from the card.  Used not to be
>>>>      a big issue as we run with interrupts disabled but that is no longer the
>>>>      case, and in some cases the rate of spurious interrupts is so high
>>>>      linux detects this and actually kills the interrupt.
>>>>
>>>> My undersatnding is that it tries to disable callbacks on TX.
>>> I think we want to disable callbacks while polling, yes. here we are not
>>> polling, and I think we want a callback because otherwise nothing will
>>> orphan skbs and a socket can be blocked, not transmitting anything - a
>>> deadlock.
>> I'm not sure how I got here, did you mean a partial revert of
>> a7766ef18b33 (the part that disables TX callbacks on start_xmit)?
> Michael, any idea on this?
>
> Thanks


Michael, any comment?

Thanks

