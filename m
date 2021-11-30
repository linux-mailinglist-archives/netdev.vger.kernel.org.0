Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BAC464234
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 00:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbhK3XZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 18:25:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236444AbhK3XZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 18:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638314525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HE0msS1vCkRQbBzuUW+gFDjWtfUevvLfeKjclp9hKp4=;
        b=UWH00zQuSCt/cZ+p+6gRVtUWo6Iz9u0QYpOekTB+h1gxZx9KYjNWga7d8G9pwz6YuP8fks
        u4xsbFaUDK3Ycw4k4UTPzzeCc0ksB+H5hkWgBo3TDb74CibtGAtAePyjdx9BHgJu+GzfMG
        GhAE7zu2W0tKK/yHNycItoraNNgf/i0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-OSEioD8GPjeD1jL5OubwYg-1; Tue, 30 Nov 2021 18:22:04 -0500
X-MC-Unique: OSEioD8GPjeD1jL5OubwYg-1
Received: by mail-ed1-f72.google.com with SMTP id a3-20020a05640213c300b003e7d12bb925so18458562edx.9
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 15:22:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HE0msS1vCkRQbBzuUW+gFDjWtfUevvLfeKjclp9hKp4=;
        b=6nFvJNLl5sBsVQL8b4BW8E9KLu307JkT3VajE05NvdspkSG20YmVadpdXrCeorjT8p
         UwvP5ZFkRnlWTPbQ6FyFcpDb1dl+Hr0ZdrTqcJV6cdk0P/CBU4k4YAlFOZgMVaD+q7E9
         EKKWAYB31us6WmRwuONzW2jepFEdQjvQpQ4xDsKC8qh7RZz0dzmFju6RDPW4kJKG1ksi
         4t8BJOCpyAu7ueGMA1Z/DmEELRVqdhafcgOQUa7p1Y9V8E+jM4f93kZUU6cIRGQRPPvW
         jPqS7r4mmudL7B3MU+EpW11ljpkXoq1pwP6UpJ6jh59xdH4lOoKk8Pphcdt9/Pppy8Hr
         RyXg==
X-Gm-Message-State: AOAM530u8nOYo7q7p2HmiSwyC4bFhZjmqUAB08Qm3ATsCmgAcjsttF/5
        n71/S2vrbav+zFW+RUf5x9fKWLGRfG5Pplg+AHTyRGr8oWPJbkDvjX3mRUHVDxDJxTiTOJ4fHbG
        mU5Ibh2bTn0/iRTEz
X-Received: by 2002:a05:6402:4251:: with SMTP id g17mr3005803edb.89.1638314522888;
        Tue, 30 Nov 2021 15:22:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbvu86zvHjPQsYW2tVNM00LmXSduAUUk7Bx3bQsiawQ/LT23+JgeK73SoD9rq5dLPGwoV84w==
X-Received: by 2002:a05:6402:4251:: with SMTP id g17mr3005791edb.89.1638314522746;
        Tue, 30 Nov 2021 15:22:02 -0800 (PST)
Received: from redhat.com ([2.53.15.215])
        by smtp.gmail.com with ESMTPSA id d10sm9814746eja.4.2021.11.30.15.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:22:01 -0800 (PST)
Date:   Tue, 30 Nov 2021 18:21:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] virtio/vsock: fix the transport to work with
 VMADDR_CID_ANY
Message-ID: <20211130181948-mutt-send-email-mst@kernel.org>
References: <20211126011823.1760-1-wei.w.wang@intel.com>
 <20211126085341.wiab2frkcbmkg4ca@steredhat>
 <2853d4c373aa4cf0961a256622014eed@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2853d4c373aa4cf0961a256622014eed@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 01:34:20AM +0000, Wang, Wei W wrote:
> Hi Michael,
> 
> Do you plan to merge this patch through your tree?
> If not, I'll resend to have it applied to the net tree.
> 
> Thanks,
> Wei


Sure, I'll merge it. Thanks!

> On Friday, November 26, 2021 4:54 PM, Stefano Garzarella wrote:
> > On Thu, Nov 25, 2021 at 08:18:23PM -0500, Wei Wang wrote:
> > >The VMADDR_CID_ANY flag used by a socket means that the socket isn't
> > >bound to any specific CID. For example, a host vsock server may want to
> > >be bound with VMADDR_CID_ANY, so that a guest vsock client can connect
> > >to the host server with CID=VMADDR_CID_HOST (i.e. 2), and meanwhile, a
> > >host vsock client can connect to the same local server with
> > >CID=VMADDR_CID_LOCAL (i.e. 1).
> > >
> > >The current implementation sets the destination socket's svm_cid to a
> > >fixed CID value after the first client's connection, which isn't an
> > >expected operation. For example, if the guest client first connects to
> > >the host server, the server's svm_cid gets set to VMADDR_CID_HOST, then
> > >other host clients won't be able to connect to the server anymore.
> > >
> > >Reproduce steps:
> > >1. Run the host server:
> > >   socat VSOCK-LISTEN:1234,fork -
> > >2. Run a guest client to connect to the host server:
> > >   socat - VSOCK-CONNECT:2:1234
> > >3. Run a host client to connect to the host server:
> > >   socat - VSOCK-CONNECT:1:1234
> > >
> > >Without this patch, step 3. above fails to connect, and socat complains
> > >"socat[1720] E connect(5, AF=40 cid:1 port:1234, 16): Connection reset
> > >by peer".
> > >With this patch, the above works well.
> > >
> > >Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> > >Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > >---
> > > net/vmw_vsock/virtio_transport_common.c | 3 ++-
> > > 1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Usually fixes for net/vmw_vsock/* are applied through the net tree
> > (netdev@vger.kernel.org) that seems not CCed. Please
> > use ./scripts/get_maintainer.pl next time.
> > 
> > Maybe this one can be queued by Michael, let's wait a bit, otherwise please
> > resend CCing netdev and using "net" tag.
> > 
> > Anyway the patch LGTM:
> > 
> > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

