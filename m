Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE7B179F5B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgCEFko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:40:44 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45554 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgCEFko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:40:44 -0500
Received: by mail-qv1-f68.google.com with SMTP id r8so1911337qvs.12;
        Wed, 04 Mar 2020 21:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=THBYMEY1yGfalLtbzYiKSYkmAX5Lj+jvZpr5bKLPTp0=;
        b=EZZv6hqD7ymuE6lbhHNuFocVxoT/8FJaP+Xdqv6NKFkH2BKU/X52VI7p/f0086Cvex
         A1xR+vIZOTlfJFozjl7vvRT12YHemz/A6ZbTZe9FB5ikmBiBbxI9W/q4qBGKIMHmWz9n
         tPAQnLeUfE67fU17daLSM8SxDrAaIJBF5vsbTbLMf87QcxItNe9GtxLwZFUBT1Ov/yDQ
         p4VkR/YCQzHiq7P42dX/faOLX8Rg3fb8D1jgQZ1QWXDM8BrfdVVCRui5QMvSAD9jyQCb
         xe9VDdDqfkk8qtrS/XaXQajELx7JA1AomSuxIJrZv+L+cYhrzmFyUyP3gmWH5B2Y8mko
         qbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=THBYMEY1yGfalLtbzYiKSYkmAX5Lj+jvZpr5bKLPTp0=;
        b=Bqr6jnkWOuh93IqQwI8pmzyIyvbhjMFazHdJLt3U9uAZNGmuouklLQlWG/XQXg8o8X
         17J76YM5cJy5J3T5cbvdd4ai957f1zEvh4++K6SEgmloplgvPyvHDwQwZRp54U3+Aw1C
         WFeLR0Cr9DWsE5Y6EEUo4QrvXkrdz40VbuteKk4yDW50CPQ9GEhsKs2KSGyQf9eiN2EM
         2MuWZJFWLcDT/Ga7BrPhuubxlLaGW8q7Gd8w+FIz3cNFXqtwYEBx5pMinW4mIJCVsX4i
         XkwSy8Ga6bJ5J+7SYH9Ew+u3AUIEgY4PKu/yMUiw+09/1uJzVjLxDl+KUMrx7jvljeAf
         U4QA==
X-Gm-Message-State: ANhLgQ1Eoo6mHb3Vd/iH/tWEJx0gvGDx5lNYxPPz8I6Wxvd+o+BjXL1b
        CpXixewA8xf7oV11COcp3bNo8P3HcwTdyyH30CM=
X-Google-Smtp-Source: ADFU+vtfOIyH1BW9riEZRACvPgvUTdUP01Lk72U0ekfmC8baXSmHIuWMubjgSVFDnAmUEs9i1uAgEiXwdE9VRISclzc=
X-Received: by 2002:ad4:4f87:: with SMTP id em7mr4923418qvb.97.1583386840011;
 Wed, 04 Mar 2020 21:40:40 -0800 (PST)
MIME-Version: 1.0
References: <20200305050207.4159-1-luke.r.nels@gmail.com>
In-Reply-To: <20200305050207.4159-1-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 5 Mar 2020 06:40:28 +0100
Message-ID: <CAJ+HfNjrUxVqpBgC-WLHbZX7_7Gd-Lk7ghrmASTmaNySuXVUfg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/4] eBPF JIT for RV32G
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Mar 2020 at 06:02, Luke Nelson <lukenels@cs.washington.edu> wrote=
:
>
> This series adds an eBPF JIT for 32-bit RISC-V (RV32G) to the kernel,
> adapted from the RV64 JIT and the 32-bit ARM JIT.
>

Nice work! Thanks for hanging in there!

For the series,
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
