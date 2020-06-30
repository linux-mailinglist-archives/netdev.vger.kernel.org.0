Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F2920EBD1
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgF3DG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbgF3DG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:06:56 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70310C061755;
        Mon, 29 Jun 2020 20:06:56 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f3so9269249pgr.2;
        Mon, 29 Jun 2020 20:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J9tNP13BOP8PSxutJbYdMQr3MtVVXrNzg605V2b0CJ8=;
        b=b7ENfBFyxmSBOfdEXGtqekuVPvTCsMmgBSKxkXZO2eNrUuit/GSwSBn8KsAcPzdTJe
         9QE/aVlQUKHPpsxFv6/3/eYVCeUq4+Lt8frjlCUeeb4tcIHFbFdUglBXAPz7pDHPKq94
         tSFkNv/jA/hc6qmQltXZXFU2IvknHLJ9u9uSE8RWXFYZodRpPSRllmxAmxsB5pZOSAUG
         SvSfUcbTB+m/Wd1tJ2u1dUt6tmrJF3MTpPDty+MMcHIy4y4hTgiYilIF6Qp+d9G3NigL
         ncGi38iAGyZ3vc4ttR0xWjN3+nNKMRjHdQLTfVGKihAlY8p72pcrshzoPCpuoKPou18s
         QAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J9tNP13BOP8PSxutJbYdMQr3MtVVXrNzg605V2b0CJ8=;
        b=din+RHX97zbre7yJxytz7ShJSLxZyovzFgF5v7RPFoo6irB5w9xOjUGSHuZoo/q1wv
         pZMNhi0Eh+bEyZ3aLrqJyESWPDC+HcG8oc95+eS2Ws0NFKIQaqOVoIdGtIudV/unRmIA
         7gd9tQObDz07K+TOlJbiCCwo4zj4elA1wKBRCQUFHVm71iwkL2Aa7l+Sup+AZAr1/Y3R
         fHcsOwQbZ+T9/JCHAHTQ6UmVm22z4wmyAudptMN3fPA+u2r91yj0KFVIW/rnVhAZCFXy
         4v8cuYOyHlY4PmJlZs6GHhZZZK82Y1hRa7qko4/oDw0rkshgoEK/lS8oD2+lIsKfxtJV
         quYA==
X-Gm-Message-State: AOAM532vQjMsUJDMjyow8fXYkUncqnBLloKL9Y1/Jpq0dpMacgNbRcE6
        0zMp1YpO7OYTruOIkdxP6No=
X-Google-Smtp-Source: ABdhPJzPmAoeWYWTglgPArLXDwBGmGKsDCdr/eh90SFHfgj/V5gRrsnKOQu2A7HWxusK/9OmablOQw==
X-Received: by 2002:aa7:9542:: with SMTP id w2mr16136155pfq.273.1593486415979;
        Mon, 29 Jun 2020 20:06:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:140c])
        by smtp.gmail.com with ESMTPSA id n15sm993063pgs.25.2020.06.29.20.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 20:06:55 -0700 (PDT)
Date:   Mon, 29 Jun 2020 20:06:53 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 5/5] selftests/bpf: Add sleepable tests
Message-ID: <20200630030653.fkgp43sz5gqi426y@ast-mbp.dhcp.thefacebook.com>
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
 <20200630003441.42616-6-alexei.starovoitov@gmail.com>
 <CAEf4BzaH367tNd77puOvwrDHCeGqoNAHPYxdy4tXtWghXqyFSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaH367tNd77puOvwrDHCeGqoNAHPYxdy4tXtWghXqyFSQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 06:25:38PM -0700, Andrii Nakryiko wrote:
> 
> > +
> > +SEC("fentry.s/__x64_sys_setdomainname")
> > +int BPF_PROG(test_sys_setdomainname, struct pt_regs *regs)
> > +{
> > +       int buf = 0;
> > +       long ret;
> > +
> > +       ret = bpf_copy_from_user(&buf, sizeof(buf), (void *)regs->di);
> > +       if (regs->si == -2 && ret == 0 && buf == 1234)
> > +               copy_test++;
> > +       if (regs->si == -3 && ret == -EFAULT)
> > +               copy_test++;
> > +       if (regs->si == -4 && ret == -EFAULT)
> > +               copy_test++;
> 
> regs->si and regs->di won't compile on non-x86 arches, better to use
> PT_REGS_PARM1() and PT_REGS_PARM2() from bpf_tracing.h.

the test is x86 only due to:
+SEC("fentry.s/__x64_sys_setdomainname")

I guess we can move samples/bpf/trace_common.h into libbpf as well
to clean the whole thing up. Something for later patches.
