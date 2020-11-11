Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB4E2AE703
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgKKDXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgKKDXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 22:23:30 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97996C0613D4
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 19:23:30 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id p7so840912ioo.6
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 19:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MtCTLPr/nLLPjkd638N9S+CTPL+nfBQ/x6OWapsdMSc=;
        b=TL0wdX7NjDApkOvujstE3i4F3uawHe37ZQIrUQ5qhGv0zg7FThLK65TVKp91AjchZv
         XrKLn3g1Fj3ahN2tmbzTiZmUfL+19TYvGenISURXld2/StkpYsSrBz/Y2Wil19SWN4Jz
         QMs5R/maEnYYDBUr9W3+r1cXuAGzT9XeMorGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MtCTLPr/nLLPjkd638N9S+CTPL+nfBQ/x6OWapsdMSc=;
        b=C5CEiKk/zknv3mNPrxzLzZD45Ad+KOTNYmZ08Ga3F9Hz389gX1AwoKwcwgaNp9nEBH
         EWKOWrGDk92h3wUtfISamyb2xLwyP1bA57KsgS8Emk8EFT0AqHI2qa67AW59OTwyQ7f/
         T0KMG/lg67/8OwcBxkg0mjv55r5GRj0tSuWcf1un6N0hWuh7HZVL/+R3b9oY18KfR0Yo
         oZTkwLajVFCR8VIooQDrg8RfaVTbP34epmbsxDORUl+qxtBdlO7kXqohug6PQFpTmvcl
         o0l3y/RFew57yr81A6XYqnL0WhdWyoD+yjgF2OT7nuZtEyC4OzGqkCiwSUaWIF3i8tVm
         Me8g==
X-Gm-Message-State: AOAM533Nc74yu4ci1FZ59qqzANy8aN5JnU2yeaGob0Z4oLI7bWOR8R37
        4qnGHzKRPwVOKlC7Xi65NGH7AL66p/qQnA==
X-Google-Smtp-Source: ABdhPJw0JPZ1Wtrw3V8t5c7qF/V65Lfd7p2B7WX8g1oao+2H0qm/vwnlOODTO0BfexAfd9jl4Gdw7A==
X-Received: by 2002:a05:6602:2c92:: with SMTP id i18mr17122324iow.18.1605065009616;
        Tue, 10 Nov 2020 19:23:29 -0800 (PST)
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com. [209.85.166.43])
        by smtp.gmail.com with ESMTPSA id y19sm414672iol.9.2020.11.10.19.23.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 19:23:28 -0800 (PST)
Received: by mail-io1-f43.google.com with SMTP id s24so806565ioj.13
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 19:23:28 -0800 (PST)
X-Received: by 2002:a5d:89c6:: with SMTP id a6mr10292848iot.69.1605065008201;
 Tue, 10 Nov 2020 19:23:28 -0800 (PST)
MIME-Version: 1.0
References: <20201110084908.219088-1-tientzu@chromium.org> <3b851462d9bfd914aeb9f5b432e4c076f6c330f3.camel@sipsolutions.net>
In-Reply-To: <3b851462d9bfd914aeb9f5b432e4c076f6c330f3.camel@sipsolutions.net>
From:   Claire Chang <tientzu@chromium.org>
Date:   Wed, 11 Nov 2020 11:23:17 +0800
X-Gmail-Original-Message-ID: <CALiNf29ku1aBiaBEg9ZTe7USSZZiOwnZWW3NKZgSGZ6M+GAX7w@mail.gmail.com>
Message-ID: <CALiNf29ku1aBiaBEg9ZTe7USSZZiOwnZWW3NKZgSGZ6M+GAX7w@mail.gmail.com>
Subject: Re: [PATCH] rfkill: Fix use-after-free in rfkill_resume()
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, kuba@kernel.org, hdegoede@redhat.com,
        marcel@holtmann.org,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 1:35 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2020-11-10 at 16:49 +0800, Claire Chang wrote:
> > If a device is getting removed or reprobed during resume, use-after-free
> > might happen. For example, h5_btrtl_resume()[drivers/bluetooth/hci_h5.c]
> > schedules a work queue for device reprobing. During the reprobing, if
> > rfkill_set_block() in rfkill_resume() is called after the corresponding
> > *_unregister() and kfree() are called, there will be an use-after-free
> > in hci_rfkill_set_block()[net/bluetooth/hci_core.c].
>
>
> Not sure I understand. So you're saying
>
>  * something (h5_btrtl_resume) schedules a worker
>  * said worker run, when it runs, calls rfkill_unregister()
>  * somehow rfkill_resume() still gets called after this
>
> But that can't really be right, device_del() removes it from the PM
> lists?

If device_del() is called right before the device_lock() in device_resume()[1],
it's possible the rfkill device is unregistered, but rfkill_resume is
still called.
We actually hit this during the suspend/resume stress test, although it's rare.

I also have a patch with multiple msleep that can 100% reproduce this
use-after-free. Happy to share here if needed.

[1] https://elixir.bootlin.com/linux/v5.10-rc3/source/drivers/base/power/main.c#L919

Thanks,
Claire

>
>
> johannes
>
>
