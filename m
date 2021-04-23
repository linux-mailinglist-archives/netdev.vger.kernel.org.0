Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B12369C1C
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbhDWVk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDWVkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 17:40:24 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29738C061574;
        Fri, 23 Apr 2021 14:39:46 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id q192so3618810ybg.4;
        Fri, 23 Apr 2021 14:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y20H1hcXw5NLpPWF3SrqvIhtpy0uh9xGzSSIElxTLGY=;
        b=sxA1i/1OL/y9hu9rxlESTSTc2K9tYasTSkqiEtG0dx3BRibsmfAX/Y8uIV1VKoCYt8
         9ib3Gj6mRFqoC2yXzpLs4hCwoXkRpMslxYeHbN5ut8iIgn8EOUi6bOQoR9gapIkt9ACp
         CJjfXZT5/mmXTRcuv31AssoDjwMdTGli9CXzcrjEoXT1AkXWq6dyhknli/GejAWobVoh
         R93NOeuRejdapMUEv8Am3n1U5FNwI2zXY+zulevy+vv7eHYJo1J6Brz5JPm0hhOV2EAU
         MP7aytfarUMpTLKM1wpMiubDTFWH4XnNUXI5+avYMVyxYsiSnb7m8CI+2/mYJKnQAC10
         gGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y20H1hcXw5NLpPWF3SrqvIhtpy0uh9xGzSSIElxTLGY=;
        b=SQY/7Mm/XOzGvfjxvpjTmqupCAppe+NgD6izVe6L4gI/Kkc53RnXx0mDTVXjFpgKQm
         myckLW2J4tOsQRJWDJs5seYXvPRmKqLo8Z0SkR7qAGf+r8gEnWMzBpNHf6YYX5yk42jt
         ao3iG8aiye23KYDhhk+iJZvT0ShS8LyFYZ7flwiu7RYO3yBb7laa1jxrAtYr4cq2CK+r
         6OepdWSif7e7qv06qa/F6U2uJcqTWDMYPVdFoWAxQKV5nvZ2eyrtdlH3kPZ+GgZD0J1g
         kJSUBrIEx6MaiTffkZkHN8TLKFKtMO07eHwL/ZT2Nz+CI8Z3WWXfT6M81e7PB78ayOhG
         0Mpg==
X-Gm-Message-State: AOAM533GUJUcvXdnO+cZZoLENFw6VhKGQ7wuZ7SLx8HwpmIkydoBgeI+
        gIEUs2fOzPy5eBWN2UV1V17iadk4tnCvEysZcjg=
X-Google-Smtp-Source: ABdhPJxDX0bKKe7uOox0/D4O5ImURhyu8ycfC3Ik40ZeBJj3X92xzZ/sjKOdZ8Azkt15PXB1h69BUpCcfm+eazJY5pw=
X-Received: by 2002:a25:3357:: with SMTP id z84mr8263467ybz.260.1619213985497;
 Fri, 23 Apr 2021 14:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210423181348.1801389-1-andrii@kernel.org> <20210423181348.1801389-18-andrii@kernel.org>
 <5d96d205-1483-95a4-dc36-798fef934f72@fb.com> <CAADnVQ+20NcPHKYyMpAYr6SQ2fuvr4yqu5eiY90hL8J9-t1L9w@mail.gmail.com>
In-Reply-To: <CAADnVQ+20NcPHKYyMpAYr6SQ2fuvr4yqu5eiY90hL8J9-t1L9w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Apr 2021 14:39:34 -0700
Message-ID: <CAEf4BzbRH-5-1MVtEnfLKOMO4f2sVFrdROBLTBT8GrESs1p1XQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 17/18] selftests/bpf: add map linking selftest
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 2:23 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 23, 2021 at 11:54 AM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 4/23/21 11:13 AM, Andrii Nakryiko wrote:
> > > Add selftest validating various aspects of statically linking BTF-defined map
> > > definitions. Legacy map definitions do not support extern resolution between
> > > object files. Some of the aspects validated:
> > >    - correct resolution of extern maps against concrete map definitions;
> > >    - extern maps can currently only specify map type and key/value size and/or
> > >      type information;
> > >    - weak concrete map definitions are resolved properly.
> > >
> > > Static map definitions are not yet supported by libbpf, so they are not
> > > explicitly tested, though manual testing showes that BPF linker handles them
> > > properly.
> > >
> > > Acked-by: Yonghong Song <yhs@fb.com>
> > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > [...]
> > > +
> > > +SEC("raw_tp/sys_exit")
> > > +int BPF_PROG(handler_exit1)
> > > +{
> > > +     /* lookup values with key = 2, set in another file */
> > > +     int key = 2, *val;
> > > +     struct my_key key_struct = { .x = 2 };
> > > +     struct my_value *value_struct;
> > > +
> > > +     value_struct = bpf_map_lookup_elem(&map1, &key_struct);
> > > +     if (value_struct)
> > > +             output_first1 = value_struct->x;
> > > +
> > > +     val = bpf_map_lookup_elem(&map2, &key);
> > > +     if (val)
> > > +             output_second1 = *val;
> > > +
> > > +     val = bpf_map_lookup_elem(&map_weak, &key);
> > > +     if (val)
> > > +             output_weak1 = *val;
> > > +
> >
> > There is an extra tab in the above line. There is no need for new
> > revision just for this. If no new revision is needed, maybe
> > the maintainer can help fix it.
>
> Sorry. I applied without it. Pls fold the fix in some of the future patches.

Ok, no problem, I'll do it in v3 of statics support patch set.
