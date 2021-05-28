Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA57A394844
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhE1VVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhE1VVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 17:21:00 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1863BC061574;
        Fri, 28 May 2021 14:19:24 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id a8so5551304ioa.12;
        Fri, 28 May 2021 14:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=7veSrYCJVRfB5dWu22gzMn0yqS4DR/Wm9nlUW8VvyAI=;
        b=Axz93KndXo52Tudut+KRpaetQXSw5FwTvXMUnUrQHYNKeUPW9wYJwFXv0Bax5bFnIj
         vQnCyrhc8PbN2gTlaDEiXip8ik3r94a2rVd4CG/lfbpxdCgy6vdhNQP2S+Rnqz+ooM5p
         TaNRRzV4+28sKeTO4C0fMk8a7L9o6msDk+npZur2PZKKasi8KsIjHWvvN7yuxpVcqXv0
         DEUX9sXFNaYHOjbxKizbAfES9ZVK1UEE3a44cCm2u9DA6xKjx+ZwMnfl85fbL3nUzigI
         VqmSxIn7o/4wyOXYxUjNOdEeG13Nys4MiMd38xp+YVJIxJYTmT5KlQ0VHwVtKnAyrmQw
         FsEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=7veSrYCJVRfB5dWu22gzMn0yqS4DR/Wm9nlUW8VvyAI=;
        b=n7n8UoZAmRLOSi/QARsb8JtM19HURrE9deBDitEYdUh9KgVj4ul9CfryJ9PObPgLrb
         aqtxO9WLW635qizMRnG+gzSiieqwnUOPt1Bb25ZuzK9Wi4RiQ4tBSDI9inciiVxXweZz
         NLnaE4fDrTqFx1ebLDHePb0pBnjSXsVSr+CpN3q/N5EuW0w4I/oCfx7LC+6dHsBADbX2
         uxwRVBphzXg3SPWTNmDbTLQoQqw6KYDgG83HXitAKGGIZPDlZAKv2vBxl3GqDHxWFdkv
         ITNrxJeABt/jZW01GA8cmFzewvGwagc9ZVO1zxv+sejISrVLPULWgx2WLteA8T8m67lE
         vN1g==
X-Gm-Message-State: AOAM533u4FGcUy4FqqJ7tsHwdfY8WAvYbnrHxD/MBKP2eEKM0f3GwV86
        EoHa6b6iAf89yHIWfvMgzf0=
X-Google-Smtp-Source: ABdhPJxUTy4gZ3ZTpePit8viCMypkKxaY0U8GHDcW0eXHfF6Ej4IOFPXTo5708/xev0y7j9zZwh3rQ==
X-Received: by 2002:a05:6638:2181:: with SMTP id s1mr10285692jaj.66.1622236763447;
        Fri, 28 May 2021 14:19:23 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id e17sm1526939ils.43.2021.05.28.14.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 14:19:23 -0700 (PDT)
Date:   Fri, 28 May 2021 14:19:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Yu Kuai <yukuai3@huawei.com>, shuah@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com
Message-ID: <60b15e53d4396_303a420875@john-XPS-13-9370.notmuch>
In-Reply-To: <60b15da184eef_303a420848@john-XPS-13-9370.notmuch>
References: <20210528090758.1108464-1-yukuai3@huawei.com>
 <60b15da184eef_303a420848@john-XPS-13-9370.notmuch>
Subject: RE: [PATCH] selftests/bpf: Fix return value check in attach_bpf()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Yu Kuai wrote:
> > use libbpf_get_error() to check the return value of
> > bpf_program__attach().
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > ---
> >  tools/testing/selftests/bpf/benchs/bench_rename.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/testing/selftests/bpf/benchs/bench_rename.c
> > index c7ec114eca56..b7d4a1d74fca 100644
> > --- a/tools/testing/selftests/bpf/benchs/bench_rename.c
> > +++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
> > @@ -65,7 +65,7 @@ static void attach_bpf(struct bpf_program *prog)
> >  	struct bpf_link *link;
> >  
> >  	link = bpf_program__attach(prog);
> > -	if (!link) {
> > +	if (libbpf_get_error(link)) {
> >  		fprintf(stderr, "failed to attach program!\n");
> >  		exit(1);
> >  	}
> > -- 
> 
> Probably should be IS_ERR(link) same as the other benchs/*.c progs.

Oops on wrong branch, agree with Daniel looks fine as !link otherwise
need an explanation and fix the rest of the cases.
