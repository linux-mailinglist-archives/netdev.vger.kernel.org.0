Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572995226D0
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbiEJWYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbiEJWYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:24:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F90028ED34
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 15:24:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DC41617D4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 22:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ECFC385CE;
        Tue, 10 May 2022 22:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652221472;
        bh=XEb9zA/wBgp10QcvlpbBtH9PCAPsKQ64KF96AhgjSdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lkBu1e9XzKYvXD9IpAiPmCjFGyQbdBoYY7nff3W8YiRlUGlxgXhunRSbXra9FjV3x
         JB/lTFroQuTJXAXiiNcTdXRWYJjd1tEgh0gLVdon9mhZxv168YB0ZG7hTXw/dvTw7c
         2Ko1wZ5nY+sByfPBxZaH3DSzOto++s8pwPMwz6te2adxmw2tQ3Cpz1X+UJPcqOtzh5
         Kdxulyk+bTVX2+NuIniD0klYZ4q2KJ/IjaAPDi/XmQCdpqp87ugAz3hAjdlK3TcHdF
         adDyqaslmCRI7uRGi9mk80BU8rvlQ32oUqjT5hxPiw7cuiToYLjFpC6Z613Z76dx9P
         TSbOPRlLLFj6w==
Date:   Tue, 10 May 2022 15:24:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Thompson <davthompson@nvidia.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <limings@nvidia.com>,
        <cai.huoqing@linux.dev>, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v1] mlxbf_gige: remove driver-managed interrupt
 counts
Message-ID: <20220510152431.0d7673bb@kernel.org>
In-Reply-To: <20220509152426.28800-1-davthompson@nvidia.com>
References: <20220509152426.28800-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 May 2022 11:24:26 -0400 David Thompson wrote:
> The driver currently has three interrupt counters,
> which are incremented every time each interrupt handler
> executes.  These driver-managed counters are not
> necessary as the kernel already has logic that manages
> interrupt counts and exposes them via /proc/interrupts.
> This patch removes the driver-managed counters, and thus
> removes them from "ethtool -S" output as well.

The last part of the last sentence is not true, or at
least I don't see the patch removing any ethtool -S keys.
I think we requested you removed them from ethtool -S 
during initial upstream review.
