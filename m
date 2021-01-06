Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C4A2EB80A
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 03:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbhAFCWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 21:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAFCWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 21:22:14 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC36C061388;
        Tue,  5 Jan 2021 18:21:33 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id 23so3174771lfg.10;
        Tue, 05 Jan 2021 18:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rf2LmiBJeICZtEhUFiqzhFAR41rj9LXb37Bn/RGx8tA=;
        b=Uo2HG634dyKTpsbAatK0DjeX1R1O8EmBBV+UykmwV0BmLJXTpj5NGEIwL7o03oEUMU
         Vkn4BDDFUVTI4C4A1dOogdtmNaPLN5Yrw/W1FLy4rn9FsCUbWdE2V1ou5PJjUdMBtxV7
         3dP/GS8+lkrZd/RMobNlISwyzZzQnbGPmMBfGsCTdmMi0Og68fSrxWGA+VbNLmOodgku
         Wa6XmivpAw0jMu/FVtrDKAUSD+BePS9v7TrEUi+zLbEMSIrOP4DWLKvF1kFbpZaTMuGe
         D8T75V9oMRH48LUYmT3XJFETS8a/V8IfEwmNPwxn23APw3HfnmRIlUZcuxbhc8940z9O
         zKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rf2LmiBJeICZtEhUFiqzhFAR41rj9LXb37Bn/RGx8tA=;
        b=NF6JBND395F4rzHA0oQ2IuRG5a6SKULHwEZWb2iERJfL9SJzCX+NZjnzgt2y8W0QyU
         PhWSxfnDWDqx0HyIKMfT3HWD9PPrbisg4rQNC/yra+V3CVYVUYoTfEVjTeeErG79E/XF
         VbtY78MlORrQrAk7nAHasZAjQRICwevhGOFftn73dlkhwZshrvk+0FEm/T99eY0GgHkc
         gUBA7+dpC98z0cmu5RzJWr05U7baXlMXk63xump0XecjmXemF0h0guN+78ofZKpYgjmk
         qaiNc/sFkoMcN7rO/1SQkUq/Owql0g0DGW1s9Iz+S74YZfYJQT/JxUdHGtf0QPOYk6pV
         5EMg==
X-Gm-Message-State: AOAM532m72c9NeJASgZ0fDlAxnnNzZ+yOX5tm39DpyZyJNGyrd/qYrXO
        SkNZ2y4pZeXu/hRsTCvxrf1wN3IJYYr5CfpWSsLkvYJAT/k=
X-Google-Smtp-Source: ABdhPJxFR10VK6gfjfYdHAAzyKvSsDmMYf8Dx24SWWpYbmU93Z8w9wFh4nDROeRkMh+6x+bWXxuoSy0X/NJB5m5VQYQ=
X-Received: by 2002:a2e:b889:: with SMTP id r9mr993921ljp.44.1609899692313;
 Tue, 05 Jan 2021 18:21:32 -0800 (PST)
MIME-Version: 1.0
References: <20210105234219.970039-1-jolsa@kernel.org>
In-Reply-To: <20210105234219.970039-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 5 Jan 2021 18:21:21 -0800
Message-ID: <CAADnVQ+PvG+aiKyhtf3Q7U6=6w_uehQ436k+K8fLvf4DD6VLnw@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next] tools/resolve_btfids: Warn when having
 multiple IDs for single type
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Qais Yousef <qais.yousef@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 3:42 PM Jiri Olsa <jolsa@kernel.org> wrote:
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
> WARN: multiple IDs found for 'file': 526, 113351 - using 526
> WARN: multiple IDs found for 'sk_buff': 2744, 113958 - using 2744
>
> We keep the lower ID for the given type instance and let the
> build continue.
>
> Also changing the 'nr' variable name to 'nr_types' to avoid confusion.
>
> [1] https://lore.kernel.org/lkml/20201229151352.6hzmjvu3qh6p2qgg@e107158-lin/
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> v2 changes:
>   - changed the warning message [Alexei]
>   - renamed 'nr' to 'nr_types' [Andrii]

Applied to bpf tree. I think it's more appropriate there.
