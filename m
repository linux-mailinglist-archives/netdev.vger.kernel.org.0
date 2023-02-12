Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772846935DA
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 04:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBLDjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 22:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBLDja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 22:39:30 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B35511658;
        Sat, 11 Feb 2023 19:39:29 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id o42so3935109qvo.13;
        Sat, 11 Feb 2023 19:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676173168;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k38DlK0t/XHGBmKF/8ZrTC+4DU+EC3G+T7TmyTsfFvU=;
        b=Eesg2pr21Hk2/SFlRpaZz6BWSDuCQ/lAmubyFyhQpXpmWUFBZwA3RMRmFl4R6kupMj
         zIqimSmEfd8SJuRPncA7f70MIq1bYExvI5pTFbun6JKUsJZNcHRDzXvBezdU8A9IDOz9
         S/KAxSCZfrwTD5epNKzAWf4XGqBE3lI9zOWH4r6myy1F/Kog4Mqu8l/+/0KMs42gMcw/
         lunbSDYZj9MoJlmDA53Ub0uurhNXOzNtd70JVU5mY0X5OckxLpdhMHkEmh8xii43dAr3
         ygFaw3kr1WSJiBYhv54OykPyCEASrCTnFAVWBt63tz1F0o3QWH6d4N8+M7w8JgbFaoUx
         uYxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676173168;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k38DlK0t/XHGBmKF/8ZrTC+4DU+EC3G+T7TmyTsfFvU=;
        b=qbsu6bKhIeYAVtJYQqP5w8TRDZKs8gJ+P0IbQXR4/uzkSS2OWUh1YkUpuNGnNFdCOF
         vqdGktXV05onwQRNlwIluhe/t4YgNAIiBk9RJL+U/IWODIQbWf/+T/WgRYiSIqIjRsCC
         gWqOPzhEPMixvJbLQoSPo5MyQ4S+WsK/+hxiVD1o7OVWUg3Sv4LtLn31Qx5Vjto1BMZC
         G8EKK1nGsmAUEbjx7ZLexoGagTcczbXHF2EvbkrLI9hTxBUuN9oiMJU9Z8eXvewbBno/
         szB+fGh0gRhkihSGfAhkn9l+ooEUB6hNMhsElTeI6laiOnxuoIZsWxzLOmojSZknnIe3
         rZuQ==
X-Gm-Message-State: AO0yUKUwznrQUQpPhFrsJSWTqhy3H3xFZ87mqOZwyQgfrgwv05YP2DCg
        frlm5TiISg5FSL9Y9Ipq/H9kHExfn3qfwc+oS5E=
X-Google-Smtp-Source: AK7set++fC5LRuz2dH+ErgwVb2ke3N2snEdx0tgAkIr73gknu4wwZoOPtJOeV6iq468KODoVusgaflTPhY0FFMyRNq4=
X-Received: by 2002:a0c:b306:0:b0:537:6777:b744 with SMTP id
 s6-20020a0cb306000000b005376777b744mr1598861qve.58.1676173168615; Sat, 11 Feb
 2023 19:39:28 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <Y+QaZtz55LIirsUO@google.com> <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
 <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
 <20230208212858.477cd05e@gandalf.local.home> <20230208213343.40ee15a5@gandalf.local.home>
 <20230211140011.4f15a633@gandalf.local.home>
In-Reply-To: <20230211140011.4f15a633@gandalf.local.home>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sun, 12 Feb 2023 11:38:52 +0800
Message-ID: <CALOAHbAnFHAiMH4QDgS6xN16B31qfhG8tfQ+iioCr9pw3sP=bw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     John Stultz <jstultz@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Qais Yousef <qyousef@google.com>,
        Daniele Di Proietto <ddiproietto@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary="0000000000004c630c05f4787a16"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004c630c05f4787a16
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2023 at 3:00 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 8 Feb 2023 21:33:43 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > OK, so it doesn't break perf, trace-cmd and rasdaemon, because the enum=
 is
> > only needed in the print_fmt part. It can handle it in the field portio=
n.
> >
> > That is:
> >
> >
> > system: sched
> > name: sched_switch
> > ID: 285
> > format:
> >       field:unsigned short common_type;       offset:0;       size:2; s=
igned:0;
> >       field:unsigned char common_flags;       offset:2;       size:1; s=
igned:0;
> >       field:unsigned char common_preempt_count;       offset:3;       s=
ize:1; signed:0;
> >       field:int common_pid;   offset:4;       size:4; signed:1;
> >
> >       field:char prev_comm[TASK_COMM_LEN];    offset:8;       size:16; =
       signed:0;
