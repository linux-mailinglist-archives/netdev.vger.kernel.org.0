Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A792558F4D
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 05:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiFXDxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 23:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiFXDxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 23:53:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4AA22BE5;
        Thu, 23 Jun 2022 20:53:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE654B82623;
        Fri, 24 Jun 2022 03:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE99BC341C8;
        Fri, 24 Jun 2022 03:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656042817;
        bh=MDW04LtN9gsOkAPK8AC+W1huYS3fs4Xm5ji94UzHS+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eG4B2/eJi0mqx80HOXU/s7snQLmtV1YShU2HfDsvp0fQHP0QBTHQ3MvdBoobG+wsS
         K44X5dPMlS/akJuW602g42YDS1JXVtnLn70HEISW78imTnYIIMJWae+O8++3f8ZNAI
         pw7hC6aEgW7sP7Pkdc7N+pkdEk84heFPBX8oTvsav6zLFafl8wzLOR0Vn+/63/Xkac
         dowy0Tgu+CcnSNRyBq9tSXb+JPztU0tfNXr4lwXh1aqRwRav8UETrfx6lncsyK+vbl
         EqbzyFgSVhwobxYSWP34+xcxdQJtwBaohboIcAfKuql6mx3tAina26yYYiCxIQwiI6
         R/VQ1pVBViVPg==
Date:   Thu, 23 Jun 2022 20:53:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [PATCH] net: page_pool: optimize page pool page allocation in
 NUMA scenario
Message-ID: <20220623205335.483540a4@kernel.org>
In-Reply-To: <20220622134202.7591-1-huangguangbin2@huawei.com>
References: <20220622134202.7591-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jun 2022 21:42:02 +0800 Guangbin Huang wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> Currently NIC packet receiving performance based on page pool deteriorates
> occasionally. To analysis the causes of this problem page allocation stats
> are collected. Here are the stats when NIC rx performance deteriorates:

Please repost this and CC the page pool maintainers.
