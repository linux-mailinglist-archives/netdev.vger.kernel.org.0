Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10534216701
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgGGHEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgGGHEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 03:04:41 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3508CC061755;
        Tue,  7 Jul 2020 00:04:41 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id by13so27615024edb.11;
        Tue, 07 Jul 2020 00:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KkPedR7CpLrpniQ2O2NQ6BxCykm/JbWf7Q7yySuVy3A=;
        b=SO3HqhvDaLQYsSyvc/C/JXg2yxbsmbjDIlom0QvgD75TKAaiWedpMlb2Xc8v20heEc
         maf2DtfEwGmvHfe4jWqAQ+Mvie6wiQKYuAZgAaMTWENgBVZV1nZX7efxgZPJPMXPXOC4
         GxLZhrueyYnT6kI43P9gzBRjb6ZaZXHMu/sv4LyyAXGXrn1slbWAqKUOO5+lTTYZ+Jld
         qlwoHgMvRYGs8NXQYXRyQ2DisgDieQWzsJfwWBkPUH1ik4iF5JGk2x8pKsY3/8xFAB3K
         vn++UTQPgx4QBNfGJ8NWUr3zEt5uGqLkpZYe/F/O4WdLieFy9s0kmCHpkm6XxN5Nqt13
         y9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KkPedR7CpLrpniQ2O2NQ6BxCykm/JbWf7Q7yySuVy3A=;
        b=js29U11T920RA7QNlhkQPFtzh7VfuAfpGGlv0mzJkRmJwT7S4ZSPyISXU6BKP4M+Hj
         lN9m/Tbo2fT1WsNDtOnpTNNjL+d8GZvYEw7AfTLpiRgaWA2zDx2j2dPEhpU43RouBiyz
         gJ6smWtBrF3mRc4S2nmhNjsXzwvxyqz8xTVr8NqAFb58tiPlxNi8pQy6uTDrH7zU0OkM
         87YYY/LB0HpVE+J0DGTW/iYsxUP2DYJzHWFmVNVrtHWabP5ruvquT4ZzhGdCQBZVqt1O
         Bh+tfEEl6m5qOqK1moXN/qEnJ2l8bX6Gw6wMZHlkLe3JQgmrfnKpy0PCERkpUVvckCuH
         Ky8w==
X-Gm-Message-State: AOAM5329fbdMGL41RGPOeTbJh9r46qjTtCFqwkLwgY2Ihlos+IQC6iUd
        hVDTYRXB1JoBKuUMANpAQXc=
X-Google-Smtp-Source: ABdhPJwm+p/EXMgPBGoB3LMryCrDK4uyduQpFAIQMrKScylD9luEFSqmCprYB4+ptzge+6sniStfzQ==
X-Received: by 2002:a05:6402:2212:: with SMTP id cq18mr63065492edb.173.1594105479669;
        Tue, 07 Jul 2020 00:04:39 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id z22sm25573773edx.72.2020.07.07.00.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 00:04:39 -0700 (PDT)
Date:   Tue, 7 Jul 2020 10:04:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch
Subject: Re: [PATCH  1/5] net: fec: properly support external PTP PHY for
 hardware time stamping
Message-ID: <20200707070437.gyfoulyezi6ubmdv@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-2-sorganov@gmail.com>
 <20200706150814.kba7dh2dsz4mpiuc@skbuf>
 <87zh8cu0rs.fsf@osv.gnss.ru>
 <20200706154728.lfywhchrtaeeda4g@skbuf>
 <87zh8cqyrp.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh8cqyrp.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 09:33:30PM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > On Mon, Jul 06, 2020 at 06:21:59PM +0300, Sergey Organov wrote:
