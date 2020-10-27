Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6903429A79C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 10:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394889AbgJ0JSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 05:18:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404499AbgJ0JSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 05:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603790290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PP9XfWWYs/ZL8eWntPMtO6Zbh5hoxUuR0KDIP5S05yQ=;
        b=iL1e1B1YBFAgIn+M8SLjs5oBL1jF1xLpp+UMRwAjMWBu83weKYyJF6BGMixi0Bbb6WgcZ1
        3eLbTHHw1HerMN1qlPNy67NZC3c/xEuCOvTvKh4Hn+6DIcMZoGcBfYnSi9o+qFRaEHnxrP
        h984oQxqy0mU+8fZxq76UXbKMSN0lKY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-_uUUtHq6PeiJuSqNTA_KWA-1; Tue, 27 Oct 2020 05:18:09 -0400
X-MC-Unique: _uUUtHq6PeiJuSqNTA_KWA-1
Received: by mail-wm1-f69.google.com with SMTP id l17so197871wmb.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 02:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PP9XfWWYs/ZL8eWntPMtO6Zbh5hoxUuR0KDIP5S05yQ=;
        b=TFpGQ3dE3lmMzvfw3hlJ2WQRyHd7QfvLnXkLwBzX8v4L87K6vHMTygPGFA1vBAt+Er
         3hgPd0D/XOVUgpBcp4Vzb3dHkWwT7Md1B8WNxREAQQk9tmLLBWV1tQNHO8OuP6z8/G/W
         fkpr3ST5Md89O6HFNUdbGeEz3WgxlFZ27oBAPvIBLa1Oul/SpC+elg6fEIxI0FH/buK4
         6LHORQzYGhgOe2djyOjR9tdlBRLeqPqYge8xDAY8aHpeZScN/23WJYO+SbPkUvI9FUln
         3h2zdTQZf6sZlOm1hULg7Wb/TtJ/llyXXxU/QwGtc7pzkyEQQv1n6EQ5WoDGdGC7+KI8
         T0ZQ==
X-Gm-Message-State: AOAM5305LEOljjaPrKjYoHElVcFgM4JNcpsAyn/vizZZxeuiJ+Fnl7qU
        haKrEW30q+NnJm4zl9iWN6xdYx8G0WBxp8pVvAlm7dsaq2D4w+vS5Ehn2mHrk7wCpDkL+9a2Tdc
        lFciL6NgsohzZoQ+S
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr1612042wmo.143.1603790287167;
        Tue, 27 Oct 2020 02:18:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIilyoqRxGaUl7p9JKTfBssuH7mohx3h+nf+wqghU8Ac68i7Wh1Yp/SFLOvnj3tU5GpJwc5Q==
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr1612024wmo.143.1603790286960;
        Tue, 27 Oct 2020 02:18:06 -0700 (PDT)
Received: from steredhat (host-79-17-248-215.retail.telecomitalia.it. [79.17.248.215])
        by smtp.gmail.com with ESMTPSA id x64sm1166853wmg.33.2020.10.27.02.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 02:18:06 -0700 (PDT)
Date:   Tue, 27 Oct 2020 10:18:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vsock: fix the error return when an invalid ioctl
 command is used
Message-ID: <20201027091804.7mpad5yaxzfmbva6@steredhat>
References: <20201027090942.14916-1-colin.king@canonical.com>
 <20201027090942.14916-3-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201027090942.14916-3-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 09:09:42AM +0000, Colin King wrote:
>From: Colin Ian King <colin.king@canonical.com>
>
>Currently when an invalid ioctl command is used the error return
>is -EINVAL.  Fix this by returning the correct error -ENOIOCTLCMD.
>
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 865331b809e4..597c86413089 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2072,7 +2072,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
> 		break;
>
> 	default:
>-		retval = -EINVAL;
>+		retval = -ENOIOCTLCMD;
> 	}
>
> 	return retval;
>-- 
>2.27.0
>

