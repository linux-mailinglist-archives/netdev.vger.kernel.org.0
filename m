Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF8D531B41
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiEWTYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiEWTYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:24:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088BF16F36A;
        Mon, 23 May 2022 12:03:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8A24B811A1;
        Mon, 23 May 2022 19:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661A5C385A9;
        Mon, 23 May 2022 19:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653332612;
        bh=PwbpPaawIX6nShLpvjVPFYMb/e2PU/5rHBUKFQwfcQQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mvt21geFFUqkirtTJT3/NF+0TPEb6xLlVDwlMfhr1IjTA6Xh4sCy4e/NXmZgXt+cS
         hM0FuXJrsIxiQC0c/Q8uXf7/39NvP+ueTbykhzJHEelu+Hbb8gIV6vvFtbuJt6kumZ
         36wCiwD7YuA6YX0TBqSw/J6A5E65niL5RxdfFH8TdBeoS1LKKqNxCdgOBQu0wUNqaM
         eCqPSQucX8DY53AIoFBCiRMibRuF+dO6dk8KM0ExnSJ0CX/cur4DquTcEAkMyn/0LS
         gVCmEGCGb5mBATsi9rX560fU9c5h1YjXKJ7ScbviYiCXm6Gqw+kN3oZamtLSzMoTc8
         bWHFuzHMc1TVQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath11k: fix IRQ affinity warning on shutdown
References: <20220523143258.24818-1-johan+linaro@kernel.org>
        <YoueemdqqRCwtk0z@hovoldconsulting.com>
Date:   Mon, 23 May 2022 22:03:25 +0300
In-Reply-To: <YoueemdqqRCwtk0z@hovoldconsulting.com> (Johan Hovold's message
        of "Mon, 23 May 2022 16:47:22 +0200")
Message-ID: <87a6b8ysua.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> On Mon, May 23, 2022 at 04:32:58PM +0200, Johan Hovold wrote:
>> Make sure to clear the IRQ affinity hint also on shutdown to avoid
>> triggering a WARN_ON_ONCE() in __free_irq() when stopping MHI while
>> using a single MSI vector.
>
> Forgot the tested-on tag, sorry.
>
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Thanks, added in the pending branch.

>> Fixes: e94b07493da3 ("ath11k: Set IRQ affinity to CPU0 in case of one MSI vector")
>> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>
> Let me know if I should resend.

No need, I can easily edit commit logs.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
