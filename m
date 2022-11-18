Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C2662F9F8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 17:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbiKRQNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 11:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbiKRQNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 11:13:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9548EB40
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 08:13:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3FA7B822B5
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 16:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B11C433D6;
        Fri, 18 Nov 2022 16:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668787990;
        bh=HYQNSsW4OjffkrCSs6/kkl6U/OZ7sgTf3kvKEGvqv+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BX7/KPTaEDyo74CPOs7IzlYQYgaxjDi1B+EDe61GU6luRW8LcMRucwxxnUKc9hnm1
         bZNsQovgPG/valD614WtIKeQSzWkeKwVFz80WUls2h3zmPdq0oM9K+0mJ6gK8+fRAI
         FnQFjNcu0+qgk1Vqwsazrj6kNQJpOuLc15SN7vpKOEGk/wmieDpncogJnmLmq9bZUs
         GgnkiwhSa0dJY4elSPsJUuwUppqkUU0a9jslJv9Y4C+jfJUHK/5ywPMBC5Jed3B9up
         SNrXL0o3C5i/Kwoj3evfvcoevtpngUeDF0jSAegr5qiEleKXw8XF8dS3pEvTkh6RfO
         hW5cwzrZEVFLw==
Date:   Fri, 18 Nov 2022 08:13:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [Need Help] tls selftest failed
Message-ID: <20221118081309.75cd2ae0@kernel.org>
In-Reply-To: <Y3c9zMbKsR+tcLHk@Laptop-X1>
References: <Y3c9zMbKsR+tcLHk@Laptop-X1>
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

On Fri, 18 Nov 2022 16:09:48 +0800 Hangbin Liu wrote:
> Hi Jakub,
> 
> The RedHat CKI got failures when run the net/tls selftest on net-next 6.1.0-rc4
> and mainline 6.1.0-rc5 kernel. Here is an example failure[1] with mainline
> 6.1.0-rc5 kernel[2]. The config link is here[3]. Would you please help
> check if there is issue with the test? Please tell me if you can't
> access the URLs, then I will attach the config file.

Hm, looks like a config problem. CRYPTO_SM4 is not enabled in the
config, even tho it's listed in tools/testing/selftests/net/config. 
Maybe it's not the right symbol to list in the test, or there is
a dependency we missed?
