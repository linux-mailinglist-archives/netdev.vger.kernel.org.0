Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C04DB84A
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 22:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437020AbfJQU3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 16:29:52 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39428 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437077AbfJQU3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 16:29:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id p12so2003667pgn.6
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 13:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IGzfoydrgfLH+6OSNvFJgVCfYe5DZkA2g+Ze13Y0BI0=;
        b=qcI3xKAn9N36dzCGhtZjh5o99q/GwWjpRcDeFYgq9owAiCDNO2KceihyuIcCNNz3E5
         WPxJHg+NoHeJoDfDuM9esl+6ZhDbqYBp3VsY4JybwMD7k1jg2Ys+vPBIv84F+vp7lRyB
         MFNYcbY5a5i7wpXrXCIM5vraJRDH7TvgpzsSKiMKpH/8jsmZKe7YjwMrFC+sAhoeJx0P
         TkYWK8IHVtDju9jvxvfKIGX5UYvHFCAeifnuW+qqfUBejAvskKWzvyyvm2Y7Ik7n4rIc
         6VfqupXReo3U334CVNf5jFwqap+ZLcfM9P/7/K4pk38GmqRm5QxNOhVZ4af3DrhvSP/2
         iqJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IGzfoydrgfLH+6OSNvFJgVCfYe5DZkA2g+Ze13Y0BI0=;
        b=FJW2Ycpg4yniKNt88OmrczGcHLFCZD8EvVHBD0Y3tVQVP8920ds/LhlB84X/DTMqie
         sXH4MfdslXtP4u6Pr6YXdNVktf2JI3YRYOGxIbP6yMhIYVL3dipGSGfR8XjYAQwe8756
         fjuCvhkCWTlfbd0A+nnnIompl6bg8HbsVNUhqRIPmXfBuxwFkb/mxJWXYHYv3BJqkNpU
         BKUJ2oHmw4UuTcRIsXkV935OfSqmQXswjjxlo8zYG39yXcRewzzAHxlClYKGbOYx73cb
         5wfxqxWXy5CUEqjZmSY8w7IjiIwJD9GmPe7xR1TaogLkNPHzgs7SmDoU6D0uBeYQ6rBE
         Rixw==
X-Gm-Message-State: APjAAAXIisyxe8woNkxoKttD2HrH6zFqZ1Vjld3X3NR/P7AxkhB70Voh
        d00SFYsoXbhdMkCxSUdT9GQcXoqq0ugR79qrEF7b+Q==
X-Google-Smtp-Source: APXvYqxQdqUhb/3P8KN/MR06ATDhMAw/8toZltJAt9HJYabqSYrn3OYDB2KZoaJ69l2hgeCLiieQudCtSs2uqLRj1E0=
X-Received: by 2002:a62:5503:: with SMTP id j3mr2232299pfb.93.1571344191179;
 Thu, 17 Oct 2019 13:29:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571333592.git.andreyknvl@google.com> <af26317c0efd412dd660e81d548a173942f8a0ad.1571333592.git.andreyknvl@google.com>
 <20191017181800.GB1094415@kroah.com> <CAAeHK+yS24KnecLyhnPEHx-dOSk3cvVHhtGHe+9Uf2d96+ZqjQ@mail.gmail.com>
 <20191017202843.GA1103978@kroah.com>
In-Reply-To: <20191017202843.GA1103978@kroah.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Thu, 17 Oct 2019 22:29:39 +0200
Message-ID: <CAAeHK+wT00vFzddy1q7SWQrnR3idLbpfC-cG+DckqDT_YEOTdw@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] vhost, kcov: collect coverage from vhost_worker
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     USB list <linux-usb@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 10:28 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Oct 17, 2019 at 09:00:18PM +0200, Andrey Konovalov wrote:
> > On Thu, Oct 17, 2019 at 8:18 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Oct 17, 2019 at 07:44:15PM +0200, Andrey Konovalov wrote:
> > > > This patch adds kcov_remote_start/kcov_remote_stop annotations to the
> > > > vhost_worker function, which is responsible for processing vhost works.
> > > > Since vhost_worker is spawned when a vhost device instance is created,
> > > > the common kcov handle is used for kcov_remote_start/stop annotations.
> > > >
> > > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > > > ---
> > > >  drivers/vhost/vhost.c | 15 +++++++++++++++
> > > >  drivers/vhost/vhost.h |  3 +++
> > > >  2 files changed, 18 insertions(+)
> > > >
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index 36ca2cf419bf..71a349f6b352 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -357,7 +357,13 @@ static int vhost_worker(void *data)
> > > >               llist_for_each_entry_safe(work, work_next, node, node) {
> > > >                       clear_bit(VHOST_WORK_QUEUED, &work->flags);
> > > >                       __set_current_state(TASK_RUNNING);
> > > > +#ifdef CONFIG_KCOV
> > > > +                     kcov_remote_start(dev->kcov_handle);
> > > > +#endif
> > >
> > > Shouldn't you hide these #ifdefs in a .h file?  This is not a "normal"
> > > kernel coding style at all.
> >
> > Well, if it's acceptable to add a kcov_handle field into vhost_dev
> > even when CONFIG_KCOV is not enabled, then we can get rid of those
> > #ifdefs.
>
> It should be, it's not a big deal and there's not a ton of those
> structures around that one more field is going to hurt anything...

OK, I'll do that in the next version then, thanks!
