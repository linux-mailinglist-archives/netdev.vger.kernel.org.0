Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C514C269509
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgINSiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgINShF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:37:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BB2C06178A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:37:00 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id w5so684348wrp.8
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bcg5MkV7GMo2scuAb1zfDS6UH6+o9K/re2iSmd6wbvs=;
        b=KKdrh2C8zETXi47pwmmq3wEd9qac/F6YSAv5uRZ7jSCDYcAyhLJcuJqobL/R53Cd+D
         zj7B6TEZd79dp1G678VQ4G6l4FHSijlJx63WwgYXA3+jU/gjp7p/QKtcBTs82AWmrXQW
         gPeFKkdlD4YfWcgM8M2RFiyGHuBmwqzAtIlqCDDu3/mHD8CZOUKG3LpYGoc28yIFIQEi
         niIvmnDw084uEREF6MVGDESR4+9AUVPpl9vCTXuQiO/m75I14vLk34qYthRLr6pAlglv
         bkEqpn9VoYtEzwuC0yc0JLTKPTLz+IDS5A0H8T5gYkgD56BWA1uoZ6sD5uWGzarAgKE4
         ogwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bcg5MkV7GMo2scuAb1zfDS6UH6+o9K/re2iSmd6wbvs=;
        b=eRMeOZvZ9hrS0umfqYKS2FqokSNITs/Wi56MS3gSsjQX6Ze8hTwJICsSVp9SceFwJH
         4soPS7qCDWjbiQxnx6527HktP0o1vaPStg3j7+kbupLFuyiqBZaK8PbHkHZzFffBAu4+
         kP31nZUANj502raSVItRHJZ+RbPDokkb4uGpJXaeNYcPdVLzpoGqSDGpaE237CDcIl4G
         kaSqnolC0vkU06KmEPTXabbMCrdnHNnQH1+xmdB0QLjk/R++vawQVgt5RNRkW6v2teHM
         cnw60QIo9AxQ6w354m9INJ3Xz6cJOBRcv6k4YKoHbPaKaZ4K78CXqFXiM6A5dTd62A3w
         vx4Q==
X-Gm-Message-State: AOAM531shsiBy0UQ2hKPSQyfgmk6pwTpa43/as0jFQSb788ADCy39zwC
        3+QfO+3H7Ua+lha20CannV3d+A==
X-Google-Smtp-Source: ABdhPJy0gpOVhE8x8dTv7A+XKUHITZMMmF32ReDMzwzwrkbFovspL6Bq2nYmj1jvbsD2AfiXK7cJoA==
X-Received: by 2002:adf:f492:: with SMTP id l18mr18076356wro.280.1600108619101;
        Mon, 14 Sep 2020 11:36:59 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id s11sm21977314wrt.43.2020.09.14.11.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 11:36:58 -0700 (PDT)
Date:   Mon, 14 Sep 2020 21:36:55 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Luke Nelson <luke.r.nels@gmail.com>
Cc:     Xi Wang <xi.wang@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Will Deacon <will@kernel.org>, bpf <bpf@vger.kernel.org>,
        ardb@kernel.org, naresh.kamboju@linaro.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200914183655.GA22481@apalos.home>
References: <20200914122042.GA24441@willie-the-truck>
 <20200914123504.GA124316@apalos.home>
 <20200914132350.GA126552@apalos.home>
 <20200914140114.GG24441@willie-the-truck>
 <20200914181234.0f1df8ba@carbon>
 <20200914170205.GA20549@apalos.home>
 <CAKU6vyaxnzWVA=MPAuDwtu4UOTWS6s0cZOYQKVhQg5Mue7Wbww@mail.gmail.com>
 <20200914175516.GA21832@apalos.home>
 <CAKU6vybuEGYtqh9gL9bwFaJ6xD=diN-0w_Mgc2Xyu4tHMdWgAA@mail.gmail.com>
 <CAB-e3NSPcYB6r=ZjFtXQ=s=LU-a9D9OfXJPtGGbY3dupB1Z1Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB-e3NSPcYB6r=ZjFtXQ=s=LU-a9D9OfXJPtGGbY3dupB1Z1Qg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luke, 

On Mon, Sep 14, 2020 at 11:21:58AM -0700, Luke Nelson wrote:
> On Mon, Sep 14, 2020 at 11:08 AM Xi Wang <xi.wang@gmail.com> wrote:
> > I don't think there's some consistent semantics of "offsets" across
> > the JITs of different architectures (maybe it's good to clean that
> > up).  RV64 and RV32 JITs are doing something similar to arm64 with
> > respect to offsets.  CCing Björn and Luke.
> 
> As I understand it, there are two strategies JITs use to keep track of
> the ctx->offset table.
> 
> Some JITs (RV32, RV64, arm32, arm64 currently, x86-32) track the end
> of each instruction (e.g., ctx->offset[i] marks the beginning of
> instruction i + 1).
> This requires care to handle jumps to the first instruction to avoid
> using ctx->offset[-1]. The RV32 and RV64 JITs have special handling
> for this case,
> while the arm32, arm64, and x86-32 JITs appear not to. The arm32 and
> x32 probably need to be fixed for the same reason arm64 does.
> 
> The other strategy is for ctx->offset[i] to track the beginning of
> instruction i. The x86-64 JIT currently works this way.
> This can be easier to use (no need to special case -1) but looks to be
> trickier to construct. This patch changes the arm64 JIT to work this
> way.
> 
> I don't think either strategy is inherently better, both can be
> "correct" as long as the JIT uses ctx->offset in the right way.
> This might be a good opportunity to change the JITs to be consistent
> about this (especially if the arm32, arm64, and x32 JITs all need to
> be fixed anyways).
> Having all JITs agree on the meaning of ctx->offset could help future
> readers debug / understand the code, and could help to someday verify
> the
> ctx->offset construction.
> 
> Any thoughts?

The common strategy does make a lot of sense and yes, both patches will  works 
assuming the ctx->offset ends up being what the JIT engine expects it to be. 
As I mentioned earlier we did consider both, but ended up using the later, 
since as you said, removes the need for handling the special (-1) case.

Cheers
/Ilias

> 
> - Luke
