Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1647C10536E
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 14:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKUNol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 08:44:41 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46711 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKUNol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 08:44:41 -0500
Received: by mail-qk1-f194.google.com with SMTP id h15so2990876qka.13
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 05:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sfhj/BSpAXObGx+Uv9hTYzsrf84iVXtz5oXZyiZdeuk=;
        b=aD0tG2KM+cuLPXFQVDIolHb83uQBvoIv6SUHiABQp0tUGCUKg8utJnNZCBA0Ny6YT1
         bUkfqKhY8qGK8GmIcS+uubUZ8tcOnuG43Hhah64TPdrqISKZrLfvf1vf1u7jBWxP/Awn
         4jyaYiatRdPnvmqxPe0Y6usPOyGiwVPocK1+BTJcwhErQDxSQl7JM4Y2Gc2knN6FJK+Y
         8pzXexyHb1IElwZVk8C1MVn+NKHGIafiaFtGPmM+DYtlh/B/RWu6AOZGc9UOjA6ltWAN
         Gk6Rx9q+FAug6ZidnXXrYcoea0y2rIiJiUHUZA5//CxfZLTWGJfqidpje/5nFV3uVbge
         /ilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sfhj/BSpAXObGx+Uv9hTYzsrf84iVXtz5oXZyiZdeuk=;
        b=rqUIiezGKGpLORxoaYpe8rpiw2KE9CPbaccGDowmLsr86d/CEhI9PARaEcr+WfsqHW
         AcREu+nrOKH6ZLKRrwOIUgUZjJFmF8LKJ7wS+4drCOCQNbk0rH4jsdAPpZNIE6AxJhbi
         z/PsHxV/m9NDUryDn0u5VYgrStO8mJ9+ZJ9WZB8hd6RMYBZuPP+rzSql70fgKu1xeO4t
         FtcIAdp0zbL6y/pNmLXhUkCapVXyTW4UJk4GzHO17BXeTvpRICoH3PdqmKaf+Hs+8Tlm
         fARp5DqO500TvLAMb9z/CAm29SK6wTfvE+njnOQxmuBW4DeT+VkeHtZPCACQhJXOKILM
         43wg==
X-Gm-Message-State: APjAAAUkLH3p390c4NheAkILYQyd4eJ6Us2zVgCbue9g0Kt3X8koIaBv
        uGy1WPEjyQCPQ0ou/1RLGMsAs//eD08=
X-Google-Smtp-Source: APXvYqwWIbMyx3iFrKk95JWvSl6/fsnsiqMLBdbVXS3zWSqrU5zmc0Ff5bmuvBhA5/C3CTAOexD04g==
X-Received: by 2002:a05:620a:2185:: with SMTP id g5mr8024518qka.129.1574343879984;
        Thu, 21 Nov 2019 05:44:39 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id o201sm1395090qka.17.2019.11.21.05.44.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Nov 2019 05:44:38 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXmlC-0002Gd-Fz; Thu, 21 Nov 2019 09:44:38 -0400
Date:   Thu, 21 Nov 2019 09:44:38 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <20191121134438.GA7448@ziepe.ca>
References: <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca>
 <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <20191120232320-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120232320-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 11:24:03PM -0500, Michael S. Tsirkin wrote:
> On Wed, Nov 20, 2019 at 11:03:57PM -0400, Jason Gunthorpe wrote:
> > Frankly, when I look at what this virtio stuff is doing I see RDMA:
> >  - Both have a secure BAR pages for mmaping to userspace (or VM)
> >  - Both are prevented from interacting with the device at a register
> >    level and must call to the kernel - ie creating resources is a
> >    kernel call - for security.
> >  - Both create command request/response rings in userspace controlled
> >    memory and have HW DMA to read requests and DMA to generate responses
> >  - Both allow the work on the rings to DMA outside the ring to
> >    addresses controlled by userspace.
> >  - Both have to support a mixture of HW that uses on-device security
> >    or IOMMU based security.
> 
> The main difference is userspace/drivers need to be portable with
> virtio.

rdma also has a stable/portable user space library API that is
portable to multiple operating systems.

What you don't like is that RDMA userspace has driver-specific
code. Ie the kernel interface is not fully hardware independent.

Jason
