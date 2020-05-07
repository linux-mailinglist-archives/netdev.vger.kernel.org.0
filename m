Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDD91C9F41
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 01:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgEGXlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 19:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726464AbgEGXlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 19:41:15 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F56C05BD43;
        Thu,  7 May 2020 16:41:15 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x73so5966674lfa.2;
        Thu, 07 May 2020 16:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G//aQzjVb5BZAr/chm3SF04cQpZHh2YZ+40Gm68unzU=;
        b=mWPEJ3Qkgxe1k88ZypQXffnkkfIBXEUJM7qYy/I96pIkgL0Z8Dk6j8+w9O+1OxuM6I
         8XErjBrJdnhWh4WIA2h65GLKZAOZloV00L4EBoTiNaOYCeSTYX8E13lIj1nEiz0hIrCu
         bHn8/zMHFGXct04jqoB0ZToGM0qeXxit2jr86nlGOgnIZQoyuFrnyaykBAwQc9T0nNRn
         cctVtdP+GxMzx+EWlh4LBWfmWaO/vJk9LjaSp+36nIjYqv7kRhR9zcFGh4yRyb7ySbJ3
         xXvIsdwEWw3z3xC0zh+12WbIJU/tA5bo9lasu07eehZiY4Xc74jYnc/QW8FUSKrd/8Sv
         lM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G//aQzjVb5BZAr/chm3SF04cQpZHh2YZ+40Gm68unzU=;
        b=XB0NyEbLFpRIwE8UP/N6OZ0PBrJSJVOu3NH7EIDI4uAcvH/BWlgf5cfRzsT0bamrCi
         GPyJtWmqLQQisN/1PTKOlc3zxMA41zRk4pCcR85em4mUNGcnUboCW/lbKlspcxpnjJTp
         C1okT70Cw2c4o293JyD8NTJWpUppyKhWXjrubTveW7OOFLFveqkm/1t+w3YevbcfT0Av
         lY/2R8WOgGymyhrw9C6KaA9wRqXXnRgDlTBwl3Br3Qy0D7G+Z6qjLzst6xYExxd07Ta9
         fcPaD98JiMyoNY8lH23ZnB5YpxDiZ4FRxd2TijbdvI5za+ZO3djXtw9gNiNxVDUEp5e/
         OmNA==
X-Gm-Message-State: AGi0PubNnIHkqr0CkEpcTbrvOgxwhtuv4VYke40pJNW6Rsr6U3gIi8Xs
        0A7IPjHSvOEl59a4WBZHqz48m7qXttIuFlo88VATUQ==
X-Google-Smtp-Source: APiQypKbFoWmgggZb25e3dh2FESIhjUdbxrg7tDZivvfNWgq42niyPdZGPIxs8eK47g3dJmfq7pODvlo6vbYYDTxq88=
X-Received: by 2002:a19:505c:: with SMTP id z28mr10320043lfj.174.1588894873513;
 Thu, 07 May 2020 16:41:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+HfNidbgwtLinLQohwocUmoYyRcAG454ggGkCbseQPSA1cpw@mail.gmail.com>
 <877dxnkggf.fsf@toke.dk> <CAJ+HfNhvzZ4JKLRS5=esxCd7o39-OCuDSmdkxCuxR9Y6g5DC0A@mail.gmail.com>
 <871rnvkdhw.fsf@toke.dk> <5eb44eb03f8e1_22a22b23544285b87a@john-XPS-13-9370.notmuch>
In-Reply-To: <5eb44eb03f8e1_22a22b23544285b87a@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 7 May 2020 16:41:02 -0700
Message-ID: <CAADnVQKCHBeyjhAvL+FWPo3OVrhWtX2GHs_vTWpwo_oksVjKxg@mail.gmail.com>
Subject: Re: XDP bpf_tail_call_redirect(): yea or nay?
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 7, 2020 at 11:09 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> I think it would work but I it would be even nicer if clang, verifier
> and jit caught the tail call pattern and did it automatically.

I've been advocating for proper tail calls for some time :)
All it needs is indirect jump instruction in the ISA.
The changes to llvm are trivial. Encoding of new insn is
straightforward as well.
The verifier side is tricky.
What you're proposing makes sense to me.
Somehow I thought that we need full indirect jump from day one,
but above is much simpler. It's a subset of it.
It's still an indirect jump, but target is always fixed.
The register will be initialized with fixed address of next kernel function
(or helper). That should be easy enough to support in the verifier.
llvm will generate:
ld_imm64 rX = addr_of_next_helper // that could be encoded via pseudo,
like for calls to helpers
jmp *rX

We can introduce an extension to JA insn instead that
takes 64-bit immediate or pc relative offset, but I think
it will be more messy to support through llvm, libbpf relocations and
the verifier.
