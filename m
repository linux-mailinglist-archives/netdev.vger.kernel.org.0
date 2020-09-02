Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E474E25A51A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 07:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIBFgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 01:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgIBFgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 01:36:33 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F92C061244;
        Tue,  1 Sep 2020 22:36:32 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p37so1972899pgl.3;
        Tue, 01 Sep 2020 22:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y/8U/CT9/01AQUynESCz7Y0aSM2GVmWg7zOjg/tdq7U=;
        b=fG3S69rb3WHtLQobW0xa+qNkyydz25/VCM5qG3MwRpBBRSxqJ27iVzIuEMPm4r964z
         26Loafz6GNJh1e/bcLijW/NKyWiggaTjJcyWznsXdthP9KHIVvViDCFLTObNSZzYzAoN
         cQe3RtAtSimt0LV+TE98xEO3MWjzb5Yb8Bv1TiplkGR2+E9SH/OiGqW8T6MAJneaysCb
         vaC4BHIoMMiQdEngbI5NxYvLeQbxOVaQCwzhxra40bIxN/r0gkXohBH6COyaXHujFPKU
         MbPy5ckhA/xUv0pzSE7b9QP9SgMnaBccCjvJrvIw6PAUbEvHc/mi42WUieZAYy/lxfQB
         Hz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y/8U/CT9/01AQUynESCz7Y0aSM2GVmWg7zOjg/tdq7U=;
        b=d02azH8va8VwsGjbf1w30+MQ0V4Pw1G4x9TDYNdAqu5UF7OLBWd0CYe/BYL2n3RUuj
         9tyt4Bbp2bWbYgeTL/xhRT0ORzLz5d4oxacJoS/ofmao7qRmnOxV6ZwUN4WYnoBhLNKp
         nHAgFa90PKtklTgEEbMmz4X+1n26McbjZ09DRSqwbw4b9MyrbVieoNy78FR4wyuW7wB2
         BfNz7rT0rBAuogc9tX5+bDRb5MnLgpSi+yLGOEIobXaRZ/tP1GLpkvJGsxqaWi2nZBZi
         Vknx8anvjn0+8+xTIDnu81E8CpPJK4dqahcHlghIZxpc+zqhQcKcsvsYXhNmkhK7yzsm
         +OqA==
X-Gm-Message-State: AOAM530BGEXzAP4jei2P5QjEHA5+UqnUUzIpqaNSpVcG29rPvtbpCkxf
        tPiOvB3MR195QwI3mou5meY=
X-Google-Smtp-Source: ABdhPJz5neJCCGMApGUiH1XZxrAjzth80Dv3hBZFOky3m/nswcQgh3oGQsYcQH1AaJJAuFrIVFKeXA==
X-Received: by 2002:a63:c948:: with SMTP id y8mr691368pgg.164.1599024991600;
        Tue, 01 Sep 2020 22:36:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:c38b])
        by smtp.gmail.com with ESMTPSA id n2sm3994448pfa.182.2020.09.01.22.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 22:36:30 -0700 (PDT)
Date:   Tue, 1 Sep 2020 22:36:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 04/14] libbpf: make RELO_CALL work for
 multi-prog sections and sub-program calls
Message-ID: <20200902053628.bqqytnpebrum7heh@ast-mbp.dhcp.thefacebook.com>
References: <20200901015003.2871861-1-andriin@fb.com>
 <20200901015003.2871861-5-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901015003.2871861-5-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 06:49:53PM -0700, Andrii Nakryiko wrote:
