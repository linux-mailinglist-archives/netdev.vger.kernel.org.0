Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C131413CC7
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 23:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhIUVnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 17:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbhIUVnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 17:43:46 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22775C061574;
        Tue, 21 Sep 2021 14:42:17 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id b65so1989766qkc.13;
        Tue, 21 Sep 2021 14:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ro2YixzMDZ5dVPKfSw8tokOtOhrHNap6kjyBrMgwAAM=;
        b=O3BhxXcuTAptGUsKz6UTeYzCS/vwEbuOQtCBDcTLXYN1giRf+RMFln6OMdT5Uly2VF
         Tkq3X3JmKP7Zj1haW8g7xeNMzl0EhmezsxFITFZIOdLOXiA+Ew6l+r5mEQ+2oHVhxRv8
         oj3bcNua0YmwNMYoNF1JpPVhzFWOKrmWZ2xFiU7KTQrmKj77TT9eMQ2jBfOlHMuizPtY
         LowNZNSAO63fg38Ct+7o3GBqma9sAnTWmEtjmXySYRvFHdpr4jea/9CoOB8V2cMW4yuP
         /3iFtHe0dTKvgEbcrgwENZi+mURaTR1VeTpTSxRakuOfEHd5RxLumELreW/7WYNMHO+O
         yrvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ro2YixzMDZ5dVPKfSw8tokOtOhrHNap6kjyBrMgwAAM=;
        b=jyQN8D1OktfnkE8rKsBVPtaGLR1mi+YtCcrqZyTHx0q5osqiD/cPpcEjuyDKHqZkwI
         iMyjWB+RS6pUVy0j/JtVREe0g3aSDbJ3BMVhKD69fAkI+NpZfLyHQyIFQg3rSOB6Iy/C
         +X/qElWVwjOsRr7zQq+HvVtjFt/85TOu1xYk7E2da4Gz9NKrTWk/hjhwKbPRD++h198C
         XXcUeXIigYDtsXIyXOk5dKHagnDCGcT2bgmVjg+nJ+f3eRybgIduILv5hQfI4Jbu17LQ
         Lp62CGUBA+7ko5ePsCyyOE6Yhe5fz+x6P7vhJNdm0GWcF6DUbPSWDChwDOlkVOSeXhr9
         +5Lw==
X-Gm-Message-State: AOAM531FTsfenO82S/orgJXwPbrf8BfiZxD3Ysa5PXle4XbpcNvBQAPA
        9FToM4jx/HERUlcrRE6vV9bo1dz1Uo/mf5RtbYM=
X-Google-Smtp-Source: ABdhPJyonbyXlJtr8w6VPfAzWqyqqOC+Bzh/x/JR+aQF3MU1iIKZ/CXTfWqZ15V+hnI8GQIWvfVDGoOXKvkdHquTwZY=
X-Received: by 2002:a25:83c6:: with SMTP id v6mr9787437ybm.2.1632260536348;
 Tue, 21 Sep 2021 14:42:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210918020958.1167652-1-houtao1@huawei.com> <20210918020958.1167652-3-houtao1@huawei.com>
In-Reply-To: <20210918020958.1167652-3-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Sep 2021 14:42:05 -0700
Message-ID: <CAEf4BzaVaOiwkNgFQjwRfy9V_5NqiEyPMj-_AotO5TYeWiva3g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] libbpf: support detecting and attaching
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

On Fri, Sep 17, 2021 at 6:56 PM Hou Tao <houtao1@huawei.com> wrote:
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
> index da65a1666a5e..981fcdd95bdc 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7976,6 +7976,10 @@ static const struct bpf_sec_def section_defs[] = {
>                 .attach_fn = attach_raw_tp),
>         SEC_DEF("raw_tp/", RAW_TRACEPOINT,
>                 .attach_fn = attach_raw_tp),
> +       SEC_DEF("raw_tracepoint_writable/", RAW_TRACEPOINT_WRITABLE,
> +               .attach_fn = attach_raw_tp),
> +       SEC_DEF("raw_tp_writable/", RAW_TRACEPOINT_WRITABLE,
> +               .attach_fn = attach_raw_tp),

_writable is a bit mouthful, maybe we should do the same we did for
"sleepable", just add ".w" suffix? So it will be "raw_tp.w/..."? Or
does anyone feel it's too subtle?

>         SEC_DEF("tp_btf/", TRACING,
>                 .expected_attach_type = BPF_TRACE_RAW_TP,
>                 .is_attach_btf = true,
> --
> 2.29.2
>
