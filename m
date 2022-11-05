Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8710061A6D3
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKECML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKECMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:12:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439062CE1F
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEB18B82E0D
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D34C433C1;
        Sat,  5 Nov 2022 02:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667614327;
        bh=B59FWhI7pAFYh0AOGMOsMjXqmeFQYhJNRRwcFQkS2Ic=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CDfbrdvPXsQLxhY+ChWGZzKKVnAdCuoq5YtKOAvm2x7GhmBfBBEh9cxTufU/ZYjRr
         H0y/8ONRJoCcprpyLvmRCOmUl2vku2qooU8OC5L9ntmDVZ43fqPR9Nc91sg2yrZnLg
         zY6KuJXoY2yYS88/ciaYGpCoG6NeG2k+WjQm13g5+JlFZdtf4tq3YebhjQUJW00k71
         hU1rqxBnslr3DXcljj0g5oG5HMT0po1dUOEzLaSzGhxqeFtVqsG39NK0HCnrvNCDpP
         ZvqL6i5NxRyE+S/+7u69Lwttc9jlR73+F/ax+jeKXmRcBrhilyGOCb/Bho20qauLKE
         VlR3Kn46yMviA==
Date:   Fri, 4 Nov 2022 19:12:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        ecree.xilinx@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v9 7/9] ice: Add an option to pre-allocate
 memory for ice_sched_node
Message-ID: <20221104191206.590e82c4@kernel.org>
In-Reply-To: <20221104143102.1120076-8-michal.wilczynski@intel.com>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
        <20221104143102.1120076-8-michal.wilczynski@intel.com>
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

On Fri,  4 Nov 2022 15:31:00 +0100 Michal Wilczynski wrote:
> devlink-rate API requires a priv object to be allocated when node still
> doesn't have a parent. This is problematic, because ice_sched_node can't
> be currently created without a parent.
> 
> Add an option to pre-allocate memory for ice_sched_node struct. Add
> new arguments to ice_sched_add() and ice_sched_add_elems() that allow
> for pre-allocation of memory for ice_sched_node struct.

kdoc missing here:

drivers/net/ethernet/intel/ice/ice_sched.c:154: warning: Function parameter or member 'prealloc_node' not described in 'ice_sched_add_node'
