Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52166479F2A
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 05:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbhLSEil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 23:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhLSEil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 23:38:41 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26C8C061574;
        Sat, 18 Dec 2021 20:38:40 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id v11so2563670pfu.2;
        Sat, 18 Dec 2021 20:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CyVX44rZRXmkE2QJPrMnFdRh7JMTe3PgNXccvLeTHAE=;
        b=JEarcMq4+naSsYS8scMWhRkVJBVS1bElyBxlOuKkeJVzCN/j3lO/uBqI8T+q4GvTx/
         hIUP+vMfvQpTg0kCZfKW9c8X5tpEBm1E3yLc9PcryZwBHXa0Dg+pISvh2C6SekgrShHP
         uyc4OqoQncAiy9K/f7HSuFN3uz1I0DQC6h/DvL3tp3i0iL5yf2ELA1pl0fAkgjmvQ79b
         0gwLAM4SIZZkjVUp5BY6ESOAz+tjp65QM9B2zIUEdLwHX2ejhUVSTR1yCbdLdLCnLeZI
         2fDAaaBBNMz34pCG11aUF8fWAE+SCqaFAOVj9nzxK2p0HtxENpqsPd3q3dbwF+9ObUlN
         8xIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CyVX44rZRXmkE2QJPrMnFdRh7JMTe3PgNXccvLeTHAE=;
        b=p9+bcY3xqWRG/k62+V1mcW0uuLDKp4ghAKCAQmTm5v9kvcusKS8uOF2QAz36lnn/RD
         kWfOz6dixEP/YhbOpR/XuuWvL4diJ+V+Se7bQ4n/JWRz0lLeMS+6mLCCcxxXsVhWak56
         XNEOoy7OyEWhqNA8uSgHqu0Sy+NtDBsgJLVSc0SW5zltXvM6CLNVo3Fqueu1k25xRDKf
         qEMELEAkLye1dFxm9u2IR7DNyYPubpjnq0YYyk4lym/uSd77HhUP3y9zZvxjwwjdpABg
         gRzL3Uh1I0ls5XjWgiyGaNhgq6VQ/WYL1efMgd8+Egu9fCF7y7gqG5g3ZaiFchyH1INs
         mUQg==
X-Gm-Message-State: AOAM533lt+u6QdPavgqDU02oPRqvWKa4PEWdmWAjErV5RKxaEWEdH2dA
        MxHJHcFmmA7zM/3ZrxcDpEs=
X-Google-Smtp-Source: ABdhPJwGpJMYJHGkI9Eh1JwsSFuZoWpKIDvsold7uDTeDuj9csskesmPTj/Z1Svi3YyYk9YZ5XyEWw==
X-Received: by 2002:a63:6c81:: with SMTP id h123mr9670715pgc.313.1639888720002;
        Sat, 18 Dec 2021 20:38:40 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id x1sm12555308pgh.1.2021.12.18.20.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 20:38:39 -0800 (PST)
Date:   Sun, 19 Dec 2021 10:08:37 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 05/10] bpf: Add reference tracking support to
 kfunc
Message-ID: <20211219043837.27p3zvtdpozs7ep4@apollo.legion>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-6-memxor@gmail.com>
 <20211219022248.6hqp64a4nbhyyxeh@ast-mbp>
 <20211219030128.2s23lzhup6et4rsu@apollo.legion>
 <CAADnVQLz_JK6=6V=iVpT2BQKcKCSvOmJy6-KbTdMnbxBKu0EAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLz_JK6=6V=iVpT2BQKcKCSvOmJy6-KbTdMnbxBKu0EAg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 09:24:37AM IST, Alexei Starovoitov wrote:
> On Sat, Dec 18, 2021 at 7:01 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Sun, Dec 19, 2021 at 07:52:48AM IST, Alexei Starovoitov wrote:
> > > On Fri, Dec 17, 2021 at 07:20:26AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index 965fffaf0308..015cb633838b 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -521,6 +521,9 @@ struct bpf_verifier_ops {
> > > >                              enum bpf_access_type atype,
> > > >                              u32 *next_btf_id);
> > > >     bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
> > > > +   bool (*is_acquire_kfunc)(u32 kfunc_btf_id, struct module *owner);
> > > > +   bool (*is_release_kfunc)(u32 kfunc_btf_id, struct module *owner);
> > > > +   bool (*is_kfunc_ret_type_null)(u32 kfunc_btf_id, struct module *owner);
> > >
> > > Same feedback as before...
> > >
> > > Those callbacks are not necessary.
> > > The existing check_kfunc_call() is just as inconvenient.
> > > When module's BTF comes in could you add it to mod's info instead of
> > > introducing callbacks for every kind of data the module has.
> > > Those callbacks don't server any purpose other than passing the particular
> > > data set back. The verifier side should access those data sets directly.
> >
> > Ok, interesting idea. So these then go into the ".modinfo" section?
>
> It doesn't need to be a special section.
> The btf_module_notify() parses BTF.
> At the same time it can add a kfunc whitelist to "struct module".
> The btf_ids[ACQUIRE/RELEASE][] arrays will be a part of
> the "struct module" too.
> If we can do a btf name convention then this job can be
> performed generically by btf_module_notify().
> Otherwise __init of the module can populate arrays in "struct module".
>

Nice idea, I think this is better than what I am doing (it also prevents
constant researching into the list).

But IIUC I think this btf_ids array needs to go into struct btf instead,
since if module is compiled as built-in, we will not have any struct module for
it.

Then we can concatenate all sets of same type (check/acquire/release etc.) and
sort them to directly search using a single btf_id_set_contains call, the code
becomes same for btf_vmlinux or module btf. struct module is not needed anymore.

WDYT?

> > I think then
> > we can also drop the check_kfunc_call callback?
>
> Right. Would be great to remove that callback too.

Ok, will do.

--
Kartikeya
