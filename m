Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5052C6F0E4B
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 00:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344097AbjD0WVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 18:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjD0WVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 18:21:22 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552B430EE;
        Thu, 27 Apr 2023 15:21:21 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-94ef8b88a5bso1395946666b.2;
        Thu, 27 Apr 2023 15:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682634080; x=1685226080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4uVd64pHIvKt06CCLGHyz+nbo3DgIHYzFJE9URnLnAg=;
        b=c5MwjQFluhsREU9qGl+dog2sDld2YN766dtbsKwSaoeRtoa6a7fPlZPFEp8miIfKHx
         M2JUfaBecoPXak/8MB3tdPXDKv0KqZ1odgOei7nrMuStLgrwsJHlNTDyI9tYoQWnwijF
         UqWHzhSXWZaUbLFnOAgNdrMTBZgzCdmOaZ/Y5eVNnj6iqXZJmCf/YMOyHHWbjtxo8mY3
         sUUa+6dzwoLYlnZDSE3WEa1E6DQdPhpDGc2ml9wOg2Q0u9Kcch1ibjTUHYHJ1zzAJBkc
         Ier9VPqPsW8IyMhvQ3RVZZQT7JZLcPXQOE7u2yfhVyLXe3thfwL5psCpvIhU8Fd5Opiy
         qUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682634080; x=1685226080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4uVd64pHIvKt06CCLGHyz+nbo3DgIHYzFJE9URnLnAg=;
        b=LCySQ7abi6mawN9/npuapCorosNoD0UugnGYKNvOyun5MmhVrCVFy6wmFg2kDI1mir
         m37C/RuX79hkjASs7inb/BI2fepgV3trMST17f2IrzfM1qPnHI/FHrbbJqdDtNRkCMwI
         SDyFuGEeoTUKOXejgPsPWW2UhzpoVannWsMH1xIf7mXqVmsONG9K5e9SW1b0nxqyKfEY
         45fU0nHd/ZZ/VsG444bRU1pFUeS3Cpx0Cq/vlbtHqBxYB6CX0MBl4EM0rF6Z1b/OwnnR
         +Up6PF5051L0+eGhehM787LuNQFbV7jM0LO1XfFi7CyJhJacNWTpreJF9GcfVf9IqyD4
         QZ+g==
X-Gm-Message-State: AC+VfDzOQWXOMxAtkE5IxfSPcWVT6ZHEIgrrtVhfrKZAg3F0juYgjeAJ
        CFzZ0mbvAx0jWOOCilX3J0cy9NMJiZffCeP/Toc=
X-Google-Smtp-Source: ACHHUZ6S6a50qvy5Ay0nBkPHRGlzKBOgO15eD6QORf9RCklcZFd7cFpbvpdupmn3Jjle9kIG1PW3yJCTko3HvbHJvZw=
X-Received: by 2002:a17:907:9281:b0:94e:c40a:cca9 with SMTP id
 bw1-20020a170907928100b0094ec40acca9mr3474592ejc.35.1682634079591; Thu, 27
 Apr 2023 15:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230421170300.24115-1-fw@strlen.de> <20230421170300.24115-2-fw@strlen.de>
 <CAEf4Bzby3gwHmvz1cjcNHKFPA1LQdTq85TpCmOg=GB6=bQwjOQ@mail.gmail.com> <20230427091015.GD3155@breakpoint.cc>
In-Reply-To: <20230427091015.GD3155@breakpoint.cc>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 Apr 2023 15:21:07 -0700
Message-ID: <CAEf4BzZrmUv27AJp0dDxBDMY_B8e55-wLs8DUKK69vCWsCG_pQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/7] bpf: add bpf_link support for
 BPF_NETFILTER programs
To:     Florian Westphal <fw@strlen.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
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

On Thu, Apr 27, 2023 at 2:10=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > @@ -1560,6 +1562,12 @@ union bpf_attr {
> > >                                  */
> > >                                 __u64           cookie;
> > >                         } tracing;
> > > +                       struct {
> > > +                               __u32           pf;
> > > +                               __u32           hooknum;
> >
> > catching up on stuff a bit...
> >
> > enum nf_inet_hooks {
> >         NF_INET_PRE_ROUTING,
> >         NF_INET_LOCAL_IN,
> >         NF_INET_FORWARD,
> >         NF_INET_LOCAL_OUT,
> >         NF_INET_POST_ROUTING,
> >         NF_INET_NUMHOOKS,
> >         NF_INET_INGRESS =3D NF_INET_NUMHOOKS,
> > };
> >
> > So it seems like this "hook number" is more like "hook type", is my
> > understanding correct?
>
> What is 'hook type'?

I meant that it's not some dynamically generated number that could
change from the system to system, it's a fixed set of point in which
this BPF program can be triggered. The distinction I was trying to
make that it's actually different in nature compared to, say, ifindex,
as it is fixed by the kernel.

>
> > If so, wouldn't it be cleaner and more uniform
> > with, say, cgroup network hooks to provide hook type as
> > expected_attach_type? It would also allow to have a nicer interface in
> > libbpf, by specifying that as part of SEC():
> >
> > SEC("netfilter/pre_routing"), SEC("netfilter/local_in"), etc...
>
> I don't understand how that would help.
> Attachment needs a priority and a family (ipv4, arp, etc.).
>
> If we allow netdev type we'll also need an ifindex.
> Daniel Xu work will need to pass extra arguments ("please enable ip
> defrag").

Ok, that's fine, if you think it doesn't make sense to pre-declare
that a given BPF program is supposed to be run only in, say,
PRE_ROUTING, then it's fine. We do declare this for other programs
(e.g., cgroup_skb/egress vs cgroup_skb/ingress), so it felt like this
might be a similar case.

>
> > Also, it seems like you actually didn't wire NETFILTER link support in
> > libbpf completely. See bpf_link_create under tools/lib/bpf/bpf.c, it
> > has to handle this new type of link as well. Existing tests seem a bit
> > bare-bones for SEC("netfilter"), would it be possible to add something
> > that will demonstrate it a bit better and will be actually executed at
> > runtime and validated?
>
> I can have a look.

It probably makes sense to add bpf_program__attach_netfilter() API as
well which will return `struct bpf_link *`. Right now libbpf support
for NETFILTER is very incomplete.
