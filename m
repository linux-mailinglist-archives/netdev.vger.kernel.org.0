Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D6D23C218
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgHDXOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgHDXOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:14:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE917C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 16:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Lu9dij56ApQRIDbuch+DxjsG5HI0/tjJxNoJIP+tsG8=; b=QfUjlEvlNtjEX7hWKopwbeprw
        3aBruWF/jLN395PoMSEpa26iQlqlNZ3cCPp22wl9B0SV54T2TJtY+q3d2ZyIPLgun2opL24iMBY4u
        lkEmdcrsacPSKTCxfWGEUVjA7J60z4WbNKFiaJtIZ+n13yelRe/n6vIZ+lqKjwOoD/yGCe/h+4J/r
        m81JF3BnrOoMy9tlTGfs03gFtFGdHLx7Cns06+e+RS+hnPr7u1Qp1c36hhA7UIGLAAU0v4SGVgr9Y
        MU98VcqaVzTZGoxUmCLbM/SUG42lYaRDDvo+5uDIUwlFGhZeRXT7TuHvqIkFZPD2erzsOw42k/Wnn
        qWPpoxLXA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48410)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k368h-0002yX-2a; Wed, 05 Aug 2020 00:14:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k368b-0004Wo-C8; Wed, 05 Aug 2020 00:14:29 +0100
Date:   Wed, 5 Aug 2020 00:14:29 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Petr Machata <petrm@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
Message-ID: <20200804231429.GW1551@shell.armlinux.org.uk>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-2-kurt@linutronix.de>
 <87lfj1gvgq.fsf@mellanox.com>
 <87pn8c0zid.fsf@kurt>
 <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com>
 <20200804210759.GU1551@shell.armlinux.org.uk>
 <45130ed9-7429-f1cd-653b-64417d5a93aa@ti.com>
 <20200804214448.GV1551@shell.armlinux.org.uk>
 <8f1945a4-33a2-5576-2948-aee5141f83f6@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f1945a4-33a2-5576-2948-aee5141f83f6@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 01:04:31AM +0300, Grygorii Strashko wrote:
> On 05/08/2020 00:44, Russell King - ARM Linux admin wrote:
> > On Wed, Aug 05, 2020 at 12:34:47AM +0300, Grygorii Strashko wrote:
> > > On 05/08/2020 00:07, Russell King - ARM Linux admin wrote:
> > > > On Tue, Aug 04, 2020 at 11:56:12PM +0300, Grygorii Strashko wrote:
> > > > > 
> > > > > 
> > > > > On 31/07/2020 13:06, Kurt Kanzenbach wrote:
> > > > > > On Thu Jul 30 2020, Petr Machata wrote:
> > > > > > > Kurt Kanzenbach <kurt@linutronix.de> writes:
> > > > > > > 
> > > > > > > > @@ -107,6 +107,37 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb)
> > > > > > > >     }
> > > > > > > >     EXPORT_SYMBOL_GPL(ptp_classify_raw);
> > > > > > > > +struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
> > > > > > > > +{
> > > > > > > > +	u8 *data = skb_mac_header(skb);
> > > > > > > > +	u8 *ptr = data;
> > > > > > > 
> > > > > > > One of the "data" and "ptr" variables is superfluous.
> > > > > > 
> > > > > > Yeah. Can be shortened to u8 *ptr = skb_mac_header(skb);
> > > > > 
> > > > > Actually usage of skb_mac_header(skb) breaks CPTS RX time-stamping on
> > > > > am571x platform PATCH 6.
> > > > > 
> > > > > The CPSW RX timestamp requested after full packet put in SKB, but
> > > > > before calling eth_type_trans().
> > > > > 
> > > > > So, skb->data pints on Eth header, but skb_mac_header() return garbage.
> > > > > 
> > > > > Below diff fixes it for me.
> > > > 
> > > > However, that's likely to break everyone else.
> > > > 
> > > > For example, anyone calling this from the mii_timestamper rxtstamp()
> > > > method, the skb will have been classified with the MAC header pushed
> > > > and restored, so skb->data points at the network header.
> > > > 
> > > > Your change means that ptp_parse_header() expects the MAC header to
> > > > also be pushed.
> > > > 
> > > > Is it possible to adjust CPTS?
> > > > 
> > > > Looking at:
> > > > drivers/net/ethernet/ti/cpsw.c... yes.
> > > > drivers/net/ethernet/ti/cpsw_new.c... yes.
> > > > drivers/net/ethernet/ti/netcp_core.c... unclear.
> > > > 
> > > > If not, maybe cpts should remain unconverted - I don't see any reason
> > > > to provide a generic function for one user.
> > > > 
> > > 
> > > Could it be an option to pass "u8 *ptr" instead of "const struct sk_buff *skb" as
> > > input parameter to ptp_parse_header()?
> > 
> > It needs to read from the buffer, and in order to do that, it needs to
> > validate that the buffer contains sufficient data.  So, at minimum it
> > needs to be a pointer and size of valid data.
> > 
> > I was thinking about suggesting that as a core function, with a wrapper
> > for the existing interface.
> > 
> 
> Then length can be added.

Actually, it needs more than that, because skb->data..skb->len already
may contain the eth header or may not.

> Otherwise not only CPTS can't benefit from this new API, but also
> drivers like oki-semi/pch_gbe/pch_gbe_main.c -> pch_ptp_match()

Again, this looks like it can be solved easily by swapping the position
of these two calls:

                        pch_rx_timestamp(adapter, skb);

                        skb->protocol = eth_type_trans(skb, netdev);

> or have to two have two APIs (name?).
> 
> ptp_parse_header1(struct sk_buff *skb, unsigned int type)
> {
> 	u8 *data = skb_mac_header(skb);
> 
> ptp_parse_header2(struct sk_buff *skb, unsigned int type)
> {
> 	u8 *data = skb->data;
> 
> everything else is the same.

Actually, I really don't think we want 99% of users doing:

	hdr = ptp_parse_header(skb_mac_header(skb), skb->data, skb->len, type)

or

	hdr = ptp_parse_header(skb_mac_header(skb), skb->data + skb->len, type);

because that is what it will take, and this is starting to look
really very horrid.

So, I repeat my question again: can netcp_core.c be adjusted to
ensure that the skb mac header field is correctly set by calling
eth_type_trans() prior to calling the rx hooks?  The other two
cpts cases look easy to change, and the oki-semi also looks the
same.

Otherwise, the easiest thing may be to just revert the change to
cpts.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
