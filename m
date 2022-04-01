Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD904EFA29
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350584AbiDASv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiDASv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:51:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A30835261
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:50:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 240FB6144E
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 18:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F254C340EC;
        Fri,  1 Apr 2022 18:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648839007;
        bh=qkm3lHM3EHUyZ6DyLHlg1r2sFU0k93ow4bGLaUi2Ch4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kxjYSndpGeb4qwa9swiQ2A3OZ8r1V1k1WyhlGm6yqPYeBPdvvQ9yqGuJmqunhvKfx
         b9qoHBja2ywMG/GriKpxwRJNsWDdPO0V+ZhEDwEeEx2VwynlwMSsIS4syQmECUWxTp
         Gi+uLcyyqZnLRDEEbjrJaXZij6ofoPXlxPlZLz6fQV5pDbYYmF77yIM6a6fz2ws2p3
         z+P6JXLBFBwMHQ14KWSHRIuTsrax4xt9Tn4yWAvZwyowsLvkjy4hJ/TtAc580EdzZv
         ZEDApq1t5PeTHZXrSJM/MulwmSlvGybfWF/l7XOX1M80tJbEuKZ6amiK0kEnE5A1rA
         UgJOb6lk3luQA==
Date:   Fri, 1 Apr 2022 11:50:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        oliver.sang@intel.com
Subject: Re: [PATCH net] xfrm: Pass flowi_oif or l3mdev as oif to
 xfrm_dst_lookup
Message-ID: <20220401115005.0c104b01@kernel.org>
In-Reply-To: <20220401015334.40252-1-dsahern@kernel.org>
References: <20220401015334.40252-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 19:53:34 -0600 David Ahern wrote:
> To: netdev@vger.kernel.org,  kuba@kernel.org,  davem@davemloft.net,  pabeni@redhat.com
> Cc: oliver.sang@intel.com,  David Ahern <dsahern@kernel.org>
> Subject: [PATCH net] xfrm: Pass flowi_oif or l3mdev as oif to xfrm_dst_lookup

This needs Steffen and Herbert on CC. I'd just CC them in but
patch was marked as Awaiting upstream in our PW already, so
repost would be better. Regardless which tree it ends up getting
applied to.

> The commit referenced in the Fixes tag no longer changes the
> flow oif to the l3mdev ifindex. A xfrm use case was expecting
> the flowi_oif to be the VRF if relevant and the change broke
> that test. Update xfrm_bundle_create to pass oif if set and any
> potential flowi_l3mdev if oif is not set.
> 
> Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>
