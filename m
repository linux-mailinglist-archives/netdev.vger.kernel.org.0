Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A84D1E2944
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388836AbgEZRnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388411AbgEZRnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:43:04 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7516C03E96D;
        Tue, 26 May 2020 10:43:02 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id s1so21460031qkf.9;
        Tue, 26 May 2020 10:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BQN+VZ84dSHmhnUASEYXncTp1qj2l2GAA/bdjaWFvUo=;
        b=oPgrvKlTowHGv23d5VIsIUsDCeOvz6avn7yp7nv+SNS6T7ipuxffWYMWmkx0S5oR64
         Z9qh3JJarflx5ZPU59kmHSn8Y99TFwYwQZelkV2omuoiO3CncwSPogs/K40bja5g85k0
         ZbDCwWvsYPZd5KTiCer5CjWffHS6HPJ1PpkCWViXQciHxVgrW2SLJEoi7wsu3uLYwl48
         R4urwHR93MgujqF7M93H/JcwGDXPaxbFndY0N8v5d4ube+U1aE2Zk1HC90//UCCwZuTW
         abpiXT6wfuZFtEagVdifOzUzklmrE31SRYuT5vVEzxObcVbUt9YL9TNfGLhRJsuyzQca
         s1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQN+VZ84dSHmhnUASEYXncTp1qj2l2GAA/bdjaWFvUo=;
        b=BqsiIZ7fgs7W/37zCIGs0enl6EYn578oHI0I5LXmcRpMeeQulJGHQ1y4XFNYkBF438
         DpVWDQb9Cohqdpsdc1IV6z0DwWq6HabSM2GaFQwvF7PNP/zkRnVWi/36gIyQHP4fsHSR
         eYTnVFM+w56q9eOFN1g3ZI0BA/bINv/WuPYNGjW6npxR2UNsFQwrTWhYovHTdlWITTEv
         Eqm2WpM0GZxfiKy79/dadujDEQTXICJjbGiQ0rRENpRjHBy/rTq+J4Syj4HdvWpLdI9/
         Fgf6JMP4OOPqPQMb9+N/N884nDJjcFAVmQaoTmYYor3ef3Tu1HlCwPHxq5aaZBx1ZuvP
         dZPQ==
X-Gm-Message-State: AOAM53223LrEe+eccK8uKbEyY4uSmKG7eGq0iVW+TV1/SCJxDBv4uI6k
        ANs2HlQp80HTb0KFXz3DCOECT562P3alK2U96/A=
X-Google-Smtp-Source: ABdhPJwBcf+juW2NSOERP4BbfKCZ/oFbTWUlpmV1x5TU7wt5Q0rERlPzqxA4/miDXq3tplJbEooST/FupiLsGnUirF4=
X-Received: by 2002:a37:6508:: with SMTP id z8mr2577860qkb.39.1590514981961;
 Tue, 26 May 2020 10:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <159048487929.89441.7465713173442594608.stgit@ebuild>
In-Reply-To: <159048487929.89441.7465713173442594608.stgit@ebuild>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 May 2020 10:42:51 -0700
Message-ID: <CAEf4BzYyzQdukdACKaNHKuaZyFE4Qd2u0fJsUEV_hA_vhuSz4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: add API to consume the perf ring
 buffer content
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 2:22 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> This new API, perf_buffer__consume, can be used as follows:
> - When you have a perf ring where wakeup_events is higher than 1,
>   and you have remaining data in the rings you would like to pull
>   out on exit (or maybe based on a timeout).
> - For low latency cases where you burn a CPU that constantly polls
>   the queues.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---

Looks good, thanks. I'd really appreciate if you could follow up with
a fix to perf_buffer__free() as well. If not, I will get to it
eventually anyway :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
