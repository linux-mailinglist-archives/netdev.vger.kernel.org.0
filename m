Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9623A561B
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 05:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhFMDMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 23:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhFMDMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 23:12:17 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0393C061574;
        Sat, 12 Jun 2021 20:10:16 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k5so7824194pjj.1;
        Sat, 12 Jun 2021 20:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fmYTPm282ZQxShprUAA+JJT8XRWCbpFbyEH4BPI2swk=;
        b=s2qFcDbbhDIEqoW8GARyLHGrgkzlQYDVB5z5Xm0SfFQze11T5VyUTMtFIRXXES5gQ+
         8LPgMmDJoJD+EcU7st2hvIi4Qu/BJ9OEndWiL0XGer72X8j6mMxbSHiWhX15cnu7qETv
         6r2w1h0GsoHuYsL2OeGOMY12BUseQQ0wJppCQdnnv6hHLVvetApJIVRxTSULLml2qm1k
         tTX9PZi9iH6iqaabuvPCBSbcT9RYxnQb0ughqG+dbhSUUTOvvHWqe+iiMkRnbKgiRZE4
         D3tIb7L3+9Yqaa5axm/nBI0kEBf8tayUzSAf+JIr3+TxY41RrxSXTqlRoWBJmct0HYUg
         t3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fmYTPm282ZQxShprUAA+JJT8XRWCbpFbyEH4BPI2swk=;
        b=BTS9woG5ltz3oU5Mn9fRGZYPqxty5pUop7kZI/NcWcRk5acKB9fv4wpgddofuCSFVC
         FyPFC+KmCCSJDlUCK3ftxiiDEGMVWIxF1cs77WVjMKfzjfIPPSr5D88kzwR8B/gFbsmV
         pHEAWXJ83/HHbTyhFzLKoK+bHFWRW1SEDHoQMEyxEnhuBqeK7rMgLEcOB8C768FA4Gm/
         j0Tlr3DJAtpSMDhzO+ZJTvnJlwR12SUv/J87JFVYY45fH2q4KVBAm+AAzxsozCcgAOka
         nFhQhHLKGG7u58qLSyqf0DkRWNRgkEgH0r9YBlbTpqg/pT3goNF1ecOZNO0iCV269vJV
         MxgA==
X-Gm-Message-State: AOAM5303NOGR3cJr1IeQ3pkRSEo1Rv/olI6utEDOd51rJCl2KLJS+ImP
        QTxeYGOotbR0jf68jqfMeF4=
X-Google-Smtp-Source: ABdhPJy+g6r5DV3OOAeeiCvQGdBqzLlCQ664xbtZd5kcx1mCkV2PGHHZZdfpS9RFqijgiJT+ZOh14w==
X-Received: by 2002:a17:90a:e409:: with SMTP id hv9mr16612084pjb.126.1623553816334;
        Sat, 12 Jun 2021 20:10:16 -0700 (PDT)
Received: from localhost ([2409:4063:4d05:9fb3:bc63:2dba:460a:d70e])
        by smtp.gmail.com with ESMTPSA id x2sm8615474pfp.155.2021.06.12.20.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 20:10:16 -0700 (PDT)
Date:   Sun, 13 Jun 2021 08:38:57 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
Message-ID: <20210613030857.72bxw56bv6rwznfk@apollo>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 07:30:49AM IST, Cong Wang wrote:
> I see why you are creating TC filters now, because you are trying to
> force the lifetime of a bpf target to align with the bpf program itself.
> The deeper reason seems to be that a cls_bpf filter looks so small
> that it appears to you that it has nothing but a bpf_prog, right?
>

Just to clarify on this further, BPF program still has its own lifetime, link
takes a reference, and the filter still takes a reference on it (since it
assumes ownership, so it was easier that way).

When releasing the bpf_link if the prog pointer is set, we also detach the TC
filter (which releases its reference on the prog). The link on destruction
releases its reference. So the rest of refcount will depend on userspace
holding/pinning the fd or not.

--
Kartikeya
