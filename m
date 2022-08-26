Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64D15A1E02
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244087AbiHZBNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243910AbiHZBNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:13:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2738DC9910;
        Thu, 25 Aug 2022 18:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B57CA61DC7;
        Fri, 26 Aug 2022 01:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D26C433D6;
        Fri, 26 Aug 2022 01:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661476386;
        bh=KT6LYdhsQfzPbR/7RJY9r7RR6OFX1jQVpKayaiN69Lo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FqBdKPaiVs0tb0aRViWXXdAu5K9ReqLmNJnAjyBw9dHq2b51+AKsSRFU63FjlP3zg
         yIao3dIvQ5ZRNTJPIVBsXylJIPYbr6Ter2DN/VvyFg314DBGR4oVAj7hOoWjDYF76u
         9igZVvg5IOU3ILJgxm7hCBwCXiK+UIpjzAQmugirFp/K13v3WwK7FEwMIcBWG2azMS
         i/ZfLIwr1ERfSnma4FcT9qKdcxZWkaUfLVBMcINZeZ3k1GfGnayUPSNgoxS69HPakH
         8x3AsUtH7sBKRls2UShJ9mPY16NEoJuSdEcKunWwTxuBL5bPr2FDyMTHWUmrBcFDo0
         jnyU798ZJ8fKw==
Date:   Thu, 25 Aug 2022 18:13:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <vladbu@mellanox.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next] net: sched: tbf: don't call qdisc_put() while
 holding tree lock
Message-ID: <20220825181305.773c9e64@kernel.org>
In-Reply-To: <20220826011248.323922-1-shaozhengchao@huawei.com>
References: <20220826011248.323922-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022 09:12:48 +0800 Zhengchao Shao wrote:
> The issue is the same to commit c2999f7fb05b ("net: sched: multiq: don't
> call qdisc_put() while holding tree lock"). Qdiscs call qdisc_put() while
> holding sch tree spinlock, which results sleeping-while-atomic BUG.
> 
> Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

If it's a bug fix for a commit already in Linus's main tree it should
come with [PATCH net] in the subject (i.e. without the -next).
Please repost.
