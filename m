Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F78D3B9FF
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfFJQuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:50:23 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:50586 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbfFJQuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:50:22 -0400
Received: by mail-it1-f194.google.com with SMTP id j194so134941ite.0
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jigJfFRZkdX+fDWDB3Z6i7DXek+TxEO+iFMi0ontPyI=;
        b=NS6I1EfOS4Qln6O21W/qaWiFUMqu8lDW/jqsVurVgncwNQNmgiZ7ryVM5WNjFbA1tg
         6okpyEoD7k4sfn32wuY4Hw3AvMOSF+FH1cyzQTqePdpEc4PxU4V1MR7kC4tb8xOzYBLB
         9dcsOIODkMVEkDakGWmtbuSR/ZtezbmGzY+/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jigJfFRZkdX+fDWDB3Z6i7DXek+TxEO+iFMi0ontPyI=;
        b=X+FjikVKR6BHfpuT+sQL9D/bmSQHv3c0FL+rN2YthuX7BAiUDA4wlqIMpi+VCYZOkN
         XK4/wzrmZfuHsEBWHm/wkn7OtWxMz1QCQDH3m836fD/3Mh97Nt1z7PD7YLa3DUDg5uH2
         nyUDt+aDHUPRhMS3kn8BmHz9s8iGoUCcOLssGij5MuUDTd741cZK03OvjQkyiBbG2YmF
         V81ah2vcgZaZT1naBtA1bzC3Vm0nRUloE07Jfcw8vraU/zK0nP9UF+8RUNRBaP7AcgzF
         hHBMUtGM9Znrea/9W+QuOSpw95dhUsU1lSN11/gHoOwR96DCe0jlu1aHL+WjAmxWWrPB
         HY0g==
X-Gm-Message-State: APjAAAXECJ67Rt5jNjtkG18P7WN2Wvz8HZTbGdnXArBG6zRpspCNMIXv
        yBsuoGm4Wkx+3DIKM8MROJ/UJCKvGYc=
X-Google-Smtp-Source: APXvYqx5tYyCL2geOmA9ATzFCdcY7lZkWmeWz4F4vQWJRK8D+kmCkRrZuujDiekUEQhibTyNI63cQg==
X-Received: by 2002:a05:6638:281:: with SMTP id c1mr15826516jaq.43.1560185421915;
        Mon, 10 Jun 2019 09:50:21 -0700 (PDT)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com. [209.85.166.44])
        by smtp.gmail.com with ESMTPSA id c1sm3580783ioc.43.2019.06.10.09.50.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 09:50:20 -0700 (PDT)
Received: by mail-io1-f44.google.com with SMTP id u19so7411942ior.9
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:50:20 -0700 (PDT)
X-Received: by 2002:a6b:b642:: with SMTP id g63mr8234768iof.142.1560185419663;
 Mon, 10 Jun 2019 09:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190607223716.119277-1-dianders@chromium.org>
 <20190607223716.119277-4-dianders@chromium.org> <363DA0ED52042842948283D2FC38E4649C52F8A0@IRSMSX106.ger.corp.intel.com>
In-Reply-To: <363DA0ED52042842948283D2FC38E4649C52F8A0@IRSMSX106.ger.corp.intel.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 10 Jun 2019 09:50:06 -0700
X-Gmail-Original-Message-ID: <CAD=FV=U8eo78Ee9xjhGXJMv=8YF9o89KLX024GH3iBRnRjCRvQ@mail.gmail.com>
Message-ID: <CAD=FV=U8eo78Ee9xjhGXJMv=8YF9o89KLX024GH3iBRnRjCRvQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] brcmfmac: sdio: Disable auto-tuning around
 commands expected to fail
To:     "Hunter, Adrian" <adrian.hunter@intel.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        "mka@chromium.org" <mka@chromium.org>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jun 10, 2019 at 1:56 AM Hunter, Adrian <adrian.hunter@intel.com> wrote:
>
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/mmc/sdio_ids.h>
> >  #include <linux/mmc/sdio_func.h>
> >  #include <linux/mmc/card.h>
> > +#include <linux/mmc/core.h>
>
> SDIO function drivers should not really include linux/mmc/core.h
> (Also don't know why linux/mmc/card.h is included)

OK, so I guess you're requesting an extra level of "sdio_" wrappers
for all the functions I need to call.  I don't think the wrappers buy
us a ton other than to abstract things a little bit and make it look
prettier.  :-)  ...but certainly I can code that up if that's what
everyone wants.

Just to make sure, I looked in "drivers/net/wireless/" and I do see
quite a few instances of "mmc_" functions being used.  That doesn't
mean all these instances are correct but it does appear to be
commonplace.  Selected examples:

drivers/net/wireless/ath/ath10k/sdio.c:
  ret = mmc_hw_reset(ar_sdio->func->card->host);

drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:
  mmc_set_data_timeout(md, func->card);
  mmc_wait_for_req(func->card->host, mr);

drivers/net/wireless/marvell/mwifiex/sdio.c:
  mmc_hw_reset(func->card->host);

drivers/net/wireless/rsi/rsi_91x_sdio.c:
  err = mmc_wait_for_cmd(host, &cmd, 3);


...anyway, I'll give it a few days and if nobody else chimes in then
I'll assume you indeed want "sdio_" wrappers for things and I'll post
a v4.  If patch #1 happens to land in the meantime then I won't
object.  ;-)


-Doug
