Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6F664057D
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbiLBLGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiLBLGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:06:22 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC959BC5A1;
        Fri,  2 Dec 2022 03:06:20 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 13E861883906;
        Fri,  2 Dec 2022 11:06:18 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 0C28425003AB;
        Fri,  2 Dec 2022 11:06:18 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 05C1F9EC0021; Fri,  2 Dec 2022 11:06:17 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 02 Dec 2022 12:06:17 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 2/2] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20221120150018.qupfa3flq6hoapgj@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221115222312.lix6xpvddjbsmoac@skbuf>
 <6c77f91d096e7b1eeaa73cd546eb6825@kapio-technology.com>
 <20221120150018.qupfa3flq6hoapgj@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <343cbf3d367e2a2d4e3ce09487f43615@kapio-technology.com>
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

On 2022-11-20 16:00, Vladimir Oltean wrote:
> On Sun, Nov 20, 2022 at 11:21:08AM +0100, netdev@kapio-technology.com 
> wrote:
>> I have something like this, using 'mvls vtu' from
>> https://github.com/wkz/mdio-tools:
>>  VID   FID  SID  P  Q  F  0  1  2  3  4  5  6  7  8  9  a
>>    0     0    0  y  -  -  =  =  =  =  =  =  =  =  =  =  =
>>    1     2    0  -  -  -  u  u  u  u  u  u  u  u  u  u  =
>> 4095     1    0  -  -  -  =  =  =  =  =  =  =  =  =  =  =
>> 
>> as a vtu table. I don't remember exactly the consequences, but I am 
>> quite
>> sure that fid=0 gave
>> incorrect handling, but there might be something that I have missed as 
>> to
>> other setups.
> 
> Can you please find out? There needs to be an answer as to why 
> something
> which shouldn't happen happens.

Hi Vladimir,
I haven't been able to reproduce the situation with fid=0, and it may be 
superfluous to check if fid has a non-zero value as the case of fid=0 in 
the miss violation handling is not valid on a bridged port, where I 
understand from consultation that the case fid=0 corresponds to a 
non-bridged port.

What I experienced then might have been from some previous bug at a 
time, but I don't know.

Should I remove the check or not?
