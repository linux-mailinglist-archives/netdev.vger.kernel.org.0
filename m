Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D451539500
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbfFGS4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:56:51 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41076 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730290AbfFGS4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:56:49 -0400
Received: by mail-ed1-f65.google.com with SMTP id p15so4393720eds.8
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=pLHqHIiNEMpqBsq1VQWJdA+f/ogiGuALrvYvfOsre5w=;
        b=JKBmHUupUT1En6Wm/PaAfDvWLs9G4reHIL/Dq7a28RXjQhW1bvj1OuB26Otd3Nzv/F
         5ZMid02V6ON7krE7muBA6YEhkfXI5N+61Qho5iv95IBFh/MlqvIhkuqMpLLIh4Gx1vis
         dD6p2HlT0owEbyLmy2rgkQ9McTJKn+DOb7v3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=pLHqHIiNEMpqBsq1VQWJdA+f/ogiGuALrvYvfOsre5w=;
        b=Bugtqo1SaNvabYDJXnbLwUp+5cU35udKAQOY9XdWT84/i3IVF3J66yJYpCrY1uMvtH
         UM1DSeEWAXeI69dRVPM/7Gd4i0dV1pMSZ4BiGUO38jeHdQ2LwSKT2E1h2fGZyqccgkj7
         KOVUYxkReR3PnxP+DzH6esFzjHQcfuQlFa9i/wZCFYysfM5oR+HQwKC/juH6UTBQH8nf
         WkRwiHj97A5pZuzx6g4Yu+1pdeK3xZVrQT3LB9I45PJ+h5ap1Pcyz0iWrO4JxQPe4iOc
         CDiiZCPDParLGezEXiaDMQSe4r9nXLWTXJB8vXxYl1w7rB53GXdOnfg1VSmeCAtUj0f8
         fLww==
X-Gm-Message-State: APjAAAXh2dvCqi9OSAKIKadLwT1aPLJfMyy/6C3x8d4cnwrRU7LyKsUn
        BaJIWVDkw/8aotborTpyVudZuA==
X-Google-Smtp-Source: APXvYqy/QInNnOY8qOmxzPqvg5vvvunnvhTKvbvtqEaMLJvI0LfXEgZqTasv/6lBtFt2xGxRunVBpA==
X-Received: by 2002:a17:906:4ada:: with SMTP id u26mr28479238ejt.258.1559933807813;
        Fri, 07 Jun 2019 11:56:47 -0700 (PDT)
Received: from [192.168.178.17] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id f9sm501183ejt.18.2019.06.07.11.56.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Jun 2019 11:56:47 -0700 (PDT)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Doug Anderson <dianders@chromium.org>
CC:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Wright Feng <wright.feng@cypress.com>,
        "Chi-Hsien Lin" <chi-hsien.lin@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        "brcm80211-dev-list" <brcm80211-dev-list@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Franky Lin <franky.lin@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Michael Trimarchi <michael@amarulasolutions.com>
Date:   Fri, 07 Jun 2019 20:56:43 +0200
Message-ID: <16b334cd9f8.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <CAD=FV=XVmCYWe9rtTFakq8yu67R-97EPyAHWck+o3dRXzHCchQ@mail.gmail.com>
References: <20190603183740.239031-1-dianders@chromium.org>
 <20190603183740.239031-4-dianders@chromium.org>
 <42fc30b1-adab-7fa8-104c-cbb7855f2032@intel.com>
 <CAD=FV=UPfCOr-syAbVZ-FjHQy7bgQf5BS5pdV-Bwd3hquRqEGg@mail.gmail.com>
 <16b305a7110.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <ff0e7b7a-6a58-8bec-b182-944a8b64236d@intel.com>
 <16b3223dea0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <CAD=FV=XVmCYWe9rtTFakq8yu67R-97EPyAHWck+o3dRXzHCchQ@mail.gmail.com>
User-Agent: AquaMail/1.20.0-1451 (build: 102000001)
Subject: Re: [PATCH v2 3/3] brcmfmac: sdio: Disable auto-tuning around commands expected to fail
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On June 7, 2019 8:06:30 PM Doug Anderson <dianders@chromium.org> wrote:

> Hi,
>
> On Fri, Jun 7, 2019 at 6:32 AM Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>> Right. I know it supports initial tuning, but I'm not sure about subsequent
>> retuning initiated by the host controller.
>
> My evidence says that it supports subsequent tuning.  In fact, without
> this series my logs would be filled with:
>
>   dwmmc_rockchip ff0d0000.dwmmc: Successfully tuned phase to XYZ
>
> ...where the phase varied by a few degrees each time.  AKA: it was
> retuning over and over again and getting sane results which implies
> that the tuning was working just fine.

Ok. Thanks for confirming this.

Regards,
Arend


