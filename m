Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C07F61691C
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiKBQdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiKBQcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:32:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887F2193F5;
        Wed,  2 Nov 2022 09:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D7E8B823C2;
        Wed,  2 Nov 2022 16:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B85C433C1;
        Wed,  2 Nov 2022 16:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667406526;
        bh=e2aDpYBoje0gQtLOnWkURg+egkBJ5OTswl+2K8lsdgQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HiO4JfxxuAAPpmTP9FkhZY/y/ZPr6WR14zvPcvt9l5HxEIlqkef4h/il4382Af42F
         +Am4J1T7PMSRvsnHe9yAtW6tCF7ELP8cQ/hkJsUNRw8tpBKp0FCqtqBlPQ+fi81ypV
         ohIoSzGuenHncGbz/UaUUzIiyWsfLK318FeLgAzfIZ5ybp90IMUE3ab86P/srtvuEG
         7VkuWNOXC7NXmQDX+PBZYowl/uSMop3ipMPVo4cgHWIAaWQQJ858r+yiZ5rmdwLNHD
         3lc7iUja3NLF/YAi9LCwN1BU+WJUDExgVnFiqf3QnP+CX44l9jcMyzfOCpifkh0JFK
         HUYQ+kVnap2tA==
Date:   Wed, 2 Nov 2022 09:28:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 13/13] net: expose devlink port over
 rtnetlink
Message-ID: <20221102092845.5e4f5ba0@kernel.org>
In-Reply-To: <Y2KT4A6ZGVfcbsfx@nanopsycho>
References: <20221031124248.484405-1-jiri@resnulli.us>
        <20221031124248.484405-14-jiri@resnulli.us>
        <20221101091834.4dbdcbc1@kernel.org>
        <Y2JS4bBhPB1qbDi9@nanopsycho>
        <20221102081006.70a81e89@kernel.org>
        <20221102081325.2086edd8@kernel.org>
        <Y2KOnKs0fsDNihaW@nanopsycho>
        <20221102085249.3b64e29f@kernel.org>
        <Y2KT4A6ZGVfcbsfx@nanopsycho>
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

On Wed, 2 Nov 2022 16:59:28 +0100 Jiri Pirko wrote:
> Wed, Nov 02, 2022 at 04:52:49PM CET, kuba@kernel.org wrote:
> >On Wed, 2 Nov 2022 16:37:00 +0100 Jiri Pirko wrote:  
> >> Or, even better, move RTnetlink to generic netlink. Really, there is no
> >> point to have it as non-generic netlink forever. We moved ethtool there,
> >> why not RTnetlink?  
> >
> >As a rewrite?  We could plug in the same callbacks into a genl family
> >but the replies / notifications would have different headers depending
> >on the socket type which gets hairy, no?  
> 
> I mean like ethtool, completely side iface, independent, new attrs etc.
> We can start with NetdevNetlink for example. Just cover netdev part of
> RTNetlink. That is probably most interesting anyway.

That came up in conversations about the YAML specs. Major effort but
may be worth doing.
