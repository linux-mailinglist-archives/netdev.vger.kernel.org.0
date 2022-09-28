Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B504E5EE352
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 19:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbiI1Rj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 13:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234532AbiI1Rj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 13:39:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9719D2CDE6
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 10:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50524B8216E
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 17:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FBBC433D6;
        Wed, 28 Sep 2022 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664386793;
        bh=t/upsREZPqfeoDCWX/xxBeA+dDYBUpAA/p+jJbjfzAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JevkrReNeyxpc/iuv2YTFmdnNZEfQp6fDLGEH+7iwCnNAFt2bYQ5JWzWZTJyXFjbq
         Z2UUWIPsPFvNALsyZCUfVuk6xtP4azv2BDIRwkaMo9jIg09UKqk3tnDgLePfM86vNn
         5nL0gfoBPFVMrXqSSSTt92JL9cTKrUU0TReKdVoIT9s1zUUOQFWJBKMrsfy4EaKfbE
         T958dJnSIUH78p0+f5XeFwr4gAuZHeiUwohf9JZpE8lppD8qIcEwytQrH1ddLs9gNS
         t4tIZ9Td5mEwSbL8vlSD6kHMJsMpVsIVUH5bPe5wb38LbOuAcCtadb1jEIm2MPvFA5
         M1yBr9mLScebQ==
Date:   Wed, 28 Sep 2022 10:39:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <20220928103951.45fc326d@kernel.org>
In-Reply-To: <0ae7b664-e84a-218a-8276-a94a78f6c510@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
        <20220915134239.1935604-3-michal.wilczynski@intel.com>
        <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
        <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
        <20220921163354.47ca3c64@kernel.org>
        <477ea14d-118a-759f-e847-3ba93ae96ea8@intel.com>
        <20220922055040.7c869e9c@kernel.org>
        <9656fcda-0d63-06dc-0803-bc5f90ee44fd@intel.com>
        <20220922132945.7b449d9b@kernel.org>
        <732253d6-69a4-e7ab-99a2-f310c0f22b12@intel.com>
        <20220923061640.595db7ef@kernel.org>
        <7003673d-3267-60d0-9340-b08e73f481fd@intel.com>
        <20220926171623.3778dc74@kernel.org>
        <0ae7b664-e84a-218a-8276-a94a78f6c510@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 14:02:57 +0200 Wilczynski, Michal wrote:
> > AFAIU you only want to cater to simple cases where the VF and PF
> > are in the same control domain, which is not normal, outside of
> > running DPDK apps. Sooner or later someone will ask for queuing
> > control from the VFs and you're have to redesign the whole thing.  
> 
> Hmm, so I guess the queue part of this patch is not well liked.
> I wonder if I should re-send this patch with just the implementation
> of devlink-rate, and minor changes in devlink, like exposing functions,
> so the driver can export initial configurations. This still brings some 
> value,
> cause the user would still be able to modify at least the upper part of the
> tree.

Sounds good to me. I don't think we ever had a general discussion
about what should the driver do in terms of exposing the initial
configuration. I can't think of a reason why we wouldn't do that
so please repost and let's see what others think!

> We can still discuss how the final solution should look like, but i'm 
> out of ideas when it comes for a inside VF interface, (like we
> discussed tc-htb in current form doesn't really work for us).
