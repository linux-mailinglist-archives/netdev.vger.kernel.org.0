Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092505C0C7
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfGAQAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:00:48 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35434 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbfGAQAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:00:48 -0400
Received: by mail-pg1-f195.google.com with SMTP id s27so6267164pgl.2
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FjcvQf0+EDliTSl66tv0P/bDWsh6jRL+LJXCTtXFt1g=;
        b=OrIAlfjhVUmhrOqZsSu8xp0U4coee5W2Xmv3kzXJT0DDQ/pkWMgDD1qdYzoXUY3N8q
         uwk75wUsQ9gQ42Sh5FsrH3akWZFUI/wqfESacXIBBCE34rX5b0XB5JEifRDRCzSxSU19
         +u7L3S1aypGhTju07b+QXFjVqgyrACRmiQ837ws7iRZ1EX/+OpUSRFMGWreL/DuM3U2D
         /LqKrjDCEAFoOmzNVd5hT96SCrTS+O9qqpWebJcZYS0NEzVnMbehRogt6npinPlYYlFj
         WuaBO/9bueigqQNKECL57fAhVxFbYgjupBysFu+9sybrYkvs3+MjnbwPl8WCUxSu3ZCq
         h4Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FjcvQf0+EDliTSl66tv0P/bDWsh6jRL+LJXCTtXFt1g=;
        b=MKTQhdceZX3WNC8mgsAX4qlXrIkqzwEeCqEBVOtv/L5toRx6bRHju4jJR1eZnR7uV6
         6gP9f+iPCtnyEYLNQfIX8Ji4N9Lu38e6IVxDL10bKXEVlwJJyKRJXxSZr8oKSnX+m9+l
         iRAN86Vfxcwt9gy1Nx4HgMy5CdtzRfk+HF/AiYKtZEY8OdRA17XuldslDxldAcffrU7k
         It1BYi5Bg1j7cNDK2+LBdg96hmAWx9i+N6kBFKWrmtgXTj7KEbiAS4xjcHI+uYqe9hE4
         vAF3c/mH8gHLJplHVBWUW6emFRYRV8H9bhAFnwDbH76/gsbjrqu/H242PgFLjrCFEpKs
         Tslg==
X-Gm-Message-State: APjAAAWlrcPpaUS48BV9K+8DnSi8jC39yttflkYGpekUTDSkDFE+60TW
        h7E5Y/i0xeC3F9TQZ99pt0UsVw==
X-Google-Smtp-Source: APXvYqzEDFFAOz7lZcDQRoS6x0/XXUKjnRMVElSbZ7ZnmnUKrWULiX9Knehjco+abxc3iUVirJNsrQ==
X-Received: by 2002:a65:640a:: with SMTP id a10mr16609103pgv.338.1561996846916;
        Mon, 01 Jul 2019 09:00:46 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id r27sm24773939pgn.25.2019.07.01.09.00.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 09:00:46 -0700 (PDT)
Date:   Mon, 1 Jul 2019 09:00:45 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Yonghong Song <yhs@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add verifier tests for wide
 stores
Message-ID: <20190701160045.GB6757@mini-arch>
References: <20190628231049.22149-1-sdf@google.com>
 <20190628231049.22149-2-sdf@google.com>
 <8e469767-a108-ba42-f8c8-6fd505393699@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e469767-a108-ba42-f8c8-6fd505393699@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/30, Yonghong Song wrote:
