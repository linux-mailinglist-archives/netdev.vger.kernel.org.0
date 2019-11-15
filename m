Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7BDFE104
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 16:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfKOPQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 10:16:53 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:15999 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfKOPQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 10:16:53 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAFFGgIQ023070;
        Fri, 15 Nov 2019 07:16:43 -0800
Date:   Fri, 15 Nov 2019 20:38:30 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v3 1/2] cxgb4: add TC-MATCHALL classifier egress
 offload
Message-ID: <20191115150824.GA14296@chelsio.com>
References: <cover.1573818408.git.rahul.lakkireddy@chelsio.com>
 <5b5af4a7ec3a6c9bc878046f4670a2838bbbe718.1573818408.git.rahul.lakkireddy@chelsio.com>
 <20191115135845.GC2158@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115135845.GC2158@nanopsycho>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, November 11/15/19, 2019 at 14:58:45 +0100, Jiri Pirko wrote:
> Fri, Nov 15, 2019 at 01:14:20PM CET, rahul.lakkireddy@chelsio.com wrote:
> 
> [...]
> 
> 
> >+static int cxgb4_matchall_egress_validate(struct net_device *dev,
> >+					  struct tc_cls_matchall_offload *cls)
> >+{
> >+	struct netlink_ext_ack *extack = cls->common.extack;
> >+	struct flow_action *actions = &cls->rule->action;
> >+	struct port_info *pi = netdev2pinfo(dev);
> >+	struct flow_action_entry *entry;
> >+	u64 max_link_rate;
> >+	u32 i, speed;
> >+	int ret;
> >+
> >+	if (cls->common.prio != 1) {
> >+		NL_SET_ERR_MSG_MOD(extack,
> >+				   "Egress MATCHALL offload must have prio 1");
> 
> I don't understand why you need it to be prio 1.

This is to maintain rule ordering with the kernel. Jakub has suggested
this in my earlier series [1][2]. I see similar checks in various
drivers (mlx5 and nfp), while offloading matchall with policer.

[1] http://patchwork.ozlabs.org/patch/1194936/#2304413
[2] http://patchwork.ozlabs.org/patch/1194301/#2303749

Thanks,
Rahul
