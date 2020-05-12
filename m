Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409271CFB69
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 18:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgELQ5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 12:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgELQ5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 12:57:05 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06DEC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 09:57:04 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id v5so7081296lfp.13
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 09:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=soB2T7jMfJPtP5H3MNhiTe8IwYHJSi7NbmavIdokrOw=;
        b=crUTI9DBwo1cPu+KhFehaihTnypYtCw55ruTD7lVh8znQdy9XZk/8FGzr8uT3FK2iV
         hRIiPsNa753rxUMiEk5p3b5zJ6y4SQ9lMrHEh4BNB0f0LNwzwPRwYUux8eaG4K48fgZE
         QLAuHslKPqD8iz0uGuPmhKPpNIIpnqwyweDz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=soB2T7jMfJPtP5H3MNhiTe8IwYHJSi7NbmavIdokrOw=;
        b=E/Tgm0fctnZpH69Fekm3ASS8IL9OFgnjZw2f66xnM/qqIdKf616P02+GFnDzWVufp8
         Qq345YL14HVwJNtTdeClFNawDOpI6Gi/IL+N3wMTesSpYK2uE722vGv3zmNwG9tq6tBr
         cUWs3UNNzIu3xwf7yimRY8bkNPqRJl9laEAfbsPvmVxmiGXjkLC93CSiyWQ0/TImq6Tg
         bGiYgd8Lhh73K+eshVwy3gzNY3ZN6ge0fFpUVQri7EluAVI3QA0GdONh1FEu5Kqzjdoo
         tDfjmsyJ7BRryRTrQVc0aSwVyORJcMawMEMfkqr35okqJMXG2JmcrGYrIzotc48rGbP/
         Si3w==
X-Gm-Message-State: AOAM531mRq5ffHdgJAMfYzyXyRRRiPaX48erf/iydWHcjOQbycwGC7QE
        uSsEsn0f8n6UowHCKPvQ7fnYbSxs5lE=
X-Google-Smtp-Source: ABdhPJxUgth9o4DZQ0qZN8B1fHKNEFOqUrxKXpIzZKKWZeyRp/d+iTYWyEqfZQfLfIOfLbEqOhHN4g==
X-Received: by 2002:a19:8809:: with SMTP id k9mr14897466lfd.151.1589302622306;
        Tue, 12 May 2020 09:57:02 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id s7sm14471726lfb.40.2020.05.12.09.56.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 09:56:59 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id h26so11175571lfg.6
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 09:56:59 -0700 (PDT)
X-Received: by 2002:a19:5518:: with SMTP id n24mr15139341lfe.61.1589302618801;
 Tue, 12 May 2020 09:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190906185931.19288-1-navid.emamdoost@gmail.com>
In-Reply-To: <20190906185931.19288-1-navid.emamdoost@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 12 May 2020 09:56:47 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMnp-GTkrT7B5O+dtopJUmGBay=Tn=-nf1LW1MtaVOr+w@mail.gmail.com>
Message-ID: <CA+ASDXMnp-GTkrT7B5O+dtopJUmGBay=Tn=-nf1LW1MtaVOr+w@mail.gmail.com>
Subject: Re: [PATCH] ath9k: release allocated buffer if timed out
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, Kangjie Lu <kjlu@umn.edu>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 11:59 AM Navid Emamdoost
<navid.emamdoost@gmail.com> wrote:
>
> In ath9k_wmi_cmd, the allocated network buffer needs to be released
> if timeout happens. Otherwise memory will be leaked.
>
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

I wonder, did you actually test your patches? I ask, because it seems
that all your patches are of the same mechanical variety (produced by
some sort of research project?), and if I look around a bit, I see
several mistakes and regressions noted on your other patches. And
recently, I see someone reporting a 5.4 kernel regression, which looks
a lot like it was caused by this patch:

https://bugzilla.kernel.org/show_bug.cgi?id=207703#c1

I'll propose a revert, if there's no evidence this was actually tested
or otherwise confirmed to fix a real bug.

Brian