> 
> 
> On 6/28/19 4:10 PM, Stanislav Fomichev wrote:
> > Make sure that wide stores are allowed at proper (aligned) addresses.
> > Note that user_ip6 is naturally aligned on 8-byte boundary, so
> > correct addresses are user_ip6[0] and user_ip6[2]. msg_src_ip6 is,
> > however, aligned on a 4-byte bondary, so only msg_src_ip6[1]
> > can be wide-stored.
> > 
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   tools/testing/selftests/bpf/test_verifier.c   | 17 ++++++--
> >   .../selftests/bpf/verifier/wide_store.c       | 40 +++++++++++++++++++
> >   2 files changed, 54 insertions(+), 3 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c
> > 
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > index c5514daf8865..b0773291012a 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -105,6 +105,7 @@ struct bpf_test {
> >   			__u64 data64[TEST_DATA_LEN / 8];
> >   		};
> >   	} retvals[MAX_TEST_RUNS];
> > +	enum bpf_attach_type expected_attach_type;
> >   };
> >   
> >   /* Note we want this to be 64 bit aligned so that the end of our array is
> > @@ -850,6 +851,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >   	int fd_prog, expected_ret, alignment_prevented_execution;
> >   	int prog_len, prog_type = test->prog_type;
> >   	struct bpf_insn *prog = test->insns;
> > +	struct bpf_load_program_attr attr;
> >   	int run_errs, run_successes;
> >   	int map_fds[MAX_NR_MAPS];
> >   	const char *expected_err;
> > @@ -881,8 +883,17 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >   		pflags |= BPF_F_STRICT_ALIGNMENT;
> >   	if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
> >   		pflags |= BPF_F_ANY_ALIGNMENT;
> > -	fd_prog = bpf_verify_program(prog_type, prog, prog_len, pflags,
> > -				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 4);
> > +
> > +	memset(&attr, 0, sizeof(attr));
> > +	attr.prog_type = prog_type;
> > +	attr.expected_attach_type = test->expected_attach_type;
> > +	attr.insns = prog;
> > +	attr.insns_cnt = prog_len;
> > +	attr.license = "GPL";
> > +	attr.log_level = 4;
> > +	attr.prog_flags = pflags;
> > +
> > +	fd_prog = bpf_load_program_xattr(&attr, bpf_vlog, sizeof(bpf_vlog));
> >   	if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
> >   		printf("SKIP (unsupported program type %d)\n", prog_type);
> >   		skips++;
> > @@ -912,7 +923,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >   			printf("FAIL\nUnexpected success to load!\n");
> >   			goto fail_log;
> >   		}
> > -		if (!strstr(bpf_vlog, expected_err)) {
> > +		if (!expected_err || !strstr(bpf_vlog, expected_err)) {
> >   			printf("FAIL\nUnexpected error message!\n\tEXP: %s\n\tRES: %s\n",
> >   			      expected_err, bpf_vlog);
> >   			goto fail_log;
> > diff --git a/tools/testing/selftests/bpf/verifier/wide_store.c b/tools/testing/selftests/bpf/verifier/wide_store.c
> > new file mode 100644
> > index 000000000000..c6385f45b114
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/verifier/wide_store.c
> > @@ -0,0 +1,40 @@
> > +#define BPF_SOCK_ADDR(field, off, res, err) \
> > +{ \
> > +	"wide store to bpf_sock_addr." #field "[" #off "]", \
> > +	.insns = { \
> > +	BPF_MOV64_IMM(BPF_REG_0, 1), \
> > +	BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, \
> > +		    offsetof(struct bpf_sock_addr, field[off])), \
> > +	BPF_EXIT_INSN(), \
> > +	}, \
> > +	.result = res, \
> > +	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR, \
> > +	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG, \
> > +	.errstr = err, \
> > +}
> > +
> > +/* user_ip6[0] is u64 aligned */
> > +BPF_SOCK_ADDR(user_ip6, 0, ACCEPT,
> > +	      NULL),
> > +BPF_SOCK_ADDR(user_ip6, 1, REJECT,
> > +	      "invalid bpf_context access off=12 size=8"),
> > +BPF_SOCK_ADDR(user_ip6, 2, ACCEPT,
> > +	      NULL),
> > +BPF_SOCK_ADDR(user_ip6, 3, REJECT,
> > +	      "invalid bpf_context access off=20 size=8"),
> > +BPF_SOCK_ADDR(user_ip6, 4, REJECT,
> > +	      "invalid bpf_context access off=24 size=8"),
> 
> With offset 4, we have
> #968/p wide store to bpf_sock_addr.user_ip6[4] OK
> 
> This test case can be removed. user code typically
> won't write bpf_sock_addr.user_ip6[4], and compiler
> typically will give a warning since it is out of
> array bound. Any particular reason you want to
> include this one?
Agreed on both, I'm being overly cautious here. They should
be caught by the outer switch and be rejected because of
other reasons.

> > +
> > +/* msg_src_ip6[0] is _not_ u64 aligned */
> > +BPF_SOCK_ADDR(msg_src_ip6, 0, REJECT,
> > +	      "invalid bpf_context access off=44 size=8"),
> > +BPF_SOCK_ADDR(msg_src_ip6, 1, ACCEPT,
> > +	      NULL),
> > +BPF_SOCK_ADDR(msg_src_ip6, 2, REJECT,
> > +	      "invalid bpf_context access off=52 size=8"),
> > +BPF_SOCK_ADDR(msg_src_ip6, 3, REJECT,
> > +	      "invalid bpf_context access off=56 size=8"),
> > +BPF_SOCK_ADDR(msg_src_ip6, 4, REJECT,
> > +	      "invalid bpf_context access off=60 size=8"),
> 
> The same as above, offset=4 case can be removed?
> 
> > +
> > +#undef BPF_SOCK_ADDR
> > 
