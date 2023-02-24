Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4626A1A10
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 11:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjBXKXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 05:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjBXKXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 05:23:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FF31E1CC;
        Fri, 24 Feb 2023 02:23:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D684B81C22;
        Fri, 24 Feb 2023 10:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C512AC433EF;
        Fri, 24 Feb 2023 10:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677234178;
        bh=SKfrap5oDtQdvwt0M/zcUMmBC58Di/JU1xdEhqwAODw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dMK5dJxm7ozctkazGHWxGw8R2KHQacu5Z6NKXne2to//xIekyjy3LQIbppmmO7eEV
         Tv9L3FULv9b2VaJiRIyDVpF/HMEQw1DD/tBGGnyqhM8GPJlE2jQhgtRwUOynq2qDpz
         0SXmXM6iF+LDQdruzsKs9nbHzl+6y+3BTZAadHDDOZsseW8UtdRMJG8oE9n8yHpJM/
         nY8YjTCQ6gRTcmy+WdyAHa2WiNiSLtQFRYJVrZYaE57myclZ3u4LmiothVR07hmGBc
         /aZwCR9JAm3g05U5MMvv6VL9zbEBKvILKC3hP4DeRjegbcLMnpmORBP2dKq7V/+gKi
         QJhICMiRaADrw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] wifi: wcn36xx: Slightly optimize
 PREPARE_HAL_BUF()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <7d8ab7fee45222cdbaf80c507525f2d3941587c1.1675371372.git.christophe.jaillet@wanadoo.fr>
References: <7d8ab7fee45222cdbaf80c507525f2d3941587c1.1675371372.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167723417226.18267.13778224357236866036.kvalo@kernel.org>
Date:   Fri, 24 Feb 2023 10:22:55 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> In most (likely all) cases, INIT_HAL_MSG() is called before
> PREPARE_HAL_BUF().
> In such cases calling memset() is useless because:
>    msg_body.header.len = sizeof(msg_body)
> 
> So, instead of writing twice the memory, we just have a sanity check to
> make sure that some potential trailing memory is zeroed.
> It even gives the opportunity to see that by itself and optimize it away.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Acked-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

4a51e66fe96d wifi: wcn36xx: Slightly optimize PREPARE_HAL_BUF()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/7d8ab7fee45222cdbaf80c507525f2d3941587c1.1675371372.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

