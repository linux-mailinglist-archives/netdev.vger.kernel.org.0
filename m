Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BF22FBB7A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391709AbhASPmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391650AbhASPlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:41:03 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C09C061574;
        Tue, 19 Jan 2021 07:40:21 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id s24so1807502wmj.0;
        Tue, 19 Jan 2021 07:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bboU+fHH/ysuT6EbuYfARXUyNXDaTGB+7EjKzd2M5n0=;
        b=kxzYmlH/85DeW8jWnMBtK3+mbJ/TAw3R0yZyjUkk7hoPJqRC/u3MzMph4Zwh0c85sE
         HALeN7nm2GkL9uRT2+jxZ4c5OvDD1qVfF5y9C6N1x8WcDFhQuvjwoZOgv53fUaZL/ST5
         eaPyIKHrso/vj59dJ3MNggFTBqHFNYEMk+/dmPsteHnC+Im/q82jDyM4rJqVhaJt1K+o
         TafbLAVOa6dgk2W1BrZdbwQyohrvkF1pQ690pduAH3cGK23I//+Bv2yKUUPRxbHFrjgd
         q0S3jtyKBcRkRF5jChz+NXc+DOJGtWyp3giD6RL0qlIredJ0y7K85D4dmzq4Uamf0sCY
         Z/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bboU+fHH/ysuT6EbuYfARXUyNXDaTGB+7EjKzd2M5n0=;
        b=Uht7prQUjPt72H0KIIxKGIZF3XoH0W1/L1xQFbt2Dqki5MdpNEPp6AKdlP9zU3n7ov
         rliwYwlWco5OWHtd0f6h4GyYMj7H06VaomFPj0TofV0+Z16aH79vSmMxSebOwMBJfUWc
         /+klc+Q7Hoevg10qeGpwbARJBAxAfjSEP2d3rNn9gIhWK9i8K67roy0kcT6T6+E9Mo4/
         H04Tdnlqlb3GTjGfRTwGELFHdPpeWDEDCtKT/jzVIl8Nfv1v+XGkzIRTqRvLoyOwSm0W
         f7sRBoAKJpn+mLSdkBtItWXBVHh2QtAk3AMyeZEeO2hmfYY8s/9FokRIu4X22/PxRsI8
         7Jvw==
X-Gm-Message-State: AOAM533UtbxurWPGOJRIQGhjs9NpXoH1FD47r9K0lRkfl1UlOMI4Ub4N
        iDNWlsLpA49jNHZf3E/5Jg9OXpQ2rgSwwdngrfQ=
X-Google-Smtp-Source: ABdhPJzjVw5Aw4AI+bdyJ7XcyB/jrfakqsFveTfBn7m7FpLK5vyvBfmXxlHn+rVzAK9sSTu5eg5tGkPy/RBtghl7cZc=
X-Received: by 2002:a7b:c20b:: with SMTP id x11mr192503wmi.107.1611070820181;
 Tue, 19 Jan 2021 07:40:20 -0800 (PST)
MIME-Version: 1.0
References: <20210119153655.153999-1-bjorn.topel@gmail.com> <20210119153655.153999-8-bjorn.topel@gmail.com>
In-Reply-To: <20210119153655.153999-8-bjorn.topel@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 19 Jan 2021 16:40:08 +0100
Message-ID: <CAJ+HfNgQGSJErZ19nOobW80bnSaf64yWJpH3h-1TmQSQ7cB73Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/8] selftest/bpf: add XDP socket tests for
 bpf_redirect_{xsk, map}()
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 at 16:37, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Add support for externally loaded XDP programs to
> xdpxceiver/test_xsk.sh, so that bpf_redirect_xsk() and
> bpf_redirect_map() can be exercised.
>

Ah, crap. Forgot two files. Will resend.

Bj=C3=B6rn
