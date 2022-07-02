Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D89563DE1
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiGBDK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGBDKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C7B377D4
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 20:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1EE5617F7
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 03:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97E0C341C6;
        Sat,  2 Jul 2022 03:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656731423;
        bh=s2/N4ZWF6pu7n9mPMu7xQm9+D9NKqKpYGZ0fI1cogdI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QChWQIc+fxOa2cF659aBhaAUmq7nHUNjL5i08Am/Y5IVqLT3LRN0pAEv0V7ikrrnG
         W/rdiiDuDERvaBDRAqnViJxfqnS8Odtz82KePnwSMUT00jtZkzKu71PJGHllw1nTHB
         H8d/Fpw60LAzjsJF49GuK4Ls6OFLro+s3VO4pt78jqhULjZoSdtETJyVywoSm9Ge2q
         /GCyNybkSk8bieV7Ky6HeuRnDEyh8I+PXG6NJ5axNfzZuUZn3Ej2ntJrN0F9br0pvW
         rKq97f6e1rE6cWVVxTIPCB+Lly7dAOIN5KE5Af8ghggdW/G6VoB0G33R35mpSMDnrH
         zC+I3XNoS6g8Q==
Date:   Fri, 1 Jul 2022 20:10:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next v2 2/3] net: devlink: call
 lockdep_assert_held() for devlink->lock directly
Message-ID: <20220701201021.400a5a83@kernel.org>
In-Reply-To: <20220701164007.1243684-3-jiri@resnulli.us>
References: <20220701164007.1243684-1-jiri@resnulli.us>
        <20220701164007.1243684-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Jul 2022 18:40:06 +0200 Jiri Pirko wrote:
> In devlink.c there is direct access to whole struct devlink so there is
> no need to use helper. So obey the customs and work with lock directly
> avoiding helpers which might obfuscate things a bit.

I think you sent this as / before I replied to all the patches.
Still not sure what the basis for the custom is.
