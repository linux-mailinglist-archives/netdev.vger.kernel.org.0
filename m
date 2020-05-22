Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299C51DEF8D
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbgEVS5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730840AbgEVS5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:57:07 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C44DC061A0E;
        Fri, 22 May 2020 11:57:06 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f189so11747150qkd.5;
        Fri, 22 May 2020 11:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=APQV4v/L30Z4Y81FbxVFdyi/lVO/94ETl2WC2K645Ik=;
        b=Fka7AlUebwQyt+u7Ee5whzlkNaii7KktmEFF0YJGWJ2Ar+8XWb0xtHTkFdpmvZr87y
         piqFUDgLvUKkI49CXHTV+5Qal1Dx0xabalZ3BUkSsDV6ZE4sXFrGKaMtveYsF5zWk3Au
         NY/Z/8eeQ2MdkqpwjXYVd1U6Y3us/teDCiBI1r95Uv/e0P8d2lsjH+RmkDbx8em/GgPN
         Bzi+qfjocDrArAcMFTpmFIrZbXZZ8pA9/yF+VMVxrbvp/7JBLqyaZ1CJv9m9mgricQsn
         8NINj81VplvdMqLlzSnx1p6eJiX6Cdkz0S8caa7hTUfi6C8ccJWZprz5lXei8DP4C86c
         fuqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=APQV4v/L30Z4Y81FbxVFdyi/lVO/94ETl2WC2K645Ik=;
        b=GAJzy+Lc+Q7rZujueiwliurmuLx9BoIquDc1kYW6Y5PHzuFvuarEPg+8NWMyUXBZXO
         9aB0sr9XeJ1so5VOCTBI0D/wAKhjosn+B8w02Wu4+lbjmWSIkq0DLNOEaJrViu6M7emB
         O2vSgz0/ZLTB5lG50D3eBH3mlOntyrRX8qZs4FPrtPW+11abekXeg4laPF0g6ANSoTFP
         aT0BhdPReygJXNWOC7JRmbpIZtlArxxhE9c2OFP50k/7YvuTD3UXzSxu+zdDod2LA0H7
         i87vXzsu0LPEUIXpqokeEIJDgEC151V/Cbz4HRUybLTf88Mj1edrUS41xN9hDQ+abP2K
         tyzQ==
X-Gm-Message-State: AOAM532hWJGWZo9BPJzqS+deWn5mosR7T6P7awetOUvtr67VpgbDcFpq
        qLzoV8lBNBfxfEnIr9FqBIj/6WiPP2ycKkFWVjy/In9cfxE=
X-Google-Smtp-Source: ABdhPJyAhszvbrHcLJZd9N2jC8LSH8+XiM1AT3F5aVefXlmJtY3dYM+7rBb1CasF+OLGHbGmqnt8184TYimgnTh/hL8=
X-Received: by 2002:a37:6508:: with SMTP id z8mr4087360qkb.39.1590173824833;
 Fri, 22 May 2020 11:57:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-5-andriin@fb.com>
 <20200522011552.ak4dkxhqwg6j2koy@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200522011552.ak4dkxhqwg6j2koy@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 May 2020 11:56:54 -0700
Message-ID: <CAEf4BzbWj28btDvzDJCJMpRJ55hiydV9c+F_pEFvuA4bMeb+Bg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/7] libbpf: add BPF ring buffer support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 6:15 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, May 17, 2020 at 12:57:24PM -0700, Andrii Nakryiko wrote:
> > +
> > +static inline int roundup_len(__u32 len)
> > +{
> > +     /* clear out top 2 bits */
> > +     len <<= 2;
> > +     len >>= 2;
>
> what this is for?
> Overflow prevention?
> but kernel checked the size already?

No, as comment above says, just clearing upper two bits (busy bit and
discard bit). Busy bit should be 0, but discard bit could be set for
discarded record. I could have written this equivalently as:

len = (len & ~(1 << BPF_RINGBUF_DISCARD_BIT));

But I think compiler won't optimize it to two bit shifts, assuming bit
#31 might be set.

>
> > +     /* add length prefix */
> > +     len += BPF_RINGBUF_HDR_SZ;
> > +     /* round up to 8 byte alignment */
> > +     return (len + 7) / 8 * 8;
> > +}
> > +
