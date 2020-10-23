Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A39297116
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 16:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750301AbgJWOKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 10:10:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S465171AbgJWOJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 10:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603462198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rVRff8IalcLcFxZp8c6FdrS3ABLClcQs9SBrNtnDkw8=;
        b=jCkrKLCTAUovvHLFOn4n5Ko2Incqp+kS0ZnkAYycZ89ZDk6lKTtj1HtkOdVjn0NZidyeXh
        sAIditgUe7D1i4cqGpsQDxrh0MlP24/GExeo0xhi62eR7bcVAkiBsmBS/4xY1Cm1e2nExf
        WJTwffWktH7eTmu6jXjct59+Iwh/AtU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-rdnJmuB1MyKoZ_ZqGBtYtA-1; Fri, 23 Oct 2020 10:09:56 -0400
X-MC-Unique: rdnJmuB1MyKoZ_ZqGBtYtA-1
Received: by mail-wm1-f69.google.com with SMTP id 22so285354wmo.3
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 07:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rVRff8IalcLcFxZp8c6FdrS3ABLClcQs9SBrNtnDkw8=;
        b=gi2ZLcdny7qUAbEIb1D+pHCvnYf5EA55xMLsLecusrkvOKkN3fJhHKACVlwaRiug3N
         O/xno7FgGWXqR6yNmhlx/fVJbu2uLJLEeW+352pCWj7NWeTeiVqc1RsqGoZ07X/dHsre
         kyemoPbzRwJKbvf7opF9NsgUdhpAfbF10kcw3Uz64us71iQAuhvmUM3hGSD44v20x+JW
         RSTVwJpPvv+jlPGlrvzsnR8Lhw5Yko/J++bAAUAOw8HRViNDsJ3Kxq8CpfXp9rfPNkQZ
         HfCd6jv9VIlsx75kbP8MCMqdbgDgCDnADQwuqV5kq7iXekZtuz5+F2ndUai6Dvyt0Ont
         909g==
X-Gm-Message-State: AOAM532TYNaCSfNFgjkVfP4C6UvPOiYdDr3v1qWeXUhIdHkWhC/1Wajc
        hwpwmWqcqO8lMYAPURQbnNkNyohRTbn0JPZMCdIyOgKPlyr80Qje9A9QnGzyna9Le5350gx3Y8i
        e623Eba5zXilMMLk1
X-Received: by 2002:a7b:c741:: with SMTP id w1mr2200125wmk.67.1603462195577;
        Fri, 23 Oct 2020 07:09:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/ohXINOadQoKRMbMO4rjSXcp5H+ohblZ7M/AnSdV3socDZSGjYZnpTkpuYZ0gzbQFumMEhA==
X-Received: by 2002:a7b:c741:: with SMTP id w1mr2200104wmk.67.1603462195366;
        Fri, 23 Oct 2020 07:09:55 -0700 (PDT)
Received: from steredhat (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id d129sm3848452wmd.5.2020.10.23.07.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 07:09:50 -0700 (PDT)
Date:   Fri, 23 Oct 2020 16:09:47 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock: ratelimit unknown ioctl error message
Message-ID: <20201023140947.kurglnklaqteovkp@steredhat>
References: <20201023122113.35517-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201023122113.35517-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 01:21:13PM +0100, Colin King wrote:
>From: Colin Ian King <colin.king@canonical.com>
>
>When exercising the kernel with stress-ng with some ioctl tests the
>"Unknown ioctl" error message is spamming the kernel log at a high
>rate. Rate limit this message to reduce the noise.
>
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 9e93bc201cc0..b8feb9223454 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2072,7 +2072,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
> 		break;
>
> 	default:
>-		pr_err("Unknown ioctl %d\n", cmd);
>+		pr_err_ratelimited("Unknown ioctl %d\n", cmd);

Make sense, or maybe can we remove the error message returning only the
-EINVAL?

Both cases are fine for me:
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

> 		retval = -EINVAL;
> 	}
>
>-- 
>2.27.0
>

