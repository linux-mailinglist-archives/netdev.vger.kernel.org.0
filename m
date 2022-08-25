Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D58E5A1561
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241272AbiHYPPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242557AbiHYPPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:15:05 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1DD48EAD;
        Thu, 25 Aug 2022 08:15:02 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 86EDA1884D53;
        Thu, 25 Aug 2022 15:14:59 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 6224C25032B7;
        Thu, 25 Aug 2022 15:14:59 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 4F2C09EC0002; Thu, 25 Aug 2022 15:14:59 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 25 Aug 2022 17:14:59 +0200
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
In-Reply-To: <YwdCovUbVpmHfl39@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <ce4266571b2b47ae8d56bd1f790cb82a@kapio-technology.com>
 <YwMW4iGccDu6jpaZ@shredder>
 <c2822d6dd66a1239ff8b7bfd06019008@kapio-technology.com>
 <YwR4MQ2xOMlvKocw@shredder>
 <15407e4b247e91fd8326b1013d1a8640@kapio-technology.com>
 <YwdCovUbVpmHfl39@shredder>
User-Agent: Gigahost Webmail
Message-ID: <824eda8a76f36c8e211289e4ed3d2118@kapio-technology.com>
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

On 2022-08-25 11:36, Ido Schimmel wrote:
> On Tue, Aug 23, 2022 at 01:41:51PM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-08-23 08:48, Ido Schimmel wrote:
>> >
>> > I'm not good at naming, but "blackhole" is at least consistent with what
>> > we already have for routes and nexthop objects.
>> >
>> 
>> I have changed it the name "masked", as that is also the term used in 
>> the
>> documentation for the zero-DPV entries, and I think that it will 
>> generally
>> be a more accepted term.
> 
> "blackhole" is an already accepted term and at least to me it is much
> more clear than "masked". Keep in mind that both L2 neighbours (FDB) 
> and
> L3 neighbours share the same uAPI and eventually we might want to 
> extend
> the use of this flag for L3 neighbours (at least Spectrum supports it),
> so it needs to make sense for both.

I have changed the name of the flag to 'blackhole', but the struct entry 
in switchdev_notifier_fdb_info and a function input parameter is still 
named 'masked'. If that should be changed before I send out V5, please 
let me know as I hope to get this patch set accepted.
