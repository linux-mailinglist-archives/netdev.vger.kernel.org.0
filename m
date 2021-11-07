Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB132447361
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 15:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbhKGPAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 10:00:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25879 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230379AbhKGPAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 10:00:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636297078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mq8+kY3l7NdxniTfmk1vX/FSxgdbx/UszhyXLNnBXNI=;
        b=LaCtkG3FLAMKGXV4T3FWR0pzMN2lKWPEkxR3mWti3fnjpYTH+v3Z+0jfXFboVvMW0KVpxC
        rH3xoOYLKVy8lxqZNRN3czZR4bCAOj5uGm33U0dQzMhzKpuF3AXnAEK3/q5G0xphrIJSN3
        nEQJFzbjRqFwuIMgEkqNLGLJVe99ULc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-rq9UKz_6MZiL_G40ZoejVg-1; Sun, 07 Nov 2021 09:57:56 -0500
X-MC-Unique: rq9UKz_6MZiL_G40ZoejVg-1
Received: by mail-wr1-f72.google.com with SMTP id f3-20020a5d50c3000000b00183ce1379feso3097347wrt.5
        for <netdev@vger.kernel.org>; Sun, 07 Nov 2021 06:57:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mq8+kY3l7NdxniTfmk1vX/FSxgdbx/UszhyXLNnBXNI=;
        b=h0pZnjTjm8u9D2c3NtIqxoRpbtGjXuTOiNHhoIWp3/Rt6av9nVUWrXpt/v+GNX7TL7
         eSX/ZQN0uf7GXYYUPWEsEJKamvkDOis4MgTuLOL+f188EMOGcMI0bAOMufqhIIAblpi3
         dQphjinDXEvH4ZimlG2c2oYsmlN59OSZBbqc7U/IJDqodoAl7vRerIVvcHUS/habRVJh
         gR9QgXzctMH+lI9gyoRLZXFwfVnSFQlh5Z8DgPlVz0VsRCMiRd8F8K37qks1nSLgR1v1
         9LPdPNj53hDhvHaMyN0eLSC55GwC7yTOLuDf92tpmcTA59Jxmna/scMxf+VhR4UNxPds
         OmOQ==
X-Gm-Message-State: AOAM530mb6g42KdiDgb8mN/ODpxgAOR/eInjVmWoGz/UMALHfnfNPs9m
        KKNAAPSThGEZZeKuGr/ITEnkKC5ZQykKOz7ZOrRx3QbNg+8TCLaEenhpcDYkUVO2sR4Vt91dXL7
        kGJWtiqhTCNSGQzUI
X-Received: by 2002:adf:df0d:: with SMTP id y13mr73012784wrl.176.1636297075527;
        Sun, 07 Nov 2021 06:57:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyCWk41i8T4HIOtLyT2IB8l9AA5l0knyM9oxgXoZiT6lihXDaLnVXRbgSfIYnBTXzWp0XTJ4A==
X-Received: by 2002:adf:df0d:: with SMTP id y13mr73012756wrl.176.1636297075233;
        Sun, 07 Nov 2021 06:57:55 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b14sm10425394wrd.24.2021.11.07.06.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 06:57:54 -0800 (PST)
Date:   Sun, 7 Nov 2021 15:57:52 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 0/2] bpf: Fix BTF data for modules
Message-ID: <YYfpcN71HCqoY1DT@krava>
References: <20211023120452.212885-1-jolsa@kernel.org>
 <CAEf4BzbaD60KFsUB4VkTAH2v3+GFkRvRbY_O-bNSpNG0=8pJ0Q@mail.gmail.com>
 <YXfulitQY1+Gd35h@krava>
 <CAEf4BzabyAdsrUoRx58MZKbwVBGa93247sw8pwU62N_wNhSZSQ@mail.gmail.com>
 <YXkTihiRKKJIc9M6@krava>
 <CAEf4BzYP8eK0qxF+1UK7=TZ+vFRVMfmnm9AN=B2JHROoDwaHeg@mail.gmail.com>
 <YXmX4+HDw9rghl0T@krava>
 <YXr2NFlJTAhHdZqq@krava>
 <CAEf4BzY1WLO+OmRQnRuJZc_-TEM12VZxd6RKQOrxWjT84KqBXw@mail.gmail.com>
 <YYFH2qSOGdcYAqaE@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYFH2qSOGdcYAqaE@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 03:14:52PM +0100, Jiri Olsa wrote:
