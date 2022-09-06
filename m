Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268685AF097
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbiIFQhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiIFQgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:36:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2404D13DEF
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 09:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662480777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kg2ZD8/t1Jr30+S6ZmV5Vng3X+mccbhRQidJGUyOJ8o=;
        b=Hdx2jw3IDZlrCLAi90onICEn5UaRBMqVRZJzny7HB2pFOFn6WF38JxMq5cL7qF3ntLY+AH
        0Chj4OdzwUj9kPiqaa2oiuhA+Noj6Wbv73sL/O/6ob24LMJsq7hvGSTdnWog0X69XmLRBF
        BEsVFCTgRjNyiBXYgtk8YiFOIs7jLJg=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-60-UnBREpnuN8yHXgTN1WtFMA-1; Tue, 06 Sep 2022 12:12:56 -0400
X-MC-Unique: UnBREpnuN8yHXgTN1WtFMA-1
Received: by mail-pj1-f69.google.com with SMTP id z8-20020a17090a014800b001fac4204c7eso5075476pje.8
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 09:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=kg2ZD8/t1Jr30+S6ZmV5Vng3X+mccbhRQidJGUyOJ8o=;
        b=oUSPhFKfmxvq2N9f8OAY8kJXi3AOoEHZ0Slnn0xzgHKiysCBfXX4EhTkq1sHoVHfrh
         ZgNUxOftFnaWu49S4/dEfVUb+if+rwgVHcJ3LTo3PcJOtR985ySQN8ueMPVzcCNkq4DQ
         EjX12INEOBS9EjTudZq0fDSU+ESzlJ+65KwIJnGKw8pTztykoEmlgnNlgjswzOLIHbhm
         N70op02bfCnMfDm8fmnYeBbQ2+LeONa1gzqgCO4Yb4i+E6t+KqtPBa1buCGHY7+Nw9pp
         ndPkHVvlWc7KXXTPPsxns2qwVNm/OLlZuk1Lc+6MZaWQD6AH1duROSI3f8saEqf9Qd6T
         rdvQ==
X-Gm-Message-State: ACgBeo10QDL8oxIQ4dN3DN3eyBwMi5rU71fEb0vltayhn2LN9yMau6Dt
        9r/KYRujEP35UOqE6O8InMcLNVIh7tPblDqaNDk9npcWPfxmA5f7lZzIIlo+SJbEk/kGnFSnYhk
        Vf4+Al8TZ5YmPQRzxXMgNhCqaMuwNPc8F
X-Received: by 2002:a17:90a:4485:b0:1fa:cc1f:a7a with SMTP id t5-20020a17090a448500b001facc1f0a7amr25979393pjg.45.1662480774584;
        Tue, 06 Sep 2022 09:12:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR62clyvFNxfvYwrm+zhQNaRY46JYdBxaA8PGMyTRlTBTbWPbc89Y4U7LekV45n04MZzTad6xPl3cyc04nZan6E=
X-Received: by 2002:a17:90a:4485:b0:1fa:cc1f:a7a with SMTP id
 t5-20020a17090a448500b001facc1f0a7amr25979368pjg.45.1662480774362; Tue, 06
 Sep 2022 09:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
 <20220902132938.2409206-2-benjamin.tissoires@redhat.com> <CAP01T75KTjawtsvQmhZhj0=tEJVwc7UewRqdT1ui+uKONg07Zw@mail.gmail.com>
 <CAP01T74zEuSfTYhkKieU1B5YwzdXhKWxPX55AabV84j-=virwA@mail.gmail.com> <CAO-hwJLBtjfU7NWVTRK8HKmATuSb3ZSY__+OOMZhqY85DeQbWQ@mail.gmail.com>
In-Reply-To: <CAO-hwJLBtjfU7NWVTRK8HKmATuSb3ZSY__+OOMZhqY85DeQbWQ@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 6 Sep 2022 18:12:43 +0200
Message-ID: <CAO-hwJ+K0EmS-j+2uuj-13aDf2+X8ZVU4ue4MNg55p9nJhLAKw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v10 01/23] selftests/bpf: regroup and declare
 similar kfuncs selftests in an array
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 6, 2022 at 3:50 PM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Tue, Sep 6, 2022 at 5:27 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > On Tue, 6 Sept 2022 at 05:25, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > >
> > > On Fri, 2 Sept 2022 at 15:29, Benjamin Tissoires
> > > <benjamin.tissoires@redhat.com> wrote:
> > > >
> > > > Similar to tools/testing/selftests/bpf/prog_tests/dynptr.c:
> > > > we declare an array of tests that we run one by one in a for loop.
> > > >
> > > > Followup patches will add more similar-ish tests, so avoid a lot of copy
> > > > paste by grouping the declaration in an array.
> > > >
> > > > To be able to call bpf_object__find_program_by_name(), we need to use
> > > > plain libbpf calls, and not light skeletons. So also change the Makefile
> > > > to not generate light skeletons.
> > > >
> > > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > >
> > > > ---
> > >
> > > I see your point, but this is also a test so that we keep verifying
> > > kfunc call in light skeleton.
> > > Code for relocating both is different in libbpf (we generate BPF ASM
> > > for light skeleton so it is done inside a loader BPF program instead
> > > of userspace).
> >
> > Err, hit send too early.
> > We can probably use a macro to hide how program is called, then do
> > X(prog1)
> > X(prog2)
> > in a series, won't look too bad and avoids duplication at the same time.
> >
> > > You might then be able to make it work for both light and normal skeleton.
> > >
> > WDYT?
> >
>
> On this patch alone, I concede the benefit is minimum. But if you look
> at 6/23, I must confess I definitely prefer having just an array of
> tests at the beginning instead of crippling the tests functions with
> calls or macros.
>
> The actual reason for me to ditch light skeletons was because I was
> using bpf_object__find_program_by_name().
>
> But I can work around that by relying on the offsetof() macro, and
> make the whole thing working for *both* light skeleton and libbpf:
> +struct kfunc_test_params {
> +       const char *prog_name;
> +       unsigned long int lskel_prog_desc_offset;
> +       int retval;
> +};
> +
> +#define TC_TEST(name,__retval) \
> +       { \
> +         .prog_name = #name, \
> +         .lskel_prog_desc_offset = offsetof(struct
> kfunc_call_test_lskel, progs.name), \
> +         .retval = __retval, \
> +       }
> +
> +static struct kfunc_test_params kfunc_tests[] = {
> +       TC_TEST(kfunc_call_test1, 12),
> +       TC_TEST(kfunc_call_test2, 3),
> +       TC_TEST(kfunc_call_test_ref_btf_id, 0),
> +};
> +
> +static void verify_success(struct kfunc_test_params *param)
>  {
> [...]
> +       struct bpf_prog_desc *lskel_prog = (struct bpf_prog_desc
> *)((char *)lskel + param->lskel_prog_desc_offset);
>
> However, for failing tests, I can not really rely on light skeletons
> because we can not dynamically set the autoload property.
> So either I split every failed test in its own file, or I only test
> the ones that are supposed to load, which don't add a lot IMO.
>
> I'll repost the bpf-core changes only so you can have a better idea of
> what I am saying.
>

FWIW, I have now sent them at [0] and dropped all of the people not in
get_maintainers.pl.

Cheers,
Benjamin

[0] https://lore.kernel.org/all/20220906151303.2780789-1-benjamin.tissoires@redhat.com/T/#u

