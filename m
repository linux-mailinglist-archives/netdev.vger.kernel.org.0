Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A21241BAD6
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243189AbhI1XNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhI1XNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 19:13:16 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A0DC06161C;
        Tue, 28 Sep 2021 16:11:36 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id v10so1170623ybq.7;
        Tue, 28 Sep 2021 16:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4jz6ukNrcNWaVNNA7EbFxCp/sg39OswbF5lQyqgIPJo=;
        b=MAaYR0iuORFIKx+ElIMe1zDSthOqGF+AUWai8dbOpkxND7CVrt2iF3i6mzTjp+3Ncw
         BJvRU9/wMYG3BUVCVsHDM2re1wMqWH52A+3WNNI0CdadN6HoUOv7Xzh84n/RgSJ99rBe
         cKtHBjggQdkhQ3QxiIzA8VRZuCOOfMf9AdXO/CWx/OzZF6TzsbdY28tRlh1V4V0phLOk
         Ng5M0ef84azdfIDdMDrOlr+URzIB+1mTw49fZYHdFOCkKXakIRvTY60j7MtgIn34JJr+
         x+FW6jtd8H6hFqkTQQnk11/g7R39w9srVdhK8aW5bOZiKwV2xbG86ZhcSCAC8d/hcamH
         PbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4jz6ukNrcNWaVNNA7EbFxCp/sg39OswbF5lQyqgIPJo=;
        b=J30qXdSwxb+rYkIFAR1vmlwFxhpVSCDUjU3S4Dy5fJQpi9t55aAUuBNCNW3meKZUOK
         GsGOUFxmU/Z8UgwJk/O6BybSnOY3VN74DXFAun3tqXe5Pj50wdqDX0BHqkt6aZPyk8ic
         bRnWchwR/rCNm/pSmwqAT/q2c3YBgrRrk/FPOeR7i4yntEvwQgVu8wcrjS3itmUIa3+c
         IJDslF/RQzRptByQzrsK8xmVt7C9GnIdxilWHL+/V2XyNePFGIG6K8V4PkDFe5Lz1Xww
         N2jyLkMHi9+1KYAorEyvlwXpC2k+gWyyxX3QyvNWPL+W1po7gEmUAUNMqeNK8K5/cAE7
         ju+A==
X-Gm-Message-State: AOAM530TTccbPYRfFKlqgKazYLyhmT79SJC1jXagQVnsKFq/Bya04CdA
        DMUI1D8LgCWrV3VVDy/J0hUYvRP5hejTMmZkN55yTF1X
X-Google-Smtp-Source: ABdhPJy8i7FUOCE4ZekVZBJNUV/kemXFjua+ACVthghjrGW9lPfaF82/BcVRwRzfeJ9/5EoGrQdT6f+u4XsYMoQLYxY=
X-Received: by 2002:a25:2d4e:: with SMTP id s14mr9419488ybe.2.1632870695304;
 Tue, 28 Sep 2021 16:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210928140734.1274261-1-houtao1@huawei.com> <20210928140734.1274261-3-houtao1@huawei.com>
In-Reply-To: <20210928140734.1274261-3-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Sep 2021 16:11:24 -0700
Message-ID: <CAEf4BzaVdU04yFWfunPRY0H=QeiFR8VbBb2ESX56SS6LbRt5mg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: support detecting and attaching
 of writable tracepoint program
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 6:53 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Program on writable tracepoint is BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
> but its attachment is the same as BPF_PROG_TYPE_RAW_TRACEPOINT.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  tools/lib/bpf/libbpf.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ef5db34bf913..b874c0179084 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7976,6 +7976,10 @@ static const struct bpf_sec_def section_defs[] = {
>                 .attach_fn = attach_raw_tp),
>         SEC_DEF("raw_tp/", RAW_TRACEPOINT,
>                 .attach_fn = attach_raw_tp),
> +       SEC_DEF("raw_tracepoint.w/", RAW_TRACEPOINT_WRITABLE,
> +               .attach_fn = attach_raw_tp),
> +       SEC_DEF("raw_tp.w/", RAW_TRACEPOINT_WRITABLE,
> +               .attach_fn = attach_raw_tp),

Unfortunately I just refactored these SEC_DEF() definitions, please
rebase because this won't apply cleanly anymore. Otherwise it looks
good to me.

>         SEC_DEF("tp_btf/", TRACING,
>                 .expected_attach_type = BPF_TRACE_RAW_TP,
>                 .is_attach_btf = true,
> --
> 2.29.2
>
