Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB87A1FD3E5
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgFQR7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgFQR7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:59:34 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ECCC06174E;
        Wed, 17 Jun 2020 10:59:33 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id g12so1280430pll.10;
        Wed, 17 Jun 2020 10:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KBpDiaLT15delPy5COt9vQjrCES9AeENrwXSlPqpFNU=;
        b=Uns8VRqQF74W4bZf+C9AVhrXu+wTGSkbgzySn4xzVw6+sp09S7FE1th3d/RNHWSiIN
         PbSWqlTXriBkEqSsZQW5RRZ3Aj/qGImtcBfvq5mIWcDtyqomnbSkYkTPXy25GqTfo8x5
         LW4hY6/s8YC94TowrZfaWZpMt1x/muo0xlMDLVkuMeQITspKC3QJybuTkA09DLoFFTnF
         WLOg4Nj2xy3xIPe9u04zOExm0xc5yDrM4U7zHjXE3bg6VpoaHZEZnpDqTkSBcQAc9a0a
         R5BGBRuqfS5Jhx7psz8NvPmgf3QqAK5BOPjqWarf5oPETQXMXNl7whF6anLs27TfBDC0
         u9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KBpDiaLT15delPy5COt9vQjrCES9AeENrwXSlPqpFNU=;
        b=VzmaGljlirDVGRrfh05iaJmek8MoTFzu97S+BI+vvYEeiOUXKRtI8dsldCWBLs3fde
         ySDr84kkpAW/x0qPuDIxYmjkhQYAgax/VUd1lOpc9KyvL2f0dlw6AdJ52u5iUNxcv3jh
         ogUl2mo5xrbyLFu0FdjazWAKV77wig90qO0RU+NYzU2wtqeZjJjS6uyBvNB7anf9Os8W
         9Kbq2/1UAjxxO1FXjGzIf/BdN+w6twWSs2Kt7ary8JbBGLN0YAco+boSbz51SjFXlqSY
         Kr0xjC3Q3LqxPdN4kdvXg24xzwaIYwtIprLbsE7IYSY/r56j49H31v79RliLngBBaas1
         lIMA==
X-Gm-Message-State: AOAM530IE5Rt3NBZfOJR2dQxFQVsg/MF+dglGWBjEyuGjjtFL4cB0lI1
        KvxEQxAgCMc9JTJ7WK9sfmk=
X-Google-Smtp-Source: ABdhPJycrqFiTD880QjUoi+2JVC/poyKEIYTJuMb/7GzewRM8KuBreGpEMh+NtBEVe2CJiXRDZomSg==
X-Received: by 2002:a17:902:aa4c:: with SMTP id c12mr240447plr.280.1592416772218;
        Wed, 17 Jun 2020 10:59:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7972])
        by smtp.gmail.com with ESMTPSA id q13sm520176pfk.8.2020.06.17.10.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 10:59:31 -0700 (PDT)
Date:   Wed, 17 Jun 2020 10:59:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     sdf@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH bpf v5 1/3] bpf: don't return EINVAL from
 {get,set}sockopt when optlen > PAGE_SIZE
Message-ID: <20200617175929.7ee2alxyjfxuolw4@ast-mbp.dhcp.thefacebook.com>
References: <20200617010416.93086-1-sdf@google.com>
 <20200617170909.koev3t5fmngla3c4@ast-mbp.dhcp.thefacebook.com>
 <20200617174508.GA246265@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617174508.GA246265@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:45:08AM -0700, sdf@google.com wrote:
