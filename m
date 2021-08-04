Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE793E0414
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhHDPYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:24:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238324AbhHDPYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628090634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FOnK+veu0wWChnkChEJGDHGZFXwH5RbR5XEsiBmdrMU=;
        b=a+2sCDTbEWPU6D5Ukc1TzLovbElEa39QaZG53MVxV+Hvbb1OiydwMIJYBNYR1rfxHiFqSz
        CXW9Jzli7NWQsg78yHIRlo07IoUxWR+xDxABF1w3tjTl0noREdhQ47eiCwyWouwevkOP6Y
        tg/Ce+oWPy3Z+yh5cHr8dzOd7DxaGzE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-IAW3ZCSzOAmOnfR3UVQX4w-1; Wed, 04 Aug 2021 11:23:53 -0400
X-MC-Unique: IAW3ZCSzOAmOnfR3UVQX4w-1
Received: by mail-ej1-f70.google.com with SMTP id k21-20020a1709062a55b0290590e181cc34so960648eje.3
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 08:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FOnK+veu0wWChnkChEJGDHGZFXwH5RbR5XEsiBmdrMU=;
        b=QuiOw4dJOjYEbsBFL48noWlfMhE4WLvp4RWe/F/N2pdkgYTAKroUdqw0XP4t0M33zn
         qRhXQwJcpT7OUgcrXyurRyGyDLi+YxrAVIdPN/ki8PCrR38U0MZeujRw6vfWyd/+qAmx
         4eP/aWuFZYHHdLv50Ai27tmizFggTCvkzJU10pngYA5sonEPqUzPY00+/v/T3mDhIQCY
         bFKYWPqW3UMectv0CoGPEm/RyNRQNOlXMgSKUkyeYOeqWRSKJuib7l1WemIIpgFaY7F4
         IEwCBaWkzjDS550vChbmXe/AtQKXhBGdhVQy/591RRJSvgkqWshfJN11xMNBtMYsO6Zw
         1eYg==
X-Gm-Message-State: AOAM533PYDNeh4c02LT17igHCPNoCy/QfnXdPV54MDeiOhv8AicetKxM
        N2+uOb/pwLwUqbCp4h8CyLd4javRrwmSuKYx3YzTQLxTJtcRvhm3rSwKsK3oxL3SDoS0HpDXjCy
        104S0RFfRnX/ARrNH
X-Received: by 2002:a05:6402:184b:: with SMTP id v11mr279741edy.267.1628090631912;
        Wed, 04 Aug 2021 08:23:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/39HeEjVjl3cpnIoTdSCpE59bH+X7ttEEVWnEzeo9TkvSQoRZJeV8fS+jTMea1+k26xJCDw==
X-Received: by 2002:a05:6402:184b:: with SMTP id v11mr279724edy.267.1628090631769;
        Wed, 04 Aug 2021 08:23:51 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id nd14sm736547ejc.113.2021.08.04.08.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:23:51 -0700 (PDT)
Date:   Wed, 4 Aug 2021 17:23:49 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     =?utf-8?B?5YKF5YWz5Lie?= <fuguancheng@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, jasowang@redhat.com,
        stefanha@redhat.com, davem@davemloft.net, kuba@kernel.org,
        arseny.krasnov@kaspersky.com, andraprs@amazon.com,
        Colin King <colin.king@canonical.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [External] Re: [PATCH 0/4] Add multi-cid support for vsock driver
Message-ID: <20210804152349.o4vh233xjdruh4pv@steredhat>
References: <20210802120720.547894-1-fuguancheng@bytedance.com>
 <20210802134251.hgg2wnepia4cjwnv@steredhat>
 <CAKv9dH5KbN25m8_Wmej9WXgJWheRV5S-tyPCdjUHHEFoWk-V1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKv9dH5KbN25m8_Wmej9WXgJWheRV5S-tyPCdjUHHEFoWk-V1w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 03:09:41PM +0800, 傅关丞 wrote:
>Sorry I cannot figure out a good use case.
>
>It is normal for a host to have multiple ip addresses used for
>communication.
>So I thought it might be nice to have both  host and guest use multiple
>CIDs for communication.
>I know this is not a very strong argument.

Maybe there could be a use case for guests (which I don't see now), but 
for the host it seems pointless. The strength of vsock is that the guest 
knows that using CID=2 always reaches the host.

Moreover we have recently merged VMADDR_FLAG_TO_HOST that when set 
allows you to forward any packet to the host, regardless of the CID (not 
yet supported by vhost-vsock).

>
>The vsock driver does not work if one of the two peers doesn't support
>multiple CIDs.

This is absolutely to be avoided.

I think the virtio device feature negotiation can help here.

>
>I have a possible solution here, but there may be some problems with it
>that I haven't noticed.
>
>Hypervisors will use different ways to send CIDs setup to the kernel based
>on their vsock setup.
>
>------For host-------
>If host vsock driver supports multi-cid, the hypervisor will use the
>modified VHOST_VSOCK_SET_GUEST_CID call to set its CIDs.
>Otherwise, the original call is used.
>
>------For guest-------
>Now the virtio_vsock_config looks like this:
>u64 guest_cid
>u32 num_guest_cid;
>u32 num_host_cid;
>u32 index;
>u64 cid;
>
>If the guest vsock driver supports multi-cid, it will read num_guest_cid
>and num_host_cid from the device config space.
>Then it writes an index register, which is the cid it wants to read.  After
>hypervisors handle this issue, it can read the cid
>from the cid register.
>
>If it does not support multi-cid, it will just read the guest_cid from the
>config space, which should work just fine.
>

Why not add a new device feature to enable or disable multi-cid?


>
>-------Communication--------
>For communication issues, we might need to use a new feature bit.  Let's
>call it VHOST_VSOCK_SUPPORT_MULTI_CID.
>The basic idea is that this feature bit is set when both host and guest
>support using multiple CIDs.  After negotiation, if the feature bit
>is set, the host can use all the CIDs specified to communicate with the
>guest.  Otherwise, the first cid passed in will
>be used as the guest_cid to communicate with guests.

I think the same feature bit can be used for the virtio_vsock_config, 
no?

>
>Also, if the bit is set for guests, all the CIDs can be used to communicate
>with the host.  Otherwise, the first cid with index 0 will be
>used as the guest_cid while the VMADDR_HOST_CID will be used for host cid.

We already have VMADDR_FLAG_TO_HOST to forward all packets to the host, 
we only need to support in some way in vhost-vsock.

Thanks,
Stefano

