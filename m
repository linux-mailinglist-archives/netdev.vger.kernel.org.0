Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8F01CFD2C
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgELSZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgELSZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 14:25:21 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B20C061A0C;
        Tue, 12 May 2020 11:25:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u5so3930295pgn.5;
        Tue, 12 May 2020 11:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3omL/UEu8fdXfy2ixt1kVFwU1RsnLoPQUztZRMXLrZM=;
        b=CtYBPA6yDdD8BLTbRmVC5toat11nC5DU0rteCRDtDgChNiYwBTndb27VC9gJHJz81+
         kjA74buH/kehzeLbYkuajQeZe9vb6+HgIzRaISDRYFtrF2fTS4PWX8jmycMIRLCUOC5D
         PrSvKAg8mE48NADnsn2E0KC+vGE6FfrGxk9KoaB7dVSyFJmXlPup33AQUEqFpkwb2ml8
         yn6MACncNfUOTdZDw0UGlHMRc16cp2ovN8QduxGYR93ntI0prnVbwn0fNelNoXQZa4rs
         +Q+4niG/QvYDNej0fRm4IYL8WrOAkE6YN+ttvsjXYr73A/SG9wGFTxO1UXKiRbjpMggH
         IJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3omL/UEu8fdXfy2ixt1kVFwU1RsnLoPQUztZRMXLrZM=;
        b=RcDfSdNUKcuDrujDXWU3/2bT261kMtDtEryn6UAu+Q/+wHYAF2f4ALaIdW9a0VFFm3
         oXurNltX5qm4kzVlr24Cla/vfvYnwZFz6DTGsRFcbXzvELPhfxm/KakIYlC9E79/LyA/
         PiSK6gbrazkvRCEN1T00JrjMCUiqylEvZhQ+Q04cFWGNP06elJiUcObnrU5vJtBlHYos
         fV+oagsrMFNBRHBrioNUa0MpaTqf441GQc+IaRedoFxwH90+fTj6FNpyOJgz6EV6gZr0
         /NB9W6u9QKUP0iKkeHQjSVBMrjYcNwZWfIJ6xFhq3QTeymE7MSJ9QXVwevMiYIuRIFlT
         uIzg==
X-Gm-Message-State: AGi0PubQgn0wRiyNlI/ArLWtUscLyOEBTDFsJYCoDyx2B0Jwv5gzz15O
        pURhvLI7YVF9X8gy2vyMC4w=
X-Google-Smtp-Source: APiQypIWpLcEcettIN+nyXJe33Kig+nEVBGULCVAn7w8glrTX8e4C5FCJ9Vg8lM7L6xqmIDUDrArdQ==
X-Received: by 2002:a62:76c1:: with SMTP id r184mr23102842pfc.155.1589307919317;
        Tue, 12 May 2020 11:25:19 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c3f6])
        by smtp.gmail.com with ESMTPSA id 1sm10699212pgy.77.2020.05.12.11.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 11:25:18 -0700 (PDT)
Date:   Tue, 12 May 2020 11:25:15 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20200512182515.7kvp6lvtnsij4jvj@ast-mbp>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
 <2aac2366-151a-5ae1-d65f-9232433f425f@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2aac2366-151a-5ae1-d65f-9232433f425f@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 04:35:41PM +0200, Daniel Borkmann wrote:
