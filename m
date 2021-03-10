Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17E8334858
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhCJTwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:52:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:49262 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233461AbhCJTwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:52:36 -0500
IronPort-SDR: H1Y/xfKNuv+gmic8PNu0tseiTIbxDeiSfmK/Pm+CygFhXDWwFEafu3g0Yr2o3MrvQnTN4a33jh
 +yYN7alfF3Ew==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="188649985"
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="188649985"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 11:52:36 -0800
IronPort-SDR: 86BZN4aqO845YyhwGwzqwZU7t/4d0A71QBDYydWd9TaM6lrnCweNxrj/ImSNPW+RLSlj8+kohk
 HXhTYk2Gwh7A==
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="448023849"
Received: from jldelgad-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.7.99])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 11:52:35 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: add a helper to avoid issues with HW TX
 timestamping and SO_TXTIME
In-Reply-To: <20210310145044.614429-1-vladimir.oltean@nxp.com>
References: <20210310145044.614429-1-vladimir.oltean@nxp.com>
Date:   Wed, 10 Mar 2021 11:52:34 -0800
Message-ID: <87k0qen5vh.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> As explained in commit 29d98f54a4fe ("net: enetc: allow hardware
> timestamping on TX queues with tc-etf enabled"), hardware TX
> timestamping requires an skb with skb->tstamp = 0. When a packet is sent
> with SO_TXTIME, the skb->skb_mstamp_ns corrupts the value of skb->tstamp,
> so the drivers need to explicitly reset skb->tstamp to zero after
> consuming the TX time.
>
> Create a helper named skb_txtime_consumed() which does just that. All
> drivers which offload TC_SETUP_QDISC_ETF should implement it, and it

nitpick: to my ears, it seems that you meant "call"/"use" instead of
"implement".

> would make it easier to assess during review whether they do the right
> thing in order to be compatible with hardware timestamping or not.
>
> Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
-- 
Vinicius
