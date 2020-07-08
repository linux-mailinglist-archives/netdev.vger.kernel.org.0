Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217282193FE
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgGHXDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgGHXDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 19:03:47 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFF0C08C5C1
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 16:03:47 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id w34so317428qte.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 16:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=To0+Smg43e/9CvTBABgED+cYpEQSStMGVMvi2i5fPzg=;
        b=RNAYnBEgE2TiqdyUeojImy8gOwbVIOFQQSEjYG9KHdt061+dFG2b6jIUUBiUdQPmWP
         deilgIVor23VxDCpWJSMXIwqiBgoH2437YnkMzPREaSjNBTwA6LUpqctj7unzQTUdblH
         y4ikK2xUtF+NbXQGkN8KYqXc1LKB/rvSP17sA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=To0+Smg43e/9CvTBABgED+cYpEQSStMGVMvi2i5fPzg=;
        b=Y4mUQ37bg4iDjoISlcFonFqg6wVpW6XsQfJ5FynFaFEfpzUPAph5y8IxXur8PXF9Wi
         dkmJkR3jDzYd/ece4v28LN/j2GRXV1SAD/FCP4zUkbRENWDtxkvbW5ewd7tKcFg4lmpM
         eMKgbzM9igOxdbKaL0YQd8FbLbEiqCzPdYtD6QXmtMFVpDpfSxdg6x1CDTEsg1Bkt5TF
         cTMV/lP1oo3U5s1RREY53LMhU1IHc4exQQtVcDxiFXO0mpGiM9sgxpM8k8OGsrEqQe99
         mlh6Wus6J1M+DMEqpb4UNhGLgirlNZsRyH8BCX6ADTG5lWeSUWR0aI+wfX1rjPcLcWd7
         L0mg==
X-Gm-Message-State: AOAM5307Fuy9vF2yW2q/ihv1mq+z5CYzU6nvhhxxMig3kpua4QpvLz7v
        Ev59ZjS7/21MHRYFAVvR2hIPJkNAh6s=
X-Google-Smtp-Source: ABdhPJx2eQ5tWL1pSNWaGISRL62SX86KXA/kS2qUCWxMV3Tj7YYBb1eeDqe6fJwo5PrDl3pgSBZ9aQ==
X-Received: by 2002:aed:26e1:: with SMTP id q88mr64646253qtd.354.1594249425430;
        Wed, 08 Jul 2020 16:03:45 -0700 (PDT)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com. [209.85.222.171])
        by smtp.gmail.com with ESMTPSA id x19sm1391559qtc.36.2020.07.08.16.03.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 16:03:42 -0700 (PDT)
Received: by mail-qk1-f171.google.com with SMTP id b4so48510qkn.11
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 16:03:42 -0700 (PDT)
X-Received: by 2002:a37:b6c6:: with SMTP id g189mr44795113qkf.206.1594249421577;
 Wed, 08 Jul 2020 16:03:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200707101712.1.I4d2f85ffa06f38532631e864a3125691ef5ffe06@changeid>
In-Reply-To: <20200707101712.1.I4d2f85ffa06f38532631e864a3125691ef5ffe06@changeid>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 8 Jul 2020 16:03:28 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMXtwdV4BNL1GSj8DY-3z8-dZ=1hP8Xv_R-AjKvJs0NMw@mail.gmail.com>
Message-ID: <CA+ASDXMXtwdV4BNL1GSj8DY-3z8-dZ=1hP8Xv_R-AjKvJs0NMw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Keep track of which interrupts fired, don't poll them
To:     Douglas Anderson <dianders@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        ath10k <ath10k@lists.infradead.org>,
        saiprakash.ranjan@codeaurora.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Abhishek Kumar <kuabhs@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 10:18 AM Douglas Anderson <dianders@chromium.org> wrote:
> diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
> index a440aaf74aa4..666ce384a1d8 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.h
> +++ b/drivers/net/wireless/ath/ath10k/ce.h
...
> @@ -376,12 +377,9 @@ static inline u32 ath10k_ce_interrupt_summary(struct ath10k *ar)
>  {
>         struct ath10k_ce *ce = ath10k_ce_priv(ar);
>
> -       if (!ar->hw_params.per_ce_irq)

If I'm reading correctly, you're removing the only remaining use of
'per_ce_irq'. Should we kill the field entirely? Or perhaps we should
leave some kind of WARN_ON() (BUG_ON()?) if this function is called
erroneously with per_ce_irq==true? But I suppose this driver is full
of landmines if the CE API is used incorrectly.

> -               return CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_GET(
> -                       ce->bus_ops->read32((ar), CE_WRAPPER_BASE_ADDRESS +
> -                       CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS));
> -       else
> -               return ath10k_ce_gen_interrupt_summary(ar);
> +       return CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_GET(
> +               ce->bus_ops->read32((ar), CE_WRAPPER_BASE_ADDRESS +
> +               CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS));
>  }
>
>  /* Host software's Copy Engine configuration. */

> diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
> index a3dd06f6ac62..5095d1893681 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.h
> +++ b/drivers/net/wireless/ath/ath10k/snoc.h
> @@ -78,6 +78,7 @@ struct ath10k_snoc {
>         unsigned long flags;
>         bool xo_cal_supported;
>         u32 xo_cal_data;
> +       DECLARE_BITMAP(pending_ce_irqs, CE_COUNT_MAX);

Do you need to clear this map if the interface goes down or if there's
a firmware crash? Right now, I don't think there's a guarantee that
we'll run through a NAPI poll in those cases, which is the only place
you clear the map, and if the hardware/firmware has been reset, the
state map is probably not valid.

Otherwise, looks OK to me:

Reviewed-by: Brian Norris <briannorris@chromium.org>
