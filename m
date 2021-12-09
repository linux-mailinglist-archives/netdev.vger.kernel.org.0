Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CC846E39B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhLIIED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLIIEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:04:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC54C061746;
        Thu,  9 Dec 2021 00:00:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA57FB8235C;
        Thu,  9 Dec 2021 08:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AAAC341C8;
        Thu,  9 Dec 2021 08:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639036826;
        bh=q8TudegaWlJbIRiG/KH/x6Pllk5BBrnfUfWzUhhSnpI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=tYgfBsfMSP7ePJBz01USbUmB+h7cn1kiJMAxltd5f4a3W+dEAisDAwgJfQcbnuy2D
         yA9RcuHlHf25RnyjyW1S89VqTT390L5DySgXbRZq0apyfFT7Iirh7bEQ4T+KLavslz
         2u5fcSjQ/bDnfh4hYiW/7R5xxikUabW8HTuHj/kix4HNLUFuwCGg8l3BVVF3IJDZKX
         C4ohUMjlDuIEqnAXXrtRSoOXAELjCKdxPEGIIFfZaS/shSHHgRowOVHU05ul3kuJ8d
         Cpeoqp8L4/4pRlFO0cKdzqHP5NoA7yynfRt7fNL7qggWd0vfXM/Qk6klD5st+nF9Qd
         4KlWVXN9iv8CA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath6kl: Use struct_group() to avoid size-mismatched
 casting
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211207063538.2767954-1-keescook@chromium.org>
References: <20211207063538.2767954-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163903682322.20904.826653912822578576.kvalo@kernel.org>
Date:   Thu,  9 Dec 2021 08:00:24 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> In builds with -Warray-bounds, casts from smaller objects to larger
> objects will produce warnings. These can be overly conservative, but since
> -Warray-bounds has been finding legitimate bugs, it is desirable to turn
> it on globally. Instead of casting a u32 to a larger object, redefine
> the u32 portion of the header to a separate struct that can be used for
> both u32 operations and the distinct header fields. Silences this warning:
> 
> drivers/net/wireless/ath/ath6kl/htc_mbox.c: In function 'htc_wait_for_ctrl_msg':
> drivers/net/wireless/ath/ath6kl/htc_mbox.c:2275:20: error: array subscript 'struct htc_frame_hdr[0]' is partly outside array bounds of 'u32[1]' {aka 'unsigned int[1]'} [-Werror=array-bounds]
>  2275 |         if (htc_hdr->eid != ENDPOINT_0)
>       |                    ^~
> drivers/net/wireless/ath/ath6kl/htc_mbox.c:2264:13: note: while referencing 'look_ahead'
>  2264 |         u32 look_ahead;
>       |             ^~~~~~~~~~
> 
> This change results in no executable instruction differences.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

e3128a9d482c ath6kl: Use struct_group() to avoid size-mismatched casting

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211207063538.2767954-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

