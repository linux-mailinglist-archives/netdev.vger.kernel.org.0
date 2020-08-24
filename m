Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B02E250B0A
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 23:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHXVnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 17:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXVnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 17:43:31 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24651C061574;
        Mon, 24 Aug 2020 14:43:31 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id g6so11374648ljn.11;
        Mon, 24 Aug 2020 14:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gYZ9ojAlDXMp/qByKGyMDM4tuzCNQNP3qnaRsbtvbxM=;
        b=bDnQH5uLYiiPMHo5IWJSR/k07DXHBzDXJww1rq9839eV2Af0dk3PX9x77IoAsIP/6b
         /TTEdR2Y6PSY7IgIcZGC/+7ODZhOIEvT1vxGskWEuvKnWlolliyBxeKcdNtMB2aT5dZM
         35avIvPHTNJ72VAK6RS09hhCQH4aTZx/I5vb6e8u40CniqgR5yi+ZJqK9n58uWTjNpr0
         5QnTLYzEfAjxPI6j5J02qaAlISGpuK6ELoY487BerP9gThd7Mr8SI00Ffv6/vqRFkY8W
         A1K+EAXkC/z+LNvpITO6MqZ41jjo1uKsCDXplkO0jOsN+qBWZ8bZXqzEktrFI9vcPlRw
         0Qxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gYZ9ojAlDXMp/qByKGyMDM4tuzCNQNP3qnaRsbtvbxM=;
        b=kA7T+QmZUBgUOzxauO2ENJF6xDnLOBQoEdWih2VJ/3dNNBBokNiTI4EOCctHhOwpF7
         EmbF39xaxBqEYJ1sgUAi7dGjGSdciFcubsUx0I9eS5vZja8m27ZhnBRap19av4JwPbc0
         akL87pWb3coE0B69XkfzleIXYXmBrd8Uqxk/AJARzWNlKfM1TUvni9UTtOPcwX6ojw2x
         qB+7L52DKBIONJOeVOtuapDx+uoENULRMwmQ/zMYYUtVf7xVCrHHtVCB2ojT9VRMyIpv
         rNglIq5EfB0f+va3aRiZUJ6/dBTmxX2wC9O6PpKqAzYzO194FRS440pdtUs2X9HujpBh
         MFLA==
X-Gm-Message-State: AOAM533VNPz+QnI28DQbaqXu69ZrC7gGF0awlTQ2WpaO3fNOjspjiXtZ
        yFxSEWTXKv6tJVLBVu7gN605HKIyQEePMVyasmamCz0N
X-Google-Smtp-Source: ABdhPJwXg+I9XIxzsLWs0IHZg7cizReSBNZRuZvD/FYNWCR6Wp9oFp5moJyftwl2kTAVijRmYA7GASM+Se4zrjQEfAw=
X-Received: by 2002:a2e:968c:: with SMTP id q12mr3289561lji.51.1598305409559;
 Mon, 24 Aug 2020 14:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200820190008.2883500-1-kafai@fb.com>
In-Reply-To: <20200820190008.2883500-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Aug 2020 14:43:18 -0700
Message-ID: <CAADnVQKWSmjcy727_mhZvMnO=TdAjpA_0=LfABd9FwYUzZuW7Q@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 00/12] BPF TCP header options
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 12:00 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The earlier effort in BPF-TCP-CC allows the TCP Congestion Control
> algorithm to be written in BPF.  It opens up opportunities to allow
> a faster turnaround time in testing/releasing new congestion control
> ideas to production environment.
>
> The same flexibility can be extended to writing TCP header option.
> It is not uncommon that people want to test new TCP header option
> to improve the TCP performance.  Another use case is for data-center
> that has a more controlled environment and has more flexibility in
> putting header options for internal traffic only.
>
> This patch set introduces the necessary BPF logic and API to
> allow bpf program to write and parse header options.
>
> There are also some changes to TCP and they are mostly to provide
> the needed sk and skb info to the bpf program to make decision.
>
> Patch 9 is the main patch and has more details on the API and design.
>
> The set includes an example which sends the max delay ack in
> the BPF TCP header option and the receiving side can
> then adjust its RTO accordingly.
>
> v5:
> - Move some of the comments from git commit message to the UAPI bpf.h
>   in patch 9
>
> - Some variable clean up in the tests (patch 11).

Applied. Thanks!
