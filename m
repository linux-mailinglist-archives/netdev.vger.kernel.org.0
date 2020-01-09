Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67921350D9
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgAIBH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 20:07:27 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43725 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgAIBH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 20:07:27 -0500
Received: by mail-qk1-f194.google.com with SMTP id t129so4502959qke.10;
        Wed, 08 Jan 2020 17:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:message-id;
        bh=Y/4MDExChkZau02Wyj1Y9rypHfHdC+K+/ULNVewLyV4=;
        b=AdLvJBTLCdz1L+u7Aal3o+we9LitdL6/Zr1Xy9Yq1UtZJwDtSR8UMYzGWwqQO/rr+Z
         zRAKhVebPSMisthZ0R2LPsrWcUozqT6pgOgw+4Y3+XQ5JnzVu2Jk1gSRcYGOGo/qYl6z
         uOEnPQokz3CCjhCdQuPw9rK5uv5lY/ZOtEbAasa6TJ5NdumJawg7BZIPoD1uM6zIBIV4
         xrNUImt7YTrie+PeUOHPX87UG9k8KQC0PgA4B4HwSnn84Kv6BYacKy1MMiq+nE89hagI
         FnoHpANU24JkVeCGwZeHXdN85kUarVf2FuD74YtWmgjOJvFaGVx0QyReOEZc7uTlQP7I
         EnGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:message-id;
        bh=Y/4MDExChkZau02Wyj1Y9rypHfHdC+K+/ULNVewLyV4=;
        b=ebyqh0ZMQ0GPNjH+NPNauuR86YCYAK7RN6oYqHNJS2/5EvLaoKrkuQOhspEZDaqoH3
         /GrM31FfzHZG3m62SxUhbTDSGtAsebv6LroMBa62HyYV6/uueqCsMzCpq49mghp6zNGY
         tkMgcIPjKYl9PPzld6ooPMcOERWVmcKGP93D7MmqwpvLWH/oxzgX73EJSh6I8ZAYah/0
         j9q5FoYEDQLWqWZdLIK2YQm4jZIZ9hrG2BOi00Xm7xbWrbMAIYzX0pOWcuj5eKuRNdFq
         K7Gd+UY7y6hbs2PYuSrjRSbflSjV4KC1mRYY5eYb0T8CuYVBEemGwdvJGwVErdokrDvD
         JTaw==
X-Gm-Message-State: APjAAAU+4hv72KmiBzmF/rPGICCwRAM4HIUzuCJhnRI/2VciQwDbaaL/
        irp05hxaaKyyUqkjmu6ZdW8=
X-Google-Smtp-Source: APXvYqwgJQ2BszMYnV1btisfImyOM+p0XvPTgCDWb0r9CEOvCDYOSMrquTbKXDCdjmE85633xiDrJQ==
X-Received: by 2002:a37:ac16:: with SMTP id e22mr7316063qkm.186.1578532046405;
        Wed, 08 Jan 2020 17:07:26 -0800 (PST)
Received: from [192.168.86.249] ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id 2sm2262575qkv.98.2020.01.08.17.07.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 17:07:25 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Date:   Wed, 08 Jan 2020 22:06:44 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <20200109004424.3894196-1-kafai@fb.com>
References: <20200109003453.3854769-1-kafai@fb.com> <20200109004424.3894196-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH bpf-next v4 01/11] bpf: Save PTR_TO_BTF_ID register state when spilling to stack
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Message-ID: <9EC7DCC9-B219-4545-BA93-E2AC0569C843@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On January 8, 2020 9:44:24 PM GMT-03:00, Martin KaFai Lau <kafai@fb=2Ecom> =
wrote:
>This patch makes the verifier save the PTR_TO_BTF_ID register state
>when
>spilling to the stack=2E

You say what it does, but not why that is needed :-/

- Arnaldo
>
>Acked-by: Yonghong Song <yhs@fb=2Ecom>
>Signed-off-by: Martin KaFai Lau <kafai@fb=2Ecom>
>---
> kernel/bpf/verifier=2Ec | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/kernel/bpf/verifier=2Ec b/kernel/bpf/verifier=2Ec
>index 6f63ae7a370c=2E=2Ed433d70022fd 100644
>--- a/kernel/bpf/verifier=2Ec
>+++ b/kernel/bpf/verifier=2Ec
>@@ -1916,6 +1916,7 @@ static bool is_spillable_regtype(enum
>bpf_reg_type type)
> 	case PTR_TO_TCP_SOCK:
> 	case PTR_TO_TCP_SOCK_OR_NULL:
> 	case PTR_TO_XDP_SOCK:
>+	case PTR_TO_BTF_ID:
> 		return true;
> 	default:
> 		return false;

