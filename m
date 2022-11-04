Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262E8618F54
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiKDD7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiKDD7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:59:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC61A1D310
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63C7BB80B19
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665F6C433D6;
        Fri,  4 Nov 2022 03:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667534387;
        bh=rwSwWaX+gLsEJDwYUtiWkMcj0d97WuzUM1DNg2yOUwI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XlpG/iEw4yU0I2D5JrhHH5VzQNHzduxQqocaxfhSpX5zhvS+N0A4sVQOHR0V9Tb48
         ZkasHvUwqNMwXCKV+eoU0Yk3Te697zOzAcKnAtGrepvjDevTrZCwt8DYPneodiBQs7
         3rttXtROSnpoKcNyDjqS0JTxOD28yth7acxLamCyC+6Ozz0vtB71Bi/K7sz8pYXFLK
         bxCypEMcZKc2CPk5qNoYd99rW3rHXgxiV2JyAUmxcdezWLcu/1D5KAOOH6dTT7iz6E
         oWcXuRIgr5fSle+bUIaQh3f/TK9tJ0V+wT0PimnHDZPqxCYOJ9xsctuyBvR4eBZ0yx
         l2f393p/IhE2A==
Date:   Thu, 3 Nov 2022 20:59:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com, bjking1@linux.ibm.com,
        ricklind@us.ibm.com, dave.taht@gmail.com
Subject: Re: [PATCH v2 net] ibmveth: Reduce maximum tx queues to 8
Message-ID: <20221103205945.40aacd90@kernel.org>
In-Reply-To: <20221102183837.157966-1-nnac123@linux.ibm.com>
References: <20221102183837.157966-1-nnac123@linux.ibm.com>
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

On Wed,  2 Nov 2022 13:38:37 -0500 Nick Child wrote:
> Previously, the maximum number of transmit queues allowed was 16. Due to
> resource concerns, limit to 8 queues instead.
> 
> Since the driver is virtualized away from the physical NIC, the purpose
> of multiple queues is purely to allow for parallel calls to the
> hypervisor. Therefore, there is no noticeable effect on performance by
> reducing queue count to 8.

I'm not sure if that's the point Dave was making but we should be
influencing the default, not the MAX. Why limit the MAX?
