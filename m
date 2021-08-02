Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5713DE07C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhHBUMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:12:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhHBUMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:12:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627935124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q52w6Q4YtuhtQOV0oJmgEUraWN88/oaIpPIXQ4cq1HY=;
        b=Fprygj2bHxMbMkyRXS/KSctsun/tyJ9YpHLF1kdjmctPdvFeOyDfc+E4jIorC2+PdfouOr
        s4ESPUNPPkjfV/bq6D1sgHFU4yNCIpgScnqN3oPdFVKIWFxzOn9x31AYNI6cFwbsPOCOMG
        NG7EnwN9VnaO/rrNlplF/DtulmP7w9E=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-TaaBO8qjPFerDDaeR6e6WQ-1; Mon, 02 Aug 2021 16:12:03 -0400
X-MC-Unique: TaaBO8qjPFerDDaeR6e6WQ-1
Received: by mail-ed1-f71.google.com with SMTP id d6-20020a50f6860000b02903bc068b7717so9395325edn.11
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 13:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q52w6Q4YtuhtQOV0oJmgEUraWN88/oaIpPIXQ4cq1HY=;
        b=Fu85b67IsR9TrfxikcSJjT4/ihtCpWtxI8KOWFYqx043VdLRPVSaFb+9GEgebAaJbS
         9Yrybkh/rG+Yx9TkldFQqSLDunoXz2dPcO8fw4mpL15xZ5n1H6hkfJSozxQQbCOcbopL
         uuCw0MEn2cEKFmJfmEDIC8OhZWYiXuB2Rjf1dyGE0GLb3vAstaxrNu4hmi+tsZhhuOO9
         pSb0RRQ5r2aQmJpTkepEFrnwH8UhcNVKF3IFx9LsDBDyb00/LWJadicqVz7wvaMzusCC
         fxIpGCf6kvQt0zhpe0xP+JeflEJDpdfASDqkP/KKn9vJjkPf50zny5E7h6ovcREF8dds
         KVVQ==
X-Gm-Message-State: AOAM531SDrPcrbgXsGehpttcudP93LITC2bbQd7KVZs77oX4pHHI73yS
        WFgrbklX43IcjeqshgI46NQH2TEu8Gv91VBgjs8z5p0LT0GdvA2fPxZgr7PDl8yqUj9cfSWmBdE
        NGYbzV2YpByBUTu7N
X-Received: by 2002:aa7:c0d1:: with SMTP id j17mr21235859edp.217.1627935122739;
        Mon, 02 Aug 2021 13:12:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfr39sns4u7IHD+697IXe7EyNtPI7YycI0ox/3uN10j7vd/YANYQrljcKZhj+LRbcxif46Ug==
X-Received: by 2002:aa7:c0d1:: with SMTP id j17mr21235843edp.217.1627935122638;
        Mon, 02 Aug 2021 13:12:02 -0700 (PDT)
Received: from redhat.com ([2.55.140.205])
        by smtp.gmail.com with ESMTPSA id o7sm4957679ejy.48.2021.08.02.13.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:12:02 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:11:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     fuguancheng <fuguancheng@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org, arseny.krasnov@kaspersky.com,
        andraprs@amazon.com, colin.king@canonical.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] VSOCK DRIVER: Add multi-cid support for guest
Message-ID: <20210802161055-mutt-send-email-mst@kernel.org>
References: <20210802120720.547894-1-fuguancheng@bytedance.com>
 <20210802120720.547894-2-fuguancheng@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802120720.547894-2-fuguancheng@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 08:07:17PM +0800, fuguancheng wrote:
> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> index 3dd3555b2740..0afc14446b01 100644
> --- a/include/uapi/linux/virtio_vsock.h
> +++ b/include/uapi/linux/virtio_vsock.h
> @@ -42,7 +42,8 @@
>  #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
>  
>  struct virtio_vsock_config {
> -	__le64 guest_cid;
> +	__le32 number_cid;
> +	__le64 cids[];
>  } __attribute__((packed));

any host/guest interface change needs to copy the virtio TC.
packing here is a bad idea imho, just add explicit padding.

-- 
MST

