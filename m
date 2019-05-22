Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2227153
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 23:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbfEVVEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 17:04:53 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40074 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbfEVVEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 17:04:53 -0400
Received: by mail-qt1-f193.google.com with SMTP id k24so4186537qtq.7
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 14:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mQra2X37FowSNkGLV4GBrSER5P4VxYF+9KwrlxSHnBk=;
        b=AvJ2ZfNua/XtrXHJcoJ9tucGfc7y+kaapli+XiRHt8jswzlSYkv6STQYWazo7FR1s+
         7VT/3q6nbPT3nD7xVsGWFd1Qt1IK5Ly2Id56eQns4fjuTFwkxa0tHUJ9ZECMTe+gOf9k
         RoH/+9fbCMYIBkWpG7GP82Z4BexPB00ZGvuY1KaBi4UvJPzaI2apFxAdrH9mdQAnwkt5
         C25gh+pc++stPN9+tE3AB5M9z0WOyYmSy9Y93Xq4OLBSl35WC6KiYh2s/7ISbNGKFEjQ
         7YYonRxB8jwDcIen0R9rKLg/u7zLQ62QNQ8Sql95JZqRzL28Xa3UL5OqRxO0dwDbHMJP
         2dSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mQra2X37FowSNkGLV4GBrSER5P4VxYF+9KwrlxSHnBk=;
        b=aVlBX0mGEg/rYMZOr8ZMgQj9FnclUDNUSqrhIc2XoV6Qfv2BmQwHuyuZ6gd2HggDY+
         GIsbHJu3vROKXtAUGJKLEyUcK+1/9XLJrI2q9LLkievh9rGTHq2rc9T9N0sEUu5iwVJq
         s8v6A7CA6xL+4Y6YJD12Rqv3/tDx5r4lcmwDs9f+UjWA5eauQOAvYo2etN0/KKWv5xwg
         LGPbJZPQ/5KUJsa/078WSDWC34HkGEP/XpPAVNC6FJrsbgbr/77zNRQHg7bn+BeNCGFu
         6HRzOtSorFBpTWn8jOjjZlfP3zhdXYbP+VCaP0EK0qoV0snQi2b/dcKNx4R/siXF+4qE
         Hd5Q==
X-Gm-Message-State: APjAAAXlt79uoL1NJ3tpE/vHYqSsFBm90njJ75lTm7QAOHBqH0W2ezc2
        WuPlEhNvWvoWqr8Eg/QUAUdQQw==
X-Google-Smtp-Source: APXvYqzOnkWQFKIXmFgjGxLlTS2Z85bLEhLAxzzSfEttmuvx6En1NSbQIfP+ZUuI0HPQ/FD+gulPBw==
X-Received: by 2002:aed:354c:: with SMTP id b12mr78671650qte.251.1558559092556;
        Wed, 22 May 2019 14:04:52 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s26sm436798qtk.21.2019.05.22.14.04.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 22 May 2019 14:04:52 -0700 (PDT)
Date:   Wed, 22 May 2019 14:04:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW} to
 netdev
Message-ID: <20190522140447.53468a2a@cakuba.netronome.com>
In-Reply-To: <CAJ+HfNiz5xbhxshWbLXyiLKDEz3ksU5jg54xxurN17=nVPetyg@mail.gmail.com>
References: <20190522125353.6106-1-bjorn.topel@gmail.com>
        <20190522125353.6106-2-bjorn.topel@gmail.com>
        <20190522113212.68aea474@cakuba.netronome.com>
        <CAJ+HfNiz5xbhxshWbLXyiLKDEz3ksU5jg54xxurN17=nVPetyg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 22:54:44 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > > Now, the same commands give:
> > >
> > >   # ip link set dev eth0 xdp obj foo.o sec main
> > >   # ip link set dev eth0 xdpgeneric off
> > >   Error: native and generic XDP can't be active at the same time. =20
> >
> > I'm not clear why this change is necessary? It is a change in
> > behaviour, and if anything returning ENOENT would seem cleaner
> > in this case.
>=20
> To me, the existing behavior was non-intuitive. If most people *don't*
> agree, I'll remove this change. So, what do people think about this?
> :-)

Having things start to fail after they were successful/ignored
is one of those ABI breakage types Linux and netdev usually takes
pretty seriously, unfortunately.  Especially when motivation is=20
"it's more intuitive" :)

If nobody chimes in please break out this behaviour change into=20
a commit of its own.

> ENOENT does make more sense.
