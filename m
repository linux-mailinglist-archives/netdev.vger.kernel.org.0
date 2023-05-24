Return-Path: <netdev+bounces-5137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7CA770FC31
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:08:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FC82281368
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A71C19E77;
	Wed, 24 May 2023 17:08:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E50019918
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:08:28 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E24E9;
	Wed, 24 May 2023 10:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=r17O1HkJRKeCWfCU23f/nGpxZ/B8ZzxbRelEQsNBLw4=; b=1s
	g8ej3AKHcZ4ViO1gAz74HlE0le/ophkG98WfMcUCiEPkG0AKTbydHZBJjwloV72V377oTJ7QFmYmf
	ZMZgpkc/ETREaXC15aFszRY075heYjXgKPZp52xOM54u2j2AOQfhLmwfAJsf8Y9st5a8FNgcVlb9E
	aF/MwptQLpMRYJs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1ryE-00DodW-Oq; Wed, 24 May 2023 19:08:18 +0200
Date: Wed, 24 May 2023 19:08:18 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Alexis =?iso-8859-1?Q?Lothor=E9?= <alexis.lothore@bootlin.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com, scott.roberts@telus.com,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next v3 2/7] net: dsa: mv88e6xxx: pass directly chip
 structure to mv88e6xxx_phy_is_internal
Message-ID: <325a6737-21b9-4b78-b022-9a540c3c0f33@lunn.ch>
References: <20230524130127.268201-1-alexis.lothore@bootlin.com>
 <20230524130127.268201-3-alexis.lothore@bootlin.com>
 <ZG4OuWllZp3MZxO8@shell.armlinux.org.uk>
 <9a7fac7b-e04b-27e2-8679-ffbbb23c248e@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a7fac7b-e04b-27e2-8679-ffbbb23c248e@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 04:46:35PM +0200, Alexis Lothoré wrote:
> Hello Russell,
> 
> On 5/24/23 15:18, Russell King (Oracle) wrote:
> > On Wed, May 24, 2023 at 03:01:22PM +0200, Alexis Lothoré wrote:
> >> Since this function is a simple helper, we do not need to pass a full
> >> dsa_switch structure, we can directly pass the mv88e6xxx_chip structure.
> >> Doing so will allow to share this function with any other function
> >> not manipulating dsa_switch structure but needing info about number of
> >> internal phys
> >>
> >> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> >> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> >>
> >> ---
> >> Changes since v2:
> >> - add reviewed-by tags
> >>
> >> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
> >> ---
> > 
> > It never ceases to amaze me the way human beings can find creative ways
> > to mess things up, no matter how well things are documented. The above
> > commit message (and the others that I've looked at) are all broken
> > because of this creativity.
> > 
> > In effect, because of the really weird format you've come up with here,
> > your patches are in effect *not* signed off by you.
> 
> Sorry for that. This was an attempt to provide relevant changelog for each
> patch, but obviously the way I stored those changelogs was wrong, and I did not
> catch the consequent broken Signed-off-by lines after re-generating the series.
> I'll do as suggested and hold off a bit before fixing/re-sending.

You can put the changelog in the commit message in git commit, you
just need to add the correct --- separate after the tags. The patch
created with git format-patch will then have two ---, but that is not
a problem.

    Andrew

---
pw-bot: cr

