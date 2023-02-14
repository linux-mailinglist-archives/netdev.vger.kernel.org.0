Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B756958F1
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 07:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjBNGNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 01:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjBNGNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 01:13:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DBD1C7EF
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 22:13:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC7A6142C
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37155C433EF;
        Tue, 14 Feb 2023 06:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676355192;
        bh=+dW5Pbh3kziU3heWdJXoEX7DBTz+a5hgWrj3YMntpMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NU7G1CDY+rv1HHj86pDPFv2wBdwridASu8Fh44hu/Xhz0KbFyTIBS4H60BbvvV2FV
         EIK5lo2U3Y/Fh45seAKcEZWeDKsFyhTp4Sj2oZDpaTKQpyp7JhgRwrQP9PyghceRGL
         C//UdI7bGzkKJkTEfjm8VSdcpgcQB/Iq5XJ/ZYlIm4XKt/vEc95PN8HPJAEfsQix6p
         AmD385oKFZQ2a2xT5EKBIzeePpDf4UU8XscC3RsMZWHGWVRCHZBQW+Mt+uw1gM7VPy
         lQ/oapBlxLzD6HPquQDdr29wjR/V1nHJ7ojQBXdZZ88gFpI9hxUv1Pb3EAJGcFloyK
         mr6+p+8QkdiCQ==
Date:   Mon, 13 Feb 2023 22:13:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com, moshe@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [patch net-next v2] devlink: don't allow to change net
 namespace for FW_ACTIVATE reload action
Message-ID: <20230213221311.43d98ba8@kernel.org>
In-Reply-To: <20230213115836.3404039-1-jiri@resnulli.us>
References: <20230213115836.3404039-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Feb 2023 12:58:36 +0100 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The change on network namespace only makes sense during re-init reload
> action. For FW activation it is not applicable. So check if user passed
> an ATTR indicating network namespace change request and forbid it.
> 
> Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

The fixes tag needs to go, too, in that case. Otherwise stable will
likely suck it in. Which is riskier than putting it into an -rc.
No need to repost tho, we can drop the tag when applying.

Acked-by: Jakub Kicinski <kuba@kernel.org>
