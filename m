Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6590D0BA4
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 11:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbfJIJoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 05:44:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbfJIJoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 05:44:38 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A3BE881F18
        for <netdev@vger.kernel.org>; Wed,  9 Oct 2019 09:44:37 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id o128so1969191wmo.1
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 02:44:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IgLlslTtHyY/DsCT/GempjMqnPIRbjKjjsT71GS80BU=;
        b=bF7sDNMpPZo5Zj2TOPuumPR37x3Km3Ub41+lr9kCNNqqhBjWDWxL2lJVJNPmZxNa5B
         mXOr3IX0OXicYRibHyddcdAm0AqJqkMqq/gWO4wVh5slFCGdSD+ui0GMKk+hh9/sMM3T
         YRmrXGvMVEOfcS8sxhiO5V8KAbR+g76BzUCfaPAaOKxmXE46MmUhl+6yYBuwVnpGyQuf
         C9hYVBed78aWO6O1i311eBrgMxTMWJ7op3fsvP6f8ONxPCFtgIETspQnEOF+PceYRq7u
         4qxrjSMZTea5xvnbSTO+Cc5umBArfP1hAXgYBk+50nhaQizdQTT3LuHbYauJDx+xWT7D
         4Fig==
X-Gm-Message-State: APjAAAUO2+eTybwxHOCBdpl3f5As0iKR4OkoHcJQP55+52uRtLQI1HEv
        1eIOuBzFUY6whjzruiQduMZbIDwA0zVJhXC23UO/hKrLrlyIFbToDZ7SCrnRUUJ5H3GuU/5z18x
        zq6Wxfhe7httYZuRI
X-Received: by 2002:a1c:7311:: with SMTP id d17mr1768162wmb.49.1570614275926;
        Wed, 09 Oct 2019 02:44:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy4Wse3vGoQIgd/ml9oYw6+IUa/k66QMkr3IXKbfsrgPgFKxrYzXylx/6gMsMm5PeJvNXxJPg==
X-Received: by 2002:a1c:7311:: with SMTP id d17mr1768146wmb.49.1570614275686;
        Wed, 09 Oct 2019 02:44:35 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id a3sm1320859wmj.35.2019.10.09.02.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 02:44:35 -0700 (PDT)
Date:   Wed, 9 Oct 2019 11:44:32 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>
Cc:     linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 11/13] vsock: add 'transport_hg' to handle g2h\h2g
 transports
Message-ID: <20191009094432.by5zs4c3binrznpp@steredhat>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-12-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-12-sgarzare@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 01:27:01PM +0200, Stefano Garzarella wrote:
> VMCI transport provides both g2h and h2g behaviors in a single
> transport.
> We are able to set (or not) the g2h behavior, detecting if we
> are in a VMware guest (or not), but the h2g feature is always set.
> This prevents to load other h2g transports while we are in a
> VMware guest.
> 
> This patch adds a new 'transport_hg' to handle this case, reducing
> the priority of transports that provide both g2h and h2g
> behaviors. A transport that has g2h and h2g features, can be
> bypassed by a transport that has only the h2g feature.
> 

Since I'm enabling the VSOCK_TRANSPORT_F_G2H in the vmci_transport only
when we run in a VMware guest, this patch doesn't work well if a KVM (or
HyperV) guest application create an AF_VSOCK socket and no transports are
loaded, because in this case the vmci_transport is loaded
(MODULE_ALIAS_NETPROTO(PF_VSOCK)) and it is registered as transport_h2g.

At this point, if we want to run a nested VM using vhost_transport, we
can't load it.

So, I can leave VSOCK_TRANSPORT_F_G2H always set in the vmci_transport
and this should fix this issue.
Or maybe I need to change how the registering works, e.g. handling a list
of transport registered, setting priority or using the last registered
transport.

Any suggestion?

Thanks,
Stefano
