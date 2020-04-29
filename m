Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3CF1BE74F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgD2T0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2T0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:26:05 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306B3C03C1AE;
        Wed, 29 Apr 2020 12:26:05 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id fb4so1757468qvb.7;
        Wed, 29 Apr 2020 12:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KOFkpyWYO5zLYUMyj6GOEp2h0JaslFjyy1Oe5wneb1M=;
        b=W4PQ0D26kuF6DhVDn7iHsykrF76fETEBOGGIykNDTe1se5cKBOe5x0ew2ePkLNaOpJ
         w+1GSKTg1NfSb/WQDJnqx2TzivZ/AzlOjZpu1bl/EnOfuz2G72FRogrtU/UivtHyMse1
         a++8fTXCUdZB5Ss++oYmOrlJNEwGxPQEts1a//B6rtgIKp4frXWOUxVT7+V/4cXjJCYx
         F+t3KQEM2y91ggWt7eCAvAcyKevSWxvnPXnZ4eEujOMuh01Y0UQHn/ZtqqECfBLbICHM
         zsdEZDXh3mjfE3q/rek4BxTt+RReJxQr3cLm3npt7kF5SsiAZqtUXDhCtQEe5InO48jZ
         iR5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KOFkpyWYO5zLYUMyj6GOEp2h0JaslFjyy1Oe5wneb1M=;
        b=kELNtD0cSdhW6Zi412ZG0OViUeCaYtY+wfx5hG772mN9vyAPuvC5PsudzG7ypwQwww
         W2rB6sOmj9RQurozBlILQZR9kMhNfSXDNLa88goWuFX/Unb9mAA66nom47YNRCVroO81
         aSZp6aopeVh98uC98cubPJp2wsnfPD/g5s1P2BxboaUbVzyiT6sY4YnvN75Hk8GYTVPM
         llXyWxeFVyQRaVHX1ZUT5+fjGT+0G9TK43WnaMAorfGvOt6/WfKQWL1NzAxZ5x9aPPUH
         rvIHSaru82kGBHtqGGP+6h0AxT6bez2E8OOc9ocOo+GUfpbIVoQzd2yoJIj1xezfar/v
         3kRA==
X-Gm-Message-State: AGi0PubsMvVijuqwFU/5ypfPWWgf3Y49lEGuXtdJZNGwDUSM7IJxZjZX
        OcHgY3i/+zogGMM5XZUQy5agCYUghdkRprhOzILGX8VQ
X-Google-Smtp-Source: APiQypJ+DG5HWUGlyaGsESsMKM8rLgMq5/Lj3ocBrKM45+0rlIvVAx0LBLyqdDisi/7UjtmUUULDZEszOKd/SGLAfoE=
X-Received: by 2002:ad4:4c03:: with SMTP id bz3mr34240320qvb.224.1588188364286;
 Wed, 29 Apr 2020 12:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp> <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
 <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com> <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
 <7f15274d-46dd-f43f-575e-26a40032f900@fb.com> <CAEf4BzaCVZem4O9eR9gBTO5c+PHy5zE8BdLD2Aa-PCLHC4ywRg@mail.gmail.com>
 <401b5bd2-dc43-4465-1232-34428a1b3e4e@fb.com> <20200429063448.fwqubjdz72uikpga@kafai-mbp>
 <a0e60713-edfa-9363-c75a-0e8977612858@fb.com>
