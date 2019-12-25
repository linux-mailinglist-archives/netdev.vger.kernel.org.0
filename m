Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C33F12A69D
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 08:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfLYHlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 02:41:15 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38959 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfLYHlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 02:41:15 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 290A02104A;
        Wed, 25 Dec 2019 02:41:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 25 Dec 2019 02:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=sPOO2b
        DJAfTQOb+Uw326Q8lbgYFxqGDhpY2Qmykd3vc=; b=VkcsBfM7Zmwlj3VZyEbYRc
        a9TO9QGuuBfH2PIwJ5xagYaB2gPeQTv/0pgGfdmSiZtKquFL76/PpON23X1hQnCg
        oIQ/XzB0fDaHG2+mk3aZO6xXRE+FYxQR5P99NyW7F/MUoNhVjp3E6icP/bdXgY+D
        ASwv7fqT2NiGk4YmUcUTDquHfxhCfEtjsZ/2Uik9mfIRp9DIpIPTIBJTy83RPuck
        WvZLKXwFdynLJsxeaXfKrbNbCM114+HqJ7+Ao7AIsiDiDp5vvsJFU1vS5Fu9gPIH
        8BZisWGr6tbCkBSrWnaPKshtKDKB6iD6dzg7H3tJv4dPHiI56BMVpYPWtdB+iwqg
        ==
X-ME-Sender: <xms:mBIDXvUDWWn_q_u1Yr87_73-C1XkgJ5y13Mh_VthIk6KFdy7PvirYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvfedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mBIDXrgUe76JbX0y6wDamvCddg7IcXRt49YLIuArbP5lyfTFZ9ZnIA>
    <xmx:mBIDXj5iYqF5UvmVk_Cuc5CmJJnPQKRE5xNtsziVoVXBKurk2b-ecw>
    <xmx:mBIDXj6ZK-KjirzN6luPkhKZ6NFzTNe-7zR5vC3qOrjj89zhVpjl1A>
    <xmx:mhIDXof2OmN83_pJ5U1V4yp1XTDz3y0IvA4Z2lekHEaRdh8vKWf6Mg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 925978005A;
        Wed, 25 Dec 2019 02:41:11 -0500 (EST)
Date:   Wed, 25 Dec 2019 09:41:09 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 1/3] net: switchdev: do not propagate bridge updates across
 bridges
Message-ID: <20191225074109.GA8726@splinter>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <E1ij6pf-00083v-Sl@rmk-PC.armlinux.org.uk>
 <20191224083931.GB895380@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224083931.GB895380@splinter>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 10:39:33AM +0200, Ido Schimmel wrote:
> On Sun, Dec 22, 2019 at 07:24:03PM +0000, Russell King wrote:
> > When configuring a tree of independent bridges, propagating changes
> > from the upper bridge across a bridge master to the lower bridge
> > ports brings surprises.
> > 
> > For example, a lower bridge may have vlan filtering enabled.  It
> > may have a vlan interface attached to the bridge master, which may
> > then be incorporated into another bridge.  As soon as the lower
> > bridge vlan interface is attached to the upper bridge, the lower
> > bridge has vlan filtering disabled.
> 
> Interesting topology :) The change looks OK to me. I'll add the patch to
> our internal tree and let it go through regression to make sure I didn't
> miss anything. Will report the results tomorrow.

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks!
