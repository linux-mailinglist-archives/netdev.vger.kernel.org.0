Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F0A69590C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 07:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjBNGSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 01:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjBNGSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 01:18:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E91F65B6
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 22:18:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3671E6144B
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668A2C433D2;
        Tue, 14 Feb 2023 06:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676355483;
        bh=cR+SgiRV90YqtZ4+HU+9zbFFA1Es24o376BlHhFZJcU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gdqfdnHkD1xOICwtN5pYqmWf/KAizHk2whG5ne95m+wTgVq+0xOwQ0DGuQ1Lk0IG6
         sNpiJQJaAJSC4bYlANnxx3Ob0Mb/1MFnyP1c58Q3zR2xOa3blY+S0SFIoV/QYgUh8R
         zv6kWonrJ6mTwwBErBSyE7kSg9cL90erGKwAc31YJavWxlXZVgVO5cRN8k1rrxF9/Z
         tcuKbLWfolRo66t1STxAco4WOxYuDXx+h+9EBgFwyJbiwbqp5aV6V632k1BQ2LAv7+
         EY3UzoH9hroJB/BkyvHV96mqSPQgo3ztzuAsKeE9bgVaSoVxmLHVJXR38sLa4s+GkF
         ijfj2u40qwkOA==
Date:   Mon, 13 Feb 2023 22:18:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 02/10] devlink: health: Fix nla_nest_end in
 error flow
Message-ID: <20230213221802.04cb7932@kernel.org>
In-Reply-To: <1676294058-136786-3-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
        <1676294058-136786-3-git-send-email-moshe@nvidia.com>
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

On Mon, 13 Feb 2023 15:14:10 +0200 Moshe Shemesh wrote:
> devlink_nl_health_reporter_fill() error flow calls nla_nest_end(). Fix
> it to call nla_nest_cancel() instead.

If you do respin please add a sentence to say that this is harmless
because we cancel the entire message, anyway.
