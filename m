Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8CD43E895
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhJ1Sr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhJ1Sr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 14:47:57 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7915BC061570;
        Thu, 28 Oct 2021 11:45:30 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id a129so4592206yba.10;
        Thu, 28 Oct 2021 11:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RWtqEKyHYkFMHQbChIdUju0X/2PuRmrE8NIrll0BanA=;
        b=TGjNzJkZ8nfkjCGtvWxTxHhGzmR+AUHymi3+BUX0kpjLDEoItcrsyKBvo9ilD7VAHC
         H3LaLd9hgf/10g9VVOhBjnqjEu10u6t1J9x+UUTKJcUOpCv+rpi+q8hsVTWc7fInWJJH
         Kiu8RxnhlmYUzz8ESTYT+lmNxuf7IzOQX9T+b+lpXT3AjK6L3RLKiNsNjYBoXTpdeCZ+
         Ve+IzNMKOGH9TUU4mYD8OcVKLtEa08sWgVXFeAs0XB+eb7cJljg8Hc5uPAllYYHbV0GP
         OX2V81d/Cgw9j98PH2YUBxeVJoJ9ou8VrN5tskfeEYlXGhAZMRlJKACTCB130+Mo2uU/
         j2tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RWtqEKyHYkFMHQbChIdUju0X/2PuRmrE8NIrll0BanA=;
        b=vvIgBBR9KqQR+PS0bOaIpDOfc5WIDtQGc6xKjUEJHo3RBTe1FX2wBg51jFW/I+gRwv
         Vz5jKtSmfINxXxW8EW7bpcFOdnDXGz9U2WJWZNEbKOqZ35oimaPeUEqItw5dkQscE6ht
         rAKwY6R86a2IxMrF1AhZ7Va4RbpEH55nJAF3dhrSdwFMXR/DvxxFVQShMjpc73VBQ1vW
         Wc4AKVAGtJDfjoSlzsDbLSA8g6PpAEMWOC2chlgUdixNbfBqA2zln7bQlpNkAfbAEL0h
         CX59PsQmMgbtNWNdZDgUU+TEd7ktEJtG5JxyNpQ0TUpXQMZMhu1pE9IsD1419nL9nUnB
         CVyQ==
X-Gm-Message-State: AOAM531DvCJ3SnDW2kuw7J3U12xTTthl9Ky5GtsmjDVekUKIS9/bPrbW
        F558nBfWPHZx8pBNvIy1+i+CpXGOPqLstAMr+Fzg0KXNyxk=
X-Google-Smtp-Source: ABdhPJwr75zKtVQQd7LZ47LWX9NV+uUMKfiO/u/jSce3KbbUAFljNKNz2/IAc5Oe0ivkBJxUNhvwhbVxlScvYjWK7Fs=
X-Received: by 2002:a25:b19b:: with SMTP id h27mr6937899ybj.225.1635446729749;
 Thu, 28 Oct 2021 11:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <20211027203727.208847-3-mauricio@kinvolk.io>
In-Reply-To: <20211027203727.208847-3-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Oct 2021 11:45:18 -0700
Message-ID: <CAEf4BzYUXYFKyWVbNmfz9Bjui4UytfQs1Qmc24U+bYZwQtRbcw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf: Implement API for generating BTF for
 ebpf objects
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Rafael David Tinoco <rafael.tinoco@aquasec.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 1:37 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> This commit implements a new set of "bpf_reloc_info__" functions for
> generating a BTF file with the types a given set of eBPF objects need
> for their CO-RE relocations. This code reuses all the existing CO-RE
> logic (candidate lookup, matching, etc). The workflow is the same as
> when an eBPF program is being loaded, but instead of patching the eBPF
> instruction, we save the type involved in the relocation.
>
> A new struct btf_reloc_info is defined to save the BTF types needed by a
> set of eBPF objects. It is created with the bpf_reloc_info__new()
> function and populated with bpf_object__reloc_info_gen() for each eBPF
> object, finally the BTF file is generated with
> bpf_reloc_info__get_btf(). Please take at a look at BTFGen[0] to get a
> complete example of how this API can be used.
>
> bpf_object__reloc_info_gen() ends up calling btf_reloc_info_gen_field()
> that uses the access spec to add all the types needed by a given
> relocation. The root type is added and, if it is a complex type, like a
> struct or union, the members involved in the relocation are added as
> well. References are resolved and all referenced types are added. This
> function can be called multiple times to add the types needed for
> different objects into the same struct btf_reloc_info, this allows the
> user to create a BTF file that contains the BTF information for multiple
> eBPF objects.
>
> The bpf_reloc_info__get_btf() generates the BTF file from a given struct
> btf_reloc_info. This function first creates a new BTF object and copies
> all the types saved in the struct btf_reloc_info there. For structures
> and unions, only the members involved in a relocation are copied. While
> adding the types to the new BTF object, a map is filled with the type
> IDs on the old and new BTF structures.  This map is then used later on
> to fix all the IDs in the new BTF object.
>
> Right now only support for field based CO-RE relocations is supported.
>
> [0]: https://github.com/kinvolk/btfgen
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> ---

I don't think it's necessary for libbpf to expose all these new APIs.
The format of CO-RE relocations and .BTF.ext is open and fixed. You
don't really need to simulate full CO-RE relocation logic to figure
out which types are necessary. Just go over all .BTF.ext records for
CO-RE relocations, parse spec (simple format as well) and see which
fields are accessed. The only extra bit is ignoring ___<suffix>,
that's it. bpftool (or whatever other tool that's going to be used for
this) can do that on its own by using existing libbpf APIs to work
with BTF. Good bit of optimization would be to only emit forward
declarations for structs that are never used, but are referenced by
structs that are used.

Either way, this is not libbpf's problem to solve. It's a tooling problem.


>  tools/lib/bpf/Makefile    |   2 +-
>  tools/lib/bpf/libbpf.c    |  28 ++-
>  tools/lib/bpf/libbpf.h    |   4 +
>  tools/lib/bpf/libbpf.map  |   5 +
>  tools/lib/bpf/relo_core.c | 514 +++++++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/relo_core.h |  11 +-
>  6 files changed, 554 insertions(+), 10 deletions(-)
>

[...]
