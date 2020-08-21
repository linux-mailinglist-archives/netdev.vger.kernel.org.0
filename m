Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66A924E33F
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 00:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgHUWXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 18:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgHUWXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 18:23:21 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBF2C061573;
        Fri, 21 Aug 2020 15:23:20 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id v9so3501245ljk.6;
        Fri, 21 Aug 2020 15:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5EbZZfuV4GDQSR4VGhwmwzf2HPW9JYVp8//mO3kBas=;
        b=O6LzcYOn3H5JNR7Pl9/j31er+ZDv+aRGee1WPY0t5GPfw8PEQNx26GGou8pvCabqsn
         EbtINBzx6k5wRSHI3yPAAanvCE+NaMIvi9ql25er++yvRhqcpz596aVkZ3Ct+pJL87s6
         ORDEMMKeE4FlNqND3y6NtrTqYvQ1/jcga+51RBmocRHbgXxNh4kudSJCWTYyFWogdfd6
         lRe32iPDQLEKqaLiwLNDySLtALeyEL04do41CzywnEIVQ2iztP5m0+aMakp+dtuJkElA
         8xNjlMtbe9CUSf73YLqahrbIU5AUZY8EbkAplzhmuIPdcPKg4iqAooIvWRFQM/ottJhU
         3p4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5EbZZfuV4GDQSR4VGhwmwzf2HPW9JYVp8//mO3kBas=;
        b=JL4Vs9Y4wjKcM381us/BYICxddH4dVH/FR3KM1D1NgbXuNUSYfFdb4xdfE+5pNuMhh
         7clcXaTBhXBxI4+Pjac5/VoJRL2pj+5/89AqUdQ83A132EcVuw4FvbBF3bl7WNZhrMn8
         OeOaTOfN6BGVgdWPMOJrHI8/V0ND4oAQviZ9swkgfxWJ5h9eUNGGpRNwsGfiMMuXwQmi
         Tpb9mL4TcO0AjrfMKwXl7wPxnAINttGZPFlnbLl7L07PqAs6NXf3MAxYNE3WvyJJ8JB1
         XiLPDDr0z6O7RYdbR8F/xpmuGuYGwVK5DczKDBKUl8OLbTjslMUYX0JP+176ETpzuRkf
         uo2Q==
X-Gm-Message-State: AOAM530AvXyf3rYkMCYR52Tnv+2L6zuAxSVrqJLydpLnYLI/Mu/GV+7F
        FyiChYWxgtMFgFIgEEg7RCWbjFJSH9Gjld8XKq4=
X-Google-Smtp-Source: ABdhPJzjj7p5mC2uy7QOk5Sb/sheiEQYzKLHMa2wInhLAMqr8Y/vlDs0rB3xonWr4dZopWrZuTEnqkB8wuqBEsUFOmA=
X-Received: by 2002:a2e:b6c3:: with SMTP id m3mr2488224ljo.450.1598048598851;
 Fri, 21 Aug 2020 15:23:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200821102948.21918-1-lmb@cloudflare.com>
In-Reply-To: <20200821102948.21918-1-lmb@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Aug 2020 15:23:07 -0700
Message-ID: <CAADnVQKj5yEcRLq83B_Otp5AfY4TNWA6q9DSUGTr02kBXZmiyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/6] Allow updating sockmap / sockhash from BPF
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 3:30 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> We're currently building a control plane for our BPF socket dispatch
> work. As part of that, we have a need to create a copy of an existing
> sockhash, to allow us to change the keys. I previously proposed allowing
> privileged userspace to look up sockets, which doesn't work due to
> security concerns (see [1]).
>
> In follow up discussions during BPF office hours we identified bpf_iter
> as a possible solution: instead of accessing sockets from user space
> we can iterate the source sockhash, and insert the values into a new
> map. Enabling this requires two pieces: the ability to iterate
> sockmap and sockhash, as well as being able to call map_update_elem
> from BPF.
>
> This patch set implements the latter: it's now possible to update
> sockmap from BPF context. As a next step, we can implement bpf_iter
> for sockmap.
>
> ===
>
> I've done some more fixups, and audited the safe contexts more
> thoroughly. As a result I'm removing CGROUP_SKB, SK_MSG and SK_SKB
> for now.
>
> Changes in v3:
> - Use CHECK as much as possible (Yonghong)
> - Reject ARG_PTR_TO_MAP_VALUE_OR_NULL for sockmap (Yonghong)
> - Remove CGROUP_SKB, SK_MSG, SK_SKB from safe contexts
> - Test that the verifier rejects update from unsafe context

All looks good to me.
I've applied the set.
Please follow up with a cleanup to selftests as Yonghong suggested.
