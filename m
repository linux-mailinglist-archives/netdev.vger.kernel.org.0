Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED9B1437BC
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 08:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgAUHgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 02:36:52 -0500
Received: from mail-il1-f178.google.com ([209.85.166.178]:41218 "EHLO
        mail-il1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgAUHgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 02:36:52 -0500
Received: by mail-il1-f178.google.com with SMTP id f10so1588505ils.8;
        Mon, 20 Jan 2020 23:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=lp58E/8stuhXM5/3F8Nh67g/n/xCRI1N+d2OSBx51qM=;
        b=rSL34f+CneD77G6ycLuZe73FFpbS7l4lQFAzIe1HQRGYCQskSIdPTXRUzKu26W6u3O
         5xAUH+zxWqy9boy1kbqjoGqbd9+oa5OP4fsvDtcUqDDIHgweohQN+XdlEbLGXbW1xaYU
         KdIpSoXF8/gHtOsbmUkTJd22405ww5F4yFWNaV+0ucY0P1jAuRHjnhBfSXle7CQ1DkIB
         n8bUOc4qU/4km9O5VzuxB1hDa8aO4QwUCqB/oKqEyx+UoIBQ0I8UZ7g1HtxZJI9k1EoR
         E2bqY+lKKhuPsvzGxlsJc97IW+FGTEDhyZfgW0wAG0HetlKrMb810hd2XmdEML3qEMQ4
         tqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=lp58E/8stuhXM5/3F8Nh67g/n/xCRI1N+d2OSBx51qM=;
        b=Tin7k9R+zWa07URvqAcKhrHFujZT5wSL8Xd1BCuwEIPDib4rqovxSsh2npwYGAS7+S
         ytzb0wOJyIxejJNVMq5X9Rsy5X1fQsDe34U8n4N4duTJuLkyNooVvZ2kSZ2PnUERyrnB
         dhogd8RmH8uALci/C8v8S15aSo1pmQYFMpI4l5e0NivpKM5iQw0Wxt0B14VFX3tVC+LY
         oYc3Ul6jwBgCN78fGlkskcsIhwYdPrpN1QIG/WMk/1zZKS1iXrsAxnANYQjit24wZXab
         RzZYoSw2hUBoZoTlyYpbAbo9a4BmblCPaLa5Z8IFZrfF85czcQ0Wl64PkH020cUTGYXT
         8CBg==
X-Gm-Message-State: APjAAAVOw2A4HROn7Um2AxqNR/pkwrhdQ7bdks5AjjmXpvebJMHW8Ghs
        +L1CRgqe5neAcWXbcFtDQEM=
X-Google-Smtp-Source: APXvYqxki1Hr4pE2upWWMfUOhH8OsIPpKh503+YGa4LlY4q+b3QGFdixTc9X9W2u5cu41CBt6mFQfQ==
X-Received: by 2002:a92:5d16:: with SMTP id r22mr2677517ilb.230.1579592211364;
        Mon, 20 Jan 2020 23:36:51 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k78sm12766969ila.80.2020.01.20.23.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 23:36:50 -0800 (PST)
Date:   Mon, 20 Jan 2020 23:36:43 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5e26aa0bc382b_32772acafb17c5b410@john-XPS-13-9370.notmuch>
In-Reply-To: <20200121005348.2769920-2-ast@kernel.org>
References: <20200121005348.2769920-1-ast@kernel.org>
 <20200121005348.2769920-2-ast@kernel.org>
Subject: RE: [PATCH v2 bpf-next 1/3] bpf: Introduce dynamic program extensions
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> Introduce dynamic program extensions. The users can load additional BPF
> functions and replace global functions in previously loaded BPF programs while
> these programs are executing.
> 
> Global functions are verified individually by the verifier based on their types only.
> Hence the global function in the new program which types match older function can
> safely replace that corresponding function.
> 
> This new function/program is called 'an extension' of old program. At load time
> the verifier uses (attach_prog_fd, attach_btf_id) pair to identify the function
> to be replaced. The BPF program type is derived from the target program into
> extension program. Technically bpf_verifier_ops is copied from target program.
> The BPF_PROG_TYPE_EXT program type is a placeholder. It has empty verifier_ops.
> The extension program can call the same bpf helper functions as target program.
> Single BPF_PROG_TYPE_EXT type is used to extend XDP, SKB and all other program
> types. The verifier allows only one level of replacement. Meaning that the
> extension program cannot recursively extend an extension. That also means that
> the maximum stack size is increasing from 512 to 1024 bytes and maximum
> function nesting level from 8 to 16. The programs don't always consume that
> much. The stack usage is determined by the number of on-stack variables used by
> the program. The verifier could have enforced 512 limit for combined original
> plus extension program, but it makes for difficult user experience. The main
> use case for extensions is to provide generic mechanism to plug external
> programs into policy program or function call chaining.
> 
> BPF trampoline is used to track both fentry/fexit and program extensions
> because both are using the same nop slot at the beginning of every BPF
> function. Attaching fentry/fexit to a function that was replaced is not
> allowed. The opposite is true as well. Replacing a function that currently
> being analyzed with fentry/fexit is not allowed. The executable page allocated
> by BPF trampoline is not used by program extensions. This inefficiency will be
> optimized in future patches.
> 
> Function by function verification of global function supports scalars and
> pointer to context only. Hence program extensions are supported for such class
> of global functions only. In the future the verifier will be extended with
> support to pointers to structures, arrays with sizes, etc.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

[...]

> +
> +	t1 = btf_type_skip_modifiers(btf1, t1->type, NULL);
> +	t2 = btf_type_skip_modifiers(btf2, t2->type, NULL);

Is it really best to skip modifiers? I would expect that if the
signature is different including modifiers then we should just reject it.
OTOH its not really C code here either so modifiers may not have the same
meaning. With just integers and struct it may be ok but if we add pointers
to ints then what would we expect from a const int*?

So whats the reasoning for skipping modifiers? Is it purely an argument
that its not required for safety so solve it elsewhere? In that case then
checking names of functions is also equally not required.

Otherwise LGTM.


> +	if (t1->info != t2->info) {
> +		bpf_log(log,
> +			"Return type %s of %s() doesn't match type %s of %s()\n",
> +			btf_type_str(t1), fn1,
> +			btf_type_str(t2), fn2);
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < nargs1; i++) {
> +		t1 = btf_type_skip_modifiers(btf1, args1[i].type, NULL);
> +		t2 = btf_type_skip_modifiers(btf2, args2[i].type, NULL);
> +
> +		if (t1->info != t2->info) {
> +			bpf_log(log, "arg%d in %s() is %s while %s() has %s\n",
> +				i, fn1, btf_type_str(t1),
> +				fn2, btf_type_str(t2));
> +			return -EINVAL;
> +		}
> +		if (btf_type_has_size(t1) && t1->size != t2->size) {
> +			bpf_log(log,
> +				"arg%d in %s() has size %d while %s() has %d\n",
> +				i, fn1, t1->size,
> +				fn2, t2->size);
> +			return -EINVAL;
> +		}
> +
> +		/* global functions are validated with scalars and pointers
> +		 * to context only. And only global functions can be replaced.
> +		 * Hence type check only those types.
> +		 */
> +		if (btf_type_is_int(t1) || btf_type_is_enum(t1))
> +			continue;
> +		if (!btf_type_is_ptr(t1)) {
> +			bpf_log(log,
> +				"arg%d in %s() has unrecognized type\n",
> +				i, fn1);
> +			return -EINVAL;
> +		}
> +		t1 = btf_type_skip_modifiers(btf1, t1->type, NULL);
> +		t2 = btf_type_skip_modifiers(btf2, t2->type, NULL);
> +		if (!btf_type_is_struct(t1)) {
> +			bpf_log(log,
> +				"arg%d in %s() is not a pointer to context\n",
> +				i, fn1);
> +			return -EINVAL;
> +		}
> +		if (!btf_type_is_struct(t2)) {
> +			bpf_log(log,
> +				"arg%d in %s() is not a pointer to context\n",
> +				i, fn2);
> +			return -EINVAL;
> +		}
> +		/* This is an optional check to make program writing easier.
> +		 * Compare names of structs and report an error to the user.
> +		 * btf_prepare_func_args() already checked that t2 struct
> +		 * is a context type. btf_prepare_func_args() will check
> +		 * later that t1 struct is a context type as well.
> +		 */
> +		s1 = btf_name_by_offset(btf1, t1->name_off);
> +		s2 = btf_name_by_offset(btf2, t2->name_off);
> +		if (strcmp(s1, s2)) {
> +			bpf_log(log,
> +				"arg%d %s(struct %s *) doesn't match %s(struct %s *)\n",
> +				i, fn1, s1, fn2, s2);
> +			return -EINVAL;
> +		}
> +	}
> +	return 0;
> +}
