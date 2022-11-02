Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3666160B1
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 11:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiKBKQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 06:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKBKQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 06:16:41 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24FE24952;
        Wed,  2 Nov 2022 03:16:40 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1oqAnE-0002Os-TL; Wed, 02 Nov 2022 11:16:21 +0100
Date:   Wed, 2 Nov 2022 10:16:16 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: ethernet: mediatek: ppe: add support for flow
 accounting
Message-ID: <Y2JDcBovstxCHCTJ@makrotopia.org>
References: <Y2G9ANkdaaENNnOd@makrotopia.org>
 <Y2G/CaPrTVsYeGWB@lunn.ch>
 <Y2HBzEdmiKK9IPFK@makrotopia.org>
 <Y2HHOSaYQGAhWL/E@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2HHOSaYQGAhWL/E@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 02:26:17AM +0100, Andrew Lunn wrote:
> On Wed, Nov 02, 2022 at 01:03:08AM +0000, Daniel Golle wrote:
> > Hi Andrew,
> > 
> > On Wed, Nov 02, 2022 at 01:51:21AM +0100, Andrew Lunn wrote:
> > > On Wed, Nov 02, 2022 at 12:42:40AM +0000, Daniel Golle wrote:
> > > > The PPE units found in MT7622 and newer support packet and byte
> > > > accounting of hw-offloaded flows. Add support for reading those
> > > > counters as found in MediaTek's SDK[1].
> > > > 
> > > > [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/bc6a6a375c800dc2b80e1a325a2c732d1737df92
> > > > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > > 
> > > Sorry, but NACK.
> > > 
> > > You have not explained why doing this correctly via ethtool -S cannot
> > > be done. debugfs is a vendor crap way of doing this.
> > 
> > The debugfs interface is pre-existing and **in addition** to the
> > standard Linux interfaces which are also provided. It is true that
> > the debugfs interface in this case doesn't provide much additional
> > value apart from having the counter listed next to the hardware-
> > specific hashtable keys. As the debugfs interface for now aims to
> > be as complete as possible, naturally there is some redundance of
> > things which can also be accessed using other (standard) interfaces.
> 
> debugfs is by definition unstable. It is not ABI. Anything using it is
> expected to break in the near future when it changes its layout. It is
> also totally option, you cannot expect it to be mounted.
> 
> I hope you don't have any user space code using it.
> 
> Maybe i should submit a patch which just for the fun of it rearranged
> the order in debugfs and change the file name?

Go ahead and have fun ;)
The debugfs interface is not used for anything except for the human
developer wanting to validate that PPE is working properly. It's
literally for debugging, and nothing else.

For productive use, you can access the counters by setting up an
nftables rule with a counter.
