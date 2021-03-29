Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC8F34C142
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhC2BqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhC2Bp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:45:29 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF6AC061574;
        Sun, 28 Mar 2021 18:45:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so6952398pjh.1;
        Sun, 28 Mar 2021 18:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H8D3sGtLUXJOTzb0NqtEbyGHIovhRrWGfN86FA/SzbI=;
        b=kmmLAvVLSv+dgFeuvv9Hiqzz+TFTzYgoQQRIedNm3oyaPm4q9RR5udQo42Uie7F31a
         uuK+mI5ALbVAWk/GlHFWc4TGUMHQTH79RO8Bl66Ci0lrNBba9TeF1gp6SnJc2gpIDgok
         J1v4WOWQ1Qz+oafm8Nkcs82DtSCeP/8QJw7XN1mXgw0wAouEK43/MfFv3p1hDXlkgNde
         Lwd4KZkFGai0/4Jqm0yCOEiBzR96Sk0o9psiDHqSWOEsapK9E53McPDYBklcGEezFrpA
         OwfVvdHR+zDZ6Bye/vhzpAFnQcPsVuRFOl2T8rKCCaoZXhLOF7z4A4iLRqi9jVLkX7uy
         +Flw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H8D3sGtLUXJOTzb0NqtEbyGHIovhRrWGfN86FA/SzbI=;
        b=TCuYe0FXWATAg4Bh2E2D/DHdP+i8GSsaGPHPD2QXNkD15cmji6dT1SzfDWTkZAQcte
         K9vWfjaZo0OdH+JUEiH77Ox060aGR7RbhjUz57hXMu9ttRJIKQwpfPBJ756H6eodiZES
         TfoU3solcJPTbp2wT5u1tNHIrrEcIoeTLHmS+8KERMAUFEsXFK/kVqyE3zwi4KUZNxaU
         3RHomfkLUmol2IlyJbUt42652FzYcTVxF8RLVZofqEla/UjLB/V2lGVOl9GiU4HrcnJr
         AN2ycwxMMZkRhBwbGgBAj/Byt+DRVf7rhtY0QrcU4ZOrCSZmbCrcaOUNg1pnTAWmGdvp
         GPHg==
X-Gm-Message-State: AOAM530OJRkJsPEbBbHyN1Wmv9nTBZieXYZDY3bvKaJN6/6N/1nULC6x
        0+1QWoHYtiZXOH3Qo46dg/M=
X-Google-Smtp-Source: ABdhPJxdei1FyzEUawUp2kv5omuyvqrbNp49jh9MWoBVGE7DLOmjFTOFyoCC5tOLAEyJlzCdBnTI/w==
X-Received: by 2002:a17:90a:a88d:: with SMTP id h13mr23502208pjq.61.1616982328799;
        Sun, 28 Mar 2021 18:45:28 -0700 (PDT)
Received: from localhost ([112.79.240.89])
        by smtp.gmail.com with ESMTPSA id k11sm13564044pjs.1.2021.03.28.18.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 18:45:28 -0700 (PDT)
Date:   Mon, 29 Mar 2021 07:15:25 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, brouer@redhat.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next 5/5] libbpf: add selftests for TC-BPF API
Message-ID: <20210329014328.srm6y7d6odmgzhri@apollo>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-6-memxor@gmail.com>
 <20210327021534.pjfjctcdczj7facs@ast-mbp>
 <87h7kwaao3.fsf@toke.dk>
 <20210329012602.4zzysn2ewbarbn3d@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329012602.4zzysn2ewbarbn3d@ast-mbp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 06:56:02AM IST, Alexei Starovoitov wrote:
> This is up to you. I'm trying to understand the motivation for *_block() apis.
> I'm not taking a stance for/against them.

The block APIs simply attach to a different shared filter block, so in that
sense they just forward to the bpf_tc_cls_*_dev API internally, where parent_id
is substituted as block_index, and ifindex is set to a special value (to
indicate operation on a block), but is still a distinct attach point, and both
APIs cannot be mixed (i.e. manipulation of filter attached using block API is
not possible using dev API).

e.g.

# tc qdisc add dev <foo> ingress block 1
# tc qdisc add dev <bar> ingress block 1

Now you can attach a filter to the shared block, e.g.

# tc filter add block 1 bpf /home/kkd/foo.o sec cls direct-action

and it will attach the identical filter with the bpf prog classifier to both
qdiscs in one go, instead of having to duplicate filter creation for each qdisc.
You can add arbitrarily many qdiscs to such a filter block, easing filter
management, and saving on resources.

So for the API, it made sense to separate this into its own function as it is a
different attach point, both for the low level API and their higher level
wrappers. This does increase the symbol count, but maintenance wise it is
zero-cost since it simply forwards to the dev functions.

As for the tests, I'll add them for the block API in v2, when I get around to
sending it (i.e. after the review is over).

> [...]

--
Kartikeya
