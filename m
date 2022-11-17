Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8D062D91B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiKQLMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239750AbiKQLLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 06:11:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64F871F30
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 03:10:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C7F060EE0
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 11:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2897CC433D6;
        Thu, 17 Nov 2022 11:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668683425;
        bh=sFl8gwPHKmmKt7v6HfqEjZgzIPvqq1JWX+sIwq4LB+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRzkSIJGEGiFKneiOm8nK6P4gjt5wHivnq712Yu1ympwkWMhPGFyTrx5WPVCry+rG
         Q4sj4T5VwJsMMCjSPmvTtssP59c9UpYd96PN1VCtqtuQER2hCfvUIYtoeQnnNd5LwT
         g5hwYtpRtRQ9Hn6TMhs2bHnKNnWiwQklat3cYoZ4jlzeQakSDRNw6FcJ6qhPptgzWw
         blXJa4bfCE1cC2wK+kKyPyHlIBBqyEJbsHTWl6U50QTD1LtuqLYrbn6yTkg9hkxU8m
         EI5B2lgANTm36wB6k6z7mMU9wDxbGZ+IVH1u2fewV3bTYk6n3RfnZwb1Gr4bUM/8hp
         um4YZNGNJtNaA==
Date:   Thu, 17 Nov 2022 13:10:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next v4 0/2] Handle alternate miss-completions
Message-ID: <Y3YWnS1ZEY8ocXCQ@unreal>
References: <20221116181725.2207544-1-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116181725.2207544-1-jeroendb@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 10:17:23AM -0800, Jeroen de Borst wrote:
> Some versions of the virtual NIC present miss-completions in
> an alternative way. Let the diver handle these alternate completions
> and announce this capability to the device.
> 
> The capability is announced uing a new AdminQ command that sends
> driver information to the device. The device can refuse a driver
> if it is lacking support for a capability, or it can adopt it's
> behavior to work around it.
> 
> Changed in v4:
> - Clarified new AdminQ command in cover letter
> - Changed EOPNOTSUPP to ENOTSUPP to match device's response

If you rely on the error code, please use the correct one and
fix the driver to use EOPNOTSUPP and not ENOTSUPP.

Thanks
