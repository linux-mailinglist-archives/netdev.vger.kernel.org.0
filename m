Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A3A4D0F85
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 06:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242817AbiCHFxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 00:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbiCHFxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 00:53:08 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77185E25;
        Mon,  7 Mar 2022 21:52:11 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id b16so5434460ioz.3;
        Mon, 07 Mar 2022 21:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+aAQ68z5bUdi4gi3f7x74ZA2W3mBI33pygnpmeRuBzI=;
        b=X1GRs5Yy1RYIEnhBxsIrFW0jFcRRm10ThJfBJUR0L/V6kCShOlw8YoQqlvYXauA+Wj
         fWm/zqn7vKHkXtPzXYI069QKuog/kXlQtTE6ulEBHFwL1Mgo4fHGVRMKuwQ8pFCnV4sd
         p6GlqXV2vZ1oRO/hQyp3FZWqzRFl88D0itB78rJZoEq7lKnTHY9wkAgdf5xObI89Pdqm
         G/e3SICZiEEI6/VZN1EQDzTcyhvN1HK7U8LQFPTfuBwMhDTELpzuHl7/2hfsktGO8qfm
         HqzNFRXqN8yTpqUqj1nSXqX1NRPDzMc+YKzDHEYM+jp3bYP0bHDxkc4QQx7ctP2J0K/V
         61LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+aAQ68z5bUdi4gi3f7x74ZA2W3mBI33pygnpmeRuBzI=;
        b=x900cMiQC+Cac1WulHU8Ai1/9mp/KBmAjk4Hw9u7M14lZlK2y6O+Rm+MuJ8DkwL+MK
         WKK0u8iaBiN7XLIR+vpH8PBdV60CQZ3LgJ66wjUXkglmtXhMl/WmABemgmLGsy3OCd1m
         ThcXOl3JQs0g4cHPVp2BpkvY/pi1oVBQ5UNc3/KDBM60uKOO8IBvl7du8UWR65HqxYGN
         wr5LuuZaaVCUYEAqj/tHne7UtIn0LcbejZhmiyP43dztOhC3TK1r67InB7Jq1s8+LIv1
         WG+FLdAos88KtFZqzpMAg30ajlfQUHVrxDW0L0SBQBOq2d/RrplGXqhEJhowgqkU53rE
         LBNQ==
X-Gm-Message-State: AOAM531Tc2vncRvZXAWizzUDPgyPxdK9/hFB8PUBZJzrpW5t6wKQ5R7e
        gm/vO9P218X9ovosVGsKMiPAbWkHeKX0Xj0u7O4x6hdQFxM=
X-Google-Smtp-Source: ABdhPJzXf9gakKVFrNzk/yuF6YME/q3/SGtybwMxDDTkzyJNgvUtSPyEDmXzmTmerQMwtxhDHNuPNJsWavo9cZPOM6s=
X-Received: by 2002:a05:6602:1605:b0:644:d491:1bec with SMTP id
 x5-20020a056602160500b00644d4911becmr13210383iow.63.1646718730922; Mon, 07
 Mar 2022 21:52:10 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-5-benjamin.tissoires@redhat.com> <CAEf4BzZa8sP4QzEgi4T4L1_tz9D8gNNvjeQt3J0hrV6kq8NfUQ@mail.gmail.com>
 <D32CC967-8923-4933-A303-8455F32C6DA0@fb.com>
In-Reply-To: <D32CC967-8923-4933-A303-8455F32C6DA0@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 21:52:00 -0800
Message-ID: <CAEf4BzaxuYt+0j8z71y9z1+i0a=Q0hS0mb4cEKKzbiq3QAyNaA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/28] libbpf: add HID program type and API
To:     Song Liu <songliubraving@fb.com>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 7, 2022 at 5:38 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Mar 7, 2022, at 5:30 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Mar 4, 2022 at 9:31 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> >>
> >> HID-bpf program type are needing a new SEC.
> >> To bind a hid-bpf program, we can rely on bpf_program__attach_fd()
> >> so export a new function to the API.
> >>
> >> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >>
> >> ---
> >>
> >> changes in v2:
> >> - split the series by bpf/libbpf/hid/selftests and samples
> >> ---
> >> tools/lib/bpf/libbpf.c   | 7 +++++++
> >> tools/lib/bpf/libbpf.h   | 2 ++
> >> tools/lib/bpf/libbpf.map | 1 +
> >> 3 files changed, 10 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index 81bf01d67671..356bbd3ad2c7 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -8680,6 +8680,7 @@ static const struct bpf_sec_def section_defs[] = {
> >>        SEC_DEF("cgroup/setsockopt",    CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
> >>        SEC_DEF("struct_ops+",          STRUCT_OPS, 0, SEC_NONE),
> >>        SEC_DEF("sk_lookup",            SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
> >> +       SEC_DEF("hid/device_event",     HID, BPF_HID_DEVICE_EVENT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
> >
> > no SEC_SLOPPY_PFX for any new program type, please
> >
> >
> >> };
> >>
> >> #define MAX_TYPE_NAME_SIZE 32
> >> @@ -10659,6 +10660,12 @@ static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie)
> >>        return bpf_program__attach_iter(prog, NULL);
> >> }
> >>
> >> +struct bpf_link *
> >> +bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd)
> >> +{
> >> +       return bpf_program__attach_fd(prog, hid_fd, 0, "hid");
> >> +}
> >> +
> >> struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
> >> {
> >>        if (!prog->sec_def || !prog->sec_def->attach_fn)
> >> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> >> index c8d8daad212e..f677ac0a9ede 100644
> >> --- a/tools/lib/bpf/libbpf.h
> >> +++ b/tools/lib/bpf/libbpf.h
> >> @@ -529,6 +529,8 @@ struct bpf_iter_attach_opts {
> >> LIBBPF_API struct bpf_link *
> >> bpf_program__attach_iter(const struct bpf_program *prog,
> >>                         const struct bpf_iter_attach_opts *opts);
> >> +LIBBPF_API struct bpf_link *
> >> +bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd);
> >>
> >> /*
> >>  * Libbpf allows callers to adjust BPF programs before being loaded
> >> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> >> index 47e70c9058d9..fdc6fa743953 100644
> >> --- a/tools/lib/bpf/libbpf.map
> >> +++ b/tools/lib/bpf/libbpf.map
> >> @@ -424,6 +424,7 @@ LIBBPF_0.6.0 {
> >> LIBBPF_0.7.0 {
> >>        global:
> >>                bpf_btf_load;
> >> +               bpf_program__attach_hid;
> >
> > should go into 0.8.0
>
> Ah, I missed this one.
>
> btw, bpf_xdp_attach and buddies should also go into 0.8.0, no?

not really, they were released in libbpf v0.7, it's just any new
incoming API that should go into 0.8.0

>
> >
> >>                bpf_program__expected_attach_type;
> >>                bpf_program__log_buf;
> >>                bpf_program__log_level;
> >> --
> >> 2.35.1
> >>
>
