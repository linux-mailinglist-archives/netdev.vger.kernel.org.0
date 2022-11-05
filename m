Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0699761A6CD
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiKECH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKECH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0252A943
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:07:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 543FA6239D
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57120C433D6;
        Sat,  5 Nov 2022 02:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667614045;
        bh=bxU/5+fm1+6yUsEPXrsuPQ6W5BUPMZC5zS1tQVwGjU0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dq2nSdZa3LvZJsw+2zRBJdHgO4ri4JTVTLogxM1P1qxQFZ6nnLV1FmyksvgtOkfTT
         uMUR7KlIQUicAtgogT1bT/YJykDglkRIrzRzCNE0U84XdGIoUDGCpWYJ+QMLTJXAAR
         f40sKOBQ5IgzWH1Tyatxnz+MNbHXImMLMMyq7Yv2VkV0x9l2hh8qkAw6pwsdfPT5lL
         Nyq3d8rR4PNxn43+GnB0NI5dYaVaqtCKChFCxLLSBZjaW2Efvw1J7Gtndr83KMMUtE
         BtaVktXwugEBlA9H0ZMF5UV0wNub/siOEEV53Sti761FtZNAFkC4sLmMyszmmUqEm7
         AI2xzfUX4Wrfw==
Date:   Fri, 4 Nov 2022 19:07:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        ecree.xilinx@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v9 1/9] devlink: Introduce new attribute
 'tx_priority' to devlink-rate
Message-ID: <20221104190724.59e614dd@kernel.org>
In-Reply-To: <20221104143102.1120076-2-michal.wilczynski@intel.com>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
        <20221104143102.1120076-2-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Nov 2022 15:30:54 +0100 Michal Wilczynski wrote:
> +	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u16 */

All netlink attributes are padded out to 4 bytes, please make this u32,
you shouldn't use smaller values at netlink level unless it's carrying
protocol fields with fixed width.

> +	int (*rate_leaf_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
> +					 u64 tx_priority, struct netlink_ext_ack *extack);

And why make the driver API u64?
