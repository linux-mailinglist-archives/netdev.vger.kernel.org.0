Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F52C3D0AD5
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 10:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbhGUIB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 04:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236493AbhGUHwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 03:52:36 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FB1C0613DF
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 01:32:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id my10so1246377pjb.1
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 01:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pf6yv9jzBQ/5AFzoIiLQG3uhUQu1tpDnak3e79XC28M=;
        b=y621LkRHoi99PoVsbnU6S0bH0TRJ5AQnMgOjpKF2WeizYtAtjYEO4wMVTq0GXd76Dx
         DViLNHf98/Czq3TvPL2kWUcgaWOm5bihicRD4yEqjftumKKgsyvoLgul2JrkM15M/Jrm
         vwWifgz5nXe8nKG/cEfmv72QUuURbldIZczbabFzQMd3BrMgIdooTAMVBilzLpdjYpJH
         1fLAP7FPSDPZdI4uV3+BC4PTZvruO/4otSFfN8ILdtj0ZpXdV+sP2wfT+HZdkiuoyeI5
         mK9KUCMw4ADGl0/8xmY6I4G/9GOnQTMKkKNW12qrrkblyDl+7sqmf+clAHi1LsFrCM6F
         VPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pf6yv9jzBQ/5AFzoIiLQG3uhUQu1tpDnak3e79XC28M=;
        b=q9PhcgBfYchF0V2kQc4eBVxxyiA5SK4Cmt+kt4Pb8CSG4K3zsOw/JVhakML+/lsGqi
         Gjoq8l/6hfBMdhjyRfzaRCJMs/YlEe70SzS7GCQMwW7ZfwrF/eXEUhHTc7TVmAlBk1H5
         lFDqVoCwTUSn7YR5Ygd7mzPrKlqPKlhb0KYdMUaj32ZaUgTXihHtRWHBUWD1ZklLr3Ue
         jJ6rjPhkvIUSUQUpNE9jSIRl/3sspLUK9zpz61ZMW1UFNy1mYqI/D/HP7w/xdsEkubBE
         uXjv6mQIfrvApv5Ypc3LFRHX3h7Yqb3rRLLIbM5z6Zio516KyM5yt2K1igKm7s0VQPNr
         hrlA==
X-Gm-Message-State: AOAM530yAOZJkyD8/NU5qdEZjYrU5T5+BxcpQlCToiTxvEBV3oLkSPMW
        QXZqmSnLUQ9A4ACRP3Cjz33TXorCvBOoqq57PLem2g==
X-Google-Smtp-Source: ABdhPJzRQYs9xMtL6uWdKACy4LYj8NjRc/WHONkTYnb65giEix9lTJqOkotPC3WrBp5cVQ+01FK/g1KFYFLuwN5g3L4=
X-Received: by 2002:a17:90a:d590:: with SMTP id v16mr33821256pju.205.1626856367721;
 Wed, 21 Jul 2021 01:32:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210721082058.71098-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210721082058.71098-1-andriy.shevchenko@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 21 Jul 2021 10:42:42 +0200
Message-ID: <CAMZdPi_SotoXgWHQxHyWnjVHs1M2t3xa8+qhsD21b_qcp+t_ag@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] net: wwan: iosm: Switch to use module_pci_driver() macro
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Intel Corporation <linuxwwan@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Jul 2021 at 10:20, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> Eliminate some boilerplate code by using module_pci_driver() instead of
> init/exit, moving the salient bits from init into probe.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
