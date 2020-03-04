Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2078117877D
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 02:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387411AbgCDBL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 20:11:28 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:44896 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbgCDBL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 20:11:28 -0500
Received: by mail-vs1-f66.google.com with SMTP id u24so78590vso.11
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 17:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/aM4CAj9ICNj/ibOV8Q5gAx6qK4daZIIhsp+e6ZLm3w=;
        b=kGkj+eD7XNvA4VRXbiZINghavk64lXRg36IYCaEPYB5lHbC+S23xZVzZgXiHq48aTW
         SVfcN8gpucy2z5tHE0hzvp8errYj2bDs6LjZygn7Fmg+4Vgshtadse216kk+2DwSn/j1
         r0vOnbX7RRiozbIXM4OsoP52wwuu1GtGPB8jc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/aM4CAj9ICNj/ibOV8Q5gAx6qK4daZIIhsp+e6ZLm3w=;
        b=dBuTjYUoucoTk4LM+DmYqHvZUTAdqSJpv7FMk2PkYQ5/a/IjxaSdJwp4Hu7J3fvYEz
         UMF65fUeJQlK2LoRQbuGE9uleyG8BEkQJyBaj9631uW3epib+RB6zvX3Rc+6IidIXNsI
         NR9LfpqRwxInZpnyaatDqnL89dpsV05ibumD0T1T+FGlTHY5R7EOlUfaNFTKZOtCNx9b
         hXGjnFn0uobqO/IJK24Pm7QeHoyTKFVjqzovhKPuQ7KhRRtJ5OTVWi6CgWflDTsicSsu
         l14s9ic5vHMUzlRbM3Oxr0M+GA0GVNZ7HMiUt6qlkmV8OCXutF1OsP+RmaoKb8jgxvyB
         +01A==
X-Gm-Message-State: ANhLgQ0bTFLgFnfBRFuKm+1Srfvd0b2ajMSkX4ax1q0SjCFS7Kaitc+1
        arVis5YaIOMtE4gxRy0ZY2t8hSvwBnolvjaKFuf8lQ==
X-Google-Smtp-Source: ADFU+vvVp81NKQ1iE/DA5zgNfLUZ2yCcBL+wpFPmDmdHGVvQiXoT8bvAPLcMGC/mbouJUTz5y5TxIFEgPkvWF/jpaBg=
X-Received: by 2002:a67:fc8c:: with SMTP id x12mr394289vsp.96.1583284285590;
 Tue, 03 Mar 2020 17:11:25 -0800 (PST)
MIME-Version: 1.0
References: <20200225000036.156250-1-abhishekpandit@chromium.org>
 <20200224160019.RFC.v3.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
 <CANFp7mUehaCSR2W3mXpq2s80YLJVfO2U8D_N+sRzJ2pMZQw1UA@mail.gmail.com> <3532949B-483D-4087-A94B-E9567878EC3E@holtmann.org>
In-Reply-To: <3532949B-483D-4087-A94B-E9567878EC3E@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Tue, 3 Mar 2020 17:11:14 -0800
Message-ID: <CANFp7mXEiAYEYNxcuo62uxEaZmotzEG=kygvmQi3Kk-QnctvjA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] Bluetooth: Add mgmt op set_wake_capable
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

Yes, I've sent up a v4. While enabling and testing these changes, I
found a bug (which I had originally implemented but missed during
various merges) where powered down and powering down adapters weren't
working.

I've ran the most recent series through a set of automated tests (on
4.19, 4.14, 4.4 and 3.18 kernels) and they are all passing now.

Thanks
Abhishek

On Mon, Mar 2, 2020 at 2:17 PM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Abhishek,
>
> > I seem to have forgotten to update the series changes here. In series
> > 3, I added a wakeable property to le_conn_param so that the wakeable
> > list is only used for BR/EDR as requested in the previous revision.
>
> are you sending a v4?
>
> Regards
>
> Marcel
>
