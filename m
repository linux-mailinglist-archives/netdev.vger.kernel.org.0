Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259375B38AA
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 15:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiIINMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiIINMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 09:12:02 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B693C94127;
        Fri,  9 Sep 2022 06:11:59 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id F0F37188528F;
        Fri,  9 Sep 2022 13:11:56 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id E8A0725032B7;
        Fri,  9 Sep 2022 13:11:56 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id DDD2B9EC0002; Fri,  9 Sep 2022 13:11:56 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 09 Sep 2022 15:11:56 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
In-Reply-To: <20220908112044.czjh3xkzb4r27ohq@skbuf>
References: <Ywyj1VF1wlYqlHb6@shredder>
 <9e1a9eb218bbaa0d36cb98ff5d4b97d7@kapio-technology.com>
 <YwzPJ2oCYJQHOsXD@shredder>
 <69db7606896c77924c11a6c175c4b1a6@kapio-technology.com>
 <YwzjPcQjfLPk3q/k@shredder>
 <f1a17512266ac8b61444e7f0e568aca7@kapio-technology.com>
 <YxNo/0+/Sbg9svid@shredder>
 <5cee059b65f6f7671e099150f9da79c1@kapio-technology.com>
 <Yxmgs7Du62V1zyjK@shredder>
 <8dfc9b525f084fa5ad55019f4418a35e@kapio-technology.com>
 <20220908112044.czjh3xkzb4r27ohq@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <152c0ceadefbd742331c340bec2f50c0@kapio-technology.com>
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

On 2022-09-08 13:20, Vladimir Oltean wrote:
> On Thu, Sep 08, 2022 at 01:14:59PM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-09-08 09:59, Ido Schimmel wrote:
>> > On Wed, Sep 07, 2022 at 11:10:07PM +0200, netdev@kapio-technology.com wrote:
>> > > I am at the blackhole driver implementation now, as I suppose that the
>> > > iproute2 command should work with the mv88e6xxx driver when adding blackhole
>> > > entries (with a added selftest)?
>> > > I decided to add the blackhole feature as new ops for drivers with functions
>> > > blackhole_fdb_add() and blackhole_fdb_del(). Do you agree with that approach?
>> >
>> > I assume you are talking about extending 'dsa_switch_ops'?
>> 
>> Yes, that is the idea.
>> 
>> > If so, it's up to the DSA maintainers to decide.
> 
> What will be the usefulness of adding a blackhole FDB entry from user 
> space?

With the software bridge it could be used to signal a untrusted host in 
connection with a locked port entry attempt. I don't see so much use 
other that test purposes with the driver though.
