Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AFB465447
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347793AbhLARyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbhLARyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:54:06 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143E4C061574;
        Wed,  1 Dec 2021 09:50:45 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so320658pjb.5;
        Wed, 01 Dec 2021 09:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V3raaT8C9wOT/pdQPVt8b1fbEFpeQjlqQ444DbTsRHg=;
        b=SqGR8zp6Tf/aDJElUh0WfWCF8qhJIUnB463tOZNqMejXxD6HlPbitmCMfv8NTeWxHK
         jBcJwrv8ab6Vgl2j27Ue2V0nydacF6UjWxJSUmn0/yH1p/CFEm559+ijeGsuDRHW4TyO
         mWr/y/9lboL8wKr7UCaezesrcSrEN5M6aTndsq/TI90YgMU20pADd8pDBAkSMKPhzFQ9
         nWMCn8ClIxYhECwhrSiwL7aL0FL+ZwFW+KIOvm76lqU49W9IKE5xKdXsFykUJnVA7dkk
         7j9zmi3kKKpwZTOQ3KrTQktCX8kfi0MdVCZE9N/iJ7Kcxre/H4Q/J0YuhNfgv5/bpk7o
         r22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V3raaT8C9wOT/pdQPVt8b1fbEFpeQjlqQ444DbTsRHg=;
        b=PDWxxXobC36LV4X9JFRwKzTlFU3smt84P5NrFVVmIi54i1QHyYmeqyJhONvhLcgiAC
         dGPlJNKUj8HJKYPmX35YpIlpwKReDvDrvucCNVEm/DxcYPV3dGcHT3/6HLwTLp9fgXlR
         kPuO5Is2+n5iZPfuhuLQgfgIFxfKGiQKoSMBn9CzWi2KmlFHiWYMnGKP9b4hOO+J0t4V
         FQwzN/LVZyowUKlvd31yDsCxO2tQuNzaU3QzpHC/XwINKL59ZMB6IFM2hxIP+b1IIneF
         vSeaTv2l61mcb4EnydrgOdRsGmvTnUUOhzxgf3UcTkMEO3NeZ8f3Gf5SwrJSoN+qgFeA
         I2Lg==
X-Gm-Message-State: AOAM533WSSG/tGKO4PjFyJSO7yGB4H8351Ug4g+lhCxUfiQJEEoMjJcO
        pRi5pS3A468Xdgr55oMUXXwr/dx/b2LmdC4cnl8=
X-Google-Smtp-Source: ABdhPJxOdY1WyGUOgzHwlzaRW7sUgZdXT+JhrzXVYN365QjmaEShsGw0023vzaqTmO8p5byH0bQEvy4gqBC7Dms5VwU=
X-Received: by 2002:a17:903:2306:b0:141:e52e:457d with SMTP id
 d6-20020a170903230600b00141e52e457dmr9233368plh.3.1638381044511; Wed, 01 Dec
 2021 09:50:44 -0800 (PST)
MIME-Version: 1.0
References: <20211201073458.2731595-1-houtao1@huawei.com> <20211201073458.2731595-2-houtao1@huawei.com>
In-Reply-To: <20211201073458.2731595-2-houtao1@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Dec 2021 09:50:33 -0800
Message-ID: <CAADnVQJ7wMxfLKgQuPYE82dXOi5dO5r77PkZR=+17JpvJoBAVQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/2] bpf: clean-up bpf_verifier_vlog() for
 BPF_LOG_KERNEL log level
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 11:19 PM Hou Tao <houtao1@huawei.com> wrote:
>
> An extra newline will output for bpf_log() with BPF_LOG_KERNEL level
> as shown below:
>
> [   52.095704] BPF:The function test_3 has 12 arguments. Too many.
> [   52.095704]
> [   52.096896] Error in parsing func ptr test_3 in struct bpf_dummy_ops
>
> Now all bpf_log() are ended by newline, but not all btf_verifier_log()
> are ended by newline, so checking whether or not the log message
> has the trailing newline and adding a newline if not.
>
> Also there is no need to calculate the left userspace buffer size
> for kernel log output and to truncate the output by '\0' which
> has already been done by vscnprintf(), so only do these for
> userspace log output.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied this patch. Thanks
