Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF293FF74D
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347803AbhIBWmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347748AbhIBWmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 18:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C09066023F;
        Thu,  2 Sep 2021 22:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630622481;
        bh=1QIi2ksNYiWyafk/C0AIdzGH9SfAmD3kB6VnLTdUL1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ObpLo4l7lRjEB/R7LB9ZM2PpuO4o3CKVNbRThNqvrVuJZMgIFsl1uCvryT1aVJ2oF
         RA0RReybUsC2JgSavnA80KezPQvLwG5SRLIovlxtIs9henSO3MHh+tlblYK3gJs9np
         n3Ps2gLWd6HX389IrkTasz1aT18kX6AJZWizFra4a4QDej4E002uViTdofYkhpE5Ff
         MfCvAIiZJAj6wh2dUxlOHtU1jhvNSe//2jfbYAodtdc0yS0NFGhPpsl65qg3mz0/UF
         X54d1VL8vNYYoqx5RPAJ7YIw5n0pZ05WarzUAByHAgY039o1kkF5ks8h3TyY6vP6b2
         NzQnJMxqqZsVA==
Date:   Thu, 2 Sep 2021 15:41:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: Re: [PATCH net-next 10/11] ptp: ocp: Add IRIG-B output mode control
Message-ID: <20210902154119.6261c15f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210902170216.gvjwkocvoosbdkdm@bsd-mbp.dhcp.thefacebook.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
        <20210830235236.309993-11-jonathan.lemon@gmail.com>
        <20210901170700.4ad3c3fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210902170216.gvjwkocvoosbdkdm@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Sep 2021 10:02:16 -0700 Jonathan Lemon wrote:
> On Wed, Sep 01, 2021 at 05:07:00PM -0700, Jakub Kicinski wrote:
> > On Mon, 30 Aug 2021 16:52:35 -0700 Jonathan Lemon wrote:  
> > > +	err = kstrtou8(buf, 0, &val);
> > > +	if (err)
> > > +		return err;
> > > +	if (val > 7)
> > > +		return -EINVAL;
> > > +
> > > +	reg = ((val & 0x7) << 16);
> > > +
> > > +	spin_lock_irqsave(&bp->lock, flags);
> > > +	iowrite32(0, &bp->irig_out->ctrl);		/* disable */
> > > +	iowrite32(reg, &bp->irig_out->ctrl);		/* change mode */
> > > +	iowrite32(reg | IRIG_M_CTRL_ENABLE, &bp->irig_out->ctrl);
> > > +	spin_unlock_irqrestore(&bp->lock, flags);  
> > 
> > locking  
> 
> Not sure what you mean - all register manipulations are 
> already done under the lock here.

I must have misread and thought it has the same problem as patch 8, 
ignore, sorry.