In-Reply-To: <a0e60713-edfa-9363-c75a-0e8977612858@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 12:25:53 -0700
Message-ID: <CAEf4BzYtkX=pyBc3oVmSg=3GbuYudj9nNd0kPDesWsVtUV9pUg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:51 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/28/20 11:34 PM, Martin KaFai Lau wrote:
> > On Tue, Apr 28, 2020 at 11:20:30PM -0700, Yonghong Song wrote:
> >>
> >>
> >> On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
> >>> On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
> >>>>> On 4/28/20 6:15 PM, Yonghong Song wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
> >>>>>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
> >>>>>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
> >>>>>>>>> bpf_iter_seq_map_info),
> >>>>>>>>> +                 &meta.session_id, &meta.seq_num,
> >>>>>>>>> +                 v == (void *)0);
> >>>>>>>>    From looking at seq_file.c, when will show() be called with "v ==
> >>>>>>>> NULL"?
> >>>>>>>>
> >>>>>>>
> >>>>>>> that v == NULL here and the whole verifier change just to allow NULL...
> >>>>>>> may be use seq_num as an indicator of the last elem instead?
> >>>>>>> Like seq_num with upper bit set to indicate that it's last?
> >>>>>>
> >>>>>> We could. But then verifier won't have an easy way to verify that.
> >>>>>> For example, the above is expected:
> >>>>>>
> >>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
> >>>>>>            if (seq_num >> 63)
> >>>>>>              return 0;
> >>>>>>            ... map->id ...
> >>>>>>            ... map->user_cnt ...
> >>>>>>         }
> >>>>>>
> >>>>>> But if user writes
> >>>>>>
> >>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
> >>>>>>             ... map->id ...
> >>>>>>             ... map->user_cnt ...
> >>>>>>         }
> >>>>>>
> >>>>>> verifier won't be easy to conclude inproper map pointer tracing
> >>>>>> here and in the above map->id, map->user_cnt will cause
> >>>>>> exceptions and they will silently get value 0.
> >>>>>
> >>>>> I mean always pass valid object pointer into the prog.
> >>>>> In above case 'map' will always be valid.
> >>>>> Consider prog that iterating all map elements.
> >>>>> It's weird that the prog would always need to do
> >>>>> if (map == 0)
> >>>>>      goto out;
> >>>>> even if it doesn't care about finding last.
> >>>>> All progs would have to have such extra 'if'.
> >>>>> If we always pass valid object than there is no need
> >>>>> for such extra checks inside the prog.
> >>>>> First and last element can be indicated via seq_num
> >>>>> or via another flag or via helper call like is_this_last_elem()
> >>>>> or something.
> >>>>
> >>>> Okay, I see what you mean now. Basically this means
> >>>> seq_ops->next() should try to get/maintain next two elements,
> >>>
> >>> What about the case when there are no elements to iterate to begin
> >>> with? In that case, we still need to call bpf_prog for (empty)
> >>> post-aggregation, but we have no valid element... For bpf_map
> >>> iteration we could have fake empty bpf_map that would be passed, but
> >>> I'm not sure it's applicable for any time of object (e.g., having a
> >>> fake task_struct is probably quite a bit more problematic?)...
> >>
> >> Oh, yes, thanks for reminding me of this. I put a call to
> >> bpf_prog in seq_ops->stop() especially to handle no object
> >> case. In that case, seq_ops->start() will return NULL,
> >> seq_ops->next() won't be called, and then seq_ops->stop()
> >> is called. My earlier attempt tries to hook with next()
> >> and then find it not working in all cases.
> >>
> >>>
> >>>> otherwise, we won't know whether the one in seq_ops->show()
> >>>> is the last or not.
> > I think "show()" is convoluted with "stop()/eof()".  Could "stop()/eof()"
> > be its own separate (and optional) bpf_prog which only does "stop()/eof()"?
>
> I thought this before. But user need to write a program instead of
> a simple "if" condition in the main program...
>

I agree with Yonghong, requiring user to check for null is pretty
trivial and verifier can give very clear error message if user didn't
check.
The PTR_TO_BTF_ID_OR_NULL seems useful in general as well, it's an
optional typed input arguments and might be useful in other
situations. Verifier changes don't seem excessive as well.

Having two coupled BPF programs to do single iteration becomes awkward
to manage, will complicate kernel interface (e.g., special variants of
LINK_CREATE and LINK_UPDATE) and libbpf implementation. It's also
going to be harder to replace them atomically. I think overall cons
outweight pros.

As one way to maybe simplify it for users a bit, we can make this
post-aggregation call optional with extra flag on BPF_PROG_LOAD.
Unless extra flag is specified, input arguments can stay PTR_TO_BTF_ID
and we'll just get non-NULL inputs and no "end of iteration" call.
With extra flags, inputs become PTR_TO_BTF_ID_OR_NULL and one extra
call at the end.



> >
> >>>> We could do it in newly implemented
> >>>> iterator bpf_map/task/task_file. Let me check how I could
> >>>> make existing seq_ops (ipv6_route/netlink) works with
> >>>> minimum changes.
