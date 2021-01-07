Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0460B2ED11E
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 14:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbhAGNrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 08:47:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728026AbhAGNrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 08:47:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610027135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G6uWpqlwSVKh90kRGilN8ra4QedFEQSfInlrRXbuegk=;
        b=GTaKgLpFzml9X+zkgpKz+1CUgsaqta7GjaSFh9FeSCuiXc+d+eKqGLsR/9C2bAeaNrbJbM
        bru7yueG0Y9eIu4jikmWjug2GL8KpoAs30Aq3QjQ8/WC1m3qZlG1m3bpUScDLWYSLsdy55
        dJ7NYoOCNf13gh45I9LQHuX0e2w821U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-exIDBZjiNAipGzkSgPwCZw-1; Thu, 07 Jan 2021 08:45:32 -0500
X-MC-Unique: exIDBZjiNAipGzkSgPwCZw-1
Received: by mail-wr1-f71.google.com with SMTP id v7so2662006wra.3
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 05:45:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G6uWpqlwSVKh90kRGilN8ra4QedFEQSfInlrRXbuegk=;
        b=PCibniOqcTocb6nj/OHNBw3UgeK5HPdj4y01sGaDz4bAMqrRWgM8wDcU3jzyoUYKRo
         hcMwO/1gsO6VgUdiLDF5Y5ChdEgx+rKVnS0GCPIKL02/shDEMXqcCxDRLYjsGQcdw5R7
         CuGeo5djbvhe//OeiInpNwUyrZqKU7YCgyVFY54fwibS1RyRDxX54852DkBnGZJhcXvy
         XbORRzHxX9icO/FBD9xbrlyIyHswl1G5mtMAl5fIOda9kQkATo8VENb75DWiK0GEgKDu
         YdELLkWFVbXE4x5TLghNmxsZWqo8f2H87iGEBfcUPjZ/jwUA0D3ZhyZ5vEiey96vRpTa
         +ToQ==
X-Gm-Message-State: AOAM530wLs8+A9Qzy89NvPqZo5CMOzTpDSjBL2lEh2d/im/EmTHIgE39
        XVzDK+uQcI7wX56gVCM5InLwDRYAHJreSuAIrFnGFwb+V+/NHkatzt6ZAbxTHl6PthWlcVHt2YK
        1vRFAo2Kn6ZCHeRgy
X-Received: by 2002:a5d:674c:: with SMTP id l12mr8926396wrw.399.1610027131332;
        Thu, 07 Jan 2021 05:45:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyA2UrtrIHsH2Ay8M5rV/B/Zag5MzLoAwcRGNIv5Kptx1Fsqxqz6UWeR//a5TyGmHyZ+dnixA==
X-Received: by 2002:a5d:674c:: with SMTP id l12mr8926389wrw.399.1610027131153;
        Thu, 07 Jan 2021 05:45:31 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id v1sm7998471wrr.48.2021.01.07.05.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 05:45:30 -0800 (PST)
Date:   Thu, 7 Jan 2021 14:45:28 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        elic@nvidia.com, mst@redhat.com
Subject: Re: [PATCH linux-next v3 1/6] vdpa_sim_net: Make mac address array
 static
Message-ID: <20210107134528.uw72mstpdorhcyvg@steredhat>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
 <20210105103203.82508-2-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210105103203.82508-2-parav@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 12:31:58PM +0200, Parav Pandit wrote:
>MAC address array is used only in vdpa_sim_net.c.
>Hence, keep it static.
>
>Signed-off-by: Parav Pandit <parav@nvidia.com>
>Acked-by: Jason Wang <jasowang@redhat.com>
>---
>Changelog:
>v1->v2:
> - new patch
>---
> drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>index c10b6981fdab..f0482427186b 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>@@ -33,7 +33,7 @@ static char *macaddr;
> module_param(macaddr, charp, 0);
> MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
>
>-u8 macaddr_buf[ETH_ALEN];
>+static u8 macaddr_buf[ETH_ALEN];
>
> static struct vdpasim *vdpasim_net_dev;
>
>-- 
>2.26.2
>
>_______________________________________________
>Virtualization mailing list
>Virtualization@lists.linux-foundation.org
>https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

