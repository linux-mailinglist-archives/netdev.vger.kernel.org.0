Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4805ABC5
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 16:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfF2OZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 10:25:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33353 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfF2OZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 10:25:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id h19so11225072wme.0;
        Sat, 29 Jun 2019 07:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tSfTfCg1RYrQS9+orWf92BVXcSGyjMupz270+2KJ+Us=;
        b=Wmn42cCjIZF370922nlT8XBZNT0vFC3qdUoivrJz5yLafRIjdx1Vw+bUvno+QUBVO5
         oMyQcmwqGx4DE3Y07CmSTM0IATWqZAW8kgg+hDEKwh+1CP4NznlAWonwVsCaGpQLaVCV
         I2vA/VdkUZjqS9WvauRGJBO3Xjdwe01bpXzqQP8wAMh3LJ6yI1E5Z9SfpRw+TuNVA5cx
         Mol2Xo2HUenKPsAtO6b1Hxjmm06+PdB0ii0cFoQihuSTWnRJjwjpf6NZuH7lsl3/21RK
         LnPOrpaBytkjll+vsC5zrv5VKacw2e2sTlF82+ldUSC/dM1uFOjAFEnxgQGkqlBXSG7l
         +TOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tSfTfCg1RYrQS9+orWf92BVXcSGyjMupz270+2KJ+Us=;
        b=XaIdppMftJuD3uEwrow4pHAKBqgnJbPuLGiMRhssI+Hi3bgImFGA5HEdpi25c/1Fam
         kfrGr6s4j2Ag2+IpaXvJQ1wqR9kj99rW1Z9mGEZZeACRq5S+FAzzSPBFWuPSYj3vdx5u
         SAmYhMKCWKk4OFGZMo6NncAb3sIA1aEwgiIUCZ1Ub39EFQjYPGqyoLkYXSFqj7c7srzh
         0aItlNF9bi+jesdKebazgVPOIH5IXFT/VtdhhVgTlSaTtOWT0jOG6xpphccPe6sNt1eS
         I+tNrBI3fDFRZJHl55w9shqt07ZneFt5sQjQUSSVSer6qTCcpkTK8Duullqe0Kfgo8rx
         J0iA==
X-Gm-Message-State: APjAAAWpj2QdGaAcPzCg3ksEjKAX/RGqLpODhql+FbQWJxaANIrHIPHC
        XgZFz2NOWutr2t8NaGyiQg==
X-Google-Smtp-Source: APXvYqzYjeGlAIXCK0Otnr3tBdPOmwP6gFHgUXBBLaR5nRWD1D7mhQsGKJ7ZXMMjG4yeTA5UDqjZKg==
X-Received: by 2002:a1c:dc46:: with SMTP id t67mr9957034wmg.159.1561818328264;
        Sat, 29 Jun 2019 07:25:28 -0700 (PDT)
Received: from avx2 ([46.53.248.49])
        by smtp.gmail.com with ESMTPSA id g123sm3503855wme.12.2019.06.29.07.25.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 07:25:27 -0700 (PDT)
Date:   Sat, 29 Jun 2019 17:25:10 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Shyam Saini <shyam.saini@amarulasolutions.com>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        devel@lists.orangefs.org, linux-mm@kvack.org,
        linux-sctp@vger.kernel.org, bpf@vger.kernel.org,
        kvm@vger.kernel.org, mayhs11saini@gmail.com
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF
 macro
Message-ID: <20190629142510.GA10629@avx2>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
 <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
 <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 03:00:10PM -0600, Andreas Dilger wrote:
> On Jun 11, 2019, at 2:48 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > On Wed, 12 Jun 2019 01:08:36 +0530 Shyam Saini <shyam.saini@amarulasolutions.com> wrote:

> I did a check, and FIELD_SIZEOF() is used about 350x, while sizeof_field()
> is about 30x, and SIZEOF_FIELD() is only about 5x.
> 
> That said, I'm much more in favour of "sizeof_field()" or "sizeof_member()"
> than FIELD_SIZEOF().  Not only does that better match "offsetof()", with
> which it is closely related, but is also closer to the original "sizeof()".
> 
> Since this is a rather trivial change, it can be split into a number of
> patches to get approval/landing via subsystem maintainers, and there is no
> huge urgency to remove the original macros until the users are gone.  It
> would make sense to remove SIZEOF_FIELD() and sizeof_field() quickly so
> they don't gain more users, and the remaining FIELD_SIZEOF() users can be
> whittled away as the patches come through the maintainer trees.

The signature should be

	sizeof_member(T, m)

it is proper English,
it is lowercase, so is easier to type,
it uses standard term (member, not field),
it blends in with standard "sizeof" operator,
