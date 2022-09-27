Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF4E5ECB89
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 19:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiI0RtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 13:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiI0Rsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 13:48:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146741EF626
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 10:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664300731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dVgPwMiQwWxz9qpcaIbF4/j9KUJT2Ui1z93QE0upqV8=;
        b=BccKNcusmHRW4GlrJZyAE0yKz9RgnLBDwJG+GMpo8P2FAvCgwyeGTjgK4aWmkFZwNXoSZF
        47HZQ+I71ByhZI1FFEhwG8WXdeIhO34x/4aMOVDmBtnpxxplOPx9LtFIVzqAaKNp5Q58da
        6Vt+UL3Uyg/KlA/63yrW/Hyfwh8WcEw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-195-alAUouSQOpumHrkPi0nzhw-1; Tue, 27 Sep 2022 13:45:29 -0400
X-MC-Unique: alAUouSQOpumHrkPi0nzhw-1
Received: by mail-wm1-f69.google.com with SMTP id n7-20020a1c2707000000b003a638356355so5870575wmn.2
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 10:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=dVgPwMiQwWxz9qpcaIbF4/j9KUJT2Ui1z93QE0upqV8=;
        b=nrJjSa9YEKfCFFgHkysTrcnrHM9I8/H8uuSJcGs/JELnxaZPPeAHUMjqKAhDd9Kq7u
         dJuv6C8MQ+VN3EmjnVGiZCK/jEHZz2XPCt2eiaPkqq5+yJJek1IKhiwDxXQLuQ1jJiOb
         ttlMZR401Idc+F65bmmPTdDhD7qS6sSxodnBLW1P3kpHkWU8piMjuT1M7dKBJ3jrr64y
         pTc8zMuPncmGZIjnPzUl3rfoX++4B6fyrKYeIDbaX90MU1tEnY+aIcr6lj3tPM0Tvef0
         UNNUpKrS6ziP4bunkWrd+UVduzLsVf3yI4idqkkb42UitgnbIZcq/z+Y9+lAALxaH8dL
         Si8g==
X-Gm-Message-State: ACrzQf3rDM73HrY3eVpo5/Eetm2J+rKBLuG1tgK0s4/JBsJqyNv1ioU3
        +CoU9MEqRkdvaYho7hdguAIVjgrOV0BimoLvJAtrr/odHqbh22i+RwfyVeToM7HodHtSWFdDx3D
        QFsnzz+R3J0ecxrIy
X-Received: by 2002:adf:fb88:0:b0:22a:f742:af59 with SMTP id a8-20020adffb88000000b0022af742af59mr17905408wrr.230.1664300728149;
        Tue, 27 Sep 2022 10:45:28 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5dw5UsDHXguGm9oaXaX47AcmjEId0lTIHxp/R1KfCc218J6dp6bwNiLDUfGstPRwVpRhUHWg==
X-Received: by 2002:adf:fb88:0:b0:22a:f742:af59 with SMTP id a8-20020adffb88000000b0022af742af59mr17905376wrr.230.1664300727822;
        Tue, 27 Sep 2022 10:45:27 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-222.retail.telecomitalia.it. [79.46.200.222])
        by smtp.gmail.com with ESMTPSA id g14-20020adfe40e000000b0022ae8b862a7sm2328616wrm.35.2022.09.27.10.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 10:45:27 -0700 (PDT)
Date:   Tue, 27 Sep 2022 19:45:21 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <20220927174521.wo5ygmmti2sgwp2d@sgarzare-redhat>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220926134219.sreibsw2rfgw7625@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220926134219.sreibsw2rfgw7625@sgarzare-redhat>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 03:42:19PM +0200, Stefano Garzarella wrote:
>Hi,
>
>On Mon, Aug 15, 2022 at 10:56:03AM -0700, Bobby Eshleman wrote:
>>Hey everybody,
>>
>>This series introduces datagrams, packet scheduling, and sk_buff usage
>>to virtio vsock.
>
>Just a reminder for those who are interested, tomorrow Sep 27 @ 16:00 
>UTC we will discuss more about the next steps for this series in this 
>room: https://meet.google.com/fxi-vuzr-jjb
>(I'll try to record it and take notes that we will share)
>

Thank you all for participating in the call!
I'm attaching video/audio recording and notes (feel free to update it).

Notes: 
https://docs.google.com/document/d/14UHH0tEaBKfElLZjNkyKUs_HnOgHhZZBqIS86VEIqR0/edit?usp=sharing
Video recording: 
https://drive.google.com/file/d/1vUvTc_aiE1mB30tLPeJjANnb915-CIKa/view?usp=sharing

Thanks,
Stefano

