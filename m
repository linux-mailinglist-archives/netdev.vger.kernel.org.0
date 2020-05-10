Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6B61CC5C5
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 02:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgEJAeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 20:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726565AbgEJAeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 20:34:05 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9278FC061A0C;
        Sat,  9 May 2020 17:34:05 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t9so6007777pjw.0;
        Sat, 09 May 2020 17:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fok3bSeMmPWC1v440GDAxr5f4bAfrcJQAnaAPZ9ct8g=;
        b=CceBlpKCLGPe0ou0kEAdsl7ZMJRfTYqYHg2qa3rUSqyPZHGcrJ2KlCde8YpmNyl693
         32DWagfnCWf8crOvczDU+cpt1khP6yTHdJHA5M6E9Loh+vn3AJ0RrkpP5U4vL5RxqaQw
         DgTl43A5OYu5bXbjAMyBlM+3fawYbHfyV2m7NtQxQty0qr64xCHShbcerOoPvX3yOOCI
         Ar1RXwWncp8r/N9umB9Oxfys4nmWa6NxC0qiZyJBSVz4jUTwAdcaVDNkHe3JNkJBsz/l
         RnASyCvlszOpcigpvwX/CzZZPxqvB93EdzXGKTdSasSVCJ1Tb1fB/I1cZU/NWOWqvzX2
         7KuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fok3bSeMmPWC1v440GDAxr5f4bAfrcJQAnaAPZ9ct8g=;
        b=KMdzl+yvZsTi+smftLlmRGYf3y4vgZcxygfdUUzAoYfgKk0oyi92Kwy2xB+t5hNTeE
         Q+CpjRai/bzwh84KOFWhLbnPY2hbwyKbHOjhdMg9V4Wc+RyqgNceDU4YU1n46pzd0ZRy
         scTPJll6tWvNl34K7mbecVdyftI4LW93HSdb7MEK4pwKjI6/O5vo1iLlntEAW0gZ2SkD
         ysJMbpwzItJ/tVtBfMS+9zSfOfipt2BGn7hk5aP4ETOSCCOXoLTWAdr6Kk0/szzFgyHa
         b9x9F1dRpPjgmXSus4jzwLrKiT83SQUwFVKNzedBBijlpavcs+VOr51QZbt6XGUMCwGj
         ua5A==
X-Gm-Message-State: AGi0PuYCQImrM01L0bUY8t8FQq4XLyrvU6wGf3bAOM8qskLHUkqbf1Nf
        E+H76uvDKozePoW85PqVNZw=
X-Google-Smtp-Source: APiQypLu6fxEYQihy+BfoG0viw5Vy3zDPzVTP9Cyx8Z3B67hEZQbUnupEvYm7vlWcxiCZhDtvrFBqQ==
X-Received: by 2002:a17:902:cb91:: with SMTP id d17mr9052840ply.129.1589070845092;
        Sat, 09 May 2020 17:34:05 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:7bdb])
        by smtp.gmail.com with ESMTPSA id k1sm653619pgh.78.2020.05.09.17.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 17:34:04 -0700 (PDT)
Date:   Sat, 9 May 2020 17:34:02 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v4 21/21] tools/bpf: selftests: add bpf_iter
 selftests
Message-ID: <20200510003402.3a4ozoynwm4mryi5@ast-mbp>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175923.2477637-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509175923.2477637-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 10:59:23AM -0700, Yonghong Song wrote:
> +static volatile const __u32 ret1;
> +
> +SEC("iter/bpf_map")
> +int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
> +{
> +	struct seq_file *seq = ctx->meta->seq;
> +	struct bpf_map *map = ctx->map;
> +	__u64 seq_num;
> +	int i, ret = 0;
> +
> +	if (map == (void *)0)
> +		return 0;
> +
> +	/* only dump map1_id and map2_id */
> +	if (map->id != map1_id && map->id != map2_id)
> +		return 0;
> +
> +	seq_num = ctx->meta->seq_num;
> +	if (map->id == map1_id) {
> +		map1_seqnum = seq_num;
> +		map1_accessed++;
> +	}
> +
> +	if (map->id == map2_id) {
> +		if (map2_accessed == 0) {
> +			map2_seqnum1 = seq_num;
> +			if (ret1)
> +				ret = 1;
> +		} else {
> +			map2_seqnum2 = seq_num;
> +		}
> +		map2_accessed++;
> +	}
> +
> +	/* fill seq_file buffer */
> +	for (i = 0; i < print_len; i++)
> +		bpf_seq_write(seq, &seq_num, sizeof(seq_num));
> +
> +	return ret;
> +}

I couldn't find where 'return 1' behavior is documented clearly.
I think it's a workaround for overflow.
When bpf prog detects overflow it can request replay of the element?
What if it keeps returning 1 ? read() will never finish?