> >                              ^^^^^^^^^^^^^^                          ^^
> >                             is ignored                             is u=
sed
> >
> >
> >       field:pid_t prev_pid;   offset:24;      size:4; signed:1;
> >       field:int prev_prio;    offset:28;      size:4; signed:1;
> >       field:long prev_state;  offset:32;      size:8; signed:1;
> >       field:char next_comm[TASK_COMM_LEN];    offset:40;      size:16; =
       signed:0;
> >       field:pid_t next_pid;   offset:56;      size:4; signed:1;
> >       field:int next_prio;    offset:60;      size:4; signed:1;
> >
> > print fmt: "prev_comm=3D%s prev_pid=3D%d prev_prio=3D%d prev_state=3D%s=
%s =3D=3D> next_comm=3D%s next_pid=3D%d next_prio=3D%d", REC->prev_comm, RE=
C->prev_pid, REC->prev_prio, (REC->prev_state & ((((0x00000000 | 0x00000001=
 | 0x00000002 | 0x00000004 | 0x00000008 | 0x00000010 | 0x00000020 | 0x00000=
040) + 1) << 1) - 1)) ? __print_flags(REC->prev_state & ((((0x00000000 | 0x=
00000001 | 0x00000002 | 0x00000004 | 0x00000008 | 0x00000010 | 0x00000020 |=
 0x00000040) + 1) << 1) - 1), "|", { 0x00000001, "S" }, { 0x00000002, "D" }=
, { 0x00000004, "T" }, { 0x00000008, "t" }, { 0x00000010, "X" }, { 0x000000=
20, "Z" }, { 0x00000040, "P" }, { 0x00000080, "I" }) : "R", REC->prev_state=
 & (((0x00000000 | 0x00000001 | 0x00000002 | 0x00000004 | 0x00000008 | 0x00=
000010 | 0x00000020 | 0x00000040) + 1) << 1) ? "+" : "", REC->next_comm, RE=
C->next_pid, REC->next_prio
> >
> >    ^^^^^^^
> >
> > Is what requires the conversions. So I take that back. It only breaks
> > perfetto, and that's because it writes its own parser and doesn't use
> > libtraceevent.
>
> Actually, there are cases that this needs to be a number, as b3bc8547d3be=
6
> ("tracing: Have TRACE_DEFINE_ENUM affect trace event types as well") made
> it update fields as well as the printk fmt.
>

It seems that TRACE_DEFINE_ENUM(TASK_COMM_LEN) in the trace events
header files would be a better fix.

> I think because libtraceevent noticed that it was a "char" array, it just
> defaults to "size". But this does have meaning for all other types, and I
> can see other parsers requiring that.
>
> -- Steve


--=20
Regards
Yafang

