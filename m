Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4D0607A60
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiJUPVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJUPVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:21:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDF6278157
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 08:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 328E961EF3
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 15:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0C2C433C1;
        Fri, 21 Oct 2022 15:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666365701;
        bh=0rwff0nAjWGxEvXNwYyg9SZXyaenaMBd3gmSHFfXQ9Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vzb0Pc4OYiziBIJLBq0Z8XBAa8vSk3iBBhGLSytK8WS4HSo/u+xThKC47sZ0eGFVv
         9bTAF8tFRQfhMh4x2htK5sTzNelATbkXVNhwYfM90YGEweDHfSOOgMjrGWrh7XOGKc
         q0C1f20JJ0jRUY/jFEj6qelRczS+kDyILhIUzVlTM7l2pIHr9gl+6dx1Ur+QTdGJoZ
         7LOginzj4OWIgkfxkC+fHWSGyjVPDOYaog+rB6/1J4476KOpEDeZr65XjTGoDU2/y/
         41QREACuJuV9AzhQx2PTk0d0rvWY4fIt8Y1aId4//waubjCdEUcG2dAgnVOrRmFsj5
         MNJErJAhvp6Ug==
Date:   Fri, 21 Oct 2022 08:21:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@mellanox.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net 1/2] netdevsim: fix memory leak in nsim_drv_probe()
 when nsim_dev_resources_register() failed
Message-ID: <20221021082140.524e97a4@kernel.org>
In-Reply-To: <297b3e63-efa5-fc14-35d7-2f6e7e334122@huawei.com>
References: <20221020023358.263414-1-shaozhengchao@huawei.com>
        <20221020023358.263414-2-shaozhengchao@huawei.com>
        <20221020172612.0a8e60bb@kernel.org>
        <ec77bbe9-7ced-8d9a-909c-9e6658b28e31@huawei.com>
        <297b3e63-efa5-fc14-35d7-2f6e7e334122@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 17:13:10 +0800 shaozhengchao wrote:
> >> Looks like a rename patch.
> >>
> >> The Fixes tag must point to the commit which introduced the bug.
> >>  
> > OK, I will check it.  
> Sorry, I check this commit introduce the bug. What do I have missed?

Say more?  All I see it do is rename devlink_resources_register() 
to nsim_dev_resources_register(). Which part do I need to look at?
