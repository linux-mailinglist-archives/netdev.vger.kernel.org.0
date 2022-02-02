Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9ED4A7B56
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 23:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347963AbiBBWz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 17:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiBBWz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 17:55:56 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A902C061714;
        Wed,  2 Feb 2022 14:55:56 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id p63so964970iod.11;
        Wed, 02 Feb 2022 14:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OELsvASIYn9h/x+6wF74orkFSnnpzIluI7lMFjvz9lk=;
        b=pO96Voi42cmdwTYhFLcsQWHVfmaPBQiAZyaxGi/wASIHvnlPR5HptbsEUBdeJRuSkP
         jvlhcMmYuCc/6vjiVKzf1loJFBd0PiBfaMP+9qd24CvjpWT9w4N8lSXtQZN6AAxI9Ttc
         yg8R8iUB6Q9wx6+cd7LqQjDwm8nePJKU0Qrzk3UE0USWJozTFZ9JCleB8+6PY6QcqoTT
         UQ2Xk8qki5XkkxIlR7l39ERPYNvgNTC0mJoe9ZsJZWHAXhuCU8eepeKLNRLVb44OJLV8
         MmlYMOv5AjOKGVmsNmP+CmOW8ezt0iyJaODAtBckB9Lv6reA1/pcgMleifZasFXulEIE
         jyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OELsvASIYn9h/x+6wF74orkFSnnpzIluI7lMFjvz9lk=;
        b=jEu4Vc2D4+PXqzP/Ok2ctMUY2oEsO5ou+LCftDMyG7p0kwj0k8ohAc5v/25psJzcwc
         mo8WTvV8Z+rV+Wvxo7rzVQVu68otyFFvfDd4A+F2g5Cf424+I2KyZTC3Yc6+CNd+wmSO
         HCKrUdE8mvp2HRgZI9C0V+TOnF+63HN8Wh0zoQ5zZlBF9TQBvDYtsNfDlb7eKD8iZj3I
         /hudV4x6lwasXHCitp4gzQ9fRr8Ezvs4BrbBKKY5FqnAp6M0ZZI2cVYFbHIZgcixCAsi
         iiJH+WlPHNxdztlnFUis9/GHKqK39T3YYsoOLioZ9cQd5cMOG4MANA3Ut8MIM5P7b2hp
         PftA==
X-Gm-Message-State: AOAM532UR0y8zaIFwxJvJKuPTgbYkdekgSUqFFSW5kY9Aom6Q8h/5Pn2
        +jwmHOnbp/RCEk+4AUCBOVbZy//2AvGxBQF9qj0=
X-Google-Smtp-Source: ABdhPJzGPTAtzeGMnYQuU7H2jOSu82sC2PPZ2jXKy0ZE1LZOy4N4yux1KOkbkPqkQnbsKHaygQdF/ZgicbcCa0Zwvzw=
X-Received: by 2002:a5e:8406:: with SMTP id h6mr17423704ioj.144.1643842556004;
 Wed, 02 Feb 2022 14:55:56 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-7-mauricio@kinvolk.io>
In-Reply-To: <20220128223312.1253169-7-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Feb 2022 14:55:44 -0800
Message-ID: <CAEf4BzZ33dhRcySttxSJ6BA-1pCkbebEksLVa-cR08W=YV6x=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 6/9] bpftool: Implement relocations recording
 for BTFGen
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> This commit implements the logic to record the relocation information
> for the different kind of relocations.
>
> btfgen_record_field_relo() uses the target specification to save all the
> types that are involved in a field-based CO-RE relocation. In this case
> types resolved and added recursively (using btfgen_put_type()).
> Only the struct and union members and their types) involved in the
> relocation are added to optimize the size of the generated BTF file.
>
> On the other hand, btfgen_record_type_relo() saves the types involved in
> a type-based CO-RE relocation. In this case all the members for the
> struct and union types are added. This is not strictly required since
> libbpf doesn't use them while performing this kind of relocation,
> however that logic could change on the future. Additionally, we expect
> that the number of this kind of relocations in an BPF object to be very
> low, hence the impact on the size of the generated BTF should be
> negligible.
>
> Finally, btfgen_record_enumval_relo() saves the whole enum type for
> enum-based relocations.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---

I've been thinking about this in background. This proliferation of
hashmaps to store used types and their members really adds to
complexity (and no doubt to memory usage and CPU utilization, even
though I don't think either is too big for this use case).

What if instead of keeping track of used types and members separately,
we initialize the original struct btf and its btf_type, btf_member,
btf_enum, etc types. We can carve out one bit in them to mark whether
that specific entity was used. That way you don't need any extra
hashmap maintenance. You just set or check bit on each type or its
member to figure out if it has to be in the resulting BTF.

This can be highest bit of name_off or type fields, depending on
specific case. This will work well because type IDs never use highest
bit and string offset can never be as high as to needing full 32 bits.

You'll probably want to have two copies of target BTF for this, of
course, but I think simplicity of bookkeeping trumps this
inefficiency. WDYT?

>  tools/bpf/bpftool/gen.c | 260 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 257 insertions(+), 3 deletions(-)
>

[...]
