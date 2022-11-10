Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5956247D9
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbiKJRDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiKJRDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:03:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E0E1209C
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:03:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60B0D61CDA
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 17:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4C9C433C1;
        Thu, 10 Nov 2022 17:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668099798;
        bh=azCdCaDVcuB5G80SZ2/sIEvuUOkIls0/xTmjBlBMhjo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WDsZuvlHAE1XfdM6mTi1Cr2H0jht0bpNQKDGh8U1j8elpdTTP4xAhEMIB8gKOWNx8
         LkuLzoEwKDGmws5vdXfOnKC0J1tuf3Kg2YFuUhH78MSBphvqRFEOvCFOrF3ZMhetd5
         srz15zhBHDIjsIKL7DBnXIx23/+Rs1jXYOAMa+AADQeF/2+PWM26w8/oRi4h3o5nD7
         IM5uhWqQD/pppm6l0lqazRkXUo3Dl7RozkftugMGZiKe/JwGbHl1BApDjFPDj29qbP
         5FFmrXs3FtGqszMbxcudE82YFhJxEQnbgGzrSu0AWZ/cpg/As2RBnuvpZN4lO+6wJp
         ShuFwrgvUU1Xw==
Date:   Thu, 10 Nov 2022 09:03:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next v10 10/10] ice: add documentation for
 devlink-rate implementation
Message-ID: <20221110090317.3b5a587c@kernel.org>
In-Reply-To: <717a9748-78a6-3d87-0b5a-539101333f57@intel.com>
References: <20221107181327.379007-1-michal.wilczynski@intel.com>
        <20221107181327.379007-11-michal.wilczynski@intel.com>
        <20221108143936.4e59f6e8@kernel.org>
        <de1cb0ab-163c-02e8-86b0-fc865796a40a@intel.com>
        <20221109132544.62703381@kernel.org>
        <717a9748-78a6-3d87-0b5a-539101333f57@intel.com>
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

On Thu, 10 Nov 2022 17:54:03 +0100 Wilczynski, Michal wrote:
> > Nice, but in case DCB or TC/ADQ gets enabled devlink rate will just
> > show a stale hierarchy?  
> 
> Yes there will be hierarchy exported during the VF creation, so if
> the user enable DCB/ADQ in the meantime, it will be a stale hierarchy.
> User won't be able to modify any nodes/parameters.

Why not tear it down if it's stale?
