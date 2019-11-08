Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB704F5B31
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfKHWnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:43:41 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:36244 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfKHWnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:43:40 -0500
Received: by mail-qv1-f67.google.com with SMTP id f12so2861519qvu.3;
        Fri, 08 Nov 2019 14:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y18Oyt5B0ILtbblHMT7QPaKaVlkGY0dyBEO5Gq9ppU0=;
        b=Uy27EHov/XZjUWPWYaqmkNnZeMl40gGf7qN56TNEbwDiKO+7GDj41F2rfbmTbBywg5
         /PW6rnHQp5lKXuZBQJhSRTU2VU/vRl8kj48kHWpTzreIyz0dpnmD5IdVCGivXGOhZdtj
         5yImIev5DubXpk/j5n1nF6CWzX5AXm5EyPAMJLkpVW4pcBjfsFxHK2W3L6AcUL2ZoDPE
         MvPA/rl4VhMRC0uJE5373oKhSIu2UjQYKQ2GNK5uM9LehiO3YFaKYQE0LWeSR0FWK4t+
         ehWa4ILKoqwZoQZL72YmW79KKxd8URZOj3FAjWNm5MciPTrPPBNF4zmQtxA76I6EVA4h
         vI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y18Oyt5B0ILtbblHMT7QPaKaVlkGY0dyBEO5Gq9ppU0=;
        b=ra0pwcdXDonB+A3n7McM5okQ7KPBhJktAwBoupGexQdMMZT+8LYX7ihZcKGiRl6Rsd
         3BZ3YNv416jWtn2DoBt4oNZTIpHfHOWEkWFHn7o4jCHB8MbYHjAFxE8Xkcjg/ldUEjE3
         POQBuPkmc4MzUu4hj2m6Sf0DbGdTm/zH9ecRe4eoE1oQlJFiZ+HZZQGPueRIf7OWJWeS
         pjNhc7J/XIptqIhfpjjJo/pG1DpE/XNlUBQogQiWv4CZSpPDYSG4WEraVx3cmbHmKO9g
         eIT0ryOWLgH+HxVdJDWfxZnAdgj9MHJN8ypxiFn1TfaK9gYhPfxKLWPy3wvLVIgX0g9A
         QdJg==
X-Gm-Message-State: APjAAAUEVjo9h8w/yMrE6Ol7LBIqeXRu4MjmohNzLo9Fy3tsedOhkRHs
        wKeeTJWgeZDZvI8IgDu4JIhVyG7Uzbxie5QRylb40UNq
X-Google-Smtp-Source: APXvYqyazE2morUwcCVJGqnXJpL/VMMQ/h/VrJZKHMVwJ2GltA7pC6x8l8Qp+YshIV7i7N/oIWeJ6V+tNEMZMkE+oEk=
X-Received: by 2002:a05:6214:90f:: with SMTP id dj15mr12038002qvb.224.1573253019561;
 Fri, 08 Nov 2019 14:43:39 -0800 (PST)
MIME-Version: 1.0
References: <157324878503.910124.12936814523952521484.stgit@toke.dk> <157324878734.910124.13947548477668878554.stgit@toke.dk>
In-Reply-To: <157324878734.910124.13947548477668878554.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 14:43:27 -0800
Message-ID: <CAEf4BzZpOdoackvjHP3v+Xv8+6adf_Fu70sNbJEU0amc6YOvqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/6] selftests/bpf: Add tests for automatic
 map unpinning on load failure
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 1:33 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This add tests for the different variations of automatic map unpinning on
> load failure.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/prog_tests/pinning.c |   20 ++++++++++++++++=
+---
>  tools/testing/selftests/bpf/progs/test_pinning.c |    2 +-
>  2 files changed, 18 insertions(+), 4 deletions(-)
>

[...]
