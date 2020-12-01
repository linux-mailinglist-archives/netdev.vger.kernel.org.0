Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505372CAA5C
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404216AbgLAR7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 12:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404207AbgLAR7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 12:59:38 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F55C0617A7
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 09:58:57 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id lt17so6000161ejb.3
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 09:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DX6KIUwirfviM9/LU40Kf0QHk6cwddHzRaxk7qxr/0M=;
        b=ZtFMGkps2lRkKC04MrOFY3muHoPuz0lmgVVDzwbTkOlXkBN5M1ATxujmQzIKb9Xphf
         YllNc6DMSPgelA8BwxYMYsEW2eScJoyQqcP6lSbcyq997m7abOclWlPc/AhmbANGdHTo
         mGaZscd7zZTyht8ZrGToJA3qB9mUw4/khTeksBu9+dDgcfggR4YhmlUg6Lfjy/adEqXW
         RKMP9HZw9z2NVKb4vZ6B1zlt6j3ccp0vJfa/A4sh6pzTGGNysptNYv5tms8y36lUBhxn
         ByETmlSgpw+SMVXwQKnZlqpxGLqymqxQx/C90hDoWG8G5aUfLzcloLTa2an+ZQMTG2De
         joPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DX6KIUwirfviM9/LU40Kf0QHk6cwddHzRaxk7qxr/0M=;
        b=dvXnNm8XG3JxKy/lkw/FYirpCzFrP4BOQ7y/yvZWcu71O0TGP4mO9M4K4VNqTFRUm1
         4WYojnyLWRl5kLDzwMyCk282gRUkO8/wRXyQ7gU7QcL41YGBygt+GQ027nk5hPvdbgOq
         1GMAd8KSY8OL4vIvViB8RhOykwPL+hZdATJjGgcp61jpwA3LyL2ZiXwW2SQD27QB77wD
         ss3HIZUDqGP/EpTUiBOireUmIZTFUhQhY2u9yH4tLlIVFpY7RHg9jqeohNqpfORxMpKn
         MKMdTt5bOMltv/iIZBlC9osXl9vyo9CnyiVk73FMnLnyiScXw0QiNXuGDh1BMsC0XC9C
         3uRg==
X-Gm-Message-State: AOAM531byk/V/SDdbJTJQX5foI4eklTwAvioIWvB5GvhsjRuKQ5FI0b3
        eUERRFNiBGQRSDKIFVtTPXB9VjVWcgiDyrJV91Mxuw==
X-Google-Smtp-Source: ABdhPJwSOWPjSYUHtTW6dykZ1JlqhK3xRraEYUELd5WlAqcz1EvsKFReJLE7FutZWVJN3HEj2XDq19T0tWBBQtdGwyk=
X-Received: by 2002:a17:906:e093:: with SMTP id gh19mr4143592ejb.510.1606845536436;
 Tue, 01 Dec 2020 09:58:56 -0800 (PST)
MIME-Version: 1.0
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
 <1606533966-22821-5-git-send-email-hemantk@codeaurora.org>
 <CAMZdPi8z+-qFqgZ7AFJcNAUMbDQtNN5Hz-geMBcp4azrUGm9iA@mail.gmail.com>
 <c47dcd57-7576-e03e-f70b-0c4d25f724b5@codeaurora.org> <CAMZdPi8mUV5cFs-76K3kg=hN8ht2SKjJwzbJH-+VH4Y8QabcHQ@mail.gmail.com>
 <1247e32e-ed67-de6b-81ec-3bde9ad93250@codeaurora.org> <CAMZdPi-tjmXWAFzZJAg_6U5h2ZJv478E88T-Lmk=YA-B6=MzRA@mail.gmail.com>
 <1a9f7ed5-7060-9146-47ff-087b9096ba3a@codeaurora.org>
