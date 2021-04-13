Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C44435E0C1
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243161AbhDMOCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237651AbhDMOCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 10:02:14 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF9DC06175F
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:01:54 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id r9so26107035ejj.3
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AFGnHKnHgizV+FsCV7toD3pQlz9ndhsRkbd9JHKTvd8=;
        b=gbYaC/RA4eUmT+VPtdGwg6SqqhZkkjrsBnbBOkqmZdFA1AVHvUBovodg7KbKHULUl+
         6heoWEPdrPOmEwLaUlmmZS3giIHFbQujJt/WaF+yl+YsNUYfyw1lc5j2TY2nb/xBL6I7
         fAaOaj19dn65sTejbQwBQJ/vqZp265XS5Ka1viuZ6TVSqEX3HDSx7F7kOvJefhTy50pM
         JJUoCrn+0+Rdf7Vzs9t07nxbtgaH8CKgw8BnMEifBXQRxGBKG9k1jNYd/6tJPMLaSmSx
         0iMZqngixmxWLGeBYhMbggLjjym2d/JyJlsRqHv2VjlFj86mRWs0UdiRw3z9uN3F+Dr4
         nC+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AFGnHKnHgizV+FsCV7toD3pQlz9ndhsRkbd9JHKTvd8=;
        b=IeS4k/lCySddO4L2D8IAlOCEib1zDUTTBarWb0E5RIXlPPFNrfe+E4mPCC0bvWLrJw
         rykqKkGzDmXpNR+X6XPlI0C4jmvjvSazhJTlMkiOJkXhA08HJLUtZ0vWnyJHeNreU7du
         sJcXLFbOH+Rw/0S6tLb1vk2lfR4vcnX+uuRng3PsrO5I3CtgDxuwNVMIfp2XUBQvGefr
         Thby+DmbOKKOJ7B3w/AN7hmG2gsMCG1ZVTP5psdBgbsmbZPLyXpNxzJNhvhy/PDurST/
         W+bzxtp11Pzms9WZjXs+uYiVS5MMmXdoUAKTgr+jepizN20rQIRvQVB22d9gIRGmYxpW
         +WeA==
X-Gm-Message-State: AOAM532H0AKxfOdA2YBkUNMOtK8Y36fRIG9VGk8Q4zXkrQQHagVU/Gk/
        TxhnNDbENCJCODYWyRhb3JvLWurtUQzfzQ==
X-Google-Smtp-Source: ABdhPJz+NeD7hxYi80HTS/Ql4TbBc+v5mBMxZTIVfZiJZYrcoTkdGDbkIaYmqY+J2tiLtiF2g2uDHQ==
X-Received: by 2002:a17:906:b2cd:: with SMTP id cf13mr23406454ejb.419.1618322511784;
        Tue, 13 Apr 2021 07:01:51 -0700 (PDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id j1sm8061298ejt.18.2021.04.13.07.01.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 07:01:50 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id m9so3852544wrx.3
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:01:49 -0700 (PDT)
X-Received: by 2002:a5d:43c1:: with SMTP id v1mr12067069wrr.419.1618322509572;
 Tue, 13 Apr 2021 07:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210413054733.36363-1-mst@redhat.com> <20210413054733.36363-2-mst@redhat.com>
In-Reply-To: <20210413054733.36363-2-mst@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 13 Apr 2021 10:01:11 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe_SjUY4JxR6G9b8a0nx-MfQOkLdHJSzmjpuRG4BvsVPw@mail.gmail.com>
Message-ID: <CA+FuTSe_SjUY4JxR6G9b8a0nx-MfQOkLdHJSzmjpuRG4BvsVPw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/4] virtio: fix up virtio_disable_cb
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 1:47 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> virtio_disable_cb is currently a nop for split ring with event index.
> This is because it used to be always called from a callback when we know
> device won't trigger more events until we update the index.  However,
> now that we run with interrupts enabled a lot we also poll without a
> callback so that is different: disabling callbacks will help reduce the
> number of spurious interrupts.

The device may poll for transmit completions as a result of an interrupt
from virtnet_poll_tx.

As well as asynchronously to this transmit interrupt, from start_xmit or
from virtnet_poll_cleantx as a result of a receive interrupt.

As of napi-tx, transmit interrupts are left enabled to operate in standard
napi mode. While previously they would be left disabled for most of the
time, enabling only when the queue as low on descriptors.

(in practice, for the at the time common case of split ring with event index,
little changed, as that mode does not actually enable/disable the interrupt,
but looks at the consumer index in the ring to decide whether to interrupt)

Combined, this may cause the following:

1. device sends a packet and fires transmit interrupt
2. driver cleans interrupts using virtnet_poll_cleantx
3. driver handles transmit interrupt using vring_interrupt,
    detects that the vring is empty: !more_used(vq),
    and records a spurious interrupt.

I don't quite follow how suppressing interrupt suppression, i.e.,
skipping disable_cb, helps avoid this.

I'm probably missing something. Is this solving a subtly different
problem from the one as I understand it?

> Further, if using event index with a packed ring, and if being called
> from a callback, we actually do disable interrupts which is unnecessary.
>
> Fix both issues by tracking whenever we get a callback. If that is
> the case disabling interrupts with event index can be a nop.
> If not the case disable interrupts. Note: with a split ring
> there's no explicit "no interrupts" value. For now we write
> a fixed value so our chance of triggering an interupt
> is 1/ring size. It's probably better to write something
> related to the last used index there to reduce the chance
> even further. For now I'm keeping it simple.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
