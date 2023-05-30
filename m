Return-Path: <netdev+bounces-6571-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B234716FA7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 092881C20A61
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0FF2D262;
	Tue, 30 May 2023 21:25:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEF8200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:25:07 +0000 (UTC)
X-Greylist: delayed 2063 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 May 2023 14:25:02 PDT
Received: from mx11lb.world4you.com (mx11lb.world4you.com [81.19.149.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08160D9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tmK094y96wxnVZkH2WsdAa3vLGfUTZukvcfeq7bEgWM=; b=g2658kAvRw+cmjUJNfxuCNCd4i
	d9gNNNLErmW8wcGrdqA8ala/MJNOtzhBThzY5NnncEfzZpdlLQTmFuLxJFjskHkF3Xpr1PWicSNvm
	gPuQNG3iSdGkO/fBG5epBXViCUyzsQmE2JCDMbQSjx74JgEsCNQmYDhkvdKAnI1LDczU=;
Received: from [88.117.62.186] (helo=[10.0.0.160])
	by mx11lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <gerhard@engleder-embedded.com>)
	id 1q46Ia-0002Tp-2o; Tue, 30 May 2023 22:50:32 +0200
Message-ID: <7602e37b-1b83-8697-d9e6-c9cc1e5214e3@engleder-embedded.com>
Date: Tue, 30 May 2023 22:50:31 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 2/5] net/sched: taprio: replace
 tc_taprio_qopt_offload :: enable with a "cmd" enum
To: Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
 Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>,
 Kurt Kanzenbach <kurt@linutronix.de>,
 Amritha Nambiar <amritha.nambiar@intel.com>,
 Ferenc Fejes <ferenc.fejes@ericsson.com>,
 Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Roger Quadros
 <rogerq@kernel.org>, Pranavi Somisetty <pranavi.somisetty@amd.com>,
 Harini Katakam <harini.katakam@amd.com>,
 Giuseppe Cavallaro <peppe.cavallaro@st.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
 Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
 Oleksij Rempel <linux@rempel-privat.de>,
 Jacob Keller <jacob.e.keller@intel.com>, linux-kernel@vger.kernel.org,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 Claudiu Manoil <claudiu.manoil@nxp.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 UNGLinuxDriver@microchip.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Horatiu Vultur <horatiu.vultur@microchip.com>,
 Jose Abreu <joabreu@synopsys.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 intel-wired-lan@lists.osuosl.org,
 Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
References: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
 <20230530091948.1408477-3-vladimir.oltean@nxp.com>
Content-Language: en-US
From: Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230530091948.1408477-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 30.05.23 11:19, Vladimir Oltean wrote:
> Inspired from struct flow_cls_offload :: cmd, in order for taprio to be
> able to report statistics (which is future work), it seems that we need
> to drill one step further with the ndo_setup_tc(TC_SETUP_QDISC_TAPRIO)
> multiplexing, and pass the command as part of the common portion of the
> muxed structure.
> 
> Since we already have an "enable" variable in tc_taprio_qopt_offload,
> refactor all drivers to check for "cmd" instead of "enable", and reject
> every other command except "replace" and "destroy" - to be future proof.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>   drivers/net/dsa/hirschmann/hellcreek.c             | 14 +++++++++-----
>   drivers/net/dsa/ocelot/felix_vsc9959.c             |  4 +++-
>   drivers/net/dsa/sja1105/sja1105_tas.c              |  7 +++++--
>   drivers/net/ethernet/engleder/tsnep_selftests.c    | 12 ++++++------
>   drivers/net/ethernet/engleder/tsnep_tc.c           |  4 +++-
>   drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  6 +++++-
>   drivers/net/ethernet/intel/igc/igc_main.c          | 13 +++++++++++--
>   .../net/ethernet/microchip/lan966x/lan966x_tc.c    | 10 ++++++++--
>   drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  7 +++++--
>   drivers/net/ethernet/ti/am65-cpsw-qos.c            | 11 ++++++++---
>   include/net/pkt_sched.h                            |  7 ++++++-
>   net/sched/sch_taprio.c                             |  4 ++--
>   12 files changed, 71 insertions(+), 28 deletions(-)

Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>

