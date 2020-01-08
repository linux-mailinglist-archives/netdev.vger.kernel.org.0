Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A04134D0F
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgAHUUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:20:47 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37461 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgAHUUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:20:47 -0500
Received: by mail-pj1-f65.google.com with SMTP id m13so103746pjb.2;
        Wed, 08 Jan 2020 12:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aeyJoba8uJ+DuqzxagZ15T2uRzxkV/DOR+oSEvEwDi0=;
        b=Y/RSOi2+vqeiPrZ+a0lHXl/z4ydSo1x+iPCD6R51fgyk7qGSUQjuFv+9x7DVZaosyo
         kC9PVByQP0XdI83G/Q7uHPfnBzxJU76yu8KozwXDRTDebumJ3kBmfVzHqhrDC46HKw+K
         BZeDwcjNsENgv67eAvbzYKHRjsgvUdEphrRwBkOV3Syt6jHio/COD6ZBhGUSm6yxnugc
         s6EIUXji/ha9YV6P4cwKDH8YmnFocHlnrW8ZUNiVB1Ah6pju6Tfra+tKvvjqlTJymW2y
         y4BILGYxFkXbl4MEdL3DVlOj3fqK8YWKYgnIOCe+Uu8/TPwrsrop85YD/06lWDex4jxV
         pwCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aeyJoba8uJ+DuqzxagZ15T2uRzxkV/DOR+oSEvEwDi0=;
        b=Jsytt8iG4eEOIf8a3aDvFaE6RL9ptNe5j0vzk3Bc0zPdcfr5UbqcikVymTUEFWrLHz
         6QVLPVC4ahutyRfLvFoKOyYVLW8MSClNHhOgo1qev0S9EjwZYkNS6D24fqRFNFw30MAT
         +smSSnLEuww/21dMtiybwejyu3mmHtQpfMgRlqpYl4Bs3btkiy+nFXqsGgOP8LWo7wG5
         ZUu4OkOszde1tLRGOVuydkjrTbaF+wHrXzWsTmXHjdcX99cll/Cmd4WPYTZ4YGjXeqqG
         0FTcUqAQFn1w/Dc6ndUDruk0U2VQ8bqnRe00yCW2UdhND9O8QujcfCHad7tCV47Oh4QQ
         G8uw==
X-Gm-Message-State: APjAAAUx2G6fjSY4Scg/cY0e+Hc7BzFe43h9GirTiJT0u8CvpD0wiGk3
        7TmExqntSgoRHWyn3wll9aw=
X-Google-Smtp-Source: APXvYqyuFE6wfN8uogNqwaovQuoUK6ixP9f6X30h8BcnssDgiqFRp/04a+LgnMVGyuql4CiwAJVGDA==
X-Received: by 2002:a17:902:ac90:: with SMTP id h16mr6900632plr.164.1578514846221;
        Wed, 08 Jan 2020 12:20:46 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::3:1e54])
        by smtp.gmail.com with ESMTPSA id l2sm118372pjt.31.2020.01.08.12.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 12:20:45 -0800 (PST)
Date:   Wed, 8 Jan 2020 12:20:44 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/6] bpf: Introduce function-by-function
 verification
Message-ID: <20200108202043.bo6sdqe5i7lttgvp@ast-mbp>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-4-ast@kernel.org>
 <2A66F154-7F54-4856-B6ED-E787EE215631@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2A66F154-7F54-4856-B6ED-E787EE215631@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 07:10:59PM +0000, Song Liu wrote:
> 
> 
> > On Jan 7, 2020, at 11:25 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> > 
> > New llvm and old llvm with libbpf help produce BTF that distinguish global and
> > static functions. Unlike arguments of static function the arguments of global
> > functions cannot be removed or optimized away by llvm. The compiler has to use
> > exactly the arguments specified in a function prototype. The argument type
> > information allows the verifier validate each global function independently.
> > For now only supported argument types are pointer to context and scalars. In
> > the future pointers to structures, sizes, pointer to packet data can be
> > supported as well. Consider the following example:
> 
> [...]
> 
> > The type information and static/global kind is preserved after the verification
> > hence in the above example global function f2() and f3() can be replaced later
> > by equivalent functions with the same types that are loaded and verified later
> > without affecting safety of this main() program. Such replacement (re-linking)
> > of global functions is a subject of future patches.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> > include/linux/bpf.h          |   7 +-
> > include/linux/bpf_verifier.h |   7 +-
> > include/uapi/linux/btf.h     |   6 +
> > kernel/bpf/btf.c             | 147 +++++++++++++++++-----
> > kernel/bpf/verifier.c        | 228 +++++++++++++++++++++++++++--------
> > 5 files changed, 317 insertions(+), 78 deletions(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index b14e51d56a82..ceb5b6c13abc 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -558,6 +558,7 @@ static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
> > #endif
> > 
> > struct bpf_func_info_aux {
> > +	u32 linkage;
> 
> How about we use u16 or even u8 for linkage? We are using BTF_INFO_VLEN() which 
> is 16-bit long. Maybe we should save some bits for future extensions?

sure. u16 is fine.
Will also introduce btf_func_kind() helper to avoid misleading BTF_INFO_VLEN macro.

> > -int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog)
> > +/* Compare BTF of a function with given bpf_reg_state */
> > +int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
> > +			     struct bpf_reg_state *reg)
> 
> I think we need more comments for the retval of btf_check_func_arg_match().

sure.

> > {
> > -	struct bpf_verifier_state *st = env->cur_state;
> > -	struct bpf_func_state *func = st->frame[st->curframe];
> > -	struct bpf_reg_state *reg = func->regs;
> > 	struct bpf_verifier_log *log = &env->log;
> > 	struct bpf_prog *prog = env->prog;
> > 	struct btf *btf = prog->aux->btf;
> [...]
> > +
> > +/* Convert BTF of a function into bpf_reg_state if possible */
> > +int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
> > +			  struct bpf_reg_state *reg)
> > +{
> > +	struct bpf_verifier_log *log = &env->log;
> > +	struct bpf_prog *prog = env->prog;
> > +	struct btf *btf = prog->aux->btf;
> > +	const struct btf_param *args;
> > +	const struct btf_type *t;
> > +	u32 i, nargs, btf_id;
> > +	const char *tname;
> > +
> > +	if (!prog->aux->func_info ||
> > +	    prog->aux->func_info_aux[subprog].linkage != BTF_FUNC_GLOBAL) {
> > +		bpf_log(log, "Verifier bug\n");
> 
> IIUC, this should never happen? Maybe we need more details in the log, and 
> maybe also WARN_ONCE()?

Should never happen and I think it's pretty clear from the diff, since
this function is called after == FUNC_GLOBAL check in the caller.
I didn't add WARN to avoid wasting .text even more here.
Single 'if' above already feels a bit overly defensive.
It's not like other cases in the verifier where we have WARN_ONCE.
Those are for complex things. Here it's one callsite and trivial control flow.

> > +	if (prog->aux->func_info_aux[subprog].unreliable) {
> > +		bpf_log(log, "Verifier bug in function %s()\n", tname);
> > +		return -EFAULT;
> 
> Why -EFAULT instead of -EINVAL? I think we treat them the same? 

EFAULT is a verifier bug like in all other places in the verifier
where EFAULT is returned. EINVAL is normal error.
