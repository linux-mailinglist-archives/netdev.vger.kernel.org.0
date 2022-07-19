Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A1C57915C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbiGSDdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiGSDdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:33:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247DE13F6D;
        Mon, 18 Jul 2022 20:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9F90B81894;
        Tue, 19 Jul 2022 03:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEDDC341C0;
        Tue, 19 Jul 2022 03:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658201627;
        bh=/7TAXj0e5Cww1oAU9qPhHCO940YEfSAdOc9AORI/EVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eKaR0lIY3nS8TDk7krLluEaovKotSfwXv7GLD6SEQebV5ZhSGLPypnD5lzCYfp5q2
         r+3kPG+yZWZJ4rXOzOocNZ7jin+YAbTgAGu6+rXFmhOSLUuDYyAYGSENUFgEzCDD9V
         h6tkS+zAtfoXysr671Knh8ZrpIr2GpIlvJoZfjTV+jb9bOI1XutyDuqNL2SDEuRdO3
         tmn6BGZOFu0t2OBZjDwgZ2K+iZ5pu5t5iGEVlyEaIBvb1czP/u3PCtnOKHKSn7oNBj
         fO0jkCSuA9ChaRmpiU/tIt85qprnr8dPB8GEATc10dEeKOdKsaNWx5w999pMbHavnA
         Dwxb1gm5cw7dA==
Date:   Mon, 18 Jul 2022 20:33:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v3 1/3] devlink: introduce framework for
 selftests
Message-ID: <20220718203346.6aab5c4e@kernel.org>
In-Reply-To: <20220718062032.22426-2-vikas.gupta@broadcom.com>
References: <0220707182950.29348-1-vikas.gupta@broadcom.com>
        <20220718062032.22426-1-vikas.gupta@broadcom.com>
        <20220718062032.22426-2-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 11:50:30 +0530 Vikas Gupta wrote:
> +	for (i = 1; i < DEVLINK_SELFTEST_ATTR_MAX + 1; i++) {
> +		u8 res;
> +
> +		if (nla_get_flag(tb[i])) {
> +			res = devlink->ops->selftest_run(devlink, i,

Shouldn't we selftest_check() first to make sure the driver supports
given test?

> +	[DEVLINK_ATTR_SELFTESTS_INFO] = { .type = NLA_NESTED },

	... = NLA_POLICY_NESTED(devlink_selftest_nl_policy),