--0000000000004c630c05f4787a16
Content-Type: application/octet-stream; name="TASK_COMM_LEN.diff"
Content-Disposition: attachment; filename="TASK_COMM_LEN.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_le0u4tol0>
X-Attachment-Id: f_le0u4tol0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJhY2UvZXZlbnRzL2Jsb2NrLmggYi9pbmNsdWRlL3RyYWNl
L2V2ZW50cy9ibG9jay5oDQppbmRleCA3ZjRkZmJkLi45N2NmNmMyIDEwMDY0NA0KLS0tIGEvaW5j
bHVkZS90cmFjZS9ldmVudHMvYmxvY2suaA0KKysrIGIvaW5jbHVkZS90cmFjZS9ldmVudHMvYmxv
Y2suaA0KQEAgLTEyLDYgKzEyLDggQEANCiANCiAjZGVmaW5lIFJXQlNfTEVOCTgNCiANCitUUkFD
RV9ERUZJTkVfRU5VTShUQVNLX0NPTU1fTEVOKTsNCisNCiBERUNMQVJFX0VWRU5UX0NMQVNTKGJs
b2NrX2J1ZmZlciwNCiANCiAJVFBfUFJPVE8oc3RydWN0IGJ1ZmZlcl9oZWFkICpiaCksDQpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS90cmFjZS9ldmVudHMvb29tLmggYi9pbmNsdWRlL3RyYWNlL2V2ZW50
cy9vb20uaA0KaW5kZXggMjZhMTFlNC4uMTlkZTlhOCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvdHJh
Y2UvZXZlbnRzL29vbS5oDQorKysgYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy9vb20uaA0KQEAgLTcs
NiArNyw4IEBADQogI2luY2x1ZGUgPGxpbnV4L3RyYWNlcG9pbnQuaD4NCiAjaW5jbHVkZSA8dHJh
Y2UvZXZlbnRzL21tZmxhZ3MuaD4NCiANCitUUkFDRV9ERUZJTkVfRU5VTShUQVNLX0NPTU1fTEVO
KTsNCisNCiBUUkFDRV9FVkVOVChvb21fc2NvcmVfYWRqX3VwZGF0ZSwNCiANCiAJVFBfUFJPVE8o
c3RydWN0IHRhc2tfc3RydWN0ICp0YXNrKSwNCmRpZmYgLS1naXQgYS9pbmNsdWRlL3RyYWNlL2V2
ZW50cy9vc25vaXNlLmggYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy9vc25vaXNlLmgNCmluZGV4IDgy
Zjc0MWUuLmFjM2MwYWIgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL3RyYWNlL2V2ZW50cy9vc25vaXNl
LmgNCisrKyBiL2luY2x1ZGUvdHJhY2UvZXZlbnRzL29zbm9pc2UuaA0KQEAgLTYsNiArNiw4IEBA
DQogI2RlZmluZSBfT1NOT0lTRV9UUkFDRV9IDQogDQogI2luY2x1ZGUgPGxpbnV4L3RyYWNlcG9p
bnQuaD4NCitUUkFDRV9ERUZJTkVfRU5VTShUQVNLX0NPTU1fTEVOKTsNCisNCiBUUkFDRV9FVkVO
VCh0aHJlYWRfbm9pc2UsDQogDQogCVRQX1BST1RPKHN0cnVjdCB0YXNrX3N0cnVjdCAqdCwgdTY0
IHN0YXJ0LCB1NjQgZHVyYXRpb24pLA0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJhY2UvZXZlbnRz
L3NjaGVkLmggYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy9zY2hlZC5oDQppbmRleCBmYmI5OWE2Li41
N2VjMDllIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS90cmFjZS9ldmVudHMvc2NoZWQuaA0KKysrIGIv
aW5jbHVkZS90cmFjZS9ldmVudHMvc2NoZWQuaA0KQEAgLTIxNiw2ICsyMTYsNyBAQCBzdGF0aWMg
aW5saW5lIGxvbmcgX190cmFjZV9zY2hlZF9zd2l0Y2hfc3RhdGUoYm9vbCBwcmVlbXB0LA0KIH0N
CiAjZW5kaWYgLyogQ1JFQVRFX1RSQUNFX1BPSU5UUyAqLw0KIA0KK1RSQUNFX0RFRklORV9FTlVN
KFRBU0tfQ09NTV9MRU4pOw0KIC8qDQogICogVHJhY2Vwb2ludCBmb3IgdGFzayBzd2l0Y2hlcywg
cGVyZm9ybWVkIGJ5IHRoZSBzY2hlZHVsZXI6DQogICovDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS90
cmFjZS9ldmVudHMvc2lnbmFsLmggYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy9zaWduYWwuaA0KaW5k
ZXggMWRiN2U0Yi4uM2IxY2RiNiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvdHJhY2UvZXZlbnRzL3Np
Z25hbC5oDQorKysgYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy9zaWduYWwuaA0KQEAgLTksNiArOSw4
IEBADQogI2luY2x1ZGUgPGxpbnV4L3NjaGVkLmg+DQogI2luY2x1ZGUgPGxpbnV4L3RyYWNlcG9p
bnQuaD4NCiANCitUUkFDRV9ERUZJTkVfRU5VTShUQVNLX0NPTU1fTEVOKTsNCisNCiAjZGVmaW5l
IFRQX1NUT1JFX1NJR0lORk8oX19lbnRyeSwgaW5mbykJCQkJXA0KIAlkbyB7CQkJCQkJCVwNCiAJ
CWlmIChpbmZvID09IFNFTkRfU0lHX05PSU5GTykgewkJCVwNCmRpZmYgLS1naXQgYS9pbmNsdWRl
L3RyYWNlL2V2ZW50cy90YXNrLmggYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy90YXNrLmgNCmluZGV4
IDY0ZDE2MDkuLjBhOWUwM2E3IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS90cmFjZS9ldmVudHMvdGFz
ay5oDQorKysgYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy90YXNrLmgNCkBAIC02LDYgKzYsNyBAQA0K
ICNkZWZpbmUgX1RSQUNFX1RBU0tfSA0KICNpbmNsdWRlIDxsaW51eC90cmFjZXBvaW50Lmg+DQog
DQorVFJBQ0VfREVGSU5FX0VOVU0oVEFTS19DT01NX0xFTik7DQogVFJBQ0VfRVZFTlQodGFza19u
ZXd0YXNrLA0KIA0KIAlUUF9QUk9UTyhzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2ssIHVuc2lnbmVk
IGxvbmcgY2xvbmVfZmxhZ3MpLA0K
--0000000000004c630c05f4787a16--
