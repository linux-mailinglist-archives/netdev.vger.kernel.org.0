Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C02CA9B7
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 18:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404143AbgLARaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 12:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404118AbgLARai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 12:30:38 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16F3C061A47
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 09:29:55 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id bo9so5717509ejb.13
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 09:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3kgOHBtixErnriEtsg2lfKIcWc7GFIxP/NgjDBm37sI=;
        b=z1hQQuuHgm+BjH29ILhlPeLmWwwCdZq4ZBQW4CzFPkSQebnGsozAhhN9l71quZlehJ
         6ALc5hrDwb/hpuRn7V1XHQXfEGV18XQUXGdJD967uAxqJ1NrOWLQsDNPAKKJ3UkYc5QU
         5HBUjG2fuiEv1J8DdDk/HNbBBfuB8cB4eoRZqktoKSXiipAMsEKBMqS76bk/CxpBYWUa
         6DcWsCIkzMqD+W2pMjhQy38TZsJ6xrTDFPGBKVyr747VovFB1hD5NEzhHT5bP0sF6+is
         OkjkJqJA7LZOA4bx2JoCiNVmFgUheXOIkMegvc+JUAlCgeesf8HQSsdiPxUTWyB2q5ZE
         9zhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3kgOHBtixErnriEtsg2lfKIcWc7GFIxP/NgjDBm37sI=;
        b=rzrMv2JxoOjm3gm3tPr3o81EnPRGbt1sIwaIx8cQuwfMomse2rKrAFzb+MzPC0Pb+J
         wBIYi0pT1GcelbB6m6bpAqimLWHHXVBgp8vUtGnYzIDxz5IFfJeBaHY8hUfOey4rHyzJ
         rg0X7e5wCdPuXHQQPJ4xhfCfCafHe3pan7SVnjK/O0toFgU3ffP6VzXZsynRJ6RodIH+
         Ixt2lJpPX9QzXxydAILCc4szqEEoFCJHoQWr4E5eSn1NVpo2KvGEVPqTCp77dkPNUR4h
         EDDs5hdSVTN+tmxACEgIWPACJYilnZkk10dNPxyiP9Q5rWoQ9BA3VNk8emNVgpn/AaXM
         Gxog==
X-Gm-Message-State: AOAM532E51gBFOQcXnNaywYxJ5n5FKkCCg+bQaW5t5TlAsAtoklEtgYj
        kF1PdhFc2WPfjfd3Hwo6z0hb3EQacimEzaYXckPMB5/OuDgHKL4K
X-Google-Smtp-Source: ABdhPJy02S0PbdqT+IuCzCZMaQvDeZJBuyN6C6ly+NWkFyziycGrzVIIQyOTk0uFU37LCSPHtCmpSAU1JYK3zQ2D3Rc=
X-Received: by 2002:a17:906:411b:: with SMTP id j27mr4045057ejk.466.1606843794518;
 Tue, 01 Dec 2020 09:29:54 -0800 (PST)
MIME-Version: 1.0
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
 <1606533966-22821-5-git-send-email-hemantk@codeaurora.org>
 <CAMZdPi8z+-qFqgZ7AFJcNAUMbDQtNN5Hz-geMBcp4azrUGm9iA@mail.gmail.com> <c47dcd57-7576-e03e-f70b-0c4d25f724b5@codeaurora.org>