> On Mon, Nov 01, 2021 at 04:14:29PM -0700, Andrii Nakryiko wrote:
> > On Thu, Oct 28, 2021 at 12:12 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Wed, Oct 27, 2021 at 08:18:11PM +0200, Jiri Olsa wrote:
> > > > On Wed, Oct 27, 2021 at 10:53:55AM -0700, Andrii Nakryiko wrote:
> > > > > On Wed, Oct 27, 2021 at 1:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Oct 26, 2021 at 09:12:31PM -0700, Andrii Nakryiko wrote:
> > > > > > > On Tue, Oct 26, 2021 at 5:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Oct 25, 2021 at 09:54:48PM -0700, Andrii Nakryiko wrote:
> > > > > > > > > On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > hi,
> > > > > > > > > > I'm trying to enable BTF for kernel module in fedora,
> > > > > > > > > > and I'm getting big increase on modules sizes on s390x arch.
> > > > > > > > > >
> > > > > > > > > > Size of modules in total - kernel dir under /lib/modules/VER/
> > > > > > > > > > from kernel-core and kernel-module packages:
> > > > > > > > > >
> > > > > > > > > >                current   new
> > > > > > > > > >       aarch64      60M   76M
> > > > > > > > > >       ppc64le      53M   66M
> > > > > > > > > >       s390x        21M   41M
> > > > > > > > > >       x86_64       64M   79M
> > > > > > > > > >
> > > > > > > > > > The reason for higher increase on s390x was that dedup algorithm
> > > > > > > > > > did not detect some of the big kernel structs like 'struct module',
> > > > > > > > > > so they are duplicated in the kernel module BTF data. The s390x
> > > > > > > > > > has many small modules that increased significantly in size because
> > > > > > > > > > of that even after compression.
> > > > > > > > > >
> > > > > > > > > > First issues was that the '--btf_gen_floats' option is not passed
> > > > > > > > > > to pahole for kernel module BTF generation.
> > > > > > > > > >
> > > > > > > > > > The other problem is more tricky and is the reason why this patchset
> > > > > > > > > > is RFC ;-)
> > > > > > > > > >
> > > > > > > > > > The s390x compiler generates multiple definitions of the same struct
> > > > > > > > > > and dedup algorithm does not seem to handle this at the moment.
> > > > > > > > > >
> > > > > > > > > > I put the debuginfo and btf dump of the s390x pnet.ko module in here:
> > > > > > > > > >   http://people.redhat.com/~jolsa/kmodbtf/
> > > > > > > > > >
> > > > > > > > > > Please let me know if you'd like to see other info/files.
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Hard to tell what's going on without vmlinux itself. Can you upload a
> > > > > > > > > corresponding kernel image with BTF in it?
> > > > > > > >
> > > > > > > > sure, uploaded
> > > > > > > >
> > > > > > >
> > > > > > > vmlinux.btfdump:
> > > > > > >
> > > > > > > [174] FLOAT 'float' size=4
> > > > > > > [175] FLOAT 'double' size=8
> > > > > > >
> > > > > > > VS
> > > > > > >
> > > > > > > pnet.btfdump:
> > > > > > >
> > > > > > > [89318] INT 'float' size=4 bits_offset=0 nr_bits=32 encoding=(none)
> > > > > > > [89319] INT 'double' size=8 bits_offset=0 nr_bits=64 encoding=(none)
> > > > > >
> > > > > > ugh, that's with no fix applied, sry
> > > > > >
> > > > > > I applied the first patch and uploaded new files
> > > > > >
> > > > > > now when I compare the 'module' struct from vmlinux:
> > > > > >
> > > > > >         [885] STRUCT 'module' size=1280 vlen=70
> > > > > >
> > > > > > and same one from pnet.ko:
> > > > > >
> > > > > >         [89323] STRUCT 'module' size=1280 vlen=70
> > > > > >
> > > > > > they seem to completely match, all the fields
> > > > > > and yet it still appears in the kmod's BTF
> > > > > >
> > > > >
> > > > > Ok, now struct module is identical down to the types referenced from
> > > > > the fields, which means it should have been deduplicated completely.
> > > > > This will require a more time-consuming debugging, though, so I'll put
> > > > > it on my TODO list for now. If you get to this earlier, see where the
> > > > > equivalence check fails in btf_dedup (sprinkle debug outputs around to
> > > > > see what's going on).
> > > >
> > > > it failed for me on that hypot_type_id check where I did fix,
> > > > I thought it's the issue of multiple same struct in the kmod,
> > > > but now I see I might have confused cannon_id with cand_id ;-)
> > > > I'll check more on this
> > >
> > > with more checking I got to the same conclusion as before,
> > > now maybe with little more details ;-)
> > >
> > > the problem seems to be that in some cases the module BTF
> > > data stores same structs under new/different IDs, while the
> > > kernel BTF data is already dedup-ed
> > >
> > > the dedup algo keeps hypot_map of kernel IDs to kmod IDs,
> > > and in my case it will get to the point that the kernel ID
> > > is already 'known' and points to certain kmod ID 'A', but it
> > > is also equiv to another kmod ID 'B' (so kmod ID 'A' and 'B'
> > > are equiv structs) but the dedup will claim as not equiv
> > >
> > >
> > > This is where the dedup fails for me on that s390 data:
> > >
> > > The pt_regs is defined as:
> > >
> > >         struct pt_regs
> > >         {
> > >                 union {
> > >                         user_pt_regs user_regs;
> > >                         struct {
> > >                                 unsigned long args[1];
> > >                                 psw_t psw;
> > >                                 unsigned long gprs[NUM_GPRS];
> > >                         };
> > >                 };
> > >                 ...
> > >         };
> > >
> > > considering just the first union:
> > >
> > >         [186] UNION '(anon)' size=152 vlen=2
> > >                 'user_regs' type_id=183 bits_offset=0
> > >                 '(anon)' type_id=181 bits_offset=0
> > >
> > >         [91251] UNION '(anon)' size=152 vlen=2
> > >                 'user_regs' type_id=91247 bits_offset=0
> > >                 '(anon)' type_id=91250 bits_offset=0
> > >
> > >
> > > ---------------------------------------------------------------
> > >
> > > Comparing the first member 'user_regs':
> > >
> > >         struct pt_regs
> > >         {
> > >                 union {
> > >     --->                user_pt_regs user_regs;
> > >                         struct {
> > >                                 unsigned long args[1];
> > >                                 psw_t psw;
> > >                                 unsigned long gprs[NUM_GPRS];
> > >                         };
> > >                 };
> > >
> > > Which looks like:
> > >
> > >         typedef struct {
> > >                 unsigned long args[1];
> > >                 psw_t psw;
> > >                 unsigned long gprs[NUM_GPRS];
> > >         } user_pt_regs;
> > >
> > >
> > > and is also equiv to the next union member struct.. and that's what
> > > kernel knows but not kmod... anyway,
> > >
> > >
> > > the dedup will compare 'user_pt_regs':
> > >
> > >         [183] TYPEDEF 'user_pt_regs' type_id=181
> > >
> > >         [91247] TYPEDEF 'user_pt_regs' type_id=91245
> > >
> > >
> > >         [181] STRUCT '(anon)' size=152 vlen=3
> > >                 'args' type_id=182 bits_offset=0
> > >                 'psw' type_id=179 bits_offset=64
> > >                 'gprs' type_id=48 bits_offset=192
> > >
> > >         [91245] STRUCT '(anon)' size=152 vlen=3
> > >                 'args' type_id=91246 bits_offset=0
> > >                 'psw' type_id=91243 bits_offset=64
> > >                 'gprs' type_id=91132 bits_offset=192
> > >
> > > and make them equiv by setting hypot_type_id for 181 to be 91245
> > >
> > >
> > > ---------------------------------------------------------------
> > >
> > > Now comparing the second member:
> > >
> > >         struct pt_regs
> > >         {
> > >                 union {
> > >                         user_pt_regs user_regs;
> > >     --->                struct {
> > >                                 unsigned long args[1];
> > >                                 psw_t psw;
> > >                                 unsigned long gprs[NUM_GPRS];
> > >                         };
> > >                 };
> > >
> > >
> > > kernel knows it's same struct as user_pt_regs and uses ID 181
> > >
> > >         [186] UNION '(anon)' size=152 vlen=2
> > >                 'user_regs' type_id=183 bits_offset=0
> > >                 '(anon)' type_id=181 bits_offset=0
> > >
> > > but kmod has new ID 91250 (not 91245):
> > >
> > >         [91251] UNION '(anon)' size=152 vlen=2
> > >                 'user_regs' type_id=91247 bits_offset=0
> > >                 '(anon)' type_id=91250 bits_offset=0
> > >
> > >
> > > and 181 and 91250 are equiv structs:
> > >
> > >         [181] STRUCT '(anon)' size=152 vlen=3
> > >                 'args' type_id=182 bits_offset=0
> > >                 'psw' type_id=179 bits_offset=64
> > >                 'gprs' type_id=48 bits_offset=192
> > >
> > >         [91250] STRUCT '(anon)' size=152 vlen=3
> > >                 'args' type_id=91246 bits_offset=0
> > >                 'psw' type_id=91243 bits_offset=64
> > >                 'gprs' type_id=91132 bits_offset=192
> > >
> > >
> > > now hypot_type_id for 181 is 91245, but we have brand new struct
> > > ID 91250, so we fail
> > >
> > > what the patch tries to do is at this point to compare ID 91250
> > > with 91245 and if it passes then we are equal and we throw away
> > > ID 91250 because the hypot_type_id for 181 stays 91245
> > >
> > >
> > > ufff.. thoughts? ;-)
> > 
> > Oh, this is a really great analysis, thanks a lot! It makes everything
> > clear. Basically, BTF dedup algo does too good job deduping vmlinux
> > BTF. :)
> > 
> > What's not clear is what to do about that, because a (current)
> > fundamental assumption of is_equiv() check is that any type within CU
> > (or in this case deduped vmlinux BTF) has exactly one unique mapping.
> > Clearly that's not the case now. That array fix you mentioned worked
> > around GCC bug where this assumption broke. In this case it's not a
> > bug of a compiler (neither of algo, really), we just need to make algo
> > smarter.
> > 
> > Let me think about this a bit, we'll need to make the equivalence
> > check be aware that there could be multiple equivalent mappings and be
> > ok with that as long as all candidates are equivalent between
> > themselves. Lots of equivalence and recursion to think about.
> > 
> > It would be great to have a simplified test case to play with that. Do
> > you mind distilling the chain of types above into a selftests and
> > posting it to the mailing list so that I can play with it? It
> > shouldn't be hard to write given BTF writing APIs. And we'll need a
> > selftests anyway once we improve the algo, so it's definitely not a
> > wasted work.
> > 


