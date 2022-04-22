Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EA850B4EB
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446401AbiDVKZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380820AbiDVKZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:25:55 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A59D54BE1
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:23:02 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 21so9876302edv.1
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wsn+ZFv/8MjIkh87SkBjlJybR0Ymcz+FYmuoHu3KHhc=;
        b=g7KNxXGtzwNFsqz7i9R3IHI33VKKlLAk+T3Zi2aIpxyVbcn0hAJQ2oUYt6cnyx4Gtk
         SV90D4SuUYFx1RzMoDYrGbPIpkwBe0eTVNHPzQomzMy9zzHBFJ5GLPoVcM2pTgZm1vWb
         chqn4brU8krrj+k3rHQge6wBu/PNOf5VJM1jS88zBDamDXlv1yapQyajx3UNkrbjhOXI
         aJCJjAbTO06HZtYfY1Q/dpbzLWYAwlx6eKAlD5uuyVXFWAZksOjEoEp8yjs7uNOJdtRx
         XCrOwPgMjUooiaGTfWEb/TwQkoujmcU+WDdWq2q40Vch4g/IXseYxaDgavUZ5yB09O86
         Ryug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wsn+ZFv/8MjIkh87SkBjlJybR0Ymcz+FYmuoHu3KHhc=;
        b=HOqfaF99zbUweGlIxg11zZPLkFo6oxtmgNurak+XS1hRtU4JiTjWJYgS0VS0H7r3+9
         PvmiOzQYKwAK61cWBDdb3smPrxDboQuHGjKFuM+ewsACDd6L132+yqh0YlcL8SoBtmO7
         E3HmnbbX0pyp1QXnhrieS/40DKkgtCgS5C5Skc8Ml3Yz8ggJx/iOnWHAjNVym+SrtS3N
         G1TJmO1pBJB2+ZlKNLlfndaHq6bFRwSeEwWlR2uJrpFOcUq7YbIZ4QlW6+NzQI46/egI
         QREhGJEPjQ9oeVKOO8xO7xoF3NY8yDGOgzH+siXo4EqVfXyZpu7NIJhiDE/Xhs+bikST
         OGXw==
X-Gm-Message-State: AOAM531nvze0qKs6lCZCznldQOrzc5PHUG+BjW2YcLglnaYhbQ809OY1
        gQXa+DvESJ0wDhqa9nLSqwY=
X-Google-Smtp-Source: ABdhPJwWJn6jPcBgBQIvZRI6AR+jImS93RijyvJE8SQkPE68mKbpdirjqzz1u3QL4CpSAi+AKSP3BQ==
X-Received: by 2002:a05:6402:84e:b0:422:b76c:bef8 with SMTP id b14-20020a056402084e00b00422b76cbef8mr4087400edz.238.1650622980519;
        Fri, 22 Apr 2022 03:23:00 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id t15-20020a1709064f0f00b006f00349c4c3sm593984eju.122.2022.04.22.03.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 03:22:59 -0700 (PDT)
