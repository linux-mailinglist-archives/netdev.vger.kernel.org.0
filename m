Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291E74A65A2
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiBAUZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiBAUZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:25:53 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFD0C061714;
        Tue,  1 Feb 2022 12:25:53 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 132so5409965pga.5;
        Tue, 01 Feb 2022 12:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ExdrZIgp39XVpTkA829D6pTDC2kNpI9DYEfWRWuVVbU=;
        b=ITc9Q24cgjgfgZIRPMUETmA1BvsoPuDTxd8akeVWC6NEkNr5mwgVfkTYcLFmbMbZ8W
         pyiO7xU2fLRPcNVKQ3o1N4+zzRWyjhUf+Vcaa4e1+8OjJOHEFGAXSujp/zo6rnD1g/zL
         QlEe0OP66UsZK0/9jwRVsB102DGV6VLSPYMbb2D4QfIBhOumzCEJsSFJXtkHDsn2c/LK
         9qolP4HxL1Ty1zxhk0TB+/KmY+9XlG7Alsrq/MeLK0v5XSnG8rruw879bv0WYQQYCVsn
         HZmPL8cv9HcJRmll17chuNrjnLe24BPDwcHjHgvr3fVxsBXwpuWolwqRWzlkkbt/ANhO
         9tSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ExdrZIgp39XVpTkA829D6pTDC2kNpI9DYEfWRWuVVbU=;
        b=US7D3np/sjN7X3UUlrWjuqeHstvg5EAVfcax7Y/DqAR6TG+ZztxpL0NC2DIIsPHBu/
         mcAoenlW4dubGKpTPaMl+oa/EDBM1sx/B4EJpVgRFvN2hO6R5+DyV37YjQbpM7rHA5ER
         gkzkY+OhqmVAh3HfQ9oytwGbqDDeFdw+a9DlONaJVtdFB17jstAXDrCNSATR/3YOGDBg
         kOAvB2cpCuoNFXBcqehRLAteEq9PLcaCA0pEcJTMxrka4mN2etE/1+OTuSlhYo8SSvxx
         C+Vng5U7gcoDW/S1BnZpgZ1kkDWJF51nir21423byUYIheG8SNVW3GJWzC9B/koJxXLq
         qnXg==
X-Gm-Message-State: AOAM532lrep4A1jmguI+7BVuqi5trdVEHIHTLsn3uHsU/7ozmD0wkDXY
        d3G6TH+ZQtOFb9LT/XAcT/8i8yg5h6lnfmkW4ac=
X-Google-Smtp-Source: ABdhPJy0q73D2jETQlZoAmIweTsGb4uPIiFseF1cAdCI2gLgedABAXPmVvU8fXTFwpCRy5HnbjEWYEaeEDiJ1HOoBhU=
X-Received: by 2002:aa7:888e:: with SMTP id z14mr26785456pfe.46.1643747152532;
 Tue, 01 Feb 2022 12:25:52 -0800 (PST)
MIME-Version: 1.0
References: <20220130030352.2710479-1-hefengqing@huawei.com>
 <CAADnVQLsom4MQq2oonzfCqrHbhfg9y7YMPCk6Wg6r4bp3Su03g@mail.gmail.com> <87zgndqukg.fsf@cloudflare.com>
In-Reply-To: <87zgndqukg.fsf@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 1 Feb 2022 12:25:41 -0800
Message-ID: <CAADnVQKAeP3RB_F-isOdRJNaKns5RBEfs1aYw=_fCtBro64Amw@mail.gmail.com>
Subject: Re: [bpf-next] bpf: Add CAP_NET_ADMIN for sk_lookup program type
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     He Fengqing <hefengqing@huawei.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30, 2022 at 4:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Sun, Jan 30, 2022 at 04:24 AM CET, Alexei Starovoitov wrote:
> > On Sat, Jan 29, 2022 at 6:16 PM He Fengqing <hefengqing@huawei.com> wrote:
> >>
> >> SK_LOOKUP program type was introduced in commit e9ddbb7707ff
> >> ("bpf: Introduce SK_LOOKUP program type with a dedicated attach point"),
> >> but the commit did not add SK_LOOKUP program type in net admin prog type.
> >> I think SK_LOOKUP program type should need CAP_NET_ADMIN, so add SK_LOOKUP
> >> program type in net_admin_prog_type.
> >
> > I'm afraid it's too late to change.
> >
> > Jakub, Marek, wdyt?
>
> That's definitely an oversight on my side, considering that CAP_BPF came
> in 5.8, and sk_lookup program first appeared in 5.9.
>
> Today it's possible to build a usable sk_lookup program without
> CAP_NET_ADMIN if you go for REUSEPORT_SOCKARRAY map instead of
> SOCKMAP/HASH.
>
> Best I can come up is a "phase it out" approach. Put the CAP_NET_ADMIN
> load-time check behind a config option, defaulting to true?, and wait
> for it to become obsolete.

I would keep it as-is then. The trouble doesn't feel worth it.
