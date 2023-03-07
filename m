Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71186AF764
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjCGVSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjCGVSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:18:38 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F23099D65;
        Tue,  7 Mar 2023 13:18:37 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id ec29so27021601edb.6;
        Tue, 07 Mar 2023 13:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678223915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bT9FiASK1DB4QbD0wXIRsqFb1t5m7/WMXyE4zipQBgs=;
        b=XZRUHZNlOVWWar8OmQxc4l18Ns4Ay3zk1r5/iP0nGgvrTarrD1WtX4t7ZDUeAU+Kmn
         y3gux0xqokeG1SF1sfRK8kH6Fs4eK/RB3DJDFJateRr3aPzJO/rdAB33D1DxBCmMvug1
         2+t/rOZmMi9aCK9I8RXUjUslBeJtPNIejQlHCpUdxA/6eyfbUFM9w37VUA1uKho+LTWc
         CC6uwViT8Xbi5YfZ5sxgklTr+38MZrlyneYHCqEEFrcAi/gzGISimm7UQJKVDiZYkpcn
         8L4DjJ3sPxFDMWliMIZaLeEF/uitLcKCkMjVzBypmiqjyFBvfKhUi2jAGDUpLX9HbWYf
         1h1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678223915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bT9FiASK1DB4QbD0wXIRsqFb1t5m7/WMXyE4zipQBgs=;
        b=F+lbrUxRtBxt4NZRLnH5iJsbhQQBfN120YX2ExOnMQXLymfoPa7sOm+LT2CmedHG+l
         2PfaUHUrLPiGnuTB9ThcFu0I3miBbQGE1bNVF4rHCoLetN+l7XAU2ALTF/M97CGmaWJ5
         ODN3XT9sD+5KIQEvdcAN2PB+iMeUxPsTshxQcQCFPADOIfjljIjRZ94AmXIwPAUcVWo3
         yBgLJTpqxJk8m1/Zp7I23tDtWKjqxBYcbu7b4YQbngqY6JpZi019ORtphKV6dZM4BoZq
         VeJSMpNfOWq785+ONJNGp/tk3sRyYJ2oVfDQoeOJr1cqaJA0qlFkZTfwnmFsajPdhTdJ
         hFSg==
X-Gm-Message-State: AO0yUKUj72GNPDC19RdZn+Cx8brRvDRrelUQpdn4jn/hZEBuAADeH/V8
        FGYZ86zONEsMpSxhf30FhSm7zOgkVHudPLvKshqeQ1r2HzY=
X-Google-Smtp-Source: AK7set+Se0iunflJpZCYnoGyjZ2gQplgrdTsGwS0vBTFJC6JhbRPQsBREQBt88sd9cj+dWd/Nc5Ban1xnd1TF7pS/ps=
X-Received: by 2002:a17:906:948:b0:8b1:2898:2138 with SMTP id
 j8-20020a170906094800b008b128982138mr7898708ejd.3.1678223915375; Tue, 07 Mar
 2023 13:18:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1677526810.git.dxu@dxuuu.xyz> <20230227230338.awdzw57e4uzh4u7n@MacBook-Pro-6.local>
 <20230228015712.clq6kyrsd7rrklbz@kashmir.localdomain> <CAADnVQ+a633QyZgkbXfRiT_WRbPgr5n8RN0w=ntEkBHUeqRcbw@mail.gmail.com>
 <20230228231716.a5uwc4tdo3kjlkg7@aviatrix-fedora.tail1b9c7.ts.net>
 <CAADnVQKK+a_0effQW5qBSq1AXoQOJg5-79q3d1NWJ2Vv8SHvOw@mail.gmail.com>
 <20230307194801.mopwvidrkrybm7h5@kashmir.localdomain> <20230307201156.GF13059@breakpoint.cc>
In-Reply-To: <20230307201156.GF13059@breakpoint.cc>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 7 Mar 2023 13:18:23 -0800
Message-ID: <CAADnVQJXpkzic+v-TTn2o8hAu94S2ARq86DUamKiMEqmJ1zy+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets in BPF
To:     Florian Westphal <fw@strlen.de>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 12:11=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Daniel Xu <dxu@dxuuu.xyz> wrote:
> > From my reading (I'll run some tests later) it looks like netfilter
> > will defrag all ipv4/ipv6 packets in any netns with conntrack enabled.
> > It appears to do so in NF_INET_PRE_ROUTING.
>
> Yes, and output.
>
> > One thing we would need though are (probably kfunc) wrappers around
> > nf_defrag_ipv4_enable() and nf_defrag_ipv6_enable() to ensure BPF progs
> > are not transitively depending on defrag support from other netfilter
> > modules.
> >
> > The exact mechanism would probably need some thinking, as the above
> > functions kinda rely on module_init() and module_exit() semantics. We
> > cannot make the prog bump the refcnt every time it runs -- it would
> > overflow.  And it would be nice to automatically free the refcnt when
> > prog is unloaded.
>
> Probably add a flag attribute that is evaluated at BPF_LINK time, so
> progs can say they need defrag enabled.  Same could be used to request
> conntrack enablement.
>
> Will need some glue on netfilter side to handle DEFRAG=3Dm, but we alread=
y
> have plenty of those.

All makes perfect sense to me.
It's cleaner than a special netdevice.
ipv4_conntrack_defrag() is pretty neat. I didn't know about it.
If we can reuse it as-is that would be ideal.
Conceptually it fits perfectly.
If we cannot reuse it (for whatever unlikely reason) I would
argue that TC hook should gain similar functionality.