> On 06/17, Alexei Starovoitov wrote:
> > On Tue, Jun 16, 2020 at 06:04:14PM -0700, Stanislav Fomichev wrote:
> > > Attaching to these hooks can break iptables because its optval is
> > > usually quite big, or at least bigger than the current PAGE_SIZE limit.
> > > David also mentioned some SCTP options can be big (around 256k).
> > >
> > > For such optvals we expose only the first PAGE_SIZE bytes to
> > > the BPF program. BPF program has two options:
> > > 1. Set ctx->optlen to 0 to indicate that the BPF's optval
> > >    should be ignored and the kernel should use original userspace
> > >    value.
> > > 2. Set ctx->optlen to something that's smaller than the PAGE_SIZE.
> > >
> > > v5:
> > > * use ctx->optlen == 0 with trimmed buffer (Alexei Starovoitov)
> > > * update the docs accordingly
> > >
> > > v4:
> > > * use temporary buffer to avoid optval == optval_end == NULL;
> > >   this removes the corner case in the verifier that might assume
> > >   non-zero PTR_TO_PACKET/PTR_TO_PACKET_END.
> > >
> > > v3:
> > > * don't increase the limit, bypass the argument
> > >
> > > v2:
> > > * proper comments formatting (Jakub Kicinski)
> > >
> > > Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> > > Cc: David Laight <David.Laight@ACULAB.COM>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  kernel/bpf/cgroup.c | 53 ++++++++++++++++++++++++++++-----------------
> > >  1 file changed, 33 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index 4d76f16524cc..ac53102e244a 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -1276,16 +1276,23 @@ static bool
> > __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
> > >
> > >  static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int
> > max_optlen)
> > >  {
> > > -	if (unlikely(max_optlen > PAGE_SIZE) || max_optlen < 0)
> > > +	if (unlikely(max_optlen < 0))
> > >  		return -EINVAL;
> > >
> > > +	if (unlikely(max_optlen > PAGE_SIZE)) {
> > > +		/* We don't expose optvals that are greater than PAGE_SIZE
> > > +		 * to the BPF program.
> > > +		 */
> > > +		max_optlen = PAGE_SIZE;
> > > +	}
> > > +
> > >  	ctx->optval = kzalloc(max_optlen, GFP_USER);
> > >  	if (!ctx->optval)
> > >  		return -ENOMEM;
> > >
> > >  	ctx->optval_end = ctx->optval + max_optlen;
> > >
> > > -	return 0;
> > > +	return max_optlen;
> > >  }
> > >
> > >  static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
> > > @@ -1319,13 +1326,13 @@ int __cgroup_bpf_run_filter_setsockopt(struct
> > sock *sk, int *level,
> > >  	 */
> > >  	max_optlen = max_t(int, 16, *optlen);
> > >
> > > -	ret = sockopt_alloc_buf(&ctx, max_optlen);
> > > -	if (ret)
> > > -		return ret;
> > > +	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
> > > +	if (max_optlen < 0)
> > > +		return max_optlen;
> > >
> > >  	ctx.optlen = *optlen;
> > >
> > > -	if (copy_from_user(ctx.optval, optval, *optlen) != 0) {
> > > +	if (copy_from_user(ctx.optval, optval, min(*optlen, max_optlen)) !=
> > 0) {
> > >  		ret = -EFAULT;
> > >  		goto out;
> > >  	}
> > > @@ -1353,8 +1360,14 @@ int __cgroup_bpf_run_filter_setsockopt(struct
> > sock *sk, int *level,
> > >  		/* export any potential modifications */
> > >  		*level = ctx.level;
> > >  		*optname = ctx.optname;
> > > -		*optlen = ctx.optlen;
> > > -		*kernel_optval = ctx.optval;
> > > +
> > > +		/* optlen == 0 from BPF indicates that we should
> > > +		 * use original userspace data.
> > > +		 */
> > > +		if (ctx.optlen != 0) {
> > > +			*optlen = ctx.optlen;
> 
> > I think it should be:
> > *optlen = min(ctx.optlen, max_optlen);
> We do have the following (existing) check above:
> 	} else if (ctx.optlen > max_optlen || ctx.optlen < -1) {
> 		/* optlen is out of bounds */
> 		ret = -EFAULT;
> 	} else {
> 
> So we shouldn't need any min here? Or am I missing something?

ahh. you're right.
Applied to bpf tree.

> > Otherwise when bpf prog doesn't adjust ctx.oplen the kernel will see
> > 4k only in kernel_optval whereas optlen will be > 4k.
> > I suspect iptables sockopt should have crashed at this point.
> > How did you test it?
> The selftests that I've attached in the series. The test is passing
> two pages and for IP_TOS we bypass the value via optlen=0 and
> for IP_FREEBIND we trim the buffer to 1 byte. I think this should
> cover this check here.
> 
> One thing I didn't really test is getsockopt when the kernel
> returns really large buffer (iptables). Right now, the test
> gets 4 bytes (trimmed) from the kernel. I think that's the only
> place that I didn't properly test. I wonder whether I should
> do a real iptables-like setsockopt/getsockopt :-/

would be nice :)
