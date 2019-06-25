Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4203A5586B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfFYUI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:08:26 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45996 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbfFYUIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:08:25 -0400
Received: by mail-pl1-f196.google.com with SMTP id bi6so23902plb.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZmfgUvSKsxGJWxDPJZxJdLCc4A053/l+NMKJ98odJj0=;
        b=FKNudjZnwyh6DfF+62stYSAzQF+mywGHpH8+TPPM4J2Cm7My+57LlQIULAK+LJMmh+
         hzA7KJVqKeUNy+hggsgi+CzqXp1rtLNT2IMfKa1MCz/KBU0hlMSBGlqXdIPVg2Rghe4V
         Nfc08Uh1YLQzxXTeGCTq69cbNy8BpNZy04XgpssT7EWkoK50h8jHBT2n5cly9cMFYnaq
         WB0P0OsNarW/rVixB5+oVE/LK4JKmjpQwAzHyMMH/YYefwPQwUmvoaxqtzJpezjYlXG3
         cPkXQccDCDOIcE3K5qBdOU9LKydjmxrwBirEpIJaKFfsy8P7qbVHLavbcMDK2JEM3elB
         VY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZmfgUvSKsxGJWxDPJZxJdLCc4A053/l+NMKJ98odJj0=;
        b=MsnqYHeC4wIs19YQyE+YZvPwFkzfxRpif95Jrv92pe6EnOetPqqry8rR8zRcWx38Pv
         cE8SCkY/bQWxXb1Tq2YrvBfC0MsSU6MWojsJ+nvIOKPD6otxrLq2yTTZSjBS1vUql9J8
         ErufzJ+LpbDEFNUAwhrJXTEQYwODOdn15QS8MTn19jImjtsrcuW+MNFwhg701dXQTdzK
         QtUiP9SP6fvC456TYzgrRXccUGr4I8D0nSRV+JPiNn7rcVh3fZqZxAFyKlgrmT5Ij1+r
         UaTd7bCvU6J2+62ZlLyqMFAB8dkvoS1mCd89FDs991Y//sjNckROETjAdR9zm+j1Ngk5
         WXMw==
X-Gm-Message-State: APjAAAXoikCbFS20ddxq0MBDCi6axomOawKoLYlMVXSqkx4zP8ZYczQx
        SsN2npiq7BLjelu5zHNUT4AtAA==
X-Google-Smtp-Source: APXvYqyXOJPUPyiAxrZ2cCKgETQPQglhAhcHovAirkKtw+UhwLSk1/666t/ofU//Ncco8GGkJkSuPQ==
X-Received: by 2002:a17:902:7894:: with SMTP id q20mr471120pll.339.1561493305108;
        Tue, 25 Jun 2019 13:08:25 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id f88sm81478pjg.5.2019.06.25.13.08.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 13:08:24 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:08:23 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     netdev@vger.kernel.org, Alban Crequy <alban@kinvolk.io>,
        Iago =?iso-8859-1?Q?L=F3pez?= Galeiras <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [bpf-next v2 03/10] selftests/bpf: Avoid another case of errno
 clobbering
Message-ID: <20190625200823.GB10487@mini-arch>
References: <20190625194215.14927-1-krzesimir@kinvolk.io>
 <20190625194215.14927-4-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625194215.14927-4-krzesimir@kinvolk.io>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/25, Krzesimir Nowak wrote:
> Commit 8184d44c9a57 ("selftests/bpf: skip verifier tests for
> unsupported program types") added a check for an unsupported program
> type. The function doing it changes errno, so test_verifier should
> save it before calling it if test_verifier wants to print a reason why
> verifying a BPF program of a supported type failed.
> 
> Fixes: 8184d44c9a57 ("selftests/bpf: skip verifier tests for unsupported program types")
> Cc: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index 12589da13487..779e30b96ded 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -867,6 +867,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>  	int fixup_skips;
>  	__u32 pflags;
>  	int i, err;
> +	int saved_errno;
Reverse Christmas tree. Otherwise LGTM.

>  
>  	for (i = 0; i < MAX_NR_MAPS; i++)
>  		map_fds[i] = -1;
> @@ -894,6 +895,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>  		pflags |= BPF_F_ANY_ALIGNMENT;
>  	fd_prog = bpf_verify_program(prog_type, prog, prog_len, pflags,
>  				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 4);
> +	saved_errno = errno;
>  	if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
>  		printf("SKIP (unsupported program type %d)\n", prog_type);
>  		skips++;
> @@ -910,7 +912,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>  	if (expected_ret == ACCEPT) {
>  		if (fd_prog < 0) {
>  			printf("FAIL\nFailed to load prog '%s'!\n",
> -			       strerror(errno));
> +			       strerror(saved_errno));
>  			goto fail_log;
>  		}
>  #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> -- 
> 2.20.1
> 
