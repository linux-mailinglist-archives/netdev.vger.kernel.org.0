Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841DF466F8E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350532AbhLCCMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240479AbhLCCMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:12:35 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1143C06174A;
        Thu,  2 Dec 2021 18:09:12 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id i12so1412219pfd.6;
        Thu, 02 Dec 2021 18:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kKifCJOL21DqZReCuwTUr92jHLQ7PGUk0VCEWwgIjTE=;
        b=i8HliV3ysp4XqzXebUOKa2pct9hK8o7LdmERiduOjG++WjRZaTHCJKbLEuV/x6h+xK
         pMW8GqXErRXy4Q50XGX668X+Yi22dTTZ59zLxbm91lXqg08vCTLtTbKLfGs4vkvXrbAT
         /NCWWx5evVnE3NyxnrVV/12A3LqZlpcJDwt7bmDxAFcyzv7mLJUi4tct+cywb/rQZY2E
         wYX2VFBcmz4E8gqbWZQn3RKcYNrxMfTfEL4t2BniUNv61TTLnrHwdCzXwmZlJXWnDYlb
         nVKGkwVDO7s3/EkKeGzXOx+85tLxELo0X2IJZUnGbL7Nhrs2AaMVnxIqvTUVVSA2G9q2
         CZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kKifCJOL21DqZReCuwTUr92jHLQ7PGUk0VCEWwgIjTE=;
        b=1BRFWU1xGlYIh84dhboegv1/KB7JxQnrhWQ0/Yr01bH1Gel8Coj1i1pk0ydEcfmjQP
         7t4OdRhaKPS2jmyLmlzsLm3JMcU2BImzZqhV8cnT8IezpRHIgDKbZtzNzdh5vwXJfoXs
         0cH+170NATJQtCO8f+fhCPASBxdpvwUwCtNreg+3dvGN0SEjDYBPW2ZlgItENNaPTpCI
         bTEaFuDhovzzmz7CBptGgGmWQLXLVWq0R8FrB6vWld4gzVj87vbIUwXUxrweOw0lD7Po
         ogLNIzBB9JCVg2xx+CZZYA2UQDtsAVFhM22UXHBB7K81z1Dz8CYN8tIipcGwGZ2gyedn
         OMIA==
X-Gm-Message-State: AOAM531kKrbCFOn0UiNjC0oogxv7dMnQ7dpm0EnWZ1JtM+skjdgTSWaN
        vxundhRGmBy30Xd1pOnoNmeeAvby84MUGPy7EDSMm8FF
X-Google-Smtp-Source: ABdhPJyvKqFEth5YZbF7xNtOxRGqDFFVjANfTuhVhd9+9SDAWpxScRMOwiz8IPbd7lM5qOgSnVBjdlJhclcn/Q4KGiA=
X-Received: by 2002:a63:6881:: with SMTP id d123mr2246483pgc.497.1638497352287;
 Thu, 02 Dec 2021 18:09:12 -0800 (PST)
MIME-Version: 1.0
References: <20211130142215.1237217-1-houtao1@huawei.com>
In-Reply-To: <20211130142215.1237217-1-houtao1@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 2 Dec 2021 18:09:01 -0800
Message-ID: <CAADnVQ+KVfcU6gvYPmLvPk3-SHwuWEbhttzE24gC0RSCQgxv6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/5] introduce bpf_strncmp() helper
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

On Tue, Nov 30, 2021 at 6:07 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi,
>
> The motivation for introducing bpf_strncmp() helper comes from
> two aspects:
>
> (1) clang doesn't always replace strncmp() automatically
> In tracing program, sometimes we need to using a home-made
> strncmp() to check whether or not the file name is expected.
>
> (2) the performance of home-made strncmp is not so good
> As shown in the benchmark in patch #4, the performance of
> bpf_strncmp() helper is 18% or 33% better than home-made strncmp()
> under x86-64 or arm64 when the compared string length is 64. When
> the string length grows to 4095, the performance win will be
> 179% or 600% under x86-64 or arm64.

I think 'home made' strncmp could have been written
differently. I bet in bpf assembly it would be much closer
in performance if not the same,
but the helper is useful.
The patch set doesn't apply cleanly.
Pls respin.
