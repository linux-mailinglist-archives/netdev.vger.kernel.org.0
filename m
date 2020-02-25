Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E4B16B9E1
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 07:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgBYGmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 01:42:05 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33268 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgBYGmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 01:42:05 -0500
Received: by mail-qt1-f195.google.com with SMTP id d5so8372931qto.0;
        Mon, 24 Feb 2020 22:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CjACLIW/ztf9uXbrc9lIWhWHMhhHprWeuEL61GFpnss=;
        b=pWo/lJ0ohpndxU57k182UbHL/4Q+95c1oCthXKhX5P5SC3ugrhMElve0Xdic/dEY6J
         kN/HJW3c7OpdxFS/D86Kle+HorN5J/n2AIp/9N6w47snqw8Nd/J8Cm3tWmsmiSYgzB/O
         CgPR+KAzDhanZOnjUJ8BqT9xNDqaNxmZ8ATbztpnWvPGMLvJXESAfTZME3hQ0sYAMvqL
         eVS0DhPOdT7oj1zy+/J6K/hHwVRxG6qzKHzEx75MDGmgw6N9VkzmJHDUhxUZx3tJXxtZ
         2/paeYlw8pXuV0mb8qfh6xtCdmt9KiYv2um7Smi3nz125AJWrBAXlxbgoPXSyP/oNGuA
         SPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CjACLIW/ztf9uXbrc9lIWhWHMhhHprWeuEL61GFpnss=;
        b=gTpQQ2PIz/CluZA0NJ3ndBSXPfvD/BZnRE6rKXZjq5B/my4bbndiNJUPLOKmiVmTNX
         dPKCkb6fKjnrBBmmSC5Zesdaal/T3+JJnSukqcwJKan2ZVawQqRDOZAJtId9UrfdnH/Y
         i5qEiKFd6Un9Fu8pgr5zuoHtcg4N/T4g4krtvUSTsMYVQAp1x6yvF/DJdOQ+G/ajTbli
         878ZFFS7eKU73aEQALax9N9TqHMA0Q/764LDIq3oWQVWYnXxiok2PTz2zSSjQKs2BfHD
         qPp7ah9OLGRRWe8m0n4vrD0xxMNZ3cXVDo//lfz2cSV3oKQUCikzD+z274VvxPYUSsFE
         SPSQ==
X-Gm-Message-State: APjAAAUd+j1oSPCxZbpGzP0P2JokKwTz4ezUU1gylRQ3xIpeCwtrtLVv
        k3yga3DIlxogH7QIwXR+aZ3+ylLBl+fr5el6rB8=
X-Google-Smtp-Source: APXvYqzuUu3LTqLatCxP+WEwHX/BTN2Ky4+aNnyZqZkcKIwMIrRJ2BJWdFX7dCsHLrz8l6iFMJJmAwuJb/4d420P/eI=
X-Received: by 2002:ac8:9e:: with SMTP id c30mr53592557qtg.359.1582612924150;
 Mon, 24 Feb 2020 22:42:04 -0800 (PST)
MIME-Version: 1.0
References: <20200220041608.30289-1-lukenels@cs.washington.edu> <CAADnVQJTtNu5a2oM=8poe6FHXeQttG44S+7XvuqQtv1Cgui8tg@mail.gmail.com>
In-Reply-To: <CAADnVQJTtNu5a2oM=8poe6FHXeQttG44S+7XvuqQtv1Cgui8tg@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 25 Feb 2020 07:41:52 +0100
Message-ID: <CAJ+HfNgBNHQ=sOgjZy1NZ+VnG2hYNCqJvueS9Xjgm0DswLPp9g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] RV32G eBPF JIT
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Luke Nelson <lukenels@cs.washington.edu>,
        bpf <bpf@vger.kernel.org>, Jiong Wang <jiong.wang@netronome.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Feb 2020 at 01:42, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
[...]
> > Co-developed-by: Xi Wang <xi.wang@gmail.com>
> > Signed-off-by: Xi Wang <xi.wang@gmail.com>
> > Signed-off-by: Luke Nelson <lukenels@cs.washington.edu>
>
> Bjorn,
>
> please review.

Alexei/Luke/Xi -- Sorry for the late reply. I'll do a review ASAP.
