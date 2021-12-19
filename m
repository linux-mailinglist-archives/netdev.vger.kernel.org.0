Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FBF479F09
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 05:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbhLSDyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 22:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhLSDyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 22:54:49 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDF8C061574;
        Sat, 18 Dec 2021 19:54:48 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id m24so5283492pls.10;
        Sat, 18 Dec 2021 19:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zqlb4HpmQNg7uqO0QG2AmsmTLWjY8JeQizPCAlzzm5s=;
        b=ZV7l6aHmQ5QfFKn8mbk6Bh7lGwbc/l7bhuiV++d8H0hXEevINVECFmlacUy666K+zB
         cMy8YcijQ+fdMqxCHvoEU1Y2/lE2JdXxXxJZCbJUQ0PLEzVxKlHKimY2SyQToOlyvpE3
         EIAdzkdKXSUekodbbtwHQDyQD+GRqpZPhLxFK5HIzJArXdhrj/TKgoNIWLpGZySIbP2v
         ME/BnVbLJOHpiHlZbBdkAXhCyiiyoifC2N0NBOPXBjq/phIpIKfH2Y/tbTJx0wcw7jUX
         lNRb2WSZnHeL6zTMxluhwJd+6iP3No27SbHaMEmnr5rpL74y0eNJLMnS5BY4hM2l5Odo
         2FWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zqlb4HpmQNg7uqO0QG2AmsmTLWjY8JeQizPCAlzzm5s=;
        b=Qo3cuqBm1aTyLPtb5ft6f2zJ295z/BpN70aiRq9bCqALP4KwUE5Fv5XR/wRbbX3cKy
         1xBWOG/TzDdJOvWKuL3JcENA7KFXhK4jpfXNYIzOzJU2zPjQsZwYeTnG+imOAtaMzPdE
         2NzH4qYtAjONadZ23RwDXsmWlADx4XPWeQvN8gpHGQc2Ri0+Egyo4DeaZK/Ga4MZsH//
         J1d4IvrOXhSQtG/asHNW1qBWAB1GMZZiISyMYqmoPwdkOiT/Szmv09jtXhK0R5e2uUx8
         oBuHCjtXo8sUSFKzplf5ALzgBl3zmZvW7rdAibIH6XmdR4YUgS8WhR7xkTBrwNRjO1Fm
         0thA==
X-Gm-Message-State: AOAM530KAaj0OeH3ygmRm2Vq0X8R6ikUIo6P3CW812Tp3xPB6UvSli2X
        j3kl4d14E3BIyspvYGqZMRoah1ExEPeKxQYD5lg=
X-Google-Smtp-Source: ABdhPJyyhgaUN0Iw4t+qnvoOVxmpJHckkv9SAP/ItVHoXI6gFHEOMImlmQY7eu/PC5VSmArz38d3p0+6zg4DpRfv+GU=
X-Received: by 2002:a17:90b:798:: with SMTP id l24mr20744114pjz.122.1639886088327;
 Sat, 18 Dec 2021 19:54:48 -0800 (PST)
MIME-Version: 1.0
References: <20211217015031.1278167-1-memxor@gmail.com> <20211217015031.1278167-6-memxor@gmail.com>
 <20211219022248.6hqp64a4nbhyyxeh@ast-mbp> <20211219030128.2s23lzhup6et4rsu@apollo.legion>
In-Reply-To: <20211219030128.2s23lzhup6et4rsu@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 18 Dec 2021 19:54:37 -0800
Message-ID: <CAADnVQLz_JK6=6V=iVpT2BQKcKCSvOmJy6-KbTdMnbxBKu0EAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 05/10] bpf: Add reference tracking support to kfunc
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 7:01 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sun, Dec 19, 2021 at 07:52:48AM IST, Alexei Starovoitov wrote:
> > On Fri, Dec 17, 2021 at 07:20:26AM +0530, Kumar Kartikeya Dwivedi wrote:
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 965fffaf0308..015cb633838b 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -521,6 +521,9 @@ struct bpf_verifier_ops {
> > >                              enum bpf_access_type atype,
> > >                              u32 *next_btf_id);
> > >     bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
> > > +   bool (*is_acquire_kfunc)(u32 kfunc_btf_id, struct module *owner);
> > > +   bool (*is_release_kfunc)(u32 kfunc_btf_id, struct module *owner);
> > > +   bool (*is_kfunc_ret_type_null)(u32 kfunc_btf_id, struct module *owner);
> >
> > Same feedback as before...
> >
> > Those callbacks are not necessary.
> > The existing check_kfunc_call() is just as inconvenient.
> > When module's BTF comes in could you add it to mod's info instead of
> > introducing callbacks for every kind of data the module has.
> > Those callbacks don't server any purpose other than passing the particular
> > data set back. The verifier side should access those data sets directly.
>
> Ok, interesting idea. So these then go into the ".modinfo" section?

It doesn't need to be a special section.
The btf_module_notify() parses BTF.
At the same time it can add a kfunc whitelist to "struct module".
The btf_ids[ACQUIRE/RELEASE][] arrays will be a part of
the "struct module" too.
If we can do a btf name convention then this job can be
performed generically by btf_module_notify().
Otherwise __init of the module can populate arrays in "struct module".

> I think then
> we can also drop the check_kfunc_call callback?

Right. Would be great to remove that callback too.
