Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058AE2C9532
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 03:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgLAC3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 21:29:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbgLAC3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 21:29:53 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59CBA20809;
        Tue,  1 Dec 2020 02:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606789752;
        bh=qmSgtrpGDoagvz4Citm0tPgCTGgHPEJNbRWr+dAB5pY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yZObzgkb5UzIRyJKwc8ErAvDLIqCbJN8w6VD1chkJCRbfZcZAfeEcZfbTiNcfU5fs
         X4BrJ9EktyeC6S/BhHluXIYDMLLBnZ+QlaegXz+e3lP4gv/bPewk+2hFhBe9UBm9Fy
         aZ6NROIMjHTKqO/14851z/NyGEsDYDOwD9ixcPgA=
Date:   Mon, 30 Nov 2020 18:29:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Cherian <george.cherian@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <saeed@kernel.org>, <jiri@resnulli.us>
Subject: Re: [PATCHv5 net-next 2/3] octeontx2-af: Add devlink health
 reporters for NPA
Message-ID: <20201130182910.49ea8c8c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201126140251.963048-3-george.cherian@marvell.com>
References: <20201126140251.963048-1-george.cherian@marvell.com>
        <20201126140251.963048-3-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 19:32:50 +0530 George Cherian wrote:
> Add health reporters for RVU NPA block.
> NPA Health reporters handle following HW event groups
>  - GENERAL events
>  - ERROR events
>  - RAS events
>  - RVU event
> An event counter per event is maintained in SW.
> 
> Output:
>  # devlink health
>  pci/0002:01:00.0:
>    reporter hw_npa
>      state healthy error 0 recover 0
>  # devlink  health dump show pci/0002:01:00.0 reporter hw_npa
>  NPA_AF_GENERAL:
>         Unmap PF Error: 0
>         NIX:
>         0: free disabled RX: 0 free disabled TX: 0
>         1: free disabled RX: 0 free disabled TX: 0
>         Free Disabled for SSO: 0
>         Free Disabled for TIM: 0
>         Free Disabled for DPI: 0
>         Free Disabled for AURA: 0
>         Alloc Disabled for Resvd: 0
>   NPA_AF_ERR:
>         Memory Fault on NPA_AQ_INST_S read: 0
>         Memory Fault on NPA_AQ_RES_S write: 0
>         AQ Doorbell Error: 0
>         Poisoned data on NPA_AQ_INST_S read: 0
>         Poisoned data on NPA_AQ_RES_S write: 0
>         Poisoned data on HW context read: 0
>   NPA_AF_RVU:
>         Unmap Slot Error: 0

You seem to have missed the feedback Saeed and I gave you on v2.

Did you test this with the errors actually triggering? Devlink should
store only one dump, are the counters not going to get out of sync
unless something clears the dump every time it triggers?
