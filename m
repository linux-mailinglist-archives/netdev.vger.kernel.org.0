Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BA569B9E6
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 13:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjBRMDJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 18 Feb 2023 07:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBRMDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 07:03:09 -0500
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AB1A26C
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 04:03:06 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 9C06A642ECD2;
        Sat, 18 Feb 2023 13:03:04 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id GkhKrdvmyNYi; Sat, 18 Feb 2023 13:03:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 336F962EFEA2;
        Sat, 18 Feb 2023 13:03:04 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9jg8mdLiCbiT; Sat, 18 Feb 2023 13:03:04 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 1240D642ECD2;
        Sat, 18 Feb 2023 13:03:04 +0100 (CET)
Date:   Sat, 18 Feb 2023 13:03:03 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     wei fang <wei.fang@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        David Laight <David.Laight@aculab.com>,
        netdev <netdev@vger.kernel.org>,
        shenwei wang <shenwei.wang@nxp.com>,
        xiaoning wang <xiaoning.wang@nxp.com>,
        linux-imx <linux-imx@nxp.com>
Message-ID: <2030061857.147332.1676721783879.JavaMail.zimbra@nod.at>
In-Reply-To: <DB9PR04MB8106FE7B686569FB15C3281388A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <1422776754.146013.1676652774408.JavaMail.zimbra@nod.at> <b4fc00958e0249208b5aceecfa527161@AcuMS.aculab.com> <Y/AkI7DUYKbToEpj@lunn.ch> <DB9PR04MB81065CC7BD56EBDDC91C7ED288A69@DB9PR04MB8106.eurprd04.prod.outlook.com> <130183416.146934.1676713353800.JavaMail.zimbra@nod.at> <DB9PR04MB8106FE7B686569FB15C3281388A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
Subject: Re: high latency with imx8mm compared to imx6q
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: high latency with imx8mm compared to imx6q
Thread-Index: KX6nItb3xzzXXgLsKrBE7F/dfPfNJbU33POAgABHTYCAAAZaMMtWSb1ctKpkzJDnhT13zw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "wei fang" <wei.fang@nxp.com>
>> Hm, I thought my settings are fine (IOW no coalescing at all).
>> Coalesce parameters for eth0:
>> Adaptive RX: n/a  TX: n/a
>> rx-usecs: 0
>> rx-frames: 0
>> tx-usecs: 0
>> tx-frames: 0
>> 
> Unfortunately, the fec driver does not support to set
> rx-usecs/rx-frames/tx-usecs/tx-frames
> to 0 to disable interrupt coalescing. 0 is an invalid parameters. :(

So setting all values to 1 is the most "no coalescing" setting i can get?
 
>> 
>> But I noticed something interesting this morning. When I set rx-usecs, tx-usecs,
>> rx-frames and tx-frames to 1, *sometimes* the RTT is good.
>> 
>> PING 192.168.0.52 (192.168.0.52) 56(84) bytes of data.
>> 64 bytes from 192.168.0.52: icmp_seq=1 ttl=64 time=0.730 ms
>> 64 bytes from 192.168.0.52: icmp_seq=2 ttl=64 time=0.356 ms
>> 64 bytes from 192.168.0.52: icmp_seq=3 ttl=64 time=0.303 ms
>> 64 bytes from 192.168.0.52: icmp_seq=4 ttl=64 time=2.22 ms
>> 64 bytes from 192.168.0.52: icmp_seq=5 ttl=64 time=2.54 ms
>> 64 bytes from 192.168.0.52: icmp_seq=6 ttl=64 time=0.354 ms
>> 64 bytes from 192.168.0.52: icmp_seq=7 ttl=64 time=2.22 ms
>> 64 bytes from 192.168.0.52: icmp_seq=8 ttl=64 time=2.54 ms
>> 64 bytes from 192.168.0.52: icmp_seq=9 ttl=64 time=2.53 ms
>> 
>> So coalescing plays a role but it looks like the ethernet controller does not
>> always obey my settings.
>> I didn't look into the configured registers so far, maybe ethtool does not set
>> them correctly.
>> 
> It look a bit weird. I did the same setting with my i.MX8ULP and didn't have
> this
> issue. I'm not sure whether you network is stable or network node devices also
> enable interrupt coalescing and the relevant parameters are set to a bit high.

I'm pretty sure my network is good, I've tested also different locations.
And as I said, with the imx6q on the very same network everything works as expected.

So, with rx-usecs/rx-frames/tx-usecs/tx-frames set to 1, you see a RTT smaller than 1ms?

Thanks,
//richard
