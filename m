Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07D65AFB98
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 07:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiIGFPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 01:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIGFPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 01:15:41 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2956F555;
        Tue,  6 Sep 2022 22:15:40 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l14so4325886eja.7;
        Tue, 06 Sep 2022 22:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=j+gF2bUdw4ITHGeuOAn3Q2fblVykEdsAK30iGjvCAVE=;
        b=H0NBzFnfCondXQal0g4/vI4B8E19WEXfXFzHB9S2KIh4Y40ynRBpNhJ7nJZDNhLoqW
         WVTcWN19+OM4LnBzGOXD2c6rCIR5Ltbs6EVIOPQlJ0Kztj1I4w6uOdXCioIK5ER3ZYTl
         KrCfH8cullvGLwFNMxdR0Z4r9Ero6j79DxmEtzuSEye0TosR61ANoK3lNvXDzhvZOEXy
         GerrXQ4MLUUOspAgBj0VzJV27+HkRPQ7Z6bX4iCgE6UfZinXWPPc7DtouBy6ZXuyZM7S
         ycfDaWynccnL8dtlgMkUiPLmjCzyBm6hwZvJp4328dRAVAg8DI/BvNca51XpxqCfDOeM
         ucuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=j+gF2bUdw4ITHGeuOAn3Q2fblVykEdsAK30iGjvCAVE=;
        b=VIlC00RcraoTn2DO3sm1R+lm973p1Oh/PEWrK5P8oQxyyX3YokJQ/mn+Ln0+KZ3cJP
         mdgNTr/Ac4rdLnL8IuWdawc6IAKjvB+IvE3sRTK0BT/a3IAoAWmRlA3Du2ORYMtjNtEk
         rCRN+mQWBOhiOdBys43qLJQRTNMlrutm+gih2zDdLva4e/Nwuo+JP6eqUVX1fvhJ0m9t
         c+CWYuui51Tr5ZJyKn5PQtt9IRHjSwkhFkXMDY1SLGX4P8I2nFXoFefuWO8CiL4nq/f3
         yrL1vh79+eYAwoAgVLbyfQ+Vk79FXGdzsEQWtEhWuW7ZAr9mDvJEGiFDeLPTyFBe6Ftj
         5d+Q==
X-Gm-Message-State: ACgBeo143pgyt1XvmTpF3zhIcykswT+LIGcNvRuyS9zVWWPnf+4epcRc
        Z54m25DiHNaCHOr0YKe4ku0pSAfuO9JvmgA7T9k=
X-Google-Smtp-Source: AA6agR5Y9xApB8c6DhmDhMDqodjtZVDSPB0Oy8CfE3YZ77w+lxLy8OTqIFDJaADHnjXzBURk9Opg0gqaLuIezBff6I8=
X-Received: by 2002:a17:906:847c:b0:73f:d7cf:bf2d with SMTP id
 hx28-20020a170906847c00b0073fd7cfbf2dmr1128579ejc.327.1662527738806; Tue, 06
 Sep 2022 22:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662383493.git.lorenzo@kernel.org> <fa02d93153b99bc994215c1644a2c75a226e3c7d.1662383493.git.lorenzo@kernel.org>
 <CAADnVQJ4XtFpsEsPRC-cepfQvXr-hN7e_3L5SchieeGHH40_4A@mail.gmail.com> <CAP01T77BuY9VNBVt98SJio5D2SqkR5i3bynPXTZG4VVUng-bBA@mail.gmail.com>
In-Reply-To: <CAP01T77BuY9VNBVt98SJio5D2SqkR5i3bynPXTZG4VVUng-bBA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Sep 2022 22:15:27 -0700
Message-ID: <CAADnVQJ7PnY+AQmyaMggx6twZ5a4bOncKApkjhPhjj2iniXoUQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] net: netfilter: add bpf_ct_set_nat_info
 kfunc helper
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

On Tue, Sep 6, 2022 at 9:40 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> On Wed, 7 Sept 2022 at 06:27, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Sep 5, 2022 at 6:14 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > +int bpf_ct_set_nat_info(struct nf_conn___init *nfct__ref,
> > > +                       union nf_inet_addr *addr, __be16 *port,
> > > +                       enum nf_nat_manip_type manip)
> > > +{
> > ...
> > > @@ -437,6 +483,7 @@ BTF_ID_FLAGS(func, bpf_ct_set_timeout, KF_TRUSTED_ARGS)
> > >  BTF_ID_FLAGS(func, bpf_ct_change_timeout, KF_TRUSTED_ARGS)
> > >  BTF_ID_FLAGS(func, bpf_ct_set_status, KF_TRUSTED_ARGS)
> > >  BTF_ID_FLAGS(func, bpf_ct_change_status, KF_TRUSTED_ARGS)
> > > +BTF_ID_FLAGS(func, bpf_ct_set_nat_info)
> > >  BTF_SET8_END(nf_ct_kfunc_set)
> >
> > Instead of __ref and patch 1 and 2 it would be better to
> > change the meaning of "trusted_args".
> > In this case "addr" and "port" are just as "trusted".
> > They're not refcounted per verifier definition,
> > but they need to be "trusted" by the helper.
> > At the end the "trusted_args" flags would mean
> > "this helper can assume that all pointers can be safely
> > accessed without worrying about lifetime".
>
> So you mean it only forces PTR_TO_BTF_ID to have reg->ref_obj_id > 0?
>
> But suppose in the future you have a type that has scalars only.
>
> struct foo { int a; int b; ... };
> Just data, and this is acquired from a kfunc and released using another kfunc.
> Now with this new definition you are proposing, verifier ends up
> allowing PTR_TO_MEM to also be passed to such helpers for the struct
> foo *.
>
> I guess even reg->ref_obj_id check is not enough, user may also pass
> PTR_TO_MEM | MEM_ALLOC which can be refcounted.
>
> It would be easy to forget such subtle details later.

It may add headaches to the verifier side, but here we have to
think from pov of other subsystems that add kfuncs.
They shouldn't need to know the verifier details.
The internals will change anyway.
Ideally KF_TRUSTED_ARGS will become the default flag that every kfunc
will use to indicate that the function assumes valid pointers.
How the verifier recognizes them is irrelevant from kfunc pov.
People that write bpf progs are not that much different from
people that write kfuncs that bpf progs use.
Both should be easy to write.
