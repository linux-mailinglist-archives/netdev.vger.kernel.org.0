Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D88460EEAF
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiJ0DgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiJ0DgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:36:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1DD4D83E
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:35:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F9306215B
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D1EC433D7;
        Thu, 27 Oct 2022 03:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666841753;
        bh=UPEK0gi5azK4pqJ9eaVveKLslo5IEViOo8QGlWs1gfE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vN23OOlIe04KHttDXcp0smY1Q32SL+SVDRAD4YcKFc0Mee0FqOGnJxXyl8pEiSQg1
         iFEMHuU4pKjtgc1ExteiyLdQ/3CM0LVKT3QRe+Z+ZmuDD6IA+70BdmzqbJ56HjBNRZ
         KXlZXX3XV6hr43GDrxdRvI14AR8zXdjGmzaNBo2KOqh4E2EUb4m88L1VREDIWWxsRk
         EmSrp+8Ua7wkSmk+afVedotboCyDtdMTbbLqBsorgNqtqDw330o4AubvXIHXTBZKQM
         2WvH6ZC1kLWNI21N6QqqQc5npHD7fmBytep4+D8KNEfRFXcRQtx4T3Clq9TowMyBeV
         VbG8WysYm9ABA==
Date:   Wed, 26 Oct 2022 20:35:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@mellanox.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net] netdevsim: fix memory leak in nsim_bus_dev_new()
Message-ID: <20221026203552.7eaf37cf@kernel.org>
In-Reply-To: <20221026015405.128795-1-shaozhengchao@huawei.com>
References: <20221026015405.128795-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 09:54:05 +0800 Zhengchao Shao wrote:
> If device_register() failed in nsim_bus_dev_new(), the value of reference
> in nsim_bus_dev->dev is 1. obj->name in nsim_bus_dev->dev will not be
> released.

The fixes tag is still not 100% but I guess the bug was
slightly different before and after that patch, so:

Acked-by: Jakub Kicinski <kuba@kernel.org>
