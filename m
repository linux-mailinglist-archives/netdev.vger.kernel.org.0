Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9F33E26FE
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244300AbhHFJPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244091AbhHFJPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 05:15:37 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF41C061798;
        Fri,  6 Aug 2021 02:15:22 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id s13so1965548oie.10;
        Fri, 06 Aug 2021 02:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=msvlg61+FMMnpmyBPV+pIriFEH/ejI4VCVNLKTM5r+s=;
        b=Yl4jduFwo0Hq9Oc9EC2SrWqBPAbJkdOaXavmTj2zFJzvEEVKhFnnQvsKW9RqhbzoMH
         CN01CixRtVkG2x+yZN/LVSJVDRxWx0X1DVfl1RX9O0X/8PCZpTG+L2zP2DnzAypA7x54
         ZxSbQdKDFfaf3hsxLvIKPLs+V8y77i0pM3Ja5p0RnUwBCklXEbkhs4yCxzplQ/iqCRIT
         89BIHt+EmaJh95mpT+Y0fa+5PJKAGghfkuH5Qqno5K3ihxwHkPrx1Z3liXn76bjskV24
         7ET7xf0DFuTTsAyFwMgfU6Yet6b8nOAxWpt72PtV9m3Nsb7llkbBCOCVk0HezbMSg1/S
         +MKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=msvlg61+FMMnpmyBPV+pIriFEH/ejI4VCVNLKTM5r+s=;
        b=DjrCUB4hZrvKAOh133RMpwNrXj/cSzytD1jfHox2InHP/+xtup+ApwuKLFQOcWXWOA
         oT1SjMl/ibvHDOIsVEUKZGcrKIv69lm/vBUxIMMZ3a2/nXQKkPiahOkaJqA51OOgk11e
         O0CkZgPPVpdbuTqHb/VEfgq+n8O4yqEPi9SOfjl4ZtJweKJfyZXetjKEimppMPBm5JpT
         pZcJsovukogumEr181OcP795HKKvA2eK5+w75w9Gu5yXOqYeWkHYqyAfVVaxuGCHMGgQ
         o6F1QPmiWuBCiNIlZqqAnE0Epz1EiQ8CKpej+X1AIvmr5KXM9HBog1xBbHt9XH4JqDe8
         Eh6A==
X-Gm-Message-State: AOAM533LWosU8n52WJ22H4MtsEVRmPWxz9jCOtwZ1i8Kv0lQbn44q/bh
        Da6EUL08EK80gyfM2L9uxllseilfl28E46DpK0M=
X-Google-Smtp-Source: ABdhPJxgKSg+RxBruJaZHGRtNQqEqEOO2iM/Nx73ndB2zZK+fnx6VJKW3qgoL+fK3e//+glSoMm55BLdYwKVKBflBqc=
X-Received: by 2002:aca:1817:: with SMTP id h23mr6692129oih.146.1628241321514;
 Fri, 06 Aug 2021 02:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210806085413.61536-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210806085413.61536-1-andriy.shevchenko@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 6 Aug 2021 12:15:10 +0300
Message-ID: <CAHNKnsSLQ9QpOk+YqqVKj3hJEJXMPGpazBV_hWngj2bwLp8LSQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] wwan: core: Avoid returning NULL from wwan_create_dev()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 6, 2021 at 12:00 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Make wwan_create_dev() to return either valid or error pointer,
> In some cases it may return NULL. Prevent this by converting
> it to the respective error pointer.
>
> Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> v2: rewrote to return error pointer, align callers (Loic)

Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
