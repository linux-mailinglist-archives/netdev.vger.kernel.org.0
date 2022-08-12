Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2922159131D
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237991AbiHLPeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHLPeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:34:02 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB4F491F8;
        Fri, 12 Aug 2022 08:34:00 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 6265F1884D2E;
        Fri, 12 Aug 2022 15:33:58 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 5798525032B7;
        Fri, 12 Aug 2022 15:33:58 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 4A623A1A0051; Fri, 12 Aug 2022 15:33:58 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 12 Aug 2022 17:33:58 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
In-Reply-To: <YvTn847P/Ga3Ulb0@shredder>
References: <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <79683d9cf122e22b66b5da3bbbb0ee1f@kapio-technology.com>
 <YvIm+OvXvxbH6POv@shredder>
 <6c6fe135ce7b5b118289dc370135b0d3@kapio-technology.com>
 <YvNcitNnyFxTw8bs@shredder>
 <2491232d5c017d94ca3213197a3fb283@kapio-technology.com>
 <YvTn847P/Ga3Ulb0@shredder>
User-Agent: Gigahost Webmail
Message-ID: <a36d6891ce8e961c24987a424b6d7b66@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-11 13:28, Ido Schimmel wrote:
>> >
>> > I'm talking about roaming, not forwarding. Let's say you have a locked
>> > entry with MAC X pointing to port Y. Now you get a packet with SMAC X
>> > from port Z which is unlocked. Will the FDB entry roam to port Z? I
>> > think it should, but at least in current implementation it seems that
>> > the "locked" flag will not be reset and having locked entries pointing
>> > to an unlocked port looks like a bug.
>> >

Yes, now I have tried to test with a case like this using the bridge and 
have verified the locked entry pointing to an unlocked port, which I 
agree seems to be a bug, which I will get fixed.
