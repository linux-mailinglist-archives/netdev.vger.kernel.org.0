Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4392C44EFBD
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 23:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhKLWxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 17:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbhKLWxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 17:53:16 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B437C0613F5
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 14:50:24 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id bk14so20613844oib.7
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 14:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vODi7QdVsXr5ltMsHWp2FnleR3mjZRfOo8/CUw9j+es=;
        b=M8edBYX7AF53kHQELBSlm84mGncbdzrpwtmcNx6TcpAU6cijvGMOcynVW5F0IdglzE
         p7UL1KV57VrYCFjmjBl0iheYUMGwJaL4sqfIFhCTIBIwfhUczA63C6gf2f3CBjRRkXd5
         NHsBF9M+k2vtvhKS0FWv5qoy+TjF0ZmRIaXvw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vODi7QdVsXr5ltMsHWp2FnleR3mjZRfOo8/CUw9j+es=;
        b=h8mFOXwUSe3TlRFhCAFJnqgo9+SBkdXbrK0ecDyZotfCNQqUkX5RQ/Cb0YZ1kt8Ovg
         Bff71IjRfuc6bhKPGD+w0qPzXbh7TSetWDjJCRyxSqyaT/TTjcg8oJ3Jt2oUv6jQkiwg
         WSoySmeQ1Bh+ItL+eOqdcT8wELxOHQZtZauH7CPXbut++Vs+Wo+QJlb51v+NNYk3SMik
         4wGfxf77Rzkobr8PuRGA/DOxQcYDExEMTr5Xu8gmtq4kMfRUYWDh4lMzYaLXNrP4CfKe
         3L7HnRrjcUO5npU1HiSC1d+4gPLSTi/iNIz/E2rCcGQ5KmTD8xXEzlptwCc9eZpVKjr8
         F2sA==
X-Gm-Message-State: AOAM532VXmd+UqpO04XbtbrI4lpwzKZG0i6r/GVFkrTnDA0AQFdGhk3T
        Jhfawc+Yjyp8F4488/6V0TfSu1qYS/Ocnw==
X-Google-Smtp-Source: ABdhPJzZqRVOfE8PbmG1QBrIlGDiSpTtEXuhFXNHgManqVq8E9J0Zv4Tzrg2Q7dOtzDs8BgpegWZKg==
X-Received: by 2002:a05:6808:1894:: with SMTP id bi20mr15901561oib.151.1636757423277;
        Fri, 12 Nov 2021 14:50:23 -0800 (PST)
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com. [209.85.210.49])
        by smtp.gmail.com with ESMTPSA id q81sm1690251oib.47.2021.11.12.14.50.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 14:50:21 -0800 (PST)
Received: by mail-ot1-f49.google.com with SMTP id z2-20020a9d71c2000000b0055c6a7d08b8so16061876otj.5
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 14:50:20 -0800 (PST)
X-Received: by 2002:a9d:6c2:: with SMTP id 60mr14670064otx.279.1636757420114;
 Fri, 12 Nov 2021 14:50:20 -0800 (PST)
MIME-Version: 1.0
References: <20211108200058.v2.1.Ide934b992a0b54085a6be469d3687963a245dba9@changeid>
 <17BDA821-9D4A-46C9-8C0E-F7DB35D50033@holtmann.org>
In-Reply-To: <17BDA821-9D4A-46C9-8C0E-F7DB35D50033@holtmann.org>
From:   Jesse Melhuish <melhuishj@chromium.org>
Date:   Fri, 12 Nov 2021 16:50:08 -0600
X-Gmail-Original-Message-ID: <CACGnfjTBtZ+1ey6+wF7hAVX23ty7yS9qEH0b6p+vzCLBWWPW0Q@mail.gmail.com>
Message-ID: <CACGnfjTBtZ+1ey6+wF7hAVX23ty7yS9qEH0b6p+vzCLBWWPW0Q@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Don't initialize msft/aosp when using user channel
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Jesse Melhuish <melhuishj@chromium.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

No problem, thanks. Happy to extend userchan-tester; do you mind if we
continue reviewing this patch for approval in the meantime so we can
mitigate the issue on our end?

On Thu, Nov 11, 2021 at 12:43 PM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Jesse,
>
> > A race condition is triggered when usermode control is given to
> > userspace before the kernel's MSFT query responds, resulting in an
> > unexpected response to userspace's reset command.
> >
> > Issue can be observed in btmon:
> > < HCI Command: Vendor (0x3f|0x001e) plen 2                    #3 [hci0]
> >        05 01                                            ..
> > @ USER Open: bt_stack_manage (privileged) version 2.22  {0x0002} [hci0]
> > < HCI Command: Reset (0x03|0x0003) plen 0                     #4 [hci0]
> >> HCI Event: Command Complete (0x0e) plen 5                   #5 [hci0]
> >      Vendor (0x3f|0x001e) ncmd 1
> >       Status: Command Disallowed (0x0c)
> >       05                                               .
> >> HCI Event: Command Complete (0x0e) plen 4                   #6 [hci0]
> >      Reset (0x03|0x0003) ncmd 2
> >       Status: Success (0x00)
> >
> > Signed-off-by: Jesse Melhuish <melhuishj@chromium.org>
> > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
> > ---
> >
> > Changes in v2:
> > - Moved guard to the new home for this code.
> >
> > net/bluetooth/hci_sync.c | 6 ++++--
> > 1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> > index b794605dc882..5f1f59ac1813 100644
> > --- a/net/bluetooth/hci_sync.c
> > +++ b/net/bluetooth/hci_sync.c
> > @@ -3887,8 +3887,10 @@ int hci_dev_open_sync(struct hci_dev *hdev)
> >           hci_dev_test_flag(hdev, HCI_VENDOR_DIAG) && hdev->set_diag)
> >               ret = hdev->set_diag(hdev, true);
> >
> > -     msft_do_open(hdev);
> > -     aosp_do_open(hdev);
> > +     if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> > +             msft_do_open(hdev);
> > +             aosp_do_open(hdev);
> > +     }
>
> but then you need to do the same on hci_dev_close. Also it would be good to extend userchan-tester with test cases for this.
>
> Regards
>
> Marcel
>
