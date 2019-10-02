Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD490C9384
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbfJBVbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:31:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41861 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfJBVbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:31:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so293965pfh.8
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 14:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m5xVHAEIhIAqpO/8qHSF3PHN+LcVgKj3lgSIWUJ6nJU=;
        b=l9SmDi/iJrgkCfuZ6qHcNy5lR3q89uvOm2q697YSOoEQXxF96ZIJm0C8Arq55uTRso
         Jz6n+hl089Z0B5EDvhbTbsa/ufsN5Az3s9OtkAkPOiuc+AkuAta+04f6C89FC9oyYTY2
         RZz4kbOBRe+AgwBJE8J6CD3GG7kFnT/pkn/lVIJ6lh8dNtu+uj+AkbM+80JWHNMabkE/
         GjkXTGmlDbVwf++eEXvl4eL9bKnqXqvMK9vq0m0MsoFR1og8SHyu70Yi2PCGDVwfHJEW
         WQWowSFow+LSCcBdDk96B1fMCmwvZN/WJSFWQ9iq1pywYMM+5AnsqwX/o9CCIemEK9Zq
         S+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m5xVHAEIhIAqpO/8qHSF3PHN+LcVgKj3lgSIWUJ6nJU=;
        b=BABEnY1NF3E+Jay2EujsZV5i4oBk+yYj6MdhBszspy4QsOGV+ce1VkZG6Qb9f8Q7mZ
         sn6k2vjumt/1b78UPM2Cc6un5U2+1SPILpoRDEsjtQlP812HqBLJwYItmfNQbTp6jeNo
         jhuV2wrKvBGwmuPQ8Q+bDADRupXUv7HG3Q7KPB+iHxjMapxU6JeQSrWjYW/erKkV4b6e
         Va/och3bknS1vm0WiCa66MxuqaAazqOpuqBYmIOWbNAc2ZO8cMey2VLex7xSKvB46JII
         7VMwFCtYwbC8uKN2yXhCqKMCQPww0fHPKlsbjOAzFvvfvQXplMAggvpfmIao76qqzmUM
         hfrA==
X-Gm-Message-State: APjAAAWOYlPzACv3NhgyWhxxKC//mLO7J6eBMykrQtvlpgZ8T97uC+Xy
        E3cKiz71MkZ4tbuSSh8q1MsrvA==
X-Google-Smtp-Source: APXvYqxefMrb+WA4AhwWWkXE9kZkzf8l8zTyjo7a9OpMxNiDT7SFCyxx152FrySs3TwCKr1n6UhR0A==
X-Received: by 2002:a17:90a:8002:: with SMTP id b2mr6894567pjn.0.1570051883271;
        Wed, 02 Oct 2019 14:31:23 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id f15sm374729pfd.141.2019.10.02.14.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 14:31:22 -0700 (PDT)
Date:   Wed, 2 Oct 2019 14:31:21 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH bpf-next 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
Message-ID: <20191002213121.GB3223377@mini-arch>
References: <20191002173357.253643-1-sdf@google.com>
 <20191002173357.253643-2-sdf@google.com>
 <CAPhsuW6ywq5yySKjtdna8rXGBWdUyFgxQuy0+=2-gReXSTQ=ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW6ywq5yySKjtdna8rXGBWdUyFgxQuy0+=2-gReXSTQ=ow@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/02, Song Liu wrote:
> On Wed, Oct 2, 2019 at 10:36 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Always use init_net flow dissector BPF program if it's attached and fall
> > back to the per-net namespace one. Also, deny installing new programs if
> > there is already one attached to the root namespace.
> > Users can still detach their BPF programs, but can't attach any
> > new ones (-EPERM).
> >
> > Cc: Petar Penkov <ppenkov@google.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  Documentation/bpf/prog_flow_dissector.rst |  3 +++
> >  net/core/flow_dissector.c                 | 11 ++++++++++-
> >  2 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
> > index a78bf036cadd..4d86780ab0f1 100644
> > --- a/Documentation/bpf/prog_flow_dissector.rst
> > +++ b/Documentation/bpf/prog_flow_dissector.rst
> > @@ -142,3 +142,6 @@ BPF flow dissector doesn't support exporting all the metadata that in-kernel
> >  C-based implementation can export. Notable example is single VLAN (802.1Q)
> >  and double VLAN (802.1AD) tags. Please refer to the ``struct bpf_flow_keys``
> >  for a set of information that's currently can be exported from the BPF context.
> > +
> > +When BPF flow dissector is attached to the root network namespace (machine-wide
> > +policy), users can't override it in their child network namespaces.
> > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > index 7c09d87d3269..494e2016fe84 100644
> > --- a/net/core/flow_dissector.c
> > +++ b/net/core/flow_dissector.c
> > @@ -115,6 +115,11 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
> >         struct bpf_prog *attached;
> >         struct net *net;
> >
> > +       if (rcu_access_pointer(init_net.flow_dissector_prog)) {
> > +               /* Can't override root flow dissector program */
> > +               return -EPERM;
> 
> Maybe -EBUSY is more accurate?
I'm not sure, -EBUSY to me means that I can retry and (maybe) eventually
will succeed. Maybe return -EEXIST? At least it gives a hint that BPF
flow dissector is already there and retrying won't help. Thoughts?

> Thanks,
> Song
