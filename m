Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EB35B90AE
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiINXAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiINXAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:00:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1823C62ABE;
        Wed, 14 Sep 2022 16:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663196409; x=1694732409;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=Gy5Kr1K0CD2RjOuPjSjaim0htKIdr+oZcI5W0+mLzZA=;
  b=ngEIPv9r90EBFK7C19tsn8Ge0MjdFUlZSaedgLSxsM8CpQeS3nSpuWl6
   KdCXcZaTKxmHvP9vy3B1SO/APqaY2OaAgJYe/o5A9sDzX7Wr+rY7kb/br
   wCKbyOekKchmZZJ/tDotsdbdFpAaHUxRStapNzZG9QpOCJfmJC04GCI+e
   zWlUMracmp4Z+xS1MZFOD58/mwat/XosTlUkNQMpThB+uh2Sbq9kbCzMA
   se7F3wx0Bwkurpc7dvNcoFotzeizVukkuaGYXCR4iGd2aga/82UeUshm+
   GP8lUe6DJIa8Lk0vzD61SM2HlHA+hPWOdciSTHb56k2Bz8RKjHYJ6XLmM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="297288772"
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="297288772"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 16:00:07 -0700
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="594575591"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 16:00:07 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 04/13] net/sched: taprio: allow user input of
 per-tc max SDU
In-Reply-To: <20220914221042.oenxhxacgt2xsb2k@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-5-vladimir.oltean@nxp.com>
 <87k065iqe1.fsf@intel.com> <20220914221042.oenxhxacgt2xsb2k@skbuf>
Date:   Wed, 14 Sep 2022 16:00:07 -0700
Message-ID: <871qsdimtk.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Wed, Sep 14, 2022 at 02:43:02PM -0700, Vinicius Costa Gomes wrote:
>> > @@ -416,6 +417,9 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
>> >  			      struct Qdisc *child, struct sk_buff **to_free)
>> >  {
>> >  	struct taprio_sched *q = qdisc_priv(sch);
>> > +	struct net_device *dev = qdisc_dev(sch);
>> > +	int prio = skb->priority;
>> > +	u8 tc;
>> >  
>> >  	/* sk_flags are only safe to use on full sockets. */
>> >  	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
>> > @@ -427,6 +431,12 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
>> >  			return qdisc_drop(skb, sch, to_free);
>> >  	}
>> >  
>> > +	/* Devices with full offload are expected to honor this in hardware */
>> > +	tc = netdev_get_prio_tc_map(dev, prio);
>> > +	if (q->max_sdu[tc] &&
>> > +	    q->max_sdu[tc] < max_t(int, 0, skb->len - skb_mac_header_len(skb)))
>> > +		return qdisc_drop(skb, sch, to_free);
>> > +
>> 
>> One minor idea, perhaps if you initialize q->max_sdu[] with a value that
>> you could use to compare here (2^32 - 1), this comparison could be
>> simplified. The issue is that that value would become invalid for a
>> maximum SDU, not a problem for ethernet.
>
> Could do (and the fact that U32_MAX becomes a reserved value shouldn't
> be a problem for any linklayer), but if I optimize the code for this one
> place, I need, in turn, to increase the complexity in the netlink dump
> and in the offload procedures, to hide what I've done.

Hm, I just noticed something.

During parse the user only sets the max-sdu for the traffic classes she
is interested on. During dump you are showing all of them, the unset
ones will be shown as zero, that seems a bit confusing, which could mean
that you would have to add some checks anyway.

For the offload side, you could just document that U32_MAX means unset.

>
> If I look at the difference in generated code, maybe it's worth it
> (I get rid of a "cbz" instruction). Maybe it's worth simply creating a
> shadow array of q->max_sdu[], but which is also adjusted for something
> like dev->hard_header_len (also a fast path invariant)? This way, we
> could only check for q->max_frm_len[tc] > skb->len and save even more
> checks in the fast path.

-- 
Vinicius
