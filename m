Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7242F4D599B
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244581AbiCKEez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239849AbiCKEey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:34:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AD8C1155
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:33:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47786B82A6B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 04:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0DBC340EC;
        Fri, 11 Mar 2022 04:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646973229;
        bh=adYUrzoLd+kGQlkVsnOpALo6evLJv275H9NeQOjCk9Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jItryHm6aTLOU4vfWA1ohc+hwLyYS7NSuDRxJtGya1RpcvYjq2ZG5F3RaLJqdMJze
         7EFd4RsgGVFlxEm1E/PqYhXt/lEfRk/Hj5uY9lFJznnS7iiov2PpEQzH29q05x2wVS
         xt8HbeycVtTPAbyLsbfMjkuSfybCMXz8rqySDU0ZzFy/d4J5ZS4534BIVYDE56e6nH
         yjTug4qTYd4mir/RUnSPz+05ZT6nOkv120nFNNzxMPrdrJ33K1BJYmWeYVUFNq7MhG
         UuWacw7oQ/E0r3/UEXRywvVzfz2AWUKBIMdJHNfZTroFUFTZDYJHiQN4MgyrhCqugE
         L4A0CAsi7aG1w==
Date:   Thu, 10 Mar 2022 20:33:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        netdev@vger.kernel.org, sudheer.mogilappagari@intel.com,
        amritha.nambiar@intel.com, jiri@nvidia.com, leonro@nvidia.com,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net-next 1/2] devlink: Allow parameter
 registration/unregistration during runtime
Message-ID: <20220310203348.40663525@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310231235.2721368-2-anthony.l.nguyen@intel.com>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
        <20220310231235.2721368-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 15:12:34 -0800 Tony Nguyen wrote:
> From: Sridhar Samudrala <sridhar.samudrala@intel.com>
> 
> commit 7a690ad499e7 ("devlink: Clean not-executed param notifications")
> added ASSERTs and removed notifications when devlink parameters are
> registered by the drivers after the associated devlink instance is
> already registered.
> The next patch in this series adds a feature in 'ice' driver that is
> only enabled when ADQ queue groups are created and introduces a
> devlink parameter to configure this feature per queue group.
> 
> To allow dynamic parameter registration/unregistration during runtime,
> revert the changes added by the above commit.

I'm pretty sure what you're doing is broken. You should probably wait
until my patches to allow explicit devlink locking are merged and build
on top of that.
