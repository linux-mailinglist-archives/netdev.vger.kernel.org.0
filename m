Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D41634B3B5
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 03:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhC0CQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 22:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhC0CPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 22:15:38 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCCBC0613AA;
        Fri, 26 Mar 2021 19:15:38 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id s11so2254pfm.1;
        Fri, 26 Mar 2021 19:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xe/Aq3/7m+CfZN6O/GcCkef3Jq0yzqRxc25xU578GNI=;
        b=EqozHY7rvp5xNqmvIMWrJ45wKCxAmLguoXBKOw3UqEn2FKPeoVD9JzxcMWHbbaKlZE
         Am+1L35j3o9kN+wRNn2eB3guHv7mfeD/V5vIGTWxrW4brGEJ1KeojC/TH0rIUflNfuLn
         jlnNp4LefkmeUIJ7LpX6x36+lKRKlfe00E34H1pxlJ/svyRAfuHSavyWX2p/jAW29XXL
         IxdaweLEzo/4/HelCcK+ZC+ylz1W84GgLMegoNu905wX7zfS6B2RWmF1ivbbfJoPqE+5
         /A3dbqdnM9qAEw2COxAwXjAa318pHORoQJaI2QQtYYsUgsgbQGzo/K1ztW5FQfjSa1H4
         Kc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xe/Aq3/7m+CfZN6O/GcCkef3Jq0yzqRxc25xU578GNI=;
        b=H0GlZRfS64VnbYqQek98pADrXOlQV72BeeG1Uhd76vBGy9M64uxgAhrOVwMwyCuyPv
         X5mIpCxLYx6G4lagc34D5wpyDuOVXCbVxLQ83aYq8augZ9ouqUnd0eCKgWdP8SQEhqab
         sYthpJj1xiTTOa7gyksKqLAReSXCYOyzvpAyi6rRLc/Zql0LVlL/jB1CMxtHKlRNUWA4
         b2MQlMHpaFb6ShvmeSacp0rs/HoMZx5Xitcdyug5+lYcAMHI9Y0Vrvr+eex+qYhXU20d
         pnYDel/hA6EOXn8bCq+dGNljCL7NnPTOkzPx8QkSyjDdjTIni67hQZSf6wCRp2OiooOZ
         u2cQ==
X-Gm-Message-State: AOAM531TsyFHHXCd51gYn4J9wzXDw8HvENCz3GGBzOf24+YgalhmPWQ6
        St9FrcE3a1KTDkmZT8ooagw=
X-Google-Smtp-Source: ABdhPJx0Tmf2VDplsWX/Z7vCpBMEstXKdzbwusss3E7GY4GlYOzvOkpQYtEPVn6QdiBJHf5oN+ydmQ==
X-Received: by 2002:aa7:942d:0:b029:1f2:cbc6:8491 with SMTP id y13-20020aa7942d0000b02901f2cbc68491mr15352458pfo.53.1616811338162;
        Fri, 26 Mar 2021 19:15:38 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:15b8])
        by smtp.gmail.com with ESMTPSA id gf20sm9519329pjb.39.2021.03.26.19.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 19:15:37 -0700 (PDT)
Date:   Fri, 26 Mar 2021 19:15:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Message-ID: <20210327021534.pjfjctcdczj7facs@ast-mbp>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-6-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325120020.236504-6-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 05:30:03PM +0530, Kumar Kartikeya Dwivedi wrote:
> This adds some basic tests for the low level bpf_tc_* API and its
> bpf_program__attach_tc_* wrapper on top.

*_block() apis from patch 3 and 4 are not covered by this selftest.
Why were they added ? And how were they tested?

Pls trim your cc. bpf@vger and netdev@vger would have been enough.

My main concern with this set is that it adds netlink apis to libbpf while
we already agreed to split xdp manipulation pieces out of libbpf.
It would be odd to add tc apis now only to split them later.
I think it's better to start with new library for tc/xdp and have
libbpf as a dependency on that new lib.
For example we can add it as subdir in tools/lib/bpf/.

Similarly I think integerating static linking into libbpf was a mistake.
It should be a sub library as well.

If we end up with core libbpf and ten sublibs for tc, xdp, af_xdp, linking,
whatever else the users would appreciate that we don't shove single libbpf
to them with a ton of features that they might never use.
