Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705835ECF4E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 23:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiI0Vcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 17:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiI0Vca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 17:32:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91417105D50;
        Tue, 27 Sep 2022 14:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C2E1B81DC7;
        Tue, 27 Sep 2022 21:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC7CC433C1;
        Tue, 27 Sep 2022 21:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664314347;
        bh=SpTVVg5bGfdD6TuPshyPPNiG6lr2nJAW7ejy5Z1c2Bk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zb61xfmNPQSQfdjxY6G76uJnWeb9UbUaS1qNNS8VFqPcyJm5bwXourkXKiuXfWpp0
         Zk7hKkRDYvNWvskN2fzMgaVa8siV/D63dC1rFIYPTD0iGQ0TXfg4e5qNrv8U0z22df
         WnBdN5l4fe+ivAy3MNxH7hvoSOMQlWi4nYhkr4RIfcyT2cP9jbZxv8sWedDwqxg2B9
         hz7SC7I3fxXxVChdUGLkMcvn81POtfqYq3hC7Mh5LqugdYbVjys0IFq6Ung8uCH0V/
         vea8h4Ap2qpjBcfsk/+TaQfPDAk/20AtZG5UtkI9J//91OHbwYArD74vK3sW9kde8v
         6UAQjGt1rpXAQ==
Date:   Tue, 27 Sep 2022 14:32:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 01/12] net/sched: taprio: allow user input
 of per-tc max SDU
Message-ID: <20220927143225.546ba2b8@kernel.org>
In-Reply-To: <20220927212319.pc75hlhsw7s6es6p@skbuf>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
        <20220923163310.3192733-2-vladimir.oltean@nxp.com>
        <20220926133829.6bb62b8a@kernel.org>
        <20220927150921.ffjdliwljccusxad@skbuf>
        <20220927112710.5fc7720f@kernel.org>
        <20220927212319.pc75hlhsw7s6es6p@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 21:23:19 +0000 Vladimir Oltean wrote:
> On Tue, Sep 27, 2022 at 11:27:10AM -0700, Jakub Kicinski wrote:
> > I know, that's what I expected you'd say :(
> > You'd need a reverse parser which is a PITA to do unless you have
> > clearly specified bindings.  
> 
> I think you're underestimating the problem, it's worse than PITA. My A
> still hurts and yet I couldn't find any way in which reverse parsing the
> bad netlink attribute is in any way practical in iproute2, other than
> doing it to prove a point that it's possible.

Yup, iproute2 does not have policy tables, so it's hard.

Once you have tables like this:

https://github.com/kuba-moo/ynl/blob/main/tools/net/ynl/generated/ethtool-user.c#L22

all linking up the types, it's fairly easy to reverse parse:

https://github.com/kuba-moo/ynl/blob/main/tools/net/ynl/lib/ynl.c#L75

Admittedly I haven't added parsing of the bounds yet so it'd just say
"invalid argument .bla.something" not "argument out of range
.bla.something (is: X, range N-M)" but that's just typing.

> > I'd rather you kept the code as is than make precedent for adding both
> > string and machine readable. If we do that people will try to stay on
> > the safe side and always add both.
> >
> > The machine readable format is carries all the information you need.  
> 
> Nope, the question "What range?" still isn't answered via the machine
> readable format. Just "What integer?".

Hm, doesn't NLMSGERR_ATTR_POLICY contain the bounds?

> > It's just the user space is not clever enough to read it which is,
> > well, solvable.  
> 
> You should come work at NXP, we love people who keep a healthy dose of
> unnecessary complexity in things :)

Ha! :D

> Sometimes, "not clever enough" is just fine.

Yup, go ahead with just the strings. "We'll get there" for the machine
readable parsing, hopefully, once my YAML descriptions come...
