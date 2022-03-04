Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFFA4CCC76
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 05:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237867AbiCDEH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 23:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbiCDEH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 23:07:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F6A17FD12;
        Thu,  3 Mar 2022 20:06:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 642A6B82750;
        Fri,  4 Mar 2022 04:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF720C340E9;
        Fri,  4 Mar 2022 04:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646366798;
        bh=JA53j2AgX/X9G8Xvc7wkJOeH5rUcfRDdjpdniPTSIVE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oAHVzz7X5kV61UUkWQKjfmwMykgBKD7PJkuQSgcKFBIw2YjksnJrCxtuntINs5owG
         Yl0e0u1JcN2qjzcdy1LS7/3v7LMdxJKVbdeeuA+/xPZlegElPBP/Nfb+Vjmj99Jlzd
         oWoEeQyHGHX4bt0D0DZpLUeKkaBXtLaL8qqnmQHIOj1nl1lCy+RZgLa0aU5frAx5AA
         DJg34gTsypaZcTNM1C+jE3PovbGMmD4VKx4H7Kss8tKwYviTYfVzh2MEdyCZOi1G6o
         gWkVmRHi3lLNBq/Z1EI+9Mqlll+/ywKFIwbgQS3sjlaPGMFlgCRfLn+yLkIn9otE52
         ipwYAJ7AlcYVQ==
Date:   Thu, 3 Mar 2022 20:06:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     menglong8.dong@gmail.com, dsahern@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, edumazet@google.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, memxor@gmail.com, arnd@arndb.de,
        pabeni@redhat.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 2/7] net: skb: introduce the function
 kfree_skb_list_reason()
Message-ID: <20220303200635.0718540e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <40f63798-2b85-c31c-9722-ee24d55093a8@oracle.com>
References: <20220303174707.40431-1-imagedong@tencent.com>
        <20220303174707.40431-3-imagedong@tencent.com>
        <40f63798-2b85-c31c-9722-ee24d55093a8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Mar 2022 16:12:05 -0800 Dongli Zhang wrote:
> I am going to send another v5 soon which introduces kfree_skb_list_reason() as well.
> 
> https://lore.kernel.org/all/20220226084929.6417-2-dongli.zhang@oracle.com/
> 
> I will need to make it inline as suggested by Jakub.
> 
> Not sure how to handle such scenario :)

Probably nothing we can do about that :( I'd say proceed as if the
other series didn't exist, and after one series is merged the author
of the other one will have to rebase.
