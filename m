Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC8A44DB84
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 19:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhKKSWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 13:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbhKKSWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 13:22:34 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F83BC061766;
        Thu, 11 Nov 2021 10:19:45 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id u60so17209712ybi.9;
        Thu, 11 Nov 2021 10:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gNYHt9TD3SpHQ7HMpqBbEDFZ8EpppTx/DF5DwoDqcaY=;
        b=asWy99nnn4y0qQgRDRz8pw5BaS441Rq/wSwEOC1zi/4VHBkO3Bhhv4B57QFRj/YudA
         +HsxclkdnybKx1CDDHxnOryaKlga6PyZ4sP/PqcKtmzTi6Jh5Mas2PrDlzBVp01bgpJk
         1kMB3h4vmlZrfKth/ddbEOIRwrrE4BDwqHj7eukcOPHWI0KyUyHHHuCgsjfyDWGPUf/x
         6dlc4PK83sMfC48Un7wj9QHHVDam85YaiZLbDAXs4KHbbmYie9TUxhDpbsUy7Tp5SQq3
         TUsWXLnTuLPW2qmq24BTmji8wEIBEA6Ht2I8qRDAVuycuy7fS7PSi17NTFtxJLF1NbJQ
         boBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gNYHt9TD3SpHQ7HMpqBbEDFZ8EpppTx/DF5DwoDqcaY=;
        b=XIoIDcvWs+zGYJo2UF2vID98sfNnJ6l/hX4HUt3zePjOUMqlW99oorQd+L8VbSUl7x
         mf8tv9QQfoGsXY2x9raeCTzW+qI1Sq9FIcrmOF/aEBQyxKVdYeEWs+5W2eu4mOAmoB72
         Vsbz/8jEDZIg/Tz2wBaLiqAX3VV5owhGlJzbfGZTOzFLmcgkRNOVEUWDrjB2ARYww105
         IxxyudDhFaYMs8UA5zBJt/vtoMFjxAJbY0j+88sSBCcWIG8EBqmNUIlbPXGn4lgrvi/G
         oOM46uY8PyAPvWUdHa4lNO/9YtiW/5jN1QcbAv4xCtr4rw9KU2wzsA+b+Xz3YKCFivpA
         yr5w==
X-Gm-Message-State: AOAM531120y1HSg04mqwXTe0pBrb+axA6OeA4VFKxqbG4xCCFe4nuCvw
        aNVgwCg6WDCEUtEXC7Etv1D4srnravs1ji17oww=
X-Google-Smtp-Source: ABdhPJwNMQMtTKUN2gYnZWJ1K9v4cr240iKRYdElnJJ8XXUVrUj2NsdbkyFLhM3gd5ljH8mqu6fLAOiqdTnXC0TkQTQ=
X-Received: by 2002:a25:cc4c:: with SMTP id l73mr10652466ybf.114.1636654784396;
 Thu, 11 Nov 2021 10:19:44 -0800 (PST)
MIME-Version: 1.0
References: <20211110192324.920934-1-sdf@google.com>
In-Reply-To: <20211110192324.920934-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Nov 2021 10:19:32 -0800
Message-ID: <CAEf4BzYbvKjOmvgWvNWSK6ra0X5mM_=igi8DVwdojtZodz5pbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpftool: enable libbpf's strict mode by default
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 11:23 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Otherwise, attaching with bpftool doesn't work with strict section names.
>
> Also:
>
> - add --legacy option to switch back to pre-1.0 behavior
> - print a warning when program fails to load in strict mode to point
>   to --legacy flag
> - by default, don't append / to the section name; in strict
>   mode it's relevant only for a small subset of prog types
>

LGTM. I'll wait for Quenting's ack before applying. Thanks!

> + bpftool --legacy prog loadall tools/testing/selftests/bpf/test_cgroup_link.o /sys/fs/bpf/kprobe type kprobe
> libbpf: failed to pin program: File exists
> Error: failed to pin all programs
> + bpftool prog loadall tools/testing/selftests/bpf/test_cgroup_link.o /sys/fs/bpf/kprobe type kprobe
>
> v2:
> - strict by default (Quentin Monnet)
> - add more info to --legacy description (Quentin Monnet)
> - add bash completion (Quentin Monnet)
>
> Cc: Quentin Monnet <quentin@isovalent.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../bpftool/Documentation/common_options.rst  |  9 +++++
>  tools/bpf/bpftool/bash-completion/bpftool     |  2 +-
>  tools/bpf/bpftool/main.c                      | 13 +++++-
>  tools/bpf/bpftool/main.h                      |  3 +-
>  tools/bpf/bpftool/prog.c                      | 40 +++++++++++--------
>  5 files changed, 48 insertions(+), 19 deletions(-)
>

[...]
