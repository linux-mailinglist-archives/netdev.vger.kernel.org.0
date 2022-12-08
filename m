Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CD64666E
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLHBX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLHBX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:23:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138A7578F3;
        Wed,  7 Dec 2022 17:23:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7A7DB821CA;
        Thu,  8 Dec 2022 01:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73A9C433C1;
        Thu,  8 Dec 2022 01:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670462603;
        bh=8rCjfbDiR4db16mymv7WYvtLQ9BVPlo1/EQLjBZWGd8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KOdnkIbzzTLcTZXg9tM25dfhkp9/dJD3YfXifWRD0C3Edh+rKDtO5+nMxNItsg/0C
         dmvo+rTjqr1QfUMqwtODgZEn9W9miUgJqDViZfqKITVDqY/LDx74N5XwkG5RUmj6G8
         5Dnrf6TJD3wiZn200GZR+Kq5OAxboAkC4b9iWHsOx6k+PO4FtcKLY9vY+UEGV5hF3s
         Ew06cGr8FqeLt8JxfIlwOP45LV43wnrluHl0VYNSVezx5tvqWJ7I5MrDZ6D46L6LkD
         BXbULLVOsWFlEQ7RsR9Y5jFaGN7wSovbm148RecouEC/eagZHA5WGxiKonIkpEu16R
         vJCdBbY1ZjhQg==
Date:   Wed, 7 Dec 2022 17:23:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <edumazet@google.com>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tedheadster@gmail.com>
Subject: Re: [PATCH linux-next] net: record times of netdev_budget exhausted
Message-ID: <20221207172321.7da162c7@kernel.org>
In-Reply-To: <202212080912066313234@zte.com.cn>
References: <20221207153256.6c0ec51a@kernel.org>
        <202212080912066313234@zte.com.cn>
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

On Thu, 8 Dec 2022 09:12:06 +0800 (CST) yang.yang29@zte.com.cn wrote:
> > Sorry if this is too direct, but it seems to me like you're trying hard
> > to find something useful to do in this area without a clear use case.
>   
> I see maybe this is a too special scenes, not suitable. The motivation
> is we see lots of time_squeeze on our working machines, and want to
> tuning, but our kernel are not ready to use threaded NAPI. And we

Ah, in that cases I indeed misjudged, sorry.

> did see performance difference on different netdev_budget* in
> preliminary tests.

Right, the budget values < 100 are quite impractical. Also as I said
time_squeeze is a terrible metric, if you can find a direct metric
in terms of application latency or max PPS, that's much more valuable.

> > We have coding tasks which would definitely be useful and which nobody
> > has time to accomplish. Please ask if you're trying to find something
> > to do.  
> 
> We focus on 5G telecom machine, which has huge TIPC packets in the
> intranet. If it's related, we are glad to do it with much appreciate of your
> indicate!

Oh, unfortunately most of the tasks we have are around driver
infrastructure.
