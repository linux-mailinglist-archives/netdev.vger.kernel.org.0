Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4052EB38D
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbhAETiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbhAETiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:38:03 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367F8C061574;
        Tue,  5 Jan 2021 11:37:23 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id y19so1034902lfa.13;
        Tue, 05 Jan 2021 11:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lbcebCZ1MmPv0hTnOsvUP04wUdUENhOR/cS8MJh5+Mk=;
        b=MD3ns3mKoyBHtZ1QM1HxXrkBUaF9jcij1KHlYIssQ9dMfE+iVSSOmnn5TCvkRO4OvD
         e9LxGDhgA0Djd+LlstMj+0/k6QR3OYdYbmEzoUW93+567/2wB+OyrqOYGHdoUVF7SzK2
         t2tE4UBoTfS7OShoARwfUNl9Fr7RclHA5xrnxBuNmL+tjwBRDBlvkD0n8SwHX8DnOvQr
         tFlVHiLYi6GikSmZI2rczObTlUBBxqKb/v2vwkeWFmr44K6qS1xBv9/qdm/Dhsi+0iu8
         xd6SmYu5mMN8EMfwNBBuy8iG7pmXLN3h0dPOGnkl+1woiLso+cdG2DKwvSJRSShVElwl
         EHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lbcebCZ1MmPv0hTnOsvUP04wUdUENhOR/cS8MJh5+Mk=;
        b=HC8JeMX47rnt9f573eMuHfCQL6/XMGY9dKlvMMhwFMP1mCyQ5k8xw1JjGYlKfQLB2E
         zDEYgvm0YEWATqpTp2exSlXDYK0xOmKAWO1UlETX4/wduTf90pcrHr5xdegfNPNpJVjE
         ON0vj6gGosuhTVTBaduiWL+R4e8NZtmTNLWM1Bwc7EthETeZZyEATcbWZNWdJmGwg9Q7
         0bN56IQzxSjZs4OwWtcvJX5nYg3ZllP44I5zu/tHH9XKPOutDwigk5m6UlPWZUu+0TAo
         /RK/5X+FJenhhVQ0mx9L5r4c7KWQWDUBDxBwVWd45uH7Wgoz+1gbaEVaOAOS1tddUyxh
         WPPA==
X-Gm-Message-State: AOAM531HHE+dvOuImuntrmJj5ot3mqN1wwTToYHXZTR9lh5Lnrjlrsaq
        MmqX+fHh8XFeAfFxf++QVB8L2hEg+L2CzU0gdoo=
X-Google-Smtp-Source: ABdhPJx97VKtysMqaANMOIY5jaNxPh+lu06xbd5tkgLFOeLm9kFLSZw2PNQc/L9wNMigQnfkwX2BmFoYfjWVmS9waac=
X-Received: by 2002:a2e:86d4:: with SMTP id n20mr495761ljj.486.1609875441621;
 Tue, 05 Jan 2021 11:37:21 -0800 (PST)
MIME-Version: 1.0
References: <20210105153944.951019-1-jolsa@kernel.org>
In-Reply-To: <20210105153944.951019-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 5 Jan 2021 11:37:09 -0800
Message-ID: <CAADnVQJSry=o-GOPT0XL0=qGrikz=TuP=Wx7fHyiQVjLqMcOxA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Warn when having multiple
 IDs for single type
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 7:39 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The kernel image can contain multiple types (structs/unions)
> with the same name. This causes distinct type hierarchies in
> BTF data and makes resolve_btfids fail with error like:
>
>   BTFIDS  vmlinux
> FAILED unresolved symbol udp6_sock
>
> as reported by Qais Yousef [1].
>
> This change adds warning when multiple types of the same name
> are detected:
>
>   BTFIDS  vmlinux
> WARN: multiple IDs found for 'file' (526, 113351)
> WARN: multiple IDs found for 'sk_buff' (2744, 113958)
>
> We keep the lower ID for the given type instance and let the
> build continue.

I think it would make sense to mention this decision in the warning.
'WARN: multiple IDs' is ambiguous and confusing when action is not specified.
