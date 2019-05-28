Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A041C2C575
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfE1Ldw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:33:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52374 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfE1Ldw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:33:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 44BE460388; Tue, 28 May 2019 11:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559043231;
        bh=L1NbZxiLtq3rlmMS9o/rSgkfR5rPEvxTXSc6OnbhHco=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fB0H+7YMCFozgKGcSbatyDncJKV7Veu0X1mHZ8K39Jq+kugmwUFfgZQNqIBTx8ZVN
         IJ05O3cEnl5jGYg3yHO5lfV5gTCgYObImstmFD6XTRFwFP6f1P/LVME/Nnf4rs4B7B
         Hh2jjmEOuU5AsGHE4GjjCrOPmWCYQVpKXG0hEPzg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 45EA360E5A;
        Tue, 28 May 2019 11:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559043228;
        bh=L1NbZxiLtq3rlmMS9o/rSgkfR5rPEvxTXSc6OnbhHco=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=epXRGH2nFWQAVz/MQJzPp7tO1NHsMRRmGiIUHfBrmUov29KtEeATI6exYBp0Vez7J
         DESnJG4ayMktH1rOIKkPYAJBZ6eHKgimEi7bLOO3WFcByq4JOvVVUeMbjR8Qshp931
         egX9WxpIzpV3njFlKh3C2wLfxNhTQm0ZdwkzGW28=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 45EA360E5A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 5.2] rsi: Properly initialize data in rsi_sdio_ta_reset
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190523153007.112231-1-natechancellor@gmail.com>
References: <20190523153007.112231-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528113351.44BE460388@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 11:33:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> When building with -Wuninitialized, Clang warns:
> 
> drivers/net/wireless/rsi/rsi_91x_sdio.c:940:43: warning: variable 'data'
> is uninitialized when used here [-Wuninitialized]
>         put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
>                                                  ^~~~
> drivers/net/wireless/rsi/rsi_91x_sdio.c:930:10: note: initialize the
> variable 'data' to silence this warning
>         u8 *data;
>                 ^
>                  = NULL
> 1 warning generated.
> 
> Using Clang's suggestion of initializing data to NULL wouldn't work out
> because data will be dereferenced by put_unaligned_le32. Use kzalloc to
> properly initialize data, which matches a couple of other places in this
> driver.
> 
> Fixes: e5a1ecc97e5f ("rsi: add firmware loading for 9116 device")
> Link: https://github.com/ClangBuiltLinux/linux/issues/464
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Patch applied to wireless-drivers.git, thanks.

f57b5d85ed58 rsi: Properly initialize data in rsi_sdio_ta_reset

-- 
https://patchwork.kernel.org/patch/10958063/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

