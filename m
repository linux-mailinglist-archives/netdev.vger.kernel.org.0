Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB93354224
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 14:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbhDEMnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 08:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235651AbhDEMnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 08:43:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5527561396;
        Mon,  5 Apr 2021 12:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617626597;
        bh=aO8jOlowOVFX3yCLeTiPa9zFKgY8EJS3aehcnkAtI4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G+Nk4tMBjWHvOnlDpesCw0SVkpsk9zTB0BAjqs2nImZzhwM7sTMvKMx3Uf03+uvC7
         uf4sKP8GvY4eD7d2BWDPeEgjV+vCH7xkT5ZwXlVkVOLgn/dufth/lpiYkjXib6EOrC
         iErkKoJLa1aMsDXBzu9s1vWopulBDnuuWaDsn7NS5JM0NABi8Ya2bf4++EhvncKkSb
         r1a2ncUNWgyTMA30Go5kueQQLh2L/SRdzbw2S8CZRhJJjbgJYhFK+5RDl8uTOsnzY/
         +Xv6lwBdrh8frMkPQkFkRdWC3AaObm6E+z0HtJMyc6vRoBPDVuqnYKtQgn+zvChPm3
         IzY5174v/k+sw==
Date:   Mon, 5 Apr 2021 15:43:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: Re: [PATCH net 1/2] net: hns3: Remove the left over redundant check
 & assignment
Message-ID: <YGsF4Q4XlvpoBUJY@unreal>
References: <20210403013520.22108-1-salil.mehta@huawei.com>
 <20210403013520.22108-2-salil.mehta@huawei.com>
 <YGlb6CgaW5r4lwaC@unreal>
 <09176e61b8ca495f8c20b94845d26ba0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09176e61b8ca495f8c20b94845d26ba0@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 12:26:37PM +0000, Salil Mehta wrote:
> Hi Leon,
> Thanks for the review.
> 
> > From: Leon Romanovsky [mailto:leon@kernel.org]
> > Sent: Sunday, April 4, 2021 7:26 AM
> > To: Salil Mehta <salil.mehta@huawei.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Linuxarm <linuxarm@huawei.com>;
> > linuxarm@openeuler.org
> > Subject: Re: [PATCH net 1/2] net: hns3: Remove the left over redundant check
> > & assignment
> > 
> > On Sat, Apr 03, 2021 at 02:35:19AM +0100, Salil Mehta wrote:
> > > This removes the left over check and assignment which is no longer used
> > > anywhere in the function and should have been removed as part of the
> > > below mentioned patch.
> > >
> > > Fixes: 012fcb52f67c ("net: hns3: activate reset timer when calling
> > reset_event")
> > > Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> > > ---
> > >  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 --
> > >  1 file changed, 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > index e3f81c7e0ce7..7ad0722383f5 100644
> > > --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > @@ -3976,8 +3976,6 @@ static void hclge_reset_event(struct pci_dev *pdev,
> > struct hnae3_handle *handle)
> > >  	 * want to make sure we throttle the reset request. Therefore, we will
> > >  	 * not allow it again before 3*HZ times.
> > >  	 */
> > > -	if (!handle)
> > > -		handle = &hdev->vport[0].nic;
> > 
> > The comment above should be updated too, and probably the signature of
> > hclge_reset_event() worth to be changed.
> 
> 
> Yes, true. Both the comment and the prototype will be updated in near future.
> I can assure you this did not go un-noticed during the change. There are
> some internal subtleties which I am trying to sort out. Those might come
> as part of different patch-set which deals with other related changes as well.

I can buy such explanation for the change in function signature, but have hard
time to believe that extra commit is needed to change comment above.

Thanks

> 
> The current change(and some other) will pave the way for necessary refactoring
> Of the code being done.
> 
> 
> > 
> > Thanks
> > 
> > >
> > >  	if (time_before(jiffies, (hdev->last_reset_time +
> > >  				  HCLGE_RESET_INTERVAL))) {
> > > --
> > > 2.17.1
> > >
