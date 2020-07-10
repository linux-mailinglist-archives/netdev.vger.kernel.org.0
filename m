Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C33B21B350
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 12:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgGJKnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 06:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726816AbgGJKnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 06:43:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A442920767;
        Fri, 10 Jul 2020 10:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594377781;
        bh=EW9MXB8Q/dnRDJNPSoM2A4yEsAsEcseFCmlJ8Ror7LM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tgf16EmbXRYSEQZYn/cD34QnoXjzA8+ynp8kG9ZTETZVgYmoZQ9HvJcHNXOiKeHSn
         ehE3cqhz2C4YyZLSq60EHVpE21xVtudo/UnjDSVTbJXS6+ZLI1L1JyynmCLNZ/0g6z
         AvmxePRff76ZbZNo72ZomEjDcZUd8MKCvgjWHDRI=
Date:   Fri, 10 Jul 2020 12:43:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH v2] net/bluetooth: Fix
 slab-out-of-bounds read in hci_extended_inquiry_result_evt()
Message-ID: <20200710104306.GA1229536@kroah.com>
References: <20200709051802.185168-1-yepeilin.cs@gmail.com>
 <20200709130224.214204-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709130224.214204-1-yepeilin.cs@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 09:02:24AM -0400, Peilin Ye wrote:
> Check upon `num_rsp` is insufficient. A malformed event packet with a
> large `num_rsp` number makes hci_extended_inquiry_result_evt() go out
> of bounds. Fix it.
> 
> This patch fixes the following syzbot bug:
> 
>     https://syzkaller.appspot.com/bug?id=4bf11aa05c4ca51ce0df86e500fce486552dc8d2
> 
> Reported-by: syzbot+d8489a79b781849b9c46@syzkaller.appspotmail.com
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Bluetooth maintainers, can you also add a cc: stable on this so it gets
picked up properly there?

thanks,

greg k-h
