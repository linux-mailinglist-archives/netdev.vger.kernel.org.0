Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F2E23E4FA
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 02:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHGALv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 20:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgHGALv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 20:11:51 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1E1C061574;
        Thu,  6 Aug 2020 17:11:50 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id u43so68711ybi.11;
        Thu, 06 Aug 2020 17:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6nF+lg9+sZfnuLQ2S0g02hlwuHDPZ0B85KBAGgTVQoY=;
        b=VVxjdaL5uzNNRJhRWgtiN4aJSXvOtOnxhEu/KibXe3kgO5pS0Cjm+QaUgu8lfy0eAe
         0YOvW3KoCg6U7vC5rGzJJKLI2Ize9cBfTTgk95/TqdCEIu+7YEkyAXsGK3ILPzWXvAXJ
         wjZV3kLF+jQ+qOZvS8kl4CYkrACONxslyvSPYE04PDPM9JeQuCDEop8fywTUe+WjkQj6
         FUyEDLK4qtlGH7asdr70OhQw+iCYR2+GKnkrI7kMKHCpVpEZ0+/S1TBS3i6uRnq9D5yg
         f1/LEakb+uvXfk5LUIMYTSoE9T2/zaDnhzgFOj0ZTn15ZlmjZPeRYuuv6Z0Tot3EOuI5
         /G8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6nF+lg9+sZfnuLQ2S0g02hlwuHDPZ0B85KBAGgTVQoY=;
        b=Fdt/g9yCUZTpmkzaVx74HJFOCxYOdsNBo5HcmyHPj8MTkJ8kKcoU+7HObIW1pAPGln
         4eL3NLi/CO4exPqdzj/UJt+JDO2CGTt7i+gtDYdcpf1nBSq6dxygNIouGk0HlYLUSbpN
         keJiMrXBRar+wLICGK5NcLU5KMWsbE6/ph5AwAg9N1X5VyMxlKi5KMH62wFo2nTqaPGX
         H8uvM2fTl6ezrvQOUYF7dpgLKwc1//YVbPtzFEF4tBF9DNry+yAeSJkned5lhJ8aNp4b
         nbc7W/RFgAD2P3quj39dmMHynCwieIoT/npqe1pldZA4Fv7OQSGdgmlrRwOdLiq39oaw
         jc+A==
X-Gm-Message-State: AOAM532iE1f521VSv8BIowGZJcgkJqSnl8cjIhOk9BNlMXnJpZMQk7Om
        5zGJKq+VPpXul8UEn88Lt9pNaSMA/cUoL8N5PwL9vg==
X-Google-Smtp-Source: ABdhPJykK5+mSe8sw0aarxVarK7SpW4v0PvEbDTvPO0guCjSAyyfBn+A2KusEvdPXMomqVz+BC7E1DWfnquimikn+30=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr16860896ybm.425.1596759110125;
 Thu, 06 Aug 2020 17:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200804182409.1512434-1-andriin@fb.com> <20200804182409.1512434-8-andriin@fb.com>
 <20200806223033.m5fe4cppxz5t3n54@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaSc=Q9mNhV_UpCKAk5RPQ-AssB4VrmvVy=2a83a5bL9Q@mail.gmail.com> <20200807001003.tf4hv7jw7aiwi3yf@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200807001003.tf4hv7jw7aiwi3yf@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Aug 2020 17:11:39 -0700
Message-ID: <CAEf4BzaY174YV3wwJsYrHG-rYWp-to0DOxj65L7fGB12vWJLtQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 7/9] selftests/bpf: add CO-RE relo test for TYPE_ID_LOCAL/TYPE_ID_TARGET
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 5:10 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Aug 06, 2020 at 04:48:27PM -0700, Andrii Nakryiko wrote:
> > On Thu, Aug 6, 2020 at 3:30 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Aug 04, 2020 at 11:24:07AM -0700, Andrii Nakryiko wrote:
> > > > +
> > > > +SEC("raw_tracepoint/sys_enter")
> > > > +int test_core_type_id(void *ctx)
> > > > +{
> > > > +     struct core_reloc_type_id_output *out = (void *)&data.out;
> > > > +
> > > > +     out->local_anon_struct = bpf_core_type_id_local(struct { int marker_field; });
> > > > +     out->local_anon_union = bpf_core_type_id_local(union { int marker_field; });
> > > > +     out->local_anon_enum = bpf_core_type_id_local(enum { MARKER_ENUM_VAL = 123 });
> > > > +     out->local_anon_func_proto_ptr = bpf_core_type_id_local(_Bool(*)(int));
> > > > +     out->local_anon_void_ptr = bpf_core_type_id_local(void *);
> > > > +     out->local_anon_arr = bpf_core_type_id_local(_Bool[47]);
> > > > +
> > > > +     out->local_struct = bpf_core_type_id_local(struct a_struct);
> > > > +     out->local_union = bpf_core_type_id_local(union a_union);
> > > > +     out->local_enum = bpf_core_type_id_local(enum an_enum);
> > > > +     out->local_int = bpf_core_type_id_local(int);
> > > > +     out->local_struct_typedef = bpf_core_type_id_local(named_struct_typedef);
> > > > +     out->local_func_proto_typedef = bpf_core_type_id_local(func_proto_typedef);
> > > > +     out->local_arr_typedef = bpf_core_type_id_local(arr_typedef);
> > > > +
> > > > +     out->targ_struct = bpf_core_type_id_kernel(struct a_struct);
> > > > +     out->targ_union = bpf_core_type_id_kernel(union a_union);
> > > > +     out->targ_enum = bpf_core_type_id_kernel(enum an_enum);
> > > > +     out->targ_int = bpf_core_type_id_kernel(int);
> > > > +     out->targ_struct_typedef = bpf_core_type_id_kernel(named_struct_typedef);
> > > > +     out->targ_func_proto_typedef = bpf_core_type_id_kernel(func_proto_typedef);
> > > > +     out->targ_arr_typedef = bpf_core_type_id_kernel(arr_typedef);
> > >
> > > bpf_core_type_id_kernel() returns btf_id of the type in vmlinux BTF or zero,
> > > so what is the point of above tests? All targ_* will be zero.
> > > Should the test find a type that actually exists in the kernel?
> > > What am I missing?
> >
> > Probably, that for almost all core_reloc tests, "kernel BTF" comes
> > from specially-crafted BTFs, like btf__core_reloc_type_id*.c for this
> > set of tests. Only one core_reloc sub-test actually loads real kernel
> > BTF, for all others we have a "controlled environment" set up.
>
> ahh. right.
>
> > But on another note. I opted to make all type-based relocations to
> > return 0 if target type is not found, but now I'm thinking that maybe
> > for TYPE_SIZE and TYPE_ID_KERNEL we should fail them, just like
> > field-based ones, if type is not found. Makes it harder to miss that
> > something changed in the new kernel version. WDYT?
>
> makes sense to me. If we ever need non-failing type_id_kernel() we can
> add it later, right?

Right. Plus you can always "guard" it with bpf_core_type_exists()
check, just like we do for field accesses, if the field might not
exist.
