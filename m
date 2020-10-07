Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2A1286B86
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 01:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgJGXaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 19:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbgJGXaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 19:30:01 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C63C061755;
        Wed,  7 Oct 2020 16:30:01 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f19so2411741pfj.11;
        Wed, 07 Oct 2020 16:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hUiwM1JNK0G3qngSHBC2n3NlaaHbnlANTd1ff1RpQvs=;
        b=tKUL82hcEjfRaMZYUhDddpNLNi4avYT6+3cy4Ogy6V8TmmI8ADW95IkK+wqHYyYPje
         z+gVuYXW6i41ulCOE8EWKIjGSpIfRLlhKgRptQopklfqGyzPNjyrir1VVguDGD1ZZcoT
         3fBcraXl/3+VTmQt9q/NJpCBg9r4a6G7QF+380pUIJx1Ps125YIbfIlblmsy++d48d2A
         uYDXjkr9RK+Y/aTr7N1W4IAt4vzujffYDUMOdslXOv2R0hVZDoX02JP7YnxtF1ntC3fX
         hnFykMa+CrO9ZP32F/vsVNyzV5jP2KA3Ffe1VXt5WhiLXGstjA1bNB/G9qQXVwsMGSPW
         BZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hUiwM1JNK0G3qngSHBC2n3NlaaHbnlANTd1ff1RpQvs=;
        b=K8Y6MrzfbdqHesE3k8e2ZPrRGORwgUhOn67KBHcwKHECx/pZv21KF6IsNcZIXQ5Ku0
         dJ6DVnji9dgoQHZRrUuIcLSF/Hh2EXo57Tp70QV9K3vwfVm403K9x0tnIozByoHMZlD0
         Md6OeULZM+xFGo/2w/5aQb0pA1mlGQuhpWUYjwNXp2dOVPMReb7qvtJYMefcRQUdxoEC
         unKF+7Tl+o26SBGax41cTAFDJk8Htj3g2FgR1+RDW3bSLuzenzNiBz5AaLqPSNuXVdXR
         yMuncJwbufD19DGo16vGQOrL+cop+lNwtxcFuYKTT5drn5/kAW4YyP/nJPAOV81dlF3b
         GiKA==
X-Gm-Message-State: AOAM5321h/0XpCszzlnB6S3y1utwe0/rOLal9TO5AMiSAQ6W+jXZkl9p
        2kOcUcPsp9+lNgVGM/JrF5w=
X-Google-Smtp-Source: ABdhPJxOUMKyiw0x+bySR+0uaCZo1dAdH56KU/MGUru7gpqMtBYhWHuE3cnzG4ltX1pxcDMUbe/9vQ==
X-Received: by 2002:a63:c946:: with SMTP id y6mr2136833pgg.379.1602113400741;
        Wed, 07 Oct 2020 16:30:00 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:36d4])
        by smtp.gmail.com with ESMTPSA id ne16sm3720715pjb.11.2020.10.07.16.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 16:29:59 -0700 (PDT)
Date:   Wed, 7 Oct 2020 16:29:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: validate libbpf's
 auto-sizing of LD/ST/STX instructions
Message-ID: <20201007232957.nrmqryypzc44rqcd@ast-mbp>
References: <20201007202946.3684483-1-andrii@kernel.org>
 <20201007202946.3684483-5-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007202946.3684483-5-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 01:29:46PM -0700, Andrii Nakryiko wrote:
> diff --git a/tools/testing/selftests/bpf/progs/test_core_autosize.c b/tools/testing/selftests/bpf/progs/test_core_autosize.c
> new file mode 100644
> index 000000000000..e999f2e2ea22
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_core_autosize.c
> @@ -0,0 +1,172 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook

The year is wrong.
Also Copyright should be in /* */
The // exception is only for SPDX and only in .c
.h should have both in /* */
