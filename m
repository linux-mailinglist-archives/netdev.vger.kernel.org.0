Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDCD64FC56
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 21:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiLQU7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 15:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiLQU7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 15:59:22 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8906FD1A
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 12:59:21 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so9420874pjp.1
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 12:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UmWawOx4OzolstjPQEMpROHI0vBM+WouD5bI5Tc+Vys=;
        b=USP1YHohiZJvsSkwoQNReM4mc6+byVrTGS8EU5QKGbw/zUgnX2DeCx/IZAU1m2L7F0
         MCu9RHtixNgznsq36mtsbVKOk3jlEIeWLMPoaeDfr1YKbKfPajRcqhsdzYfPlCUYuQ//
         yP+Wpxhwqqv4Os0TheO69hrEIli67k4tFEBqv08TbWqciYf1vzdCRjkPOmhs8G2QYTfN
         a3dfaKV4tq6KH00eDo1mpE4bJ65ef18TTWnZjx3r7/FUxMWet6baKPuE+seRj5OKqcFg
         vBxl9+IH2AptaAS8wyOl5j5tmnNnMBmrdefzoQBQASCUQJVDKcxxhstx5swHXuHJvelG
         H6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UmWawOx4OzolstjPQEMpROHI0vBM+WouD5bI5Tc+Vys=;
        b=LvI2U0IDScPhb/qdO4nKJTF7NsW9Cgc+TLk1fJ1K0QCu4LNU/Wp5YG/8CBByYLVngy
         6Y6zHTGqUK6zCcDYUuuxJ7A47a9ZQji4e2g6TQE4GYIr6GWe9g0hTgxYeTUxZgWw5ogs
         pixKNZwhJPy2sfgEk5lrGP3E+7t4NrmuYdueoEg0cSAkgzDWYHTZUg53R2ZvjHbZX1lV
         7TvEloEhoqY2w+RzvTChLC/hO0DpiMl8H2D0ds6gkTAvHezeQNgi3UqG2U1KB6iTh+6S
         uMSo+jomHir97jfzC+W6v8rKrcVx9KbBRp5GN9NQ9qg973c3zmlHGRAEwqCXMfXaBMZ3
         H6Gw==
X-Gm-Message-State: AFqh2koO0xhAwyXnj/3SlRj4HhAFM93MiF6Om+Mt2pBBiraWQXMhddqH
        KptGBba0OM6Jv2BHXpdtRvaFXCO8ZB3o++MJRjY=
X-Google-Smtp-Source: AA0mqf5JhkCx4cX++nDasCqFgSEBfiAVwv5PJoMLdGcpwuE7y1SXFlO90myfigaE0UlrSVVDV/Z1fDrBhtJfH1Vptnc=
X-Received: by 2002:a17:90a:c396:b0:219:6a07:c6d0 with SMTP id
 h22-20020a17090ac39600b002196a07c6d0mr1763292pjt.178.1671310761190; Sat, 17
 Dec 2022 12:59:21 -0800 (PST)
MIME-Version: 1.0
References: <20221216034409.27174-1-jk@codeconstruct.com.au>
 <2eecaca2d1066d51d136a8d95b5cd2fd19e5e111.camel@gmail.com> <6d07e45e6237f24ec32a723e747dd070fb53bea7.camel@codeconstruct.com.au>
In-Reply-To: <6d07e45e6237f24ec32a723e747dd070fb53bea7.camel@codeconstruct.com.au>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 17 Dec 2022 12:59:09 -0800
Message-ID: <CAKgT0Ufb-PeuqH4+dLca8ANJ=Y7uhYCK-QLNz-Pjo991pJZ8Xw@mail.gmail.com>
Subject: Re: [PATCH net] mctp: serial: Fix starting value for frame check sequence
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Harsh Tyagi <harshtya@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 10:44 PM Jeremy Kerr <jk@codeconstruct.com.au> wrote:
>
>
> Hi Alexander.
>
> > Since the starting value isn't unique would it possibly be worthwhile
> > to look at adding a define to include/linux/crc-ccitt.h to be used to
> > handle the cases where the initial value is 0xffff? I notice there
> > seems to only be two starting values 0 and 0xffff for all callers so
> > it might make sense to centralize it in one place.
>
> Yep, that would make sense if they're commonly used values, but I'm not
> sure that would be suitable to include that in this fix, as it would
> just add disruption to any backport work.

Sorry, I didn't intend that for this patch. I was suggesting it as
possible follow-on work.

Thanks,

- Alex
