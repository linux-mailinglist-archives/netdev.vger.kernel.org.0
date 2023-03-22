Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EB36C53FD
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjCVSqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbjCVSqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:46:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F27664E8
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 689F5B81DA9
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8C4C433EF;
        Wed, 22 Mar 2023 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679510757;
        bh=gk+zskFzwXHH/BqUSUxeVZC9D826Tkta9egwOd30iWw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BTZNQyFWEQ1st5VL5Njq5p+F1vfnE+9zYwe1lfQ2MyMCDXVPJHaDFGHzaiWH5TKuU
         cKGoqjn4gDbKGhA0Y3QpFSdFdBypGsQN3fGgqVKO12jUs528U5x6jnsVY40YE99VtQ
         JRy77sPrz1NKAqQtaz+B4V+X7mohs7hISVAL/szUFlWAIXPSF4rU6rCMgZKH3HExOC
         01K6KsSHMrSiVM94W7I1gITMZH5JJJoW8kI4YPVD9KsVTgMLs2iwjo0GNMlMVFPAEW
         2CKmhluL9luk40Op8P69ti+w21PBX+tk/ZHL+n8b4rwPy2653qTik8TosON38rxoFG
         5hAWfq3mQNjLg==
Date:   Wed, 22 Mar 2023 11:45:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next 03/14] lib: cpu_rmap: Add irq_cpu_rmap_remove to
 complement irq_cpu_rmap_add
Message-ID: <20230322114556.7cc6536c@kernel.org>
In-Reply-To: <87aa5292-d59b-9789-1326-91805da34831@nvidia.com>
References: <20230320175144.153187-1-saeed@kernel.org>
        <20230320175144.153187-4-saeed@kernel.org>
        <20230321204631.0f8bc64e@kernel.org>
        <87aa5292-d59b-9789-1326-91805da34831@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 13:24:33 +0200 Eli Cohen wrote:
> On 22/03/2023 5:46, Jakub Kicinski wrote:
> > On Mon, 20 Mar 2023 10:51:33 -0700 Saeed Mahameed wrote:  
> >> From: Eli Cohen <elic@nvidia.com>
> >>
> >> Add a function to complement irq_cpu_rmap_add(). It removes the irq from
> >> the reverse mapping by setting the notifier to NULL.  
> > Poor commit message. You should mention that glue is released and
> > cleared via the kref.  
> 
> Why is it necessary to mention glue which is internal to the 
> implementation and is not part of the API?

So that the reviewer of the code knows and knows that you know.

> > BTW who can hold the kref? What are the chances that user will call:  
> 
> The glue kref is used to ensure the glue is not remove when the callback 
> is called in the workqueue context.
> 
> Re chances, not really high since a driver usually deals with rmap at 
> load and unload time.

Mention it in the commit message please, to make sure Thomas is aware
when he acks.

