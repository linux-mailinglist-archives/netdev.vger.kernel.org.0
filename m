Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FEA39F0FA
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhFHId6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFHId5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 04:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 299D06124B;
        Tue,  8 Jun 2021 08:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623141125;
        bh=bWFAmKd3DNZ+NkTU8ZsF5ftLYqiBVXsIWH5ZAF+xP4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hFI58qU597v46ZY746x3xrEZgo6uu+TuqBXM9QpZ2/baCj6ZTtmHTrfO6RkDw4yfm
         Lnjwl1iQCvCdFRAScDBLAMqVYI1Fv88Jue3ktj71s3EobuX3WQBNRDxKxZLL9bva7L
         sUapmD98BOr6hBnhyvo0pponS2gGC1rSy6lwLlrs=
Date:   Tue, 8 Jun 2021 10:32:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Hao Xiong <mart1n@zju.edu.cn>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] Bluetooth: fix the erroneous flush_work() order
Message-ID: <YL8rAlo56DT9Ok0B@kroah.com>
References: <20210525123902.189012-1-gregkh@linuxfoundation.org>
 <BF0493D4-AB96-44D3-8229-9EA6D084D260@holtmann.org>
 <YL73vTBtgWkaup+A@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL73vTBtgWkaup+A@eldamar.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 06:53:17AM +0200, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Thu, May 27, 2021 at 10:14:59PM +0200, Marcel Holtmann wrote:
> > Hi Greg,
> > 
> > > In the cleanup routine for failed initialization of HCI device,
> > > the flush_work(&hdev->rx_work) need to be finished before the
> > > flush_work(&hdev->cmd_work). Otherwise, the hci_rx_work() can
> > > possibly invoke new cmd_work and cause a bug, like double free,
> > > in late processings.
> > > 
> > > This was assigned CVE-2021-3564.
> > > 
> > > This patch reorder the flush_work() to fix this bug.
> > > 
> > > Cc: Marcel Holtmann <marcel@holtmann.org>
> > > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: linux-bluetooth@vger.kernel.org
> > > Cc: netdev@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Lin Ma <linma@zju.edu.cn>
> > > Signed-off-by: Hao Xiong <mart1n@zju.edu.cn>
> > > Cc: stable <stable@vger.kernel.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > > net/bluetooth/hci_core.c | 7 ++++++-
> > > 1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > patch has been applied to bluetooth-stable tree.
> 
> Can you queue this one as well for the stable series? It is
> 6a137caec23aeb9e036cdfd8a46dd8a366460e5d commit upstream and in
> 5.13-rc5.

It's now queued up, thanks.

greg k-h
