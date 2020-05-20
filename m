Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5851DA792
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 03:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgETBzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 21:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgETBzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 21:55:47 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE307C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 18:55:47 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id er16so657168qvb.0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 18:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=ghTZqejRfgfS5fU2jVg75uMDbgGX4TrDcdfAaAdauPM=;
        b=ZOSedoTXRdCITrmaNoTnIMCXK7FvETKzbgoMB6JrmV4a5WGgI4bUyJioFolzQmGVrq
         o84jZ9Q029nIsm59ickCSKRAQ01KYsQEUK+O0c4WczRv54WM0OVp426vCrLLCpKR37Mw
         m5+8b6DcRSebQJ0RTOCsPoR2ZIbKjuquYzCasav1Nxy8+/U0kUkQUoatHY5OrIxy9YtL
         yAVmCyNuLc+1DjGAfNtUnT7YgFJbNpFsbuQn2zlgnGL6qXiPYNQ0+P32QGnABRJpe8HR
         nVBWLJcjfkd+mQxUSjqqoCgfYXpimBamkomH/UGmqkYwxDWuFhnC7r08aRZk4wq13M7K
         eJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=ghTZqejRfgfS5fU2jVg75uMDbgGX4TrDcdfAaAdauPM=;
        b=tBKvIjeFlo/Y+dFhjw98doJgIdu+NbpRd6MahK9ekIUAaUuxr1YFxrDhP0EL8apMdC
         uoUY6bLNrgzkeY/RYd/LBguXClaeW2uU9SwZieVddwlJ4T+cESmTH4VvhaLvpT48aCqi
         GW7rr+9oO/8/IGoPgK9iJCW6h90BCdgEfmXkZUsDy+m6ZpNfNamFNnBCp0t3bnX7pboR
         xCchaALER/Gj6SNZct46J4mQSTiZjLtgj9qL82N1KEagdkz7YHhih4Wst/pAQNcKJyaI
         +oQPEqvvdjXDfvQqgWBwOIxO29PbnT1YpyE3yzCZmudAuPSUSmeHAoescIxBMcueV86u
         cAnQ==
X-Gm-Message-State: AOAM533RywUP5soUH0+kW4NuL5vtMDWAjX0M0cINBuhpp0o2nIFLsItY
        +ZfiEIEtke+EFwBLDdqJvT4xbw==
X-Google-Smtp-Source: ABdhPJyy1uyJk+Gqjg5bwcSBKIbQNOr6J5nfgaVGYYnWbcx1hDrSKyd/Hr8zTt2MLIvCkn1/+n7iIQ==
X-Received: by 2002:ad4:466f:: with SMTP id z15mr2750441qvv.101.1589939746442;
        Tue, 19 May 2020 18:55:46 -0700 (PDT)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id j3sm1007064qkf.9.2020.05.19.18.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 18:55:45 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: UBSAN: array-index-out-of-bounds in kernel/bpf/arraymap.c:177
Date:   Tue, 19 May 2020 21:55:45 -0400
Message-Id: <FE7742FF-713E-4310-95E7-9B217662E53E@lca.pw>
References: <CAEf4BzZKCh7+2TL8GVetxrOKYCoL0U7jTGsO5CbDExs7Px+bYQ@mail.gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>
In-Reply-To: <CAEf4BzZKCh7+2TL8GVetxrOKYCoL0U7jTGsO5CbDExs7Px+bYQ@mail.gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
X-Mailer: iPhone Mail (17E262)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 19, 2020, at 7:23 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> I agree, it's bad to have this noise. But again, there is nothing
> wrong with the way it's used in BPF code base. We'd gladly use
> flexible array, if we could. But given we can't, I'd say the proper
> solution (in order of my preference) would be:
>=20
>  - don't trigger false error, if zero-sized array is the member of union;
>  - or have some sort of annotation at field declaration site (not a
> field access site).
>=20
> Is that possible?

I am not a compiler expert, but with my experience with all those compiler i=
nstrumental technology like KCSAN, KASAN and UBSAN, it seems both options yo=
u prop need to modify compilers, i.e., -fsanitize=3Dundefined=
