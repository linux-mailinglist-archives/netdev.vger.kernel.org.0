Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C7F1D2357
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732865AbgENAAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732861AbgENAAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 20:00:00 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB717C061A0E
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 16:59:59 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a21so1478430ljj.11
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 16:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fasYih196bvKUHb0YCxHna3fp2u2qNy7HWnYHVsQ+sQ=;
        b=fD3hyHvKHx/67q1VTFKCR74zDcE6394aAhGXhl0a0C48TMMb4AnhPQvs7IdErH6CX2
         um+ec95QL1F0EfXLmER3SmoJ0T+gygc4SnxysABRELnzBjVWudgYOLaUmLBf8bjna0/G
         B5XXX5vTTIkGXj8ZYK86YltWbiai+htzLW22s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fasYih196bvKUHb0YCxHna3fp2u2qNy7HWnYHVsQ+sQ=;
        b=mLl09OXdmQ++fKeLhT5/HugiBlw/FUi97xNlHvvAeNHkXuC+4gb9jJesEyI+NBclb/
         bYDEdUqnE/FZ8pKxkPZr+bLHbpa2vP07l7JIhtuLXTtAN5XXNSheQHJ/HSQQxCXO0OuR
         lYZd3U59S1JSfAl+N/jnICqAxNnMs/sSXvShyMa414ROCW4soOCX7vg/Q+W1D/hPan4q
         Z3MZ0jocF550YoLm+N5aMI+R53MDFScLCD45odWmwNsC2VVPErhmtdjRHV9Phf4I3dMP
         A6aG2FObYBkpVwXnX1z5xl+9dyiY476RmljbilkANohV1VFbAbJOqmG//b3olmSrEf4Y
         hfpQ==
X-Gm-Message-State: AOAM533T8d/wR7/NT9Vxk9AHu4roBSo8wMFljvrXrPRDQVkXcCpaUU0w
        lxnRlWQ4FPv23hVfqabCyG9jQAq9tHg=
X-Google-Smtp-Source: ABdhPJx2KCUMnSSfOJoatx0HifMQrkoL/mEVWAA3XVgyqBpnBP144G6XLSw+gilM3VU6H5Md8pXyVg==
X-Received: by 2002:a05:651c:1104:: with SMTP id d4mr919677ljo.128.1589414397738;
        Wed, 13 May 2020 16:59:57 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id a8sm444100ljp.102.2020.05.13.16.59.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 16:59:56 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id g1so1499424ljk.7
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 16:59:56 -0700 (PDT)
X-Received: by 2002:a05:651c:319:: with SMTP id a25mr857486ljp.209.1589414396039;
 Wed, 13 May 2020 16:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200513160038.2482415-1-hch@lst.de> <20200513160038.2482415-12-hch@lst.de>
 <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
 <20200513192804.GA30751@lst.de> <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
 <20200514082054.f817721ce196f134e6820644@kernel.org>
In-Reply-To: <20200514082054.f817721ce196f134e6820644@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 13 May 2020 16:59:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjBKGLyf1d53GwfUTZiK_XPdujwh+u2XSpD2HWRV01Afw@mail.gmail.com>
Message-ID: <CAHk-=wjBKGLyf1d53GwfUTZiK_XPdujwh+u2XSpD2HWRV01Afw@mail.gmail.com>
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Christoph Hellwig <hch@lst.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 4:21 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
>
> For trace_kprobe.c current order (kernel -> user fallback) is preferred
> because it has another function dedicated for user memory.

Well, then it should just use the "strict" kernel-only one for the
non-user memory.

But yes, if there are legacy interfaces, then we might want to say
"these continue to work for the legacy case on platforms where we can
tell which kind of pointer it is from the bit pattern".

But we should likely at least disallow it entirely on platforms where
we really can't - or pick one hardcoded choice. On sparc, you really
_have_ to specify one or the other.

                  Linus
