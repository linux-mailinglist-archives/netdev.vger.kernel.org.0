Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6D46108B9
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 05:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiJ1D25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 23:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbiJ1D2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 23:28:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C29B7F57
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 20:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 752AA624E6
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82036C433C1;
        Fri, 28 Oct 2022 03:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666927733;
        bh=f9GMMqLcObvTXOVFkNHlPRhLjJgaghJ7MQ8DjpcVouA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p0QogyzhIwTBVZjfDuezVN0RH/3XPaEH3xLSV326jtIZij/kNUF1AJ2DxWEw0s7k9
         LAj9+41YLY3EUgMZPtW9oo++l2LQhpucnlLnbqLNJFnZoJXL13Wy6171QPPtuJ/xc2
         2b1vjf8WP4RRbItrE39BnAwa7ry9TdEb7VrSkW8zrt35yFl1h0MFG4flZSnp71t/5Y
         zG9p5feRPoupLAlcxRpItKP26qAqQPT0rlU0CwrbX4nHiIsTVbyVl2Nkmfw9zfWSHF
         afMxPsBYRv2eJM1j2/GwtEvvSzmLh6Bo7TbKMOyIE2yyvtoIeTt6WUlBP8Os+WZyZU
         Cgdt2bYsIFBdw==
Date:   Thu, 27 Oct 2022 20:28:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        ecree.xilinx@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v7 9/9] ice: Prevent ADQ, DCB, RDMA coexistence
 with Custom Tx scheduler
Message-ID: <20221027202852.5be21498@kernel.org>
In-Reply-To: <20221027130049.2418531-10-michal.wilczynski@intel.com>
References: <20221027130049.2418531-1-michal.wilczynski@intel.com>
        <20221027130049.2418531-10-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 15:00:49 +0200 Michal Wilczynski wrote:
> ADQ, DCB, RDMA might interfere with Custom Tx Scheduler changes that user
> might introduce using devlink-rate API.
> 
> Check if ADQ, DCB, RDMA is active, when user tries to change any setting
> in exported Tx scheduler tree. If any of those are active block the user
> from doing so, and log an appropriate message.

drivers/net/ethernet/intel/ice/ice_devlink.c:727: warning: Excess function parameter 'extack' description in 'ice_enable_custom_tx'
