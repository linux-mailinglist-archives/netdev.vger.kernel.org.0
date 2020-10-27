Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35F729A791
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 10:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437162AbgJ0JRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 05:17:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732117AbgJ0JRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 05:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603790230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2couyPS9oU8nqon9qRpsj1IaLZzKbO0wg6RKQog+8FE=;
        b=gSgMIfrCjjqIcH1JbNWe9py0YG/2TPSHd6eKlakQoG8/sJr96UDTiZEGSsUzEAW+3I9X45
        n7lykw6xrcKpnkzcqBz/G5zWTUZV0xKPGj4YkG4sO4yKEFSoUYXPghrOaUiEvKNbSfbmqk
        BPW+PsWdc5u5hELUA0RCmkVIwGWODmQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-3xaNkHfGMqWRq_n0E6ZaRw-1; Tue, 27 Oct 2020 05:17:08 -0400
X-MC-Unique: 3xaNkHfGMqWRq_n0E6ZaRw-1
Received: by mail-wr1-f69.google.com with SMTP id v5so516675wrr.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 02:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2couyPS9oU8nqon9qRpsj1IaLZzKbO0wg6RKQog+8FE=;
        b=iR1baGhZ+bwM+DA1X38mL/sENxuKYeu6PyhQT5vCsYSr2IqF8a/8HIJ8Ud8NnCxwc+
         Wwvim1nJL4X5V1qkOlUJSNaJUgJHNKYy4USR7WV/Us2VfKhji+jNqfQpULGmYCr0i+zP
         WyKobtvLdvdujUyw6an10n32MaeWtSdGAE6yEhw/MkoHdFkutELaPzcITfyTdSF3PacN
         mygXkf1qDLtTBrsq2/U2jFpCWj19e3sFltuMQuobcEzAZgfHqZqlWzGDSol5L1BXct/v
         wN2DbcBvf6aDTvkhoOqZbajQiDrH2gMPFmU+8hgkgmW//WEeCsWBSnxiGg+lZS6H7YN+
         cq5Q==
X-Gm-Message-State: AOAM532Sn7gWUip05Z7GpsZUAYwp+5EnsitoyrS/WrW7cGHVbWWOjkYf
        aEa+60SgLfkjSNo/LKEdplCECEXtvC/HQj8ONrFwbk5fZA7KGcQSVrkvuDWah6V+hyu+JHqCta4
        8Yydbp06WFFGU9eFI
X-Received: by 2002:a1c:4d13:: with SMTP id o19mr1709687wmh.185.1603790227289;
        Tue, 27 Oct 2020 02:17:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOw3Fses5vfPNkX+6A+Vrc5l4MfHYL1vm4mt1FXcRuczReog+9IDOi94XyxRsLvwlXundZ/g==
X-Received: by 2002:a1c:4d13:: with SMTP id o19mr1709663wmh.185.1603790227042;
        Tue, 27 Oct 2020 02:17:07 -0700 (PDT)
Received: from steredhat (host-79-17-248-215.retail.telecomitalia.it. [79.17.248.215])
        by smtp.gmail.com with ESMTPSA id e25sm1151755wra.71.2020.10.27.02.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 02:17:06 -0700 (PDT)
Date:   Tue, 27 Oct 2020 10:17:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2][V2] vsock: remove ratelimit unknown ioctl message
Message-ID: <20201027091704.eovesxm3h5f5mi4j@steredhat>
References: <20201027090942.14916-1-colin.king@canonical.com>
 <20201027090942.14916-2-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201027090942.14916-2-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 09:09:41AM +0000, Colin King wrote:
>From: Colin Ian King <colin.king@canonical.com>
>
>When exercising the kernel with stress-ng with some ioctl tests the
>"Unknown ioctl" error message is spamming the kernel log at a high
>rate. Remove this message.
>
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> net/vmw_vsock/af_vsock.c | 1 -
> 1 file changed, 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 9e93bc201cc0..865331b809e4 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2072,7 +2072,6 @@ static long vsock_dev_do_ioctl(struct file *filp,
> 		break;
>
> 	default:
>-		pr_err("Unknown ioctl %d\n", cmd);
> 		retval = -EINVAL;
> 	}
>
>-- 
>2.27.0
>

