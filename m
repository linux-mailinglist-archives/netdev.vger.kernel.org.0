Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4611C4C1A0D
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243449AbiBWRpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243436AbiBWRpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:45:05 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DA241334;
        Wed, 23 Feb 2022 09:44:37 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id r13so30979629ejd.5;
        Wed, 23 Feb 2022 09:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zltyPlxW3uDjVlzYzIgB3L+AcBjct0C7Tq5+1WnfdfA=;
        b=MtL9zxsAt5x8IvEGyjWYZzL7bO2nEo7tbm4EPwvey0Od7Qeyny+KlyEtLYAYnCFAOo
         IwsMc0QKTjRIdxwVUClWJT4KmDm3p44THHMXBcIuRX4btcVlNgyeeEP5BcFisGQ5kEz3
         /Ij3ZlCgTAHJSyWo96klCsI9AfWVhyTzFBIPApiGy7BiErsisOuO3E42zPBoIW2aQORv
         +PSThX5C2dl9Cr2rVVG/nUKjccqI6BcNeWP2MlCFGUp3v4VtR/FJBx4YFQe5Ef6CPdAH
         jA29k3g695S5sUSgsIUXRxEQsDpLYoCUSQ07z+1Z5xVWcdPHaBza3luRLdSklXNr+ea7
         XxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zltyPlxW3uDjVlzYzIgB3L+AcBjct0C7Tq5+1WnfdfA=;
        b=0phdmWKBAzoq1j7629JEEXx6LbBtAeFjJ6YYSYycTLZBHb2cc1qyTPN3uMOd/6OqVT
         ao5nVRgbGX7kwp7F6BJreL3cghjUNwh+G86iMb9V551mKDtZyjMIDnPyyXpqA3Bv7T5X
         7cqVPe/r0VLvZpy3f2SyGTxWPUvP4IFzY8kKGf2kN7XZTO+yJMH8M99lxKWdj75DSW3q
         jNWXDG3LnNYuAcyxUJFQLgcE6h5Lf8BSDwBbV8KxPQNkVhjZX5aVkmJjr6aKcSAqVA/W
         Sd6r/PZLaMmTFRaxfE6uyABHL40T9h7Mix2daITvrrs/oe7mP6R8Y0/7chi9mF9Nf8fp
         yL/Q==
X-Gm-Message-State: AOAM530cyo0Q/NVPMLfDVlLTw86q5m9qu6mQm1q7TYY8tJrvw9XRG/9d
        DEDb1r71IQTI2lbH/of62cI=
X-Google-Smtp-Source: ABdhPJwLpI4uj3x+MhFJtBONe9+bf12BVfOHGoZcMd1saToiRSokzyqCBoS52vq5G3Bkf53sbIrJug==
X-Received: by 2002:a17:906:4313:b0:6b8:b3e5:a46 with SMTP id j19-20020a170906431300b006b8b3e50a46mr618427ejm.417.1645638275698;
        Wed, 23 Feb 2022 09:44:35 -0800 (PST)
Received: from krava (ip-89-102-25-98.net.upcbroadband.cz. [89.102.25.98])
        by smtp.gmail.com with ESMTPSA id m18sm130578eje.145.2022.02.23.09.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 09:44:35 -0800 (PST)
Date:   Wed, 23 Feb 2022 18:44:33 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 02/10] bpf: Add multi kprobe link
Message-ID: <YhZygR9AMtJmo1mJ@krava>
References: <20220222170600.611515-1-jolsa@kernel.org>
 <20220222170600.611515-3-jolsa@kernel.org>
 <20220223145840.64f708ed2357c89039f55f07@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223145840.64f708ed2357c89039f55f07@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 02:58:40PM +0900, Masami Hiramatsu wrote:
> Hi Jiri,
> 
> On Tue, 22 Feb 2022 18:05:52 +0100
> Jiri Olsa <jolsa@kernel.org> wrote:
> 
> [snip]
> > +
> > +static void
> > +kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
> > +			  struct pt_regs *regs)
> > +{
> > +	unsigned long saved_ip = instruction_pointer(regs);
> > +	struct bpf_kprobe_multi_link *link;
> > +
> > +	/*
> > +	 * Because fprobe's regs->ip is set to the next instruction of
> > +	 * dynamic-ftrace instruction, correct entry ip must be set, so
> > +	 * that the bpf program can access entry address via regs as same
> > +	 * as kprobes.
> > +	 */
> > +	instruction_pointer_set(regs, entry_ip);
> 
> This is true for the entry_handler, but false for the exit_handler,
> because entry_ip points the probed function address, not the
> return address. Thus, when this is done in the exit_handler,
> the bpf prog seems to be called from the entry of the function,
> not return.
> 
> If it is what you expected, please explictly comment it to
> avoid confusion. Or, make another handler function for exit
> probing.

yes we want the ip of the function we are tracing, so it's correct,
I'll adjust the comment

> 
> > +
> > +	link = container_of(fp, struct bpf_kprobe_multi_link, fp);
> > +	kprobe_multi_link_prog_run(link, regs);
> > +
> > +	instruction_pointer_set(regs, saved_ip);
> > +}
> > +
> > +static int
> > +kprobe_multi_resolve_syms(const void *usyms, u32 cnt,
> > +			  unsigned long *addrs)
> > +{
> > +	unsigned long addr, size;
> > +	const char **syms;
> > +	int err = -ENOMEM;
> > +	unsigned int i;
> > +	char *func;
> > +
> > +	size = cnt * sizeof(*syms);
> > +	syms = kvzalloc(size, GFP_KERNEL);
> > +	if (!syms)
> > +		return -ENOMEM;
> > +
> > +	func = kmalloc(KSYM_NAME_LEN, GFP_KERNEL);
> > +	if (!func)
> > +		goto error;
> > +
> > +	if (copy_from_user(syms, usyms, size)) {
> > +		err = -EFAULT;
> > +		goto error;
> > +	}
> > +
> > +	for (i = 0; i < cnt; i++) {
> > +		err = strncpy_from_user(func, syms[i], KSYM_NAME_LEN);
> > +		if (err == KSYM_NAME_LEN)
> > +			err = -E2BIG;
> > +		if (err < 0)
> > +			goto error;
> > +
> > +		err = -EINVAL;
> > +		if (func[0] == '\0')
> > +			goto error;
> > +		addr = kallsyms_lookup_name(func);
> > +		if (!addr)
> > +			goto error;
> > +		if (!kallsyms_lookup_size_offset(addr, &size, NULL))
> > +			size = MCOUNT_INSN_SIZE;
> 
> Note that this is good for x86, but may not be good for other arch
> which use some preparation instructions before mcount call.  Maybe you
> can just reject it if kallsyms_lookup_size_offset() fails.

I 'borrowed' this from fprobe's get_ftrace_locations function,
and it still seems to match.. do you plan to change that?

thanks,
jirka