> On 5/8/20 11:53 PM, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> > 
> > Implement permissions as stated in uapi/linux/capability.h
> > In order to do that the verifier allow_ptr_leaks flag is split
> > into allow_ptr_leaks and bpf_capable flags and they are set as:
> >    env->allow_ptr_leaks = perfmon_capable();
> >    env->bpf_capable = bpf_capable();
> > 
> > bpf_capable enables bounded loops, variable stack access and other verifier features.
> > allow_ptr_leaks enable ptr leaks, ptr conversions, subtraction of pointers, etc.
> > It also disables side channel mitigations.
> > 
> > That means that the networking BPF program loaded with CAP_BPF + CAP_NET_ADMIN will
> > have speculative checks done by the verifier and other spectre mitigation applied.
> > Such networking BPF program will not be able to leak kernel pointers.
> 
> I don't quite follow this part in the code below yet, see my comments.
> 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> [...]
> > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > index 6abd5a778fcd..c32a7880fa62 100644
> > --- a/include/linux/bpf_verifier.h
> > +++ b/include/linux/bpf_verifier.h
> > @@ -375,6 +375,7 @@ struct bpf_verifier_env {
> >   	u32 used_map_cnt;		/* number of used maps */
> >   	u32 id_gen;			/* used to generate unique reg IDs */
> >   	bool allow_ptr_leaks;
> > +	bool bpf_capable;
> >   	bool seen_direct_write;
> >   	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
> >   	const struct bpf_line_info *prev_linfo;
> > diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> > index 95d77770353c..264a9254dc39 100644
> > --- a/kernel/bpf/arraymap.c
> > +++ b/kernel/bpf/arraymap.c
> > @@ -77,7 +77,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
> >   	bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
> >   	int ret, numa_node = bpf_map_attr_numa_node(attr);
> >   	u32 elem_size, index_mask, max_entries;
> > -	bool unpriv = !capable(CAP_SYS_ADMIN);
> > +	bool unpriv = !bpf_capable();
> 
> So here progs loaded with CAP_BPF will have spectre mitigations bypassed which
> is the opposite of above statement, no?

right. good catch, but now I'm not sure it was such a good call to toss
spectre into cap_perfmon. It probably should be disabled under cap_bpf.

> >   	u64 cost, array_size, mask64;
> >   	struct bpf_map_memory mem;
> >   	struct bpf_array *array;
> [...]
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 6aa11de67315..8f421dd0c4cf 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -646,7 +646,7 @@ static bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
> >   void bpf_prog_kallsyms_add(struct bpf_prog *fp)
> >   {
> >   	if (!bpf_prog_kallsyms_candidate(fp) ||
> > -	    !capable(CAP_SYS_ADMIN))
> > +	    !bpf_capable())
> >   		return;
> >   	bpf_prog_ksym_set_addr(fp);
> > @@ -824,7 +824,7 @@ static int bpf_jit_charge_modmem(u32 pages)
> >   {
> >   	if (atomic_long_add_return(pages, &bpf_jit_current) >
> >   	    (bpf_jit_limit >> PAGE_SHIFT)) {
> > -		if (!capable(CAP_SYS_ADMIN)) {
> > +		if (!bpf_capable()) {
> 
> Should there still be an upper charge on module mem for !CAP_SYS_ADMIN?

hmm. cap_bpf is a subset of cap_sys_admin. I don't see a reason
to keep requiring cap_sys_admin here.

> 
> >   			atomic_long_sub(pages, &bpf_jit_current);
> >   			return -EPERM;
> >   		}
> [...]
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 70ad009577f8..a6893746cd87 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> [...]
> > @@ -3428,7 +3429,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
> >   		 * Spectre masking for stack ALU.
> >   		 * See also retrieve_ptr_limit().
> >   		 */
> > -		if (!env->allow_ptr_leaks) {
> > +		if (!env->bpf_capable) {
> 
> This needs to stay on env->allow_ptr_leaks, the can_skip_alu_sanitation() does
> check on env->allow_ptr_leaks as well, otherwise this breaks spectre mitgation
> when masking alu.

The patch kept it in can_skip_alu_sanitation(), but I missed it here.
Don't really recall the details of discussion around
commit 088ec26d9c2d ("bpf: Reject indirect var_off stack access in unpriv mode")

So thinking all over this bit will effectively disable variable
stack access which is one of main usability features.
So for v6 I'm thinking to put spectre bypass into cap_bpf.
allow_ptr_leak will mean only what the name says: pointer leaks only.
cap_bpf should not be given to user processes that want to become root
via spectre side channels.
I think it's a usability trade-off for cap_bpf.
Without indirect var under cap_bpf too many networking progs will be forced to use
cap_bpf+net_net_admin+cap_perfmon only to pass the verifier
while they don't really care about reading arbitrary memory via cap_perfmon.
