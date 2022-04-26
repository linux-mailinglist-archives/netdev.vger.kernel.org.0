Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCCD510282
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346321AbiDZQHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237871AbiDZQHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:07:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA91434AA;
        Tue, 26 Apr 2022 09:04:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3EFA61A59;
        Tue, 26 Apr 2022 16:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94823C385AA;
        Tue, 26 Apr 2022 16:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650989045;
        bh=69jqnS80ls4U/ADxnP7PEc7prC9IyzE3eMxJZnp7tAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OF7ff69aH9WhWwYQqzv8Ol92hHSgQ1EBu3+vmSaVHUEhT5CXy6BJoKpnIuYAhOrt8
         W1+kix+7UbGMbEfZgWHap4qIKIRg2Ye6XkwFsUB7ytq8MkxS6U4QjlimKB3EUaL4Tl
         lG+o75zjCy5+kHsfpGM/hBJukTZGFs1jaomfDgYBY1Kv33I3gF4Y/h2hmu16YG4tOI
         kHd3BWsSDlq/XDUcjLKqULgQd/YhY8S2ZqFQGnW6NepUoyoYTx17eDXhJL7t6mPl//
         V69PmgBM9PsxdttsmpNYPouZkSizbbwh7Uo5h5cBqpGePVXkk9IKXAYus5nAM8w29n
         A7gpRf/DVOB8Q==
Date:   Wed, 27 Apr 2022 01:03:59 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv2 bpf-next 1/4] kallsyms: Add kallsyms_lookup_names
 function
Message-Id: <20220427010359.8400f28813c1ffc62af2ae2b@kernel.org>
In-Reply-To: <YmflGEbjkp8mynxK@krava>
References: <20220418124834.829064-1-jolsa@kernel.org>
        <20220418124834.829064-2-jolsa@kernel.org>
        <20220418233546.dfe0a1be12193c26b05cdd93@kernel.org>
        <Yl5yHVOJpCYr+T3r@krava>
        <YmJPcU9dahEatb0f@krava>
        <20220426190108.d9c76f5ccff52e27dbef21af@kernel.org>
        <YmflGEbjkp8mynxK@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 14:27:04 +0200
Jiri Olsa <olsajiri@gmail.com> wrote:

> On Tue, Apr 26, 2022 at 07:01:08PM +0900, Masami Hiramatsu wrote:
> > Hi Jiri,
> > 
> > Sorry for replying late.
> > 
> > On Fri, 22 Apr 2022 08:47:13 +0200
> > Jiri Olsa <olsajiri@gmail.com> wrote:
> > 
> > > On Tue, Apr 19, 2022 at 10:26:05AM +0200, Jiri Olsa wrote:
> > > 
> > > SNIP
> > > 
> > > > > > +static int kallsyms_callback(void *data, const char *name,
> > > > > > +			     struct module *mod, unsigned long addr)
> > > > > > +{
> > > > > > +	struct kallsyms_data *args = data;
> > > > > > +
> > > > > > +	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > > > > > +		return 0;
> > > > > > +
> > > > > > +	addr = ftrace_location(addr);
> > > > > > +	if (!addr)
> > > > > > +		return 0;
> > > > > 
> > > > > Ooops, wait. Did you do this last version? I missed this point.
> > > > > This changes the meanings of the kernel function.
> > > > 
> > > > yes, it was there before ;-) and you're right.. so some archs can
> > > > return different address, I did not realize that
> > > > 
> > > > > 
> > > > > > +
> > > > > > +	args->addrs[args->found++] = addr;
> > > > > > +	return args->found == args->cnt ? 1 : 0;
> > > > > > +}
> > > > > > +
> > > > > > +/**
> > > > > > + * kallsyms_lookup_names - Lookup addresses for array of symbols
> > > > > 
> > > > > More correctly "Lookup 'ftraced' addresses for array of sorted symbols", right?
> > > > > 
> > > > > I'm not sure, we can call it as a 'kallsyms' API, since this is using
> > > > > kallsyms but doesn't return symbol address, but ftrace address.
> > > > > I think this name misleads user to expect returning symbol address.
> > > > > 
> > > > > > + *
> > > > > > + * @syms: array of symbols pointers symbols to resolve, must be
> > > > > > + * alphabetically sorted
> > > > > > + * @cnt: number of symbols/addresses in @syms/@addrs arrays
> > > > > > + * @addrs: array for storing resulting addresses
> > > > > > + *
> > > > > > + * This function looks up addresses for array of symbols provided in
> > > > > > + * @syms array (must be alphabetically sorted) and stores them in
> > > > > > + * @addrs array, which needs to be big enough to store at least @cnt
> > > > > > + * addresses.
> > > > > 
> > > > > Hmm, sorry I changed my mind. I rather like to expose kallsyms_on_each_symbol()
> > > > > and provide this API from fprobe or ftrace, because this returns ftrace address
> > > > > and thus this is only used from fprobe.
> > > > 
> > > > ok, so how about:
> > > > 
> > > >   int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs);
> > > 
> > > quick question.. is it ok if it stays in kalsyms.c object?
> > 
> > I think if this is for the ftrace API, I think it should be in the ftrace.c, and
> > it can remove unneeded #ifdefs in C code.
> > 
> > > 
> > > so we don't need to expose kallsyms_on_each_symbol,
> > > and it stays in 'kalsyms' place
> > 
> > We don't need to expose it to modules, but just make it into a global scope.
> > I don't think that doesn't cause a problem.

Oops, I meant "I don't think that cause any problem."

> 
> np, will move it to ftrace

Thank you!

> 
> thanks,
> jirka


-- 
Masami Hiramatsu <mhiramat@kernel.org>
