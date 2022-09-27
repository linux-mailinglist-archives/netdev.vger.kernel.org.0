Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053025ECC26
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiI0S1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiI0S1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:27:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA6217D415;
        Tue, 27 Sep 2022 11:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48916617AE;
        Tue, 27 Sep 2022 18:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FD8C433C1;
        Tue, 27 Sep 2022 18:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664303232;
        bh=VmeZoaR4znmAeKpaeUX///idXMsk6iOrJR1YkkoUSQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U93JZXK2THIHddlkh50COJm0+uGpFKCjBA5v005IafWDRMqx4ahy2pNgArW0IsJ+1
         1Wr79efqmxciHNZoWUS2SuZDdKiZbB4tFG3m07Ep8M/OzlkIe2GfRRiM+Xa8qZgCIf
         uHMeib1UUDfBSSH2Ybgi+mGfuSXwNPgzCTh1FixXfIpcQlR3I8kM3C9zFPSb0Huf2B
         AAZ8I4fDBQs1DR1g+IIbyLW/IchGFbJC5cD0lMvhkZWbwa0Yh2L/ESnSFlnSchhaV0
         TR5lSiscd3tFza9T10FhJvTo3viVpzikKE84MukGm6ZiQ7EBN0zIWDAJyP6IzEwlgV
         Frq6QojYSetvQ==
Date:   Tue, 27 Sep 2022 11:27:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
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
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 01/12] net/sched: taprio: allow user input
 of per-tc max SDU
Message-ID: <20220927112710.5fc7720f@kernel.org>
In-Reply-To: <20220927150921.ffjdliwljccusxad@skbuf>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
        <20220923163310.3192733-2-vladimir.oltean@nxp.com>
        <20220926133829.6bb62b8a@kernel.org>
        <20220927150921.ffjdliwljccusxad@skbuf>
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

On Tue, 27 Sep 2022 18:09:21 +0300 Vladimir Oltean wrote:
> On Mon, Sep 26, 2022 at 01:38:29PM -0700, Jakub Kicinski wrote:
> > On Fri, 23 Sep 2022 19:32:59 +0300 Vladimir Oltean wrote:  
> > > +	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
> > > +		NL_SET_ERR_MSG_MOD(extack, "TC entry index missing");  
> > 
> > NL_SET_ERR_ATTR_MISS() ?
> >   
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	tc = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
> > > +	if (tc >= TC_QOPT_MAX_QUEUE) {
> > > +		NL_SET_ERR_MSG_MOD(extack, "TC entry index out of range");  
> > 
> > NLA_POLICY_MAX()
> > 
> > Are you not using those on purpose? :(  
> 
> I don't exactly see it as being super user friendly to leave it to the
> policy validator (or to use NL_SET_ERR_ATTR_MISS()) because all that
> will be reported back to user space will be the offset to the original
> attribute in the nlmsghdr, which is pretty hard to retrieve and
> re-interpret (at least in the iproute2 tc source code, I can't seem to
> find a way to stringify it or something like that). For the NLA_POLICY_MAX(),
> all I'll get now is an uninformative "Error: integer out of range."
> What integer?  What range?

I know, that's what I expected you'd say :(
You'd need a reverse parser which is a PITA to do unless you have
clearly specified bindings.

> I don't understand what is the gain of removing extack message strings
> and just pointing to the netlink attribute via NLMSGERR_ATTR_OFFS? Could
> I at least use the NL_SET_ERR_ATTR_MISS() helper *and* set a custom message?
> That's for the missing nlattr. Regarding the range checking in the
> policy, I'd like a custom message there as well, but the NLA_POLICY_MAX()
> doesn't provide one. However, I see that struct nla_policy has a const
> char *reject_message for NLA_REJECT types. Would it be an abuse to move
> this outside of the union and allow U32 policies and such to also
> provide it?

I'd rather you kept the code as is than make precedent for adding both
string and machine readable. If we do that people will try to stay on
the safe side and always add both.

The machine readable format is carries all the information you need.
It's just the user space is not clever enough to read it which is,
well, solvable.
