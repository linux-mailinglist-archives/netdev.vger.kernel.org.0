Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88CB6D2698
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 19:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjCaRY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 13:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCaRY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 13:24:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3710B1D2D1;
        Fri, 31 Mar 2023 10:24:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6F6962A92;
        Fri, 31 Mar 2023 17:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A29DC433EF;
        Fri, 31 Mar 2023 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680283496;
        bh=DxkTNqKM5xbHWQljDAPO6QEfNmH+hRrp/m3R6vfZIhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s5x+xahQHmZqg2hvtfQBX/wg1q4FZgNhycQd8uwdaqur40s5cY0rnWWaHp0NCKQae
         yVpaw3UVI9/fNAcnigNDKupjuueOy85Xh9aNsyyJpVWFgq43hEUIQsx9PS9ZJko4yX
         5Cft7U/xScnEbrlv90fLD0kvEm3o5fgltfXKyA4sH0Ieft5FtIcN14HoSJEUQK+WqC
         6F+pI8siSO0kVb+lBDa9y01ZqHUXz5PYZbo/fBb/0/gH2epS6jwUj6jZBkapiggg3m
         45tsfGsu30YsCvn5qL4uEmnWxI8SYPJCdNOb3gswKy5FOQNIChiYFukH9kGwSy0O08
         YzIn76E6S0qNw==
Date:   Fri, 31 Mar 2023 10:24:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] netlink: Add multicast group level permissions
Message-ID: <20230331102454.1251a97f@kernel.org>
In-Reply-To: <830EC978-8B94-42D6-B70F-782724CEC82D@oracle.com>
References: <20230329182543.1161480-1-anjali.k.kulkarni@oracle.com>
        <20230329182543.1161480-7-anjali.k.kulkarni@oracle.com>
        <20230330233941.70c98715@kernel.org>
        <830EC978-8B94-42D6-B70F-782724CEC82D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 17:00:27 +0000 Anjali Kulkarni wrote:
> > Is there a reason this is better than implementing .bind
> > in the connector family and filtering there?  
> 
> Are you suggesting adding something like a new struct proto_ops for
> the connector family? I have not looked into that, though that would
> seem like a lot of work, and also I have not seen any infra structure
> to call into protocol specific bind from netlink bind?

Where you're adding a release callback in patch 2 - there's a bind
callback already three lines above. What am I missing?
