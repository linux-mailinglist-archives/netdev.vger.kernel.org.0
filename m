Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D94217C62A
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 20:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCFTTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 14:19:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgCFTTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 14:19:22 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 017D520656;
        Fri,  6 Mar 2020 19:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583522362;
        bh=5AEkumCVq21wYUPEgUN2UKWndRwF68vU2Z4/miR0TWE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AjSCejtwdQmfnx5wwD4AedReUAFawuT45Q5LejthVrl3TQiLHy/1Etv9BdSClHmjI
         tkgRPapdJRAQdYoXkgcTaP+4758zuzWcS9XBYIdCp/fZkST3w1Dinh3i2aIHbYT8GW
         9hCIb3WX8vcwjdI61CSEkPMEZr6LMcEcE53YTTp4=
Date:   Fri, 6 Mar 2020 11:19:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po Liu <Po.Liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        roy.zang@nxp.com, mingkai.hu@nxp.com, jerry.huang@nxp.com,
        leoyang.li@nxp.com, michael.chan@broadcom.com, vishal@chelsio.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com,
        pablo@netfilter.org, moshe@mellanox.com,
        ivan.khoronzhuk@linaro.org, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, jakub.kicinski@netronome.com
Subject: Re: [RFC,net-next  3/9] net: schedule: add action gate offloading
Message-ID: <20200306111914.746d9bb3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200306110200.5fc47ad7@kicinski-fedora-PC1C0HJN>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
        <20200306125608.11717-4-Po.Liu@nxp.com>
        <20200306110200.5fc47ad7@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Mar 2020 11:02:00 -0800 Jakub Kicinski wrote:
> On Fri,  6 Mar 2020 20:56:01 +0800 Po Liu wrote:
> > +static int tcf_gate_get_entries(struct flow_action_entry *entry,
> > +				const struct tc_action *act)
> > +{
> > +	entry->gate.entries = tcf_gate_get_list(act);
> > +
> > +	if (!entry->gate.entries)
> > +		return -EINVAL;
> > +
> > +	entry->destructor = tcf_gate_entry_destructor;
> > +	entry->destructor_priv = entry->gate.entries;  
> 
> What's this destructor stuff doing? I don't it being called.

Ah, it's the action destructor, not something gate specific. Disregard.
