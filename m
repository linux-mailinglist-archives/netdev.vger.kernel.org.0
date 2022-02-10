Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F254B0678
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 07:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbiBJGlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 01:41:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiBJGlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 01:41:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A870310A6;
        Wed,  9 Feb 2022 22:41:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 442CA61CD5;
        Thu, 10 Feb 2022 06:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65F5C004E1;
        Thu, 10 Feb 2022 06:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644475261;
        bh=DWpM8xJA6dWr+X2mNlbIvh0RMS3ic7OpO5Z6YUdDSMc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=V4f0GHlvTfJ9tdWBvSMOcPE4nktTKUJ3KnLHLk+SV4iRA6gi3FxvP8jQg7uRDje9J
         z5GFJoeqJTMWBrK1+pN7Dkqvdq8LUmbMA1+5HcN0Vr5Q1Jwly2xq+s3642MSNyBJ5J
         dGUHtTT+nPZczKsRWFsF1tYF1m/pV9ZEYjJPpNE+9vpxmzrcam18JEmN4fPWd9Hqaz
         CJjLrOrhw6GGWrn38LTsTvRI/oNhJXO5u8VzQOuBDTdhfPSeNUevub/dLgL0ndQ/P0
         ME1zcePWMUg3CfOT9Ies24BVu69Lrcl+ysuvZ1qtUS1xb+qxy9oW0vpc6d6ExbbApr
         Qz7eAaPUOFldw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: ath: use div64_u64() instead of do_div()
References: <1644395972-4303-1-git-send-email-wangqing@vivo.com>
Date:   Thu, 10 Feb 2022 08:40:56 +0200
In-Reply-To: <1644395972-4303-1-git-send-email-wangqing@vivo.com> (Qing Wang's
        message of "Wed, 9 Feb 2022 00:39:32 -0800")
Message-ID: <87v8xnrzpj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qing Wang <wangqing@vivo.com> writes:

> From: Wang Qing <wangqing@vivo.com>
>
> do_div() does a 64-by-32 division.
> When the divisor is u64, do_div() truncates it to 32 bits, this means it
> can test non-zero and be truncated to zero for division.
>
> fix do_div.cocci warning:
> do_div() does a 64-by-32 division, please consider using div64_u64 instead.
>
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/net/wireless/ath/wil6210/debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

The subject prefix should be "wil6210:", but I can fix that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
