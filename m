Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B16325E41
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 08:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBZHXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 02:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbhBZHXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 02:23:42 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CDDC06174A;
        Thu, 25 Feb 2021 23:23:02 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id k2so7234122ili.4;
        Thu, 25 Feb 2021 23:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CIXHLLcdF3NPwLoLYR00+kIyGCbIxIClS6D5W4I5jx0=;
        b=SKXb9V2iZE/41Xxmsfy4qYz4maXOMAMdbhUTmW6Yuu+Bo64nSj1bbNzTjSv0rZFCL3
         1pTPGiu4/k4M3ePEjwVSplTAW1KhEa2hbIuKPX72AH2QEK8yQ0SBSGXRYGIrgXYZa7DT
         dYmcBbFYgUcZ66aMHLb3Hsr3xydLXhl6ngVlUvXkfTtuc/HtMKxEWSAfCXDJVaQAS6FR
         7BNO65vWjgcwpczCLibrsVKoL6imCL247D+zjQ1weCmZEKp6IMnHxTYtilNLLVm8DFTw
         QSXaedY9oZMDMvpmSaztbZViYQckR53tiLbrPx6/WVVYiIiKpLJjkCBrNghEhktqjPGX
         Wz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CIXHLLcdF3NPwLoLYR00+kIyGCbIxIClS6D5W4I5jx0=;
        b=O0zNV9yw2w9BOnUIuIKCo81fMczveDp6ibC2umDpjWj2UFOEmNwPjWFuDR2ogOQ0Im
         sZo+i6WL95CRb4ZCJEaCUr+l/VV50Q3ou7PdJRHKdrqrKur0HE1hAujmi+Jak7qn3gkr
         Zga6s+iH/uXHuNBs82lJYleZPiaz8Bpw9+9i1/2L8ZYPSIcxS68mTRSo6QYyo6KmAfFx
         K6l9H+fIqg4+iFq0tQxI/SzQKOkhGdN4ueKgj0YNHELlsepWpg0tqrpUjpZvd8McgkCE
         Qh0ROgSXMQBin63imvdhcJZ7qav0QMxpIe+MmNN7e79E42WCHf71HRAuCBxA5fcwakG+
         g5Sw==
X-Gm-Message-State: AOAM533W/Kr4ba5kMfD+mbLjK0mRfNK6fwXYSFYbK1Nf68y0IpKqEga5
        dv3/LadIw+AuJNNAhauEHSwMkFBcVFoUqjt1TLTqStgwjR0a4g==
X-Google-Smtp-Source: ABdhPJwS4Z69cthjSLIia/lIbBl077kBrEYsnHRSDMkX3sQsovzELPXmUDLAd7CBAi7MjKb5yjx0KOca2MeMhBP0J3M=
X-Received: by 2002:a92:c265:: with SMTP id h5mr1261035ild.225.1614324181404;
 Thu, 25 Feb 2021 23:23:01 -0800 (PST)
MIME-Version: 1.0
References: <20210225211514.9115-1-heiko.thiery@gmail.com>
In-Reply-To: <20210225211514.9115-1-heiko.thiery@gmail.com>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Fri, 26 Feb 2021 08:22:50 +0100
Message-ID: <CAEyMn7aijecc6ai5YaaHFa1Y7u52v=KEga3nRKvXE3o-mCQLYA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] net: fec: ptp: avoid register access when ipg
 clock is disabled
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Am Do., 25. Feb. 2021 um 22:15 Uhr schrieb Heiko Thiery
<heiko.thiery@gmail.com>:
>
> When accessing the timecounter register on an i.MX8MQ the kernel hangs.
> This is only the case when the interface is down. This can be reproduced
> by reading with 'phc_ctrl eth0 get'.
>
> Like described in the change in 91c0d987a9788dcc5fe26baafd73bf9242b68900
> the igp clock is disabled when the interface is down and leads to a
> system hang.
>
> So we check if the ptp clock status before reading the timecounter
> register.
>
> Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>


Sorry for the noise. But just realized that I sent a v3 version of the
patch but forgot to update the subject line (still v2). Should I
resend it with the correct subject?

> ---
> v2:
>  - add mutex (thanks to Richard)
>
> v3:
> I did a mistake and did not test properly
>  - add parenteses
>  - fix the used variable
>
>  drivers/net/ethernet/freescale/fec_ptp.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
> index 2e344aada4c6..1753807cbf97 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -377,9 +377,16 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
>         u64 ns;
>         unsigned long flags;
>
> +       mutex_lock(&adapter->ptp_clk_mutex);
> +       /* Check the ptp clock */
> +       if (!adapter->ptp_clk_on) {
> +               mutex_unlock(&adapter->ptp_clk_mutex);
> +               return -EINVAL;
> +       }
>         spin_lock_irqsave(&adapter->tmreg_lock, flags);
>         ns = timecounter_read(&adapter->tc);
>         spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
> +       mutex_unlock(&adapter->ptp_clk_mutex);
>
>         *ts = ns_to_timespec64(ns);
>
> --
> 2.30.0
>
