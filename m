Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AADB8E70
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 12:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438087AbfITKXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 06:23:52 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38215 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408660AbfITKXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 06:23:51 -0400
Received: by mail-qt1-f194.google.com with SMTP id j31so8038348qta.5
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 03:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4KRYh78mW4SdPF70IJ1RhDBVtlq4LObNU1qGDDQxBs0=;
        b=tOoNnDAmZES+tYlRwv1BDJ5tc/c8uonUgoCJSanG/N6cxUUYQoeu5LP1MxcyskPr7+
         9tDDCvJLigvz3UwafsvzuE++dDIpk6xSb5AU1UMFGIwZzm+Sr81VHNni+jl729noqpAF
         i9ksNxKYjkPAw49oj/maGCIQ/qef2i/NVdTNwkvXC8gPONA9jB8igaMmwBrciL1s3G5s
         8xt0/L7/Mq3C5hoLiRgdPB0euTb5vzE/KGbeoowsaOG0qzgV8UgPagJZxPcJEK+wTjFQ
         46KRAOfX/sibqEp054jtv0xOSN6wOdVVN1vfXUBdae0IPYifLcZsZzvwdvdP6aGv5gV+
         xVAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4KRYh78mW4SdPF70IJ1RhDBVtlq4LObNU1qGDDQxBs0=;
        b=sL142vp127w3E3QYi58TK0MZvg8zywEAwzpleEMFzRfFqwRiRU8mR1rTIoGHj4/wJ5
         3uujVzBKwBM2odu/fbAbCvwxo/+XZloACSUTuTYa0gj/KlmdpCewkkJ7s2tmQhkp2u28
         2FhzYX5UHQ6hHtfVrE2IU1+IEk96ZmpDalYelFYque3tIQICeO+ybJz0lQXL/olUPLyU
         M0LIJMfKvFCrOr62SXDhKxLjviykgIwJhXn4Ze0n/gvj9o4VO9KFQmXdUSq22JzTDE95
         9PguoPV0VCglEPuSCBKwP0Pdf7pwN26GuWv2c27mRtUelZ5p8FaFNuLB35e3LsT++yvi
         ogdw==
X-Gm-Message-State: APjAAAU37FLuaHhGUl+iRJqxk4RPpOWHr3NO6t8l8eh4dqKCsIcfH5ci
        o/+XHnKNpVp9ShFNTKYIuq7N4Uj543BaZFkoYwbz3A==
X-Google-Smtp-Source: APXvYqycUexjcYpUbAA6viTRHrluaYbe8beqhFKg88II3Oyet91p8bdZ1huPfn6oJReTol4y7D3T60HEKnuPzIRpUTY=
X-Received: by 2002:ac8:7310:: with SMTP id x16mr2416972qto.382.1568975030782;
 Fri, 20 Sep 2019 03:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190920030043.30137-1-navid.emamdoost@gmail.com>
In-Reply-To: <20190920030043.30137-1-navid.emamdoost@gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Fri, 20 Sep 2019 18:23:40 +0800
Message-ID: <CAB4CAwf34TFGqTCz0BGGj3MC4pTTW10qvfJaPsNxMcXB6_EbEg@mail.gmail.com>
Subject: Re: [PATCH] rtl8xxxu: prevent leaking urb
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 11:01 AM Navid Emamdoost
<navid.emamdoost@gmail.com> wrote:
>
> In rtl8xxxu_submit_int_urb if usb_submit_urb fails the allocated urb
> should be released.
>
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Chris Chiu <chiu@endlessm.com>


> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -5443,6 +5443,7 @@ static int rtl8xxxu_submit_int_urb(struct ieee80211_hw *hw)
>         ret = usb_submit_urb(urb, GFP_KERNEL);
>         if (ret) {
>                 usb_unanchor_urb(urb);
> +               usb_free_urb(urb);
>                 goto error;
>         }
You're right. There's a usb_alloc_urb in the beginning of this
function and should be
handled after submit failure.

Chris
