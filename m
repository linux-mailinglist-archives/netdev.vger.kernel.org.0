Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F39E69004C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 07:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjBIGVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 01:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBIGVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 01:21:21 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FC33EFE6;
        Wed,  8 Feb 2023 22:21:13 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id ay41so413267qkb.5;
        Wed, 08 Feb 2023 22:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qq0aisiZNdBLJvJt/Le3Y3PzDAUc4+ToM1tj/U5V4rg=;
        b=Ryaii25HOhzJMz0eUkaA8JhS3QR1L9O2OSHOQJugjKZGj217gON9D+Ze6c8jjXxC9J
         Ooqk5aKfyNQWMSIc2HU6I/ZrvysInzc8OgQ+RFqtDbpva+gd4ZY7lEY9y1rsEZgcoJuv
         1YNzr3oHoIPDW/0zagWG1XowewXrQodskXrCMaoM3mqqasQzlu+Vd/AqCTFW5xld4wsV
         puslr2Ka5zip9sXeb9k9SJf6/7m5JjPoByNjx4K0z6GfFcRRb58AT8efBT0hbD0q7pTE
         Ek4Ad7NPD0Ma9f90upH4uP0MupQXZLNWiO7mM93RvEP9wP8E2ld0czptP5J43NdsGP7V
         HBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qq0aisiZNdBLJvJt/Le3Y3PzDAUc4+ToM1tj/U5V4rg=;
        b=2GQQRvIAAoCU2TYzdOmo7YLUsfhwEFsiplTWTn2f6CM51S4bgBCAjCyjxtb6rfjQwn
         8WnC7ZbihErRR2xKR6pbDkmsjMYe0knIEoplqunEAxqZGPKYacsVo5QbNTiJSdidof6Y
         w+EpGN887JqiOiyXjfGYpP1DqadEmNF7filoPRufL3Jj8BSXItaUoD7jlJngJQEDMY+B
         jXTGllmfY+l3A/0ZV1eNQfVKvnbVKQRmdec2zN641uLKKcnYDaqyLhLgjVDYhQ78fk2c
         4qclVFiZu8Hg14D3UhsSpESJb3wbOLwhvt4GmGAUZt6hhTobVPvnWg75RVNTZBCgzYtL
         d7ug==
X-Gm-Message-State: AO0yUKUmjFshoOxFcWv8UxbyCUKXq6NNoPHffSkj3LguOW3KOswyEUlN
        QMg673n3fLTIyl88oJ8/qiT66LlEO0roeHIi+qI=
X-Google-Smtp-Source: AK7set+FZFRdcxH6wzgtySMPy6nf1kDJJT2jtdAUg1/CBquW+eJ0HDo7ky5ivIP6FaLc1Nc8MYSUbeB4q4ceqowi14k=
X-Received: by 2002:a37:42d5:0:b0:738:dd4d:986e with SMTP id
 p204-20020a3742d5000000b00738dd4d986emr370129qka.409.1675923672480; Wed, 08
 Feb 2023 22:21:12 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <Y+QaZtz55LIirsUO@google.com> <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
 <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com> <08e1c9d0-376f-d669-6fe8-559b2fbc2f2b@efficios.com>
In-Reply-To: <08e1c9d0-376f-d669-6fe8-559b2fbc2f2b@efficios.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 9 Feb 2023 14:20:36 +0800
Message-ID: <CALOAHbBsmajStJ8TrnqEL_pv=UOt-vv0CH30EqThVq=JYXfi8A@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Qais Yousef <qyousef@google.com>,
        Daniele Di Proietto <ddiproietto@google.com>
