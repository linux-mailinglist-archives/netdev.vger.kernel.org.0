Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE9C631343
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 10:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKTJyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 04:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKTJyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 04:54:14 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6746415A06;
        Sun, 20 Nov 2022 01:54:13 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 2C9101883853;
        Sun, 20 Nov 2022 09:54:12 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id E626A25002DE;
        Sun, 20 Nov 2022 09:54:11 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id D69C691201E4; Sun, 20 Nov 2022 09:54:11 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 20 Nov 2022 10:54:11 +0100
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
In-Reply-To: <20221115222312.lix6xpvddjbsmoac@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221115222312.lix6xpvddjbsmoac@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <7f2a4ef8d5d790c557b255f715e63ade@kapio-technology.com>
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

On 2022-11-15 23:23, Vladimir Oltean wrote:
> On Sat, Nov 12, 2022 at 09:37:48PM +0100, Hans J. Schultz wrote:
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h 
>> b/drivers/net/dsa/mv88e6xxx/chip.h
>> index e693154cf803..3b951cd0e6f8 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.h
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
>> @@ -280,6 +280,10 @@ struct mv88e6xxx_port {
>>  	unsigned int serdes_irq;
>>  	char serdes_irq_name[64];
>>  	struct devlink_region *region;
>> +
>> +	/* Locked port and MacAuth control flags */
> 
> Can you please be consistent and call MAB MAC Authentication Bypass?
> I mean, "bypass" is the most important part of what goes on, and you
> just omit it.
> 

I must admit that I consider 'MacAuth' and 'Mac Authentication Bypass' 
to be
completely equivalent terms, where the MAB terminology is what is coined 
by
Cisco. Afaik, there is no difference in the core functionality between 
the two.

I do see that Cisco has a more extended concept, when you consider 
non-core
functionality, as how the whole authorization decision process and the
infrastructure that is involved works, and thus is very Cisco centered, 
as I
have had in my cover letter:

"This feature is known as MAC-Auth or MAC Authentication Bypass
(MAB) in Cisco terminology, where the full MAB concept involves
additional Cisco infrastructure for authorization."

I would have preferred the MacAuth terminology as I see it as more 
generic
and open, but 'mab' is short as a flag name... :D
