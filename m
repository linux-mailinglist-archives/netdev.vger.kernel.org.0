Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A36740FF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfGXVmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:42:38 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37595 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGXVmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:42:38 -0400
Received: by mail-qk1-f193.google.com with SMTP id d15so34901607qkl.4;
        Wed, 24 Jul 2019 14:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HZecLEH3fh0u72aj+FlumozN0dlA54Qjp5RbC1GUW3M=;
        b=HBb7Sx2nTydx1Xs7au8P9ycmUMfkql/zvOTiHShcK5ySXl29egug2h0oBna8mAYCCe
         aQklM4wML5Pseurf6p9UzQz1elnNjQHQaW5eYCjB1V8SIMOEjgaGXGVEqBq+ppBM75DB
         UyBRbzAKs+8xVzjZPjOI9e2P46yDHDn1145ek0Yo7Snh07RWjcTTKQjiqLeK4ccxHgpp
         HgrFpt5UWXdbzUEIsVNFzfQ+krpZezgVR6GhVOguOnQuJG0zSnbHZfzl7mP7Q4bkV9X0
         kDxnAAGcNIIjUWSOG6vWaS8B7P1H5ziy84hiWzpIMfp+5sNZFinDojqrGCOSUQPUemBg
         bxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HZecLEH3fh0u72aj+FlumozN0dlA54Qjp5RbC1GUW3M=;
        b=Vd+8eHsK+zPUardMtWwEuKRvHW5KwzBTWSOj+FJmhqdrE07rph+HFoYx752hoA2LIg
         qGYpeUvd5K9bF2+mq4T/O3uOaWJFnqXmY8lbWBKwlq2kkoioKORNKlK8YS9JHkdXsC3O
         gEa6FsZriA9N9FGc17gwWW9R2uttlX6gMVrS5eahj4oOvDyRtB9zmaf81vvIaCKP6p0D
         6AfklTypeYbkRrYWuVH5Nl9DR72wWXJyrcbYBBmO+ziI5Y0oSMHm9kEQS0AzKmRZ7bCI
         kOA829HUcOzUtJEtDnXZcNDIwcrL7PhTHdVqxxkPdZCgED55UPJkQX/ZHcUKOpgzIenB
         KTOA==
X-Gm-Message-State: APjAAAWi5FIA+96/w7Pb+cbTI/oQ+xJK4/F3HlbDaBgoWPmtRIJuXdQn
        Id4ZmmRB2/POqHDn0ks//QCrQR9u32vyVmeKad8=
X-Google-Smtp-Source: APXvYqzc56kw32pWlCfAaEqy1DLArh0SSnzsngtqtn8bjTi4909EE7Tcd+aORmBYnpPCcVIbtVLmsQEWW3bbKTPJLu0=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr58952846qke.449.1564004557037;
 Wed, 24 Jul 2019 14:42:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-2-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-2-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Jul 2019 14:42:25 -0700
Message-ID: <CAEf4Bzbrm0mrteuK=jFs6gdfLceMkjLDJ=UhOg1x8JeRfai07A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] libbpf: add .BTF.ext offset relocation
 section loading
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 12:28 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add support for BPF CO-RE offset relocations. Add section/record
> iteration macros for .BTF.ext. These macro are useful for iterating over
> each .BTF.ext record, either for dumping out contents or later for BPF
> CO-RE relocation handling.
>
> To enable other parts of libbpf to work with .BTF.ext contents, moved
> a bunch of type definitions into libbpf_internal.h.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

[...]

> + *
> + * Example to provide a better feel.
> + *
> + *   struct sample {
> + *       int a;
> + *       struct {
> + *           int b[10];
> + *       };
> + *   };
> + *
> + *   struct sample *s = ...;
> + *   int x = &s->a;     // encoded as "0:0" (a is field #0)
> + *   int y = &s->b[5];  // encoded as "0:1:5" (b is field #1, arr elem #5)

This should be "0:1:0:5", actually. Anon struct is field #1 in BTF, b
is field #0 inside that anon struct + array index 5.
Will update it locally and incorporate into next version once the rest
of patch set is reviewed.

> + *   int z = &s[10]->b; // encoded as "10:1" (ptr is used as an array)
> + *
> + * type_id for all relocs in this example  will capture BTF type id of
> + * `struct sample`.
> + *
> + *   [0] https://llvm.org/docs/LangRef.html#getelementptr-instruction
> + */
> +struct bpf_offset_reloc {
> +       __u32   insn_off;
> +       __u32   type_id;
> +       __u32   access_str_off;
> +};
> +
>  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
> --
> 2.17.1
>
