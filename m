Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02A76F2007
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 23:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345449AbjD1VSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 17:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjD1VSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 17:18:50 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C06211C;
        Fri, 28 Apr 2023 14:18:49 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94f7a0818aeso40902966b.2;
        Fri, 28 Apr 2023 14:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682716728; x=1685308728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0yu+PGePfgOn7Dr4AaCeHmSNPX477Sl7q4z5WfJr3k=;
        b=B8TOc+pJlAYzkk1X3X96kUHA7doLFTW8l7DDb0fWE61FFxKOCBtIs6FlSlNNP392XK
         fP//IiGiq09fSmTprEuBnP1SDj6I5TSnFA79QXWm4Mvh9cs8jdzdMlh3vS/bff9o9d79
         XTkJe2z///wiLsz4c6Et7HzHf2AXe8aum4kvPDPNVtLkBM6cKyRWPAPN9sTxi/wtHClb
         TaW7HT220/nBlhrnh1yUOO/dKBfxppeX442HhNUqQJIpN7UQjya2+z5JSX+hYt9WzJ1X
         y9nv8IdQAwl2T57rukjzBg8nHABxV7v1+31xwMBtmTy3p+jNAT4WT99couD0hOIfOPf7
         t2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682716728; x=1685308728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0yu+PGePfgOn7Dr4AaCeHmSNPX477Sl7q4z5WfJr3k=;
        b=VO+H8WAevDOY7TcByjwnTHhCHqHI2+gTMnvgtjE1bMrk3Tw0R1J/Dsryxgin/zON9A
         5ZD7OkUOeIabq+emSDQdVxz2WA3QDckVJl4cCnCWjw29bjD+vKSlUtkFAHIa442m7eP0
         Ac+PTpyrQQeKS23qy3gQKUtzaonVN32D4sQecFY5vQjpUu0cQqZqOMCFQitwK5IOqz2h
         AAG6QnkJqHID1g0Hx1KxaDEEKmwBWLKRiDNB/fkYEKHon6mCxwAn3kRC7dVcYlA8eVv1
         7MJS8Yyc3qIiWFboCS2sI4aRpS7sAhOQsID6s9LkWHLtCSmZqQpQo3rFacckO/Uw9s5e
         HUYw==
X-Gm-Message-State: AC+VfDwVYjQFExvsAQxmDkvbvDFpEUZAeiuJasFPg5aQ2WoaZUTitVB0
        pQ2T0ozN84eOfEbMP9z+L3adpqbaCqsy2/NHs3g=
X-Google-Smtp-Source: ACHHUZ6HGII9pyMTvBUXKdFtK5Pw60ncRx2oaFxnTUJ7UB8cvn8ENmaTQVN40tMnBP3M9G4W/jHRSyKa9vfZloEi4ZA=
X-Received: by 2002:a17:907:3faa:b0:94a:99a4:58d7 with SMTP id
 hr42-20020a1709073faa00b0094a99a458d7mr7114563ejc.15.1682716727472; Fri, 28
 Apr 2023 14:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230421170300.24115-1-fw@strlen.de> <20230421170300.24115-2-fw@strlen.de>
 <CAEf4Bzby3gwHmvz1cjcNHKFPA1LQdTq85TpCmOg=GB6=bQwjOQ@mail.gmail.com>
 <20230427091015.GD3155@breakpoint.cc> <CAEf4BzZrmUv27AJp0dDxBDMY_B8e55-wLs8DUKK69vCWsCG_pQ@mail.gmail.com>
 <d6de9d40-ff59-4cb6-5a97-f8b72a5d853e@naccy.de>
In-Reply-To: <d6de9d40-ff59-4cb6-5a97-f8b72a5d853e@naccy.de>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 28 Apr 2023 14:18:35 -0700
Message-ID: <CAEf4BzbWCKTMzU=w0STOZM23hTbVtqoMamgB3wC3e+X3xNKZ9w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/7] bpf: add bpf_link support for
 BPF_NETFILTER programs
To:     Quentin Deslandes <qde@naccy.de>
Cc:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 9:54=E2=80=AFAM Quentin Deslandes <qde@naccy.de> wr=
ote:
>
> On 28/04/2023 00:21, Andrii Nakryiko wrote:
> > On Thu, Apr 27, 2023 at 2:10=E2=80=AFAM Florian Westphal <fw@strlen.de>=
 wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>>> @@ -1560,6 +1562,12 @@ union bpf_attr {
> >>>>                                  */
> >>>>                                 __u64           cookie;
> >>>>                         } tracing;
> >>>> +                       struct {
> >>>> +                               __u32           pf;
> >>>> +                               __u32           hooknum;
> >>>
> >>> catching up on stuff a bit...
> >>>
> >>> enum nf_inet_hooks {
> >>>         NF_INET_PRE_ROUTING,
> >>>         NF_INET_LOCAL_IN,
> >>>         NF_INET_FORWARD,
> >>>         NF_INET_LOCAL_OUT,
> >>>         NF_INET_POST_ROUTING,
> >>>         NF_INET_NUMHOOKS,
> >>>         NF_INET_INGRESS =3D NF_INET_NUMHOOKS,
> >>> };
> >>>
> >>> So it seems like this "hook number" is more like "hook type", is my
> >>> understanding correct?
> >>
> >> What is 'hook type'?
> >
> > I meant that it's not some dynamically generated number that could
> > change from the system to system, it's a fixed set of point in which
> > this BPF program can be triggered. The distinction I was trying to
> > make that it's actually different in nature compared to, say, ifindex,
> > as it is fixed by the kernel.
>
> Doesn't this ties the program to a specific hook then? Let's say you
> have a program counting the number of packets from a specific IP, and
> would you be able to attach it to both LOCAL_IN and FORWARD without
> modifying it?

By default, yes (but you can work around that). From your and
Florian's replies it follows that these are not like
expected_attach_type, if I understand correctly. So I'm fine with
having them as attach argument, not part of program type and attach
type.

>
> >>> If so, wouldn't it be cleaner and more uniform
> >>> with, say, cgroup network hooks to provide hook type as
> >>> expected_attach_type? It would also allow to have a nicer interface i=
n
> >>> libbpf, by specifying that as part of SEC():
> >>>
> >>> SEC("netfilter/pre_routing"), SEC("netfilter/local_in"), etc...
> >>
> >> I don't understand how that would help.
> >> Attachment needs a priority and a family (ipv4, arp, etc.).
> >>
> >> If we allow netdev type we'll also need an ifindex.
> >> Daniel Xu work will need to pass extra arguments ("please enable ip
> >> defrag").
> >
> > Ok, that's fine, if you think it doesn't make sense to pre-declare
> > that a given BPF program is supposed to be run only in, say,
> > PRE_ROUTING, then it's fine. We do declare this for other programs
> > (e.g., cgroup_skb/egress vs cgroup_skb/ingress), so it felt like this
> > might be a similar case.
> >
> >>
> >>> Also, it seems like you actually didn't wire NETFILTER link support i=
n
> >>> libbpf completely. See bpf_link_create under tools/lib/bpf/bpf.c, it
> >>> has to handle this new type of link as well. Existing tests seem a bi=
t
> >>> bare-bones for SEC("netfilter"), would it be possible to add somethin=
g
> >>> that will demonstrate it a bit better and will be actually executed a=
t
> >>> runtime and validated?
> >>
> >> I can have a look.
> >
> > It probably makes sense to add bpf_program__attach_netfilter() API as
> > well which will return `struct bpf_link *`. Right now libbpf support
> > for NETFILTER is very incomplete.
>
