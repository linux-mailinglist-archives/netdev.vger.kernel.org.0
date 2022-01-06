Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990AA486450
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238766AbiAFMYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:24:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238475AbiAFMYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641471893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0uPOPPljcCRT5JnCSjBYTsAZ9QvLUTF6yXLYqezm/jk=;
        b=TRiXqEUxE7KuA99lKmqzrqDNxkNScZCWtrXHJ5qdEN3IgQU2/Z+45eaRWHxwO0FRXamXEj
        PJEDiNefTlhZ8x5WRkGSg6x0K8iZEBj287/POrc1Rp1+pnD8MO8YSiVLUgkGH2eNeoMF0F
        dBeTdhs5r+ovRH6e3Pg47cESHf7UNKU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-v2pzn08sNQqGuq2MZL-NFw-1; Thu, 06 Jan 2022 07:24:52 -0500
X-MC-Unique: v2pzn08sNQqGuq2MZL-NFw-1
Received: by mail-wr1-f72.google.com with SMTP id h12-20020adfa4cc000000b001a22dceda69so1177851wrb.16
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 04:24:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0uPOPPljcCRT5JnCSjBYTsAZ9QvLUTF6yXLYqezm/jk=;
        b=KrXSyspAWryQI9E7HN99KKbS88kDp5bDZ7J9YcjvmscRbgnCQG2Gho5iaxOxLRNAgJ
         3OWCZiUoZsNj/HtMVok1VyRfOzJpMSbwzokB0y+BlI8bNTFrSMconKocjFtyLVYDblkn
         mzW0mptGNotTm0qVh23cku70CZnrm0jJMdipETToJx5PEjK9O/ruPmAyI7OtWBvoURYl
         IzC/fhFNhc8dPJiePLBWeu8zc1cOV+ZgOFgNM96j2J2mnWkFeJ0/3gkdu4uyeM4oFp+8
         54KK8+AsW8PAeQbHvr0vGcTIT2ORXVrhUgA4uPKtZrUP8sfpevByju/8hYXkhIANrz3/
         f2Ww==
X-Gm-Message-State: AOAM532eJHSSg66z+812s1WCB16E4OAnztbjTwT5Tm9t+xmm3Ey2yG46
        L6drgxN0Pg7DlCXEWq/JepAuTIyjfqEODk3l9DxyDXoAI2zXP9w/WFtpN3YKmqhyLnKpQonFLCZ
        C7ynGrG9kCEMUD5VT
X-Received: by 2002:adf:f904:: with SMTP id b4mr31756835wrr.457.1641471890970;
        Thu, 06 Jan 2022 04:24:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxcnYl5f7mjbdHhw5BDaaDbej/KBrzommpeO6kEVNqKU1TlflODCHM/SPqrxpiLKr97ZxWBog==
X-Received: by 2002:adf:f904:: with SMTP id b4mr31756826wrr.457.1641471890799;
        Thu, 06 Jan 2022 04:24:50 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:207e:991b:6857:5652:b903:a63b])
        by smtp.gmail.com with ESMTPSA id l8sm1945393wrv.25.2022.01.06.04.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 04:24:49 -0800 (PST)
Date:   Thu, 6 Jan 2022 07:24:47 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     jasowang@redhat.com, leon@kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] vhost: add vhost_test to Kconfig & Makefile
Message-ID: <20220106072352-mutt-send-email-mst@kernel.org>
References: <20210617033844.1107-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617033844.1107-1-caihuoqing@baidu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 11:38:44AM +0800, Cai Huoqing wrote:
> When running vhost test, make it easier to config
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

I'd stick this under Kernel Testing and Coverage or something like this.
The point being we don't want this in release kernels by mistake.

> ---
>  drivers/vhost/Kconfig  | 11 +++++++++++
>  drivers/vhost/Makefile |  3 +++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 587fbae06182..ac2bffd6a501 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -61,6 +61,17 @@ config VHOST_VSOCK
>         To compile this driver as a module, choose M here: the module will be called
>         vhost_vsock.
>  
> +config VHOST_TEST
> +       tristate "vhost virtio-test driver"
> +       depends on EVENTFD
> +       select VHOST
> +       help
> +       This kernel module can be loaded in the host kernel to test vhost function
> +       with tools/virtio-test.
> +
> +       To compile this driver as a module, choose M here: the module will be called
> +       vhost_test.
> +
>  config VHOST_VDPA
>         tristate "Vhost driver for vDPA-based backend"
>         depends on EVENTFD
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index f3e1897cce85..cf31c1f2652d 100644
> --- a/drivers/vhost/Makefile
> +++ b/drivers/vhost/Makefile
> @@ -8,6 +8,9 @@ vhost_scsi-y := scsi.o
>  obj-$(CONFIG_VHOST_VSOCK) += vhost_vsock.o
>  vhost_vsock-y := vsock.o
>  
> +obj-$(CONFIG_VHOST_TEST) += vhost_test.o
> +vhost_test-y := test.o
> +
>  obj-$(CONFIG_VHOST_RING) += vringh.o
>  
>  obj-$(CONFIG_VHOST_VDPA) += vhost_vdpa.o
> -- 
> 2.22.0

