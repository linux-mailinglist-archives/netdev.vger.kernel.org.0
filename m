Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C912DC1DF
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 15:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgLPOKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 09:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgLPOKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 09:10:08 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CFDC0617A7;
        Wed, 16 Dec 2020 06:09:16 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id g25so2015502wmh.1;
        Wed, 16 Dec 2020 06:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1R0+GWIQamROnhGmICz1nGLtViitEFgG5Tyt6JqoEKM=;
        b=l10a3xbsk6yzBRp+lnIING2p6E7W1Gs3KgjUShE628+8nRftt0h2t/0wHdFex3bEts
         yvDyuFg42khTUArPPo3yBaeig+91dsB5hdEmU7L1s1+EVBrCatSBfWw5Y+HxkygYDABN
         xHKh+5/A0GDZx8fSpT+ZQ9Mdb4ti/um0mlPhp6tBj+fI6WCy0E8mjBeOjPDqa9mRSP1y
         NgsAi6KwwjFEzUJYrER30Mm1MC/0zuCKxYR+Tr1/Pazxz7uHznbI1H/ZLKlG12aurOoX
         6aI+3d+t9/DpNJ1aMKGZ39Dw8Ukcm3+EQ2+Si6AOnaMR+cz1YBjwDQ+q2nECmlKTQWTF
         yD6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1R0+GWIQamROnhGmICz1nGLtViitEFgG5Tyt6JqoEKM=;
        b=eJ+4LMCu6kxa3/aBozLYQvqcnZL4QyAhG0vwakrSGXgMklc5Ctz5EqorqHCoEtrJ0i
         dSCNFQ1IGepn5H8YLXRhIEjx/o1FbyrhYyR1yGptMnwFWKq/9jWyciaxPPbgtnuuSnMU
         cZFaTGc8+1PE+ruhwFn6qgyj4NsrczrHMEKFnoJCFn3+rLc3jzOhrX37F3uo6M2jZowy
         nR3sjTlILj853aa+Eut8HKJaC6aU8VHEVaUTS6EVJB4m7qPg+v6J4Ib7FeHKxjSO0VZT
         CICWcnG9SY9VTdBv69UhocQ58AP5CeDuKPitJK+53Uw11pm0bWrEUQtd3V37ascSn0IR
         5U4Q==
X-Gm-Message-State: AOAM531rrRZrGZJLfNhurZXZj4tAe51zS39maR9OWTCZKhaYJhYeSC4D
        5x06O2N5UeTiQe1nzK3hxIXubs5doMYxZhZRPHDNjA0PnNSCvw==
X-Google-Smtp-Source: ABdhPJxo9eJjynTTN1ADqAIF2WiPBXHVolB1LmCORe9wX40qVt1mRtrp9AMo3EVvSklQ6CZX6z8PA9EMC+IeP9OgmSQ=
X-Received: by 2002:a1c:64c4:: with SMTP id y187mr3593197wmb.165.1608127754865;
 Wed, 16 Dec 2020 06:09:14 -0800 (PST)
MIME-Version: 1.0
References: <20201214152757.7632-1-magnus.karlsson@gmail.com>
In-Reply-To: <20201214152757.7632-1-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 16 Dec 2020 15:09:03 +0100
Message-ID: <CAJ+HfNgS4SymdqRogGRZqqTwugNpfop9Tda1t4q8BGZqF_ACqw@mail.gmail.com>
Subject: Re: [PATCH bpf 0/2] xsk: fix two bugs in the SKB Tx path
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, A.Zema@falconvsystems.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 at 16:35, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> This patch set contains two bug fixes to the Tx SKB path. Details can
> be found in the individual commit messages. Special thanks to Xuan
> Zhuo for spotting both of them.
>
> Thanks: Magnus
>
> Magnus Karlsson (2):
>   xsk: fix race in SKB mode transmit with shared cq
>   xsk: rollback reservation at NETDEV_TX_BUSY
>

For the series:

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

>  include/net/xdp_sock.h      |  4 ----
>  include/net/xsk_buff_pool.h |  5 +++++
>  net/xdp/xsk.c               | 12 +++++++++---
>  net/xdp/xsk_buff_pool.c     |  1 +
>  net/xdp/xsk_queue.h         |  5 +++++
>  5 files changed, 20 insertions(+), 7 deletions(-)
>
>
> base-commit: d9838b1d39283c1200c13f9076474c7624b8ec34
> --
> 2.29.0
