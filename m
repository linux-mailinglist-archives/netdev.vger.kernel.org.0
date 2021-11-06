Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F576447019
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 20:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhKFT2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 15:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhKFT2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 15:28:46 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299A5C061570;
        Sat,  6 Nov 2021 12:26:05 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x64so12090073pfd.6;
        Sat, 06 Nov 2021 12:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TCDGGZBE94EQitsRdSmlc57LXB5IcNg6m4Ayk7djMx0=;
        b=nVle96lFWTcyEKKJblARx0AXUoplXBuzWb43YpjzRNoPgdxh0qK7dmxOQZvajG+AFX
         NwhGZ4eLdrav+ZHG7ZerA+WJB2/N3Is1AVUEG7K+i5IZ9WlIXBrXr3GD3Z86J4Gb8jIa
         4tjfRnJtpD1O5KNW4ukAXjRMYKiZ9MS0NFu10cBtfiijaEXVDhvirdgtXaFhHdh6oBo8
         NLn5g0I+3h82rkYKyN9CnT8X4tmLnmzyBMVxfln4ZMovTNLbOwO/V/H0z4w3u9mp18Dv
         5vVih+dEyTpd19mknq80ZUm4MShlfac6yu1YPh1bEDXLAFX1ZThSWLf+DtIGwdY4mi9n
         Pb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TCDGGZBE94EQitsRdSmlc57LXB5IcNg6m4Ayk7djMx0=;
        b=HgStvI7YaykurtxWIUczGYv3bW39A+7JVk5kN4i7e2vysHt1wWeG0YahzLczfx7qQq
         i67sEi1itPRUMp68emYzdY2LlZYSZ7K4I5gzkZypTi46vleQAoIqYTPFwzIS71vXiDxM
         u84PBnPbzqOEhpWQb7F24HhJvsR5DE/1iqrfLJ3JHy+k0S/vO9GF0WOa9XA9tO0QKNF5
         rAbeaEvFZffuYaW+3PER+jGgflO6MaydQSmuY/egidfvKTjqEHucRwAynq9DdeABIQjW
         w7k7CLUuCKvsvlCCSENMJpnxJ7mVeDuhrCgu3oRsQ+Az/tKNJW6zdBeGDPQf4f0vZBaE
         /x9w==
X-Gm-Message-State: AOAM531wprfIibXx5+mo2BB4dw0FauiIcilTcp1gww4ONJi2B/tMv9SE
        1kfGZJtlLmfw6i9CozfJDW0=
X-Google-Smtp-Source: ABdhPJw5EZVXyp5rlY45NYQHOEgmKeQZcAxlnJ2vvEqfWTjHw2IC+PbkyxELwW6Jz7H4dM59cwX2Pw==
X-Received: by 2002:a63:8842:: with SMTP id l63mr40077006pgd.280.1636226764537;
        Sat, 06 Nov 2021 12:26:04 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:5e3b])
        by smtp.gmail.com with ESMTPSA id l21sm10852049pfu.213.2021.11.06.12.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 12:26:04 -0700 (PDT)
Date:   Sat, 6 Nov 2021 12:26:02 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: add bpf_strncmp helper
Message-ID: <20211106192602.knmfk2x7ogcjuzvw@ast-mbp.dhcp.thefacebook.com>
References: <20211106132822.1396621-1-houtao1@huawei.com>
 <20211106132822.1396621-2-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106132822.1396621-2-houtao1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 06, 2021 at 09:28:21PM +0800, Hou Tao wrote:
> The helper compares two strings: one string is a null-terminated
> read-only string, and another one has const max storage size. And
> it can be used to compare file name in tracing or LSM program.
> 
> We don't check whether or not s2 in bpf_strncmp() is null-terminated,
> because its content may be changed by malicous program, and we only
> ensure the memory accessed is bounded by s2_sz.

I think "malicous" adjective is unnecessary and misleading.
It's also misspelled.
Just mention that 2nd argument doesn't have to be null terminated.

> + * long bpf_strncmp(const char *s1, const char *s2, u32 s2_sz)
...
> +BPF_CALL_3(bpf_strncmp, const char *, s1, const char *, s2, size_t, s2_sz)

probably should match u32 instead of size_t.

> @@ -1210,6 +1210,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_get_branch_snapshot_proto;
>  	case BPF_FUNC_trace_vprintk:
>  		return bpf_get_trace_vprintk_proto();
> +	case BPF_FUNC_strncmp:
> +		return &bpf_strncmp_proto;

why tracing only?
Should probably be in bpf_base_func_proto.

I was thinking whether the proto could be:
long bpf_strncmp(const char *s1, u32 s1_sz, const char *s2)
but I think your version is better though having const string as 1st arg
is a bit odd in normal C.

Would it make sense to add bpf_memchr as well while we are at it?
And
static inline bpf_strnlen(const char *s, u32 sz)
{
  return bpf_memchr(s, sz, 0);
}
to bpf_helpers.h ?
