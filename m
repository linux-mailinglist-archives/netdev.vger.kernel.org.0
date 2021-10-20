Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C775E4351BA
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhJTRrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:47:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231241AbhJTRrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 13:47:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634751918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2hBP0Hfu21rfryuWwyspO9zl4oca+bH25WuLkT22wcc=;
        b=OGvo1JYIZpHrjIM3pTANYfRJwuYAHN/ZdgKgUAR6XI4ggBJCMjoQdTrDDHGY2NPlVmlJH5
        EQagJ7sd6Peg2AoxTZGwHaFVBp6dDn6YE/UTM7qNXwLWODzE4tOKpQP1ozO+4Q+yf0FA6q
        npRYwH0EOiUFsN9neeyur89BHO8PUQU=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-VnklVN4WNOC62NrorGB8VQ-1; Wed, 20 Oct 2021 13:45:17 -0400
X-MC-Unique: VnklVN4WNOC62NrorGB8VQ-1
Received: by mail-ot1-f69.google.com with SMTP id b27-20020a9d60db000000b0055036944426so4071170otk.9
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 10:45:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2hBP0Hfu21rfryuWwyspO9zl4oca+bH25WuLkT22wcc=;
        b=DFekfu49REOzMi/tOxhvwglh2Sga+ZZvy1lrKxvSZ6fJ+fXyCWIwjfvY4Nthw93vug
         cA5pNp9yDh4m0LEaWvz0kzKYk7zLbOgYzshmoyjhz4x8TE4u0jtBSjvpAodUfgHkJ7nh
         aYjkC60//jKRedlA3Cn1BH+c5f381pPQmUnrRuBC1j/jN+GSkrbGF7ns80qi7xt8Vrny
         O6Lbd8Yd7hi1wFfFzrPdBruPLp92nhpozGbHViMMa2zNF12lzAVY/3VwmuO0Tz7NhCI8
         8E0PkIM0EBoNS8JgYWgwPA4lGHrZUDBKvugSdpDC+rjqutSi2798uYsVxVEorUm/ZzR3
         toVA==
X-Gm-Message-State: AOAM5323rXfJohhbLvGULV2e1l+UYrltDtqJkzqNjpPO+axz/NWNr1t5
        jNFELSw6NNCI4kspTY5cceG1Rt56sncYEFIZzTzQ5mWk+4UahP49jxsGuxfYWBHEFza8IcR/n6q
        OAit4/ZhvMryvBfqN
X-Received: by 2002:aca:5f05:: with SMTP id t5mr764530oib.6.1634751916602;
        Wed, 20 Oct 2021 10:45:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKoHj9L/+cPOQcjxZIt11pD2g7gRAhKD9GAn7fGM9xPBRn3QxFkpALYapm7VHjLzF9mQtvwA==
X-Received: by 2002:aca:5f05:: with SMTP id t5mr764508oib.6.1634751916398;
        Wed, 20 Oct 2021 10:45:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n187sm538797oif.52.2021.10.20.10.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 10:45:16 -0700 (PDT)
Date:   Wed, 20 Oct 2021 11:45:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 mlx5-next 14/14] vfio/mlx5: Use its own PCI
 reset_done error handler
Message-ID: <20211020114514.560ce2fa.alex.williamson@redhat.com>
In-Reply-To: <20211020164629.GG2744544@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
        <20211019105838.227569-15-yishaih@nvidia.com>
        <20211019125513.4e522af9.alex.williamson@redhat.com>
        <20211019191025.GA4072278@nvidia.com>
        <5cf3fb6c-2ca0-f54e-3a05-27762d29b8e2@nvidia.com>
        <20211020164629.GG2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Oct 2021 13:46:29 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Oct 20, 2021 at 11:46:07AM +0300, Yishai Hadas wrote:
> 
> > What is the expectation for a reasonable delay ? we may expect this system
> > WQ to run only short tasks and be very responsive.  
> 
> If the expectation is that qemu will see the error return and the turn
> around and issue FLR followed by another state operation then it does
> seem strange that there would be a delay.
> 
> On the other hand, this doesn't seem that useful. If qemu tries to
> migrate and the device fails then the migration operation is toast and
> possibly the device is wrecked. It can't really issue a FLR without
> coordinating with the VM, and it cannot resume the VM as the device is
> now irrecoverably messed up.
> 
> If we look at this from a RAS perspective would would be useful here
> is a way for qemu to request a fail safe migration data. This must
> always be available and cannot fail.
> 
> When the failsafe is loaded into the device it would trigger the
> device's built-in RAS features to co-ordinate with the VM driver and
> recover. Perhaps qemu would also have to inject an AER or something.
> 
> Basically instead of the device starting in an "empty ready to use
> state" it would start in a "failure detected, needs recovery" state.

The "fail-safe recovery state" is essentially the reset state of the
device.  If a device enters an error state during migration, I would
think the ultimate recovery procedure would be to abort the migration,
send an AER to the VM, whereby the guest would trigger a reset, and
the RAS capabilities of the guest would handle failing over to a
multipath device, ejecting the failing device, etc.

However, regardless of the migration recovery strategy, userspace needs
a means to get the device back into an initial state in a deterministic
way without closing and re-opening the device (or polling for an
arbitrary length of time).  That's the minimum viable product here.
Thanks,

Alex

