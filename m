Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76036662CFD
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbjAIRj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237167AbjAIRj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:39:27 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DE32BC6
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:39:26 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id bk2-20020a056a02028200b004a7e2a790d2so3948280pgb.18
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6EYMc5+vcvT6f31eLJLkK3p4u36cmy2i+T+Mh/4Q6NA=;
        b=FLs67g0QQc461pVpmVYzv4JE42HcNJbYVaVQb86HYVjfvccG7Wve5dzAONsJVLjl3l
         Kd3Bh3ROGfbudVrMmXU/eCnEBE/znoDln/DcgPLDeNgaUBkIUZ2UaJIOS8wMi0LSERgh
         wgcWtKCgu98ayOkdDY+ifxqZaqtzjM77Ap2i0oWMKI3/QDdgQxt/4YeSOMnUXBhWwboY
         lDBBvTaUxZNKyxLnC59v7GRd8us3KBx7ycMpLaVTANgMMVPtWo7T2xttqbrm6jvXxc61
         8No1JfurnmCn4sAx7utqc+O0kjvC4lQU7OM0FpAApLY6DTU0t6x3ImBrnGVUo1N/07Ea
         1GFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6EYMc5+vcvT6f31eLJLkK3p4u36cmy2i+T+Mh/4Q6NA=;
        b=hMhwVbqNKQcAskiffzzqqq4RFk3sjaDbS5dTjNsJsWfMVtg/OjhGkZz0TxeEmcGxAl
         DLKIZT13LG2kqMzPiHzgPa6Oto8CYHUXZLWllTPknBUFOrsbYu4FXVD7F2mgg+AN76pu
         tqbOcq/QIc1l9MjKXUyGa9V/GJk9VH2iW0NJmJMyEpM87tVHhZjiSwRCR2K87+IQHaZg
         pJOyJg+skHpJEWs1e109QqTnn4n5X2p37kgrLvV0GgOdXSycKFN2kigdSpnF0hnbEEmH
         mjuIrCVXFpG5kSGCdYhlgtAkGGq1N28LLPRPuYDZao1LMAPqfRFfqp3KwooRBitkGCN4
         Aewg==
X-Gm-Message-State: AFqh2konbGGn1cmie2J04FmdJ70+whGKyqkJUo4DqK2l9GN/KsxLGwg2
        f/z1FGeOiNbovMuTYEuQ0KlKeEU=
X-Google-Smtp-Source: AMrXdXtvgn68FFnPUvQB/BnPtGld7g/pBzpiV+iqx7hVRMVQJmOFIdrSn3NeWo6eBus19cbmn3qcZTA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:451:b0:192:821b:dbda with SMTP id
 iw17-20020a170903045100b00192821bdbdamr3361160plb.58.1673285965987; Mon, 09
 Jan 2023 09:39:25 -0800 (PST)
Date:   Mon, 9 Jan 2023 09:39:24 -0800
In-Reply-To: <20230108151258.96570-1-haiyue.wang@intel.com>
Mime-Version: 1.0
References: <20230108151258.96570-1-haiyue.wang@intel.com>
Message-ID: <Y7xRLsOD1l9FpnC5@google.com>
Subject: Re: [PATCH bpf-next v1] bpf: Remove the unnecessary insn buffer comparison
From:   sdf@google.com
To:     Haiyue Wang <haiyue.wang@intel.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/08, Haiyue Wang wrote:
> The variable 'insn' is initialized to 'insn_buf' without being changed,
> only some helper macros are defined, so the insn buffer comparison is
> unnecessary, just remove it.

> Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>

Acked-by: Stanislav Fomichev <sdf@google.com>

Looks like these should have been removed as part of commit 2377b81de527
("bpf: split shared bpf_tcp_sock and bpf_sock_ops implementation").

> ---
>   net/core/filter.c | 6 ------
>   1 file changed, 6 deletions(-)

> diff --git a/net/core/filter.c b/net/core/filter.c
> index ab811293ae5d..d9befa6ba04e 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6847,9 +6847,6 @@ u32 bpf_tcp_sock_convert_ctx_access(enum  
> bpf_access_type type,
>   					FIELD));			\
>   	} while (0)

> -	if (insn > insn_buf)
> -		return insn - insn_buf;
> -
>   	switch (si->off) {
>   	case offsetof(struct bpf_tcp_sock, rtt_min):
>   		BUILD_BUG_ON(sizeof_field(struct tcp_sock, rtt_min) !=
> @@ -10147,9 +10144,6 @@ static u32 sock_ops_convert_ctx_access(enum  
> bpf_access_type type,
>   			SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ);	      \
>   	} while (0)

> -	if (insn > insn_buf)
> -		return insn - insn_buf;
> -
>   	switch (si->off) {
>   	case offsetof(struct bpf_sock_ops, op):
>   		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_ops_kern,
> --
> 2.39.0

