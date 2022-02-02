Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910BB4A7683
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiBBRKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiBBRKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:10:05 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B31CC061714;
        Wed,  2 Feb 2022 09:10:05 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so38273pjb.5;
        Wed, 02 Feb 2022 09:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1DL8sfxlQQLOeQGFtJFHJ27O4Xdr1eVKbTtjsz7BVE=;
        b=aagH7PDCRetaZM+lkqTur0D3PUly1lmFKw/2mRAE6zxzT/kRzaE/8EekJDRRowUO2W
         PUXZWD1TJKsz612V7nB1Z7DWTyEDTAp7mxGfvELOLmA58riVbPPvEQYcyMUekYc4DDoJ
         oq6fURNlUfgKnp/lxj0e/N3fLR/4IFNDUR5KSyWMMpXLo7IgX4lZyuFgJeBqINzHloZk
         D+bNi2eClaCQ8kfwLyJFrnyCgCj2E/yEAkg9JDbeqSSBwue5xOYEO3A+X5TqVc/lwWHA
         FeBbizLLL/b+PTSxq/1lyRJQ7ypBEIgYRAY0/5lvTrWE1Q9sthBoyUlWbJS9d8+xEAS4
         ResQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1DL8sfxlQQLOeQGFtJFHJ27O4Xdr1eVKbTtjsz7BVE=;
        b=WvsNetIghLuyriMniWKzVuvoDpmKzzUNCVQB+8kC5tvljzoEAiLhwYiT6jLqyaEQoo
         jdFDEtIqWT7ef3kzNCL9YhXfTua9WX6YW0URrgi1omwjttBeuM+jFj3tTQ6B2V5Nt7MD
         hz+dV0XCFLZ7K4JWeHLRqs2pVPznAK58LKvbPm+/kOto6a+lOvMbyfR8hIBzRHN3I4qQ
         8d8/zig7ICoXJjZBSJf1u4+ZgHLe5qPHq25nQth9iRcvFFj8wBFg9eRz4VJU0Lt0Y0k6
         hne+8+1IbvGLIWTINYfEztPN7PfiyJCg3n8saOUIixiK1MFlvmkRdSRGvaYeUgK5cLQd
         bZMg==
X-Gm-Message-State: AOAM533U7Pwu1ETfTEo46JInCY+UoVSfaNaaFTa63wv6eHeyU+37alvY
        X1snrlmR6PJ4fM5Jco0o9lAcM9FbGIRNMK1LFkTBMUzq
X-Google-Smtp-Source: ABdhPJzGaU7Uc0adA4D1fI+kEy+lyqvMeXRVVe+OQtJ6Jtcz5lMKikGzEP3bFofUiIZT647aQtShs07y3s9iaZHVD3M=
X-Received: by 2002:a17:90b:1e41:: with SMTP id pi1mr8966762pjb.62.1643821804537;
 Wed, 02 Feb 2022 09:10:04 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org>
In-Reply-To: <20220202135333.190761-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 2 Feb 2022 09:09:53 -0800
Message-ID: <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> hi,
> this patchset adds new link type BPF_LINK_TYPE_FPROBE that attaches kprobe
> program through fprobe API [1] instroduced by Masami.

No new prog type please.
I thought I made my reasons clear earlier.
It's a multi kprobe. Not a fprobe or any other name.
The kernel internal names should not leak into uapi.
