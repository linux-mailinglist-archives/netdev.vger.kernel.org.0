Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7AC609153
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 07:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJWFcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 01:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiJWFcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 01:32:07 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047DA75380;
        Sat, 22 Oct 2022 22:32:04 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 6DA421884623;
        Sun, 23 Oct 2022 05:32:02 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 5A307250007B;
        Sun, 23 Oct 2022 05:32:02 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 46F999EC000A; Sun, 23 Oct 2022 05:32:02 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 23 Oct 2022 07:32:02 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [PATCH v8 net-next 02/12] net: bridge: add blackhole fdb entry
 flag
In-Reply-To: <Y1FHuXE+X/V9aRvh@shredder>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-3-netdev@kapio-technology.com>
 <Y1FHuXE+X/V9aRvh@shredder>
User-Agent: Gigahost Webmail
Message-ID: <7690b7f836b144b60f60b3b68d3bf784@kapio-technology.com>
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

On 2022-10-20 15:06, Ido Schimmel wrote:

> [...]
> 
>> @@ -1140,7 +1148,7 @@ static int __br_fdb_add(struct ndmsg *ndm, 
>> struct net_bridge *br,
>>  		err = br_fdb_external_learn_add(br, p, addr, vid, true);
>>  	} else {
>>  		spin_lock_bh(&br->hash_lock);
>> -		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
>> +		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, ext_flags, 
>> nfea_tb);
> 
> I believe the preference is to wrap to 80 columns when possible.

Very strange... since I ran checkpatch.pl from the net-next kernel 
itself and it did not
give me any warnings about 80 columns, but rather said 'patch is ready 
for submission'.

As this is silent, could it be some missing python plugins or something 
to do with perl?
