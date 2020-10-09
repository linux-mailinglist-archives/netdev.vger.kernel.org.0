Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C108288CC9
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389297AbgJIPeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388473AbgJIPeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:34:19 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9E2C0613D2;
        Fri,  9 Oct 2020 08:34:18 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x8so7520895ybe.12;
        Fri, 09 Oct 2020 08:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhaC4CfBlF6MI4/GCdyxBEo4B/qjNFnWrs/5fzTSDE8=;
        b=dKIp27HidNSg+q8q4jGKuxlpggHIUEiozaf/GfFDEx0gBSsS12bWnDqSiBTwTetceK
         un1S6D8s0NnzONZVNAHg1MXEXmqrwezOAA+FbWywPRTC+QLrheoB0qNfszTjmIPXjst9
         zW9DypCEeIIFaH+BTF2RYtWEZUHGa+kk8OaRmm4ObZnf5+lRbXKu+1wj8CKcXu3L04iu
         a4Cc6FqCbp5jyHMjFu+Fy4eNyzKGJQ5fukrM8WyJPc5cU9Q2n4grXKqH3ZG2Wr9OimwC
         QtGTMJe53SA5+xGaOnqYFgZU/uZb8T3j5iJaUltl+3sUM4VYOhEtaK/vSvxZws8JVjuw
         uDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhaC4CfBlF6MI4/GCdyxBEo4B/qjNFnWrs/5fzTSDE8=;
        b=tYi7P/Bdpt9kP0fh2y+XUbosAULUQM2AaWjViGxyKKaF4fpu3YCwg4D4sFi/UpGhQz
         bXQUjdwuBkm+a1N2NNEAGCB9v+O5jw+90F06dh4PC73dOHYIsHnZ7A7pfxoraZ0X6Kx0
         6eqe/ZyGHu3INhkhjswKsKJouU5Y7Q4+vHUenjqjmkizVYnv9Rb70r/vHj0nfl5k5uDC
         Sfg2IQNjdf806gJdDR9LVAVyOSAGQeMmAYONzyBYbbwm2/bZ1g5VK2y8X53dEVUtWX12
         4meE+K/IFz7PjHm+lK8rOemHm63tCWjJnVISqA1ZyrUhavfNa7KbUKFc+q5yqlJ25W2N
         0tEA==
X-Gm-Message-State: AOAM532aFiDudAnaQEcpq6BXdLLvKzo/Q6pmmTQrxastovW3SDNI27Ab
        gMzqTB73GEpj91Dvbux98k0Q1GFCPcPkzhubpqo=
X-Google-Smtp-Source: ABdhPJxdTKC82L3IOwN1ItfamDMCaGgZzWZj6raebF9Fbp0Hxzd9YYx3fdVX3uKw5Ru/rNGKU+1wjtJxIB1ujSmM1Kk=
X-Received: by 2002:a25:dc09:: with SMTP id y9mr2896321ybe.231.1602257657463;
 Fri, 09 Oct 2020 08:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201008155048.17679-1-ap420073@gmail.com> <1cbb69d83188424e99b2d2482848ae64@AcuMS.aculab.com>
 <62f6c2bd11ed8b25c1cd4462ebc6db870adc4229.camel@sipsolutions.net>
 <87v9fkgf4i.fsf@suse.de> <fd8aaf06b53f32eae7b5bdcec2f3ea9e1f419b1d.camel@sipsolutions.net>
 <CAMArcTUdGPH5a0RTUiNoLvuQtdnXHOCwStJ+gp_noaNEzgSA1Q@mail.gmail.com> <4a58caee3b6b8975f4ff632bf6d2a6673788157d.camel@sipsolutions.net>
In-Reply-To: <4a58caee3b6b8975f4ff632bf6d2a6673788157d.camel@sipsolutions.net>
From:   Steve deRosier <derosier@gmail.com>
Date:   Fri, 9 Oct 2020 08:33:41 -0700
Message-ID: <CALLGbRKFOcSDX6yw9W=8fzKJw+GDdL0XSsWYq_kymvDPkz74KQ@mail.gmail.com>
Subject: Re: [PATCH net 000/117] net: avoid to remove module when its debugfs
 is being used
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Taehee Yoo <ap420073@gmail.com>, Nicolai Stange <nstange@suse.de>,
        David Laight <David.Laight@aculab.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wil6210@qti.qualcomm.com" <wil6210@qti.qualcomm.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 3:22 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Fri, 2020-10-09 at 19:15 +0900, Taehee Yoo wrote:
> >
> > Okay, as you mentioned earlier in 001/117 patch thread,
> > I will squash patches into per-driver/subsystem then send them as v2.
>
> Give me a bit. I think I figured out a less intrusive way that at least
> means we don't have to do it if the fops doesn't have ->release(), which
> is the vast majority.
>

While I'm all for a patch that fixes something at a single level
instead of touching 100s of files, let me ask a loosely related, but
more basic, question: Should `->owner` be set properly in each driver?
 Or the flip of that, should we be considering that it isn't a
semantic error? I don't know the answer myself, I just thought to ask
the question.

IMHO, if true that `->owner` should be set for "correctness", and even
if we fix the debugfs problem elsewhere, perhaps this series (squashed
of course) should be merged.

- Steve
