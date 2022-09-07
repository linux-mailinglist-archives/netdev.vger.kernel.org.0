Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE2C5AFB62
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 06:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiIGEkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 00:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIGEkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 00:40:24 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3F379696;
        Tue,  6 Sep 2022 21:40:23 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id b142so10581636iof.10;
        Tue, 06 Sep 2022 21:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ezEF7w9zA4BskPFGEFST9mSunblExENcllbswNMRyQ0=;
        b=ipxNK+QHBnNovNqYPkwGzoZgpUIlGqqS6mZan3rl/3fQErwYZn+YzW36GxxuFtIJUV
         pjN64IQC1vbqJKy5EE/FHXo+nggdCF6A4dBsmkeCsu3TrwYh4q89GzeJ3WnMKcc5paEM
         1h0xobosYZR/PLcnQiu9VVzATbS/r/IMOJjj96v5cjFG2kw2xtZdkxf063G2Mjv+CZ3i
         Scu2ytXVhZR9c/X7V+BGlcblzYQlfM7UAlw7zXV7UAkSzf0hJkNVIH7I/+tuh7BvNfWS
         MW9CNnSenXJkzuSkUOJ3KAX4zYK4NOhhbYxZ13yIa4IBgS5GTTLF8Q6a5NR0ScO/awzg
         e9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ezEF7w9zA4BskPFGEFST9mSunblExENcllbswNMRyQ0=;
        b=sRjTnyJtzbSuqIwpfLN0vtD63wkRYMTFjEScn3Pitv8s9uQXC+zw2/AFdgwBrW2DLs
         9Jf6B9jD1apgEkXFe9J0n+ToFbdBlLpIAXsDm6yWmAWU/24rADULtnOeU5+Vd3zinZI+
         xsTObtYxwaA0KUmoS5Mj1OzB32kutS6kSa93/rr4ahpvOCOJ60qE117amcfKC6Zree9+
         PMzIMM4aIT0z8xaEN641b0efOcuCfFyFHOlYX/SDpCKnss9z2MlZUmhWe6mN/vhhjSqe
         leJMP1WaLKLHJyfITw2NGUUbiCUhakWClV34Na22FdWSXBvoKOMxnO9Ec0uk2I/pqlai
         xrwA==
X-Gm-Message-State: ACgBeo3cLxA1ONNeN18XZ2KbZSx/8W989NdJXZcOOUVK2C3VzVG0XgoN
        MpsIH1iqCK8Ld8r1XuHtofHCa2CfuMm4zonsD+U=
X-Google-Smtp-Source: AA6agR42Ok66O+Vxz9+NO9Hbdw7oExuu+zdXGqK4W7/X7TuOEoAKCnMz0d31bY4jWWb3FVWPUJO0hhNITOg9TfTrw1k=
X-Received: by 2002:a05:6638:16cf:b0:34a:263f:966d with SMTP id
 g15-20020a05663816cf00b0034a263f966dmr1061294jat.124.1662525622665; Tue, 06
 Sep 2022 21:40:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662383493.git.lorenzo@kernel.org> <fa02d93153b99bc994215c1644a2c75a226e3c7d.1662383493.git.lorenzo@kernel.org>
 <CAADnVQJ4XtFpsEsPRC-cepfQvXr-hN7e_3L5SchieeGHH40_4A@mail.gmail.com>
In-Reply-To: <CAADnVQJ4XtFpsEsPRC-cepfQvXr-hN7e_3L5SchieeGHH40_4A@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 7 Sep 2022 06:39:45 +0200
Message-ID: <CAP01T77BuY9VNBVt98SJio5D2SqkR5i3bynPXTZG4VVUng-bBA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] net: netfilter: add bpf_ct_set_nat_info
 kfunc helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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

On Wed, 7 Sept 2022 at 06:27, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Sep 5, 2022 at 6:14 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > +int bpf_ct_set_nat_info(struct nf_conn___init *nfct__ref,
> > +                       union nf_inet_addr *addr, __be16 *port,
> > +                       enum nf_nat_manip_type manip)
> > +{
> ...
> > @@ -437,6 +483,7 @@ BTF_ID_FLAGS(func, bpf_ct_set_timeout, KF_TRUSTED_ARGS)
> >  BTF_ID_FLAGS(func, bpf_ct_change_timeout, KF_TRUSTED_ARGS)
> >  BTF_ID_FLAGS(func, bpf_ct_set_status, KF_TRUSTED_ARGS)
> >  BTF_ID_FLAGS(func, bpf_ct_change_status, KF_TRUSTED_ARGS)
> > +BTF_ID_FLAGS(func, bpf_ct_set_nat_info)
> >  BTF_SET8_END(nf_ct_kfunc_set)
>
> Instead of __ref and patch 1 and 2 it would be better to
> change the meaning of "trusted_args".
> In this case "addr" and "port" are just as "trusted".
> They're not refcounted per verifier definition,
> but they need to be "trusted" by the helper.
> At the end the "trusted_args" flags would mean
> "this helper can assume that all pointers can be safely
> accessed without worrying about lifetime".

So you mean it only forces PTR_TO_BTF_ID to have reg->ref_obj_id > 0?

But suppose in the future you have a type that has scalars only.

struct foo { int a; int b; ... };
Just data, and this is acquired from a kfunc and released using another kfunc.
Now with this new definition you are proposing, verifier ends up
allowing PTR_TO_MEM to also be passed to such helpers for the struct
foo *.

I guess even reg->ref_obj_id check is not enough, user may also pass
PTR_TO_MEM | MEM_ALLOC which can be refcounted.

It would be easy to forget such subtle details later.

What we want to actually force here is 'please give me refcounted
PTR_TO_BTF_ID to foo'.
So maybe KF_TRUSTED_ARGS should change meaning to what you described,
and then a __btf tag should force PTR_TO_BTF_ID.
KF_TRUSTED_ARGS then just forces reg->ref_obj_id for PTR_TO_BTF_ID.
