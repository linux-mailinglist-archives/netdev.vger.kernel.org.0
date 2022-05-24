Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166F4532B33
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 15:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbiEXNYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 09:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbiEXNYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 09:24:41 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208281E3D9
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 06:24:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id f9so35407069ejc.0
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 06:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sqduQAfA787X6rig9SqlmkHyKjTWXRmJeOc/9yUWmmQ=;
        b=P43biSn1PTFuNq2+e9eJQ+Pe6clET2SEKKLSii1uor8YhCbWfsF8XpoJkyUr1paPfT
         gfWiet+O0CPT1MOJDDSwaqdBeRMEgNhDSFSG9icGX/D7qA7V2Dv05G1GrF+AezcIf8QI
         kUsu8job/gMgJHWkaBUe5HuDk1O5dnr0jXcnaVEPiP20kUdfoPrXVmM5HJpJO1zEklMW
         XIFSxHJ4rnSbwLi4fiKlkvuBklTwEX3X2Wkz7Y/sjURnCSfRto7+f0pqe33v4lgIKr2u
         IoRLGH0h9OI9F7UFCJVGHfP/2NNAbkhm1/ceC6CT5oPpGZsRIqjzt5LwGDUU5tP1FCQ+
         RwXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sqduQAfA787X6rig9SqlmkHyKjTWXRmJeOc/9yUWmmQ=;
        b=UsaW+kW2R75eg1uWK9FMddKq1o2m30ZvfHdAmQStBvEjMPh3Hx9r5ggK5PBch3z3yz
         SrM6iTtawWTDTL13KbpqyNycoYH0AfeI7X4iXbqu6Ri3SEzMjysNg4FZUsmufPIgoK1Z
         43r+45fxYFIOs8YeBlDlV8Twt4A1GMYaWrQfSdP6sIr4FtRIQmnXk98dJv2PUZZNtLVc
         PTtkXM/gFUWniKdYvwWNS911kJ3DIPW176wDF1O40YmZOaELx4JwNp5L5vhPc4izeKAQ
         Xq8v4fnueVCteGPp0I7WYp0UDuhthYcOP2g7eXLxBeRJVO849BznS2sEvv7eJnxGVzfH
         hdtA==
X-Gm-Message-State: AOAM532S9dh7JY+3UFdDJWShPqtNMxPO725TG5CMyVH1ANYrht889946
        3LSfdo0OEuJkCoh8Jq/EL7s=
X-Google-Smtp-Source: ABdhPJywHsivIMbFUan/Ocblu3tfcGnGzenGl9bLLakvzp1Vfd8kmuCwmtuj58cXICeG2XmORouycw==
X-Received: by 2002:a17:907:2cc5:b0:6f9:1fc:ebef with SMTP id hg5-20020a1709072cc500b006f901fcebefmr23743001ejc.121.1653398678450;
        Tue, 24 May 2022 06:24:38 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id l8-20020a1709060e0800b006f3ef214e62sm1934276eji.200.2022.05.24.06.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 06:24:37 -0700 (PDT)
Date:   Tue, 24 May 2022 16:24:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC PATCH net-next 00/12] DSA changes for multiple CPU ports
 (part 3)
Message-ID: <20220524132435.vj35shnzbrtw3ikz@skbuf>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <628cc94d.1c69fb81.15b0d.422d@mx.google.com>
 <20220524122905.4y5kbpdjwvb6ee4p@skbuf>
 <628cd1e0.1c69fb81.d28b0.df81@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <628cd1e0.1c69fb81.d28b0.df81@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 02:38:53PM +0200, Ansuel Smith wrote:
> On Tue, May 24, 2022 at 12:29:06PM +0000, Vladimir Oltean wrote:
> > On Tue, May 24, 2022 at 02:02:19PM +0200, Ansuel Smith wrote:
> > > Probably offtopic but I wonder if the use of a LAG as master can
> > > cause some problem with configuration where the switch use a mgmt port
> > > to send settings. Wonder if with this change we will have to introduce
> > > an additional value to declare a management port that will be used since
> > > master can now be set to various values. Or just the driver will have to
> > > handle this with its priv struct (think this is the correct solution)
> > > 
> > > I still have to find time to test this with qca8k.
> > 
> > Not offtopic, this is a good point. dsa_tree_master_admin_state_change()
> > and dsa_tree_master_oper_state_change() set various flags in cpu_dp =
> > master->dsa_ptr. It's unclear if the cpu_dp we assign to a LAG should
> > track the admin/oper state of the LAG itself or of the physical port.
> > Especially since the lag->dsa_ptr is the same as one of the master->dsa_ptr.
> > It's clear that the same structure can't track both states. I'm thinking
> > we should suppress the NETDEV_CHANGE and NETDEV_UP monitoring from slave.c
> > on LAG DSA masters, and track only the physical ones. In any case,
> > management traffic does not really benefit from being sent/received over
> > a LAG, and I'm thinking we should just use the physical port.
> > Your qca8k_master_change() function explicitly only checks for CPU port
> > 0, which in retrospect was a very wise decision in terms of forward
> > compatibility with device trees with multiple CPU ports.
> 
> Switch can also have some hw limitation where mgmt packet are accepted
> only by one specific port and I assume using a LAG with load balance can
> cause some problem (packet not ack).
> 
> Yes I think the oper_state_change would be problematic with a LAG
> configuration since the driver should use the pysical port anyway (to
> prevent any hw limitation/issue) and track only that.
> 
> But I think we can put that on hold and think of a correct solution when
> we have a solid base with all of this implemented. Considering qca8k
> is the only user of that feature and things will have to change anyway
> when qca8k will get support for multiple cpu port, we can address that
> later. (in theory everything should work correctly if qca8k doesn't
> declare multiple cpu port or a LAG is not confugred) 

Consider this - the way in which DSA tracks the state of DSA masters
already "supports multiple [ physical ] CPU ports". It's just a matter
of driver writers acknowledging this and doing the right thing in the
ds->ops->master_state_change() callback. DSA tells us when any physical
master goes up or down, and it does this regardless of whether that
master's dsa_ptr is the dp->cpu_dp of any user port. Otherwise said,
given this device tree snippet:

eth0: ethernet@0 {
	...
};

eth1: ethernet@1 {
	...
};

ethernet-switch@0 {
	ethernet-ports {
		ethernet-port@0 {
			label = "swp0";
		};

		ethernet-port@1 {
			label = "swp1";
		};

		ethernet-port@2 {
			ethernet = <&eth0>;
		};

		ethernet-port@3 {
			ethernet = <&eth1>;
		};
	};
};

Current mainline DSA will create swp0@eth0 and swp1@eth0, but it will
call dsa_master_setup(eth0) and dsa_master_setup(eth1). Then it will
monitor the state of both eth0 and eth1, and pass updates to both
masters' states down to the driver.

It is therefore the responsibility of the driver to ensure forward
compatibility with multiple CPU ports (otherwise said, if one master
goes down, don't hurry to say "I don't have any management interface to
use for register access" - maybe the other one is still ok).
Consequently, you can use a DSA master for register access even if no
dp->cpu_dp points to it. This patch set is just about changing the
dp->cpu_dp mapping that is used for netdevice traffic, which is quite
orthogonal to the concern you describe.