I ended up with simply test, where the idea is to use
type id which is defined after currently processed type

the last VALIDATE_RAW_BTF fails

I'm not sending full atch, because I assume this is not
to merge yet also I assume you might want to change that
anyway ;-)

I'll check later on that special array case

thanks,
jirka


---
 .../bpf/prog_tests/btf_dedup_split.c          | 113 ++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c b/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
index 64554fd33547..2ad54e185221 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
@@ -314,6 +314,117 @@ static void test_split_struct_duped() {
 	btf__free(btf1);
 }
 
+static void btf_add_data(struct btf *btf, int start_id)
+{
+#define ID(n) (start_id + n)
+	btf__set_pointer_size(btf, 8); /* enforce 64-bit arch */
+
+	btf__add_int(btf, "int", 4, BTF_INT_SIGNED);	/* [1] int */
+
+	btf__add_struct(btf, "s", 8);			/* [2] struct s { */
+	btf__add_field(btf, "a", ID(3), 0, 0);		/*      struct anon a; */
+	btf__add_field(btf, "b", ID(4), 0, 0);		/*      struct anon b; */
+							/* } */
+
+	btf__add_struct(btf, "(anon)", 8);		/* [3] struct anon { */
+	btf__add_field(btf, "f1", ID(1), 0, 0);		/*      int f1; */
+	btf__add_field(btf, "f2", ID(1), 32, 0);	/*      int f2; */
+							/* } */
+
+	btf__add_struct(btf, "(anon)", 8);		/* [4] struct anon { */
+	btf__add_field(btf, "f1", ID(1), 0, 0);		/*      int f1; */
+	btf__add_field(btf, "f2", ID(1), 32, 0);	/*      int f2; */
+							/* } */
+#undef ID
+}
+
+static void test_split_struct_missed()
+{
+	struct btf *btf1, *btf2;
+	int err;
+
+	/* generate the base data.. */
+	btf1 = btf__new_empty();
+	if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
+		return;
+
+	btf_add_data(btf1, 0);
+
+	VALIDATE_RAW_BTF(
+		btf1,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] STRUCT 's' size=8 vlen=2\n"
+		"\t'a' type_id=3 bits_offset=0\n"
+		"\t'b' type_id=4 bits_offset=0",
+		"[3] STRUCT '(anon)' size=8 vlen=2\n"
+		"\t'f1' type_id=1 bits_offset=0\n"
+		"\t'f2' type_id=1 bits_offset=32",
+		"[4] STRUCT '(anon)' size=8 vlen=2\n"
+		"\t'f1' type_id=1 bits_offset=0\n"
+		"\t'f2' type_id=1 bits_offset=32");
+
+	/* ..dedup them... */
+	err = btf__dedup(btf1, NULL, NULL);
+	if (!ASSERT_OK(err, "btf_dedup"))
+		goto cleanup;
+
+	VALIDATE_RAW_BTF(
+		btf1,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] STRUCT 's' size=8 vlen=2\n"
+		"\t'a' type_id=3 bits_offset=0\n"
+		"\t'b' type_id=3 bits_offset=0",
+		"[3] STRUCT '(anon)' size=8 vlen=2\n"
+		"\t'f1' type_id=1 bits_offset=0\n"
+		"\t'f2' type_id=1 bits_offset=32");
+
+	/* and add the same data on top of it */
+	btf2 = btf__new_empty_split(btf1);
+	if (!ASSERT_OK_PTR(btf2, "empty_split_btf"))
+		goto cleanup;
+
+	btf_add_data(btf2, 3);
+
+	VALIDATE_RAW_BTF(
+		btf2,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] STRUCT 's' size=8 vlen=2\n"
+		"\t'a' type_id=3 bits_offset=0\n"
+		"\t'b' type_id=3 bits_offset=0",
+		"[3] STRUCT '(anon)' size=8 vlen=2\n"
+		"\t'f1' type_id=1 bits_offset=0\n"
+		"\t'f2' type_id=1 bits_offset=32",
+		"[4] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[5] STRUCT 's' size=8 vlen=2\n"
+		"\t'a' type_id=6 bits_offset=0\n"
+		"\t'b' type_id=7 bits_offset=0",
+		"[6] STRUCT '(anon)' size=8 vlen=2\n"
+		"\t'f1' type_id=4 bits_offset=0\n"
+		"\t'f2' type_id=4 bits_offset=32",
+		"[7] STRUCT '(anon)' size=8 vlen=2\n"
+		"\t'f1' type_id=4 bits_offset=0\n"
+		"\t'f2' type_id=4 bits_offset=32");
+
+	err = btf__dedup(btf2, NULL, NULL);
+	if (!ASSERT_OK(err, "btf_dedup"))
+		goto cleanup;
+
+	/* after dedup it should match the original data */
+	VALIDATE_RAW_BTF(
+		btf2,
+		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
+		"[2] STRUCT 's' size=8 vlen=2\n"
+		"\t'a' type_id=3 bits_offset=0\n"
+		"\t'b' type_id=3 bits_offset=0",
+		"[3] STRUCT '(anon)' size=8 vlen=2\n"
+		"\t'f1' type_id=1 bits_offset=0\n"
+		"\t'f2' type_id=1 bits_offset=32");
+
+cleanup:
+	btf__free(btf2);
+	btf__free(btf1);
+}
+
 void test_btf_dedup_split()
 {
 	if (test__start_subtest("split_simple"))
@@ -322,4 +433,6 @@ void test_btf_dedup_split()
 		test_split_struct_duped();
 	if (test__start_subtest("split_fwd_resolve"))
 		test_split_fwd_resolve();
+	if (test__start_subtest("split_struct_missed"))
+		test_split_struct_missed();
 }
-- 
2.32.0

