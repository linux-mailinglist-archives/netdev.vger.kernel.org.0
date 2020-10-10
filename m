Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24B528A4A4
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgJJX4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 19:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgJJX4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 19:56:12 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F197C0613D0;
        Sat, 10 Oct 2020 16:56:12 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id n142so10339965ybf.7;
        Sat, 10 Oct 2020 16:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YIXQTwLTpUOuJgxV2OPwDZm/iRJDixtKJl76tm+Korc=;
        b=E00TWHyjQERW2N0mKAM6evLPXVYZfjPCKjcfWHtc6pnJh+BCjx1zMqmMYw23A5yGB0
         1gZdHEbZruS8PvR1Xn8RFVdqEw+3I4zeaNKrbgbqdkI4wF33OTuhQZqgXxwwzHw3tZT7
         4s6rCG4ffaUh0Bi6UDe4Hv48KlIiG7SmEnhyM4Lb9gs59qHHH183Nr+3n+B8bAKNo/NE
         asNN2WlHq5qwCI2yy1wxLHDphk1KZflN6qCWrWslMHN78nHFWXHhTZEB6w5jUoE+xgIT
         kV1Smay3zyBLy6yG9TqJeXDgP+PnM28vfZLe4H+LwaVbLHqCKPUmdl0X3mFDUhUMB4MT
         j8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YIXQTwLTpUOuJgxV2OPwDZm/iRJDixtKJl76tm+Korc=;
        b=CUOZUJIL+JeLKWikPz/M6EqenLQ0rhjtzQj2wtFphgD+WM3yH/JQ6TbZ5DHIic0k8w
         Ahotpl0KoBJWPYFArlLGvIbAk0uq+JLaO2+fCO0HiYdFZJHgjcEbfLNSJKah8s5OhOir
         dE9uISwhVMYR8XwbtqoNXN46vJnoZo+ZoGARwF/XUCRsKXAcxO9R8apv3d8W0RGjoVFl
         hx1PUcZe+b81ewkSuZYsDp2ecAP6K53Vmkmw/h1nPOEUUxuRX5PfXuLgW+FCfu6TtJAV
         QH382RlBUvKQYEkn6J/ayMIxulTFykBZhDfIWW5/59SB7hIy/HvtT6wvQQkrWYDYcc/W
         r+gg==
X-Gm-Message-State: AOAM531dy4P7lHg0lMKCSQc7rzDRbF7KH0SVZ33+X19U4KbYsEWEaUZX
        ofGTn24y0/JKQeMvOZCCe0dnNAFshjpUPMFXbutbrp3aeWWDRw==
X-Google-Smtp-Source: ABdhPJz86hF0omTwBZ9V1usQdzXzlfXKrt+1GbSWB4y8g1X0fbcCwypc7RAIFxXyIMsdfuzVhZ+sLwDNelP9ws5xmrY=
X-Received: by 2002:a25:3443:: with SMTP id b64mr3774016yba.510.1602374171501;
 Sat, 10 Oct 2020 16:56:11 -0700 (PDT)
MIME-Version: 1.0
References: <20201010181734.1109-1-danieltimlee@gmail.com> <20201010181734.1109-4-danieltimlee@gmail.com>
In-Reply-To: <20201010181734.1109-4-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 10 Oct 2020 16:56:00 -0700
Message-ID: <CAEf4Bzbz8Ycikmsg5mKeuMkBboJ7DuTTBGq0yv+ZMg2TDLqNtw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/3] samples: bpf: refactor XDP kern program
 maps with BTF-defined map
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 11:17 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Most of the samples were converted to use the new BTF-defined MAP as
> they moved to libbpf, but some of the samples were missing.
>
> Instead of using the previous BPF MAP definition, this commit refactors
> xdp_monitor and xdp_sample_pkts_kern MAP definition with the new
> BTF-defined MAP format.
>
> Also, this commit removes the max_entries attribute at PERF_EVENT_ARRAY
> map type. The libbpf's bpf_object__create_map() will automatically
> set max_entries to the maximum configured number of CPUs on the host.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> ---
> Changes in v2:
>  - revert BTF key/val type to default of BPF_MAP_TYPE_PERF_EVENT_ARRAY
>

Acked-by: Andrii Nakryiko <andrii@kernel.org>


>  samples/bpf/xdp_monitor_kern.c     | 60 +++++++++++++++---------------
>  samples/bpf/xdp_sample_pkts_kern.c | 14 +++----
>  samples/bpf/xdp_sample_pkts_user.c |  1 -
>  3 files changed, 36 insertions(+), 39 deletions(-)
>

[...]
