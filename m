Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81CDABE3D
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 19:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403878AbfIFREJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 13:04:09 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38734 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfIFREJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 13:04:09 -0400
Received: by mail-lj1-f193.google.com with SMTP id y23so6326623ljn.5;
        Fri, 06 Sep 2019 10:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xSkwWVIntzAztHmGrnQ70cK/qaHc5XCXtZJoNVAnchs=;
        b=JnIE9GMir7yHps5tLNcNEJHeRUnZaIfZFdG5mcu3RDZwEDmA0NrAEmldrIGH8I4fSu
         9w2WrT57vt+JKh2/6BpaKSoPEkyRfag4trKz8olb+UNZv0gCwZVGXnM4949BeDOXp5uo
         wq2PwlVmu7P+vp0QLy0+Jg1mYy5I9YzASXoPolOzioDyNDy2Trixj7M5DGGc4EaCe/rv
         niKa1/dqTQsRSIBCBFtRV6WQ9LJ8/JRySXzVVD7dkh1s8jjRoUK9CQ6SqkmcmkcB0qxh
         nqvYI41YAu5AtcoPJWvoRVZmWQR0u1gW5WU8FTP6gkhoWteZ7fNGwazZK/tk6rR2auzH
         KluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xSkwWVIntzAztHmGrnQ70cK/qaHc5XCXtZJoNVAnchs=;
        b=dXCQqdMr3YjlmXAiRrUC6x13opNY2RjGr87ZO0RTChagPBi5hsfVHRZl7zJArxeXe9
         QP3YMVPDFIfmm7UFZXnMpjF+oMfi8KMOJz+fqo3RfwY2RVaLqyI8FOrUj2TsZgYgVICd
         lDQrmw4hRHXAO/HF6UEW7zyDivwaeoKe2OLT8qQahQCTbq/ZMuumLbfiC1L8TumE7Ha/
         Igy0jnCvuDQwQYbdPYmtCgkri5U/3XYMa1mtfIUxIqoHL9nh/ABzp4p8ZeLK15Q1yPuY
         zcwnh3BpLHsAlN9t1LrBbTn28KvY67KJW4dnBAAyrx8YNVC9GT+SeseAadeHyWYFTxh3
         zrMg==
X-Gm-Message-State: APjAAAVWAd7klxO5UEJrW8+41oJbWrPMgir3LViD3j3rfID8ClJ6cEHx
        mqra2+j3XNbMeU7WDMhi8j4VARKmjhiDu2FTsD4=
X-Google-Smtp-Source: APXvYqx+KsNJ1OneC7BDX3h65/Rh370eJBldtEJJrVkVD5KWqi3Z/PYUYxRNxU7MBvmrlIlHduhm8dBMKcmCq+jCChg=
X-Received: by 2002:a2e:87d6:: with SMTP id v22mr5912593ljj.195.1567789446991;
 Fri, 06 Sep 2019 10:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190905175938.599455-1-andriin@fb.com> <0b39dab4fdbe4c678902657c71364abd@SOC-EX01V.e01.socionext.com>
In-Reply-To: <0b39dab4fdbe4c678902657c71364abd@SOC-EX01V.e01.socionext.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 6 Sep 2019 10:03:55 -0700
Message-ID: <CAADnVQKSH+bwXWK=noKuzqDeW9QLu+NQPFnE+x0JDz6O8rBP+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] kbuild: replace BASH-specific ${@:2} with shift
 and ${@}
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 3:34 AM <yamada.masahiro@socionext.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Andrii Nakryiko <andriin@fb.com>
> > Sent: Friday, September 06, 2019 3:00 AM
> > To: bpf@vger.kernel.org; netdev@vger.kernel.org; ast@fb.com;
> > daniel@iogearbox.net
> > Cc: andrii.nakryiko@gmail.com; kernel-team@fb.com; Andrii Nakryiko
> > <andriin@fb.com>; Stephen Rothwell <sfr@canb.auug.org.au>; Yamada,
> > Masahiro/=E5=B1=B1=E7=94=B0 =E7=9C=9F=E5=BC=98 <yamada.masahiro@socione=
xt.com>
> > Subject: [PATCH bpf-next] kbuild: replace BASH-specific ${@:2} with shi=
ft
> > and ${@}
> >
> > ${@:2} is BASH-specific extension, which makes link-vmlinux.sh rely on
> > BASH. Use shift and ${@} instead to fix this issue.
> >
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Fixes: 341dfcf8d78e ("btf: expose BTF info through sysfs")
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Applied. Thanks