Date:   Fri, 22 Apr 2022 13:22:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net-next 0/8] DSA selftests
Message-ID: <20220422102257.rqy2zd6liqwu7y7x@skbuf>
References: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 01:14:56PM +0300, Vladimir Oltean wrote:
> When working on complex new features or reworks it becomes increasingly
> difficult to ensure there aren't regressions being introduced, and
> therefore it would be nice if we could go over the functionality we
> already have and write some tests for it.
> 
> Verbally I know from Tobias Waldekranz that he has been working on some
> selftests for DSA, yet I have never seen them, so here I am adding some
> tests I have written which have been useful for me. The list is by no
> means complete (it only covers elementary functionality), but it's still
> good to have as a starting point. I also borrowed some refactoring
> changes from Joachim Wiberg that he submitted for his "net: bridge:
> forwarding of unknown IPv4/IPv6/MAC BUM traffic" series, but not the
> entirety of his selftests. I now think that his selftests have some
> overlap with bridge_vlan_unaware.sh and bridge_vlan_aware.sh and they
> should be more tightly integrated with each other - yet I didn't do that
> either :). Another issue I had with his selftests was that they jumped
> straight ahead to configure brport flags on br0 (a radical new idea
> still at RFC status) while we have bigger problems, and we don't have
> nearly enough coverage for the *existing* functionality.
> 
> One idea introduced here which I haven't seen before is the symlinking
> of relevant forwarding selftests to the selftests/drivers/net/<my-driver>/
> folder, plus a forwarding.config file. I think there's some value in
> having things structured this way, since the forwarding dir has so many
> selftests that aren't relevant to DSA that it is a bit difficult to find
> the ones that are.
> 
> While searching for applications that I could use for multicast testing
> (not my domain of interest/knowledge really), I found Joachim Wiberg's
> mtools, mcjoin and omping, and I tried them all with various degrees of
> success. In particular, I was going to use mcjoin, but I faced some
> issues getting IPv6 multicast traffic to work in a VRF, and I bothered
> David Ahern about it here:
> https://lore.kernel.org/netdev/97eaffb8-2125-834e-641f-c99c097b6ee2@gmail.com/t/
> It seems that the problem is that this application should use
> SO_BINDTODEVICE, yet it doesn't.
> 
> So I ended up patching the bare-bones mtools (msend, mreceive) forked by
> Joachim from the University of Virginia's Multimedia Networks Group to
> include IPv6 support, and to use SO_BINDTODEVICE. This is what I'm using
> now for IPv6.
> 
> Note that mausezahn doesn't appear to do a particularly good job of
> supporting IPv6 really, and I needed a program to emit the actual
> IP_ADD_MEMBERSHIP calls, for dev_mc_add(), so I could test RX filtering.
> Crafting the IGMP/MLD reports by hand doesn't really do the trick.
> While extremely bare-bones, the mreceive application now seems to do
> what I need it to.
> 
> Feedback appreciated, it is very likely that I could have done things in
> a better way.
> 
> Joachim Wiberg (2):
>   selftests: forwarding: add TCPDUMP_EXTRA_FLAGS to lib.sh
>   selftests: forwarding: multiple instances in tcpdump helper
> 
> Vladimir Oltean (6):
>   selftests: forwarding: add option to run tests with stable MAC
>     addresses
>   selftests: forwarding: add helpers for IP multicast group joins/leaves
>   selftests: forwarding: add helper for retrieving IPv6 link-local
>     address of interface
>   selftests: forwarding: add a no_forwarding.sh test
>   selftests: forwarding: add a test for local_termination.sh
>   selftests: drivers: dsa: add a subset of forwarding selftests
> 
>  .../drivers/net/dsa/bridge_locked_port.sh     |   1 +
>  .../selftests/drivers/net/dsa/bridge_mdb.sh   |   1 +
>  .../selftests/drivers/net/dsa/bridge_mld.sh   |   1 +
>  .../drivers/net/dsa/bridge_vlan_aware.sh      |   1 +
>  .../drivers/net/dsa/bridge_vlan_mcast.sh      |   1 +
>  .../drivers/net/dsa/bridge_vlan_unaware.sh    |   1 +
>  .../drivers/net/dsa/forwarding.config         |   2 +
>  .../testing/selftests/drivers/net/dsa/lib.sh  |   1 +
>  .../drivers/net/dsa/local_termination.sh      |   1 +
>  .../drivers/net/dsa/no_forwarding.sh          |   1 +
>  .../drivers/net/ocelot/tc_flower_chains.sh    |  24 +-
>  tools/testing/selftests/net/forwarding/lib.sh | 112 ++++++-
>  .../net/forwarding/local_termination.sh       | 299 ++++++++++++++++++
>  .../selftests/net/forwarding/no_forwarding.sh | 261 +++++++++++++++
>  14 files changed, 687 insertions(+), 20 deletions(-)
>  create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_locked_port.sh
>  create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_mdb.sh
>  create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_mld.sh
>  create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_aware.sh
>  create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_mcast.sh
>  create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_unaware.sh
>  create mode 100644 tools/testing/selftests/drivers/net/dsa/forwarding.config
>  create mode 120000 tools/testing/selftests/drivers/net/dsa/lib.sh
>  create mode 120000 tools/testing/selftests/drivers/net/dsa/local_termination.sh
>  create mode 120000 tools/testing/selftests/drivers/net/dsa/no_forwarding.sh
>  mode change 100644 => 100755 tools/testing/selftests/net/forwarding/lib.sh
>  create mode 100755 tools/testing/selftests/net/forwarding/local_termination.sh
>  create mode 100755 tools/testing/selftests/net/forwarding/no_forwarding.sh
> 
> -- 
> 2.25.1
> 

Sorry again, now I've really fixed all the places from which I could
have possibly copy-pasted Nikolay's dead NVIDIA email address.
It shouldn't happen again next time.

For those who consider replying, if you don't forget, maybe you can also
replace Nikolay's address in Cc: here to avoid getting a bounce-back
email from NVIDIA.

Sorry!
