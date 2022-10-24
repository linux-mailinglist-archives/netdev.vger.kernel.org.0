Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C0760B5AD
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiJXShF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiJXSgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:36:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27E8201AC;
        Mon, 24 Oct 2022 10:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62B00B81888;
        Mon, 24 Oct 2022 17:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0086C433C1;
        Mon, 24 Oct 2022 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666631284;
        bh=qWgfUtE4UN4/iCrWAyctAyzwt74lHMnUej7miAfWozs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zu+kqShRcjC8nRPj+ZPavRcjYG48rUxYr/xtUKVxq/tVD3qP4BQ8938gc4JRHh+sQ
         wUEoCQstYbywkycJbXo1Gx9NudXpA31ePGv1ymKF7AziAkUafYLdFNwgeHV1QImOEK
         JFwJgG3tBQ+MqnkxeUpIBTBFzGPMlWiBuQYZJPplfyUZSfiekZhXplF9BCf4TEz5cR
         BoSuO18xOEhTlK5W4tnJUnjIc+5268Ad/+OGpyLVWX/qO+ewTt1u6BRu/hvzFkn3Kl
         CbW0He1dZ/toR97u7dANoXILUr18MDMSTzT2iOWvvh3xihpjn8Gr15icEr7MzFt17l
         NwXsJuVW8BO6Q==
Date:   Mon, 24 Oct 2022 10:08:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
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
Subject: Re: [PATCH v8 net-next 02/12] net: bridge: add blackhole fdb entry
 flag
Message-ID: <20221024100801.6c391ff9@kernel.org>
In-Reply-To: <7690b7f836b144b60f60b3b68d3bf784@kapio-technology.com>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
        <20221018165619.134535-3-netdev@kapio-technology.com>
        <Y1FHuXE+X/V9aRvh@shredder>
        <7690b7f836b144b60f60b3b68d3bf784@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Oct 2022 07:32:02 +0200 netdev@kapio-technology.com wrote:
> >> @@ -1140,7 +1148,7 @@ static int __br_fdb_add(struct ndmsg *ndm, 
> >> struct net_bridge *br,
> >>  		err = br_fdb_external_learn_add(br, p, addr, vid, true);
> >>  	} else {
> >>  		spin_lock_bh(&br->hash_lock);
> >> -		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
> >> +		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, ext_flags, 
> >> nfea_tb);  
> > 
> > I believe the preference is to wrap to 80 columns when possible.  
> 
> Very strange... since I ran checkpatch.pl from the net-next kernel 
> itself and it did not
> give me any warnings about 80 columns, but rather said 'patch is ready 
> for submission'.
> 
> As this is silent, could it be some missing python plugins or something 
> to do with perl?

I run:

./scripts/checkpatch.pl --strict --max-line-length=80

