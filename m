Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D45A5F0E59
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiI3PBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiI3PA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:00:59 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CB81C2970;
        Fri, 30 Sep 2022 07:59:16 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 1745C1884494;
        Fri, 30 Sep 2022 14:59:14 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 028A62500015;
        Fri, 30 Sep 2022 14:59:14 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id F0E8B9EC0007; Fri, 30 Sep 2022 14:59:13 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 30 Sep 2022 16:59:13 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 net-next 0/9] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
In-Reply-To: <Yzb3oNGNtq4GCS3M@shredder>
References: <20220928150256.115248-1-netdev@kapio-technology.com>
 <20220929091036.3812327f@kernel.org>
 <12587604af1ed79be4d3a1607987483a@kapio-technology.com>
 <20220929112744.27cc969b@kernel.org>
 <ab488e3d1b9d456ae96cfd84b724d939@kapio-technology.com>
 <Yzb3oNGNtq4GCS3M@shredder>
User-Agent: Gigahost Webmail
Message-ID: <16d6db15df0a875e442456ff56234b98@kapio-technology.com>
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

On 2022-09-30 16:05, Ido Schimmel wrote:
> On Fri, Sep 30, 2022 at 07:42:37AM +0200, netdev@kapio-technology.com 
> wrote:
>> Obviously my method of selecting all switchcore drivers with 
>> sub-options
>> under menuconfig was not sufficient, and I didn't know of the 
>> allmodconfig
>> option, otherwise I would have used it.
> 
> You can see build issues on patchwork:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220928150256.115248-6-netdev@kapio-technology.com/
> 
> Also:
> 
> https://docs.kernel.org/next/process/maintainer-netdev.html#what-level-of-testing-is-expected-before-i-submit-my-change
> 
> https://docs.kernel.org/next/process/maintainer-netdev.html#can-i-reproduce-the-checks-from-patchwork-on-my-local-machine
> 
> https://docs.kernel.org/next/process/maintainer-netdev.html#running-all-the-builds-and-checks-locally-is-a-pain-can-i-post-my-patches-and-have-the-patchwork-bot-validate-them
> 
>> So the question is if I should repost the fixed patch-set or I need to 
>> make
>> a new version?
> 
> A new fixed version (v7) is required, but wait for this version to be
> reviewed first.
> 
>> Anyhow I hope that there will not be problems when running the 
>> selftests, as
>> I have not been able to do so with my system, so there can be more 
>> that
>> needs to be changed.
> 
> It's not really acceptable to post tests that you haven't run... What
> exactly is the issue? You should be able to run the tests with veth
> pairs in a VM.

It is only the blackhole test that I have not been able to run as is, 
but I have stepped it manually as far as I could.
My environment has changed lately and in that context the building of 
the selftests fails and I don't know why,I just get some error 
messagesabout missing header files, and setting up a whole system like 
f.ex. linuxfromscratch with the necessary libs and tools to run it in a 
VM is too time consuming a task at the moment.

If there is some freely available system for the purpose out there 
besides my own system based on Buildroot that does not work now, please 
let me know...
