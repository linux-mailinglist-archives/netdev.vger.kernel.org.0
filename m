Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B3D234D59
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 23:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgGaVw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 17:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgGaVw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 17:52:56 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3BBC061574;
        Fri, 31 Jul 2020 14:52:56 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l17so33088693iok.7;
        Fri, 31 Jul 2020 14:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=u0WnrEEbki1i/hcaafYSzslvQ7FMlY7zypF99r+3B/o=;
        b=c/MJnMa7iFlRBOG02m0T54NzFYPRsxOii1CeQ16KYQkd4QKokIa0N/RND9PSnQzmJx
         he9XFY1jf5LZkpWxNbD2SAbwnXGmTsUf+VIG9o6VK8HcaUB6LUdwqB6beOhniK9hlW00
         Ey4PLP49xYvfKkd8cAiURWATEuBPmZvqdnM2gDOnRfJUjd5FHSivmvmcYbazmgN6gE4B
         ApzN7hy16Bcmn9cYtU1venxzbdUkcaoGF0JmfArVDW++ro0Vr2c7RbREEBR3VlyEcYn9
         JKWbYSAeva3koTpN+9Jun6O6QJ+r3yZn4oqqeVj8ldWj70afnW8AmqVF/7rG5JjcSKuM
         OYSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=u0WnrEEbki1i/hcaafYSzslvQ7FMlY7zypF99r+3B/o=;
        b=N4nT1NzxKWHd30wQ1ZbNTqoBVj/jnagz0H183FNeYFz3xlCFb1A/pDxPtjTpAJQ1Od
         RLqU9QQCjYDbmOyFs/QSrHc74R7pEAILg9pUyd+sB8Fay2fbI3YEuxaPabAaDM/SCBz5
         nyGbAiyTcOx3+FvYtw3Sg/i76pUcYCsnji0QG5aqbsnMuvFgyli6nABhszCSO0xpPX7A
         7MivKvDwGXFb5VPbEwmiMAWrTuIjhGaZh/FsgBfx0mlPwasmiTToiaBrJinUGZdeboYj
         Q0FkeZQNGjuiIDxg8znHW7NO8fh14bFtD/S9/WkgoBcdqEI8HP+IqOwpzNqDcokVKuGU
         orjQ==
X-Gm-Message-State: AOAM53142ClEsgIUC8W28GKIIIRKpKID7rEQ+4RD8s1ypF6aVCYdcb/+
        +zldBQWWX/F3Ju9k6qlNGjs=
X-Google-Smtp-Source: ABdhPJxmhDOHE3IYhuUvM8ElPOuraNw5ha7HN+/8fJSXcVpziYlysuTOoW+LwbRrGLtKjy4Q+ntKag==
X-Received: by 2002:a05:6638:2164:: with SMTP id p4mr7123522jak.57.1596232375349;
        Fri, 31 Jul 2020 14:52:55 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h1sm5330588iob.8.2020.07.31.14.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 14:52:54 -0700 (PDT)
Date:   Fri, 31 Jul 2020 14:52:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        bpf@vger.kernel.org
Message-ID: <5f2492aedba05_54fa2b1d9fe285b42d@john-XPS-13-9370.notmuch>
In-Reply-To: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
Subject: RE: [RFC PATCH bpf-next 0/3] Add a new bpf helper for FDB lookup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yoshiki Komachi wrote:
> This series adds a new bpf helper for doing FDB lookup in the kernel
> tables from XDP programs. This helps users to accelerate Linux bridge
> with XDP.
> =

> In the past, XDP generally required users to reimplement their own
> networking functionalities with specific manners of BPF programming
> by themselves, hindering=C2=A0its=C2=A0potential=C2=A0uses. IMO, bpf he=
lpers to
> access networking stacks in kernel help to mitigate the programming
> costs because users reuse mature Linux networking feature more easily.
> =

> The previous commit 87f5fc7e48dd ("bpf: Provide helper to do forwarding=

> lookups in kernel FIB table") have already added a bpf helper for acces=
s
> FIB in the kernel tables from XDP programs. As a next step, this series=

> introduces the API for FDB lookup. In the future, other bpf helpers for=

> learning and VLAN filtering will also be required in order to realize
> fast XDP-based bridge although these are not included in this series.

Just to clarify for myself. I expect that with just the helpers here
we should only expect static configurations to work, e.g. any learning
and/or aging is not likely to work if we do redirects in the XDP path.

Then next to get a learning/filtering/aging we would need to have a
set of bridge helpers to get that functionality as well? I believe
I'm just repeating what you are saying above, but wanted to check.

Then my next question is can we see some performance numbers? These
things are always trade-off between performance and ease of
use, but would be good to know roughly what we are looking at vs
a native XDP bridge functionality.

Do you have a use case for a static bridge setup? Nothing wrong to
stage things IMO if the 'real' use case needs learning and filtering.

I guess to get STP working you would minimally need learning and
aging?

Thanks,
John=
