Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D7F2FC010
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 20:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbhASTc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 14:32:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403980AbhASTPB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 14:15:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B609820706;
        Tue, 19 Jan 2021 19:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611083661;
        bh=fx4XzfhwiKnOxIp5MkgmOCMIAfCbTNKkZWY/iBxYc68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fgINYSNE1KJQ/y17f3kOK6ZDv8TT8VSY5Criw0OhXtcml1nesXUeQtOdaf8uPys23
         pXhWi8HL4D9AcE1Iiz/JRGaIFDxFTz0BxxC81bTfwBFzLAnxVVZ52c+nny0JXl5hh3
         iFkIuyizPlArEWVatphY6IQZlbtdS6nPEcphVTOUXQqGla9Ja7wutSCATqr0wXgdpX
         JU7hig6SXdTCs9GiiCKASSk9/YySZoGWulhmpCtLJxyyJJgNlqIaS83PJd5qVmricj
         EHoI5nTvQX62AAn2NdQ2klRO/UCGU4h8qvXptFxegvU4K13ALLA04zam3LuFt2VLrY
         PQyUKQGMqOO0A==
Date:   Tue, 19 Jan 2021 11:14:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        wangyunjian <wangyunjian@huawei.com>, jasowang@redhat.com,
        willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Subject: Re: [PATCH net-next v7] vhost_net: avoid tx queue stuck when
 sendmsg fails
Message-ID: <20210119111419.20be1cf0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119045607-mutt-send-email-mst@kernel.org>
References: <1610685980-38608-1-git-send-email-wangyunjian@huawei.com>
        <20210118143329.08cc14a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210119045607-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 04:56:59 -0500 Michael S. Tsirkin wrote:
> On Mon, Jan 18, 2021 at 02:33:29PM -0800, Jakub Kicinski wrote:
> > On Fri, 15 Jan 2021 12:46:20 +0800 wangyunjian wrote:  
> > > From: Yunjian Wang <wangyunjian@huawei.com>
> > > 
> > > Currently the driver doesn't drop a packet which can't be sent by tun
> > > (e.g bad packet). In this case, the driver will always process the
> > > same packet lead to the tx queue stuck.
> > > 
> > > To fix this issue:
> > > 1. in the case of persistent failure (e.g bad packet), the driver
> > >    can skip this descriptor by ignoring the error.
> > > 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
> > >    the driver schedules the worker to try again.
> > > 
> > > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>  
> > 
> > Michael, LMK if you want to have a closer look otherwise I'll apply
> > tomorrow.  
> 
> Thanks for the reminder. Acked.

Applied, thanks everyone!
