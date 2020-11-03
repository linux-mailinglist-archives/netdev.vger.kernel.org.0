Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4FF2A4D76
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgKCRsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbgKCRsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:48:30 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECFAC0613D1;
        Tue,  3 Nov 2020 09:48:29 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id a7so23335240lfk.9;
        Tue, 03 Nov 2020 09:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mYXorWBr8zWL+PHmzYaHbLemVXqGBhRfqAs8l+ZRgEE=;
        b=kjnXBbqL8Ln18ggUu5jM7UkT1rA3vT2wWjABXMSj8pISDYROm8tmHzYZcoPGPS8rAa
         o2gNNuKqDRaAL7XpLC2jsyZnouaf8HaQrym6sWf9U722yuwOGlg9vsxIWT4W9Ce/pE95
         ZSWDEveq/M8BXhVskMyD5XhAlXuSOxtVzImNCHRPepkG9oWPF06Pav29O6/RqvtR4rv5
         kjDA74l/z5ELKDXNYUh2TB2kbGh/JhltDBF6+xHQ/HNvjD5MFuuf8fJg6LEZ6Mg6SvLq
         SBz/aE4YGi8w0+OQhpc0QPETZPVtP+EY5rs5ApOOb6zNMcBF2oUdVwfQFnkZLD0XkK+e
         ZQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mYXorWBr8zWL+PHmzYaHbLemVXqGBhRfqAs8l+ZRgEE=;
        b=jLeMIV9OqS+hBsCVgz04/BOSKHgdldkGbXnUqQEmOZSTx2Gou+BNxuVp5K5ob0q0Rp
         ttSVzsdtar2hvlTOp9JN+l47qgG6At1vRuHacduDHKWGCiUZ3pDmPSYuIUVwOCVGkob7
         ibcUeQH3TpZAZ78NqgOzsK1yWvOA25XZctIhFA9OS6HBgLt60CX4COdsT4vWP1nkE+mn
         WHfz5RRmtgHeTvhBn6tJ3ww6m8LMZNE4PijjW7P6E9CrMwKfXdnFumhoZwGA15P8+UL5
         RNnmWp3XAcJD90qztLP1njtUHNxQe9+kGzLCfOi87jbahZ3PVuXsQ63VieZlUFAAAyPT
         dzfg==
X-Gm-Message-State: AOAM533aoX+0w3QTbbxzhX0OSQesoumMG4o3KQgDsaQVftX/6H0VkTCS
        zUGGmogKJPjtg/Um2c1EOHTFQk1EgMbBqt5EVyEni9STo3U=
X-Google-Smtp-Source: ABdhPJwa6l65rSy3oL6HS27i7jYIn8x6QRck7WvFA84GxNvJZS2Qk0jPMgt4E9FfOm1MNkn7u5JZ0kltzcieR7ipf1c=
X-Received: by 2002:a19:6912:: with SMTP id e18mr7799428lfc.196.1604425707620;
 Tue, 03 Nov 2020 09:48:27 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <20201103094224.6de1470d@redhat.com>
In-Reply-To: <20201103094224.6de1470d@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 3 Nov 2020 09:48:15 -0800
Message-ID: <CAADnVQ+3Q850dmSssaQCa9yi-d3G3FCHPkVd2N8y8OMJ0++E=w@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 12:42 AM Jiri Benc <jbenc@redhat.com> wrote:
> sight, this sounds easier for the developers. Why bother with dynamic
> linking at all? Everything can be linked statically.

That's exactly what some companies do.
Linking everything statically provides stronger security.
