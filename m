Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B173F103B8C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfKTNdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:33:53 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38987 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730719AbfKTNdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 08:33:53 -0500
Received: by mail-qk1-f196.google.com with SMTP id o17so1196823qko.6
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 05:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lHwaR6/WO4EIY3OB0Bp2r80uiqkTlHfpUMPdQjF1F40=;
        b=X3IeqZazpQyunNoTxZPYg99GZqBJfUQ8BzxHwH63wYR8YzajGvYZveT8CeqKo71obv
         9RtZVDcw+TBpRDkwK0od7MV2UYNwnZehSC+pvKngMW71nxxMjrHkF+UFHgq64ZJMXNJy
         s8reO2jrZAwPnuCBq6Nhi+LR9obhetMhkNyM6w0YPMTYK5y8WCM5HIJRyqKe8Lq2M8vV
         sdHm/aoccg/tpPhklqDl4YNAgbr+voHM5RCNhwtuNtCvCO2vOwiBKLRLYRActUgVKROG
         K+/XLWdOS8Cb6VWWRlE5XQ/C9rBOV4YaEeXd/OKL+ORPd7X/AjOTGc6+hHZAlG+24I5E
         mTSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lHwaR6/WO4EIY3OB0Bp2r80uiqkTlHfpUMPdQjF1F40=;
        b=Iux0wRKNtlir2dtZtzwPO6j5tTOF5HztEJbVQ02seBlK20SCVEsOuVQyULE4o9ezox
         WkyfZC4IPXq8c+C3Z8VHMcc1cdG0n/9C996VOE16a6NHZ+UoSQoqUHHJHVCND9kvJxDZ
         G80w45zAbjvTJEMxfgiOjPNR37qvtMWHE6xFjW5ZZUXCP499CR6GpqhJpYm23TA8NjGb
         nFXFkB+x68ClMpuJD9FJQt/eFds7670JqHBg+uZWDub0hh/hH6CdPi+nK2TUERYRMbUC
         utGxHRNcm/BI+qJHEI2vX5QbjtdwcRyZOKDQPXb7HsBrLi7bra6dnO/hHFfULbEPyqMA
         QBiA==
X-Gm-Message-State: APjAAAVAeUPHAwckxpMgm98n8vUDV9anLOvKClQLlHI54q51h/DNC0GC
        DqFIsk7qrItTnl3GW2/nt3r58A==
X-Google-Smtp-Source: APXvYqy+v3ozm4OkRHeJLSgSJ2hFg+6vhPRdqVDtfSCeWASV4Rq+UhH8Q+Z7UeeTR0+RLAUm6ZrzZA==
X-Received: by 2002:a37:610f:: with SMTP id v15mr2242412qkb.98.1574256830792;
        Wed, 20 Nov 2019 05:33:50 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id d18sm11656509qko.112.2019.11.20.05.33.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Nov 2019 05:33:50 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXQ7B-0006YE-M3; Wed, 20 Nov 2019 09:33:49 -0400
Date:   Wed, 20 Nov 2019 09:33:49 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191120133349.GB22515@ziepe.ca>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <20191119164632.GA4991@ziepe.ca>
 <1655636323.35622504.1574220291482.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655636323.35622504.1574220291482.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 10:24:51PM -0500, Jason Wang wrote:

> > The driver providing the virtio should really be in control of the
> > life cycle policy. For net related virtio that is clearly devlink.
> 
> As replied in another thread, there were already existed devices
> (Intel IFC VF) that doesn't use devlink.

Why is that a justification? Drivers can learn to use devlink, it
isn't like it is set in stone.

Jason
