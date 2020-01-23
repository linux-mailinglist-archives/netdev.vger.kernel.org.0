Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A784C146AF2
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAWOOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:14:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbgAWOOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 09:14:42 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACB7E20718;
        Thu, 23 Jan 2020 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579788882;
        bh=VMRwMGW03yqZGb6m6UyADnOPSXlAN3XCuYv/tzXx9Ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GBsV2tD+njdvN5T9HOmyBPc9NIF33AXSr4Mmo6eSeMNuesWCcoSQhuPks72BbmW9T
         wvYigIZzoyEl6/p1tsI/OZ1lEiq6MBTvAsDWZ4KJdtZQ6tMWGM1SFlzgg9VvfyD+Hx
         nmMVey09SF2I8PbzvYoENNxWMxLSXjGrlruU0W94=
Date:   Thu, 23 Jan 2020 06:14:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Aleksey Makarov <amakarov@marvell.com>
Subject: Re: [PATCH v4 02/17] octeontx2-pf: Mailbox communication with AF
Message-ID: <20200123061440.171e93f6@cakuba>
In-Reply-To: <CA+sq2Ce7nFbPu33Cu5YwgfEdfjOSWQwA1nijjtF7KKBYSph1TQ@mail.gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579612911-24497-3-git-send-email-sunil.kovvuri@gmail.com>
        <20200121080029.42b6ea7d@cakuba>
        <CA+sq2Ce7nFbPu33Cu5YwgfEdfjOSWQwA1nijjtF7KKBYSph1TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 00:57:22 +0530, Sunil Kovvuri wrote:
> > I'm slightly concerned about the use of non-iomem helpers like memset
> > and memcpy on what I understand to be IOMEM, and the lack of memory
> > barriers. But then again, I don't know much about iomem_wc(), is this
> > code definitely correct from memory ordering perspective?
> > (The memory barrier in otx2_mbox_msg_send() should probably be just
> > wmb(), syncing with HW is unrelated with SMP.)  
> 
> The mailbox region is a normal memory which is exposed to two devices
> via PCI BARs.
> And the writeq() call (to trigger IRQ) inside otx2_mbox_msg_send() has a wmb().

Oka, fine, if it works it works, I guess.
