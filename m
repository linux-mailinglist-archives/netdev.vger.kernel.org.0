Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4335E4E52F9
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244246AbiCWNXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiCWNXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:23:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE3E77CDFD
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648041731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=suvndhg5i90sE3alVpWaoy01Es5EJ/QlvWcm+elPd0I=;
        b=gKnZmccY1DbHQu2UBDe6WX7bI95sTIdY/HAPq/SmYPdnlJPEvM6Jkgn8SMLXn9KA7YLPQ6
        Qqk+CYyTupWrP2ligJhfOjFbB1WYYb/W48qaaxjw1EkSKTSCX5KYySglQcd7Ixmz4cAf4a
        7H6UGx7xPaBdtU1UZoRIAr93IdBF5G4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-XBLtdpCcPCaNp_H2QNkurQ-1; Wed, 23 Mar 2022 09:22:09 -0400
X-MC-Unique: XBLtdpCcPCaNp_H2QNkurQ-1
Received: by mail-wm1-f69.google.com with SMTP id v2-20020a05600c214200b0038c7c02deceso601631wml.8
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:22:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=suvndhg5i90sE3alVpWaoy01Es5EJ/QlvWcm+elPd0I=;
        b=mbbTtnRjBwDIeYAO/qHazrkrvKzSE91gYAMAlZF8rV/KwwBzk9aoEcfD1aEnmWwOUN
         qAxkkmRgm8TNoA68vBpFO2e0FIknzIbT4aVFxNSQ7tW0iV9xKN2piitlf0UBuC8RuIx3
         QUSZxIIrVcVV3um8MImr5PDC38sFPBCFvMOcaXs+USrM9KvCVCHzYMZOYbOkt8Fv8mvx
         i6dgaRnSxuk7kb94xkylHG5FmD5ugUnjvkZweNTeRcE7xVK2t8tghafOokgAucO2RSF/
         xeQp+M+EVVWeV+mh6Rzr10o6VdszjVgieW1S1dXXQLQw00G7wc4137AxOHfijFwLjYdd
         4Swg==
X-Gm-Message-State: AOAM5330IV0nSMD8yq6avS9ITD92YAz8+I3uXG7tgZMmnMuF5sH05vJJ
        ucbLTVdBVV/Ky5np1l52NMIf1oGj//ZaAmLFWobv9hAlcVg+/atvWUOoCmgyyXqwrwPOX8Cuf0C
        5BxtH6sjTDA/XyUQa
X-Received: by 2002:a05:6000:15c7:b0:205:87a2:87bc with SMTP id y7-20020a05600015c700b0020587a287bcmr2861189wry.260.1648041728536;
        Wed, 23 Mar 2022 06:22:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyp9kjUHrJnPA7iyjXS+pAxAeSdHIG+pVsNH4tY9VWV5thpBNO3b44rofEKgNXV0UAniIaJg==
X-Received: by 2002:a05:6000:15c7:b0:205:87a2:87bc with SMTP id y7-20020a05600015c700b0020587a287bcmr2861171wry.260.1648041728292;
        Wed, 23 Mar 2022 06:22:08 -0700 (PDT)
Received: from redhat.com ([2.55.151.118])
        by smtp.gmail.com with ESMTPSA id g17-20020a05600c4ed100b0038ca32d0f26sm4091594wmq.17.2022.03.23.06.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 06:22:06 -0700 (PDT)
Date:   Wed, 23 Mar 2022 09:22:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2 0/3] vsock/virtio: enable VQs early on probe and
 finish the setup before using them
Message-ID: <20220323092118-mutt-send-email-mst@kernel.org>
References: <20220323084954.11769-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323084954.11769-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 09:49:51AM +0100, Stefano Garzarella wrote:
> The first patch fixes a virtio-spec violation. The other two patches
> complete the driver configuration before using the VQs in the probe.
> 
> The patch order should simplify backporting in stable branches.

Ok but I think the order is wrong. It should be 2-3-1,
otherwise bisect can pick just 1 and it will have
the issues previous reviw pointed out.



> v2:
> - patch 1 is not changed from v1
> - added 2 patches to complete the driver configuration before using the
>   VQs in the probe [MST]
> 
> v1: https://lore.kernel.org/netdev/20220322103823.83411-1-sgarzare@redhat.com/
> 
> Stefano Garzarella (3):
>   vsock/virtio: enable VQs early on probe
>   vsock/virtio: initialize vdev->priv before using VQs
>   vsock/virtio: read the negotiated features before using VQs
> 
>  net/vmw_vsock/virtio_transport.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> -- 
> 2.35.1

