Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5973B1E5D
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFWQMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:12:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24584 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbhFWQMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 12:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624464624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rnf1xld2zG7ITor+H4pye+Ce8VDHDjjS7DCz0019lgk=;
        b=MVxi1JwfqKfNNVHr6QXkPTV7AIbUFVIfbJRX76T6CYKnX9FTwyOzL4KOSzx043hnWkLlea
        HFRaSssq8yVW4CwE/UoqaaUACFcvYqqjou+1gtO+LelUXOJaP7jIWPA7QYUw/PolUOptjn
        lwhIWcl8U55xR3hjkMFXHy4GZlBYmz0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-N0y4Wpi6PLGHIdrJmBpAow-1; Wed, 23 Jun 2021 12:10:23 -0400
X-MC-Unique: N0y4Wpi6PLGHIdrJmBpAow-1
Received: by mail-ej1-f71.google.com with SMTP id jw19-20020a17090776b3b0290481592f1fc4so1174460ejc.2
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 09:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rnf1xld2zG7ITor+H4pye+Ce8VDHDjjS7DCz0019lgk=;
        b=uHlvqvgPJm4yhhjzo9tlNv1iHtZuVAgKd4vIxQU6I//Ad8ygYQOdIv9z6fZbkg3wA7
         BIsxVTbf/2M1vdMsjqUx11lUJXl1jV4L56q0VHL+IKyOWY0PG8sG/BQV0/2EG6jjaEQ7
         hzk4ajRcwTd73em44EpZnOd1fylqaMd45czI0uFFtDFr+X09yZlnCDnHkSqxHV2dPkBZ
         e47SSrwufSYMdjRHDxGOSU8ezHcq4k8zLh4GuOxyTlMoHG9wwtH/9IvwL+HQfInxh1/y
         BSbp2LcBRdqnN2DuOlB+QVdeFkxhGKFz6l8IDHKNrmXy4Cck52e35ixgXz8BYeqn1Cqq
         v+Yg==
X-Gm-Message-State: AOAM531xWYbHgsR6t75rI14Pz6OxLQvniiQ8/d30QevP2N7YyYsxnz/N
        hU4pGWvKts8KFBTwtgneJE82z24fsCWcqGIoMbxhFrWYJrMhPC+Y6/7wczR8BCTBQlzTXXFqqtP
        N0ItMd7xAaNTXPVZa
X-Received: by 2002:a17:906:5049:: with SMTP id e9mr840283ejk.30.1624464618607;
        Wed, 23 Jun 2021 09:10:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1pKANbb6hP+TU5DFw0ClGZrpYkWFi0a2by+iDKCeEPzurXLgBC+9knH9a6wa4g8T3K5CnSw==
X-Received: by 2002:a17:906:5049:: with SMTP id e9mr840077ejk.30.1624464616406;
        Wed, 23 Jun 2021 09:10:16 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id x21sm260208edv.97.2021.06.23.09.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:10:15 -0700 (PDT)
Date:   Wed, 23 Jun 2021 18:10:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Neeraj Upadhyay <neeraju@codeaurora.org>
Cc:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vringh: Use wiov->used to check for read/write desc order
Message-ID: <20210623161013.qg3azanyxt7nucgl@steredhat>
References: <1624361873-6097-1-git-send-email-neeraju@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1624361873-6097-1-git-send-email-neeraju@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 05:07:53PM +0530, Neeraj Upadhyay wrote:
>As iov->used is incremented when descriptors are processed
>in __vringh_iov(), use it to check for incorrect read
>and write descriptor order.
>
>Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
>---
> drivers/vhost/vringh.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
>index 4af8fa2..14e2043 100644
>--- a/drivers/vhost/vringh.c
>+++ b/drivers/vhost/vringh.c
>@@ -359,7 +359,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
> 			iov = wiov;
> 		else {
> 			iov = riov;
>-			if (unlikely(wiov && wiov->i)) {
>+			if (unlikely(wiov && wiov->used)) {
> 				vringh_bad("Readable desc %p after writable",
> 					   &descs[i]);
> 				err = -EINVAL;
>-- 
>QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
>hosted by The Linux Foundation
>

