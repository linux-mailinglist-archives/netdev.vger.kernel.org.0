Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBA8402F1F
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346071AbhIGTtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbhIGTtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 15:49:19 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A9FC061757
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:48:13 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id o16-20020a9d2210000000b0051b1e56c98fso506900ota.8
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 12:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=w+pEkVJd/h+WI+7Ik9xWqY+Z8oL6sb51sITpdGLwuE0=;
        b=ZfXkyFLoNLwSCxIt2lcXw2d4jOGw2BhBPBTFYcXhipfSjLsFGRUgNK6ftpTAP5TXWq
         ruwHEv5trPt3h2I/CyAqcbyOo83YrThS3Kjacjot2cOxAKpRgjgr1lQizsZ7yTchvihV
         ErsPeqGVBrbrrKzNFlwtX95iDjPuVYP5wRuiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=w+pEkVJd/h+WI+7Ik9xWqY+Z8oL6sb51sITpdGLwuE0=;
        b=MdQO1YpyVwmR1SZdQ3utlvpVMHqzrlwqeHAVs2Ae0IGRZbc2d0Mi1PUgVYWO9thaRf
         uVzp/RO057x1y0gojxvB4MX6wu5dCk0BCNc7jxYqbOVQ768K2CcdpVsIywl4xkZAlWGO
         Rl9djSi20YdNnKkUWinquqm2gTMTntNqJrO5NLyL8WcfQ96KBqoj/RGcdCXUvihtAd7y
         8czJo+hyM05JcTKETjGfhrc3xYSxHf/ps8YkIOvGzgvb0ibltiGqZthCBZ57v54AYDPn
         cbraHd3ZhGiv2WVh/U0njdke9lI2aWb9eHneFxX4MKiWzVjkrBEXjMtIRl5pSlhIX8lG
         aaug==
X-Gm-Message-State: AOAM532S/MGKmLxYmtBcNKmu5gk/DGYQEPrxvaHMDfW9Ls+h2maOFqde
        8iht8+XJEoz7csnFjGD3NFhVIQ0B7/iDrj1Gs3g8IfWfL4U=
X-Google-Smtp-Source: ABdhPJxksUjTUTa8Exx6uQm/t3KaU/loUjkBf+4L6i+ATrGe4465p6dpfz+D435OVm1pzqfNM6HNZXNRx4Iq1MprmqA=
X-Received: by 2002:a05:6830:1212:: with SMTP id r18mr58677otp.159.1631044092581;
 Tue, 07 Sep 2021 12:48:12 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 7 Sep 2021 19:48:11 +0000
MIME-Version: 1.0
In-Reply-To: <YTe+a0Gu7O6MEy2d@google.com>
References: <20210905210400.1157870-1-swboyd@chromium.org> <YTe+a0Gu7O6MEy2d@google.com>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.9.1
Date:   Tue, 7 Sep 2021 19:48:11 +0000
Message-ID: <CAE-0n52d_GBh70pSDXTrVkD5S6akP4O9YcE4tVRKZcvLtLZSmg@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Don't always treat modem stop events as crashes
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Youghandhar Chintala <youghand@codeaurora.org>,
        Abhishek Kumar <kuabhs@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Matthias Kaehlcke (2021-09-07 12:32:59)
> On Sun, Sep 05, 2021 at 02:04:00PM -0700, Stephen Boyd wrote:
> > @@ -1740,10 +1805,19 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
> >               goto err_fw_deinit;
> >       }
> >
> > +     ret = ath10k_modem_init(ar);
> > +     if (ret) {
> > +             ath10k_err(ar, "failed to initialize modem notifier: %d\n", ret);
>
> nit: ath10k_modem_init() encapsulates/hides the setup of the notifier,
> the error message should be inside the function, as for _deinit()

Sure. I can fix it. I was also wondering if I should drop the debug
prints for the cases that don't matter in the switch statement but I'll
just leave that alone unless someone complains about it.
