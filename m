Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E48E339144
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhCLPaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:30:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231849AbhCLP3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:29:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615562971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=czotstymJyYNFdPhwwa87kqjbZU6tULSaV4jVggza0c=;
        b=LxJ6AcaLlAICH0lZGFa3nmKYbIBZvYY/p685EJfxmuOpEUzD9sCHw0LjnQcYxchsW93SwK
        9qVeGphAJafDOgUzbYGlViRdrS1eqAVvdKr/y+kcHvFwYgAGxmao10EAzwyyZECBRDD5/I
        OTMVw4wUWZA6VQtrhwjKb5Tm9NiRZN4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-wP5b1yupNteY0qNCfQGe9w-1; Fri, 12 Mar 2021 10:29:29 -0500
X-MC-Unique: wP5b1yupNteY0qNCfQGe9w-1
Received: by mail-wr1-f72.google.com with SMTP id s10so11303886wre.0
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 07:29:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=czotstymJyYNFdPhwwa87kqjbZU6tULSaV4jVggza0c=;
        b=p1r+yCwS4I7e5PUMxdbp4cDXl9PlrbwOOtmwYp+cCRYJ6pedGGdQwsgGUdlI6hYTwl
         i+KdHW7L/ZlU4kqxJ5EK39LVPnwBTi9TZBFGXTsoVG6TPjHL3LtRJJkZQGMUBHqXJoCd
         a2ZUI013W+64BjJLbrD4RTZpnGnzR8l4as/ez7lD3d9hVwk71O4YHW9EQ+7aA5LxIQCT
         J5lkH3eDzrMzgK1Pk7mQV55TPtFwOz88eN2WI9oUD6cv2SN0dNKuB0lmqn0xba8gMAu7
         KPNa+kZMX8D6/aTKf4QN+a4DluLTIUDVMjKGWP19+ZD4tUCoUaBgsnRW7mhSJL5QQLBK
         xr5g==
X-Gm-Message-State: AOAM530qVKg1sn43bZ27kN6/YJgQy70GiviXOSKX3mSvL1e0ZKs6aBjh
        rGU+HC1huHK0B4jKzmGPtSDIaM+AslAsudLvwyKd6uynTo7reZlkeFksmv93HSFukzyDAarGq6K
        Wgnwy95PZhTGLRSjN
X-Received: by 2002:adf:ded1:: with SMTP id i17mr14795809wrn.349.1615562968737;
        Fri, 12 Mar 2021 07:29:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+1YroWw/KII86Gtcw8KIDCORZXNuDVgfD6MmoqYoTncwOuB+icviQJbIfWvZiUkdd1sVuqQ==
X-Received: by 2002:adf:ded1:: with SMTP id i17mr14795794wrn.349.1615562968586;
        Fri, 12 Mar 2021 07:29:28 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id n66sm2411295wmn.25.2021.03.12.07.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:29:28 -0800 (PST)
Date:   Fri, 12 Mar 2021 16:29:26 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 08/22] af_vsock: update comments for stream sockets
Message-ID: <20210312152926.p75hjd3oghgu6b3i@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307180108.3465422-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307180108.3465422-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 09:01:05PM +0300, Arseny Krasnov wrote:
>This replaces 'stream' to 'connection oriented' in comments as
>SEQPACKET is also connection oriented.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 31 +++++++++++++++++--------------
> 1 file changed, 17 insertions(+), 14 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

