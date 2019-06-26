Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CBD55F83
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 05:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfFZDas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 23:30:48 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:34090 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfFZDas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 23:30:48 -0400
Received: from sapphire.tkos.co.il (unknown [192.168.100.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id D298F440038;
        Wed, 26 Jun 2019 06:30:45 +0300 (IDT)
Date:   Wed, 26 Jun 2019 06:30:44 +0300
From:   Baruch Siach <baruch@tkos.co.il>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH iproute2 1/2] devlink: fix format string warning for
 32bit targets
Message-ID: <20190626033044.jmsejzopzj3wgl5f@sapphire.tkos.co.il>
References: <016aabe2639668b4710b73157ea39e8f97f7d726.1561463345.git.baruch@tkos.co.il>
 <20190625115806.01e29659@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625115806.01e29659@hermes.lan>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Tue, Jun 25, 2019 at 11:58:06AM -0700, Stephen Hemminger wrote:
> On Tue, 25 Jun 2019 14:49:04 +0300
> Baruch Siach <baruch@tkos.co.il> wrote:
> 
> > diff --git a/devlink/devlink.c b/devlink/devlink.c
> > index 436935f88bda..b400fab17578 100644
> > --- a/devlink/devlink.c
> > +++ b/devlink/devlink.c
> > @@ -1726,9 +1726,9 @@ static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
> >  		jsonw_u64_field(dl->jw, name, val);
> >  	} else {
> >  		if (g_indent_newline)
> > -			pr_out("%s %lu", name, val);
> > +			pr_out("%s %llu", name, val);
> >  		else
> > -			pr_out(" %s %lu", name, val);
> > +			pr_out(" %s %llu", name, val);
> 
> But on 64 bit target %llu expects unsigned long long which is 128bit.

Is that a problem?

> The better way to fix this is to use:
> #include <inttypes.h>
> 
> And the use the macro PRIu64
> 			pr_out(" %s %"PRIu64, name, val);

I think it makes the code harder to read. But OK, I'll post an update to this 
patch and the next.

Thanks,
baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
