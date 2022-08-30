Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD795A5AE7
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 06:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiH3Es4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 00:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiH3Esx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 00:48:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3858CAE22D;
        Mon, 29 Aug 2022 21:48:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9599C61231;
        Tue, 30 Aug 2022 04:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E41C433C1;
        Tue, 30 Aug 2022 04:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661834929;
        bh=zX1NN0m+kuHbiVw/vJt8nv2cDsPm1F+9+El9H/9IgbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dUVF2+5SOda/PRZwwEadbecDju2R5FubkdwKO5tPXn0BsCq3b518zBz4M0fJZ0+FP
         A2WTVob0K/t4rYf+9dio2MzYTGWH+gUg1SZG1FhJ1Jr6ZgvkJXsKnVmHYmK4qqY2eI
         d9IJWsXgDt/Bzg/ShHjy1OBXnIeYw3vt5Vh5Yt2GScHBH02JiIcrruNarIP83em5ym
         9rPrr5fIfOhhvD1oRoaMVWgQ793XTrXywiIWYCBmDpz8WZb8J1qkLASLBDxOxDgFAL
         MOy34LJ/aeCaOZK6fO00VzokQPZUDlvwcQgIpEv8JDcN9L6T9Yw7R0eOjmtsVIvdf8
         Uhh/8w4m48kuw==
Date:   Mon, 29 Aug 2022 21:48:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next 0/3] net: sched: add other statistics when
 calling qdisc_drop()
Message-ID: <20220829214846.3fbb41b1@kernel.org>
In-Reply-To: <3bee0773-dc81-79b8-bddd-852141e3258c@huawei.com>
References: <20220825032943.34778-1-shaozhengchao@huawei.com>
        <20220826194052.7978b101@kernel.org>
        <3bee0773-dc81-79b8-bddd-852141e3258c@huawei.com>
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

On Sat, 27 Aug 2022 11:16:53 +0800 shaozhengchao wrote:
> On 2022/8/27 10:40, Jakub Kicinski wrote:
> > On Thu, 25 Aug 2022 11:29:40 +0800 Zhengchao Shao wrote:  
> >> According to the description, "other" should be added when calling
> >> qdisc_drop() to discard packets.  
> > 
> > The fact that an old copy & pasted comment says something is not
> > in itself a sufficient justification to make code changes.
> > 
> > qdisc_drop() already counts drops, duplicating the same information
> > in another place seems like a waste of CPU cycles.  
> 
> Hi Jakub:
> 	Thank you for your reply. It seems more appropriate to delete the other 
> variable, if it is unused?

Yes, removing it SGTM.
