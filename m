Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0607B153185
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 14:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgBENO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 08:14:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48268 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727104AbgBENO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 08:14:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580908495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QuNXmwS8sysRc0ThXGMCmTTQlX8tFR45lSd0PUTiOGs=;
        b=CzvJwhwXrycMJnKvpCWji+0amMkonKqF/bG//ByPBF59iq3kYYjy0F5ebHXAZlYr9RG7eV
        U690ZpS/GYaOohPjq5mweRKtcUieVkAObnf7tfLLtFPX8+WuzzxwiJXnDcJI+VfOKD/8W1
        1zaCRT901L2/EwMsv8hm36qP5XUPMcA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-ikBgPCoePJyYxyPhNjwITA-1; Wed, 05 Feb 2020 08:14:54 -0500
X-MC-Unique: ikBgPCoePJyYxyPhNjwITA-1
Received: by mail-qv1-f70.google.com with SMTP id l1so1431444qvu.13
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 05:14:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QuNXmwS8sysRc0ThXGMCmTTQlX8tFR45lSd0PUTiOGs=;
        b=P9ofC69p/F+9objvkGRe0YwrgIPxmcA7jdDuYquNgHIiA0h57M52WFD3mhcnY4zjzj
         1nGqTL5ua2FIu7fyeCmWiBEMqWGLlTNRl7fGt3AFmBdfVWnZmzQNNMlI1Mpra2mB2deu
         cBr3Z5/KbaSEWzowyMudBQHza+540n4OxoJbmS3MD5Tl4YHw5R9/i2YaiE102Ggmc6oX
         wcLsGt8mMd5GMO+OWnC4rxxhRpT1sAW3LRfy8tV/aF6Yvgl/GttgtcHdfkqftgJnR4ia
         WH6dxf42jVst6MEEpe9gUPz+wtca2VyS12iJuvYTp+E+Zu1R0pha8gGm6+/FpPjfpnfP
         4NBQ==
X-Gm-Message-State: APjAAAVIX3f9he2Ao/mabosXPRzlGJtJWyDdqfLnTY528ThRhmdU/CNL
        U6V2JEE5thKNbIRZZVRcbJSnXmIwUvaDLh0c+cocueJRFAqvALUhvCRyZKj53ANAzxZ5SFnc+NK
        xf+HKmCCz44Gsmg6R
X-Received: by 2002:a37:6551:: with SMTP id z78mr34386877qkb.144.1580908493733;
        Wed, 05 Feb 2020 05:14:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPJbBNbk5endfccq+ku5moWMnpzgaXCLDqjaEgV35BhSBP12RgV6EFcH2z1a9H9HuZasXKOQ==
X-Received: by 2002:a37:6551:: with SMTP id z78mr34386840qkb.144.1580908493533;
        Wed, 05 Feb 2020 05:14:53 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id c45sm14187780qtd.43.2020.02.05.05.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 05:14:52 -0800 (PST)
Date:   Wed, 5 Feb 2020 08:14:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "dan.daly@intel.com" <dan.daly@intel.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200205081210-mutt-send-email-mst@kernel.org>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
 <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
 <20200205125648.GV23346@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205125648.GV23346@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 05, 2020 at 08:56:48AM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 05, 2020 at 03:50:14PM +0800, Jason Wang wrote:
> > > Would it be better for the map/umnap logic to happen inside each device ?
> > > Devices that needs the IOMMU will call iommu APIs from inside the driver callback.
> > 
> > Technically, this can work. But if it can be done by vhost-vpda it will make
> > the vDPA driver more compact and easier to be implemented.
> 
> Generally speaking, in the kernel, it is normal to not hoist code of
> out drivers into subsystems until 2-3 drivers are duplicating that
> code. It helps ensure the right design is used
> 
> Jason

That's up to the sybsystem maintainer really, as there's also some
intuition involved in guessing a specific API is widely useful.
In-kernel APIs are flexible, if we find something isn't needed we just
drop it.

-- 
MST

