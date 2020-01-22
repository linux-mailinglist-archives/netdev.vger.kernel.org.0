Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF1D144E62
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 10:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgAVJN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 04:13:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47582 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729012AbgAVJNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 04:13:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579684403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VCjUlObpobjgu0XJb3W7s5ESBT52LecxoFq9/8IzvlQ=;
        b=NTRUFIX6cJ9fqLWmbB1lqbyTzkZnUOPOtUst6bFe4KchN7kwfRyRlXrFZhGYZ72azTUQJo
        Cdukkhu44lHedeTs1a8JMjVyEfUFRlEmNOgSPTzcoEPVAVIfJviVjJGQTXZE9VAM8/ayZP
        b6SdpXNda8HAmX4wMIxI1mIMDJFg0eA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-xomKTq1qOgSgPSwWnEeBnA-1; Wed, 22 Jan 2020 04:13:21 -0500
X-MC-Unique: xomKTq1qOgSgPSwWnEeBnA-1
Received: by mail-wm1-f72.google.com with SMTP id f25so1793128wmb.1
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 01:13:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VCjUlObpobjgu0XJb3W7s5ESBT52LecxoFq9/8IzvlQ=;
        b=aM9615gPZMYw5tzsvFM7hCdx9qZm4iBVqqtW7rCcWMv/O2ZhVfiTk5aXj40/9QcnWB
         26NaIiga9b5o/Zt80H2s6JeWELv0OIJFLlCi8hvcIs6vF9S3Z+gloTekjAiuPN9T2rBV
         +S1SpbPSjhbtep3B2vfqp/kD0IKsiH3p/mSJYKp+za8uyuO/cnk3EthcPAihMF0ZvfK8
         J1U8a7dPg181VVsuCVvmUBVXD88c4MlNlnSKaN1Q/fawb1q/8t7pBHvu2jLarjp3w38z
         TWJIBqrtts2cbMKWcmKoFwhx0nDI6VSCWvZQRXIuyC2rNBdin5l635eQpFRAGkAUcZSl
         cpdg==
X-Gm-Message-State: APjAAAWMckLzlJq3c+4RGpEtmIC2Hx2CP/pYYPGf6IuoMYS8ZPhBJ9xe
        U9JtOOc/FOo7ZRsNeQS5Vd4f43fU/WZzHOgcvRWgl2vhQsRMmcE+Kq2Iooq0PpcLksJ6GEN4q6a
        7/mQ6NkPjOqywATdx
X-Received: by 2002:a1c:f008:: with SMTP id a8mr1830059wmb.81.1579684400348;
        Wed, 22 Jan 2020 01:13:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqyOAUFw7NHJnIEiOuVrzpIIsJ1Hl4WYbzk9zmGk9s6D1DD6KOiSk9oXHOw1MLOs5RZStZA8sQ==
X-Received: by 2002:a1c:f008:: with SMTP id a8mr1830038wmb.81.1579684400178;
        Wed, 22 Jan 2020 01:13:20 -0800 (PST)
Received: from steredhat (host84-49-dynamic.31-79-r.retail.telecomitalia.it. [79.31.49.84])
        by smtp.gmail.com with ESMTPSA id r15sm3049648wmh.21.2020.01.22.01.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 01:13:19 -0800 (PST)
Date:   Wed, 22 Jan 2020 10:13:16 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <20200122091316.zduzvy2txtyqty2p@steredhat>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200121155053.GD641751@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121155053.GD641751@stefanha-x1.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 03:50:53PM +0000, Stefan Hajnoczi wrote:
> What should vsock_dev_do_ioctl() IOCTL_VM_SOCKETS_GET_LOCAL_CID return?
> The answer is probably dependent on the caller's network namespace.

Right, and I'm not handling this case. I'll fix!

> 
> Ultimately we may need per-namespace transports.  Imagine assigning a
> G2H transport to a specific network namespace.

Agree.

> 
> vsock_stream_connect() needs to be namespace-aware so that other
> namespaces cannot use the G2H transport to send a connection
> establishment packet.

Right, maybe I can change the vsock_assign_transport() to check if a
transport can be assigned to a socket, checking the namespace.

I'll send a v2 handling these cases and implementing the Michael's idea
about /dev/vhost-vsock-netns

Thanks,
Stefano

