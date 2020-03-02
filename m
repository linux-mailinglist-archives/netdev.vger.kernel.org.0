Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A846175FA1
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgCBQ3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:29:47 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:36072 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgCBQ3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:29:47 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 457F794007C;
        Mon,  2 Mar 2020 16:29:45 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 2 Mar 2020
 16:29:36 +0000
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <mlxsw@mellanox.com>,
        <netfilter-devel@vger.kernel.org>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-2-jiri@resnulli.us>
 <20200229192947.oaclokcpn4fjbhzr@salvia> <20200301084443.GQ26061@nanopsycho>
 <20200302132016.trhysqfkojgx2snt@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
Date:   Mon, 2 Mar 2020 16:29:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200302132016.trhysqfkojgx2snt@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25264.003
X-TM-AS-Result: No-3.849000-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E8bF9xF7zzuNfZvT2zYoYOwC/ExpXrHizzX1cRD6e4P5NSL
        ORr4Zhm8IHihTRCBJ1ltewhzqv9YS6hUBSBrsWXxtvnlOJ61K3r2X2nyY2WSCcu+4EUKZ3vm0S+
        TvGOUgqL2LbpCmFcD5pu+5Nb0pnThretZkLOvTssZSUX8zcPGn9eh/5dF8Efbf2dEskHXJhD5gc
        6akIiNTQXtme8N0/6lwwA6ev2FLZJsMVyAAdvrLeIfK/Jd5eHmHkWa9nMURC5ye2s5ZlPBl6PFj
        JEFr+olA6QGdvwfwZYNXwNUB3oA790H8LFZNFG7CKFCmhdu5cWNjrwpdeJBI6sg5bWIRniU5aaL
        pIF9qa6LLHa9LQCI6JJH5x2hrN5mHovwctn5rtfHn14A3I06W09UWTcHpEqnXwLU7HsLL72igEH
        y7J4S6ylkreA5r24aYnCi5itk3iprD5+Qup1qU56oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.849000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25264.003
X-MDID: 1583166586-hcP_vLkroZbg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/03/2020 13:20, Pablo Neira Ayuso wrote:
> 2) explicit counter action, in this case the user specifies explicitly
>    that it needs a counter in a given position of the rule. This
>    counter might come before or after the actual action.
But the existing API can already do this, with a gact pipe.  Plus, Jiri's
 new API will allow specifying a counter on any action (rather than only,
 implicitly, those which have .stats_update()) should that prove to be
 necessary.

I really think the 'explicit counter action' is a solution in search of a
 problem, let's not add random orthogonality violations.  (Equally if the
 counter action had been there first, I'd be against adding counters to
 the other actions.)

-ed
