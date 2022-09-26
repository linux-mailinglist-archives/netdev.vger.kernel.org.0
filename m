Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808705EB5C4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiIZX3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiIZX3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:29:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE6ADF96;
        Mon, 26 Sep 2022 16:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98FB761514;
        Mon, 26 Sep 2022 23:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF189C433C1;
        Mon, 26 Sep 2022 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664234977;
        bh=cta2tfrXgkkpSJeDQBht6XFAQ6L5k4lJTcVaApoEA5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IlyI8JuH1iynVj2WuRqLKNUauOiw88VWMBxnryUrir9tdLI9dbo1weQhJANJJNQd3
         lzEZtuZU6teyYmrl9MZkLwcQHWXi5IKX36M7hdQJlENSsReh+OlPQxsjfmn4ivdmHn
         o6Av0sWC9HcrIMRHdDFU4uNpGld7VG6FDwvqge5LWiq2ojiAfITr+wxVOPFdUfr8ke
         nB7po0v2mlTogzXe2v9DGSgvzofryWr4luuMrHoJSzHYWPmwru2/m38CFYZrKss1Q2
         +HiZpmFszeq+IgkqPBT9Z3jQjGXv6xkNjDcmuFuPukxXQ+m487IiZG66kidyMFu/qX
         oYhiYEUxAJlrw==
Date:   Mon, 26 Sep 2022 16:29:34 -0700
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
Subject: Re: [PATCH v2 net-next 02/12] tsnep: deny tc-taprio changes to
 per-tc max SDU
Message-ID: <20220926162934.58bf38a6@kernel.org>
In-Reply-To: <20220926215049.ndvn4ocfvkskzel4@skbuf>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
        <20220923163310.3192733-3-vladimir.oltean@nxp.com>
        <20220926134025.5c438a76@kernel.org>
        <20220926215049.ndvn4ocfvkskzel4@skbuf>
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

On Tue, 27 Sep 2022 00:50:49 +0300 Vladimir Oltean wrote:
> > Don't all the driver patches make you wanna turn this into an opt-in?  
> 
> Presumably you're thinking of a way through which the caller of
> ndo_setup_tc(TC_SETUP_QDISC_TAPRIO, struct tc_taprio_qopt_offload *)
> knows whether the driver took the new max_sdu field into consideration,
> and not just accepted it blindly?
> 
> I'm not exactly up to date with all the techniques which can achieve
> that without changes in drivers, and I haven't noticed other qdisc
> offloads doing it either... but this would be a great trick to learn for
> sure. Do you have any idea?

I usually put a capability field into the ops themselves. But since tc
offloads don't have real ops (heh) we need to do the command callback
thing. This is my knee-jerk coding of something:

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9f42fc871c3b..2d043def76d8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -960,6 +960,11 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_FIFO,
 	TC_SETUP_QDISC_HTB,
 	TC_SETUP_ACT,
+	TC_QUERY_CAPS,
+};
+
+struct tc_query_caps {
+	u32 cmd;
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 2ff80cd04c5c..2416151a23db 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -155,6 +155,12 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_taprio_drv_caps {
+	struct tc_query_caps base;
+
+	bool accept_max_sdu;
+};
+
 struct tc_taprio_sched_entry {
 	u8 command; /* TC_TAPRIO_CMD_* */
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 136ae21ebce9..68302ee33937 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1219,6 +1219,7 @@ static int taprio_enable_offload(struct net_device *dev,
 				 struct sched_gate_list *sched,
 				 struct netlink_ext_ack *extack)
 {
+	struct tc_taprio_drv_caps caps = { { .cmd = TC_SETUP_QDISC_TAPRIO, }, };
 	const struct net_device_ops *ops = dev->netdev_ops;
 	struct tc_taprio_qopt_offload *offload;
 	int err = 0;
@@ -1229,6 +1230,12 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 
+	ops->ndo_setup_tc(dev, TC_QUERY_CAPS, &caps);
+	if (!caps.accept_max_sdu && taprio_is_max_sdu_used(...))  {
+		NL_SET_ERR_MSG(extack, "nope.");
+		return -EOPNOTSUPP;
+	}
+
 	offload = taprio_offload_alloc(sched->num_entries);
 	if (!offload) {
 		NL_SET_ERR_MSG(extack,

> > What are the chances we'll catch all drivers missing the validation 
> > in review?  
> 
> Not that slim I think, they are all identifiable if you search for
> TC_SETUP_QDISC_TAPRIO.

Right, but that's what's in the tree _now_. Experience teaches that
people may have out of tree code which implements TAPRIO and may send
it for upstream review without as much as testing it against net-next :(
As time passes and our memories fade the chances we'd catch such code
when posted upstream go down, perhaps from high to medium but still,
the explicit opt-in is more foolproof.
