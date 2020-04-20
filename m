Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CCC1B15C6
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgDTTTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:19:17 -0400
Received: from correo.us.es ([193.147.175.20]:37132 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgDTTTR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 15:19:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BDE83E8B70
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 21:19:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB791207A2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 21:19:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A0AE9DA7B2; Mon, 20 Apr 2020 21:19:13 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1E84FA551;
        Mon, 20 Apr 2020 21:18:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 Apr 2020 21:18:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8317742EF42A;
        Mon, 20 Apr 2020 21:18:32 +0200 (CEST)
Date:   Mon, 20 Apr 2020 21:18:32 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree@solarflare.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420191832.ppxjjebls2idrshh@salvia>
References: <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
 <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
 <20200420123915.nrqancwjb7226l7e@salvia>
 <20200420134826.GH6581@nanopsycho.orion>
 <20200420135754.GD32392@breakpoint.cc>
 <20200420141422.GK6581@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="deaja572kukvzixv"
Content-Disposition: inline
In-Reply-To: <20200420141422.GK6581@nanopsycho.orion>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--deaja572kukvzixv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 20, 2020 at 04:14:22PM +0200, Jiri Pirko wrote:
> Mon, Apr 20, 2020 at 03:57:54PM CEST, fw@strlen.de wrote:
[...]
> >I mean, the user is forced to use SW datapath just because HW can't turn
> >off stats?!  Same for a config change, why do i need to change my rules
> 
> By default, they are on. That is what user should do in most of the
> cases.

Fair enough, I can workaround this problem by using
FLOW_ACTION_HW_STATS_ANY. However, I still don't need counters and
there is no way to say "I don't care" to the drivers.

Note that the flow_offload infrastructure is used by ethtool,
netfilter, flowtable and tc these days.

* ethtool's default behaviour is no counters.
* netfilter's default behaviour is no counters.
* flowtable's default behaviour is no counters.


I understand FLOW_ACTION_HW_STATS_DISABLED means disabled, strictly.
But would you allow me to introduce FLOW_ACTION_HW_STATS_DONT_CARE to
fix ethtool, netfilter and flowtable? :-)

FLOW_ACTION_HW_STATS_DONT_CARE means "this front-end doesn't need
counters, let driver decide what it is best".

Thank you.

--deaja572kukvzixv
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3619c6acf60f..ae09d1911912 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -164,17 +164,21 @@ enum flow_action_mangle_base {
 };
 
 enum flow_action_hw_stats_bit {
+	FLOW_ACTION_HW_STATS_DONT_CARE_BIT,
 	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
 	FLOW_ACTION_HW_STATS_DELAYED_BIT,
 };
 
 enum flow_action_hw_stats {
 	FLOW_ACTION_HW_STATS_DISABLED = 0,
+	FLOW_ACTION_HW_STATS_DONT_CARE =
+		BIT(FLOW_ACTION_HW_STATS_DONT_CARE_BIT),
 	FLOW_ACTION_HW_STATS_IMMEDIATE =
 		BIT(FLOW_ACTION_HW_STATS_IMMEDIATE_BIT),
 	FLOW_ACTION_HW_STATS_DELAYED = BIT(FLOW_ACTION_HW_STATS_DELAYED_BIT),
 	FLOW_ACTION_HW_STATS_ANY = FLOW_ACTION_HW_STATS_IMMEDIATE |
-				   FLOW_ACTION_HW_STATS_DELAYED,
+				   FLOW_ACTION_HW_STATS_DELAYED |
+				   FLOW_ACTION_HW_STATS_DONT_CARE,
 };
 
 typedef void (*action_destr)(void *priv);

--deaja572kukvzixv--
