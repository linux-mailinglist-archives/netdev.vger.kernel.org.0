Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4C32EE675
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbhAGUAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbhAGUAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 15:00:33 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65042C0612F4;
        Thu,  7 Jan 2021 12:00:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id j13so4441264pjz.3;
        Thu, 07 Jan 2021 12:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wh+6IqxKBsEEEDVUlamA3AcE5xJ7bW9iP0jShrBxnko=;
        b=gAg/nAshHthLBXuKkSQOWhq3JbJqISNbcwapevF4wqnUqUSycDoPJonVb/GoX2SBdn
         qGiFPZVWTM8vmYnOKiKGhGuhl1zdOnqbbRd/lTC8svQN29Lv/eBztWpeRghJ1hAF0IJA
         e5bCPoruv2EJian7OIj2LTv/X8QZpDudEjBQDmhmVFoZgJcf2AxbazbfawRLrwBhfwP2
         a/hbiMOKoR6pt9BRoB00X1JJ06CKWxh/OUX/NyqRDz2vjyYCCqxSBcym53TL1z1biQm3
         XKyYowklgL1JEQsb6zcdWakUUf651DlepJkQVl9XWnqHwzOq6tvcO1WDs/nevCvcVoXI
         Hfvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wh+6IqxKBsEEEDVUlamA3AcE5xJ7bW9iP0jShrBxnko=;
        b=p9cSI81Cd8fg86kg5KyF4+NqVvniELqUhNbdEffksdJorwtcBAtj6STiJbKijJRuoh
         3FmpwsANJep4uEBmASKt9PrW7SaNDiv26FZ+9Il6vmuPUAtraDSGaDMol7SP9NxSrwPZ
         SXuRSEn0cxAzdLIjUJ9oU0Vj4ZqK6a3G7R3FqdYZgX0qXYlhjTAYf9kZtWhXuFOQVTNo
         fEr2HNgNPTeXIJ5lVBBKkU7SrEXIgtlDzu4rna7iJE/29+cxaFMR7TGcrkB8ac912x7B
         uoAq1bVqhx+sBzCgDA5R+OsIaYcJ898bWnLtCtRfzVTB6PX59/2UeCjHkHp7ZJnqH9Df
         aZbw==
X-Gm-Message-State: AOAM531h6zhtfAwdHgfoC4uNlxaAb08P9IPFm35giDI3T7Ysh6JnH/G3
        soU7YUbQORgmejyQiPa/NOU=
X-Google-Smtp-Source: ABdhPJwv+nlRU5J3h8BZSVcCwhM5fednEuF0RaagfZN3zOWuGVW2E4knvGYeky8sH+N4Y7jDRuaiDQ==
X-Received: by 2002:a17:90b:215:: with SMTP id fy21mr97886pjb.227.1610049617964;
        Thu, 07 Jan 2021 12:00:17 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:4d7d])
        by smtp.gmail.com with ESMTPSA id b12sm6507295pft.114.2021.01.07.12.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 12:00:16 -0800 (PST)
Date:   Thu, 7 Jan 2021 12:00:14 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Gilad Reti <gilad.reti@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add tests for user- and
 non-CO-RE BPF_CORE_READ() variants
Message-ID: <20210107200014.ijpg3n7mjqdrrrvo@ast-mbp>
References: <20201218235614.2284956-1-andrii@kernel.org>
 <20201218235614.2284956-4-andrii@kernel.org>
 <20210105034644.5thpans6alifiq65@ast-mbp>
 <CAEf4BzY4qXW_xV+0pcWPQp+Tda6BY69xgJnaA3RFxKc255rP2g@mail.gmail.com>
 <20210105190355.2lbt6vlmi752segx@ast-mbp>
 <CAEf4BzZPqBp=Th5Xy3mrWZ2k5ANo_+1rQSkC1Q=uEHz6FcBqpA@mail.gmail.com>
 <20210106060920.wmnvwolbmju4edp3@ast-mbp>
 <CANaYP3E5qYq0JznOkxVf6r3N-oM-WjKEw6kqPKD_ofQtk1gL+A@mail.gmail.com>
 <CAEf4BzZay-ofoZ-RURa0vTyQnEVaqF4_xuTAijSA9wgm=kt02g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZay-ofoZ-RURa0vTyQnEVaqF4_xuTAijSA9wgm=kt02g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 03:25:30PM -0800, Andrii Nakryiko wrote:
> >
> > If I am not mistaken (which is completely possible), I think that
> > providing such a macro will
> > not cause any more confusion than the bpf_probe_read_{,user}
> > distinction already does,
> > since BPF_CORE_READ_USER to BPF_CORE_READ is the same as bpf_probe_read_user
> > to bpf_probe_read.
> 
> I think the biggest source of confusion is that USER part in
> BPF_CORE_READ_USER refers to reading data from user address space, not
> really user structs (which is kind of natural instinct here). CO-RE
> *always* works only with kernel types, which is obvious if you have a
> lot of experience with using CO-RE, but not initially, unfortunately.

Please send a patch to add such clarifying comment.
