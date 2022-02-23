Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F1F4C05D4
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiBWASl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiBWASk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:18:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B064D26D;
        Tue, 22 Feb 2022 16:18:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 575CAB81D90;
        Wed, 23 Feb 2022 00:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F9DC340E8;
        Wed, 23 Feb 2022 00:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645575492;
        bh=RnGSZlD3UXNbxlErLjFyxWBfwOaTBXXu5QN6JgLEYmc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L0KBFvdoWv+UuUr5+Y9RQnZgB58m1MR8iXxswBmme4DrVSCVMZRZVlBSCKrrRvY7m
         Uae4eYxSLlD4e/AgI6AuxWM2+CUZDU+uKoaaXWClK9MlfPHWQQDji+SMid0WlQ1T20
         jp3BiOjj+kEikOKP1BNN5GvdYaiFIqRRYuvGN1jyBQC4d9vDsIeHximM3IEV+tr+0g
         UnawS6D2NQ+8j3A+wO4eDD9NeOnaDArM0raBpVyAA0Emw/NOXwafD0zm9YhbEgW6LR
         bKMqUWYnhP0N+B5iCZ5g8GEqPc46Bc9+DtbwmtIv9RiPMHwBQJXTT4K1B73KAC7XBX
         PsYj/mqcs1Jvw==
Date:   Tue, 22 Feb 2022 16:18:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] net/tcp: Merge TCP-MD5 inbound callbacks
Message-ID: <20220222161810.164f6d07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222185006.337620-1-dima@arista.com>
References: <20220222185006.337620-1-dima@arista.com>
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

On Tue, 22 Feb 2022 18:50:06 +0000 Dmitry Safonov wrote:
> The functions do essentially the same work to verify TCP-MD5 sign.
> Code can be merged into one family-independent function in order to
> reduce copy'n'paste and generated code.
> Later with TCP-AO option added, this will allow to create one function
> that's responsible for segment verification, that will have all the
> different checks for MD5/AO/non-signed packets, which in turn will help
> to see checks for all corner-cases in one function, rather than spread
> around different families and functions.

Please rebase on top of net-next
