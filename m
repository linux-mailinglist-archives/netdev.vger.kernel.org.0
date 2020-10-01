Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9640427FF6C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 14:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732144AbgJAMqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 08:46:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732016AbgJAMqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 08:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601556401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Js563GcaR2/yt5ZRRb4g7uvZTFa1RVtXs31pHNFBFkg=;
        b=bQFOVF8MlVPdNT4+woGI4eYk4tfRH9aSS0oC53vFrattcxxc9f0olUSdpYx1EQfvXAJBm0
        CA6Ps3eGzLbKLG9ap053EnFcFB1etIp4gmSR4VpZhHs6SVMs8HcJGD+1/NhREl+1j7MX/d
        P2nmjCcUQNY+Oedj2W2JH1EQe/Yzfyg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-YnuUGVA2M52bVJ166J0uhg-1; Thu, 01 Oct 2020 08:46:36 -0400
X-MC-Unique: YnuUGVA2M52bVJ166J0uhg-1
Received: by mail-wm1-f71.google.com with SMTP id t10so858721wmi.9
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 05:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Js563GcaR2/yt5ZRRb4g7uvZTFa1RVtXs31pHNFBFkg=;
        b=pmGCYJL/jWCpqOiGNmR+7faYgC1lA/B7oY+OP9LPQBz2ajW0kAtw1pFNFmSDCaV5qp
         4gR4NwDJRcD+qTtZ+di5v5J/EcSyZSMk2V2LnqpcL3UkB4h7OEx/3os6nqC+SCuGPE7L
         DQIko3LuTQNQ2oeww2O7+jGTykJ8uW3s3I6CBcpuzmUelNbbCwq8Ga3oZMz7IZ3ri3Xa
         b1oxM3V3LcUf/UAAllQspfNvLmgYLCo4wVNkI7JdpXl6v8yzelJdYaTumfYMxE2vm34L
         ehuPl1JrHMtex6EZ3uHzZF8aNkMxUy5moQZgfp5Fv4dW2FwE9YltTujQgq++Oi3W2fok
         mPIQ==
X-Gm-Message-State: AOAM532vHtmeD5Phy0atppiJbK6NEctGA8Lt4MYG+OA4YIVJ+DjvTpMk
        wZfBab75L3KlTibfhjGRsVjLaOliHCEm9t7xS5zYOEt/pcEWnHYbTuMm0NLJV2Bym+19EhQAauj
        HSxrJOjDy90RKayE0
X-Received: by 2002:a7b:c774:: with SMTP id x20mr2389447wmk.102.1601556394412;
        Thu, 01 Oct 2020 05:46:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzH6EuErZXThHeJ05UE72wy3Fr8fkLJJnHtXxx76BlpIz/RYUHWaHYI9cBE1T6i8tXzrTOyqA==
X-Received: by 2002:a7b:c774:: with SMTP id x20mr2389421wmk.102.1601556394184;
        Thu, 01 Oct 2020 05:46:34 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id y1sm8480045wma.36.2020.10.01.05.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:46:33 -0700 (PDT)
Date:   Thu, 1 Oct 2020 08:46:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 0/2] vhost: Skip access checks on GIOVAs
Message-ID: <20201001084608-mutt-send-email-mst@kernel.org>
References: <160139701999.162128.2399875915342200263.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160139701999.162128.2399875915342200263.stgit@bahia.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 06:30:20PM +0200, Greg Kurz wrote:
> This series addresses some misuse around vring addresses provided by
> userspace when using an IOTLB device. The misuse cause failures of
> the VHOST_SET_VRING_ADDR ioctl on POWER, which in turn causes QEMU
> to crash at migration time.
> 
> While digging some more I realized that log_access_ok() can also be 
> passed a GIOVA (vq->log_addr) even though log_used() will never log
> anything at that address. I could observe addresses beyond the end
> of the log bitmap being passed to access_ok(), but it didn't have any
> impact because the addresses were still acceptable from an access_ok()
> standpoint. Adding a second patch to fix that anyway.
> 
> Note that I've also posted a patch for QEMU so that it skips the used
> structure GIOVA when allocating the log bitmap. Otherwise QEMU fails to
> allocate it because POWER puts GIOVAs very high in the address space (ie.
> over 0x800000000000000ULL).
> 
> https://patchwork.ozlabs.org/project/qemu-devel/patch/160105498386.68108.2145229309875282336.stgit@bahia.lan/

I queued this. Jason, can you ack please?

> v2:
>  - patch 1: move the (vq->ioltb) check from vhost_vq_access_ok() to
>             vq_access_ok() as suggested by MST
>  - patch 2: new patch
> 
> ---
> 
> Greg Kurz (2):
>       vhost: Don't call access_ok() when using IOTLB
>       vhost: Don't call log_access_ok() when using IOTLB
> 
> 
>  drivers/vhost/vhost.c |   32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
> 
> --
> Greg

