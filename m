Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863D72A4D72
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgKCRrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgKCRrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:47:14 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E6AC0613D1;
        Tue,  3 Nov 2020 09:47:14 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id 126so23339050lfi.8;
        Tue, 03 Nov 2020 09:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JUXjHtZzBWlGVVBZ/xZOve5rGA5vb0SjNpyE1oO5hlE=;
        b=pDyaHEPXsNkqNDdm7AA0OYH8IT5Xu4+jZmisDHQp5txkwRIWHymhdVbLqHXzUL7fov
         K15HJrGyXtux4ckSyJM7FfvcPQr1aIRV+TVlP9j1VH06yikrxTt2t+s6dmMr3b/LNOxI
         UhMovliBeoKc2zebK9Kc9tSLMXVIm/flK5bJoveWqAK6otda8P+DRwQ6WQHBW7/AESKy
         R3+ABrohOIYdPtS7kLKZ1D+TepsEUgKEShTVXQNJlRixP6LtnjYTJ9t3U+0o6pibuNJF
         5gLHbBwFPWgVU2UWlG3psS6vqPHRgtBgswUtKy3AgB1ABsNPln6e2dfJV93SiK8g+wfK
         yXqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JUXjHtZzBWlGVVBZ/xZOve5rGA5vb0SjNpyE1oO5hlE=;
        b=buW73lipIgSdGcarJJopdUzVBU9t2cxj4/04AnT8dzslsz2Vwhy5TyU7lBpojSwApz
         +ab2rQ04k2F3wi5DS3TDEM68F4iweF1Eoz4o3u93utODHyeiDyidKRGyr35pxno+pG0V
         ykBf2jqRRBWPxdW+LcveL5O1mzDzR4R42DQ+QZUQjmM2E1JBsSlGhD8JzkHEgQDdBGUL
         pi03sCOnfyhxdnUVniCDWWIrgxDV/TIPie3Pbvl8Z4edGQQdaTW4EEMdWw7tLnQThDWt
         JO9wPYE+zL8jBoLSxOT7mrML2oqeji3/Qo/C1f/q8zM05d93TKUZs/H2jOpYco/6Yppu
         dwKw==
X-Gm-Message-State: AOAM530iTznQpW1kbPfIDIU+rxXvia+70/PmvnxFog4ZK8uZGA9xROdd
        6NMrSur9BUHtOsmev+7Fm55p7A6b+9RmIEjSg8M=
X-Google-Smtp-Source: ABdhPJziLcE/IiSRLYbE/WrhJ55N7KzchU2xJs4JexGUgqnH5xEpiWS3ketsOJcmf2KB9RkDKeC5lLRFprMIvlc9JvM=
X-Received: by 2002:ac2:58d2:: with SMTP id u18mr7703487lfo.390.1604425632607;
 Tue, 03 Nov 2020 09:47:12 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
In-Reply-To: <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 3 Nov 2020 09:47:00 -0800
Message-ID: <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 9:36 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/3/20 1:46 AM, Daniel Borkmann wrote:
> > I thought last time this discussion came up there was consensus that the
> > submodule could be an explicit opt in for the configure script at least?
>
> I do not recall Stephen agreeing to that, and I certainly did not.

Daniel,

since David is deaf to technical arguments,
how about we fork iproute2 and maintain it separately?
