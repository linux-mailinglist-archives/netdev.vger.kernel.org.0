Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39EA48F9E1
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 01:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiAPAFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 19:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiAPAFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 19:05:54 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25EBC061574
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 16:05:53 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id w188so17914045oiw.13
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 16:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=23Mq0FaXyDcA835mlalF32uXVdyP2ZUcWj0onbMonNU=;
        b=oZm97Dnryv8zArDr3FNEGAc6UnqO8BMhV9CR7JVKqNiInL+evulF2CAszi0b+X7wKE
         VF7XVGEgKYqCqoy00s+nLTUNhTu2I3ugYVTQW7GBhOkaRXdDyxlKnUIOeoxrvsqPIq+8
         tf2rKlXAyd9aUYkagpUqUpm1PL03nIMs5QMSxUqSvpaY/14ubF7yxDlvdk+Mwwm2m1P0
         PquIUiDjEf1KirZ5Q/L5CI7HpDQqah29hScE3Y31Asapr/7PsxLIJYjAO9ZdHOrrAZpV
         BuK7cA+nUKEM/ngGMR1aF2mgoQo6QFP6nCGDaaoySxwpYpqyl0kP8ABcVrun1LPDAKQo
         nCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=23Mq0FaXyDcA835mlalF32uXVdyP2ZUcWj0onbMonNU=;
        b=dFoCy2y5Ss4IGe+uy8ugFMgij48iCQs3jepeXe97DjAlnwucqKX7J7CvD9IgIyRGbx
         GSOjUjEu3aPQ1jLIUuwsqVI6JON7PiIOznyKOGuf5IZtGu92lZK5fGlzoGSmos9bSeGP
         1zFNS9YjuxTNPnSKat0zavtdtvxopigbOxDk2yeDyIBD8ke45b7Xh1gO+iniyAZIcoAn
         EP1XYq2Bg+xhOPOxkFi03VjsNrFeiT4U3ItWHDRLqTZgHiRERPxUEJS7fJaBhxaxOmWT
         FhytAFGc9sOHNqdmBG3BpLz3B2QXjS3rdQZZUI4eEta/8CSGTwE9DdF1WVLXZcHWbT7x
         9Ksw==
X-Gm-Message-State: AOAM5336QvKK6kPXvOtlI/TOJ+/5j0lskD6RIMnYhr9rsmcfvYgyJ5BE
        OP9ldBqQPDM6lB9j2gmdI4s3Boec/nP7mp/k+2mDBQ==
X-Google-Smtp-Source: ABdhPJyYpBLfKKWkc4hnY0O4w1zAzcSdE1W5NDuGSzvJY3ungeufX1i9UVro/bRv7lqHS38fpaa9ye69nMKiw7dP0ec=
X-Received: by 2002:a54:4613:: with SMTP id p19mr12160553oip.162.1642291553261;
 Sat, 15 Jan 2022 16:05:53 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220105031515.29276-4-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-4-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 16 Jan 2022 01:05:41 +0100
Message-ID: <CACRpkdYCtnaTFVrxj7jmp0w4i0rV_q18R8krpfcLgGp+wOJaEw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 03/11] net: dsa: realtek: remove direct calls
 to realtek-smi
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 4:15 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> Remove the only two direct calls from subdrivers to realtek-smi.
> Now they are called from realtek_priv. Subdrivers can now be
> linked independently from realtek-smi.
>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
