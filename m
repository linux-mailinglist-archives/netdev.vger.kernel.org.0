Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4F01BBD5E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 14:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgD1MTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 08:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726645AbgD1MTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 08:19:52 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0DFC03C1A9;
        Tue, 28 Apr 2020 05:19:50 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id c23so16487450qtp.11;
        Tue, 28 Apr 2020 05:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oFJ7FDcoDnoD48wdxTajGCu98nB0CyZejoNAVndFZOU=;
        b=Pl502ELUcqiGfjmtdK/ix7MgmiAang6cxzjn3JXIqAHqztDr9xBRw93NtFkn+y/zL/
         VkcUCdAhQlmKtupGV1YKlXM8GveDVgUjkwlsTvdEZlqhxK+Tiwa6hsP0QDqbBPaXaSTu
         N0SWuoB0C4+Ogy7i1V3lZr1hCiCzugDY9J7JGFt6T7ZsihnVoCmiz9xa/JrzZlLA2DeL
         RZcaFIpPmgAdsNbFVKb4FoPCOeWXvRwTIXYvEvruRhESpEBMceMDeAI1X5/61Vt7zE2u
         tc2YyhTQQO0uuvOsNQcPLz9hQagT7UVoq4eCec+59sQMzPtDN6n6JUQsxO5WhGcL6ORj
         p1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oFJ7FDcoDnoD48wdxTajGCu98nB0CyZejoNAVndFZOU=;
        b=f4GVMTX62v+GmHQr+g142mdn/YmsByzzvA9IndVbM5jFrUdEA312Ve6zyE8dll4nBn
         h8DP3hmFjU4mEBPLLT/mwEMMdhUj0lbY+S4/IYJBIGdN+xBAnhTDIZ9jb5a8xiepGTsX
         gUnjAeW9uJLbTR9vQo59Qodt/T63kpbuPbyg/ekzmrzDQIHd8kg9dRSefjBgKHfujE8m
         Gkn3xYyHYydlEthExEO67syQctucNp9zZsWGzsbmfPoQVEjxJLAapZ+w4hVBWuT1OC1e
         tRFs0itA94ak5xL1HXifa1xwQWnh5ruZZKHIInXv1w82jL8KFuRUri1U5Ms/Co4yiTK0
         Bphg==
X-Gm-Message-State: AGi0PuZr+xNoWcuLJccGulzlUZtsrUK6Rkxjq7J0nEZB2P/1lkD7l8DR
        aMUshOIbAT1aZXbvqpU8bWA=
X-Google-Smtp-Source: APiQypJctTj6EaLDB73zVfBLtxtFP/rLInVGSPnLku0shws1+dJ+tl3mtNnOEd4Sx8e0xUp8Nfevaw==
X-Received: by 2002:ac8:fee:: with SMTP id f43mr28534015qtk.376.1588076389896;
        Tue, 28 Apr 2020 05:19:49 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id n13sm13875149qtf.15.2020.04.28.05.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 05:19:48 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1765B409A3; Tue, 28 Apr 2020 09:19:47 -0300 (-03)
Date:   Tue, 28 Apr 2020 09:19:47 -0300
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [RFC PATCH bpf-next 0/3] bpf: add tracing for XDP programs using
 the BPF_PROG_TEST_RUN API
Message-ID: <20200428121947.GC2245@kernel.org>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
 <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com>
 <D0164AC9-7AF7-4434-B6D1-0A761DC626FB@redhat.com>
 <fefda00a-1a08-3a53-efbc-93c36292b77d@fb.com>
 <CAADnVQ+SCu97cF5Li6nBBCkshjF45U-nPEO5jO8DQrY5PqPqyg@mail.gmail.com>
 <F97A3E80-9C99-49CF-84C5-F09C940F7029@redhat.com>
 <20200428040424.wvozrsy6uviz33ha@ast-mbp.dhcp.thefacebook.com>
 <78EFC9DD-48A2-49BB-8C76-1E6FDE808067@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <78EFC9DD-48A2-49BB-8C76-1E6FDE808067@redhat.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Apr 28, 2020 at 12:47:53PM +0200, Eelco Chaudron escreveu:
> On 28 Apr 2020, at 6:04, Alexei Starovoitov wrote:
> > On Fri, Apr 24, 2020 at 02:29:56PM +0200, Eelco Chaudron wrote:

> > > > But in reality I think few kprobes in the prog will be enough to
> > > > debug the program and XDP prog may still process millions of
> > > > packets because your kprobe could be in error path and the user
> > > > may want to capture only specific things when it triggers.

> > > > kprobe bpf prog will execute in such case and it can capture
> > > > necessary state from xdp prog, from packet or from maps that xdp
> > > > prog is using.

> > > > Some sort of bpf-gdb would be needed in user space.  Obviously
> > > > people shouldn't be writing such kprob-bpf progs that debug
> > > > other bpf progs by hand. bpf-gdb should be able to generate them
> > > > automatically.

> > > See my opening comment. What you're describing here is more when
> > > the right developer has access to the specific system. But this
> > > might not even be possible in some environments.

> > All I'm saying that kprobe is a way to trace kernel.
> > The same facility should be used to trace bpf progs.
 
> perf doesn’t support tracing bpf programs, do you know of any tools that
> can, or you have any examples that would do this?

I'm discussing with Yonghong and Masami what would be needed for 'perf
probe' to be able to add kprobes to BPF jitted areas in addition to
vmlinux and modules.

- Arnaldo
