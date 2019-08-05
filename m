Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873B982744
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 00:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfHEWCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 18:02:45 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42220 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbfHEWCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 18:02:45 -0400
Received: by mail-ot1-f65.google.com with SMTP id l15so87570765otn.9;
        Mon, 05 Aug 2019 15:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1tYFj8fLEfMucFF88WzuLX+YfDkZb2Hei2792mPapEA=;
        b=dptrY0t5pMgCYUoU0pESnqQ5UM9jOt5iigO6nTkHPQNcBELPmcM/xsv0wr1xloTm3f
         FLqo5NSxho98GOZVrMedryjkRaCi9DiSOle1yJrARAgpZ7pX9GMr58QXu3CrFMdtZgxu
         reEe96SAXlXyL2AxZMrKo68Z3C8W0qtYLPqdCZXjeFuIJTLf+cnsEbwpW2i4TVqFJIok
         UER3EJXGE6Dpi00oHVWRQNLVhXhZdC9ZP4tv8BbKpZQe964U/rMPv8tEkZbX/mYGXINN
         TsS7IuJ/g2hcr0t/ZVnrKxZgPd+60GkxcL2t2TOqCyDwcQVJOa6TgRrL2ZC3EwU9HIlG
         cC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1tYFj8fLEfMucFF88WzuLX+YfDkZb2Hei2792mPapEA=;
        b=g5T4hzw/ifSJsnSVh0WU83MsnxPRzxr6kUcn45Llam475A4LO5RGtb80+3bYo67YOS
         VvEyJobJmPbUtU7GBHh/WGRISS2VhOjB1S1+nWeMW60Umd11aUUE9V9XEtkkc/b7HRtb
         b2gCSb6i3V5wduhezBzM9m3i3o3dEfqbTJG6S9vTcuuSXVRlspz3hDfqExvbPb0gBzNL
         NB8bbooTdivwXhYXF1+Z8QTztL005+RF6p4dvJv2+4EjQfSoM8/TJpqeQsSOLvC8II7e
         Ye5Aa1Cro2CaatX8Ogcsm1Jco/TdySmXiHcnwfVuffwBxFB12COLDEDQud6lxKC2n4KP
         8R/Q==
X-Gm-Message-State: APjAAAU8d9JPxbme78rjMYx+PAt1u7rx6qPJIlzFsvk0bhln1uL4RuBF
        hmPsrx9pPacgSNmA3VZkN8dea0t4dfzVffkXp2CEFh3V
X-Google-Smtp-Source: APXvYqy9X+tohvgSCeqle3zPcWlHn3jIxWB/KLj21S/fW+vvOlI8Ew2GtXL+aBv4RLlPVHZuD7HPl9yYE3D0kWomYbw=
X-Received: by 2002:a6b:5106:: with SMTP id f6mr193333iob.15.1565042564192;
 Mon, 05 Aug 2019 15:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190802105507.16650-1-hslester96@gmail.com> <CA+FuTScLs-qJApj5Yw9OOjVk4++HSjn__Vdy+xX2V1rpWU8uLg@mail.gmail.com>
In-Reply-To: <CA+FuTScLs-qJApj5Yw9OOjVk4++HSjn__Vdy+xX2V1rpWU8uLg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 5 Aug 2019 15:02:33 -0700
Message-ID: <CAKgT0UdzUChE36pYEj4x72vjMkBhjqWd33_B75FhmaYePSgDUw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 2/2] ixgbe: Use refcount_t for refcount
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 6:47 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Aug 2, 2019 at 6:55 AM Chuhong Yuan <hslester96@gmail.com> wrote:
> >
> > refcount_t is better for reference counters since its
> > implementation can prevent overflows.
> > So convert atomic_t ref counters to refcount_t.
> >
> > Also convert refcount from 0-based to 1-based.
> >
> > This patch depends on PATCH 1/2.
> >
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 6 +++---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h | 2 +-
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
> > index 00710f43cfd2..d313d00065cd 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
> > @@ -773,7 +773,7 @@ int ixgbe_setup_fcoe_ddp_resources(struct ixgbe_adapter *adapter)
> >
> >         fcoe->extra_ddp_buffer = buffer;
> >         fcoe->extra_ddp_buffer_dma = dma;
> > -       atomic_set(&fcoe->refcnt, 0);
> > +       refcount_set(&fcoe->refcnt, 1);
>
> Same point as in the cxgb4 driver patch: how can you just change the
> initial value without modifying the condition for release?
>
> This is not a suggestion to resubmit all these changes again with a
> change to the release condition.

So I am pretty sure this patch is badly broken. It doesn't make any
sense to be resetting with the refcnt in
ixgbe_setup_fcoe_ddp_resources. The value is initialized to zero when
the adapter structure was allocated.

Consider this a NAK from me.
