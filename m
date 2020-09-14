Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16CD269264
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgINRCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgINRCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:02:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99642C06178A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:02:11 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a17so426613wrn.6
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8phrXHPm9iOawTdsaIPnylRsltNcVb5/pPjRLSqXyMk=;
        b=H262HavfjAMKUr1v/sUjYJPhhhCjLTriI/M7rKKaiYnuzgf9T0ia46nZNeoILPihEq
         dmOPrBGWckaIU5DFj3jeSForb8LDfCEAHv7n/nkdye++p73LHuzDnAGBOgBj0tRwKBC+
         APVbeMAbByOfNr3qSAr75PjjgJnTm2wpekcBzsUelMXk6W+z9Zf2tJz190MrinY9zjQi
         CHk5udFpGgosByJSnpFSaZ12OUSBvyBIhYjZMhAOBHoqFu+eJf5gCU8ljlLSt3Cb4orW
         Jxi5563V/3+whieCptlduy6v88dwV7BYNs9AZ2fdY+Ps2ekXDXNu1WoCb3Kcaq36tm85
         ETtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8phrXHPm9iOawTdsaIPnylRsltNcVb5/pPjRLSqXyMk=;
        b=qhT4Dx9G4Y4udY9CCcO/LH+BOyT2vZg5q7Ote84hsA9s3natKtUQE+WRp+M6IJ2fra
         asw8zoh6oSqFqMUfNcedFkOoIvtkOM6KmydGXS2dO/kl42chylSITYZnINnyEZ1H7sqi
         K58VC+pBfoxhQA3JflzjBEi7OZFBQOQ3PLQeysjbDmirJfNyDe6xfWwwPVnK/ffudkcj
         Td/oM9GJLFRUSOQF8N2HetkHQDn2kt1McBiobzjd4uipIdkU6ZKk8ZByZk5G3N5OH6Pv
         k3pKSWqSZXE5px5hurLS1vtoEP6bKcKrxrRQfLzQ6IWNozEkrd4WTYRvKhHNHX4/KMaL
         1pog==
X-Gm-Message-State: AOAM531OXaRxjvO33ovjVdiSJQ3Ae2iEFZGM81EPApwbHY1yBvuLry2t
        P0nfxf27EiWpKgv2YLJmoRDJJg==
X-Google-Smtp-Source: ABdhPJwAa55HftLb6r7Iwk0ni2ORg7ecloANTsssVyBu6gm2nFHsVbTL9FHc8yFemg38gD48gj5mMw==
X-Received: by 2002:adf:e80b:: with SMTP id o11mr14005546wrm.118.1600102930108;
        Mon, 14 Sep 2020 10:02:10 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id y5sm20313641wmg.21.2020.09.14.10.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 10:02:09 -0700 (PDT)
Date:   Mon, 14 Sep 2020 20:02:05 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Will Deacon <will@kernel.org>, bpf@vger.kernel.org,
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
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200914170205.GA20549@apalos.home>
References: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
 <20200914122042.GA24441@willie-the-truck>
 <20200914123504.GA124316@apalos.home>
 <20200914132350.GA126552@apalos.home>
 <20200914140114.GG24441@willie-the-truck>
 <20200914181234.0f1df8ba@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914181234.0f1df8ba@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 06:12:34PM +0200, Jesper Dangaard Brouer wrote:
> 
> On Mon, 14 Sep 2020 15:01:15 +0100 Will Deacon <will@kernel.org> wrote:
> 
> > Hi Ilias,
> > 
> > On Mon, Sep 14, 2020 at 04:23:50PM +0300, Ilias Apalodimas wrote:
> > > On Mon, Sep 14, 2020 at 03:35:04PM +0300, Ilias Apalodimas wrote:  
> > > > On Mon, Sep 14, 2020 at 01:20:43PM +0100, Will Deacon wrote:  
> > > > > On Mon, Sep 14, 2020 at 11:36:21AM +0300, Ilias Apalodimas wrote:  
> > > > > > Running the eBPF test_verifier leads to random errors looking like this:  
> > 
> > [...]
> > > >   
> > > Any suggestion on any Fixes I should apply? The original code was 'correct' and
> > > broke only when bounded loops and their self-tests were introduced.  
> > 
> > Ouch, that's pretty bad as it means nobody is regression testing BPF on
> > arm64 with mainline. Damn.
> 
> Yes, it unfortunately seems that upstream is lacking BPF regression
> testing for ARM64 :-(
> 
> This bug surfaced when Red Hat QA tested our kernel backports, on
> different archs.

Naresh from Linaro reported it during his tests on 5.8-rc1 as well [1].
I've included both Jiri and him on the v2 as reporters.

[1] https://lkml.org/lkml/2020/8/11/58
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
