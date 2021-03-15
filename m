Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8632333BF81
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhCOPMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbhCOPMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:12:13 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8527CC06174A;
        Mon, 15 Mar 2021 08:12:13 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id u20so33692554iot.9;
        Mon, 15 Mar 2021 08:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4fsBolBzRXXzfub//zLUAYvHUKMZoQh8342zf2IfFb4=;
        b=h7yPC8ZgDBfiiVm7Cui0buHgxyzQRkHx7hvuAPjJR3+U1gMAPPjg0hHAwfDafDMQdD
         8Dpkk/aQD++qcA41WTeLYO5fOGxGb3J17hgfDKaRJ5oadkHgypQ+5P3TKYt66s1tQZsm
         inFPkEhsWhmTIg7Q6e4g898R8g/j9Ohz90b4bdBEfsGpg5F70u0kuT8GyQv0ynfERIQg
         mSTxLK2g//DwASF6jG1L7+ECZIAx1AKJU/jzMBKp4twsx2oSWPWVpg/NsCCbhoHUVMUb
         WBD0JjDC5o9EVePnN7HZ++JHrClM2cE4NsLiObRdPwk1Ea6RX8LvTfzsO6DcOkvMldQA
         OmuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4fsBolBzRXXzfub//zLUAYvHUKMZoQh8342zf2IfFb4=;
        b=VVnVr99Tsbs9MrDU7UplFQLp3cYW9L2Rl0beExs2t3oEfdgD+YMUC/K/LzpiKLruNI
         LrW3dgJZg/LJFfPWMNwlLa7KjcnCK9zGHeDwATNvmXzkzsn9IafbdOG9GIq2D8VWmB81
         oQazOVXme102CyC6QufscQZOijnuCIUlxP0C6vYCikrW8as45jgEgoPI4xLJFKezfcgJ
         LryYw6CveWyI6eFs7QjWe9dEAYKK8pLv/AU2faIHO48c++yBO4zw7hJHlAmnO4Cz+yLp
         0do2F1jueYsT/1SESlXHB7n+Yw/U+3ADkkAETCN6acCXhXkmU74aAuHY3tudPyD4wHmn
         tLSg==
X-Gm-Message-State: AOAM530VDKf1aBgoTRw/W4IhgDWpIoAW2N61wTN6nX/HjEyDHufzoXPN
        U7KSCUiY3zLXw7pPev8XlFYdXSJJ/BhwPpGgMP4=
X-Google-Smtp-Source: ABdhPJwCDzdMyhwsjTLbbqnKHxseDumoUNsEDfldiwWwhJnOTV3hj2bkg0gpox2jf8Hs1/Z4pOvaUOrZZxpFIVbJ8Z0=
X-Received: by 2002:a5e:df46:: with SMTP id g6mr78937ioq.38.1615821132857;
 Mon, 15 Mar 2021 08:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210315150118.1770939-1-elder@linaro.org>
In-Reply-To: <20210315150118.1770939-1-elder@linaro.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 15 Mar 2021 08:12:02 -0700
Message-ID: <CAKgT0Uf4e4YeCJ_cHombeS8_D0uPoWa9krqngTyExgL6ggp3ow@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ipa: make ipa_table_hash_support() inline
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 8:01 AM Alex Elder <elder@linaro.org> wrote:
>
> In review, Alexander Duyck suggested that ipa_table_hash_support()
> was trivial enough that it could be implemented as a static inline
> function in the header file.  But the patch had already been
> accepted.  Implement his suggestion.
>
> Signed-off-by: Alex Elder <elder@linaro.org>

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

> ---
>  drivers/net/ipa/ipa_table.c | 5 -----
>  drivers/net/ipa/ipa_table.h | 5 ++++-
>  2 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
> index baaab3dd0e63c..7450e27068f19 100644
> --- a/drivers/net/ipa/ipa_table.c
> +++ b/drivers/net/ipa/ipa_table.c
> @@ -239,11 +239,6 @@ static void ipa_table_validate_build(void)
>
>  #endif /* !IPA_VALIDATE */
>
> -bool ipa_table_hash_support(struct ipa *ipa)
> -{
> -       return ipa->version != IPA_VERSION_4_2;
> -}
> -
>  /* Zero entry count means no table, so just return a 0 address */
>  static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
>  {
> diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
> index 1a68d20f19d6a..889c2e93b1223 100644
> --- a/drivers/net/ipa/ipa_table.h
> +++ b/drivers/net/ipa/ipa_table.h
> @@ -55,7 +55,10 @@ static inline bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask)
>   * ipa_table_hash_support() - Return true if hashed tables are supported
>   * @ipa:       IPA pointer
>   */
> -bool ipa_table_hash_support(struct ipa *ipa);
> +static inline bool ipa_table_hash_support(struct ipa *ipa)
> +{
> +       return ipa->version != IPA_VERSION_4_2;
> +}
>
>  /**
>   * ipa_table_reset() - Reset filter and route tables entries to "none"
> --
> 2.27.0
>
