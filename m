Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A093344073
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 13:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCVMGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 08:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhCVMGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 08:06:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B990A6197F;
        Mon, 22 Mar 2021 12:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616414779;
        bh=oxcFvgdEdsJnWKUOlZwhr81OOZNOTBT37QmaZowntJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SpQEmy5WwC/gCRKzSnfcLcPeLZtSl597X9gU8OQAzoMF4YJ/zYk0LkIbOmOyy7LmQ
         F1YZigKJhBVpUI5zfAxpGajo/O1VS5wCwmY9gik55icByT0EvSv0ROVExmLhnTQc3e
         4eN3AG9KGcfFQ0INww0dobRIBzCm+yYJ0i94CZf73j9sVZH2GYfXtR5AQMsnmzaQ8s
         ap0V1R2iZTpxi5RpZh7iRGTNPENthiFYX4Uh+8NOMHJ1fbJhy1fOfup3XEd/CiW958
         PqeMIO1u8g3UEyzI/CBDOlDu1r4qQN6D8fqUzlpcRWpg/1PEyuKj5T0zcM+VC3W8VK
         tSDYWpwha2M/Q==
Date:   Mon, 22 Mar 2021 14:06:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/5] misdn: avoid -Wempty-body warning
Message-ID: <YFiIN50pcTnO4X3M@unreal>
References: <20210322104343.948660-1-arnd@kernel.org>
 <YFh3heNXq6mqYqzI@unreal>
 <CAK8P3a3WZmBB=bxNc=taaDwBksLOPVPzhXPAFJ3QCG+eA+Xxww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3WZmBB=bxNc=taaDwBksLOPVPzhXPAFJ3QCG+eA+Xxww@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 12:24:20PM +0100, Arnd Bergmann wrote:
> On Mon, Mar 22, 2021 at 11:55 AM Leon Romanovsky <leon@kernel.org> wrote:
> > On Mon, Mar 22, 2021 at 11:43:31AM +0100, Arnd Bergmann wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > gcc warns about a pointless condition:
> > >
> > > drivers/isdn/hardware/mISDN/hfcmulti.c: In function 'hfcmulti_interrupt':
> > > drivers/isdn/hardware/mISDN/hfcmulti.c:2752:17: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
> > >  2752 |                 ; /* external IRQ */
> > >
> > > Change this as suggested by gcc, which also fits the style of the
> > > other conditions in this function.
> > >
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > >  drivers/isdn/hardware/mISDN/hfcmulti.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
> > > index 7013a3f08429..8ab0fde758d2 100644
> > > --- a/drivers/isdn/hardware/mISDN/hfcmulti.c
> > > +++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
> > > @@ -2748,8 +2748,9 @@ hfcmulti_interrupt(int intno, void *dev_id)
> > >               if (hc->ctype != HFC_TYPE_E1)
> > >                       ph_state_irq(hc, r_irq_statech);
> > >       }
> > > -     if (status & V_EXT_IRQSTA)
> > > -             ; /* external IRQ */
> > > +     if (status & V_EXT_IRQSTA) {
> > > +             /* external IRQ */
> > > +     }
> >
> > Any reason do not delete this hunk?
> 
> I don't care either way, I only kept it because it was apparently left there
> on purpose by the original author, as seen by the comment.

I personally would delete it.

Thanks

> 
>         Arnd
