Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D83844EE9
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 00:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbfFMWA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 18:00:58 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38273 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfFMWA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 18:00:57 -0400
Received: by mail-pf1-f195.google.com with SMTP id a186so95570pfa.5;
        Thu, 13 Jun 2019 15:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o0Xxr326HdVBxJMQJ7yuDvuInC+0DtTaN16E8H3a2bk=;
        b=iwg9vvI8CIMUZnifphfNAi7MMdiXb5tLze1Wjdtzn7ptvajN7YJIN73rJAnv2SrorO
         jaB81fzQaDK+JMuvGQwsEE4jwIY44z/DGTKqHsx1Kk/FS9iP+UWfZMMBxHTRuP8CxTpv
         lE2+2k9L/W9bUVM85tyuyWEiDqRKBGK360DmIiwCIMI03BRlU/cATpcM5f3pZFwONuJG
         +ECxR2b/P1pdEt88fbls+/HzpMYKTj6mRovaUUUBvLBgzOv5x8mAEGF7A6fKy964hfVf
         o6Nkds204NQYzmDXEZSD927Lq0tTL+Rk8JstUF21VPd7LrycvbiyHEYwZ81t0J47QGr/
         9Upg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o0Xxr326HdVBxJMQJ7yuDvuInC+0DtTaN16E8H3a2bk=;
        b=FqMKztGuUftCBfuks53GPnwMQDNYPsvqfdyR0p25JyET5RA/XH3NCyskIC87SNLlJN
         iXrIBKBchbiqzg1Yn6i+/PbVyG73tidckRgfCP+CxwoS3+fzjWyxc8HT6VBzg40doTOQ
         JbnanzHlVZt1saEkPQYXAPSuVj59KyBHlrbh++rnrYzfO4VNrqT5e6LuEQuLYJDeBKpP
         vYmkGwm57eLHYFAdT2lwjGUQmEScPIK5cSIw/qPuU8NHVZOOjAnxsgIs/lyylfpbwtOR
         OTMnXQCl7m3YLZj9sbmk8f/UNr7czFJgOQrpWrJ6/QkeVD5hcAI0/6lflzzc1+s120iJ
         5F6w==
X-Gm-Message-State: APjAAAUpzARKrZr5wKItpaFWL2XpAODXi5IT35DyrDbGbkzeEeLx05v2
        NfRzxjZiuU9g8N/vVqc7/OA=
X-Google-Smtp-Source: APXvYqwyywNqJkHJDH2mvO+bvRmgBxFaFgJmncdf/zEQvCUIGwjF1LxvkA+ZwyfyqgkYoFfmqTWUOw==
X-Received: by 2002:a62:82c2:: with SMTP id w185mr75108171pfd.202.1560463257135;
        Thu, 13 Jun 2019 15:00:57 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:e034])
        by smtp.gmail.com with ESMTPSA id g8sm723759pgd.29.2019.06.13.15.00.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 15:00:56 -0700 (PDT)
Date:   Thu, 13 Jun 2019 15:00:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers
 for generated code
Message-ID: <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:21:04AM -0500, Josh Poimboeuf wrote:
> The ORC unwinder can't unwind through BPF JIT generated code because
> there are no ORC entries associated with the code.
> 
> If an ORC entry isn't available, try to fall back to frame pointers.  If
> BPF and other generated code always do frame pointer setup (even with
> CONFIG_FRAME_POINTERS=n) then this will allow ORC to unwind through most
> generated code despite there being no corresponding ORC entries.
> 
> Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> Reported-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  arch/x86/kernel/unwind_orc.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
> index 33b66b5c5aec..72b997eaa1fc 100644
> --- a/arch/x86/kernel/unwind_orc.c
> +++ b/arch/x86/kernel/unwind_orc.c
> @@ -82,9 +82,9 @@ static struct orc_entry *orc_find(unsigned long ip);
>   * But they are copies of the ftrace entries that are static and
>   * defined in ftrace_*.S, which do have orc entries.
>   *
> - * If the undwinder comes across a ftrace trampoline, then find the
> + * If the unwinder comes across a ftrace trampoline, then find the
>   * ftrace function that was used to create it, and use that ftrace
> - * function's orc entrie, as the placement of the return code in
> + * function's orc entry, as the placement of the return code in
>   * the stack will be identical.
>   */
>  static struct orc_entry *orc_ftrace_find(unsigned long ip)
> @@ -128,6 +128,16 @@ static struct orc_entry null_orc_entry = {
>  	.type = ORC_TYPE_CALL
>  };
>  
> +/* Fake frame pointer entry -- used as a fallback for generated code */
> +static struct orc_entry orc_fp_entry = {
> +	.type		= ORC_TYPE_CALL,
> +	.sp_reg		= ORC_REG_BP,
> +	.sp_offset	= 16,
> +	.bp_reg		= ORC_REG_PREV_SP,
> +	.bp_offset	= -16,
> +	.end		= 0,
> +};
> +
>  static struct orc_entry *orc_find(unsigned long ip)
>  {
>  	static struct orc_entry *orc;
> @@ -392,8 +402,16 @@ bool unwind_next_frame(struct unwind_state *state)
>  	 * calls and calls to noreturn functions.
>  	 */
>  	orc = orc_find(state->signal ? state->ip : state->ip - 1);
> -	if (!orc)
> -		goto err;
> +	if (!orc) {
> +		/*
> +		 * As a fallback, try to assume this code uses a frame pointer.
> +		 * This is useful for generated code, like BPF, which ORC
> +		 * doesn't know about.  This is just a guess, so the rest of
> +		 * the unwind is no longer considered reliable.
> +		 */
> +		orc = &orc_fp_entry;
> +		state->error = true;

That seems fragile.
Can't we populate orc_unwind tables after JIT ?

