Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586FC4D4B9B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243197AbiCJOVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244318AbiCJOTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:19:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63B03172271
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646921668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Go8Xs3nn4xJMSXzgfTAf+aN/PVriO9262aZwriGw3dc=;
        b=f9gUP17noUr5krSG9qsICGKCmSN24s2TGWWzxY4EGNqxRCAiUgDiNhYHFMQNMavVQmoUbl
        BCKSuUgI+IDeWe+mTQfS1Ghl0yYTmnzeYJWqMVXfY9oWFmTU44JXGk+PPZkaBccFkmnssp
        +onSfv2z9ZHABxG3pYqvFiPZA6wZd0A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-U9nAp1-9O0-7S0TmhRsCBA-1; Thu, 10 Mar 2022 09:14:27 -0500
X-MC-Unique: U9nAp1-9O0-7S0TmhRsCBA-1
Received: by mail-wm1-f69.google.com with SMTP id 3-20020a05600c230300b00384e15ceae4so4110521wmo.7
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:14:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Go8Xs3nn4xJMSXzgfTAf+aN/PVriO9262aZwriGw3dc=;
        b=P317T/xJaV12SV1ihhaCK1RB0wO5Pqan5XAVeQdM1Hq+XhyWs65UVEOO4mZjFNQgNh
         Q84F2EK/Gy/NZ99FWmBp9jdyLkgZphJIGlpOMNcpAJh10BfSswPTEf+zZiCD3fGG+JFi
         rGhhH3+p96tBGFUxHmd8muElz/rOAfucV3xuomXL+ppaBO45Qjr8l8FDlM7c9XBdrViJ
         EWbEkePi1nml+O0h0AX6SVox436nYH2kH+9/sfO7vDpCq8wNxfR6h2g/3MVkCPBjW9HI
         rtFY7BXi8RjOtC6lLygxNjr9ywPtqPQy596NnxNaJppAtBUazH9TAt2GTjh9R0qXSPPm
         uwIQ==
X-Gm-Message-State: AOAM533CTXYDpiYUEeu5XEF6iJgK2hBHN20yZeA/BTIOrU30aOGcRQgD
        K5tStbMFv+k3BtG8e4lKQV3x2gCepMb3wamyF4SGwpLI/5LvUcDMu/1FSslra7YQS2Ss4wXwlx4
        fVfgY47c0UGHhstM/
X-Received: by 2002:a7b:c759:0:b0:389:82c6:ac44 with SMTP id w25-20020a7bc759000000b0038982c6ac44mr11566470wmk.168.1646921664193;
        Thu, 10 Mar 2022 06:14:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJrE6GOOprlJAb2464K/jVRkVAPfidu7mYv+i734cs8hDz4HbESzpyS0sW35U1EuqGVJzrQw==
X-Received: by 2002:a7b:c759:0:b0:389:82c6:ac44 with SMTP id w25-20020a7bc759000000b0038982c6ac44mr11566447wmk.168.1646921663950;
        Thu, 10 Mar 2022 06:14:23 -0800 (PST)
Received: from sgarzare-redhat (host-212-171-187-184.pool212171.interbusiness.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id e18-20020adfdbd2000000b001e4bbbe5b92sm4687989wrj.76.2022.03.10.06.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 06:14:23 -0800 (PST)
Date:   Thu, 10 Mar 2022 15:14:20 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vsock: each transport cycles only on its own sockets
Message-ID: <20220310141420.lsdchdfcybzmdhnz@sgarzare-redhat>
References: <20220310135012.175219-1-jiyong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220310135012.175219-1-jiyong@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 10:50:11PM +0900, Jiyong Park wrote:
>When iterating over sockets using vsock_for_each_connected_socket, make
>sure that a transport filters out sockets that don't belong to the
>transport.
>
>There actually was an issue caused by this; in a nested VM
>configuration, destroying the nested VM (which often involves the
>closing of /dev/vhost-vsock if there was h2g connections to the nested
>VM) kills not only the h2g connections, but also all existing g2h
>connections to the (outmost) host which are totally unrelated.
>
>Tested: Executed the following steps on Cuttlefish (Android running on a
>VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
>connection inside the VM, (2) open and then close /dev/vhost-vsock by
>`exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
>session is not reset.
>
>[1] https://android.googlesource.com/device/google/cuttlefish/
>
>Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
>Signed-off-by: Jiyong Park <jiyong@google.com>
>---
>Changes in v3:
>  - Fixed the build error in vmci_transport.c
>Changes in v2:
>  - Squashed into a single patch
>
> drivers/vhost/vsock.c            | 3 ++-
> include/net/af_vsock.h           | 3 ++-
> net/vmw_vsock/af_vsock.c         | 9 +++++++--
> net/vmw_vsock/virtio_transport.c | 7 +++++--
> net/vmw_vsock/vmci_transport.c   | 5 ++++-
> 5 files changed, 20 insertions(+), 7 deletions(-)

It seems okay now, I ran my test suite and everything seems to be fine:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

