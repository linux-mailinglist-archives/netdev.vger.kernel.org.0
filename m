Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53C05EB258
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiIZUiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiIZUid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:38:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23A9A2AAA;
        Mon, 26 Sep 2022 13:38:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8499461325;
        Mon, 26 Sep 2022 20:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79B8C433C1;
        Mon, 26 Sep 2022 20:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664224711;
        bh=QyJMP+QGSUxMTsVikViQMth7+3yPtv37tyQBNBwftbE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V6CIQWY+Z37bnN8kxk+cWMBiF00KrPy8xJXN2YnVpMzSTm6hcCjIHHEXXROMJZirO
         +gM/0efmkvPwJWgA+1xGBk4PRPJoDGtZqTftoDRVLMga2dwAGxbVtdcsS9hzqGo66a
         MsSvp0IaKcwrrqBb/VKT2zjQ6/CsXdk+IEKab7UwJBqdEfBiDuNF7MQ8J9Ysw+JBKW
         FmPifPoCPazYJJBIbCMCz5XfmpUHkEqZPWn23PrCREcGwjSQxIHAEUOfdw/Y/gtF8u
         3IjYTEYpMLE+hn2hoXsAuIrCYq2j4TzJfCFOIGQWtAFN9mFXxnrTtN/yHEJWHGDqgS
         lz26O2I5ef7/Q==
Date:   Mon, 26 Sep 2022 13:38:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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
        Vladimir Oltean <olteanv@gmail.com>,
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
Message-ID: <20220926133829.6bb62b8a@kernel.org>
In-Reply-To: <20220923163310.3192733-2-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
        <20220923163310.3192733-2-vladimir.oltean@nxp.com>
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

On Fri, 23 Sep 2022 19:32:59 +0300 Vladimir Oltean wrote:
> +	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
> +		NL_SET_ERR_MSG_MOD(extack, "TC entry index missing");

NL_SET_ERR_ATTR_MISS() ?

> +		return -EINVAL;
> +	}
> +
> +	tc = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
> +	if (tc >= TC_QOPT_MAX_QUEUE) {
> +		NL_SET_ERR_MSG_MOD(extack, "TC entry index out of range");

NLA_POLICY_MAX()

Are you not using those on purpose? :(