In-Reply-To: <1a9f7ed5-7060-9146-47ff-087b9096ba3a@codeaurora.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 1 Dec 2020 19:05:11 +0100
Message-ID: <CAMZdPi_=k95C0TTJDvRfYcFtqm6kSLfWHZ6CKpksAD=1P5vtfA@mail.gmail.com>
Subject: Re: [PATCH v13 4/4] bus: mhi: Add userspace client interface driver
To:     Jeffrey Hugo <jhugo@codeaurora.org>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 at 18:51, Jeffrey Hugo <jhugo@codeaurora.org> wrote:
>
> On 12/1/2020 10:52 AM, Loic Poulain wrote:
> > On Tue, 1 Dec 2020 at 18:37, Jeffrey Hugo <jhugo@codeaurora.org> wrote:
> >>
> >> On 12/1/2020 10:36 AM, Loic Poulain wrote:
> >>> On Tue, 1 Dec 2020 at 02:16, Hemant Kumar <hemantk@codeaurora.org> wrote:
> >>>>
> >>>> Hi Loic,
> >>>>
> >>>> On 11/30/20 10:22 AM, Loic Poulain wrote:
> >>>>> On Sat, 28 Nov 2020 at 04:26, Hemant Kumar <hemantk@codeaurora.org> wrote:
> >>>>>>
> >>>>>> This MHI client driver allows userspace clients to transfer
> >>>>>> raw data between MHI device and host using standard file operations.
> >>>>>> Driver instantiates UCI device object which is associated to device
> >>>>>> file node. UCI device object instantiates UCI channel object when device
> >>>>>> file node is opened. UCI channel object is used to manage MHI channels
> >>>>>> by calling MHI core APIs for read and write operations. MHI channels
> >>>>>> are started as part of device open(). MHI channels remain in start
> >>>>>> state until last release() is called on UCI device file node. Device
> >>>>>> file node is created with format
> >>>>>
> >>>>> [...]
> >>>>>
> >>>>>> +struct uci_chan {
> >>>>>> +       struct uci_dev *udev;
> >>>>>> +       wait_queue_head_t ul_wq;
> >>>>>> +
> >>>>>> +       /* ul channel lock to synchronize multiple writes */
> >>>>>> +       struct mutex write_lock;
> >>>>>> +
> >>>>>> +       wait_queue_head_t dl_wq;
> >>>>>> +
> >>>>>> +       /* dl channel lock to synchronize multiple reads */
> >>>>>> +       struct mutex read_lock;
> >>>>>> +
> >>>>>> +       /*
> >>>>>> +        * protects pending list in bh context, channel release, read and
> >>>>>> +        * poll
> >>>>>> +        */
> >>>>>> +       spinlock_t dl_pending_lock;
> >>>>>> +
> >>>>>> +       struct list_head dl_pending;
> >>>>>> +       struct uci_buf *cur_buf;
> >>>>>> +       size_t dl_size;
> >>>>>> +       struct kref ref_count;
> >>>>>> +};
> >>>>>
> >>>>> [...]
> >>>>>
> >>>>>> + * struct uci_dev - MHI UCI device
> >>>>>> + * @minor: UCI device node minor number
> >>>>>> + * @mhi_dev: associated mhi device object
> >>>>>> + * @uchan: UCI uplink and downlink channel object
> >>>>>> + * @mtu: max TRE buffer length
> >>>>>> + * @enabled: Flag to track the state of the UCI device
> >>>>>> + * @lock: mutex lock to manage uchan object
> >>>>>> + * @ref_count: uci_dev reference count
> >>>>>> + */
> >>>>>> +struct uci_dev {
> >>>>>> +       unsigned int minor;
> >>>>>> +       struct mhi_device *mhi_dev;
> >>>>>> +       struct uci_chan *uchan;
> >>>>>
> >>>>> Why a pointer to uci_chan and not just plainly integrating the
> >>>>> structure here, AFAIU uci_chan describes the channels and is just a
> >>>>> subpart of uci_dev. That would reduce the number of dynamic
> >>>>> allocations you manage and the extra kref. do you even need a separate
> >>>>> structure for this?
> >>>>
> >>>> This goes back to one of my patch versions i tried to address concern
> >>>> from Greg. Since we need to ref count the channel as well as the uci
> >>>> device i decoupled the two objects and used two reference counts for two
> >>>> different objects.
> >>>
> >>> What Greg complained about is the two kref in the same structure and
> >>> that you were using kref as an open() counter. But splitting your
> >>> struct in two in order to keep the two kref does not make the much
> >>> code better (and simpler). I'm still a bit puzzled about the driver
> >>> complexity, it's supposed to be just a passthrough interface to MHI
> >>> after all.
> >>>
> >>> I would suggest several changes, that IMHO would simplify reviewing:
> >>> - Use only one structure representing the 'uci' context (uci_dev)
> >>> - Keep the read path simple (mhi_uci_read), do no use an intermediate
> >>> cur_buf pointer, only dequeue the buffer when it is fully consumed.
> >>> - As I commented before, take care of the dl_pending list access
> >>> concurrency, even in wait_event.
> >>> - You don't need to count the number of open() calls, AFAIK,
> >>> mhi_prepare_for_transfer() simply fails if channels are already
> >>> started...
> >>
> >> Unless I missed something, you seem to have ignored the root issue that
> >> Hemant needs to solve, which is when to call
> >> mhi_unprepare_for_transfer().  You can't just call that when close() is
> >> called because there might be multiple users, and each one is going to
> >> trigger a close(), so you need to know how many close() instances to
> >> expect, and only call mhi_unprepare_for_transfer() for the last one.
> >
> > That one part of his problem, yes, but if you unconditionally call
> > mhi_prepare_for_transfer in open(), it should fail for subsequent
> > users, and so only one user will successfully open the device.
>
> I'm pretty sure that falls under "trying to prevent users from opening a
> device" which Greg gave a pretty strong NACK to.  So, that's not a solution.

That would deserve clarification since other drivers like
virtio_console clearly prevent that (guest_connected).

>
> So, the complete problem is -
>
> N users need to be able to use the device (and by proxy, the channel)
> concurrently, but prepare needs to be called on the first user coming
> into the picture, and unprepare needs to be called on the last user
> exiting the picture.
>
> Hemant has supported this usecase in every rev of this series I've
> looked at, but apparently every solution he has proposed to handle this
> has caused confusion.

Understood, but that can be done with a simple counter in that case.

Regards,
Loic
