Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4911F172335
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbgB0QXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:23:02 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46804 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729689AbgB0QXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 11:23:02 -0500
Received: by mail-lj1-f193.google.com with SMTP id w19so4091532lje.13
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 08:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YmWeTRNmfTQKqKsHRSs7xFxE8r5h0EFqFL8ygC7o+QI=;
        b=u4QrWuu7oyoa5zsAEa3hO2ungqW72W1OhM6M/XtTxwRUlE2pdm/ehAStPRE4iY6EH/
         znlG1J288Fc1b3y7pbFQ/zICvZFilPsiEP+bPLPXWp/dgYD14Rlu2E9zMCtbUAohd4tS
         Cx5O5M5xFtDiLqqHTxgSWaI5wrCoPfcuY4jIGjBvNU5yLtAEhpqEtjw2Kuae0AZ4Kda1
         UibnMn8tIQohr8f3AGyabN+RP5xYwecyF+7SUvbbHpqgBA9w7aI+4D+O6+jD5aicZ+IN
         K+nd6shptV5lkcvPCPOPT6CjOFrLEl7AURCnusrWYpvF2M2Vm5pCzy3obf6nU9M3zglS
         ueMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YmWeTRNmfTQKqKsHRSs7xFxE8r5h0EFqFL8ygC7o+QI=;
        b=HQIp6wgbVlXcSyVc4tHIxKGlb66yhfOJEsgBdZXAkRmO0TmR/wCsDM6gSAoOUb77mJ
         s8D6Fj+rQAXx8xIpGWwOUKv9S0RpI4VTD3MfMhW3jWjQFx0MdvLyYjvf1N6Y9RnIR3pm
         9gLdJIw1X3qCPhoupKvNNQ/8U8erM13qJs+SDTy+rli5VuPrlls3LIto7a33qMWMVwZq
         pCvQizJjPD7b1/JOb+FHOAEFoKJnYl7/rjdM8WR7eoXR3/FA1jqsNOEvhl2QN2hPKrTH
         9NqKPK3EW6ZO3bfHB2ds6eeFclJdOUCT6ymeUDKOYB7UuRXRUcr8o0kcQbX+n8pURWq/
         rTng==
X-Gm-Message-State: ANhLgQ38ygJFUlAd3K4ejbFTAy6JOYpamot15o0jcUhfUWwEirM0Bear
        752Ry++vK6Ykogr0sRMmFhnaNOdIJiJ6aZ0MRCU=
X-Google-Smtp-Source: ADFU+vsKotMdGLr3Kcr9qucD3aeKaS5Y+m2fwC02t1YIRexVIWPfGcg2oh8b6KQAPeDyayaADaYkMGCxCos6DCkyUZI=
X-Received: by 2002:a2e:84d0:: with SMTP id q16mr193373ljh.138.1582820579974;
 Thu, 27 Feb 2020 08:22:59 -0800 (PST)
MIME-Version: 1.0
References: <20200227032013.12385-1-dsahern@kernel.org> <87a754w8gr.fsf@toke.dk>
In-Reply-To: <87a754w8gr.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 27 Feb 2020 08:22:48 -0800
Message-ID: <CAADnVQJOZNP+=woGk8OjUgT8yApkrZ1mCKOgzD1mdqi91F1AYw@mail.gmail.com>
Subject: Re: [PATCH RFC v4 bpf-next 00/11] Add support for XDP in egress path
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 3:55 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> However, my issue with this encoding is that it is write-only: You can't
> inspect a BPF program already loaded into the kernel and tell which type
> it is. So my proposal would be to make it explicit: Expose the
> expected_attach_type as a new field in bpf_prog_info so userspace can
> query it, and clearly document it as, essentially, a program subtype
> that can significantly affect how a program is treated by the kernel.

You had the same request for "freplace" target prog.
My answer to both is still the same:
Please take a look at drgn and the script that Andrey posted.
All this information is trivial to extract from the kernel
without introducing new uapi.
