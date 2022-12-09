Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0215647CC9
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiLIEAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 23:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLIEAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 23:00:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9665D379FF;
        Thu,  8 Dec 2022 19:59:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4B5ADCE2874;
        Fri,  9 Dec 2022 03:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A5BC433D2;
        Fri,  9 Dec 2022 03:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670558391;
        bh=5L9mqsZf3iMJpnzx/OYOcSwAgaIpEKcgPiuLx3CUubE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dMjrxxRWB+YOmtOPVlPqtST5ES/W3s3GM+Yy8BSZ7WSDx09YRY1uGAybWc+hjDP/9
         4A/bq5pGGaZQvxL3lllv1qidufVnOupTAD48YOUvQC7n5C0JBHN/ME1BR+AddrlRWM
         +YaOeoPhM6wF2YaLG4hTRgPOpdGiZWI2Nc1zAteHP7fLdODyHTllx8CIG9u85+DGw4
         aWZa0Gg73CiFI71xH3KwlfXACNm7z5fn3vKVpoUA1sEpkIs1XdrawlApdKUJztr37V
         u6EIgFZMDK9Z6nyhC6fKUiSp7w+BbtIAOnia6IDx3FwN6gbNPHaItfzQy2/yQdns9K
         rLwEIqWv2UYnQ==
Date:   Thu, 8 Dec 2022 19:59:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: Re: [PATCH net-next] net: tso: inline tso_count_descs()
Message-ID: <20221208195950.1efe71db@kernel.org>
In-Reply-To: <20221208195721.698f68b6@kernel.org>
References: <20221208024303.11191-1-linyunsheng@huawei.com>
        <20221208195721.698f68b6@kernel.org>
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

On Thu, 8 Dec 2022 19:57:21 -0800 Jakub Kicinski wrote:
> On Thu, 8 Dec 2022 10:43:03 +0800 Yunsheng Lin wrote:
> > tso_count_descs() is a small function doing simple calculation,
> > and tso_count_descs() is used in fast path, so inline it to
> > reduce the overhead of calls.  
> 
> TSO frames are large, the overhead is fine.
> I'm open to other opinions but I'd rather keep the code as is than
> deal with the influx with similar sloppily automated changes.

Oh, wait, you're not one of the bot people. Sorry, please just address
my comments and post a v2.

There is a lot of poorly written patches coming from @huawei addresses
which are giving the company a bad name :(
