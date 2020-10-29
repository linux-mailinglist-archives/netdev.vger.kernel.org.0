Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3A629EF69
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgJ2PNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:13:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52460 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgJ2PNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 11:13:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kY9bv-004BLg-Hn; Thu, 29 Oct 2020 16:13:07 +0100
Date:   Thu, 29 Oct 2020 16:13:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Laight <David.Laight@ACULAB.COM>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH net-next 2/2] net: rose: Escape trigraph to fix warning
 with W=1
Message-ID: <20201029151307.GP878328@lunn.ch>
References: <20201028002235.928999-1-andrew@lunn.ch>
 <20201028002235.928999-3-andrew@lunn.ch>
 <294bfee65035493fac1e2643a5e360d5@AcuMS.aculab.com>
 <20201029143121.GN878328@lunn.ch>
 <2c3145a577f84e96b2ec7be15db90331@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c3145a577f84e96b2ec7be15db90331@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 02:52:52PM +0000, David Laight wrote:
> From: Andrew Lunn
> > Sent: 29 October 2020 14:31
> > On Thu, Oct 29, 2020 at 02:19:27PM +0000, David Laight wrote:
> > > From: Andrew Lunn
> > > > Sent: 28 October 2020 00:23
> > > >
> > > > net/rose/af_rose.c: In function ‘rose_info_show’:
> > > > net/rose/af_rose.c:1413:20: warning: trigraph ??- ignored, use -trigraphs to enable [-Wtrigraphs]
> > > >  1413 |    callsign = "??????-?";
> > > >
> > > > ??- is a trigraph, and should be replaced by a ˜ by the
> > > > compiler. However, trigraphs are being ignored in the build. Fix the
> > > > warning by escaping the ?? prefix of a trigraph.
> > > >
> > > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > > ---
> > > >  net/rose/af_rose.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
> > > > index cf7d974e0f61..2c297834d268 100644
> > > > --- a/net/rose/af_rose.c
> > > > +++ b/net/rose/af_rose.c
> > > > @@ -1410,7 +1410,7 @@ static int rose_info_show(struct seq_file *seq, void *v)
> > > >  			   ax2asc(buf, &rose->dest_call));
> > > >
> > > >  		if (ax25cmp(&rose->source_call, &null_ax25_address) == 0)
> > > > -			callsign = "??????-?";
> > > > +			callsign = "????\?\?-?";
> > >
> > > I think I'd just split the string, eg: "?????" "-?".
> > 
> > Humm. I think we need a language lawyer.
> > 
> > Does it concatenate the strings and then evaluate for trigraphs? Or
> > does it evaluate for trigraphs, and then concatenate the strings?
> 
> I'm 99.9999% sure trigraphs are evaluated before string concatenation.
> 
> Although trigraphs are such a stupid idea I'd be tempted to just
> turn the warning off.
> There is good reason why they are ignored by default.

Hi Arnd

I think this trigraph issues popped up because of one of the changes
you have in your playground, adding more warnings.

What do you think of disabling the trigraph warning as well as
disabling trigraphs themselves?

	   Andrew
