Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1977635E87B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346204AbhDMVpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbhDMVps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:45:48 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87845C061756
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 14:45:24 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 18so21203463edx.3
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 14:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZtrQUYaQ1DNhvexbHv80y5K6lB9AUwatNXLoT+S6QRQ=;
        b=l6L0IRxR8mNsE8rknbUzNijupzedPU2v4qLqSEqJ48RMJgFdDRjzy34uiA5zh3lfLL
         RsMyAYg+6rXFTzguI0d14YpGlsYiiXTAZ7kY4r+YimEfmd209ZvzgdI90KuwLTKDSZfn
         0PKySFgZoTo9y7dGJOrzVVF/ruk0qTvPqfzR2Ny45nHnTCRmdmHHGOSbO3F9UraMUdZ7
         zuwL7JMSq/L8E5kTAztS/D75inJd9msvh1j4/yoI07U3FfYyQeNHX0UBlE8m0K2PtqE7
         LnkxcKJPNp4RV/KT2YN9JyaK2TqDppeAOihjhrG9wxsFyr5Unb2DFnynqPPbxL9vk//v
         54Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZtrQUYaQ1DNhvexbHv80y5K6lB9AUwatNXLoT+S6QRQ=;
        b=GAdK8vi0QFNJhVGNR5jiBaOjpUyIXMBMT+9lgSpdCPrG0+wU7dTMN54ocDpZpW4bb/
         R/93qlYTvSyv8o+qBbWcTumzHMVLGTNtLBEkExe3Wtxexxx1rkPIRBRHTA/xamAZvCCX
         6yqZBRRgazBjt2lEDk9yOAWEkqqcru6nzgI7PVx/K1OvwjUGd9rJiMZviLkpsUdMHRgK
         1cqGclzzJQ7atwGmDzSKzFPkJqKM2fCVwEkZVdVDsbkA2T2E7klPnDfDr/39Smp+JhoJ
         TMS39R5XDKYEMpY2/EG4PfZMOojqJkyi1ytZYx1uasfUucns5GWX3QzyWys90SWrfUMj
         7JgA==
X-Gm-Message-State: AOAM530JMF81Fa6pavTkmCOKeSyQcnkjJWcxcsv5HUdKw5/IZIDc2hlE
        CzxZzg6eTJ7BcTu3wjzzPMquq66m9qfk3Q==
X-Google-Smtp-Source: ABdhPJxLgZRz7+zCwcB1KElaXmshnJb5EEwFtCpwV9pH5m131Tf6kxkKtdaJZNzNZA2PBeYkb0pnyw==
X-Received: by 2002:aa7:ca04:: with SMTP id y4mr26869970eds.72.1618350322493;
        Tue, 13 Apr 2021 14:45:22 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id a27sm8697524ejk.80.2021.04.13.14.45.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 14:45:21 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id y204so8128276wmg.2
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 14:45:21 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc8:: with SMTP id o8mr1832923wmq.87.1618350321080;
 Tue, 13 Apr 2021 14:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210413054733.36363-1-mst@redhat.com> <20210413054733.36363-2-mst@redhat.com>
 <CA+FuTSe_SjUY4JxR6G9b8a0nx-MfQOkLdHJSzmjpuRG4BvsVPw@mail.gmail.com> <20210413153951-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210413153951-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 13 Apr 2021 17:44:42 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd7qagJAN0wpvudvi2Rvxn-SvQaBZ1SU9rwdb1x0j1s3g@mail.gmail.com>
Message-ID: <CA+FuTSd7qagJAN0wpvudvi2Rvxn-SvQaBZ1SU9rwdb1x0j1s3g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/4] virtio: fix up virtio_disable_cb
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 3:54 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Apr 13, 2021 at 10:01:11AM -0400, Willem de Bruijn wrote:
> > On Tue, Apr 13, 2021 at 1:47 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > virtio_disable_cb is currently a nop for split ring with event index.
> > > This is because it used to be always called from a callback when we know
> > > device won't trigger more events until we update the index.  However,
> > > now that we run with interrupts enabled a lot we also poll without a
> > > callback so that is different: disabling callbacks will help reduce the
> > > number of spurious interrupts.
> >
> > The device may poll for transmit completions as a result of an interrupt
> > from virtnet_poll_tx.
> >
> > As well as asynchronously to this transmit interrupt, from start_xmit or
> > from virtnet_poll_cleantx as a result of a receive interrupt.
> >
> > As of napi-tx, transmit interrupts are left enabled to operate in standard
> > napi mode. While previously they would be left disabled for most of the
> > time, enabling only when the queue as low on descriptors.
> >
> > (in practice, for the at the time common case of split ring with event index,
> > little changed, as that mode does not actually enable/disable the interrupt,
> > but looks at the consumer index in the ring to decide whether to interrupt)
> >
> > Combined, this may cause the following:
> >
> > 1. device sends a packet and fires transmit interrupt
> > 2. driver cleans interrupts using virtnet_poll_cleantx
> > 3. driver handles transmit interrupt using vring_interrupt,
> >     detects that the vring is empty: !more_used(vq),
> >     and records a spurious interrupt.
> >
> > I don't quite follow how suppressing interrupt suppression, i.e.,
> > skipping disable_cb, helps avoid this.
> > I'm probably missing something. Is this solving a subtly different
> > problem from the one as I understand it?
>
> I was thinking of this one:
>
>  1. device is sending packets
>  2. driver cleans them at the same time using virtnet_poll_cleantx
>  3. device fires transmit interrupts
>  4. driver handles transmit interrupts using vring_interrupt,
>      detects that the vring is empty: !more_used(vq),
>      and records spurious interrupts.

I think that's the same scenario

>
>
> but even yours is also fixed I think.
>
> The common point is that a single spurious interrupt is not a problem.
> The problem only exists if there are tons of spurious interrupts with no
> real ones. For this to trigger, we keep polling the ring and while we do
> device keeps firing interrupts. So just disable interrupts while we
> poll.

But the main change in this patch is to turn some virtqueue_disable_cb
calls into no-ops. I don't understand how that helps reduce spurious
interrupts, as if anything, it keeps interrupts enabled for longer.

Another patch in the series disable callbacks* before starting to
clean the descriptors from the rx interrupt. That I do understand will
suppress additional tx interrupts that might see no work to be done. I
just don't entire follow this patch on its own.

*(I use interrupt and callback as a synonym in this context, correct
me if I'm glancing over something essential)
