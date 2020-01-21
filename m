Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313921434B9
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 01:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAUAYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 19:24:11 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33261 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgAUAYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 19:24:11 -0500
Received: by mail-il1-f196.google.com with SMTP id v15so983789iln.0;
        Mon, 20 Jan 2020 16:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=DlcI6bB3XZo+tEJuOk7rJDBEyCbKWyCGb9fvywI64zI=;
        b=KxRQVaDMzVI5BMv1vFBXcGfF+rNsGV/f+VTGO41NTAAfm/A45sIsb6U5UBdeWs5NpK
         V/Sc7X+4whayri+cUCcDvji7JcuLur0mxQMBupWXg5DpCknagNCbGM8jRrkbOCIIerr7
         TVO//pRfgi9H2GminrI6b+jA7yOZhsR/lAXY3OHQXxErnbiLG40JulJC4pMOn8QkobR2
         b8qmK8+YosUlkZIqYg8HETmMefxz1sW7dQkLrIsKQZeHYskhIJwYHXG5MbzESmVO6NaH
         Ql3H8HlxO+9uEWciwGoShOLdBue/ryZ5HyFZx0onjJogJzwIHURGziP4X6rUYe4QqoIl
         ncVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=DlcI6bB3XZo+tEJuOk7rJDBEyCbKWyCGb9fvywI64zI=;
        b=DRK8Tu4fcz0ymWW3YV+7UdMEvID0cKvnErQD6i3MU9TsGmK8mIF5f8+qhwS71k0NAu
         Oe110MPy8sCa4n74zpxv8Dgx0gpbusWibVpIqrKfcpDPxArSun2pSxBs1V2cav+HWWsR
         RnbcyC/K7XR3FINKn0ZayILIZrgyvmz7Iz8Mz70gyhs3b8LzEXsmOCYHKGdMdE5Y3zp/
         YjoLztNDfTk0UbhMc+YYrj/0xa/G97RTJ6MsAxUvuQRtRZ2Nh4mlHJNnNOLEZf4uJEnV
         15yEWK6o3b8egqPyYhg66odERcHul26E3qm3Mkxlu7OhJwkekSKSTHuML+lu0bY9/NbP
         fghA==
X-Gm-Message-State: APjAAAV4qpkTyK5c26Tyc9vOGwkSJOZqk/l9zije7U5BJY0Jaw5ldovJ
        qMk7N1b18Qv2fnDdaWurZ1lvYibm
X-Google-Smtp-Source: APXvYqyGlhp/EjZpz2uSIUgyTjB53jaDP/25NMtZI+c56nyddpJQVApVT34dgURVAPC2Wryck381oQ==
X-Received: by 2002:a92:7606:: with SMTP id r6mr1438271ilc.120.1579566250722;
        Mon, 20 Jan 2020 16:24:10 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q9sm8976656iod.79.2020.01.20.16.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 16:24:10 -0800 (PST)
Date:   Mon, 20 Jan 2020 16:24:01 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <5e2644a144e2c_20912afc5c86e5c4cc@john-XPS-13-9370.notmuch>
In-Reply-To: <20200118134945.493811-2-jolsa@kernel.org>
References: <20200118134945.493811-1-jolsa@kernel.org>
 <20200118134945.493811-2-jolsa@kernel.org>
Subject: RE: [PATCH 1/6] bpf: Allow ctx access for pointers to scalar
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa wrote:
> When accessing the context we allow access to arguments with
> scalar type and pointer to struct. But we omit pointer to scalar
> type, which is the case for many functions and same case as
> when accessing scalar.
> 
> Adding the check if the pointer is to scalar type and allow it.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/btf.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 832b5d7fd892..207ae554e0ce 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3668,7 +3668,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>  		    const struct bpf_prog *prog,
>  		    struct bpf_insn_access_aux *info)
>  {
> -	const struct btf_type *t = prog->aux->attach_func_proto;
> +	const struct btf_type *tp, *t = prog->aux->attach_func_proto;
>  	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
>  	struct btf *btf = bpf_prog_get_target_btf(prog);
>  	const char *tname = prog->aux->attach_func_name;
> @@ -3730,6 +3730,17 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>  		 */
>  		return true;
>  
> +	tp = btf_type_by_id(btf, t->type);
> +	/* skip modifiers */
> +	while (btf_type_is_modifier(tp))
> +		tp = btf_type_by_id(btf, tp->type);
> +
> +	if (btf_type_is_int(tp) || btf_type_is_enum(tp))
> +		/* This is a pointer scalar.
> +		 * It is the same as scalar from the verifier safety pov.
> +		 */
> +		return true;
> +
>  	/* this is a pointer to another type */
>  	info->reg_type = PTR_TO_BTF_ID;
>  

Acked-by: John Fastabend <john.fastabend@gmail.com>
