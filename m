Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06A23B73BF
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhF2OHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhF2OHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:07:10 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E920CC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:04:42 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id s137so9641521pfc.4
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FAUe2Np2sl1yuVgMKxxvlqxQAgPzbv4Do3g4DfIpijA=;
        b=vYw+EqKX/lKyiHLo4yOv7wyyL4wwqMqKLxx25dGoJZqwThfczOkBOLHuO2UV0wb1r8
         +ReC2s1lZp7eRZg3ReuHwyuP1KDewKtOktRdoVJ10jrvo5NAeRpJlqaPG3tx9pmIT+RU
         X8l/MPuL+L+yltJjBC3C/n1N0uVwR0aJg9NV8eqsmM2y9kJk9Kfi1FNfnydKdMXx69bc
         bPEB754Z1GoUh1SVa2C+OFnYWBFcxLp9ZPJMOjKaA3oXr/pwt6sL6PGJr3e8adbHh7zZ
         VAqgdxi+cTrODfxuPDw+Y0t3kU89RCTBWjyxUrTSSog39xykeyYmXeeZ8ehdISvYMDdo
         CPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FAUe2Np2sl1yuVgMKxxvlqxQAgPzbv4Do3g4DfIpijA=;
        b=rWrdJwVNI96z2amaQsu9CyU67ZheyAZEJSh29eiRWBEo9F0DKkR3ZDZT3dq5HKonO0
         ozXHgCSGPkzpv6wHsv5nPAhVcnTaPoyxaAFsQUFXG5ErbtBiWIAjr6HlFsSveEpG/EsI
         hzn/wcW46OQU+HcUYTax0j7IPDPalhoG6LncgWK1KshAhBUiImPfSGloTUUukLtRMU5Z
         Bs97zFYUWaMrYDJ99JrxdBEeKxanJ9Oq9esNXBj+Mj+5oZDeL4VLWL5bIrizPt2SgQ/2
         7kpO/qO1gxZxw14E7DF51xieyguJk/yob2E/t2uYL58eAauO69xl5+ygG4Kv6c1fCLrn
         NErA==
X-Gm-Message-State: AOAM530/6AU+t3oUiUk621ac2xtniwXKW0vcvPZmcmhRp+hXG8jVoVSe
        nZTtIsCNqEk8QFOlGQrXyGDg+huvz1D3m0i5ws2NoA==
X-Google-Smtp-Source: ABdhPJzY2u7ghKTS6SNb8XjIeJHNcpif+6nwRkgA9ep6kDC5l83aGa8d5Wo/JwXCmr+XWqAgGxpvs3UGdTM0pG8GT8E=
X-Received: by 2002:a63:1215:: with SMTP id h21mr28250062pgl.173.1624975482321;
 Tue, 29 Jun 2021 07:04:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-7-ryazanov.s.a@gmail.com>
 <CAHNKnsR5X8Axttk_YX=fpi5h6iV191fLJ6MZqrLvhZvPe==mXA@mail.gmail.com> <1d31c18cebf74ff29b5e388c4cd26361@intel.com>
In-Reply-To: <1d31c18cebf74ff29b5e388c4cd26361@intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 29 Jun 2021 16:14:05 +0200
Message-ID: <CAMZdPi9bqTB8+=xAsx3C6yAJdf3CHx9Z0AUxZpFQ-FFU5q84cQ@mail.gmail.com>
Subject: Re: [PATCH net-next 06/10] net: iosm: drop custom netdev(s) removing
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chetan,

On Sun, 20 Jun 2021 at 17:42, Kumar, M Chetan <m.chetan.kumar@intel.com> wrote:
>
> Hi Sergey,
>
> > On Tue, Jun 15, 2021 at 3:30 AM Sergey Ryazanov
> > <ryazanov.s.a@gmail.com> wrote:
> > > Since the last commit, the WWAN core will remove all our network
> > > interfaces for us at the time of the WWAN netdev ops unregistering.
> > > Therefore, we can safely drop the custom code that cleaning the list
> > > of created netdevs. Anyway it no longer removes any netdev, since all
> > > netdevs were removed earlier in the wwan_unregister_ops() call.
> >
> > Are you Ok with this change? I plan to submit a next version of the series. If
> > you have any objections, I can address them in V2.
>
> Changes looks fine.
>
> > BTW, if IOSM modems have a default data channel, I can add a separate
> > patch to the series to create a default network interface for IOSM if you tell
> > me which link id is used for the default data channel.
>
> Link id 1 is always associated as default data channel.

Quick question, Isn't your driver use MBIM session IDs? with
session-ID 0 as the default one?

Regards,
Loic
