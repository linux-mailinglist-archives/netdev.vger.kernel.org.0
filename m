Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736E0F2113
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 22:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfKFVuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 16:50:25 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38413 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKFVuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 16:50:25 -0500
Received: by mail-lf1-f67.google.com with SMTP id q28so19295517lfa.5;
        Wed, 06 Nov 2019 13:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iz9X76PSdRULdQFuOqOg6MOYzVIoZ6P7KD4jbfK5/n4=;
        b=UI4K3KIpPNhrIOV9V78P9pmWapeIeeAXYSiYCWD9hOxemFQfea4vc15wa1ZEtaaMUT
         iJEkqywkyCjJaZIO44UlkphCPjtr4WCKNNUqDfebQtzZXJqKGyQrYEucNhbEV2t2M0B6
         PaDu6uzudB074EBpnMw2lgktvhOI7RPgUdfOA9zfDoOyJFJxpqmj2OlKSy/LBbRoiA2H
         myPLl3S5v7UK/fdAUhZmAlx0KRCYxFI5ragSzicvIyqFaS6kINMiQP6dGvz3wkxRcsaw
         JNHWCKzAQz8Agsf6s+f/MFGQ3q2MW/Uz+kd5L2qHxXbi3NwJ+7EbBGbflqPgmepdkD58
         OVpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iz9X76PSdRULdQFuOqOg6MOYzVIoZ6P7KD4jbfK5/n4=;
        b=ClI32KJmey65d2JlgxZMLxwdM1qYIn04rc5uv9wKYkpowryXyN9KqjEhjUaD+WlfUB
         kVf/rIVQahND0gz7R9a+pbpRj/NaQ+pRoHUykUAPDELOZ8s/ryicnwe7mChd1DQBMJK8
         3UnzRffjYBown7R3MXVF3JtYdHj+8thC3vnWG6eb5kiRalcFllAk9SaqT+zaIkBnQWvz
         VH8mFCKLJAy65qb7P6S1ouyQz38N00vBoYzFXpSQt2+Q0HH+Avua6mBOCaIkmaRSrj5y
         iaVqorYB2sJXXFS34odG+LatxW77oPEsmSZzwYkZJy7jsYJLDDSDhffrEJG5NIfOeFzd
         Jwxg==
X-Gm-Message-State: APjAAAVEhbYgl8vbLC/+jVrHNRsiS9/UyklgS77cBQXCtoJR6BcyW0oD
        Yk3ayKIN9yYmsTvc3UtwvePYDdX1gzF4RTQoF8w=
X-Google-Smtp-Source: APXvYqzvEvzTHiDdgxCwMwi1BYMwwcIsWHn6tuXKm/UmzI1DHQwqzyXI8HthyB/tMxxjSMyHK6iw4jBSHVEuzZBVIUQ=
X-Received: by 2002:ac2:5453:: with SMTP id d19mr3704195lfn.181.1573077023311;
 Wed, 06 Nov 2019 13:50:23 -0800 (PST)
MIME-Version: 1.0
References: <20191106173659.1978131-1-andriin@fb.com>
In-Reply-To: <20191106173659.1978131-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 6 Nov 2019 13:50:11 -0800
Message-ID: <CAADnVQLkRJE8d1H7vVNYwCb2kixtf5u4eBZN2D6s94t0BnpD=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bps: clean up removed ints relocations
 negative tests
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 9:39 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> As part of 42765ede5c54 ("selftests/bpf: Remove too strict field offset relo
> test cases"), few ints relocations negative (supposed to fail) tests were
> removed, but not completely. Due to them being negative, some leftovers in
> prog_tests/core_reloc.c went unnoticed. Clean them up.
>
> Fixes: 42765ede5c54 ("selftests/bpf: Remove too strict field offset relo test cases")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
