Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4231D4460AE
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 09:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhKEIfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 04:35:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229722AbhKEIfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 04:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636101151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HUz7Uqfcr6vjpPuFN/6PJkrmCB4tUkJaU03BFN22CaE=;
        b=OX6aZtWYtaBTA4SK0N5wHWadhRGoiZ5IX+U7tCen1XoPTDpcEL9id+NBwqjyA0KRj2JdCl
        EfE+WtLUUa/9Oo0JxZy6kK1i5Lcgzsn8aGpoaVG26AMl7c7ZyWz9le1iq1RpMlbtNs9Gr/
        E3OdyCmh3N9/WhmpkzatsM8+iftnQfQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-Gh6OCAD-M1mMwhjhzJNvcA-1; Fri, 05 Nov 2021 04:32:30 -0400
X-MC-Unique: Gh6OCAD-M1mMwhjhzJNvcA-1
Received: by mail-ed1-f69.google.com with SMTP id x13-20020a05640226cd00b003e2bf805a02so7714672edd.23
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 01:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HUz7Uqfcr6vjpPuFN/6PJkrmCB4tUkJaU03BFN22CaE=;
        b=vuWN051CWTiwbcaQjpRYg0iNDTpyOhBV8c4vVewnoJyIWV66cOui9D/2xVafNf7gvS
         FEq6CtJWiCILL1PmxJq/lCQb7vz6nFCgSUV243j9tLzKkDr6rR3nVTJBBH7OZYfLuUd+
         vKKJqpHvlW6dLPrPYEWaQvPrSVL9w6yapmqM7fUBsDuCmD0qEX7Dp6KPRurWFUVlfFuP
         aQ8hLlvzbsb8F0JaHfw02O1lwRugS9chM0JG9i0swTkBJv65wrdtJ0OTG1Jg3hfP595j
         Oqv0Kzj1ekaV48121OdxXyqy3FD5pIVz/+0FeRx5ki07panDbmDdEZEBHDKCtQ1a07w7
         5Q5w==
X-Gm-Message-State: AOAM531opfhJox3tTAOHywMG6fW62hGjiy0wDEggkThmPYBPKAvfHd7J
        S1OA8qQBkoGpTMbvEYqeByU69ZsHRq3/ETdh4saNBaMmwK9GVNXtUmzNTg/pctyJ6V+dR0UHdcc
        yfBruglt5VvwI0ub6
X-Received: by 2002:aa7:c395:: with SMTP id k21mr59826681edq.175.1636101149129;
        Fri, 05 Nov 2021 01:32:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwG6LlOvWNxHc/km/eCAgFIUf26b78WCGDOP8wC0KUlo3tODOpjH30Ptj/aqd85VBUALJi06g==
X-Received: by 2002:aa7:c395:: with SMTP id k21mr59826670edq.175.1636101149017;
        Fri, 05 Nov 2021 01:32:29 -0700 (PDT)
Received: from steredhat (host-87-10-72-39.retail.telecomitalia.it. [87.10.72.39])
        by smtp.gmail.com with ESMTPSA id t15sm3588190ejx.75.2021.11.05.01.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 01:32:27 -0700 (PDT)
Date:   Fri, 5 Nov 2021 09:32:24 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa: Mark vdpa_config_ops.get_vq_notification as
 optional
Message-ID: <20211105083224.5tkhslrswshbynnu@steredhat>
References: <20211104195248.2088904-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211104195248.2088904-1-eperezma@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 08:52:48PM +0100, Eugenio Pérez wrote:
>Since vhost_vdpa_mmap checks for its existence before calling it.
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> include/linux/vdpa.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>index c3011ccda430..0bdc7f785394 100644
>--- a/include/linux/vdpa.h
>+++ b/include/linux/vdpa.h
>@@ -155,7 +155,7 @@ struct vdpa_map_file {
>  *				@vdev: vdpa device
>  *				@idx: virtqueue index
>  *				@state: pointer to returned state (last_avail_idx)
>- * @get_vq_notification:	Get the notification area for a virtqueue
>+ * @get_vq_notification:	Get the notification area for a virtqueue (optional)
>  *				@vdev: vdpa device
>  *				@idx: virtqueue index
>  *				Returns the notifcation area
>-- 
>2.27.0
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

