Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FD3475DBE
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 17:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244961AbhLOQpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 11:45:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231883AbhLOQpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 11:45:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639586720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zr39epKNIeLqCYAviX0DP39J0kASqwukLjlBFjVs0XU=;
        b=WOknj9aN7glqMgqscVeyOa5g8dwzd3TT1sNGc27sYLngPpFrvc4k9V5mCitR2RHC9btoEb
        9ABE7xUShpyCBVZfGl4tU7j3QmaAXFZJTFhhytHPHVDe1/vT+CAi6XqA85RQvXvCPxwEOf
        xI2OnPrmQvRAWHynjvGvpUt3BAH8lt0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-9oGDK-3xPYS7VwG_uPpxOw-1; Wed, 15 Dec 2021 11:45:19 -0500
X-MC-Unique: 9oGDK-3xPYS7VwG_uPpxOw-1
Received: by mail-wm1-f72.google.com with SMTP id k25-20020a05600c1c9900b00332f798ba1dso14888289wms.4
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 08:45:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zr39epKNIeLqCYAviX0DP39J0kASqwukLjlBFjVs0XU=;
        b=ZXGnjmzJj4ENsceOxdGoIbAOYb13oxLuemYnUEO8J+pRiRSkMSiWuTJzhgXCQQvoOX
         YsdZTFCiUeehUdmT97fKsEichbq1GH+28bVx7ZfMoMGKa9Sk9f10AUF09YnPCEOdhAJo
         /Sv1Qcaljknjz6o2W6fwPFCliWjqEvvNWShgIogT0abJYC9Y0oJ/clADkRCjILy76lI/
         qH2UZ2QoudeVSVPjcJf6gciFdQSEhOAyunecUB4gjBxzUlfGlYNh6BwU+lR60abThjdL
         xH4Rk5aH5fCeeQVb/G2rjBnFnAwc6FM7Nhmg4xuonmvPvsRQGX3PnLtPUjUZ8UoG5E3j
         4hfw==
X-Gm-Message-State: AOAM530dtLPc9tdL55GPI6Es+jKVuO4KSh/c4t7jR20UiGvRdi8+YSM8
        VZy+77Q9XfFfdZrVLRy5xPao7Lfitqzs0nP7lgFsc6OB56Ss2f6Fvv49gq/nv703LVPRGTwob1p
        UT0LMXbWk5dWAK9D0
X-Received: by 2002:a05:600c:1e87:: with SMTP id be7mr695300wmb.182.1639586718059;
        Wed, 15 Dec 2021 08:45:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy+3vIbzUHPuqX0QQ2sjRKOoX2Vtnk6RSxWjA+2ON0AX89jmdKEyRTtA718GGxV+iwjCPrzpA==
X-Received: by 2002:a05:600c:1e87:: with SMTP id be7mr695283wmb.182.1639586717877;
        Wed, 15 Dec 2021 08:45:17 -0800 (PST)
Received: from steredhat (host-87-21-203-138.retail.telecomitalia.it. [87.21.203.138])
        by smtp.gmail.com with ESMTPSA id p5sm2540559wrd.13.2021.12.15.08.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:45:17 -0800 (PST)
Date:   Wed, 15 Dec 2021 17:45:15 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: Fw: [Bug 215329] New: The vsock component triggers out of memory
 when sending small packets.
Message-ID: <20211215164515.6cnjzcndrqsqtlkp@steredhat>
References: <20211215073807.30c0041d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211215073807.30c0041d@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 07:38:36AM -0800, Stephen Hemminger wrote:
>
>
>Begin forwarded message:
>
>Date: Wed, 15 Dec 2021 03:40:59 +0000
>From: bugzilla-daemon@bugzilla.kernel.org
>To: stephen@networkplumber.org
>Subject: [Bug 215329] New: The vsock component triggers out of memory 
>when sending small packets.
>
>
>https://bugzilla.kernel.org/show_bug.cgi?id=215329

Thanks for CC me. I think it's related to this issue: 
https://gitlab.com/vsock/vsock/-/issues/1

virtio-vsock provides a credit mechanism, but we need to improve the 
memory tracking, maybe reusing sk_sndbuf and sk_rcvbuf.

Unfortunately, when vsock was introduce it adds is own IOCTL to set the 
buffer size, so we need to clean up a bit that part.

I can't work on it right now, maybe in the next months I can, but I can 
help for sure if someone has time.

Thanks,
Stefano

