Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E77345344E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbhKPOim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:38:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45302 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237449AbhKPOiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637073319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rDz1YUR0AgNW1PyJTJkx0fL4NDM6le7gN2iBvKWyYhY=;
        b=F461NkN5XJy0TyHWHh++eUOeXHbreq2b16hQfVk5nW/axYSZw/gLPE2oKHiX9KDD3v+HLX
        IuovUxyT+HPAbPcYvG6++Pjvy14ZqtRhsAOd/u5KBUcQ5jHH0NNMPtqbjfBHSLB42OeKn9
        U/zel0LZZ/erT3hMlEaFlyz2SlAJf3M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-APNCZaYtOCiNigW1E_uapw-1; Tue, 16 Nov 2021 09:35:18 -0500
X-MC-Unique: APNCZaYtOCiNigW1E_uapw-1
Received: by mail-wr1-f70.google.com with SMTP id f3-20020a5d50c3000000b00183ce1379feso4521196wrt.5
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 06:35:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rDz1YUR0AgNW1PyJTJkx0fL4NDM6le7gN2iBvKWyYhY=;
        b=sO5jbLjXOzPOvr53B4O5mH9iIUaXVL2xcMRP0waSTKL93RPOFw8QCwZ2cgxIisAAZ6
         +KrPNrnu3CxD7hL+7Nze5LixMXxmFIOz2BbclgrHGKrqo0EYzMcoRJVWZmOafGtrwtGI
         ZbmmncMj/C0zaRXPSCYvB43i9rtYqh98TJI8sJgfK5N8mScdkbkEmCWzHE+rKPuwLCQn
         VqlwMH4E2tdY6zhi5ixjlOEB2R2/TYPjXyTBv83MWWU7AWuO6CJk/zfQ3jFjaVqrsbpB
         Q/oCGbUJ8zFugiZGqO5+zUMMLZ3UYiFilI0Tl2m63/zJbWFi6gm58sb8VtnwvbVTBOFw
         mb+Q==
X-Gm-Message-State: AOAM532D0DxYZa0iVUttJh6RHXMFoqgGUeRL/uInXAjMTDg1fbP8Fvn9
        12z+oSoo8izEMG1hIy+xaBkeP4MvgkcVPNPPQWWTDiy2bTBM2XUFM5ln1saBhTtFlOiZNr2c5wo
        f4JUjbSw+lDYaB9RN
X-Received: by 2002:adf:ded0:: with SMTP id i16mr10045253wrn.335.1637073317269;
        Tue, 16 Nov 2021 06:35:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTqQ6byTlaJB2mMvVBJPVz/03fWQs2QX2Z7ktgMC1OpQia0Z85aodMjtpJrgMPy+iqkkZfiQ==
X-Received: by 2002:adf:ded0:: with SMTP id i16mr10045215wrn.335.1637073317064;
        Tue, 16 Nov 2021 06:35:17 -0800 (PST)
Received: from steredhat (host-87-10-72-39.retail.telecomitalia.it. [87.10.72.39])
        by smtp.gmail.com with ESMTPSA id s8sm4988581wra.9.2021.11.16.06.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 06:35:16 -0800 (PST)
Date:   Tue, 16 Nov 2021 15:35:14 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] vhost_vsock: simplify vhost_vsock_flush()
Message-ID: <20211116143514.2jvemtjrds4453me@steredhat>
References: <20211115153003.9140-1-arbn@yandex-team.com>
 <20211115153003.9140-4-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211115153003.9140-4-arbn@yandex-team.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 06:30:01PM +0300, Andrey Ryabinin wrote:
>vhost_vsock_flush() calls vhost_work_dev_flush(vsock->vqs[i].poll.dev)
>before vhost_work_dev_flush(&vsock->dev). This seems pointless
>as vsock->vqs[i].poll.dev is the same as &vsock->dev and several flushes
>in a row doesn't do anything useful, one is just enough.
>
>Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
>---
> drivers/vhost/vsock.c | 5 -----
> 1 file changed, 5 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index b0361ebbd695..b4dcefbb7e60 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -707,11 +707,6 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>
> static void vhost_vsock_flush(struct vhost_vsock *vsock)
> {
>-	int i;
>-
>-	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++)
>-		if (vsock->vqs[i].handle_kick)
>-			vhost_work_dev_flush(vsock->vqs[i].poll.dev);
> 	vhost_work_dev_flush(&vsock->dev);
> }
>
>-- 
>2.32.0
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

