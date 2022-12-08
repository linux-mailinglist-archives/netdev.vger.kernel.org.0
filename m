Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3364B6472CA
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiLHPXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiLHPXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:23:01 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8955FB8
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:22:55 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id D8D851884593;
        Thu,  8 Dec 2022 15:22:53 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id CA4F025002E1;
        Thu,  8 Dec 2022 15:22:53 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id BFDAB9EC0021; Thu,  8 Dec 2022 15:22:53 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 08 Dec 2022 16:22:53 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: replace ATU violation
 prints with trace points
In-Reply-To: <20221208144901.tgdhp73n7g5uh7qj@skbuf>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
 <20221207233954.3619276-3-vladimir.oltean@nxp.com> <Y5EsWNfVQrl8Nb71@x130>
 <20221208144901.tgdhp73n7g5uh7qj@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <1bf9be8b0877a0536b73ceaa957f6234@kapio-technology.com>
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

On 2022-12-08 15:49, Vladimir Oltean wrote:
> On Wed, Dec 07, 2022 at 04:14:16PM -0800, Saeed Mahameed wrote:
>> > 	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
>> > -		dev_err_ratelimited(chip->dev,
>> > -				    "ATU age out violation for %pM fid %u\n",
>> > -				    entry.mac, fid);
>> > +		trace_mv88e6xxx_atu_age_out_violation(chip->dev, spid,
>> > +						      entry.mac, fid);
>> 
>> no stats here? tracepoints are disabled by default and this event will 
>> go
>> unnoticed, users usually monitor light weight indicators such as 
>> stats, then
>> turn on tracepoints to see what's actually happening..
> 
> I believe that the ATU age out violation handler is dead code 
> currently.
> The driver does not enable the MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT 
> bit
> (interrupt on age out).
> 
> I just converted the existing debugging prints to trace points. Open to
> more suggestions, but I believe that if I introduce a counter, it would
> always return 0.

The follow-up patch set to the MAB patch set I have, will make use of 
the age
out violation.