Content-Type: multipart/mixed; boundary="0000000000002d019505f43e6383"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002d019505f43e6383
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 9, 2023 at 10:07 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> On 2023-02-08 19:54, John Stultz wrote:
> > On Wed, Feb 8, 2023 at 4:11 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Wed, Feb 8, 2023 at 2:01 PM John Stultz <jstultz@google.com> wrote:
> >>>
> >>> On Sat, Nov 20, 2021 at 11:27:38AM +0000, Yafang Shao wrote:
> >>>> As the sched:sched_switch tracepoint args are derived from the kernel,
> >>>> we'd better make it same with the kernel. So the macro TASK_COMM_LEN is
> >>>> converted to type enum, then all the BPF programs can get it through BTF.
> >>>>
> >>>> The BPF program which wants to use TASK_COMM_LEN should include the header
> >>>> vmlinux.h. Regarding the test_stacktrace_map and test_tracepoint, as the
> >>>> type defined in linux/bpf.h are also defined in vmlinux.h, so we don't
> >>>> need to include linux/bpf.h again.
> >>>>
> >>>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> >>>> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> >>>> Acked-by: David Hildenbrand <david@redhat.com>
> >>>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >>>> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> >>>> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> >>>> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> >>>> Cc: Peter Zijlstra <peterz@infradead.org>
> >>>> Cc: Steven Rostedt <rostedt@goodmis.org>
> >>>> Cc: Matthew Wilcox <willy@infradead.org>
> >>>> Cc: David Hildenbrand <david@redhat.com>
> >>>> Cc: Al Viro <viro@zeniv.linux.org.uk>
> >>>> Cc: Kees Cook <keescook@chromium.org>
> >>>> Cc: Petr Mladek <pmladek@suse.com>
> >>>> ---
> >>>>   include/linux/sched.h                                   | 9 +++++++--
> >>>>   tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
> >>>>   tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
> >>>>   3 files changed, 13 insertions(+), 8 deletions(-)
> >>>
> >>> Hey all,
> >>>    I know this is a little late, but I recently got a report that
> >>> this change was causiing older versions of perfetto to stop
> >>> working.
> >>>
> >>> Apparently newer versions of perfetto has worked around this
> >>> via the following changes:
> >>>    https://android.googlesource.com/platform/external/perfetto/+/c717c93131b1b6e3705a11092a70ac47c78b731d%5E%21/
> >>>    https://android.googlesource.com/platform/external/perfetto/+/160a504ad5c91a227e55f84d3e5d3fe22af7c2bb%5E%21/
> >>>
> >>> But for older versions of perfetto, reverting upstream commit
> >>> 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16
> >>> with TASK_COMM_LEN") is necessary to get it back to working.
> >>>
> >>> I haven't dug very far into the details, and obviously this doesn't
> >>> break with the updated perfetto, but from a high level this does
> >>> seem to be a breaking-userland regression.
> >>>
> >>> So I wanted to reach out to see if there was more context for this
> >>> breakage? I don't want to raise a unnecessary stink if this was
> >>> an unfortuante but forced situation.
> >>
> >> Let me understand what you're saying...
> >>
> >> The commit 3087c61ed2c4 did
> >>
> >> -/* Task command name length: */
> >> -#define TASK_COMM_LEN                  16
> >> +/*
> >> + * Define the task command name length as enum, then it can be visible to
> >> + * BPF programs.
> >> + */
> >> +enum {
> >> +       TASK_COMM_LEN = 16,
> >> +};
> >>
> >>
> >> and that caused:
> >>
> >> cat /sys/kernel/debug/tracing/events/task/task_newtask/format
> >>
> >> to print
> >> field:char comm[TASK_COMM_LEN];    offset:12;    size:16;    signed:0;
> >> instead of
> >> field:char comm[16];    offset:12;    size:16;    signed:0;
> >>
> >> so the ftrace parsing android tracing tool had to do:
> >>
> >> -  if (Match(type_and_name.c_str(), R"(char [a-zA-Z_]+\[[0-9]+\])")) {
> >> +  if (Match(type_and_name.c_str(),
> >> +            R"(char [a-zA-Z_][a-zA-Z_0-9]*\[[a-zA-Z_0-9]+\])")) {
> >>
> >> to workaround this change.
> >> Right?
> >
> > I believe so.
> >
> >> And what are you proposing?
> >
> > I'm not proposing anything. I was just wanting to understand more
> > context around this, as it outwardly appears to be a user-breaking
> > change, and that is usually not done, so I figured it was an issue
> > worth raising.
> >
> > If the debug/tracing/*/format output is in the murky not-really-abi
> > space, that's fine, but I wanted to know if this was understood as
> > something that may require userland updates or if this was a
> > unexpected side-effect.
>
> If you are looking at the root cause in the kernel code generating this:
>
> kernel/trace/trace_events.c:f_show()
>
>          /*
>           * Smartly shows the array type(except dynamic array).
>           * Normal:
>           *      field:TYPE VAR
>           * If TYPE := TYPE[LEN], it is shown:
>           *      field:TYPE VAR[LEN]
>           */
>
> where it uses the content of field->type (a string) to format the VAR[LEN] part.
>
> This in turn is the result of the definition of the
> struct trace_event_fields done in:
>
> include/trace/trace_events.h at stage 4, thus with the context of those macros defined:
>
> include/trace/stages/stage4_event_fields.h:
>
> #undef __array
> #define __array(_type, _item, _len) {                                   \
>          .type = #_type"["__stringify(_len)"]", .name = #_item,          \
>          .size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type), \
>          .is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
>
> I suspect the real culprit here is the use of __stringify(_len), which happens to work
> on macros, but not on enum labels.
>
> One possible solution to make this more robust would be to extend
> struct trace_event_fields with one more field that indicates the length
> of an array as an actual integer, without storing it in its stringified
> form in the type, and do the formatting in f_show where it belongs.
>
> This way everybody can stay happy and no ABI is broken.
>
> Thoughts ?

Many thanks for the detailed analysis. Seems it can work.

Hi John,

Could you pls. try the attached fix ? I have verified it in my test env.


--
Regards
Yafang

--0000000000002d019505f43e6383
Content-Type: application/octet-stream; 
	name="0001-trace-fix-TASK_COMM_LEN-in-trace-event-format-file.patch"
Content-Disposition: attachment; 
	filename="0001-trace-fix-TASK_COMM_LEN-in-trace-event-format-file.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ldwpm1ql0>
X-Attachment-Id: f_ldwpm1ql0

RnJvbSA0ZTYyMjdlNjU3MTYwMDFhYTc4NjExNjhjM2M1MTAzMTdhMzc3NGQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogWWFmYW5nIFNoYW8gPGxhb2FyLnNoYW9AZ21haWwuY29tPg0K
RGF0ZTogVGh1LCA5IEZlYiAyMDIzIDE0OjEzOjQ4ICswODAwDQpTdWJqZWN0OiBbUEFUQ0ggMS8x
XSB0cmFjZTogZml4IFRBU0tfQ09NTV9MRU4gaW4gdHJhY2UgZXZlbnQgZm9ybWF0IGZpbGUNCg0K
U2lnbmVkLW9mZi1ieTogWWFmYW5nIFNoYW8gPGxhb2FyLnNoYW9AZ21haWwuY29tPg0KLS0tDQog
aW5jbHVkZS9saW51eC90cmFjZV9ldmVudHMuaCAgICAgICAgICAgICAgIHwgIDEgKw0KIGluY2x1
ZGUvdHJhY2Uvc3RhZ2VzL3N0YWdlNF9ldmVudF9maWVsZHMuaCB8ICAzICsrLQ0KIGtlcm5lbC90
cmFjZS90cmFjZS5oICAgICAgICAgICAgICAgICAgICAgICB8ICAxICsNCiBrZXJuZWwvdHJhY2Uv
dHJhY2VfZXZlbnRzLmMgICAgICAgICAgICAgICAgfCAzMiArKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0NCiA0IGZpbGVzIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25z
KC0pDQoNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3RyYWNlX2V2ZW50cy5oIGIvaW5jbHVk
ZS9saW51eC90cmFjZV9ldmVudHMuaA0KaW5kZXggNDM0MmU5OS4uMGUzNzMyMiAxMDA2NDQNCi0t
LSBhL2luY2x1ZGUvbGludXgvdHJhY2VfZXZlbnRzLmgNCisrKyBiL2luY2x1ZGUvbGludXgvdHJh
Y2VfZXZlbnRzLmgNCkBAIC0yNzAsNiArMjcwLDcgQEAgc3RydWN0IHRyYWNlX2V2ZW50X2ZpZWxk
cyB7DQogCQkJY29uc3QgaW50ICBhbGlnbjsNCiAJCQljb25zdCBpbnQgIGlzX3NpZ25lZDsNCiAJ
CQljb25zdCBpbnQgIGZpbHRlcl90eXBlOw0KKwkJCWNvbnN0IGludCAgbGVuOw0KIAkJfTsNCiAJ
CWludCAoKmRlZmluZV9maWVsZHMpKHN0cnVjdCB0cmFjZV9ldmVudF9jYWxsICopOw0KIAl9Ow0K
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJhY2Uvc3RhZ2VzL3N0YWdlNF9ldmVudF9maWVsZHMuaCBi
L2luY2x1ZGUvdHJhY2Uvc3RhZ2VzL3N0YWdlNF9ldmVudF9maWVsZHMuaA0KaW5kZXggYWZmZDU0
MS4uMzA2ZjM5YSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvdHJhY2Uvc3RhZ2VzL3N0YWdlNF9ldmVu
dF9maWVsZHMuaA0KKysrIGIvaW5jbHVkZS90cmFjZS9zdGFnZXMvc3RhZ2U0X2V2ZW50X2ZpZWxk
cy5oDQpAQCAtMjYsNyArMjYsOCBAQA0KICNkZWZpbmUgX19hcnJheShfdHlwZSwgX2l0ZW0sIF9s
ZW4pIHsJCQkJCVwNCiAJLnR5cGUgPSAjX3R5cGUiWyJfX3N0cmluZ2lmeShfbGVuKSJdIiwgLm5h
bWUgPSAjX2l0ZW0sCQlcDQogCS5zaXplID0gc2l6ZW9mKF90eXBlW19sZW5dKSwgLmFsaWduID0g
QUxJR05fU1RSVUNURklFTEQoX3R5cGUpLAlcDQotCS5pc19zaWduZWQgPSBpc19zaWduZWRfdHlw
ZShfdHlwZSksIC5maWx0ZXJfdHlwZSA9IEZJTFRFUl9PVEhFUiB9LA0KKwkuaXNfc2lnbmVkID0g
aXNfc2lnbmVkX3R5cGUoX3R5cGUpLCAuZmlsdGVyX3R5cGUgPSBGSUxURVJfT1RIRVIsIFwNCisJ
LmxlbiA9IF9sZW59LA0KIA0KICN1bmRlZiBfX2R5bmFtaWNfYXJyYXkNCiAjZGVmaW5lIF9fZHlu
YW1pY19hcnJheShfdHlwZSwgX2l0ZW0sIF9sZW4pIHsJCQkJXA0KZGlmZiAtLWdpdCBhL2tlcm5l
bC90cmFjZS90cmFjZS5oIGIva2VybmVsL3RyYWNlL3RyYWNlLmgNCmluZGV4IGU0NmE0OTIuLjE5
Y2FmMTUgMTAwNjQ0DQotLS0gYS9rZXJuZWwvdHJhY2UvdHJhY2UuaA0KKysrIGIva2VybmVsL3Ry
YWNlL3RyYWNlLmgNCkBAIC0xMjgyLDYgKzEyODIsNyBAQCBzdHJ1Y3QgZnRyYWNlX2V2ZW50X2Zp
ZWxkIHsNCiAJaW50CQkJb2Zmc2V0Ow0KIAlpbnQJCQlzaXplOw0KIAlpbnQJCQlpc19zaWduZWQ7
DQorCWludAkJCWxlbjsNCiB9Ow0KIA0KIHN0cnVjdCBwcm9nX2VudHJ5Ow0KZGlmZiAtLWdpdCBh
L2tlcm5lbC90cmFjZS90cmFjZV9ldmVudHMuYyBiL2tlcm5lbC90cmFjZS90cmFjZV9ldmVudHMu
Yw0KaW5kZXggMzNlMGI0Zi4uODQxOWU0OCAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS90cmFj
ZV9ldmVudHMuYw0KKysrIGIva2VybmVsL3RyYWNlL3RyYWNlX2V2ZW50cy5jDQpAQCAtMTE0LDcg
KzExNCw3IEBAIHN0cnVjdCBmdHJhY2VfZXZlbnRfZmllbGQgKg0KIA0KIHN0YXRpYyBpbnQgX190
cmFjZV9kZWZpbmVfZmllbGQoc3RydWN0IGxpc3RfaGVhZCAqaGVhZCwgY29uc3QgY2hhciAqdHlw
ZSwNCiAJCQkJY29uc3QgY2hhciAqbmFtZSwgaW50IG9mZnNldCwgaW50IHNpemUsDQotCQkJCWlu
dCBpc19zaWduZWQsIGludCBmaWx0ZXJfdHlwZSkNCisJCQkJaW50IGlzX3NpZ25lZCwgaW50IGZp
bHRlcl90eXBlLCBpbnQgbGVuKQ0KIHsNCiAJc3RydWN0IGZ0cmFjZV9ldmVudF9maWVsZCAqZmll
bGQ7DQogDQpAQCAtMTMzLDYgKzEzMyw3IEBAIHN0YXRpYyBpbnQgX190cmFjZV9kZWZpbmVfZmll
bGQoc3RydWN0IGxpc3RfaGVhZCAqaGVhZCwgY29uc3QgY2hhciAqdHlwZSwNCiAJZmllbGQtPm9m
ZnNldCA9IG9mZnNldDsNCiAJZmllbGQtPnNpemUgPSBzaXplOw0KIAlmaWVsZC0+aXNfc2lnbmVk
ID0gaXNfc2lnbmVkOw0KKwlmaWVsZC0+bGVuID0gbGVuOw0KIA0KIAlsaXN0X2FkZCgmZmllbGQt
PmxpbmssIGhlYWQpOw0KIA0KQEAgLTE1MCwxNCArMTUxLDI4IEBAIGludCB0cmFjZV9kZWZpbmVf
ZmllbGQoc3RydWN0IHRyYWNlX2V2ZW50X2NhbGwgKmNhbGwsIGNvbnN0IGNoYXIgKnR5cGUsDQog
DQogCWhlYWQgPSB0cmFjZV9nZXRfZmllbGRzKGNhbGwpOw0KIAlyZXR1cm4gX190cmFjZV9kZWZp
bmVfZmllbGQoaGVhZCwgdHlwZSwgbmFtZSwgb2Zmc2V0LCBzaXplLA0KLQkJCQkgICAgaXNfc2ln
bmVkLCBmaWx0ZXJfdHlwZSk7DQorCQkJCSAgICBpc19zaWduZWQsIGZpbHRlcl90eXBlLCAwKTsN
CiB9DQogRVhQT1JUX1NZTUJPTF9HUEwodHJhY2VfZGVmaW5lX2ZpZWxkKTsNCiANCitpbnQgdHJh
Y2VfZGVmaW5lX2ZpZWxkX2V4dChzdHJ1Y3QgdHJhY2VfZXZlbnRfY2FsbCAqY2FsbCwgY29uc3Qg
Y2hhciAqdHlwZSwNCisJCSAgICAgICBjb25zdCBjaGFyICpuYW1lLCBpbnQgb2Zmc2V0LCBpbnQg
c2l6ZSwgaW50IGlzX3NpZ25lZCwNCisJCSAgICAgICBpbnQgZmlsdGVyX3R5cGUsIGludCBsZW4p
DQorew0KKwlzdHJ1Y3QgbGlzdF9oZWFkICpoZWFkOw0KKw0KKwlpZiAoV0FSTl9PTighY2FsbC0+
Y2xhc3MpKQ0KKwkJcmV0dXJuIDA7DQorDQorCWhlYWQgPSB0cmFjZV9nZXRfZmllbGRzKGNhbGwp
Ow0KKwlyZXR1cm4gX190cmFjZV9kZWZpbmVfZmllbGQoaGVhZCwgdHlwZSwgbmFtZSwgb2Zmc2V0
LCBzaXplLA0KKwkJCQkgICAgaXNfc2lnbmVkLCBmaWx0ZXJfdHlwZSwgbGVuKTsNCit9DQorDQog
I2RlZmluZSBfX2dlbmVyaWNfZmllbGQodHlwZSwgaXRlbSwgZmlsdGVyX3R5cGUpCQkJXA0KIAly
ZXQgPSBfX3RyYWNlX2RlZmluZV9maWVsZCgmZnRyYWNlX2dlbmVyaWNfZmllbGRzLCAjdHlwZSwJ
XA0KIAkJCQkgICAjaXRlbSwgMCwgMCwgaXNfc2lnbmVkX3R5cGUodHlwZSksCVwNCi0JCQkJICAg
ZmlsdGVyX3R5cGUpOwkJCVwNCisJCQkJICAgZmlsdGVyX3R5cGUsIDApOwkJCVwNCiAJaWYgKHJl
dCkJCQkJCQkJXA0KIAkJcmV0dXJuIHJldDsNCiANCkBAIC0xNjYsNyArMTgxLDcgQEAgaW50IHRy
YWNlX2RlZmluZV9maWVsZChzdHJ1Y3QgdHJhY2VfZXZlbnRfY2FsbCAqY2FsbCwgY29uc3QgY2hh
ciAqdHlwZSwNCiAJCQkJICAgImNvbW1vbl8iICNpdGVtLAkJCVwNCiAJCQkJICAgb2Zmc2V0b2Yo
dHlwZW9mKGVudCksIGl0ZW0pLAkJXA0KIAkJCQkgICBzaXplb2YoZW50Lml0ZW0pLAkJCVwNCi0J
CQkJICAgaXNfc2lnbmVkX3R5cGUodHlwZSksIEZJTFRFUl9PVEhFUik7CVwNCisJCQkJICAgaXNf
c2lnbmVkX3R5cGUodHlwZSksIEZJTFRFUl9PVEhFUiwgMCk7CVwNCiAJaWYgKHJldCkJCQkJCQkJ
XA0KIAkJcmV0dXJuIHJldDsNCiANCkBAIC0xNTg5LDEwICsxNjA0LDEwIEBAIHN0YXRpYyBpbnQg
Zl9zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwgdm9pZCAqdikNCiAJCQkgICBmaWVsZC0+dHlwZSwg
ZmllbGQtPm5hbWUsIGZpZWxkLT5vZmZzZXQsDQogCQkJICAgZmllbGQtPnNpemUsICEhZmllbGQt
PmlzX3NpZ25lZCk7DQogCWVsc2UNCi0JCXNlcV9wcmludGYobSwgIlx0ZmllbGQ6JS4qcyAlcyVz
O1x0b2Zmc2V0OiV1O1x0c2l6ZToldTtcdHNpZ25lZDolZDtcbiIsDQorCQlzZXFfcHJpbnRmKG0s
ICJcdGZpZWxkOiUuKnMgJXNbJWRdO1x0b2Zmc2V0OiV1O1x0c2l6ZToldTtcdHNpZ25lZDolZDtc
biIsDQogCQkJICAgKGludCkoYXJyYXlfZGVzY3JpcHRvciAtIGZpZWxkLT50eXBlKSwNCiAJCQkg
ICBmaWVsZC0+dHlwZSwgZmllbGQtPm5hbWUsDQotCQkJICAgYXJyYXlfZGVzY3JpcHRvciwgZmll
bGQtPm9mZnNldCwNCisJCQkgICBmaWVsZC0+bGVuLCBmaWVsZC0+b2Zmc2V0LA0KIAkJCSAgIGZp
ZWxkLT5zaXplLCAhIWZpZWxkLT5pc19zaWduZWQpOw0KIA0KIAlyZXR1cm4gMDsNCkBAIC0yMzc5
LDkgKzIzOTQsMTAgQEAgc3RhdGljIGludCBmdHJhY2VfZXZlbnRfcmVsZWFzZShzdHJ1Y3QgaW5v
ZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCiAJCQl9DQogDQogCQkJb2Zmc2V0ID0gQUxJ
R04ob2Zmc2V0LCBmaWVsZC0+YWxpZ24pOw0KLQkJCXJldCA9IHRyYWNlX2RlZmluZV9maWVsZChj
YWxsLCBmaWVsZC0+dHlwZSwgZmllbGQtPm5hbWUsDQorCQkJcmV0ID0gdHJhY2VfZGVmaW5lX2Zp
ZWxkX2V4dChjYWxsLCBmaWVsZC0+dHlwZSwgZmllbGQtPm5hbWUsDQogCQkJCQkJIG9mZnNldCwg
ZmllbGQtPnNpemUsDQotCQkJCQkJIGZpZWxkLT5pc19zaWduZWQsIGZpZWxkLT5maWx0ZXJfdHlw
ZSk7DQorCQkJCQkJIGZpZWxkLT5pc19zaWduZWQsIGZpZWxkLT5maWx0ZXJfdHlwZSwNCisJCQkJ
CQkgZmllbGQtPmxlbik7DQogCQkJaWYgKFdBUk5fT05fT05DRShyZXQpKSB7DQogCQkJCXByX2Vy
cigiZXJyb3IgY29kZSBpcyAlZFxuIiwgcmV0KTsNCiAJCQkJYnJlYWs7DQotLSANCjEuOC4zLjEN
Cg0K
--0000000000002d019505f43e6383--
