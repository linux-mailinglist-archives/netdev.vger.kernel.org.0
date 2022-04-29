Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCBD51406E
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351430AbiD2CBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 22:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbiD2CBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 22:01:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9945BF52E
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 18:57:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 23330CE3004
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 01:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257BFC385A9;
        Fri, 29 Apr 2022 01:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651197461;
        bh=WSmbvOxe4jQ8U1WdkVnlhgKmq71A1kfaMtyXnIM0u3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C0dc2DLz9+jvx9efmqCfWrfwTIHOURUKeox+Tgyajb8oQ+wy2X2CtJfMTi0YrBB8u
         cClgPBC64SmNftM7gsnLqCzx30ym1/ncXGszIfc4sr82tAgZaNDuTNxbw59+b6DlIP
         RSpCcgKENthkBl+TdPqFz8NCkJKjJsFWBWd9Ns27b3w9zr1lKP1HtRAVV62YcoWowN
         7DPObo5cAo5qMlQ7Os5T2guWDP510N+BIyncd+I5xQ7ZKI+XT+2/T0Lzx1WqsOgZmf
         T7eOUGZIevD+hJwYH6oKR+67KQl+koOZzHovw1GfF4fve4bbzeEFHP0usirZtxnSWe
         jJ/GhO6CleGEA==
Date:   Thu, 28 Apr 2022 18:57:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 0/6] mptcp: Path manager mode selection
Message-ID: <20220428185739.39cdbb33@kernel.org>
In-Reply-To: <20220427225002.231996-1-mathew.j.martineau@linux.intel.com>
References: <20220427225002.231996-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 15:49:56 -0700 Mat Martineau wrote:
> MPTCP already has an in-kernel path manager (PM) to add and remove TCP
> subflows associated with a given MPTCP connection. This in-kernel PM has
> been designed to handle typical server-side use cases, but is not very
> flexible or configurable for client devices that may have more
> complicated policies to implement.
> 
> This patch series from the MPTCP tree is the first step toward adding a
> generic-netlink-based API for MPTCP path management, which a privileged
> userspace daemon will be able to use to control subflow
> establishment. These patches add a per-namespace sysctl to select the
> default PM type (in-kernel or userspace) for new MPTCP sockets. New
> self-tests confirm expected behavior when userspace PM is selected but
> there is no daemon available to handle existing MPTCP PM events.
> 
> Subsequent patch series (already staged in the MPTCP tree) will add the
> generic netlink path management API.

Could you link to those patches, maybe? Feels a little strange to add
this sysctl to switch to user space mode now, before we had a chance
to judg^W review the netlink interface.

Does the pm_type switch not fit more neatly into the netlink interface
itself?
