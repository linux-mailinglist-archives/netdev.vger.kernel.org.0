Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF490232AC5
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 06:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgG3EVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 00:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgG3EVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 00:21:04 -0400
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE8F122B43;
        Thu, 30 Jul 2020 04:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596082864;
        bh=YKnjMCcJfV16uIP9PoRTAu3+LNc2cb5A4H1CSbCCmBY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TnVZt9cc/hroMxwAMq2ORgJuPnjSAg13WiK5gz3S+611wyaFUlzGKczmEdJEERXxV
         MiVri0yuyZ2vrzXufatLW+JdXSN55m+/k3lWjA10pScD/zoXF1zezCE5EVD5nhwIsR
         BHnJowxuL0b6oIZ3SJ0XqOuJed1h6GDKf4IXbWhs=
Received: by mail-lj1-f170.google.com with SMTP id q6so27398549ljp.4;
        Wed, 29 Jul 2020 21:21:03 -0700 (PDT)
X-Gm-Message-State: AOAM533QT/eMrOCMXGWmLiyzioixTu8/7de6uUxBVSyqxYfBytMgrGC+
        67dvTd3aMuJ1/ECRlW0g7iRFYGM5ttmVc9Le/kw=
X-Google-Smtp-Source: ABdhPJxvCiEiGgFOg2IhZc3eN+ErOdyU9hMyD5XdGmghMVilyQ7Y5qNT20wnRfoDzTV+/r5fb4GUj9h4Em106ogIneI=
X-Received: by 2002:a05:651c:1349:: with SMTP id j9mr499381ljb.392.1596082862079;
 Wed, 29 Jul 2020 21:21:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200729232148.896125-1-andriin@fb.com>
In-Reply-To: <20200729232148.896125-1-andriin@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 29 Jul 2020 21:20:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6apm_oL+9JZ3o7b1hq+7O7-9X-FAHt_oy1BOk_o6VWRQ@mail.gmail.com>
Message-ID: <CAPhsuW6apm_oL+9JZ3o7b1hq+7O7-9X-FAHt_oy1BOk_o6VWRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: make destructors more robust by handling
 ERR_PTR(err) cases
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 4:22 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Most of libbpf "constructors" on failure return ERR_PTR(err) result encoded as
> a pointer. It's a common mistake to eventually pass such malformed pointers
> into xxx__destroy()/xxx__free() "destructors". So instead of fixing up
> clean up code in selftests and user programs, handle such error pointers in
> destructors themselves. This works beautifully for NULL pointers passed to
> destructors, so might as well just work for error pointers.
>
> Suggested-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
