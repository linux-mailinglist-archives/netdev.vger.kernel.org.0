Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A0E2215C8
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgGOUI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGOUI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 16:08:56 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5561C061755;
        Wed, 15 Jul 2020 13:08:55 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c80so7056023wme.0;
        Wed, 15 Jul 2020 13:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TolZEtxgsV3An5H/SdGdZj4fiN57mXcD++DOPxm6nec=;
        b=jnQVra4+13tS061DNIkTvsRN58izvTQtayCFy3EenQN3TZszDfT5iQLKl4CCwDqXac
         mxK9lP5rUoskc/FzlXEjYSQ22MICw9Ui5tV3HckDCZIIFV+54zKHfWCZgYgTUk+/61nc
         rCKSyiStxwsayPsHroTFsJkBZoB2PHBxrq/zRKBXKsRApgfUlHICMl6a5toV5myHQ/Ij
         Tnn292G6AN8i7Yxz7kQTNMpq6TJF6bVlC9KWpmmPQ5tLqqLvKmon9O8RB9aSvc/bFnK9
         lSmT5ex5uekMteqlOYR7EnNLWRxDWzM69X6xAGMJ0ujYqE03nCF6nbcps76viWv163se
         /4ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TolZEtxgsV3An5H/SdGdZj4fiN57mXcD++DOPxm6nec=;
        b=TMjffXnktfJTcJbbAQ629AR9Mg92zIQEBMLCOpiN1vUbCJlq9K0gxnybuJQ44C/cxP
         FanScgvrxRUcDaA+gM4JEKYSIPrgnCIQc0k/70FEo7miqKHylMZKOb5Yb0RU7XVEgonx
         6UwtW5xeeLyh4gett2xqw0t3B+D2qJt6gIKzFMs6nQO3oFhIlIj6+arHVHOCfxuUuSxv
         9VYQBSHcYijl3DTszWFMf0S4LyP1Gj0TdsBX1SL4wdxVFSFPDCpnAPfHhKSOLMQdLfMr
         JncmGcAkmQll1om1xoFnA5fRIvGDRZ/RqIthqIhzN78ykAoopBcRPMZjIuPzt0zwoNNh
         rR+w==
X-Gm-Message-State: AOAM530sAuHqJZI5FQ86WiZu6ko3KwM2i90bFyABA4+uDYWJGh9hUVF1
        dDBbqeFFxKkQ3AM71nIIizJaBiioMthK8sXCbE0=
X-Google-Smtp-Source: ABdhPJxxxn/p48diSigUNGjm4Jnah7ajXIZF5W1reXQTfbH4SrdS7LWBtgRqa0NxXagT2e1CXjGCce/zqJQ+MyLpXa8=
X-Received: by 2002:a1c:ab56:: with SMTP id u83mr1111488wme.94.1594843734608;
 Wed, 15 Jul 2020 13:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200713183711.762244-1-luke.r.nels@gmail.com> <CAJ+HfNg_qV=umB9T1U9vRo2pUpmUFfBN44WpAOfMoi75Ymh2dw@mail.gmail.com>
In-Reply-To: <CAJ+HfNg_qV=umB9T1U9vRo2pUpmUFfBN44WpAOfMoi75Ymh2dw@mail.gmail.com>
From:   Luke Nelson <luke.r.nels@gmail.com>
Date:   Wed, 15 Jul 2020 13:08:43 -0700
Message-ID: <CAB-e3NQFE9rsVZ55Y=jivuBsd1A+V4GWtceqjOz80qtmFsFQVA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/3] bpf, riscv: Add compressed instructions
 to rv64 JIT
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Luke Nelson <lukenels@cs.washington.edu>,
        bpf <bpf@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> First of all; Really nice work. I like this, and it makes the code
> easier to read as well (e.g. emit_mv). I'm a bit curious why you only
> did it for RV64, and not RV32? I have some minor comments on the
> patches. I strongly encourage you to submit this as a proper (non-RFC)
> set for bpf-next.
>

Thanks for the feedback! I'll clean up the patches and address your
comments in the next revision.

The patch adding RVC to the RV32 JIT is forthcoming; some of the
optimizations there are more difficult since the RV32 JIT makes more
use of "internal" jumps whose offsets depend on the sizes of emitted
instructions. I plan to clean up that code and add RVC support in a
future series.

- Luke
