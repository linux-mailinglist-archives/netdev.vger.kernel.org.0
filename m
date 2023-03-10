Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F71A6B39F8
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCJJQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCJJPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:15:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01D1591FE
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678439383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lsjkU85N4FNU0o/oNblF3pwjNhend/N5SR9L0EvjGbM=;
        b=YvQens3gt3YhCJ2axli3ECG5T+uIT9IRuXryPdwmnsPWsgwXccpBEmV+88Gi3BbAmdJ8Mc
        qSnu7u0agmcOHvGgGcAXDGgLjzA/ijRiKCF9vxoCqAR7XHMnPHji49zg7MGljGYsfzo9ir
        8TKNAMbn9Uq/cHrvFPGw0avnm5rw3Nk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-YsGVL1wqMKS0t01-hX5WXQ-1; Fri, 10 Mar 2023 04:09:42 -0500
X-MC-Unique: YsGVL1wqMKS0t01-hX5WXQ-1
Received: by mail-wr1-f70.google.com with SMTP id y11-20020a056000168b00b002ce179d1b90so923722wrd.23
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678439381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lsjkU85N4FNU0o/oNblF3pwjNhend/N5SR9L0EvjGbM=;
        b=LBYW8CCbdnGXdQ6lv9CtVT2nfSd3TLLYtfAcDTWRKUal+kHVbefCRDAHI8hsruPeSP
         p1ly81QOexUm2JElFeOmXZ29uCK4rrUITkKKNSX1075A0GPLVibUivLyeFUICU0m9uAi
         fLiIqSwpeZ495O6bbW96Cj31DpVaVcJ4SjTw9EmcjhFNkkgyczPEL6EFJ10GnWrVypuO
         RfvYTDQ0CasFyR4GkjiTZPnieP6EalUUge+TASS7i26L3x1ZQ1tKee9sD588rY0HP0ub
         81+rBNxDaG4KjbBGg2RTL6d46qN9tG3yXWwGYWyz0f+WZQHr/dQuavNS/OfB3IMF6Tr9
         81qg==
X-Gm-Message-State: AO0yUKWBhKJQZtV/hCFRLoyKy+aLzaw5VDcrN3AHKCa53QslOAM9RJuG
        s+mmf/JZ5LFwtLGmLiS53J4y0SAuHD5BW07wigfR63NMcEljMVkoEATuQ/up9wsMIq6i/Xd808J
        /2ln+TV7mdOXjaJIB
X-Received: by 2002:a05:600c:5493:b0:3ea:edc7:aa59 with SMTP id iv19-20020a05600c549300b003eaedc7aa59mr1966006wmb.32.1678439381604;
        Fri, 10 Mar 2023 01:09:41 -0800 (PST)
X-Google-Smtp-Source: AK7set82DcNAbEYxkRgzwkXhtStyGRG6ScEq9WaLV3HetEFKZK8m0CtX+X41h5pDK46UpFBKYqStZQ==
X-Received: by 2002:a05:600c:5493:b0:3ea:edc7:aa59 with SMTP id iv19-20020a05600c549300b003eaedc7aa59mr1965990wmb.32.1678439381344;
        Fri, 10 Mar 2023 01:09:41 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id n12-20020a5d67cc000000b002c8476dde7asm1539421wrw.114.2023.03.10.01.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 01:09:40 -0800 (PST)
Date:   Fri, 10 Mar 2023 10:09:37 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 0/4] several updates to virtio/vsock
Message-ID: <20230310090937.s55af2fx56zn4ewu@sgarzare-redhat>
References: <1804d100-1652-d463-8627-da93cb61144e@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1804d100-1652-d463-8627-da93cb61144e@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseniy,

On Thu, Mar 09, 2023 at 11:24:42PM +0300, Arseniy Krasnov wrote:
>Hello,
>
>this patchset evolved from previous v2 version (see link below). It does
>several updates to virtio/vsock:
>1) Changes 'virtio_transport_inc/dec_rx_pkt()' interface. Now instead of
>   using skbuff state ('head' and 'data' pointers) to update 'fwd_cnt'
>   and 'rx_bytes', integer value is passed as an input argument. This
>   makes code more simple, because in this case we don't need to update
>   skbuff state before calling 'virtio_transport_inc/dec_rx_pkt()'. In
>   more common words - we don't need to change skbuff state to update
>   'rx_bytes' and 'fwd_cnt' correctly.
>2) For SOCK_STREAM, when copying data to user fails, current skbuff is
>   not dropped. Next read attempt will use same skbuff and last offset.
>   Instead of 'skb_dequeue()', 'skb_peek()' + '__skb_unlink()' are used.
>   This behaviour was implemented before skbuff support.
>3) For SOCK_SEQPACKET it removes unneeded 'skb_pull()' call, because for
>   this type of socket each skbuff is used only once: after removing it
>   from socket's queue, it will be freed anyway.

thanks for the fixes, I would wait a few days to see if there are any
comments and then I think you can send it on net without RFC.

@Bobby if you can take a look, your ack would be appreciated :-)

Thanks,
Stefano

