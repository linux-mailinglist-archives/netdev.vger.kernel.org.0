Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E75532A3EF
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349485AbhCBKDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 05:03:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1577742AbhCBJw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 04:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614678662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lNvLI1zsChJgnJq9MCR6chFkbHYLQrCmCIxk0IHOWi0=;
        b=XrY4k05BT7SzNjlnx6UuoZ5zE1afiNczuqO+CqTPwwEo/R4JE37s8paFV72GOedTn/z7Tb
        httIM6NRGLHV2TnL1CZmLUkWMNmLLgQGdqsczEZHv6/HExvj5MHCg6OLyTGxUwWWJyXvDF
        iX/qO/VTEOD0chH8ziJYlfM65iR0LqU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-1muzqldoOAOSoFzW2yvlAw-1; Tue, 02 Mar 2021 04:47:12 -0500
X-MC-Unique: 1muzqldoOAOSoFzW2yvlAw-1
Received: by mail-ej1-f72.google.com with SMTP id 7so8207257ejh.10
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 01:47:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lNvLI1zsChJgnJq9MCR6chFkbHYLQrCmCIxk0IHOWi0=;
        b=cYUCq2rZXcCLkcz4j+Vqtl5k5+fsV7hBzHmp0Ckp8mbH5uLrmqhVJAulyNjA5PyGyA
         rWCFKsgcc+HOg9R8UVjgNdAJyANgU2k03xPSHpWS524Mz8OJ1MqVwkl3l/X+RIeaHKSl
         Y3/23zVKqoorTcJ3X7g7QI+S0MMtRI+2D5JYjyBdqyFKwogUtNWHe/HJqZNkaqKNvPL4
         FoHv/MT4Yh6Y/6t8mL7jmJNOddPL4haXevwWPdLOAfdKiy+Hp6iz4FKluaq4dPDOTeIG
         g4VT41IyLVtfYSUpz5FU8080Ui2BopVnd7ChkstTUYYLFb+RrwrxdWlEj+G4XnQpVGWy
         q2Og==
X-Gm-Message-State: AOAM530xnjpKLbMinWjEI5bDp+FEsq3QLYtAI16CznfzscjoNEmGjxy0
        OGh0hiAiWrM+wZxsqk2ZyNpMNPNyw4YX67AwZbsLSPCmlO2umbBzixsGINu8VE9si5UdRR7N5M2
        XxJH3a33oYLQH9kPy
X-Received: by 2002:a17:906:fcb2:: with SMTP id qw18mr3047199ejb.434.1614678431039;
        Tue, 02 Mar 2021 01:47:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjMhMEgexNSVGalvHgWj2+Bk230qklneo7u70O2OErqt4IfLk29fQciTb8d95u4L7fIeXDMQ==
X-Received: by 2002:a17:906:fcb2:: with SMTP id qw18mr3047184ejb.434.1614678430896;
        Tue, 02 Mar 2021 01:47:10 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id w8sm17455053edd.39.2021.03.02.01.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 01:47:10 -0800 (PST)
Date:   Tue, 2 Mar 2021 04:47:07 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210302043419-mutt-send-email-mst@kernel.org>
References: <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> 
> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
> > On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> > > > Detecting it isn't enough though, we will need a new ioctl to notify
> > > > the kernel that it's a legacy guest. Ugh :(
> > > Well, although I think adding an ioctl is doable, may I know what the use
> > > case there will be for kernel to leverage such info directly? Is there a
> > > case QEMU can't do with dedicate ioctls later if there's indeed
> > > differentiation (legacy v.s. modern) needed?
> > BTW a good API could be
> > 
> > #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > 
> > we did it per vring but maybe that was a mistake ...
> 
> 
> Actually, I wonder whether it's good time to just not support legacy driver
> for vDPA. Consider:
> 
> 1) It's definition is no-normative
> 2) A lot of budren of codes
> 
> So qemu can still present the legacy device since the config space or other
> stuffs that is presented by vhost-vDPA is not expected to be accessed by
> guest directly. Qemu can do the endian conversion when necessary in this
> case?
> 
> Thanks
> 

Overall I would be fine with this approach but we need to avoid breaking
working userspace, qemu releases with vdpa support are out there and
seem to work for people. Any changes need to take that into account
and document compatibility concerns. I note that any hardware
implementation is already broken for legacy except on platforms with
strong ordering which might be helpful in reducing the scope.


-- 
MST

