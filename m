Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207A9FC777
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKNNaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:30:03 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:48650 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfKNNaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 08:30:03 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAEDTt9T014762;
        Thu, 14 Nov 2019 05:29:56 -0800
Date:   Thu, 14 Nov 2019 18:51:44 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 2/2] cxgb4: add TC-MATCHALL classifier ingress
 offload
Message-ID: <20191114132143.GB12021@chelsio.com>
References: <cover.1573656040.git.rahul.lakkireddy@chelsio.com>
 <cbbe1b8e3d4062e329bb17f8521a6fa6de543091.1573656040.git.rahul.lakkireddy@chelsio.com>
 <20191113191610.0974298f@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113191610.0974298f@cakuba>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, November 11/13/19, 2019 at 19:16:10 -0800, Jakub Kicinski wrote:
> On Wed, 13 Nov 2019 20:09:21 +0530, Rahul Lakkireddy wrote:
> > +static int cxgb4_matchall_alloc_filter(struct net_device *dev,
> > +				       struct tc_cls_matchall_offload *cls)
> > +{
> > +	struct cxgb4_tc_port_matchall *tc_port_matchall;
> > +	struct port_info *pi = netdev2pinfo(dev);
> > +	struct adapter *adap = netdev2adap(dev);
> > +	struct ch_filter_specification *fs;
> > +	int ret, fidx;
> > +
> > +	/* Since the rules with lower indices have higher priority, place
> > +	 * MATCHALL rule at the highest free index of the TCAM because
> > +	 * MATCHALL is usually not a high priority filter and is generally
> > +	 * used as a last rule, if all other rules fail.
> > +	 */
> 
> The rule ordering in HW must match the ordering in the kernel.
> 

Ok. Will maintain the same ordering as in kernel in v2.

> > +	fidx = cxgb4_get_last_free_ftid(dev);
> > +	if (fidx < 0)
> > +		return -ENOMEM;
> 

Thanks,
Rahul
