Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3693B6AC5ED
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjCFPwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjCFPwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:52:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326273344C
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 07:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678117888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q86XLZ7Q4ZHp1CUGcCN/NjLhC2ggJRWLx1s//bOcLDM=;
        b=IDGY3v4CGTQZ5idFWVW87EHcy0lVva+Ckm1QP33JE4zD1o0xlMWDuXOwOCDMlbt0PLkbsw
        cuVE2g+sX2EJtbLsfVEBTjN60pf/ea00y0B1DV8muqwcvqkb291HZ7z4hWMKGOsuizk4Rt
        32ElIB+cwlfCStYB3uVtvK3uVAFrA3w=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-gx1-qRXEMyqSOVpOGtTsOA-1; Mon, 06 Mar 2023 10:51:27 -0500
X-MC-Unique: gx1-qRXEMyqSOVpOGtTsOA-1
Received: by mail-qt1-f200.google.com with SMTP id c5-20020ac85185000000b003bfae3b8051so5465071qtn.0
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 07:51:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678117887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q86XLZ7Q4ZHp1CUGcCN/NjLhC2ggJRWLx1s//bOcLDM=;
        b=6NnzL1xwSYRpuZipYP4NrLMjrHDwr2ZFgZQMOol+/2886UULisI03JVv6OIjJ1YQPF
         /wB0s8eYSelTudNWlOkWNxRQwacVJ/HOjd8pLP7Jwr5ubAU6n6jVnDwh/FDq86whizv2
         lGaX9gDzsosqwQ+3xe1oG0ph3UWoJhUxGDm4WNvaDWLtYqq2YWR6ZeWPbEBzgPA26dxz
         f0h/1BGkBfFuUaFKEFiNJ2ubG2Wv8qR7FsfnPpSSG2M0m3RhZvo+IZZTLhmYJvND943y
         Pk9Zba+jr0JEyLMmC86m2QaAHddRegBBO6PAijv3RYYMiRae5+PbVk2W7BbXDW036hfE
         bjzw==
X-Gm-Message-State: AO0yUKUtZkjAD5jpTOPY7jIHdRwaA88Xqxr5i9X87g7GpJ2Wkp8mGDfH
        HKp7rs3i0jRM1wPJBr2WQQgEZ/z0A+7AsTMMrHWz6/ajCIQ20vetQUGMJHDpE9921+UFBKUZjGw
        Z43ukh/tSRhZSWIJC
X-Received: by 2002:a05:622a:c:b0:3b9:bc8c:c207 with SMTP id x12-20020a05622a000c00b003b9bc8cc207mr26969673qtw.18.1678117886721;
        Mon, 06 Mar 2023 07:51:26 -0800 (PST)
X-Google-Smtp-Source: AK7set8J+A3R80v+MVqfE2WCygPas52Ry5LmPSFlnPMQvzMyOQV6nh5+6ZCsftO+pkisfBFlvJJ58Q==
X-Received: by 2002:a05:622a:c:b0:3b9:bc8c:c207 with SMTP id x12-20020a05622a000c00b003b9bc8cc207mr26969642qtw.18.1678117886394;
        Mon, 06 Mar 2023 07:51:26 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id q17-20020ac84111000000b003bfa52112f9sm7805681qtl.4.2023.03.06.07.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 07:51:25 -0800 (PST)
Date:   Mon, 6 Mar 2023 16:51:21 +0100
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
Message-ID: <20230306155121.7xwxzgxtle7qjbnc@sgarzare-redhat>
References: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
 <dfadea17-a91e-105f-c213-a73f9731c8bd@sberdevices.ru>
 <20230306120857.6flftb3fftmsceyl@sgarzare-redhat>
 <b18e3b13-3386-e9ee-c817-59588e6d5fb6@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b18e3b13-3386-e9ee-c817-59588e6d5fb6@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 06:31:22PM +0300, Arseniy Krasnov wrote:
>
>
>On 06.03.2023 15:08, Stefano Garzarella wrote:
>> On Sun, Mar 05, 2023 at 11:07:37PM +0300, Arseniy Krasnov wrote:
>>> In case of SOCK_SEQPACKET all sk_buffs are used once - after read some
>>> data from it, it will be removed, so user will never read rest of the
>>> data. Thus we need to update credit parameters of the socket like whole
>>> sk_buff is read - so call 'skb_pull()' for the whole buffer.
>>>
>>> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> net/vmw_vsock/virtio_transport_common.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Maybe we could avoid this patch if we directly use pkt_len as I
>> suggested in the previous patch.
>Hm, may be we can avoid calling 'skb_pull()' here if 'virtio_transport_dec_rx_pkt()'
>will use integer argument?

Yep, exactly!

>Just call 'virtio_transport_dec_rx_pkt(skb->len)'. skb

It depends on how we call virtio_transport_inc_rx_pkt(). If we use
hdr->len there I would use the same to avoid confusion. Plus that's the
value the other peer sent us, so definitely the right value to increase
fwd_cnt with. But if skb->len always reflects it, then that's fine.

>is never returned to queue to read it again, so i think may be there is no sense for
>extra call 'skb_pull'?

Right!

Thanks,
Stefano

