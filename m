Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8EE25C9B0
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgICTvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgICTvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:51:18 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B14C061244;
        Thu,  3 Sep 2020 12:51:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gl3so909016pjb.1;
        Thu, 03 Sep 2020 12:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6B0Zt4L4438kTcyiY4vRFcH55d4QhrJ3dYLjLq46ZHA=;
        b=g3VYwYg9RcspHLVhzYWQiJaF4pTz5nkQQ9LfBGc2I4Pmp9SqVb4psmYXSzTL4PtDAq
         WMwwqaAyRipcaLM4zCMe8Qr+hNG3Y3dvezWs9ccJNsFRCwMdCGHeNJ4G5pi3brDvBRqG
         0rYSgxBDa5GarTD/7qFFNgyzrCPZUuAlbAVop47ka5faAYUfgzT99ewAtkH/VGHyTNp+
         1wJ3dAP9aPSiTeouKIIFp93Ym0dJ456h/a2kRWtkzaP2OH3K5TGGHNfHErocYPtwLClh
         1c6bwFjnia7z6szXFGy2/yQvhRGFRT3Dc7mArfI9hn/MgnHvV0zMMvfkuWZEEw5UEgbP
         aAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6B0Zt4L4438kTcyiY4vRFcH55d4QhrJ3dYLjLq46ZHA=;
        b=tZazdy7TcTzO2QfpYPEkquhGTFW3yqeUyRh983Mrvp6UC/ZPssV1qbCSwQuv2P6CLU
         ZwjAJwnbnqseWfv/wOQu4/Tb925pfBBOeCb+7eVs8zAwtMmlnUFkwGKEYH7vDs8ZtYdS
         qhxyThn/QvO0Zq/oQNDbB/PDmM5/SXcT3T19jB0AJwaV8rcPLZ3hMZYoI7yc22vXiHVd
         UcFVyJy0yzQMif056XT1KojSoqlP62c7vIqI0LEuFmUQDXT9eIzVQurVQpk54G5SNPl/
         fYtxs+F/VSEFy8t0u2tOh10895PVqL+xYvzfoZtWyfE3DSBbUSxN+7rpYpHEtwLkYSnD
         n3kA==
X-Gm-Message-State: AOAM530tK4FdYe3yU7PsdhBISLWjUQssDKc3zf3tiOroo5I4Rfq5uEDW
        FN8FfAATv7Z0uo8b5m5RzFY=
X-Google-Smtp-Source: ABdhPJyTNwrxwIFfiPY3hIx/VSx5VO4y+sCmlOJpYeB9esRJ+ZkIKwtzj2cHxFfZVq3ninzbWG9yHw==
X-Received: by 2002:a17:90b:4718:: with SMTP id jc24mr2180055pjb.214.1599162677182;
        Thu, 03 Sep 2020 12:51:17 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7ac4])
        by smtp.gmail.com with ESMTPSA id e12sm3234482pjl.9.2020.09.03.12.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 12:51:16 -0700 (PDT)
Date:   Thu, 3 Sep 2020 12:51:14 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v7 bpf-next 7/7] selftests: bpf: add dummy prog for
 bpf2bpf with tailcall
Message-ID: <20200903195114.ccfzmgcl4ngz2mqv@ast-mbp.dhcp.thefacebook.com>
References: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
 <20200902200815.3924-8-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902200815.3924-8-maciej.fijalkowski@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 10:08:15PM +0200, Maciej Fijalkowski wrote:
> diff --git a/tools/testing/selftests/bpf/progs/tailcall6.c b/tools/testing/selftests/bpf/progs/tailcall6.c
> new file mode 100644
> index 000000000000..e72ca5869b58
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/tailcall6.c
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
> +	__uint(max_entries, 2);
> +	__uint(key_size, sizeof(__u32));
> +	__uint(value_size, sizeof(__u32));
> +} jmp_table SEC(".maps");
> +
> +#define TAIL_FUNC(x) 				\
> +	SEC("classifier/" #x)			\
> +	int bpf_func_##x(struct __sk_buff *skb)	\
> +	{					\
> +		return x;			\
> +	}
> +TAIL_FUNC(0)
> +TAIL_FUNC(1)
> +
> +static __attribute__ ((noinline))
> +int subprog_tail(struct __sk_buff *skb)
> +{
> +	bpf_tail_call(skb, &jmp_table, 0);
> +
> +	return skb->len * 2;
> +}
> +
> +SEC("classifier")
> +int entry(struct __sk_buff *skb)
> +{
> +	bpf_tail_call(skb, &jmp_table, 1);
> +
> +	return subprog_tail(skb);
> +}

Could you add few more tests to exercise the new feature more thoroughly?
Something like tailcall3.c that checks 32 limit, but doing tail_call from subprog.
And another test that consume non-trival amount of stack in each function.
Adding 'volatile char arr[128] = {};' would do the trick.
