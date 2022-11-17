Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066A862E602
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 21:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240510AbiKQUgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 15:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239211AbiKQUgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 15:36:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140BE13E80;
        Thu, 17 Nov 2022 12:36:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2D7761DBC;
        Thu, 17 Nov 2022 20:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB34C433D6;
        Thu, 17 Nov 2022 20:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668717377;
        bh=2ZmdHLDS4qm6SHmQ7D1QhbOo8Q6bQ0ysahq/DKuAR1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hh2yThx6kkeLrdLc7MiTYq+khadcEM9h3qGtE96kYmmWckMN4casjbciXzurqKF25
         YhSkO12m+qIFPzg7Hk1LQlz0tlgrbrhr7txZc6i5bcQ/4+FNmFzn76+8hZ8qaO9jkQ
         yqeLKiI1H5RGcYcKKJL4aP+9ew2Ji+YwEeqPRkw2TH4chAGp5snDwaZQpQNDlxTgdR
         nmCaycnLRauW81ecI5RrH5O1DCcyuw0gBzj+1eFgUrEgf69IkTu93a9rD6jMWIMan0
         AoRDByvp6Fnux9L+ZCc5/T6F6rev2HpuWRSwLKJELFJMZslRxregfSkO/+8hcFgdlE
         2OL4asqKw6d+g==
Date:   Thu, 17 Nov 2022 12:36:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <20221117123615.41d9c71a@kernel.org>
In-Reply-To: <20221117082556.37b8028f@hermes.local>
References: <20221027212553.2640042-1-kuba@kernel.org>
        <20221114023927.GA685@u2004-local>
        <20221114090614.2bfeb81c@kernel.org>
        <202211161444.04F3EDEB@keescook>
        <202211161454.D5FA4ED44@keescook>
        <202211161502.142D146@keescook>
        <1e97660d-32ff-c0cc-951b-5beda6283571@embeddedor.com>
        <20221116170526.752c304b@kernel.org>
        <1b373b08-988d-b870-d363-814f8083157c@embeddedor.com>
        <20221116221306.5a4bd5f8@kernel.org>
        <20221117082556.37b8028f@hermes.local>
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

On Thu, 17 Nov 2022 08:25:56 -0800 Stephen Hemminger wrote:
> > I was asking based on your own commit 1e6e9d0f4859 ("uapi: revert
> > flexible-array conversions"). This is uAPI as well.  
>  
> Some of the flex-array conversions fixed build warnings that occur in
> iproute2 when using Gcc 12 or later.

Alright, this is getting complicated. I'll post a patch to fix 
the issue I've added and gently place my head back into the sand.
