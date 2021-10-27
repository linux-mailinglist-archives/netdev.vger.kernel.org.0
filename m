Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A1A43CEF6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbhJ0Qv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:51:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242964AbhJ0QvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 12:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635353339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=myjd4yI+pQW3BM05TdHc3lwGLGFjbII7js9KwnlTHdM=;
        b=LDjLHRITWikHfk4PRyEMG+vCQ0erpbGSmRxccjkyEcTtjTbRlu+4G95UE+2RdQGHXnmIMK
        6a2/kW/qOBMyZTRcQlY9Llna1Eu3tLGHCCvTyFp9qWMNmIOlUVYzWeo4+ixX5vwzBkBTiI
        0Ynbzz9/zyzTe4jO8JlBBzZ9uhpLNkA=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-UkqUXy4GOTy8oe5TjTDonw-1; Wed, 27 Oct 2021 12:48:58 -0400
X-MC-Unique: UkqUXy4GOTy8oe5TjTDonw-1
Received: by mail-ot1-f70.google.com with SMTP id l17-20020a9d7351000000b0054e7cd8a64dso1775403otk.4
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 09:48:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=myjd4yI+pQW3BM05TdHc3lwGLGFjbII7js9KwnlTHdM=;
        b=ab/bWFtjlJ83Li69xJKvfuAlDxijb3EDEAb+9Pu41zsYqNIfphqnu722qoGzNu4Jkf
         IJWE/Pe6t/1CnGcbG1oA6LCXrTjBwx0/m57STjAPXjpSSL8uQZPzEZT+BnwndljqmKCB
         jcoseSMwyyw0+yeH4DWu9xMl9JPKnCJSbpbGq6/vesjF9MAhPofkEOwHip4Mnk3WZ4ry
         SS64RUrNo0No8iGmuPww3kGkuTeFV95le0n11K469YwBA4rF+PHKg0jVxKVcGi85V+D8
         GnxIJB1sqwyMEHMwykfYWYlWsd89kfoIxsetYsMIMwkVMnocO1JGgEz9Hn0paQLoFpMb
         lzog==
X-Gm-Message-State: AOAM533+MyPcQafHcKBOokZYzASJV8cHtatOF7gCxK4HOWFWXDEeGt9P
        VPH0lPpsUMeO3BtHANkq/u6yeyag0tjVOXvwERIagMlaeX1LE7wmhgsHYXYSUvpiQ5yg55xe2KO
        4rphKcnxpqRfPkXUP
X-Received: by 2002:a4a:e597:: with SMTP id o23mr22933854oov.96.1635353336945;
        Wed, 27 Oct 2021 09:48:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvSN3j91f9/c+UdOhpzYFjIhX3dw1hCLu+GCaj1YcJ706DUx9FcLfTO9FoGf+SqbDtSgQ25g==
X-Received: by 2002:a4a:e597:: with SMTP id o23mr22933827oov.96.1635353336683;
        Wed, 27 Oct 2021 09:48:56 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e1sm189205oiw.16.2021.10.27.09.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 09:48:56 -0700 (PDT)
Date:   Wed, 27 Oct 2021 10:48:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V4 mlx5-next 13/13] vfio/mlx5: Use its own PCI
 reset_done error handler
Message-ID: <20211027104855.7d35be05.alex.williamson@redhat.com>
In-Reply-To: <20211027155339.GE2744544@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
        <20211026090605.91646-14-yishaih@nvidia.com>
        <20211026171644.41019161.alex.williamson@redhat.com>
        <20211026235002.GC2744544@nvidia.com>
        <20211027092943.4f95f220.alex.williamson@redhat.com>
        <20211027155339.GE2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 12:53:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Oct 27, 2021 at 09:29:43AM -0600, Alex Williamson wrote:
> 
> > The reset_done handler sets deferred_reset = true and if it's possible
> > to get the state_mutex, will reset migration data and device_state as
> > part of releasing that mutex.  If there's contention on state_mutex,
> > the deferred_reset field flags that this migration state is still stale.
> > 
> > So, I assume that it's possible that a user resets the device via ioctl
> > or config space, there was contention and the migration state is still
> > stale, right?  
> 
> If this occurs it is a userspace bug and the goal here is to maintain
> kernel integrity.
> 
> > The user then goes to read device_state, but the staleness of the
> > migration state is not resolved until *after* the stale device state is
> > copied to the user buffer.  
> 
> This is not preventable in the general case. Assume we have sane
> locking and it looks like this:
> 
>    CPU0                            CPU1
>   ioctl state change
>     mutex_lock
>     copy_to_user(state == !RUNNING)
>     mutex_unlock
>                                ioctl reset
>                                  mutex_lock
>                                  state = RUNNING
>                                  mutex_unlock
>                                return to userspace
>   return to userspace
>   Userspace sees state != RUNNING
> 
> Same issue. Userspace cannot race state manipulating ioctls and expect
> things to make any sense.
> 
> In all cases contention on the mutex during reset causes the reset to
> order after the mutex is released. This is true with this approach and
> it is true with a simple direct use of mutex.
> 
> In either case userspace will see incoherent results, and it is
> userspace error to try and run the kernel ioctls this way.
> 
> > What did the user do wrong to see stale data?  Thanks,  
> 
> Userspace allowed two state effecting IOCTLs to run concurrently.
> 
> Userspace must block reset while it is manipulating migration states.

Ok, I see.  I didn't digest that contention on state_mutex can only
occur from a concurrent migration region access and the stale state is
resolved at the end of that concurrent access, not some subsequent
access.  I agree we have no obligation to resolve anything about the
state that concurrent access would see.  Thanks,

Alex

