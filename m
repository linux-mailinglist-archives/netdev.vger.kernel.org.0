Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A024831A442
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhBLSId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:08:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231304AbhBLSIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:08:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613153208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IsKCNOETLXXhO0vv4Uv4utq9x/Y2rRSM/dS8wn5MRYQ=;
        b=ZqQGLAIJQ1Ttd7dRUy/DX83Ex42HwM62MFsJPzUzhQ5udmgXzsMkEY2RQHmmZZA0kEq36r
        rIQNZ1fFCpssqv9oCuXYTYMp7FisoyPrZmdwawNozj0m4EZIexMcPv/m+pDEVv+mAeWfAM
        WVPl58yxuhNWcqOCMlNfApcqO/odCSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-R1WhqZ39Npi4u-1T5zwSEw-1; Fri, 12 Feb 2021 13:06:44 -0500
X-MC-Unique: R1WhqZ39Npi4u-1T5zwSEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FB5D1934104;
        Fri, 12 Feb 2021 18:06:42 +0000 (UTC)
Received: from localhost (ovpn-114-86.phx2.redhat.com [10.3.114.86])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 40A4F19D6C;
        Fri, 12 Feb 2021 18:06:41 +0000 (UTC)
Date:   Fri, 12 Feb 2021 10:06:39 -0800
From:   Chris Leech <cleech@redhat.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, aelior@marvell.com, mkalderon@marvell.com,
        nassa@marvell.com, malin1024@gmail.com, Douglas.Farley@dell.com,
        Erik.Smith@dell.com, kuba@kernel.org, pkushwaha@marvell.com,
        davem@davemloft.net
Subject: Re: [RFC PATCH v3 00/11] NVMeTCP Offload ULP and QEDN Device Driver
Message-ID: <20210212180639.GA511742@localhost>
References: <20210207181324.11429-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207181324.11429-1-smalin@marvell.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 08:13:13PM +0200, Shai Malin wrote:
> Queue Initialization:
> =====================
> The nvme-tcp-offload ULP module shall register with the existing 
> nvmf_transport_ops (.name = "tcp_offload"), nvme_ctrl_ops and blk_mq_ops.
> The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
> with the following ops:
>  - claim_dev() - in order to resolve the route to the target according to
>                  the net_dev.
>  - create_queue() - in order to create offloaded nvme-tcp queue.
> 
> The nvme-tcp-offload ULP module shall manage all the controller level
> functionalities, call claim_dev and based on the return values shall call
> the relevant module create_queue in order to create the admin queue and
> the IO queues.

Hi Shai,

How well does this claim_dev approach work with multipathing?  Is it
expected that providing HOST_TRADDR is sufficient control over which
offload device will be used with multiple valid paths to the controller?

- Chris

