Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB664E5B4B
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 23:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345252AbiCWWix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 18:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345248AbiCWWiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 18:38:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FF279024B
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 15:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648075039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GCO9kWmcJK/zqnHuqkvNPWBBfJrDpoSVizCjP9r818U=;
        b=STYULCXmu/mInbQuHjB3Hebp8QDOz8lWt+82ULzjkkFzptNBQancCg53TG7hCfX32rCKFK
        mnhatWTPJ+f7A3R7hGndq8117VMSuCuLJjhnUSXuRM9RZlxzrnku4vTyvsIDRvdJWJLo1e
        8gzSqk6U/hLqGYMoaLWjQCxi2uPXNlo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-hGnSWDsfN4mt8hWBY-Mx7A-1; Wed, 23 Mar 2022 18:37:17 -0400
X-MC-Unique: hGnSWDsfN4mt8hWBY-Mx7A-1
Received: by mail-wm1-f70.google.com with SMTP id n19-20020a7bcbd3000000b0038c94b86258so1030832wmi.2
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 15:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GCO9kWmcJK/zqnHuqkvNPWBBfJrDpoSVizCjP9r818U=;
        b=3fBJTVx71GUbXq2uyQ20mQCp+cscuNpbiI3oNOutLRTLUMdfgri0gvdQp3npZQQmNK
         nFdJPbRlDFnZSJbVL0VNZYJMnvHk/CcOsjaG11MTs765bvG8PD55PhYoA0rS+i7HROtg
         Pgwt0GZahICNzIsVbUD2c83gwUTV8SIPtm177yy014TJR78LgTMAmjxu3j7qTfS+7LTm
         O5zGfssI3T5/ph6IYgdCf3IUeYm8Lt78GmlCyUya3TMPQddaWV5cq06+1sAex7S18LgS
         Mr7vdO57eaS0oKDujDyf9DFVNf0wsDJV+bkg906qjeS+CDN24/On+wdMZM/jfPm4Cjor
         jRjw==
X-Gm-Message-State: AOAM533Aimk/UwdRhZPRdeIFDcJG11+GgD1J5Orax329NvaC8RsyNnW8
        HBUEAC+WeUntDLvYEPWFVSZi+BLs1A0wpyXSvB54zMbKzrqXSryUObqDpsVJWZeRl6N3qKoMPPi
        z+BPa+ffsMDTs8M82
X-Received: by 2002:adf:9dc3:0:b0:205:7bf0:669f with SMTP id q3-20020adf9dc3000000b002057bf0669fmr1944321wre.4.1648075036542;
        Wed, 23 Mar 2022 15:37:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzf4BMQJkf+iGF0bxSMIgVNRplbXP5vi6oAc/EcslZHs0qUwYj6/T80KpKvYkRJT0LDAxm8Pw==
X-Received: by 2002:adf:9dc3:0:b0:205:7bf0:669f with SMTP id q3-20020adf9dc3000000b002057bf0669fmr1944308wre.4.1648075036322;
        Wed, 23 Mar 2022 15:37:16 -0700 (PDT)
Received: from redhat.com ([2.55.151.118])
        by smtp.gmail.com with ESMTPSA id a18-20020a05600c349200b0038ca453a887sm4944273wmq.19.2022.03.23.15.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 15:37:15 -0700 (PDT)
Date:   Wed, 23 Mar 2022 18:37:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Asias He <asias@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v3 0/3] vsock/virtio: enable VQs early on probe and
 finish the setup before using them
Message-ID: <20220323183657-mutt-send-email-mst@kernel.org>
References: <20220323173625.91119-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323173625.91119-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 06:36:22PM +0100, Stefano Garzarella wrote:
> The first patch fixes a virtio-spec violation. The other two patches
> complete the driver configuration before using the VQs in the probe.
> 
> The patch order should simplify backporting in stable branches.


Series:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> v3:
> - re-ordered the patch to improve bisectability [MST]
> 
> v2: https://lore.kernel.org/netdev/20220323084954.11769-1-sgarzare@redhat.com/
> v1: https://lore.kernel.org/netdev/20220322103823.83411-1-sgarzare@redhat.com/
> 
> Stefano Garzarella (3):
>   vsock/virtio: initialize vdev->priv before using VQs
>   vsock/virtio: read the negotiated features before using VQs
>   vsock/virtio: enable VQs early on probe
> 
>  net/vmw_vsock/virtio_transport.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> -- 
> 2.35.1