> +
> +static int
> +bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
> +		       struct bpf_program *prog)
> +{
> +	size_t sub_insn_idx, insn_idx, new_cnt;
> +	struct bpf_program *subprog;
> +	struct bpf_insn *insns, *insn;
> +	struct reloc_desc *relo;
> +	int err;
> +
> +	err = reloc_prog_func_and_line_info(obj, main_prog, prog);
> +	if (err)
> +		return err;
> +
> +	for (insn_idx = 0; insn_idx < prog->sec_insn_cnt; insn_idx++) {
> +		insn = &main_prog->insns[prog->sub_insn_off + insn_idx];
> +		if (!insn_is_subprog_call(insn))
> +			continue;
> +
> +		relo = find_prog_insn_relo(prog, insn_idx);
> +		if (relo && relo->type != RELO_CALL) {
> +			pr_warn("prog '%s': unexpected relo for insn #%zu, type %d\n",
> +				prog->name, insn_idx, relo->type);
> +			return -LIBBPF_ERRNO__RELOC;
> +		}
> +		if (relo) {
> +			/* sub-program instruction index is a combination of
> +			 * an offset of a symbol pointed to by relocation and
> +			 * call instruction's imm field; for global functions,
> +			 * call always has imm = -1, but for static functions
> +			 * relocation is against STT_SECTION and insn->imm
> +			 * points to a start of a static function
> +			 */
> +			sub_insn_idx = relo->sym_off / BPF_INSN_SZ + insn->imm + 1;
> +		} else {
> +			/* if subprogram call is to a static function within
> +			 * the same ELF section, there won't be any relocation
> +			 * emitted, but it also means there is no additional
> +			 * offset necessary, insns->imm is relative to
> +			 * instruction's original position within the section
> +			 */

Great two comments. Thanks.

> +			sub_insn_idx = prog->sec_insn_off + insn_idx + insn->imm + 1;
> +		}
> +
> +		/* we enforce that sub-programs should be in .text section */
> +		subprog = find_prog_by_sec_insn(obj, obj->efile.text_shndx, sub_insn_idx);
> +		if (!subprog) {
> +			pr_warn("prog '%s': no .text section found yet sub-program call exists\n",
> +				prog->name);
> +			return -LIBBPF_ERRNO__RELOC;
> +		}
> +
> +		/* if subprogram hasn't been used in current main program,
> +		 * relocate it and append at the end of main program code
> +		 */

This one is quite confusing.
"hasn't been used" isn't right.
This subprog was used, but wasn't appeneded yet. That's what sub_insn_off is tracking.
Also "relocate and append it" is not right either.
It's "append and start relocating".
Probably shouldn't call it 'main' and 'subprog'.
It equally applies to 'subprog' and 'another subprog'.

> +		if (subprog->sub_insn_off == 0) {
> +			subprog->sub_insn_off = main_prog->insns_cnt;
> +
> +			new_cnt = main_prog->insns_cnt + subprog->insns_cnt;
> +			insns = libbpf_reallocarray(main_prog->insns, new_cnt, sizeof(*insns));
> +			if (!insns) {
> +				pr_warn("prog '%s': failed to realloc prog code\n", main_prog->name);
> +				return -ENOMEM;
> +			}
> +			main_prog->insns = insns;
> +			main_prog->insns_cnt = new_cnt;
> +
> +			memcpy(main_prog->insns + subprog->sub_insn_off, subprog->insns,
> +			       subprog->insns_cnt * sizeof(*insns));
> +
> +			pr_debug("prog '%s': added %zu insns from sub-prog '%s'\n",
> +				 main_prog->name, subprog->insns_cnt, subprog->name);
> +
> +			err = bpf_object__reloc_code(obj, main_prog, subprog);
> +			if (err)
> +				return err;
> +		}
> +
> +		/* main_prog->insns memory could have been re-allocated, so
> +		 * calculate pointer again
> +		 */
> +		insn = &main_prog->insns[prog->sub_insn_off + insn_idx];
> +		/* calculate correct instruction position within main prog */

may be: "calculate position within the prog being relocated?"

> +		insn->imm = subprog->sub_insn_off - (prog->sub_insn_off + insn_idx) - 1;

I think the algorithm is sound.
Could you add a better description of it?
May be some small diagram to illustrate how it recursively relocates?
That it starts with main, walks some number of insn, when it sees pseudo_call to
not yet appended subprog, it adds it to the end and recursively starts relocating it.
That subprog can have relos too. If they're pointing to not yet appended subprog it will be
added again and that 2nd subprog will start relocating while the main and 1st subprog
will be pending.
The algorithm didn't have to be recursive, but I guess it's fine to keep this way.
It's simple enough. I haven't thought through how it can look without recursion.
Probably a bunch of book keeping of things to relocate would have been necessary.
