Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98ECC48E356
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239103AbiANEmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:42:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34578 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiANEmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 23:42:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACBFA618EC
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 04:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A49C36AE9;
        Fri, 14 Jan 2022 04:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642135325;
        bh=RXSsKkp0bGhtEg44a3EqmzHNPWBCi9v2X4TN859vLmU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eUkYu9zfcw72TQS3WFF73yu4McPBcC07Y8tWAfCkAc/XVI6rKz6sI6pkfZLzJociA
         6sZKOkiciXmb/NL3EmeSw8M09pKxuvFlqCZAOnj8AoNr6jCxWXsbgsVC5Ut8PDuzvz
         OvUiCCq/S0zhk+TMSIrtdZy87tG0pd/ZPG0PQ2UV3OScqx8HrA8wm3QpXW4Ip41Zoc
         a6C/1EtbBe02aY3l80z+LbDVr+c5iW1p1/9661z+vMsmRYiAYlzvzp+UY4F5zj3SPe
         g70jDar+hbeA1G+VzPRlpvrNzPXYIZkuLsMZIgBEQ3YI7r7K+oaSb8e0P8SjGUp9sv
         NMhRS2IKRJP/Q==
Date:   Thu, 13 Jan 2022 20:42:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111112418.2bbc0db4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 03:37:47 +0000 Parav Pandit wrote:
> > > The fairness among VFs is present via the QoS knobs. Hence it doesn't hogg  
> > the entire crypto path.

Could you please fix your email client? It's incorrectly wrapping the
quotes and at the same time not wrapping your replies at all. :( What
client is this? 

> > Why do you want to disable it, then?  
> Each enabled feature consumes 
> (a) driver level memory resource such as querying ip sec capabilities and more later,
> (b) time in querying those capabilities, 

These are on the VM's side, it's not hypervisors responsibility to help
the client by stripping features.

> (c) device level initialization in supporting this capability
> 
> So for light weight devices which doesn't need it we want to keep it disabled.

You need to explain this better. We are pretty far from "trust"
settings, which are about privilege and not breaking isolation.

"device level initialization" tells me nothing.

> > > It is the internal mlx5 implementation of how to do steering, triggered by  
> > netdev ndo's and other devices callback.  
> > > There are multiple options on how steering is done.
> > > Such as sw_steering or dev managed steering.
> > > There is already a control knob to choose sw vs dev steering as devlink  
> > param on the PF at [1].  
> > > This [1] device specific param is only limited to PF. For VFs, HV need to  
> > enable/disable this capability on selected VF.  
> > > API wise nothing drastic is getting added here, it's only on different object.  
> > (instead of device, it is port function).  
> > >
> > > [1]
> > > https://www.kernel.org/doc/html/v5.8/networking/device_drivers/mellano
> > > x/mlx5.html#devlink-parameters  
> > 
> > Ah, that thing. IIRC this was added for TC offloads, VFs don't own the eswitch
> > so what rules are they inserting to require "high insertion rate"? My suspicion
> > is that since it's not TC it'd be mostly for the "DR" feature you have hence my
> > comment on it not being netdev.  
> No it is limited to tc offloads.
> A VF netdev inserts flow steering rss rules on nic rx table.
> This also uses the same smfs/dmfs when a VF is capable to do so.

Given the above are you concerned about privilege or also just
resources use here? Do VFs have SMFS today?
