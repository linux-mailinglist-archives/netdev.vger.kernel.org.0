Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A40F453807
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbhKPQtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbhKPQtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:49:50 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF92C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:46:52 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id i5so38867398wrb.2
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ge2UfQvIG7BcQ6jGlMWeh47LcVrmBB2jXUcPMoNRU9w=;
        b=KEmhohCGxyyrmfrpbJi6nlw5P9Uy8PjK58h8qCBoUqTFxLd3Z1Myp1NSYNryw292T9
         qGr0gwT5u9uqd04ew4j0iFcRXZPRsiTNYZ9EjCoKXno9VrS90tAl9B+R0H3G/W1v87w3
         xsa9eaXmuBx2MEhxxh9ntrFIcOzPsL4CWKp5guSG6zreQKu/Ie5Lo6wTxHkMzT2wviyW
         pBZfokipJf604qwnt+y4ChaNrqf5PnYP+gv3rZzE66aB2xua39vGhGWc5xUAaLRuAZOv
         OvZv9zLObDg2N3M3sKxa786wEaNkguG8Lcqq2QVAJwTOT+XbETawmOcpUC4iheCt/k4+
         BD6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ge2UfQvIG7BcQ6jGlMWeh47LcVrmBB2jXUcPMoNRU9w=;
        b=xCBw6nDwtCjLK5E5C0KxxPZ/8fah+J/hZaBq1f5tNFkgCMfGho8gvYEXN8a0o4uI2U
         iBLJZqyBdRagCGvRZqn3CB2ZMU3/7KYUMN1WGbRyRnkitTYNuYMUbHoQCCFzqhBaWQU4
         D2T+8xDXCCPoADgBNpA4+pRubojYnA093hTs/L3g30LAqJhSbNFN1ggukeoIOLD4WDDN
         T2I8j8S5G1XCyLoRKlSdLXVqabLdwryThHu2EmY9hQIHnw1wHCsHEtjcxirMykWLUiTr
         O+Byz4yIV7gHqSnw4/VtLOPTE/O2fixtQaOKj+q3TAOSlIrvjFagpRIOHs5SdcWF+aSv
         9Lvg==
X-Gm-Message-State: AOAM533LvV49f2eLbf1na1nXbnuez66AVKaNgxIO++ZUwPFCnWH/7x7/
        BxtnyniU/1dJUtwtqDp3S5xr1mZd0Ug1wq183T0bwg==
X-Google-Smtp-Source: ABdhPJxNIkCyAjz2I70TCapyEJGuGkts62yh34yc/k+wdmtoSfctgMDeufoQEogZ7BmP+n0s1kAqsqrfl9CWJN9X7u4=
X-Received: by 2002:a05:6000:1548:: with SMTP id 8mr11504049wry.279.1637081210373;
 Tue, 16 Nov 2021 08:46:50 -0800 (PST)
MIME-Version: 1.0
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
 <20211115190249.3936899-18-eric.dumazet@gmail.com> <20211116062732.60260cd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJL=pGQDgqqKDrL5scxs_S5yMP013ch3-5zwSkMqfMn3A@mail.gmail.com>
 <CANn89iJ5kWdq+agqif+72mrvkBSyHovphrHOUxb2rj-vg5EL8w@mail.gmail.com> <20211116072735.68c104ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211116072735.68c104ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Nov 2021 08:46:37 -0800
Message-ID: <CANn89iJb7s-JoCCfn=eoxZ_tX_2RaeEPZKO1aHyHtgHxLXsd2A@mail.gmail.com>
Subject: Re: [PATCH net-next 17/20] tcp: defer skb freeing after socket lock
 is released
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 7:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 16 Nov 2021 07:22:02 -0800 Eric Dumazet wrote:
> > Here is the perf top profile on cpu used by user thread doing the
> > recvmsg(), at 96 Gbit/s
> >
> > We no longer see skb freeing related costs, but we still see costs of
> > having to process the backlog.
> >
> >    81.06%  [kernel]       [k] copy_user_enhanced_fast_string
> >      2.50%  [kernel]       [k] __skb_datagram_iter
> >      2.25%  [kernel]       [k] _copy_to_iter
> >      1.45%  [kernel]       [k] tcp_recvmsg_locked
> >      1.39%  [kernel]       [k] tcp_rcv_established
>
> Huh, somehow I assumed your 4k MTU numbers were with zero-copy :o
>
> Out of curiosity - what's the softirq load with 4k? Do you have an
> idea what the load is on the CPU consuming the data vs the softirq
> processing with 1500B ?

On my testing host,

4K MTU : processing ~2,600.000 packets per second in GRO and other parts
use about 60% of the core in BH.
(Some of this cost comes from a clang issue, and the csum_partial() one
I was working on last week)
NIC RX interrupts are firing about 25,000 times per second in this setup.

1500 MTU : processing ~ 5,800,000 packets per second uses one core in
BH (and also one core in recvmsg()),
We stay in NAPI mode (no IRQ rearming)
(That was with a TCP_STREAM run sustaining 70Gbit)

BH numbers also depend on IRQ coalescing parameters.
