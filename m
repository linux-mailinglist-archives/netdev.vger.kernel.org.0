Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F38634F24
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbiKWEns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbiKWEno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:43:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA8BCC16D;
        Tue, 22 Nov 2022 20:43:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C249461A51;
        Wed, 23 Nov 2022 04:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046A5C433D6;
        Wed, 23 Nov 2022 04:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669178623;
        bh=b58VdBqgq0NaqB9sgIa30VbocJ1L94i6622vlfiDO5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a2yJvPLIRDQOqdwGNBw8OwQ/AmelXp4/WXwW68oM54bNUAEfZx9lIL1giTaBEw/bx
         /zvTMezK9lTAFG4RueHCFWNGRmQcsYGvcEcoco6wLzE3Diq1UX8BZqdFQyEV3wFDXk
         I6fBk42lGbJyomFe4UIXG/m3I8LwI6tXaBy1pnCOELX4j8++JV01mrLGsjX9bLcw9E
         oPA/B8sWRHpAfOymTVYtdUeHbBEiGLNhF6WWkHij7gLnlVyrk9EXkwXuBCzGna7X/6
         UEVMSVpWNc5aicqA86LwyS0Qnw9b/rR8RFJhZEVZaKvIwULbDBw9KwlZuINL8P9Lgo
         iW3t5MLZL3zcw==
Date:   Tue, 22 Nov 2022 20:43:41 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, Peter Kosyh <pkosyh@yandex.ru>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] mlx4: use snprintf() instead of sprintf() for safety
Message-ID: <Y32k/ZGQhNR9iM2F@x130.lan>
References: <20221122130453.730657-1-pkosyh@yandex.ru>
 <Y3zhL0/OItHF1R03@unreal>
 <20221122121223.265d6d97@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221122121223.265d6d97@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22 Nov 12:12, Jakub Kicinski wrote:
>On Tue, 22 Nov 2022 16:48:15 +0200 Leon Romanovsky wrote:
>> On Tue, Nov 22, 2022 at 04:04:53PM +0300, Peter Kosyh wrote:
>> > Use snprintf() to avoid the potential buffer overflow. Although in the
>> > current code this is hardly possible, the safety is unclean.
>>
>> Let's fix the tools instead. The kernel code is correct.
>
>I'm guessing the code is correct because port can't be a high value?
>Otherwise, if I'm counting right, large enough port representation
>(e.g. 99999999) could overflow the string. If that's the case - how
>would they "fix the tool" to know the port is always a single digit?

+1 

FWIW,

Reviewed-by: Saeed Mahameed <saeed@kernel.org>

