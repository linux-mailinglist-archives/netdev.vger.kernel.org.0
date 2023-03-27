Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9AB6C9CB4
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbjC0HsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbjC0HsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:48:09 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EAB421F;
        Mon, 27 Mar 2023 00:47:47 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id n125so9315371ybg.7;
        Mon, 27 Mar 2023 00:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679903267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5jEg0Kavtz8jsyZXSPmOUPqZAH/yIhikE612EoIKMaA=;
        b=CWzX3MeDJD5tZ0iHpfje86riHrkvOALPPBd/yYpmIuvwabELoPsjWainSl37pRjUss
         iF1cto5vBAV+JjAtCJvI+dVYO7SpKLXL3v95pGKeDaF//xt3XH7/CuqEYeNSxqAGk6yv
         t5WuHB/Loj94YY1kn2KjJ98oyW9uK9CWHKfzgJX/omQvws8RvUw+V/Q1EAeeRcs2X6sO
         q6pw7PGdMeyXw2hy2l5xf5bqd9CLGuA5a4lhI+pwwHc5ZjC6yhN9N4xG0FEC9ZOQzzQL
         GTFhLAATQTAYO2+PmIQ3igqrWvm5nGPgh7kEmjo6Ru3xkVHDaeXi27+PZ4SdMzv7VkVI
         ZuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679903267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5jEg0Kavtz8jsyZXSPmOUPqZAH/yIhikE612EoIKMaA=;
        b=7HCHk5n7enNVT/xkjyGp7tXHg34T8OHyGlv4Zmxv7ZIU4RXuEG2E5HoDZ4HDnA2IQV
         qN2POxqTBODAZ04hlaHLGFiw2M2f8aFdb/991TfHn5BwxJnOU3ExbWTLs25LNzu28LZP
         WKPPo4axZkXR0A3iCihToil+1MzspQ66YnmVmFoxc5Nrt7ksB0fPgaKP8rfc0o2KZ4wc
         E7RuIoMiHg9DeTXvzsxPe9vOepqchc4xkUe0QC7okWdWQ/+kSs2B6M/LxqHJHku0xFJS
         pbpMMFBd80WjrVosz7zWBll6s4oRbEQuG5mrfhE1igd5+IYUvpxPZwiZ7DWFPwS1FaEp
         ZHlA==
X-Gm-Message-State: AAQBX9chuRq5Kes13iG8koSTAvMXddj7jm+5KcL1kX5gxtAdB/vLpKzX
        YnycqrOifeLiQubBADtb0/q6rTXefE1z+X7GQ4/yVEK4
X-Google-Smtp-Source: AKy350YBc+5wf92eUPh0T5RBO6d/mw5JA3KjPJaAy9VvjP1v2egYxUTWrVq+49bQ+FvFJgc8FBxx4bI2wso+bXunAzM=
X-Received: by 2002:a05:6902:124a:b0:b43:8424:2a4c with SMTP id
 t10-20020a056902124a00b00b4384242a4cmr6620042ybu.10.1679903266779; Mon, 27
 Mar 2023 00:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230306071006.73t5vtmxrsykw4zu@apollo> <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo> <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo> <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
 <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzYo-8ckyi-aogvW9HijNh+Z81CE__mWtmVJtCzuY+oECA@mail.gmail.com>
 <CAADnVQLBDNqqfoNOV=mPxvsMdXLJCK_g1qmHjqxo=PED_vbhuw@mail.gmail.com>
 <CAJnrk1YCbLxcKT_FY_UdO9YBOz9fTyFQFTB8P0_2swPc39egvg@mail.gmail.com>
 <20230313144135.5xvgdfvfknb4liwh@apollo> <CAEf4BzacF6pj7wHJ4NH3GBe4rtkaLSZUU1xahhQ37892Ds2ZmA@mail.gmail.com>
In-Reply-To: <CAEf4BzacF6pj7wHJ4NH3GBe4rtkaLSZUU1xahhQ37892Ds2ZmA@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Mon, 27 Mar 2023 00:47:35 -0700
Message-ID: <CAJnrk1Y=u_9sVo1QhNopRu7F7tRsmZmcNDMeiUw+QF3rtQQ2og@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 11:55=E2=80=AFAM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Mar 13, 2023 at 7:41=E2=80=AFAM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
[...]
> > > > For bpf_dynptr_slice_rdrw we can mark buffer[] in stack as
> > > > poisoned with dynptr_id =3D=3D R0's PTR_TO_MEM dynptr_id.
> > > > Then as soon as first spillable reg touches that poisoned stack are=
a
> > > > we can invalidate all PTR_TO_MEM's with that dynptr_id.
> > >
> > > Okay, this makes sense to me. are you already currently working or
> > > planning to work on a fix for this Kumar, or should i take a stab at
> > > it?
> >
> > I'm not planning to do so, so go ahead. One more thing I noticed just n=
ow is
> > that we probably need to update regsafe to perform a check_ids comparis=
on for
> > dynptr_id for dynptr PTR_TO_MEMs? It was not a problem back when f8064a=
b90d66
> > ("bpf: Invalidate slices on destruction of dynptrs on stack") was added=
 but
> > 567da5d253cd ("bpf: improve regsafe() checks for PTR_TO_{MEM,BUF,TP_BUF=
FER}")
> > added PTR_TO_MEM in the switch statement.
>
> I can take care of this. But I really would like to avoid these
> special cases of extra dynptr_id, exactly for reasons like this
> omitted check.
>
> What do people think about generalizing current ref_obj_id to be more
> like "lifetime id" (to borrow Rust terminology a bit), which would be
> an object (which might or might not be a tracked reference) defining
> the scope/lifetime of the current register (whatever it represents).
>
> I haven't looked through code much, but I've been treating ref_obj_id
> as that already in my thinking before, and it seems to be a better
> approach than having a special-case of dynptr_id.
>
> Thoughts?

Thanks for taking care of this (and apologies for the late reply). i
think the dynptr_id field would still be needed in this case to
associate a slice with a dynptr, so that when a dynptr is invalidated
its slices get invalidated as well. I'm not sure we could get away
with just having ref_obj_id symbolize that in the case where the
underlying object is a tracked reference, because for example, it
seems like a dynptr would need both a unique reference id to the
object (so that if for example there are two dynptrs pointing to the
same object, they will both be assignedthe same reference id so the
object can't for example be freed twice) and also its own dynptr id so
that its slices get invalidated if the dynptr is invalidated
