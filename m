Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4324F14E3
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbiDDMdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234724AbiDDMdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:33:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5C825286
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 05:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6n3KX1GEwip33D8wMssV4+KDho9nOZu079l8bG5zkmM=; b=hrKqzX1sURdX25gsYs5KjB4VFe
        ffbnb67+kHNwrSr6Eo1F6iAI5Df/5PrbIkNxeW4LxsXhLdCmBr7obBi7wp6WduimKIRI6YmDXcdGW
        2+0s5Gygj7wn040Bh9nrrDBxGNrizLUMAVyq0xwM4pKUktljzac0KMNbnGFQ0iwKA0xE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbLrX-00E5Vu-8m; Mon, 04 Apr 2022 14:31:15 +0200
Date:   Mon, 4 Apr 2022 14:31:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ian Wienand <iwienand@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/ethernet : set default assignment identifier to
 NET_NAME_ENUM
Message-ID: <YkrlEwXs3HlE9OQd@lunn.ch>
References: <20220401063430.1189533-1-iwienand@redhat.com>
 <Ykb6d3EvC2ZvRXMV@lunn.ch>
 <YkeVzFqjhh1CcSkf@fedora19.localdomain>
 <YkiYiLK+zvwiS4t+@lunn.ch>
 <YkpB/2idmtgz10eV@fedora19.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkpB/2idmtgz10eV@fedora19.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 10:55:27AM +1000, Ian Wienand wrote:
> On Sat, Apr 02, 2022 at 08:40:08PM +0200, Andrew Lunn wrote:
> > So is there a risk here that Xen user suddenly find their network
> > interfaces renamed, where as before they were not, and their
> > networking thus breaks?
> 
> Well, this is actually what "got" us.  The interfaces *are* renamed on
> CentOS 9-stream, but not on earlier releases, because systemd makes
> different choices [1].  Tomorrow someone might "fix" something in that
> systemd/udev chain that flips interfaces without specific use flags
> back to not being renamed again.  I'm certain it would vary based on
> what distro and release you chose to boot.
> 
> > Consistency is good, but it is hard to do in retrospect when there are
> > deployed systems potentially dependent on the inconsistency.
> 
> As noted, it is already the case that if your names are falling into
> this path, they are unstable? (there are many pages for every distro
> that go on and on about this, systemd/udev interactions, rules, link
> files, and so on; e.g. [2]).
> 
> I get what you are saying, that in a fixed virtual environment booting
> some relatively fixed distro, perhaps the names are "stable enough"
> and nobody has bothered updating this yet, so everyone is probably
> happy enough with what they have.
> 
> But ultimately it seems like nobody is regression testing this, and
> all it takes is a seemingly unrelated change to struct layout or list
> walking and things might change anyway.  Then the answer would then be
> -- well sorry about that but we never guaranteed that anyway.
> 
> Reflecting reality and labeling the interface as named in a
> unstable way just seems like the way forward here, to me.

Hi Ian

Please send a v2 and include this consideration in the commit message.
It is then clear you have thought about the issue, why you think it is
O.K, etc. We can then let others decide if it should be merged.

If it does cause a regression and somebody thinks it should be
reverted, your reasoning why it is O.K. is also easy to see etc.

     Andrew
