Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4323DE9DB
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbhHCJmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbhHCJlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:41:22 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4CCC0617BA;
        Tue,  3 Aug 2021 02:40:23 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id db14so10282945qvb.10;
        Tue, 03 Aug 2021 02:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eEM/WUlwtx4hf39m52l1JLiRl2wv7VkPd8bo9YRHmTw=;
        b=lotxXYGxZ2Eyv9JyDkqQpsec5Y9QMObShmBvwV4m3BXxqtxVIOzAA2dEs10C4UTCRc
         3rEcFxJg6qt/Y6F94PWLZc5V0ql7rKcr6ZTh1s9CF7Z1EckGZYlI7V3u+ToVCdAponWT
         YuYnqFXT0xlXBRtuz4+koCBTCfo6zy8CTcYVObJLMKBRBU6PfHwmDhBxgKN8Xkxl+J3y
         vd2Tlj72nhmHcjdBSOisHJvIj6hP4JD9UPSAYFup1clcambsYVrpsgLM9a5f/qDWWCuH
         pfSLTLiI0Aro+U4RgPLVJJuVEmWvn2hM/BS1aqaqPKIHrfiNbBYMyJN7/9jmhQ+jUBUB
         M9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eEM/WUlwtx4hf39m52l1JLiRl2wv7VkPd8bo9YRHmTw=;
        b=ges3W28YrmPPx8SxN5va1VeXsRh1BHBPSojYW82fOAipA8fN1oHPfoawZFEAmWrS/8
         j8mvZM/ZIBqPxn+SfG37dkR7FPOIZl4ziXH/vEHMVdDxjrHbrwC0bZJuTysyZm36OMMF
         qUENfqioPwRAJltKUB0sba0uMU7lZx1mleneoozvlkfhAFJSyObOOUTgTpgcVuJXWn+J
         XkkadHft4RS14BY4kKOhSoMRSWxy1fGCHUkK3PYSLzrw9ghH7SjVkY1asWVPjPRZ593E
         DpnDubRjC/nVWz8uAXffSYK7KwPeXJjYVY57TQvtRb4t0KesTH+mg6jt7W8rmCWWmPS1
         5BRg==
X-Gm-Message-State: AOAM530vU83wbYm7nPM/N7YYGvWnJEBAHmg7FrSqi4kCGx0n/0CqEFj0
        yXXqhlypaOqG1sv8nNkQZkgHBLp0CRB+X3ieiA==
X-Google-Smtp-Source: ABdhPJy4DPTwee4CM3c+Tm5owlyWgAPW1jiwL8X4xwkcuqyl1V5tPTwJEgY379JbJkAMxbG3omuDw5WxeoMyhjCHTR8=
X-Received: by 2002:a0c:e8cc:: with SMTP id m12mr4709162qvo.7.1627983622698;
 Tue, 03 Aug 2021 02:40:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210728234350.28796-1-joamaki@gmail.com>
 <20210728234350.28796-7-joamaki@gmail.com> <CAEf4BzbcavnGdAjV-KjTrFg8bXWF=2qN1j67+09-CgS_Ub+4TQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbcavnGdAjV-KjTrFg8bXWF=2qN1j67+09-CgS_Ub+4TQ@mail.gmail.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Tue, 3 Aug 2021 11:40:11 +0200
Message-ID: <CAHn8xcmjVf+eajrZLhJtF-b-dLCnf--4KZ_Gm-H9Q_ZEOjzFag@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 6/6] selftests/bpf: Add tests for XDP bonding
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 2:19 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Aug 2, 2021 at 6:24 AM <joamaki@gmail.com> wrote:
> >
> > From: Jussi Maki <joamaki@gmail.com>
> >
> > Add a test suite to test XDP bonding implementation
> > over a pair of veth devices.
> >
> > Signed-off-by: Jussi Maki <joamaki@gmail.com>
> > ---
>
> Was there any reason not to use BPF skeleton in your new tests? And
> also bpf_link-based XDP attachment instead of netlink-based?

Not really. I used the existing xdp_redirect_multi test as basis and
that used this approach. I'll give a go at changing this to use the
BPF skeletons.
