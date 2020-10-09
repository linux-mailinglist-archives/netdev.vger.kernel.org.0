Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE2F287FB3
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 03:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgJIBBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 21:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725952AbgJIBBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 21:01:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4512206A1;
        Fri,  9 Oct 2020 01:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602205270;
        bh=3jYARCQ+vnFKbSZFj/JZAIsiVetKF+4uSTOzrhXQGLE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DAmf+4NF5FqYytatVvXn+LjbEHytcORpgbytngs175xNg/6f0NHc+TQbiIQM3WFSY
         /QXklIQ5uoGfPe5oaRPwwfngpQ85qd90r3PFGt9QueYyrlYCk8L2vWtWQ5PW8PlzjT
         mdM3pg+pIzZICZSG4cmRyCSwV14h1D6i2Hh+X310=
Date:   Thu, 8 Oct 2020 18:01:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ne2k-pci: Enable RW-Bugfix
Message-ID: <20201008180108.43e502a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006165606.7313-1-W_Armin@gmx.de>
References: <20201006165606.7313-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 18:56:06 +0200 Armin Wolf wrote:
> Enable the ne2k-pci Read-before-Write Bugfix
> since not doing so could (according to the Datasheet)
> cause the system to lock up with some chips.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> ---
>  drivers/net/ethernet/8390/ne2k-pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8390/ne2k-pci.c
> index bc6edb3f1af3..a1319cd86ab9 100644
> --- a/drivers/net/ethernet/8390/ne2k-pci.c
> +++ b/drivers/net/ethernet/8390/ne2k-pci.c
> @@ -91,7 +91,7 @@ MODULE_PARM_DESC(full_duplex, "full duplex setting(s) (1)");
>  #define USE_LONGIO
> 
>  /* Do we implement the read before write bugfix ? */
> -/* #define NE_RW_BUGFIX */
> +#define NE_RW_BUGFIX

This doesn't do anything, does it:

$ git grep NE_RW_BUGFIX
drivers/net/ethernet/8390/ne.c:/* #define NE_RW_BUGFIX */
drivers/net/ethernet/8390/ne2k-pci.c:/* #define NE_RW_BUGFIX */

