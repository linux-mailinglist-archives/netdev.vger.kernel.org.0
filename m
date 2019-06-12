Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F5C424BC
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 13:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbfFLLtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 07:49:35 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:37942 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729607AbfFLLtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 07:49:35 -0400
Received: by mail-ua1-f67.google.com with SMTP id j2so5777292uaq.5
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 04:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fL5+yAvFpszDdwrzAhEA7Ye5Luf0zjBze5h9taUU+T8=;
        b=IWDvMyC9P5AiIW64CutGGY3WzwhVrLGaAwN6J8EHfw77V8yPYgGHANQJg8t7eiy16v
         uMqvroecwGxZQhVf/oKmaAoo3x8Zv6b+o3OUoxe8P5B/4oLM4GhchWkpjqvRt+VvIA3l
         OJa17Pfk4PgfzzVZjGVPa3deTyFnbxuDADm7WJ9Sc4pnYOc18CjiqS7J44hKqeXxDKCr
         piablk8wr9MlnupnliBftfIn4flYndyYx6WkOtHT3Ju+Yeph+UIiWKaVCoxSyXhYEyIM
         27B1y+7ahTL2MLr2dgibSIN4AwXg/MjbIfq1YkfB3kyLgGXCBK9ZErt71PtnX/DZhIjk
         4Rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fL5+yAvFpszDdwrzAhEA7Ye5Luf0zjBze5h9taUU+T8=;
        b=NkIk81AJS64Z+lYoE9ANq+FUBSG5sJW6i19KuaGMJ+hB1wJf0zkaC3Q/TWIo/2Xxl6
         xgc3EyzrfQxTyzAbI6p8bGVPgSVfUcGHYC62CBcocfjo6cdcwHPaE6GtHI4WW3poit0q
         qmgTitmUdvq+xV2+XAHFANuen4XovbzS4aYmKr/zOHLtCxXmBIZz0SYavXjOsKTl2mhS
         cfjSjA14JD3xbrn0q7uCyGSMDxXHIxDrrARKH6Uufx0XmQGujEYDvWRuDkw8ikNdm2mq
         Z1lcBfMclf+8nydzQ7wSzJ5IYlmnIFvBYb8PilXfI50RXpqXO+V+U7XbwGPPe6rFSfrW
         E0JA==
X-Gm-Message-State: APjAAAWvsAx04486YNu4KsXerthBxCMrx0WbpSiMO6l6YsR9NotndP4v
        Bl3dn4NqcDqaf2WkcYshfHzpezleh6MICayLoKfKsw==
X-Google-Smtp-Source: APXvYqy9Znw8HxyqdcJxmFY7a6Iw36a1N9tWz9NbjPT8mcjJotx9MWPFEjWPSQY9+rfUfMt64hGDugr+7AVqGSrtZqY=
X-Received: by 2002:ab0:2705:: with SMTP id s5mr576634uao.104.1560340174391;
 Wed, 12 Jun 2019 04:49:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190607223716.119277-1-dianders@chromium.org>
 <20190607223716.119277-4-dianders@chromium.org> <363DA0ED52042842948283D2FC38E4649C52F8A0@IRSMSX106.ger.corp.intel.com>
 <CAD=FV=U8eo78Ee9xjhGXJMv=8YF9o89KLX024GH3iBRnRjCRvQ@mail.gmail.com>
 <CAPDyKFo=QMRTkNYUVSE2AqiZgytkTVRXF0Mvznn6trVT4-cR=Q@mail.gmail.com> <c7c6d3f4-ebb1-8964-0616-973fae1ab47d@broadcom.com>
In-Reply-To: <c7c6d3f4-ebb1-8964-0616-973fae1ab47d@broadcom.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 12 Jun 2019 13:48:57 +0200
Message-ID: <CAPDyKFpM0+FfvoMo8Z_hxM9rzSjeQZHCsA2SPa8WP+SRDhhsPA@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] brcmfmac: sdio: Disable auto-tuning around
 commands expected to fail
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Doug Anderson <dianders@chromium.org>,
        "Hunter, Adrian" <adrian.hunter@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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

On Wed, 12 Jun 2019 at 13:11, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> On 6/12/2019 12:10 PM, Ulf Hansson wrote:
> >> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:
> >>    mmc_set_data_timeout(md, func->card);
> >>    mmc_wait_for_req(func->card->host, mr);
> > These are not okay, none of these things calls should really be done
> > from an SDIO func driver.
> >
> > It tells me that the func driver is a doing workaround for something
> > that should be managed in a common way.
>
> We are using some low-level functions passing chain of skbuff to the
> device using CMD53 with scatterlist. If I recall correctly Marvell made
> an attempt to have a similar function for it in the mmc stack. Not sure
> if that ever made it in. If so I can rework our driver using that API.
> If not, I can make a new attempt.

I recall there were some patches, but not sure why we didn't merge them.

Anyway, if you want to move this forward, that would be awesome!

Kind regards
Uffe
