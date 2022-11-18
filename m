Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FDC62F667
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242206AbiKRNjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242133AbiKRNin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:38:43 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7D3920B5;
        Fri, 18 Nov 2022 05:37:28 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 6A14D1884470;
        Fri, 18 Nov 2022 13:37:26 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 5E708250052C;
        Fri, 18 Nov 2022 13:37:26 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 5395F9EC0020; Fri, 18 Nov 2022 13:37:26 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 18 Nov 2022 14:37:26 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
In-Reply-To: <20221116102406.gg6h7gvkx55f2ojj@skbuf>
References: <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
 <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
 <20221115145650.gs7crhkidbq5ko6v@skbuf>
 <f229503b98d772c936f1fc8ca826a14f@kapio-technology.com>
 <20221115161846.2st2kjxylfvlncib@skbuf>
 <e05f69915a2522fc1e9854194afcc87b@kapio-technology.com>
 <20221116102406.gg6h7gvkx55f2ojj@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <54b489e65712e50e5ee67b746c0fec74@kapio-technology.com>
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

On 2022-11-16 11:24, Vladimir Oltean wrote:
> On Tue, Nov 15, 2022 at 07:40:02PM +0100, netdev@kapio-technology.com 
> wrote:
>> So, I will not present you with a graph as it is a tedious process 
>> (probably
>> it is some descending gaussian curve wrt timeout occurring).
>> 
>> But 100ms fails, 125 I had 1 port fail, at 140, 150  and 180 I saw 
>> timeouts
>> resulting in fdb add fails, like (and occasional port fail):
>> 
>> mv88e6085 1002b000.ethernet-1:04: Timeout while waiting for switch
>> mv88e6085 1002b000.ethernet-1:04: port 0 failed to add 
>> be:7c:96:06:9f:09 vid
>> 1 to fdb: -110
>> 
>> At around 200 ms it looks like it is getting stable (like 5 runs, no
>> problems).
>> 
>> So with the gaussian curve tail whipping ones behind (risque of 
>> failure) it
>> might need to be like 300 ms in my case... :-)
> 
> Pick a value that is high enough to be reliable and submit a patch to
> "net" where you present the evidence for it (top-level MDIO controller,
> SoC, switch, kernel). I don't believe there's much to read into. A 
> large
> timeout shouldn't have a negative effect on the MDIO performance,
> because it just determines how long it takes until the kernel declares
> it dead, rather than how long it takes for transactions to actually 
> take
> place.

Would it not be appropriate to have a define that specifies the value 
instead
of the same value two places as it is now?

And in so case, what would be an appropriate name?
