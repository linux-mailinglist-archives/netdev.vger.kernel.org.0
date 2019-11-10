Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC91F6A67
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfKJQ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:59:10 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46557 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfKJQ7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 11:59:10 -0500
Received: by mail-qt1-f195.google.com with SMTP id u22so12967540qtq.13;
        Sun, 10 Nov 2019 08:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x56lMj75UBGCWG3P2CTmWKUCSwzgG0qhSgGVczzxiOw=;
        b=dOPR2ojs7EBRnuo5Jelln4jXnAn4X/LfZdgBOC5xAfgRF/2SymAm3IZN3LZJhK+3Ic
         MGFHUoFX27uz1q1920RMuS1bwKWWCu++lHKBqf6Ac5BQk3KuvG2O236rm04kpjLwkPSx
         ZbUAnKkxwoZb+0vDMjLGuDyYKsEe9fJQLfq2D+t2v9JBrhcZ+Sog0eUD3uLeZFYD67Ht
         2kjmjDTT4y3spYm13UecJls9CzDcKx1r8LdAGsCKo2bcG/IbbF1NfDZ7/m5TNjRo8+qf
         r4LrwVs3xGU/rC0B3FlwVVymv/qX2cG0u0FYDtAKH/z3s1rCmBRCOhALh7xO5DYOUWaq
         clsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x56lMj75UBGCWG3P2CTmWKUCSwzgG0qhSgGVczzxiOw=;
        b=ImaWZnEuZkv7bQdp6mEp36IibazWemx7YuPx/KRP2T+07YpR76ZfxT/T02dzx4zRLd
         vyFzZsNLHl+un+YB0z5LXzwiemliQ+C/5lbdy97MPbQx+e4EiWLQxdmUpSvtVdYn2HRI
         KpJuavkyJKFiq2x2neJJk/twSNMJbIJlYQYh5IzvAZ8TlKbzrKvYNlxdKSr//6PxQcXs
         xnYxS+6no0Wd28X2uS46a18sTB0DMa+PHpMGWW6ezi7XvDJqm1Oq83i0am6uBpglQFqv
         UxASk4o/DhudyirlO7VUKHOKoK3CfHkwtaJhgejw0cBqneV6I6gxKzg9+1fa/ql+kNN/
         oSxQ==
X-Gm-Message-State: APjAAAU0X29ENnXnOjvih6G2A/qrygcLHpGkEJ/zVym83UBhV/8PXn2Q
        w165tfvq/R7scMUCvhv6o5LFpAHZf0G54SdBQ7I=
X-Google-Smtp-Source: APXvYqyPDhg2Jbfoj6/SsZY/pIC/zSymX8iSxHMGMNvR2hVN3cezpun2uDtWkoBCHOMV8OgKzB3rY//t4sWmXNe9Ouo=
X-Received: by 2002:aed:35e7:: with SMTP id d36mr21397788qte.59.1573405149505;
 Sun, 10 Nov 2019 08:59:09 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-18-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-18-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 10 Nov 2019 08:58:58 -0800
Message-ID: <CAEf4BzZW2cDBhj1uY_wyZvmsFP9U_eKuMVvvozMWO6fEhr9eMQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 17/18] selftests/bpf: Extend test_pkt_access test
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 10:42 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> The test_pkt_access.o is used by multiple tests. Fix its section name so that
> program type can be automatically detected by libbpf and make it call other
> subprograms with skb argument.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/progs/test_pkt_access.c     | 38 ++++++++++++++++++-
>  1 file changed, 36 insertions(+), 2 deletions(-)
>

[...]
