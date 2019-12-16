Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91ED6121A0D
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfLPTgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:36:01 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:33719 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726664AbfLPTgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:36:01 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2019 14:36:00 EST
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id BD299849;
        Mon, 16 Dec 2019 14:29:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 16 Dec 2019 14:29:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        content-transfer-encoding:content-type:in-reply-to:date:cc
        :subject:from:to:message-id; s=fm2; bh=/+h1XTDwJZREmBxJnMMOAIBLJ
        zO2exzHnVCiokLdtoA=; b=t/AnX6ZkAD+bRy43PrrkjLjDc4+OMRnPwaaO1wl3X
        ngwmEMLO/en3sMlWlB7SH3vR7HryBi/+EQhMJ7cGKAYxmwHvzkOpwKlwECunekkm
        4joSITTwqSKKr6lYri8TOXggFljuxwT0iT5cCJms6PS/u5AolDja/ZkAUgYt4kr3
        ZOeyWlAQOKjtoL8GzOkrsRUIF6DfR2wTBGrcoO8TkxLDpIjJqaP9p+q49QC0dNVm
        jTPH15mdYVSGp87oBPui7NcMFEZjYto4oAKYsbp7iebkbHrwMQ0ZD0OGVumAPO1V
        BCr0cjzHQparcJ4b5bQTkln/wax2PNY4qMK9MTBl3fvFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/+h1XT
        DwJZREmBxJnMMOAIBLJzO2exzHnVCiokLdtoA=; b=g3K863FhgGFSF9ahNft0Nt
        Yj++LGUnxZjnvqlR/kU2IJbV5sx6pAPpgco5LaWhXXz4Bn15f0s8Hpn02ebml0ZM
        ZZihHJ9FED1V7FEStXRxUWAk7aira4s7v5iGOe0XDB+Xljv27xRJ0XnXKXzuiTsO
        N3QvRJIJsjK+Gi6d6zRbRZBi5Kh7VVqktsDr+yNXnLo1U4qDBTm1hNUUlcUce0ZC
        NJC52undINqXdl6OqQHuJahToN/Mz3mZs0fzSqWZfSFarKqw39V1RvshffPMJwNx
        vHBDAQuBqbjAatvmH6PteQEpC7oCHKnxxdMRXwqpUJuKeUPX78hJOe3E6NXFvKAQ
        ==
X-ME-Sender: <xms:Adv3XU41YPQ6O49BrteiMX5V4ws-FsczwSbe4tAjMUhh56BqRCVAyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddthedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdejtddmnecujfgurhepgfgtjgffuffhvffksehtqhertddttdej
    necuhfhrohhmpedfffgrnhhivghlucgiuhdfuceougiguhesugiguhhuuhdrgiihiieqne
    cukfhppeduleelrddvtddurdeigedrudeftdenucfrrghrrghmpehmrghilhhfrhhomhep
    ugiguhesugiguhhuuhdrgiihiienucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Adv3XRZRiocV-JYX8YYX4hHT5Jlp1uPh5ulcJBVSKbUIQryo0MFTAw>
    <xmx:Adv3XYiZKDI6ZnlQd4qO_lH3jHHdKujPQrImHeorMcPGTeYlLE1kOA>
    <xmx:Adv3XYFbK9BzHUKShuGfBCaADV4UI1AMqPhifFVMOcCxJIomTLzUjw>
    <xmx:Atv3XWZp-9T-c8ZvFlgM4NniklkUSHUg4P5W4NA51tyQmcFlXzt4JzwpO5g>
