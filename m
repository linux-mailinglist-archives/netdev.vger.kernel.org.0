Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9186D275CF0
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgIWQJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIWQJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:09:29 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F1EC0613CE;
        Wed, 23 Sep 2020 09:09:29 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 67so164013ybt.6;
        Wed, 23 Sep 2020 09:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o7WnvxJmBRfhtrCbHCwlnuPx6FcGYiuUSlQl7hdJlDM=;
        b=VAE/OFovGRVsF5o3leexmAjVxOWHNn2l+p+DVjShO8XVmkEBoD/Oq9B2oDSv5jIRU1
         TaxfX44mqoHVFw1RArxz8x0ipQ4bzOuCRlhqq93omu3gmD5urzNMPY85wZy6rzB1ZPCl
         XonezG+572WVQZLJS60Lo7V4jGaEY9xCPVWPwSvxvoUwgYA3PbC+T3LhjagnaHyV+Gro
         b3VOkhJRwReIw0AQ5ewuUiF/B2W65qvDgQ4Cewne0OP8JjyPFFqn4o3Am/Lw9nY4Tkff
         TxQ6DDXrBcu/ZgswG01P6gI2nZ+2f3Cg9hy3jiVG+KlTDQGT2l2fkd18SPwuCUUIQncz
         TxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o7WnvxJmBRfhtrCbHCwlnuPx6FcGYiuUSlQl7hdJlDM=;
        b=Pe3LSPv8ihfJmIWnT+glke9EGrc5Z2K2aKPOdrqyUQBh177uwn+PNLS18/jT+PYfpa
         M2VDbcBQC2KMRziXTTg7UrlW9WjynWFbYw6Dh9PrPCI7at/QS3x12N6duYJiylvjCJFE
         O51W6LmV0huIpgA6Yl9K/MR4Gct/8m+bQxExYy91eAXEpGykh8avB4InJsBWqwa/B589
         lBrfDGpMt3HgphIi7Alx1V683pRO6K5U1Vvgfs0fhmjehjKoRJxA9EYGCT8CaWZEjvIr
         m6my/EzHnbw12d6ChF3MszXUJ8gjyLOVaSjr6+2tCYK/4Ex6C1Mc68GwkMoEUNiATqN0
         zp0w==
X-Gm-Message-State: AOAM5321r+qsuOOsfdJzAcJYHJcBiZjtw+xWe6bYgPUSt7CAPrq50Bed
        a8ZObg8Ln6KNPMAyPNLuoZPoh5DEA28U7xZ/jdU=
X-Google-Smtp-Source: ABdhPJzF599RIgymjA3gXYO1sdQNLbOAom1Dnk3kV+PnHLqSq55TcT3cTP8WxsmuUChdb8qS+TOsw76dCjGzoEEQEgY=
X-Received: by 2002:a25:cbc4:: with SMTP id b187mr1064977ybg.260.1600877368732;
 Wed, 23 Sep 2020 09:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200923140459.3029213-1-jolsa@kernel.org>
In-Reply-To: <20200923140459.3029213-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 09:09:17 -0700
Message-ID: <CAEf4BzZM8UOZ4x_uDtbzMbpmYGcLSo5h-7miPMAd+wDzMuG7Aw@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 1/2] bpf: Use --no-fail option if CONFIG_BPF is
 not enabled
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 7:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Currently all the resolve_btfids 'users' are under CONFIG_BPF
> code, so if we have CONFIG_BPF disabled, resolve_btfids will
> fail, because there's no data to resolve.
>
> Disabling resolve_btfids if there's CONFIG_BPF disabled,
> so we won't fail such builds.
>
> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> v2 changes:
>   - disable resolve_btfids completely when CONFIG_BPF is not defined

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
