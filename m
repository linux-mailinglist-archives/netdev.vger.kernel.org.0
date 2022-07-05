Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B956567A02
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 00:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiGEWPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 18:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiGEWPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 18:15:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AC713CD0
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 15:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB5C961D2B
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 22:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E971CC341C7;
        Tue,  5 Jul 2022 22:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657059306;
        bh=18o5JdHD93TTA44EVynNs4t1YRrH6fBTlojPF+F3SMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PUgj0Erz6JFfwILFzI8p7LsvlwYVdTLKCB6wZZZvm4uZ4N+0YOXcBhT1xmIw/syFn
         tvlAXVv3G4DNF04SwsCmQ+SdUKPMrZIRtTnZb/sk4NGAvIqGJhhtY3qp4E1XnFE9Ur
         XNv112sPwbEYJ6Yx/gFnO9m3zIxk1xP3QKXUSoEFI/A0gCQbzsgbqdzi8F/zVjwFKn
         0xWJFk6Ozkrn3UZ+Jtsm5mvrYcJLFX3ZOc5jm68wN/LyOVQlEvgF/ueq0l9Zjqr3CC
         /zsIU47FtkRR/6LzUxbaMJvO4vkez3GKG6N0IN2z4jtfNZbn5VZPZ7/ibqnVnBS8yi
         SOMkYqXEnKDRQ==
Date:   Tue, 5 Jul 2022 15:15:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [RFC] ice: Reconfigure tx scheduling for SR-IOV
Message-ID: <20220705151505.7a4757ae@kernel.org>
In-Reply-To: <20220704114513.2958937-1-michal.wilczynski@intel.com>
References: <20220704114513.2958937-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Jul 2022 13:45:13 +0200 Michal Wilczynski wrote:
> If we were to follow normal flow, we would now use tc-filter family of
> commands to direct types of interesting traffic to the correct nodes.
> That is NOT the case in this implementation. In this POC, meaningful
> classid number identifies scheduling node. Number of qdisc handle is a
> queue number in a PF space. Reason for this - we want to support ALL
> queues on the card including SR-IOV ones that are assigned to VF
> netdevs.

Have you looked at the devlink rate API? It should do what you need.
Dima has been working on extending that API recently you may want to
compare notes with him as well: 

https://lore.kernel.org/all/20220620152647.2498927-1-dchumak@nvidia.com/