In-Reply-To: <c47dcd57-7576-e03e-f70b-0c4d25f724b5@codeaurora.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 1 Dec 2020 18:36:09 +0100
Message-ID: <CAMZdPi8mUV5cFs-76K3kg=hN8ht2SKjJwzbJH-+VH4Y8QabcHQ@mail.gmail.com>
Subject: Re: [PATCH v13 4/4] bus: mhi: Add userspace client interface driver
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 at 02:16, Hemant Kumar <hemantk@codeaurora.org> wrote:
>
> Hi Loic,
>
> On 11/30/20 10:22 AM, Loic Poulain wrote:
> > On Sat, 28 Nov 2020 at 04:26, Hemant Kumar <hemantk@codeaurora.org> wrote:
> >>
> >> This MHI client driver allows userspace clients to transfer
> >> raw data between MHI device and host using standard file operations.
> >> Driver instantiates UCI device object which is associated to device
> >> file node. UCI device object instantiates UCI channel object when device
> >> file node is opened. UCI channel object is used to manage MHI channels
> >> by calling MHI core APIs for read and write operations. MHI channels
> >> are started as part of device open(). MHI channels remain in start
> >> state until last release() is called on UCI device file node. Device
> >> file node is created with format
> >
> > [...]
> >
> >> +struct uci_chan {
> >> +       struct uci_dev *udev;
> >> +       wait_queue_head_t ul_wq;
> >> +
> >> +       /* ul channel lock to synchronize multiple writes */
> >> +       struct mutex write_lock;
> >> +
> >> +       wait_queue_head_t dl_wq;
> >> +
> >> +       /* dl channel lock to synchronize multiple reads */
> >> +       struct mutex read_lock;
> >> +
> >> +       /*
> >> +        * protects pending list in bh context, channel release, read and
> >> +        * poll
> >> +        */
> >> +       spinlock_t dl_pending_lock;
> >> +
> >> +       struct list_head dl_pending;
> >> +       struct uci_buf *cur_buf;
> >> +       size_t dl_size;
> >> +       struct kref ref_count;
> >> +};
> >
> > [...]
> >
> >> + * struct uci_dev - MHI UCI device
> >> + * @minor: UCI device node minor number
> >> + * @mhi_dev: associated mhi device object
> >> + * @uchan: UCI uplink and downlink channel object
> >> + * @mtu: max TRE buffer length
> >> + * @enabled: Flag to track the state of the UCI device
> >> + * @lock: mutex lock to manage uchan object
> >> + * @ref_count: uci_dev reference count
> >> + */
> >> +struct uci_dev {
> >> +       unsigned int minor;
> >> +       struct mhi_device *mhi_dev;
> >> +       struct uci_chan *uchan;
> >
> > Why a pointer to uci_chan and not just plainly integrating the
> > structure here, AFAIU uci_chan describes the channels and is just a
> > subpart of uci_dev. That would reduce the number of dynamic
> > allocations you manage and the extra kref. do you even need a separate
> > structure for this?
>
> This goes back to one of my patch versions i tried to address concern
> from Greg. Since we need to ref count the channel as well as the uci
> device i decoupled the two objects and used two reference counts for two
> different objects.

What Greg complained about is the two kref in the same structure and
that you were using kref as an open() counter. But splitting your
struct in two in order to keep the two kref does not make the much
code better (and simpler). I'm still a bit puzzled about the driver
complexity, it's supposed to be just a passthrough interface to MHI
after all.

I would suggest several changes, that IMHO would simplify reviewing:
- Use only one structure representing the 'uci' context (uci_dev)
- Keep the read path simple (mhi_uci_read), do no use an intermediate
cur_buf pointer, only dequeue the buffer when it is fully consumed.
- As I commented before, take care of the dl_pending list access
concurrency, even in wait_event.
- You don't need to count the number of open() calls, AFAIK,
mhi_prepare_for_transfer() simply fails if channels are already
started...

For testing purpose, I've implemented those changes on my side (based
on your driver):
https://git.linaro.org/landing-teams/working/telit/linux.git/commit/?h=mhi_uci_test&id=45ff60703cc26913061a26260e39cf3ab3e57c2b

Feel free to pick (or not), I'm not going to 'block' that series if
others are fine with the current implementation.

Anyway, I've tested your series and it works on my side with
libqmi/qmicli (controlling SDX55 modem):
Tested-by: Loic Poulain <loic.poulain@linaro.org>

Regards,
Loic
