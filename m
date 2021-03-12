Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5DB339029
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhCLOi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:38:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhCLOiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 09:38:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615559889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wqR2VXBD9ShzLCVtX+qqk63mSGBNYYonntBUYfSNkBU=;
        b=a7RyGF0sLSy0wOWAMa0okxjQfBCLI1TO4lKIYi56lDn5Ued7N95TW6+1lA3igD742ZH9Ur
        qtaxZdhQQwR+LhZl0b7GJNDJBA2yOMRql/yFnyOdqQcdJ0JI5qfInp7sq1VkltrjyLC8iu
        RnDnk/SZXOed6Ps6S1t0Kw+DnSTCJB8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-e18xACSWPJCeRw0LOpRZTQ-1; Fri, 12 Mar 2021 09:38:07 -0500
X-MC-Unique: e18xACSWPJCeRw0LOpRZTQ-1
Received: by mail-wr1-f71.google.com with SMTP id p15so11130659wre.13
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:38:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wqR2VXBD9ShzLCVtX+qqk63mSGBNYYonntBUYfSNkBU=;
        b=omHIfYoCSeZNn1aWAdc13X1YF/RmCCtI+s/kpDo42GLYax8/kCmVUj7A9uKpBarOSW
         dzIbeJivrR69EjA3Kk1dDRWEzlK9MeFhqTLl2ExQ5MYS18XTBy9Vx9RSy0M798rCEh3z
         CKlAg/GnNjm8rfBuWSqS2jbBCSOVvGfKI65WyXFOSayxkcldzqluqg+wsJIZR46tSEfi
         uTa20SqzrDrWXRi2sDn8ZFZB7xWPTdg5qTomuklumC9krwKssva4hoqc/9Racd0+hm8U
         Q3qYx9CRMigEnmJJay9/6P3FIMIUY/8atytxbLa2pPsVTCOijNw4qK+fYlkTZ4MM8kk7
         GZjQ==
X-Gm-Message-State: AOAM533RXqZbRh/r18A+IqRbgECnG5xq30GVOXaBUmMuBUM/ZTnn2KUu
        wf/1HEJ1/+YZb252Vhmqv4tJoLT6hrfyzBJcJjEFL6rpiHyCWmXIqRnbJvuFuhpYEJmWAo97MP7
        OkTeAiC45fMQyKLQA
X-Received: by 2002:adf:a4d0:: with SMTP id h16mr14234128wrb.52.1615559886546;
        Fri, 12 Mar 2021 06:38:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxCMOehTT6EynoUYujDmF8ZxV5JxPQ3Xa+h0M2h9lyxZbt2sDFpKhYb/X+GcurEHDbm83cQTA==
X-Received: by 2002:adf:a4d0:: with SMTP id h16mr14234110wrb.52.1615559886374;
        Fri, 12 Mar 2021 06:38:06 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id x11sm2760458wme.9.2021.03.12.06.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:38:05 -0800 (PST)
Date:   Fri, 12 Mar 2021 15:38:03 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 01/22] af_vsock: update functions for connectible
 socket
Message-ID: <20210312143803.hcq4byotzx5x65j7@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307175843.3464468-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307175843.3464468-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 08:58:39PM +0300, Arseny Krasnov wrote:
>This prepares af_vsock.c for SEQPACKET support: some functions such
>as setsockopt(), getsockopt(), connect(), recvmsg(), sendmsg() are
>shared between both types of sockets, so rename them in general
>manner.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 64 +++++++++++++++++++++-------------------
> 1 file changed, 34 insertions(+), 30 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

