Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00ED4799D5
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfG2UWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:22:33 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43220 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfG2UWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:22:33 -0400
Received: by mail-lj1-f193.google.com with SMTP id y17so35276317ljk.10;
        Mon, 29 Jul 2019 13:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TlgF/U6C9Nfq0ND+3tkWHMA2RYlrQtMv5J1HVmQnI3s=;
        b=qZFFxhSTnWYnhOUyoGNFKY1OXsUZMIlekuFrMBfcsCNqhbH6TRjlTbpO/fIML5G9ST
         6nt85rNCpCKkS5sG58z/pMyIGRLGoI2HlNPn1riIb2owosn7f2vlUtryy1PUJOSuQYqs
         zEi4rRlVYVRd6A5rzK/KfoguU+DxztSMUozFHVReHztTQW51lrD9a8q8D6A9bDPNm7jK
         jkXzhkuDecRzUhw3B+0njGtxwtPqTjN3eSkky8Rb4pq2mE4+xplP2Miy1FTgMLLsbpkG
         IQLjuX2Tz3XtRBKhDLwnTJ37j4N0wfdDWwAGMAyzgdF0AWo8dznUVcY0jpo8FxVIUNuh
         p8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TlgF/U6C9Nfq0ND+3tkWHMA2RYlrQtMv5J1HVmQnI3s=;
        b=KnojoJlgOjSi5X3XTqX12wn2o0sLLszK/fErh+ZMDmJJnGwLeQzNrzSxlHzbQZ85NZ
         clg74SqKmmJfVs+8mBG/nvgOnSW8GZHuzB1TUQc4pxkJKBq6SArN7O93v+5dQKl5snrp
         Zx4GgDw9wryqYYQAhMsZHWLodc+8cGpVGUEOmVpBlh2eUu3e+t1833DhHPX/cm4lXdk0
         r22oRMttMQMYpmiuDQcfnKJFBSckYyLLF3dqNXI9c1h0je+/RB10uPghRS2K2dK4LGWQ
         xauTdcw7oTR0eBoOJ0m/ottDoxBLbGEoq9glw/E9btdTMseoQAoUca/PRFgPg3S5EgHY
         JrOQ==
X-Gm-Message-State: APjAAAWZpbUMogYWHaLRhBoZcOaUUjBjmCLssqnV/h7jUx9br3iMwyzo
        GVPupfCNB/YD82T03mY7wvx03ALlikZYy/8Vpwb2PBBk
X-Google-Smtp-Source: APXvYqwt688fBsTtG3NbbV1ylAwKCgSA/f7vffyqiJnkE6cHmn3Msa5Lpbef2RxjJttBz0jW9gGP/CJlN3FCW0urFGY=
X-Received: by 2002:a2e:9a19:: with SMTP id o25mr59471615lji.63.1564431751429;
 Mon, 29 Jul 2019 13:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-4-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-4-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 29 Jul 2019 13:22:20 -0700
Message-ID: <CAPhsuW4tbkLyY0tGBZW7dz=qY7NiAbz1MV6UsXPUdctXspn+YQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/10] selftests/bpf: add CO-RE relocs testing setup
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 1:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add CO-RE relocation test runner. Add one simple test validating that
> libbpf's logic for searching for kernel image and loading BTF out of it
> works.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
