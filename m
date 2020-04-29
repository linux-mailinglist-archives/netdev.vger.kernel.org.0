Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7C71BD0D1
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgD2AL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726181AbgD2AL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:11:56 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763DBC03C1AC;
        Tue, 28 Apr 2020 17:11:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w65so183368pfc.12;
        Tue, 28 Apr 2020 17:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5dubIge/wiAHbcmXeB9Z2pdb+p/6I0IV1z0b/YBgN1I=;
        b=MEn+1UKdrNH8pE+Zk/FupYuJLgGhV8rOJyEilEHp4BJgOt/IJjqrxW9u821GINU+K3
         feuiIqM/2r3Zy8JEyofGsL3GnFSei4C3OWJHYPqKq/a/UcGy232Y5Kz89lHIba3kl76i
         zZ0rBM8WpzkCdYRhbawizG82QzMdtXfrvGOWpAAiak20GjUIrwpKPhWruaj0FJ2+jyrF
         mRtlrnzxPV4kYLVLSvSGx11pvxilVwvq4wu9iYS59Hb7iYgfPx3ONRl4QkF+ZX/GUN3T
         o1MWK8JgY9X4ohM+h9y3T8ZZzLGmILgMiG5V4MlOHTyF7N1jFZXJDW+PXPK3XBTqGxOC
         fu1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5dubIge/wiAHbcmXeB9Z2pdb+p/6I0IV1z0b/YBgN1I=;
        b=h/nllqOtVOrw/CeZhuiibHfLpDlsktKBLpaqcJQ86q73jWJUt8L0jMhiw4/VL8ZWp/
         TfufrFpDBxoEhl95jyWnijRLQGZTPUP9QHsk7gJnWcvQyi3mA6EpSFU0Ye+hHI6V+zjE
         XSfjIn0TKe1V29BX8s5qauns0X/zB5kNTQ3+YFveyaicbopkAg/vkhpiBYR1mkI3oACo
         iN6zhI/9hRdl7FOoZT6Yq4CK1Ni7AzIDpxTfzqSjpml8NWXP0w1ym7MxfBAD1mJAh5U2
         f34Z6KUgRmzfuoldR3TfxacBfT8gvjLz4/Rw8bwDpzxgYSI4QwSGZVvwAcMPL3aY8xjx
         ms8w==
X-Gm-Message-State: AGi0Pua09TNKgRvfEF7TrWvABqTx9eUCyb6oF40SjUfdRosF2Tt/Xufa
        ZCS2MUebq0SioRkjCBvwXYc=
X-Google-Smtp-Source: APiQypJV1Y5w4OteCHNEylF0I8Oj5XChrOkZ5JWw2ml7P/swY71Bur8LFdoKHlQf9moEj94PYs32UQ==
X-Received: by 2002:a63:1d4a:: with SMTP id d10mr30877448pgm.188.1588119114056;
        Tue, 28 Apr 2020 17:11:54 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id gl4sm3143060pjb.42.2020.04.28.17.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 17:11:52 -0700 (PDT)
Date:   Tue, 28 Apr 2020 17:11:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 02/10] bpf: allocate ID for bpf_link
Message-ID: <20200429001150.63c7n5f4rw5gmf3r@ast-mbp.dhcp.thefacebook.com>
References: <20200428054944.4015462-1-andriin@fb.com>
 <20200428054944.4015462-3-andriin@fb.com>
 <20200428173120.lof25gzz75bx5ot7@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bza-gqQHz3_9RyX7pKo_2kYeh7cCmNRAxExx48JQdOpfDQ@mail.gmail.com>
 <20200428203843.pe7d4zbki2ihnq2m@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZ4q5ngbF9YQSrCSyXv3UkQL5YWRnuOAuKs4b7nBkYZpg@mail.gmail.com>
 <20200428224309.pod67otmp77mcspp@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbF1C81J1UkmqkuX5VuGZRo7cwwJcCaZRCPFqC0MEfA8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbF1C81J1UkmqkuX5VuGZRo7cwwJcCaZRCPFqC0MEfA8A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 04:25:39PM -0700, Andrii Nakryiko wrote:
> >
> > compiler doesn't guarantee that plain 32-bit load/store will stay 32-bit
> > even on 64-bit archs.
> >
> > > If that was the case, neither
> > > WRITE_ONCE/READ_ONCE nor smp_write_release/smp_load_acquire would
> > > help.
> >
> > what do you mean? They will. That's the point of these macros.
> 
> According to Documentation/memory-barriers.txt,
> smp_load_acquire/smp_store_release are about ordering and memory
> barriers, not about guaranteeing atomicity of reading value.
> Especially READ_ONCE/WRITE_ONCE which are volatile read/write, not
> atomic read/write. But nevertheless, I'll do lock and this will become
> moot.

May be that's something for Paul to clarify in the doc?
smp_load_acquire() is READ_ONCE() + smp_mb() unoptimized in general case.
And READ_ONCE + barrier on x86.

> >
> > > But I don't think that's the case, we have code in verifier that
> > > does similar racy u32 write/read (it uses READ_ONCE/WRITE_ONCE) and
> > > seems to be working fine.
> >
> > you mean in btf_resolve_helper_id() ?
> > What kind of race do you see there?
> 
> Two CPUs reading/writing to same variable without lock? Value starts
> at 0 (meaning "not yet ready") and eventually becoming valid and final
> non-zero value. Even if they race, and one CPU reads 0 while another
> CPU already set it to non-zero, it's fine. In verifier's case it will
> be eventually overwritten with the same resolved btf id. In case of
> bpf_link, GET_FD_BY_ID would pretend link doesn't exist yet and return
> error. Seems similar enough to me.

ahh. similar in the sense that only one value is written.
it's either zero or whatever_that_id. Right.
