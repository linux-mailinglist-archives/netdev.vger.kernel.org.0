Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090DD381424
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhENXP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENXP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 19:15:58 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F01EC06174A;
        Fri, 14 May 2021 16:14:46 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id z13so627189lft.1;
        Fri, 14 May 2021 16:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CzDfQYMTOaPbin5q9xJWRHDcrPLj/vT6cRZOobVQLXI=;
        b=SK5mGJUQMUb3fBGz+f6QsaGEFjiwBofNzQa4yngxE5UVCTk7L3BF7Tbta1/a88MmqK
         yIrLMdsGXlnf+76ojiby4V9U+FLrl/DI0t7dV4eCXzOzEJje1wOimzLCaGHCdpXhFgN5
         Bltjxilg3ttxa6UufTTxmBAqV/dOoAL6fXokIiwWPto7OX332VrMBRi2x96KgegPR1Dv
         p4Pu3S2E3ghKkX/vv66Ak0u9DSNr6RTxZQXijsGFrBeQ8h4vUGn4Whpomzfui1oGng3n
         nVlPwndZKLz6GsltomESGuGZnZKHUiTRsjpsrhj5zKz3S3hPAJXNWmiiC4P/1Oc2pQeE
         l/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CzDfQYMTOaPbin5q9xJWRHDcrPLj/vT6cRZOobVQLXI=;
        b=eH5RfD27Dajq16/esle/7XIKcgrE5rS17E5OMSxkmEJtlH8/2X01pipwZ7c1mnxZrc
         Wz2s35j2sJEG1hSD0klPlLUsYITwp763J9lPGrGckIe2tRL37W6EDES7U5z9Twh3vYhR
         JM8d4AZ6n1tq/zmm1AhBXj8ikHf56EMy31YLyAI81S/a4wKFFo2Pd0HsQF6OvpXsbavy
         55P3mg/gFEHTxmLdpKZk/8JguF59UvqfuP/L0eBwUxQZa40QX4DlhuC6m62Q69hFR4+j
         5ztXuLgboRgJfYMu6+/dHp2U+57zVJBG0JWz3mkSWMddsdZ4CwAprfzOkaeJ3Bi1gnBm
         zo0Q==
X-Gm-Message-State: AOAM533oonJnRC6hR0McmzPLJOaWg0GXdzolK8g6BgU/jhJG/5eqhaEU
        SInAHawMt05bOO/cHY8rfcJEliCR48TMLbO3PGg=
X-Google-Smtp-Source: ABdhPJwvwpauT6YQuHcL9u9qC6cggsQJcVVzVLVymDj0fM47bLDZPgtoUa4rx6kOgBRKqcPvohzY5ktDpCuJBnZP9Z8=
X-Received: by 2002:a05:6512:2036:: with SMTP id s22mr35853609lfs.540.1621034084989;
 Fri, 14 May 2021 16:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210514195534.1440970-1-andrii@kernel.org>
In-Reply-To: <20210514195534.1440970-1-andrii@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 May 2021 16:14:33 -0700
Message-ID: <CAADnVQJEWUJ68SQG=bDHG007384xsbPzH5-hdXuZYpDR-txBBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: reject static entry-point BPF programs
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 1:34 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Detect use of static entry-point BPF programs (those with SEC() markings) and
> emit error message.

Applied. I was wondering whether you've seen such combinations ?
