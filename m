Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47A26235C4
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiKIVZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKIVZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:25:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75498EE37
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 13:25:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 021B161CEF
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 21:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B08C433D6;
        Wed,  9 Nov 2022 21:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668029145;
        bh=8vdrfnSzRQ8APsihZmxhcBpGsE+zJy5HR5LARCCZF0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nLY266wNu2t6MrPpXe8hUawKnvUuUCelJq0v4TfXcTPHDo8WUZquGYawfvbyl6eu1
         lsNehQxHKFYradqQO16249P7x/Dqv3L53/yOxpA5CaxYJSn+pFZekAIqaXGqTNWmpa
         LInLDZn9JXnZSnNlbdZUNH/uQ5Q9qjHcT6NHpTrLe57/Gmu7GG1Xvsi6xsgcECt3IN
         uIn5e9pA2gIBLtTED+PpAaW4zCzKpyVgDXg1lzvNSdoiQvHMQDWHvLnlhztrQU+cI8
         tFpd359xZSV1VFhvoTYnNKiTexR4Zklszo7jpC9iADOH5wv9tgP3NSue+wSX8fP0Yu
         Q8Tu4Fa/J3G+w==
Date:   Wed, 9 Nov 2022 13:25:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next v10 10/10] ice: add documentation for
 devlink-rate implementation
Message-ID: <20221109132544.62703381@kernel.org>
In-Reply-To: <de1cb0ab-163c-02e8-86b0-fc865796a40a@intel.com>
References: <20221107181327.379007-1-michal.wilczynski@intel.com>
        <20221107181327.379007-11-michal.wilczynski@intel.com>
        <20221108143936.4e59f6e8@kernel.org>
        <de1cb0ab-163c-02e8-86b0-fc865796a40a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Nov 2022 19:54:52 +0100 Wilczynski, Michal wrote:
> On 11/8/2022 11:39 PM, Jakub Kicinski wrote:
> > On Mon,  7 Nov 2022 19:13:26 +0100 Michal Wilczynski wrote:  
> >> Add documentation to a newly added devlink-rate feature. Provide some
> >> examples on how to use the features, which netlink attributes are
> >> supported and descriptions of the attributes.
> >> +Devlink Rate
> >> +==========
> >> +
> >> +The ``ice`` driver implements devlink-rate API. It allows for offload of
> >> +the Hierarchical QoS to the hardware. It enables user to group Virtual
> >> +Functions in a tree structure and assign supported parameters: tx_share,
> >> +tx_max, tx_priority and tx_weight to each node in a tree. So effectively
> >> +user gains an ability to control how much bandwidth is allocated for each
> >> +VF group. This is later enforced by the HW.
> >> +
> >> +It is assumed that this feature is mutually exclusive with DCB and ADQ, or
> >> +any driver feature that would trigger changes in QoS, for example creation
> >> +of the new traffic class.  
> > Meaning? Will the devlink API no longer reflect reality once one of
> > the VFs enables DCB for example?  
> 
> By DCB I mean the DCB that's implemented in the FW, and I'm not aware
> of any flow that would enable the VF to tweak FW DCB on/off. Additionally
> there is a commit in this patch series that should prevent any devlink-rate
> changes if the FW DCB is enabled, and should prevent enabling FW DCB
> enablement if any changes were made with the devlink-rate.

Nice, but in case DCB or TC/ADQ gets enabled devlink rate will just
show a stale hierarchy?

We need to document clearly that the driver is supposed to prevent
multiple APIs being used, and how we decide which API takes precedence.

> I don't think there is a way to detect that the SW DCB is enabled though.
> In that case the software would try to enforce it's own settings in the SW
> stack and the HW would try to enforce devlink-rate settings.
>
> >> +        consumed by the tree Node. Rate Limit is an absolute number
> >> +        specifying a maximum amount of bytes a Node may consume during
> >> +        the course of one second. Rate limit guarantees that a link will
> >> +        not oversaturate the receiver on the remote end and also enforces
> >> +        an SLA between the subscriber and network provider.
> >> +    * - ``tx_share``  
> > Wouldn't it be more common to call this tx_min, like in the old VF API
> > and the cgroup APIs?  
> 
> I agree on this one, I'm not really sure why this attribute is called
> tx_share. In it's iproute documentation tx_share is described as:
> "specifies minimal tx rate value shared among all rate objects. If rate
> object is a part of some rate group, then this value shared with rate
> objects of this rate group.".
> So tx_min is more intuitive, but I suspect that the original author
> wanted to emphasize that this BW is shared among all the children
> nodes.

Ah :/ I missed you're not adding this one :S
