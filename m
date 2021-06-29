Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB6C3B7334
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 15:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhF2NbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 09:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbhF2NbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 09:31:20 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2BAC061760;
        Tue, 29 Jun 2021 06:28:52 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id h15so39410064lfv.12;
        Tue, 29 Jun 2021 06:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZPxCf3JCehIZHiIYfg7q22e3r1xUPANOMTT9AMRGzuU=;
        b=qTVdFLSUjzYjD3ekV8wcNQf77zEezrhV1goIRdnSb7b/x5Vsj08iNOz9iU4I1UedwV
         zp7B91UVP16QYwJWE9sCUwEVdtrLrbej3A+0+vlt85AeQ3QXQOD8DAZK93peTWCZplpi
         Ea/jZMAY7xiJP5MZ9DWq6NFLBB5qFpeK+m9HZF57RCVLgGpE5zeK8AVkYOM7tZuSQZZ3
         wnRg3lrXrHIqaIMM7XPYLEHGzGvtf7netm+LgViTFdPelNFplDPddejLIJZK0TDblmyC
         0AvN308BqNXcbCmk9eVt1pvPjctKnno/cr8cZAQeSnpXBmfXs96eaxlPx2ZYBG8ImmKN
         8c0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZPxCf3JCehIZHiIYfg7q22e3r1xUPANOMTT9AMRGzuU=;
        b=k+RPtB6gtW39UOWxj8exXxydvzabDDtUuLXZRjrN/XKbzmsHoF5VHRHHHi/XAkvnow
         24xBikREPjIBzyO44K1Uw3cPX1Fz0xQWZ/DJxU7oFU6Z7lmQCcO5eoSJKHWLGpwyUIMD
         0rGlLewBxycKCL7pKqmYE5TEEigAC2qePnkiYuZJ01t8g3aZwv5f5k0yv9t+1ftDwUPC
         1ifOFaCJZDdwDIY/acTZmsjrf1WE69tVUmCSMeZFPgUJSPbzPDhc3IEvsEv2xac5hrqu
         yN52LaeunmBDiDJdNj6647vT3EzWjnFnBLDVVvRY0adLM1cyuaXCe6/2qN8/NsjWV60v
         C0SA==
X-Gm-Message-State: AOAM532UjXtgw1M3OTnKWVPxpQNw1MbWBXPCWAnpgOQdAPkFpAGuB1AT
        QwKUaOMxPnDSSS+PbUD1e7dEN5e/XM2EFQnL0UY=
X-Google-Smtp-Source: ABdhPJwasruHD3uwUaDPnT7kv7sg5ec0P0mwQBVlVxKTMAnV6L6j1hWCd0CGN8sydF3JnaMzFwOVGORSMlOfvYMSVDg=
X-Received: by 2002:a05:6512:33b8:: with SMTP id i24mr22660554lfg.540.1624973331047;
 Tue, 29 Jun 2021 06:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com> <fd30895e-475f-c78a-d367-2abdf835c9ef@fb.com>
 <20210629014607.fz5tkewb6n3u6pvr@ast-mbp.dhcp.thefacebook.com> <CAEf4BzaPPDEUvsx51mEpp_vJoXVwJQrLu5QnL4pSnL9YAPXevw@mail.gmail.com>
In-Reply-To: <CAEf4BzaPPDEUvsx51mEpp_vJoXVwJQrLu5QnL4pSnL9YAPXevw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Jun 2021 06:28:39 -0700
Message-ID: <CAADnVQ+erEuHj_0cy16DBFSu_Otj-+60EZN__9W=vogeNQuBOg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 11:34 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> Have you considered alternatively to implement something like
> bpf_ringbuf_query() for BPF ringbuf that will allow to query various
> things about the timer (e.g., whether it is active or not, and, of
> course, remaining expiry time). That will be more general, easier to
> extend, and will cover this use case:
>
> long exp = bpf_timer_query(&t->timer, BPF_TIMER_EXPIRY);
> bpf_timer_start(&t->timer, new_callback, exp);

yes, but...
hrtimer_get_remaining + timer_start to that value is racy
and not accurate.
hrtimer_get_expires_ns + timer_start(MODE_ABS)
would be accurate, but that's an unnecessary complication.
To live replace old bpf prog with new one
bpf_for_each_map_elem() { bpf_timer_set_callback(new_prog); }
is much faster, since timers don't need to be dequeue, enqueue.
No need to worry about hrtimer machinery internal changes, etc.
bpf prog being replaced shouldn't be affecting the rest of the system.

> This will keep common timer scenarios to just two steps, init + start,
> but won't prevent more complicated ones. Things like extending
> expiration by one second relative that what was remaining will be
> possible as well.

Extending expiration would be more accurate with hrtimer_forward_now().

All of the above points are minor compared to the verifier advantage.
bpf_timer_set_callback() typically won't be called from the callback.
So verifier's insn_procssed will be drastically lower.
The combinatorial explosion of states even for this small
selftests/bpf/progs/timer.c is significant.
With bpf_timer_set_callback() is done outside of callback the verifier
behavior will be predictable.
To some degree patches 4-6 could have been delayed, but since the
the algo is understood and it's working, I'm going to keep them.
It's nice to have that flexibility, but the less pressure on the
verifier the better.
