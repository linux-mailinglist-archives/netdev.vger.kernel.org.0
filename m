Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B0F5148F8
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358969AbiD2MSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238748AbiD2MSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:18:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBD2205D3;
        Fri, 29 Apr 2022 05:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=nJbZKj7+pWCDUFlNUm1wgYBm08byh6iVe5oLUsV2N0I=; b=5S
        j/EYV/8pbsLLSu8n1/uFFbh2LWnTM81hBfk5ByckrGFEz/Rzm0HXbq8JtQJgO5q8+P9NvMdC1CJYr
        pRPj16atkhl+PJjTdufp6ZRrDM4Le5t3OVL/LfORBPTg8OyraEq2jc4EYMRjWXLyKwzmhkOZxajJq
        SdpcKlQ30SYXps4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkPWS-000TZv-69; Fri, 29 Apr 2022 14:14:56 +0200
Date:   Fri, 29 Apr 2022 14:14:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "jay.xu@rock-chips.com" <jay.xu@rock-chips.com>
Cc:     kuba <kuba@kernel.org>, davem <davem@davemloft.net>,
        joabreu <joabreu@synopsys.com>,
        "alexandre.torgue" <alexandre.torgue@st.com>,
        "peppe.cavallaro" <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Device Tree <devicetree@vger.kernel.org>
Subject: Re: Re: [PATCH V2] ethernet: stmmac: support driver work for DTs
 without child queue node
Message-ID: <YmvWwIgE71iwZhgp@lunn.ch>
References: <20220428010927.526310-1-jay.xu@rock-chips.com>
 <20220429004605.1010751-1-jay.xu@rock-chips.com>
 <Yms3ynT8RGmldAkm@lunn.ch>
 <2022042909545741446644@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2022042909545741446644@rock-chips.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding device tree list.

This is mostly a device tree issue, so the device tree Maintainers
should be part of the discussion.

> >On Fri, Apr 29, 2022 at 08:46:05AM +0800, Jianqun Xu wrote:
> >> The driver use the value of property 'snps,rx-queues-to-use' to loop
> >> same numbers child nodes as queues, such as:
> >>
> >>     gmac {
> >>         rx-queues-config {
> >>             snps,rx-queues-to-use = <1>;
> >>             queue0 {
> >>                 // nothing need here.
> >>     };
> >> };
> >>     };
> >>
> >> Since a patch for dtc from rockchip will delete all node without any
> >> properties or child node, the queue0 node will be deleted, that caused
> >> the driver fail to probe:
> >
> >Is this the in tree dtc? Do you have a commit hash for it? That should
> >probably be used as a Fixes: tag. Or that change to dtc needs
> >reverting because it breaks stuff.
> > 
> The patch is a hack patch for some products and have not in tree dtc, I said that to
> explain a possible case how things happed, it's only a case of no child queue node.

So this has nothing to do with the kernel dtc, or the upstream
dtc. This is only a 'vendor crap' dtc which has been hacked?

Why should mainline care? Is there anything in the DT standard which
says the compiler can optimise out empty properties?

     Andrew
