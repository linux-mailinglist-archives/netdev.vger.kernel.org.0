Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1873F2F6B2
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbfE3E6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:58:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41226 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389157AbfE3E6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 00:58:30 -0400
Received: by mail-qt1-f195.google.com with SMTP id s57so5480596qte.8
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 21:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rLmgEjHoFbZEgDIpNdCHV3eTKhj4yByl9zF5X6YEDyU=;
        b=RPnZUCBgRQHtYNK14mI5pN632nIxFQ9nLcYN1I5h78/zyx3v50ePjNHdlKRtRu/G3C
         hWbB0se/iWL0ROpD9gWbN28s4bBolC9R9WmpJRKZC2D8eoPKqSvW0def9L5GLi1i/Wry
         /pDU7Y8f9zQecUtCv0HO2QRN3jWQE9FmsnMbyQOFm7EnrJeXK4zBTV7Hn3MZXpoe51Kq
         iXtMHowwtmYgFLmJ7S19FxXG5pOdjdcZ/Is90S8cWSvOKjbufCIYwRFwMViwfBAhxYg0
         Yt+jtrrJdpuLDcqwyEaSLafp6AHzuWRI7L9f2qdZE+jVHczQoWI41SvYEzs+Bx/Nuat3
         gadg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rLmgEjHoFbZEgDIpNdCHV3eTKhj4yByl9zF5X6YEDyU=;
        b=kIrYreNvYU7i6tJko8YYZ28O4b+K7gcE2yceR9Ed9op7u2uuc0eB+a/tIhlKGliET1
         zFVRc7lZNaU2x81TrCwn9dcNrROXRRW6mWtl/mb7qTPPqtnSgpoO62H5Z2BSgdo3vNpo
         XaY20l9jmk9vXpGz/Fu/xInROEBTpgJqekOp5pioWGuJo+0T6WI1JptG56lJg6FpWETO
         ju5oeoe8QPbJuw/0PUIlJotU+5Vm9thQKSSC+qkMgYUeIP1ib/L0byNYrmYQ5P8rWLOn
         7ofjXLjlS1m+CNbR3FFFrcWbYjCkPNb/WGM1ZPxSVSOVBmwtYqgqlZjtiOj6d3QK86zT
         qWEA==
X-Gm-Message-State: APjAAAUEr5RPIkKudgkjUQBo2SbK0N4yTk+wH1RuznheiNxmCIE8Xdtu
        394uMERd6jGzrfGIUOfIVdLHaen4sd3KVCh0YbQwrA==
X-Google-Smtp-Source: APXvYqykJVzyUNjoIJTxPOCOl5J357hUfTlOmm8qycXoUfA80/eqCZBpMHgAh/kbPPhBE08WD9UbtmZTxYfSv0n8FEA=
X-Received: by 2002:a0c:be87:: with SMTP id n7mr1524590qvi.65.1559192309628;
 Wed, 29 May 2019 21:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190529050335.72061-1-chiu@endlessm.com> <5f5e262d-aadb-cca0-8576-879735366a73@lwfinger.net>
In-Reply-To: <5f5e262d-aadb-cca0-8576-879735366a73@lwfinger.net>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Thu, 30 May 2019 12:58:18 +0800
Message-ID: <CAB4CAwdB_8f-JZWWpXdYDghaGQv+Kc4H=G4UUrEK-_xbNg4Ctw@mail.gmail.com>
Subject: Re: [RFC PATCH v3] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 2:22 AM Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> On 5/29/19 12:03 AM, Chris Chiu wrote:
> > We have 3 laptops which connect the wifi by the same RTL8723BU.
> > The PCI VID/PID of the wifi chip is 10EC:B720 which is supported.
> > They have the same problem with the in-kernel rtl8xxxu driver, the
> > iperf (as a client to an ethernet-connected server) gets ~1Mbps.
> > Nevertheless, the signal strength is reported as around -40dBm,
> > which is quite good. From the wireshark capture, the tx rate for each
> > data and qos data packet is only 1Mbps. Compare to the driver from
> > https://github.com/lwfinger/rtl8723bu, the same iperf test gets ~12
> > Mbps or more. The signal strength is reported similarly around
> > -40dBm. That's why we want to improve.
>
> The driver at GitHub was written by Realtek. I only published it in a prominent
> location, and fix it for kernel API changes. I would say "the Realtek driver at
> https://...", and every mention of "Larry's driver" should say "Realtek's
> driver". That attribution is more correct.

Thanks. I'll modify this in next revision.

> >
> > After reading the source code of the rtl8xxxu driver and Larry's, the
> > major difference is that Larry's driver has a watchdog which will keep
> > monitoring the signal quality and updating the rate mask just like the
> > rtl8xxxu_gen2_update_rate_mask() does if signal quality changes.
> > And this kind of watchdog also exists in rtlwifi driver of some specific
> > chips, ex rtl8192ee, rtl8188ee, rtl8723ae, rtl8821ae...etc. They have
> > the same member function named dm_watchdog and will invoke the
> > corresponding dm_refresh_rate_adaptive_mask to adjust the tx rate
> > mask.
> >
> > With this commit, the tx rate of each data and qos data packet will
> > be 39Mbps (MCS4) with the 0xF00000 as the tx rate mask. The 20th bit
> > to 23th bit means MCS4 to MCS7. It means that the firmware still picks
> > the lowest rate from the rate mask and explains why the tx rate of
> > data and qos data is always lowest 1Mbps because the default rate mask
> > passed is always 0xFFFFFFF ranges from the basic CCK rate, OFDM rate,
> > and MCS rate. However, with Larry's driver, the tx rate observed from
> > wireshark under the same condition is almost 65Mbps or 72Mbps.
> >
> > I believe the firmware of RTL8723BU may need fix. And I think we
> > can still bring in the dm_watchdog as rtlwifi to improve from the
> > driver side. Please leave precious comments for my commits and
> > suggest what I can do better. Or suggest if there's any better idea
> > to fix this. Thanks.
> >
> > Signed-off-by: Chris Chiu <chiu@endlessm.com>
>
> I have not tested this patch, but I plan to soon.
>
> Larry
>
>