Received: from localhost (unknown [199.201.64.130])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4403D80065;
        Mon, 16 Dec 2019 14:29:04 -0500 (EST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Originaldate: Fri Dec 6, 2019 at 9:10 AM
Originalfrom: "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Original: =?utf-8?q?On_Thu,_Dec_5,_2019_at_4:13_PM_Daniel_Xu_<dxu@dxuuu.xyz>_wrote:?=
 =?utf-8?q?=0D=0A>=0D=0A>_Last-branch-record_is_an_intel_CPU_feature_that_?=
 =?utf-8?q?can_be_configured_to=0D=0A>_record_certain_branches_that_are_ta?=
 =?utf-8?q?ken_during_code_execution._This_data=0D=0A>_is_particularly_int?=
 =?utf-8?q?eresting_for_profile_guided_optimizations._perf_has=0D=0A>_had_?=
 =?utf-8?q?LBR_support_for_a_while_but_the_data_collection_can_be_a_bit_co?=
 =?utf-8?q?arse=0D=0A>_grained.=0D=0A>=0D=0A>_We_(Facebook)_have_recently_?=
 =?utf-8?q?run_a_lot_of_experiments_with_feeding=0D=0A>_filtered_LBR_data_?=
 =?utf-8?q?to_various_PGO_pipelines._We've_seen_really_good=0D=0A>_results?=
 =?utf-8?q?_(+2.5%_throughput_with_lower_cpu_util_and_lower_latency)_by=0D?=
 =?utf-8?q?=0A>_feeding_high_request_latency_LBR_branches_to_the_compiler_?=
 =?utf-8?q?on_a=0D=0A>_request-oriented_service._We_used_bpf_to_read_a_spe?=
 =?utf-8?q?cial_request_context=0D=0A>_ID_(which_is_how_we_associate_branc?=
 =?utf-8?q?hes_with_latency)_from_a_fixed=0D=0A>_userspace_address._Readin?=
 =?utf-8?q?g_from_the_fixed_address_is_why_bpf_support_is=0D=0A>_useful.?=
 =?utf-8?q?=0D=0A>=0D=0A>_Aside_from_this_particular_use_case,_having_LBR_?=
 =?utf-8?q?data_available_to_bpf=0D=0A>_progs_can_be_useful_to_get_stack_t?=
 =?utf-8?q?races_out_of_userspace_applications=0D=0A>_that_omit_frame_poin?=
 =?utf-8?q?ters.=0D=0A>=0D=0A>_This_patch_adds_support_for_LBR_data_to_bpf?=
 =?utf-8?q?_perf_progs.=0D=0A>=0D=0A>_Some_notes:=0D=0A>_*_We_use_`=5F=5Fu?=
 =?utf-8?q?64_entries[BPF=5FMAX=5FLBR=5FENTRIES_*_3]`_instead_of=0D=0A>___?=
 =?utf-8?q?`struct_perf=5Fbranch=5Fentry[BPF=5FMAX=5FLBR=5FENTRIES]`_becau?=
 =?utf-8?q?se_checkpatch.pl=0D=0A>___warns_about_including_a_uapi_header_f?=
 =?utf-8?q?rom_another_uapi_header=0D=0A>=0D=0A>_*_We_define_BPF=5FMAX=5FL?=
 =?utf-8?q?BR=5FENTRIES_as_32_(instead_of_using_the_value_from=0D=0A>___ar?=
 =?utf-8?q?ch/x86/events/perf=5Fevents.h)_because_including_arch_specific_?=
 =?utf-8?q?headers=0D=0A>___seems_wrong_and_could_introduce_circular_heade?=
 =?utf-8?q?r_includes.=0D=0A>=0D=0A>_Signed-off-by:_Daniel_Xu_<dxu@dxuuu.x?=
 =?utf-8?q?yz>=0D=0A>_---=0D=0A>__include/uapi/linux/bpf=5Fperf=5Fevent.h_?=
 =?utf-8?q?|__5_++++=0D=0A>__kernel/trace/bpf=5Ftrace.c____________|_39_++?=
 =?utf-8?q?+++++++++++++++++++++++++++=0D=0A>__2_files_changed,_44_inserti?=
 =?utf-8?q?ons(+)=0D=0A>=0D=0A>_diff_--git_a/include/uapi/linux/bpf=5Fperf?=
 =?utf-8?q?=5Fevent.h_b/include/uapi/linux/bpf=5Fperf=5Fevent.h=0D=0A>_ind?=
 =?utf-8?q?ex_eb1b9d21250c..dc87e3d50390_100644=0D=0A>_---_a/include/uapi/?=
 =?utf-8?q?linux/bpf=5Fperf=5Fevent.h=0D=0A>_+++_b/include/uapi/linux/bpf?=
 =?utf-8?q?=5Fperf=5Fevent.h=0D=0A>_@@_-10,10_+10,15_@@=0D=0A>=0D=0A>__#in?=
 =?utf-8?q?clude_<asm/bpf=5Fperf=5Fevent.h>=0D=0A>=0D=0A>_+#define_BPF=5FM?=
 =?utf-8?q?AX=5FLBR=5FENTRIES_32=0D=0A>_+=0D=0A>__struct_bpf=5Fperf=5Feven?=
 =?utf-8?q?t=5Fdata_{=0D=0A>_________bpf=5Fuser=5Fpt=5Fregs=5Ft_regs;=0D?=
 =?utf-8?q?=0A>_________=5F=5Fu64_sample=5Fperiod;=0D=0A>_________=5F=5Fu6?=
 =?utf-8?q?4_addr;=0D=0A>_+_______=5F=5Fu64_nr=5Flbr;=0D=0A>_+_______/*_Ca?=
 =?utf-8?q?st_to_struct_perf=5Fbranch=5Fentry*_before_using_*/=0D=0A>_+___?=
 =?utf-8?q?____=5F=5Fu64_entries[BPF=5FMAX=5FLBR=5FENTRIES_*_3];=0D=0A>__}?=
 =?utf-8?q?;=0D=0A>=0D=0A=0D=0AI_wonder_if_instead_of_hard-coding_this_in_?=
 =?utf-8?q?bpf=5Fperf=5Fevent=5Fdata,_could=0D=0Awe_achieve_this_and_perha?=
 =?utf-8?q?ps_even_more_flexibility_by_letting_users=0D=0Aaccess_underlyin?=
 =?utf-8?q?g_bpf=5Fperf=5Fevent=5Fdata=5Fkern_and_use_CO-RE_to_read=0D=0Aw?=
 =?utf-8?q?hatever_needs_to_be_read_from_perf=5Fsample=5Fdata,_perf=5Feven?=
 =?utf-8?q?t,_etc=3F=0D=0AWould_that_work=3F=0D=0A=0D=0A>__#endif_/*_=5FUA?=
 =?utf-8?q?PI=5F=5FLINUX=5FBPF=5FPERF=5FEVENT=5FH=5F=5F_*/=0D=0A>_diff_--g?=
 =?utf-8?q?it_a/kernel/trace/bpf=5Ftrace.c_b/kernel/trace/bpf=5Ftrace.c=0D?=
 =?utf-8?q?=0A>_index_ffc91d4935ac..96ba7995b3d7_100644=0D=0A>_---_a/kerne?=
 =?utf-8?q?l/trace/bpf=5Ftrace.c=0D=0A>_+++_b/kernel/trace/bpf=5Ftrace.c?=
 =?utf-8?q?=0D=0A=0D=0A[...]=0D=0A?=
In-Reply-To: <CAEf4BzY-ahRm5HPrqRWF5seOjGM+PJs+J+DTbuws3r=jd_PArg@mail.gmail.com>
Date:   Mon, 16 Dec 2019 11:29:03 -0800
Cc:     "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Yonghong Song" <yhs@fb.com>, "Martin Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>,
        "Andrii Nakryiko" <andriin@fb.com>,
        "Networking" <netdev@vger.kernel.org>, "bpf" <bpf@vger.kernel.org>,
        "Peter Ziljstra" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Kernel Team" <kernel-team@fb.com>
Subject: Re: [PATCH bpf] bpf: Add LBR data to BPF_PROG_TYPE_PERF_EVENT prog
 context
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Message-Id: <BZ73B4ZKTVZP.2ME64EWPJ01T8@dlxu-fedora-R90QNFJV>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Dec 6, 2019 at 9:10 AM, Andrii Nakryiko wrote:
> On Thu, Dec 5, 2019 at 4:13 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
> >
> > Last-branch-record is an intel CPU feature that can be configured to
> > record certain branches that are taken during code execution. This data
> > is particularly interesting for profile guided optimizations. perf has
> > had LBR support for a while but the data collection can be a bit coarse
> > grained.
> >
> > We (Facebook) have recently run a lot of experiments with feeding
> > filtered LBR data to various PGO pipelines. We've seen really good
> > results (+2.5% throughput with lower cpu util and lower latency) by
> > feeding high request latency LBR branches to the compiler on a
> > request-oriented service. We used bpf to read a special request context
> > ID (which is how we associate branches with latency) from a fixed
> > userspace address. Reading from the fixed address is why bpf support is
> > useful.
> >
> > Aside from this particular use case, having LBR data available to bpf
> > progs can be useful to get stack traces out of userspace applications
> > that omit frame pointers.
> >
> > This patch adds support for LBR data to bpf perf progs.
> >
> > Some notes:
> > * We use `__u64 entries[BPF_MAX_LBR_ENTRIES * 3]` instead of
> >   `struct perf_branch_entry[BPF_MAX_LBR_ENTRIES]` because checkpatch.pl
> >   warns about including a uapi header from another uapi header
> >
> > * We define BPF_MAX_LBR_ENTRIES as 32 (instead of using the value from
> >   arch/x86/events/perf_events.h) because including arch specific header=
s
> >   seems wrong and could introduce circular header includes.
> >
> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> > ---
> >  include/uapi/linux/bpf_perf_event.h |  5 ++++
> >  kernel/trace/bpf_trace.c            | 39 +++++++++++++++++++++++++++++
> >  2 files changed, 44 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf_perf_event.h b/include/uapi/linux/b=
pf_perf_event.h
> > index eb1b9d21250c..dc87e3d50390 100644
> > --- a/include/uapi/linux/bpf_perf_event.h
> > +++ b/include/uapi/linux/bpf_perf_event.h
> > @@ -10,10 +10,15 @@
> >
> >  #include <asm/bpf_perf_event.h>
> >
> > +#define BPF_MAX_LBR_ENTRIES 32
> > +
> >  struct bpf_perf_event_data {
> >         bpf_user_pt_regs_t regs;
> >         __u64 sample_period;
> >         __u64 addr;
> > +       __u64 nr_lbr;
> > +       /* Cast to struct perf_branch_entry* before using */
> > +       __u64 entries[BPF_MAX_LBR_ENTRIES * 3];
> >  };
> >
>
>=20
> I wonder if instead of hard-coding this in bpf_perf_event_data, could
> we achieve this and perhaps even more flexibility by letting users
> access underlying bpf_perf_event_data_kern and use CO-RE to read
> whatever needs to be read from perf_sample_data, perf_event, etc?
> Would that work?
>
>=20
> >  #endif /* _UAPI__LINUX_BPF_PERF_EVENT_H__ */
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index ffc91d4935ac..96ba7995b3d7 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
>
>=20
> [...]
>

Sorry about the late response. I chatted w/ Andrii last week and spent
some time playing with alternatives. It turns out we can read lbr data
by casting the bpf_perf_event_data to the internal kernel datastructure
and doing some well placed bpf_probe_read's.

Unless someone else thinks this patch would be useful, I will probably
abandon it for now (unless we experience enough pain from doing these
casts). If I did a v2, I would probably add a bpf helper instead of
modifying the ctx to get around the ugly api limitations.

Daniel
