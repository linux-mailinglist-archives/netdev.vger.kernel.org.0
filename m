Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D26175B7A
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 14:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCBNXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 08:23:46 -0500
Received: from correo.us.es ([193.147.175.20]:45730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbgCBNXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 08:23:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 45D6B118465
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 14:23:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3913AFB378
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 14:23:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 373E87843C; Mon,  2 Mar 2020 14:23:32 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26F38DA788;
        Mon,  2 Mar 2020 14:23:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Mar 2020 14:23:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DA43F42EF9E1;
        Mon,  2 Mar 2020 14:23:29 +0100 (CET)
Date:   Mon, 2 Mar 2020 14:23:42 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 08/12] flow_offload: introduce "immediate" HW
 stats type and allow it in mlxsw
Message-ID: <20200302132338.inwkbnkbytjsrikw@salvia>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-9-jiri@resnulli.us>
 <20200229193217.ejk3gbwhjcnxlk3c@salvia>
 <20200301084716.GR26061@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301084716.GR26061@nanopsycho>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 01, 2020 at 09:47:16AM +0100, Jiri Pirko wrote:
> Sat, Feb 29, 2020 at 08:32:18PM CET, pablo@netfilter.org wrote:
> >On Fri, Feb 28, 2020 at 06:25:01PM +0100, Jiri Pirko wrote:
> >[...]
> >> @@ -31,7 +31,8 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
> >>  
> >>  	act = flow_action_first_entry_get(flow_action);
> >>  	switch (act->hw_stats_type) {
> >> -	case FLOW_ACTION_HW_STATS_TYPE_ANY:
> >> +	case FLOW_ACTION_HW_STATS_TYPE_ANY: /* fall-through */
> >> +	case FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE:
> >
> >This TYPE_ANY mean that driver picks the counter type for you?
> 
> Driver pick any counter, yes.
> 
> >Otherwise, users will not have a way to know how to interpret what
> >kind of counter this is.
> 
> User does not care in this case.

OK.

When listing back the counters, will the user get what counter type
the driver has selected?
