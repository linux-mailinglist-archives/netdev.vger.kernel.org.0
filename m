Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D03371049A7
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 05:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfKUEYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 23:24:14 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44967 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725819AbfKUEYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 23:24:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574310253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7MiQoAlmb+4j2v6SgDa1Q9v4RQh84PVKLEKwv2xgY9M=;
        b=gEch4m1qzcF6yqePg0p2ZUQj3bkUyRZ6K3qpkMUtKLCinA91VVr27eioWTrAZ0ChQLkNyA
        SBWdP6ea22rp1V/mWSs+nsgWTZLHhCgp/n3Ty50onkiMyFcIRXt1AhBB0FjrYAmCZ5wjio
        mPuxVQK9QIs66xbyvzQY6oG16/Rty8o=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-pFdamXueNWiiozYvSpesMw-1; Wed, 20 Nov 2019 23:24:10 -0500
Received: by mail-qt1-f198.google.com with SMTP id h15so1464898qtn.6
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 20:24:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h002/KfwzNnHwaVFHvMAKKzPg+NcqTlO07ep/sFR+MI=;
        b=mJGyuwpDXNw6NYstuIJj8rDt0G8SgYAKz0PEDKcdnupWbmXTjKr0mpHt+20btjRiX/
         bLRFli5bBjf3jObsKiqDQw2KMMneMhf1s3OfHUMFViu250WU3t3fbHZZ5Sok2Ai7twMk
         3I3ytvZisG4gNnN4fXcDL2AIIdUEGL2CA6WSte+ulL836YgI7aZDsWhWbLBX3waoBrJo
         3gpBpd87JiHY4EwjSeHP4pRL7Ps0KdwhsTegju6wngZ1fyigAZDowqVRvj3gSUu9DeEs
         vhMwY/QZwGAFVW0ekp7j3Iyj/A4bm86Wxw+z3nAuSBrp5cthOqSH5LBsZsLb97t4bAiM
         p1Rw==
X-Gm-Message-State: APjAAAUGi5FFamZyw+vH6EVHW6K9N2SW/Caqv6EJgsVSPj3WQo3ujZnd
        Dg6RHDrOEl/jWVWfMqGO6scO3sT9Y0R8rFRnIewCvB6NRce1MGB8k7RUItAKKyd6Ths7FoHOcyG
        Qbl2KrHFII5ZntIak
X-Received: by 2002:a37:ac09:: with SMTP id e9mr6184768qkm.258.1574310250073;
        Wed, 20 Nov 2019 20:24:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqw7XNl+H+UW6snu6/5KF765mQrBqtDgv/zVy1Mne2H0maYjusu3isdX7aEJ7G7ZUYWVtX6mNw==
X-Received: by 2002:a37:ac09:: with SMTP id e9mr6184754qkm.258.1574310249852;
        Wed, 20 Nov 2019 20:24:09 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id b185sm809197qkg.45.2019.11.20.20.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 20:24:08 -0800 (PST)
Date:   Wed, 20 Nov 2019 23:24:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191120232320-mutt-send-email-mst@kernel.org>
References: <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca>
 <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20191121030357.GB16914@ziepe.ca>
X-MC-Unique: pFdamXueNWiiozYvSpesMw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 11:03:57PM -0400, Jason Gunthorpe wrote:
> Frankly, when I look at what this virtio stuff is doing I see RDMA:
>  - Both have a secure BAR pages for mmaping to userspace (or VM)
>  - Both are prevented from interacting with the device at a register
>    level and must call to the kernel - ie creating resources is a
>    kernel call - for security.
>  - Both create command request/response rings in userspace controlled
>    memory and have HW DMA to read requests and DMA to generate responses
>  - Both allow the work on the rings to DMA outside the ring to
>    addresses controlled by userspace.
>  - Both have to support a mixture of HW that uses on-device security
>    or IOMMU based security.

The main difference is userspace/drivers need to be portable with
virtio.

--=20
MST

