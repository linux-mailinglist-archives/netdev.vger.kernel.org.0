Return-Path: <netdev+bounces-6590-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADE017170BB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61319281385
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92EEEA931;
	Tue, 30 May 2023 22:33:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843B04C75
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:33:06 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D91093;
	Tue, 30 May 2023 15:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685485985; x=1717021985;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=VABDFdCJy0Ud+Ks8o/SFbThuZCncKrRivw4ObAAYIR8=;
  b=P+kkw8dYQD+M0bIFBD1IBW+RdX870JA2uZdwRybdWDIMrH9HK+Ct3hPV
   6bN3e9PR06zpcBztXTt8X5llR7CR5uJ/D3bDapn9dLMkjQq6hC/gBvIsH
   1kalHg4bCQW6xbbvpGZaeZLuydg7NDweUxAvMIKZkb6h0xqpAuVfnkpkZ
   Uu8+gZJMwrkR1yOkXfbURBFMBszeihhHx0xrUaioXwEzwko4179P846Dx
   EYdQTjtx5YOZVLEktoyllgFVyHKKQ0cnrQnsmE4IrOtXTv/IZZdBJUZeM
   w0aCavBOI5t6JOyj69uN4WCpNHbgCx9CgkqdOB5DvWKW573gRvYgkMLSx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="358322047"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="358322047"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 15:33:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="880914492"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="880914492"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.17])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 15:33:02 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, Kurt Kanzenbach
 <kurt@linutronix.de>, Gerhard Engleder <gerhard@engleder-embedded.com>,
 Amritha Nambiar <amritha.nambiar@intel.com>, Ferenc Fejes
 <ferenc.fejes@ericsson.com>, Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
 Roger Quadros <rogerq@kernel.org>, Pranavi Somisetty
 <pranavi.somisetty@amd.com>, Harini Katakam <harini.katakam@amd.com>,
 Giuseppe Cavallaro <peppe.cavallaro@st.com>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, Michael Sit Wei Hong
 <michael.wei.hong.sit@intel.com>, Mohammad Athari Bin Ismail
 <mohammad.athari.ismail@intel.com>, Oleksij Rempel
 <linux@rempel-privat.de>, Jacob Keller <jacob.e.keller@intel.com>,
 linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>, Florian
 Fainelli <f.fainelli@gmail.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 UNGLinuxDriver@microchip.com, Jesse
 Brandeburg <jesse.brandeburg@intel.com>, Tony Nguyen
 <anthony.l.nguyen@intel.com>, Horatiu Vultur
 <horatiu.vultur@microchip.com>, Jose Abreu <joabreu@synopsys.com>, Maxime
 Coquelin <mcoquelin.stm32@gmail.com>, intel-wired-lan@lists.osuosl.org,
 Muhammad
 Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net-next 1/5] net/sched: taprio: don't overwrite "sch"
 variable in taprio_dump_class_stats()
In-Reply-To: <20230530213252.pddrmwgppneawmht@skbuf>
References: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
 <20230530091948.1408477-2-vladimir.oltean@nxp.com>
 <87edmxv7x2.fsf@intel.com> <20230530213252.pddrmwgppneawmht@skbuf>
Date: Tue, 30 May 2023 15:33:02 -0700
Message-ID: <878rd5v49t.fsf@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Tue, May 30, 2023 at 02:14:17PM -0700, Vinicius Costa Gomes wrote:
>> But I have a suggestion, this "taprio_queue_get() ->
>> dev_queue->qdisc_sleeping()" dance should have the same result as
>> calling 'taprio_leaf()'.
>> 
>> I am thinking of using taprio_leaf() here and in taprio_dump_class().
>> Could be a separate commit.
>
> Got it, you want to consolidate the dev_queue->qdisc_sleeping pattern.
> Since taprio_dump_class() could benefit from the consolidation too, they
> could really be both converted separately. Or I could also handle that
> in this patch set, if I need to resend it.

Exactly. Both options sound great.


Cheers,
-- 
Vinicius