> >> Vladimir Oltean <olteanv@gmail.com> writes:
>  
> >> > Hi Sergey,
> >> >
> >> > On Mon, Jul 06, 2020 at 05:26:12PM +0300, Sergey Organov wrote:
> >> >> When external PTP-aware PHY is in use, it's that PHY that is to time
> >> >> stamp network packets, and it's that PHY where configuration requests
> >> >> of time stamping features are to be routed.
> >> >> 
> >> >> To achieve these goals:
> >> >> 
> >> >> 1. Make sure we don't time stamp packets when external PTP PHY is in use
> >> >> 
> >> >> 2. Make sure we redirect ioctl() related to time stamping of Ethernet
> >> >>    packets to connected PTP PHY rather than handle them ourselves
> >> 
> >> [...]
> >> 
> >> >> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> >> >> index 2d0d313..995ea2e 100644
> >> >> --- a/drivers/net/ethernet/freescale/fec_main.c
> >> >> +++ b/drivers/net/ethernet/freescale/fec_main.c
> >> >> @@ -1298,7 +1298,11 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
> >> >>  			ndev->stats.tx_bytes += skb->len;
> >> >>  		}
> >> >>  
> >> >> +		/* It could be external PHY that had set SKBTX_IN_PROGRESS, so
> >> >> +		 * we still need to check it's we who are to time stamp
> >> >> +		 */
> >> >>  		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
> >> >> +		    unlikely(fep->hwts_tx_en) &&
> >> >
> >> > I think this could qualify as a pretty significant fix in its own right,
> >> > that should go to stable trees. Right now, this patch appears pretty
> >> > easy to overlook.
> >> >
> >> > Is this the same situation as what is being described here for the
> >> > gianfar driver?
> >> >
> >> > https://patchwork.ozlabs.org/project/netdev/patch/20191227004435.21692-2-olteanv@gmail.com/
> >> 
> >> Yes, it sounds exactly like that!
> >> 
> >
> > Cool. Join the club! You were lucky though, in your case it was pretty
> > evident where the problem might be, so you were already on your way even
> > though you didn't know exactly what was going on.
> >
> > Towards the point that you brought up in that thread:
> >
> >> Could somebody please help me implement (or point me to) proper fix to
> >> reliably use external PHY to timestamp network packets?
> >
> > We do it like this:
> > - DSA: If there is a timestamping switch stacked on top of a
> >   timestamping Ethernet MAC, the switch hijacks the .ndo_do_ioctl of the
> >   host port, and you are supposed to use the PTP clock of the switch,
> >   through the .ndo_do_ioctl of its own (virtual) net devices. This
> >   approach works without changing any code in each individual Ethernet
> >   MAC driver.
> > - PHY: The Ethernet MAC driver needs to be kind enough to check whether
> >   the PHY supports hw timestamping, and pass this ioctl to that PHY
> >   while making sure it doesn't do anything stupid in the meanwhile, like
> >   also acting upon that timestamping request itself.
> >
> > Both are finicky in their own ways. There is no real way for the user to
> > select which PHC they want to use. The assumption is that you'd always
> > want to use the outermost one, and that things in the kernel side always
> > collaborate towards that end.
> 
> Makes sense, -- thanks for clarification! Indeed, if somebody connected
> that external thingy, chances are high it was made for a purpose.
> 
> >
> >> However, I'd insist that the second part of the patch is as important.
> >> Please refer to my original post for the description of nasty confusion
> >> the second part of the patch fixes:
> >> 
> >> https://lore.kernel.org/netdev/87r1uqtybr.fsf@osv.gnss.ru/
> >> 
> >> Basically, you get PHY response when you ask for capabilities, but then
> >> MAC executes ioctl() request for corresponding configuration!
> >> 
> >> [...]
> >> 
> >
> > Yup, sure, _but_ my point is: PHY timestamping is not supposed to work
> > unless you do that phy_has_hwtstamp dance in .ndo_do_ioctl and pass it
> > to the PHY driver. Whereas, timestamping on a DSA switch is supposed to
> > just work. So, the double-TX-timestamp fix is common for both DSA and
> > PHY timestamping, and it should be a separate patch that goes to David's
> > "net" tree and has an according Fixes: tag for the stable people to pick
> > it up. Then, the PHY timestamping patch is technically a new feature,
> > because the driver wasn't looking at the PHY's ability to perform PTP
> > timestamping, and now it does. So that part is a patch for "net-next".
> 
> Ah, thanks, now it makes sense! I simply was not aware of the DSA
> (whatever it is) you've mentioned above.
> 

https://netdevconf.info/2.1/papers/distributed-switch-architecture.pdf

> I'll then make these 2 changes separate in v2 indeed, though I'm not
> aware about Fixes: tag and if I should do something about it. Any clues?
> 

Add these 2 lines to your .gitconfig file:

[pretty]
	fixes = Fixes: %h (\"%s\")

Then use $(git blame) to find the commit which introduced the bad
behavior. I was able to go down back to this commit, which I then tagged
as follows:

git show 6605b730c061f67c44113391e5af5125d0672e99 --pretty=fixes

Then you copy the first line of the generated output to the patch, right
above your Signed-off-by: tag. Like this:

Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware clock")

Note that the offending commit has been obscured, in the meantime, by
refactoring commit ff43da86c69d ("NET: FEC: dynamtic check DMA desc buff
type"). That doesn't mean that the Fixes: tag should point to the newest
commit touching the code though. In case where the refactoring is recent
though (not this case), Greg will send an email that backporting failed,
and you can send him a follow-up with a patch adjusted for each
individual stable tree where adjustments need to be made. You can also
ignore Greg's email, if you don't care about old stable trees.

In this particular case, the original offending commit and the one
obscuring it were included first in the following kernel tags:

$(git tag --contains 6605b730c061): v3.8
$(git tag --contains ff43da86c69d): v3.9

But, if you look at https://www.kernel.org/, the oldest stable tree
being actively maintained should be 3.16, so v3.8 vs v3.9 shouldn't make
any difference because nobody will try to apply your fix patch to a tree
older than 3.9 anyway.

When sending a bugfix patch, there are 2 options:

- You send the patch to the linux-stable mailing list directly. For
  networking fixes, however, David doesn't prefer this. See below.

- You send the patch to the netdev list (the same list where you sent
  this one), but with --subject-prefix "PATCH net" so that it gets
  applied to a different tree (this one:
  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git as
  opposed to this one:
  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git).
  The "net" tree is periodically merged into "net-next". Because your
  patch series will have to be split, there are 2 options: either you
  send your bugfix patches first, wait for them to be merged, and then
  for "net" to be merged into "net-next", or try somehow to make sure
  that the patches for "net" and for "net-next" can be applied in
  parallel without interfering and creating merge conflicts. I think you
  can do the latter.

Whatever you do, however, please be sure to copy Richard Cochran to
PTP-related patches, he tends to have a broader picture of the 1588 work
that is being done throughout the kernel, and can provide more feedback.

> Thanks,
> -- Sergey
> 

Thanks,
-Vladimir
