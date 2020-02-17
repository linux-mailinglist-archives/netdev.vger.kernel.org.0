Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15171612A2
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 14:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgBQNFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 08:05:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49832 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgBQNFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 08:05:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HpIdm9DMydVRRiMV5Ha+p/ZTvwHk+GnqkwHX2W4/ft0=; b=qHrUTUFG6b+ft1kWPZekMkVxML
        Ex9kqLm5lq0IHFdF1I/9F8tuLqv/Ucvv/wH4GalSnhvc6onNOvDUpYEE5TaXe4z3n5hGeTRawsGk2
        aX0N2hR8TjBkIunSFX6W+koLlEGwDOICGxGYNdW1SxL5/6qlOgD0jOWPPhL2bcnHB9Lk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3g5L-0004cS-1f; Mon, 17 Feb 2020 14:05:15 +0100
Date:   Mon, 17 Feb 2020 14:05:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        David Ahern <dsahern@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next 4/5] net: mvneta: introduce xdp counters to
 ethtool
Message-ID: <20200217130515.GE32734@lunn.ch>
References: <cover.1581886691.git.lorenzo@kernel.org>
 <882d9f03a8542cceec7c7b8e6d083419d84eaf7a.1581886691.git.lorenzo@kernel.org>
 <20200217111718.2c9ab08a@carbon>
 <20200217102550.GB3080@localhost.localdomain>
 <20200217113209.2dab7f71@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217113209.2dab7f71@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 11:32:09AM +0100, Jesper Dangaard Brouer wrote:
> On Mon, 17 Feb 2020 11:25:50 +0100
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> 
> > > On Sun, 16 Feb 2020 22:07:32 +0100
> > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >   
> > > > @@ -2033,6 +2050,7 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
> > > >  	u64_stats_update_begin(&stats->syncp);
> > > >  	stats->es.ps.tx_bytes += xdpf->len;
> > > >  	stats->es.ps.tx_packets++;
> > > > +	stats->es.ps.xdp_tx++;
> > > >  	u64_stats_update_end(&stats->syncp);  
> > > 
> > > I find it confusing that this ethtool stats is named "xdp_tx".
> > > Because you use it as an "xmit" counter and not for the action XDP_TX.
> > > 
> > > Both XDP_TX and XDP_REDIRECT out this device will increment this
> > > "xdp_tx" counter.  I don't think end-users will comprehend this...
> > > 
> > > What about naming it "xdp_xmit" ?  
> > 
> > Hi Jesper,
> > 
> > yes, I think it is definitely better. So to follow up:
> > - rename current "xdp_tx" counter in "xdp_xmit" and increment it for
> >   XDP_TX verdict and for ndo_xdp_xmit
> > - introduce a new "xdp_tx" counter only for XDP_TX verdict.
> > 
> > If we agree I can post a follow-up patch.
> 
> I agree, that sounds like an improvement to this patchset.
> 
> 
> I suspect David Ahern have some opinions about more general stats for
> XDP, but that it is a more general discussion, that it outside this
> patchset, but we should also have that discussion.

Hi Jesper

I've not been following XDP too much, but xdp_xmit seems pretty
generic. It would be nice if all drivers used the same statistics
names. Less user confusion that way. So why is this outside of the
discussion?

	Andrew
