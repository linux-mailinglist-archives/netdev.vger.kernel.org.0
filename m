Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA316AC7C1
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjCFQXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjCFQWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:22:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2299B3773A
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 08:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678119540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d9yibYb7BiHv8VUJHHc1xSbchMTl79O8SC4SNRlYdVk=;
        b=abp2wcxqSftJL+H4L9taMDXkF0ej5wSKRB6TMmIm5pp4wG5I7EkDMLDCbjfc6UCpr6M3Hi
        gswnAN1o7Z8xG+Gs6WsM2Tvny23fO1w/FjrFslLHkAO9+tIHPttvL70z5Vi35Qspixmimw
        EXkG9kKMlR69uh0n7p/y/oxDNWzO5jo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-CkCnu-N6P0Kd3UHx_ED1dw-1; Mon, 06 Mar 2023 11:18:57 -0500
X-MC-Unique: CkCnu-N6P0Kd3UHx_ED1dw-1
Received: by mail-qk1-f200.google.com with SMTP id d10-20020a05620a240a00b0073baf1de8ebso5668964qkn.19
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 08:18:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678119537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9yibYb7BiHv8VUJHHc1xSbchMTl79O8SC4SNRlYdVk=;
        b=oSCQQrLS4E6bTduubh9tBhP8EfgGtroA/EGd0E+N7jQRDWM2cXYKQT31UJC9J4lwvq
         AsJR2wX6gkNgrYvbnjuWoBzWARDZ+b7/KkwZRzOe3lXMGOqWudcrIdpwkt/cKiHkIkna
         m314thSSfQE02yU7KocQEtiIFedC95WTwREvhoVrxr0uSWePJ9N6cQ4GwWDMva0PeS6X
         223ulL5hL0UOB7NWdWCBKNAv1aGT9+JBNiBHoqiLLhRnxt7y0TcsVrNO9rV3DpG0kX/e
         IRVXtldiU1qBgFwtkN53PUURurpb9csi1PQJRDSwYp5Q1Nbt4Uj1dRk3UEFC0XJnx5pw
         dDOw==
X-Gm-Message-State: AO0yUKU7A2FWGBxjHIbV13u9b5CYpD3pnNJB1Hx1Re234eGNZbOb6DJT
        B+tbxpY0pbam7w/r9EdZqhmERkJps4M6tiY1TQqEmx7zgE1RkPWDsl2FChZpzIK6bboutWIkabP
        TNB0XBwaGWr+3GMYH
X-Received: by 2002:ac8:57c4:0:b0:3bf:c7ac:37e4 with SMTP id w4-20020ac857c4000000b003bfc7ac37e4mr21646907qta.53.1678119536888;
        Mon, 06 Mar 2023 08:18:56 -0800 (PST)
X-Google-Smtp-Source: AK7set8J4YE/RXJjUhe6KmcGADN++XZIQZ5a1lW56p6P5SGInNCKdizbMZ77Gy1LukOOT+Xou8kNBQ==
X-Received: by 2002:ac8:57c4:0:b0:3bf:c7ac:37e4 with SMTP id w4-20020ac857c4000000b003bfc7ac37e4mr21646869qta.53.1678119536628;
        Mon, 06 Mar 2023 08:18:56 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id l5-20020ac87245000000b003b9a426d626sm7744060qtp.22.2023.03.06.08.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:18:56 -0800 (PST)
Date:   Mon, 6 Mar 2023 17:18:52 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 2/4] virtio/vsock: remove all data from sk_buff
Message-ID: <20230306161852.4s7qf4qm3fnwjck7@sgarzare-redhat>
References: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
 <dfadea17-a91e-105f-c213-a73f9731c8bd@sberdevices.ru>
 <20230306120857.6flftb3fftmsceyl@sgarzare-redhat>
 <b18e3b13-3386-e9ee-c817-59588e6d5fb6@sberdevices.ru>
 <20230306155121.7xwxzgxtle7qjbnc@sgarzare-redhat>
 <9b882d45-3d9d-c44d-a172-f23fff54962b@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9b882d45-3d9d-c44d-a172-f23fff54962b@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 07:00:10PM +0300, Arseniy Krasnov wrote:
>
>
>On 06.03.2023 18:51, Stefano Garzarella wrote:
>> On Mon, Mar 06, 2023 at 06:31:22PM +0300, Arseniy Krasnov wrote:
>>>
>>>
>>> On 06.03.2023 15:08, Stefano Garzarella wrote:
>>>> On Sun, Mar 05, 2023 at 11:07:37PM +0300, Arseniy Krasnov wrote:
>>>>> In case of SOCK_SEQPACKET all sk_buffs are used once - after read some
>>>>> data from it, it will be removed, so user will never read rest of the
>>>>> data. Thus we need to update credit parameters of the socket like whole
>>>>> sk_buff is read - so call 'skb_pull()' for the whole buffer.
>>>>>
>>>>> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>>> ---
>>>>> net/vmw_vsock/virtio_transport_common.c | 2 +-
>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> Maybe we could avoid this patch if we directly use pkt_len as I
>>>> suggested in the previous patch.
>>> Hm, may be we can avoid calling 'skb_pull()' here if 'virtio_transport_dec_rx_pkt()'
>>> will use integer argument?
>>
>> Yep, exactly!
>>
>>> Just call 'virtio_transport_dec_rx_pkt(skb->len)'. skb
>>
>> It depends on how we call virtio_transport_inc_rx_pkt(). If we use
>> hdr->len there I would use the same to avoid confusion. Plus that's the
>> value the other peer sent us, so definitely the right value to increase
>> fwd_cnt with. But if skb->len always reflects it, then that's fine.
>i've checked 'virtio_transport_rx_work()', it calls 'virtio_vsock_skb_rx_put()' which
>sets 'skb->len'. Value is used from header, so seems 'skb->len' == 'hdr->len' in this
>case.

Thank you for checking it.

However, I still think it is better to use `hdr->len` (we have to assign 
it to `pkt_len` anyway, as in the proposal I sent for patch 1), 
otherwise we have to go every time to check if skb_* functions touch 
skb->len.

E.g. skb_pull() decrease skb->len, so I'm not sure we can call 
virtio_transport_dec_rx_pkt(skb->len) if we don't remove `skb_pull(skb, 
bytes_to_copy);` inside the loop.

Thanks,
Stefano

