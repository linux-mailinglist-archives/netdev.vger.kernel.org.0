Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B8C5B9030
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 23:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiINVrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 17:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiINVrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 17:47:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B6E81695;
        Wed, 14 Sep 2022 14:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663192029; x=1694728029;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=cbnXqtf2TMDhDBxTiSWRd+F7VowQpmqU+RCKBnbHXtk=;
  b=FXoTuvP1cr9qwBNJx8u5qjAXvrV+lZjFWEWNJoRWOCO/nyHuez+cB9NH
   xXQHLk4SckczThTWuSpLUgk5013fgoqr+u2N0KBfRuFIl2CT+KfrWi9vh
   Nl++MEPA48x7QyC1kf3V1N10M545v94k7zNTn4KBvhUfRw4Ge7c0nlaNF
   mvkaPr00IvXi0hed+9331kaFpGcoULh7LL+zJJCXHNWLHOiClyb5vK8wH
   goxHX0noXA1YYI9rg2EHtm4RZAs++dcGTykUGKTFKcPdVnfXz5MXwRjSo
   mau+NU9bxO7Uj+RGpkF++xqXs3QjcAO281MA/GC2MGrP7WncmC8APhESD
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="384842037"
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="384842037"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 14:47:08 -0700
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="568172315"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 14:47:08 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
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
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/13] Add tc-taprio support for queueMaxSDU
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Date:   Wed, 14 Sep 2022 14:47:08 -0700
Message-ID: <87edwdiq77.fsf@intel.com>
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

> Michael and Xiaoliang will probably be aware that the tc-taprio offload
> mode supported by the Felix DSA driver has limitations surrounding its
> guard bands.
>
> The initial discussion was at:
> https://lore.kernel.org/netdev/c7618025da6723418c56a54fe4683bd7@walle.cc/
>
> with the latest status being that we now have a vsc9959_tas_guard_bands_update()
> method which makes a best-guess attempt at how much useful space to
> reserve for packet scheduling in a taprio interval, and how much to
> reserve for guard bands.
>
> IEEE 802.1Q actually does offer a tunable variable (queueMaxSDU) which
> can determine the max MTU supported per traffic class. In turn we can
> determine the size we need for the guard bands, depending on the
> queueMaxSDU. This way we can make the guard band of small taprio
> intervals smaller than one full MTU worth of transmission time, if we
> know that said traffic class will transport only smaller packets.
>
> Allow input of queueMaxSDU through netlink into tc-taprio, offload it to
> the hardware I have access to (LS1028A), and deny non-default values to
> everyone else.
>
> First 3 patches are some cleanups I made while figuring out what exactly
> gets called for taprio software mode, and what gets called for offload
> mode.
>
> Vladimir Oltean (13):
>   net/sched: taprio: remove redundant FULL_OFFLOAD_IS_ENABLED check in
>     taprio_enqueue
>   net/sched: taprio: stop going through private ops for dequeue and peek
>   net/sched: taprio: add extack messages in taprio_init

Indeed. I think the first three patches can be in a separate series.

>   net/sched: taprio: allow user input of per-tc max SDU
>   net: dsa: felix: offload per-tc max SDU from tc-taprio
>   net: enetc: cache accesses to &priv->si->hw
>   net: enetc: offload per-tc max SDU from tc-taprio
>   net: dsa: hellcreek: deny tc-taprio changes to per-tc max SDU
>   net: dsa: sja1105: deny tc-taprio changes to per-tc max SDU
>   tsnep: deny tc-taprio changes to per-tc max SDU
>   igc: deny tc-taprio changes to per-tc max SDU
>   net: stmmac: deny tc-taprio changes to per-tc max SDU
>   net: am65-cpsw: deny tc-taprio changes to per-tc max SDU
>
>  drivers/net/dsa/hirschmann/hellcreek.c        |   5 +
>  drivers/net/dsa/ocelot/felix_vsc9959.c        |  20 +-
>  drivers/net/dsa/sja1105/sja1105_tas.c         |   6 +-
>  drivers/net/ethernet/engleder/tsnep_tc.c      |   6 +-
>  drivers/net/ethernet/freescale/enetc/enetc.c  |  28 ++-
>  drivers/net/ethernet/freescale/enetc/enetc.h  |  12 +-
>  .../net/ethernet/freescale/enetc/enetc_pf.c   |  25 ++-
>  .../net/ethernet/freescale/enetc/enetc_qos.c  |  70 +++----
>  drivers/net/ethernet/intel/igc/igc_main.c     |   6 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |   6 +-
>  drivers/net/ethernet/ti/am65-cpsw-qos.c       |   6 +-
>  include/net/pkt_sched.h                       |   1 +
>  include/uapi/linux/pkt_sched.h                |  11 +
>  net/sched/sch_taprio.c                        | 194 +++++++++++++-----
>  14 files changed, 283 insertions(+), 113 deletions(-)
>
> -- 
> 2.34.1
>


Cheers,
-- 
Vinicius
