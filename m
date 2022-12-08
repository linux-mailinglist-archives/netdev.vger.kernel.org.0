Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D26473D7
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiLHQEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiLHQEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:04:05 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4339B2AD;
        Thu,  8 Dec 2022 08:04:01 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id DF03A1883A08;
        Thu,  8 Dec 2022 16:03:59 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id CD4E825002E1;
        Thu,  8 Dec 2022 16:03:59 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id BF2359EC0022; Thu,  8 Dec 2022 16:03:59 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 08 Dec 2022 17:03:59 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20221208133524.uiqt3vwecrketc5y@skbuf>
References: <20221205185908.217520-1-netdev@kapio-technology.com>
 <20221205185908.217520-4-netdev@kapio-technology.com>
 <Y487T+pUl7QFeL60@shredder>
 <580f6bd5ee7df0c8f0c7623a5b213d8f@kapio-technology.com>
 <20221207202935.eil7swy4osu65qlb@skbuf>
 <1b0d42df6b3f2f17f77cfb45cf8339da@kapio-technology.com>
 <20221208133524.uiqt3vwecrketc5y@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <7c7986329901730416b1505535ec3d36@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-12-08 14:35, Vladimir Oltean wrote:
> 
> So it appears that frames which get a VTU miss will still also cause an
> ATU miss, and that's what you're seeing.
> 
> The solution would be to acknowledge this fact, and not print any error
> message from the ATU IRQ handler for unknown FID/VID, which would just
> alarm the user.

Thanks for clearing that up!

At leisure, do you have an idea why it will encounter a VTU miss 
violation at random?

I guess I must check if FID != FID_STANDALONE instead then...
