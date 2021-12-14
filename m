Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E63474A58
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbhLNSEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236783AbhLNSEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 13:04:39 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0BAC06173E
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 10:04:39 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id m192so17568437qke.2
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 10:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iFd/RLtXfEa7FNow2Y8rcbCG+dp9BD0pUf8nWiAekpk=;
        b=RMH5Ly2BBs8fnXFQqM2JB55l792ROrwUnODNiBAmUogeZbFnQM9v0Fm8YJGXzynWWN
         iBgy6zFBfuUBmaMjnbcjt+O0mPQzqkE+uNCyhT1CkFYFxN7mUNtD7CN2xzRvO/PEJvIh
         AZ8j0RQ70ni+Dim0OOSoPlIDC7PaalpWTaEfrGCUTg3n5BMLvKl8xBDJ4sSXjfG3h+sa
         RhX9rjJxLmiEkT3lD+zeluLdIl5tT/IHwj4JLozPxe4GxlsrDyoz5zkQRI4uDPBtPeNx
         SqfYmKrcsZi3oDZuZmCKrlMJpt2CPZUbbvE7oyuWwOXDENIkls72QGKKcLKPA0rOqWje
         +U5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iFd/RLtXfEa7FNow2Y8rcbCG+dp9BD0pUf8nWiAekpk=;
        b=ZKgnCOEPEPOBPQkPdrMbiEYqNmpaYVUP4uQGbUx1riouFKY+XG/JOmYJptToBEUmHh
         sTjYBig7PWr6D3Lz3fK3aFzotjsSvh0GtO47dOQr1UYn0b7OP/aZEuS9Sah1O+W5VFZU
         7cHyC9cCmMSK/SbaOUzULvU+CpoZJDVQVbYZ4Ifvvkh+26iSLLRij9mlyVtPeSMy5noz
         ZAPoMFf4aFPqB9v6wS2kzBR9ixZgi/Z1Ukr71yqvEfx8VVTSDM/9VxfTlGgelvYaFsiy
         xz37IFWzcZRvJIYqidXYFf70G3apBTQ1hVtLvGhz3oo1Q+qbN18xjcWHzKF81aLKYYo2
         2FwQ==
X-Gm-Message-State: AOAM533plE1Yiag7syPRfvzEvJ2jGez2oQpl19DI7RzLUBdFbb66/PCX
        29nVSBxMJzSJUVJiq0af1w3/WkDuP5uTchEIiFhqYw==
X-Google-Smtp-Source: ABdhPJye7k3sUDvQJ7lwsSrRua4khAyxdXGYT2S2jVYUAjbHSaYNzwa8bkYyZYIzsswpgXol0brDVu8fvH/ZamF2B7c=
X-Received: by 2002:a37:8d84:: with SMTP id p126mr5465940qkd.684.1639505077989;
 Tue, 14 Dec 2021 10:04:37 -0800 (PST)
MIME-Version: 1.0
References: <d77b08bf757a8ea8dab3a495885c7de6ff6678da.1639102791.git.asml.silence@gmail.com>
 <20211211003838.7u4lcqghcq2gqvho@kafai-mbp.dhcp.thefacebook.com>
 <5f7d2f60-b833-04e5-7710-fdd2ef3b6f67@gmail.com> <20211211015656.tvufcnh5k4rrc7sw@kafai-mbp.dhcp.thefacebook.com>
 <fa707ef9-d612-a3a4-1b2a-fc2b28a3ec5f@gmail.com> <YbjaSNBlW03rX6c7@google.com>
 <5e2bc4bc-e844-9a8c-2a95-0f55645b4392@gmail.com>
In-Reply-To: <5e2bc4bc-e844-9a8c-2a95-0f55645b4392@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 14 Dec 2021 10:04:27 -0800
Message-ID: <CAKH8qBvRG3Zdpo0ZK_Mkji52HqMa=i9ftzMykZLQB5bnz1YAPA@mail.gmail.com>
Subject: Re: [BPF PATCH for-next] cgroup/bpf: fast path for not loaded skb BPF filtering
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 10:00 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 12/14/21 17:54, sdf@google.com wrote:
> > On 12/11, Pavel Begunkov wrote:
> >> On 12/11/21 01:56, Martin KaFai Lau wrote:
> >> > On Sat, Dec 11, 2021 at 01:15:05AM +0000, Pavel Begunkov wrote:
> >> > > That was the first idea, but it's still heavier than I'd wish. 0.3%-0.7%
> >> > > in profiles, something similar in reqs/s. rcu_read_lock/unlock() pair is
> >> > > cheap but anyway adds 2 barrier()s, and with bitmasks we can inline
> >> > > the check.
> >> > It sounds like there is opportunity to optimize
> >> > __cgroup_bpf_prog_array_is_empty().
> >> >
> >> > How about using rcu_access_pointer(), testing with &empty_prog_array.hdr,
> >> > and then inline it?  The cgroup prog array cannot be all
> >> > dummy_bpf_prog.prog.  If that could be the case, it should be replaced
> >> > with &empty_prog_array.hdr earlier, so please check.
> >
> >> I'd need to expose and export empty_prog_array, but that should do.
> >> Will try it out, thanks
> >
> > Note that we already use __cgroup_bpf_prog_array_is_empty in
> > __cgroup_bpf_run_filter_setsockopt/__cgroup_bpf_run_filter_getsockopt
> > for exactly the same purpose. If you happen to optimize it, pls
> > update these places as well.
>
> Just like it's already done in the patch? Or maybe you mean something else?

Ah, you already did it, looks good! I didn't scroll all the way to the
bottom and got distracted by Martin's comment about
__cgroup_bpf_prog_array_is_empty :-[
