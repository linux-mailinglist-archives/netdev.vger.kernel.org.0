Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25263FF204
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346494AbhIBRDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:03:19 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:19244 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbhIBRDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 13:03:19 -0400
Received: (qmail 71148 invoked by uid 89); 2 Sep 2021 17:02:17 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 2 Sep 2021 17:02:17 -0000
Date:   Thu, 2 Sep 2021 10:02:16 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: Re: [PATCH net-next 10/11] ptp: ocp: Add IRIG-B output mode control
Message-ID: <20210902170216.gvjwkocvoosbdkdm@bsd-mbp.dhcp.thefacebook.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
 <20210830235236.309993-11-jonathan.lemon@gmail.com>
 <20210901170700.4ad3c3fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901170700.4ad3c3fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 05:07:00PM -0700, Jakub Kicinski wrote:
> On Mon, 30 Aug 2021 16:52:35 -0700 Jonathan Lemon wrote:
> > +	err = kstrtou8(buf, 0, &val);
> > +	if (err)
> > +		return err;
> > +	if (val > 7)
> > +		return -EINVAL;
> > +
> > +	reg = ((val & 0x7) << 16);
> > +
> > +	spin_lock_irqsave(&bp->lock, flags);
> > +	iowrite32(0, &bp->irig_out->ctrl);		/* disable */
> > +	iowrite32(reg, &bp->irig_out->ctrl);		/* change mode */
> > +	iowrite32(reg | IRIG_M_CTRL_ENABLE, &bp->irig_out->ctrl);
> > +	spin_unlock_irqrestore(&bp->lock, flags);
> 
> locking

Not sure what you mean - all register manipulations are 
already done under the lock here.
-- 
Jonathan
