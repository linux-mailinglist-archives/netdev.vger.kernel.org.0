Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8629573F86
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbiGMWUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiGMWUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:20:36 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4C12A735;
        Wed, 13 Jul 2022 15:20:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x91so174321ede.1;
        Wed, 13 Jul 2022 15:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CEHSY50dvHt/LC+VsJ7O0dPmxasVR1q6mkEcpMhGoe4=;
        b=eUfHYzrRAckb7Ntj310nITc37nBP0SovYipb+qU5yAPYBLJCqK2FyKwmc3HEgxkjky
         IOwt7i9RsDDdNzkPFrI/qoaoS++EgBRAmcIlMboWoflzXtMi6kYNuFIkGrlcJaemz9NO
         C1Br1AUZfDBUeLVT/2gMph5rBb+sKIZgjpekX99tZSt3PzHYdIlBaxRB8kSRhNDO/x1h
         6kLsu6f6SQEPfff6I57d88AGljpqi+JdS3mU4L6tb1k6iCXDXUL93aiW5Oes4QV3uk8B
         YZnzP1fikm0yrfkSWNupo/vcFhI1OhjlEXoWdK7XSPIiLUaORtW2jD8B+PyJrJcF/5Bn
         EmUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CEHSY50dvHt/LC+VsJ7O0dPmxasVR1q6mkEcpMhGoe4=;
        b=aIGxm3LsGOWGrr/7s//w+F0nt/+3OgJgk9XjSl9lCh3BCpgKFeVUEjAOgmvkFUXSwP
         pALfcd0t/1IOvlbQm9CKXCkeKEgLXmGABKmCNozDK5f8GJG75guDaiTpbJJerRLCIiJU
         CRSBdrvSiZBuNzMYrXDEp6L+Oud0j0dXNMw8QgUP+5fv94008ExXs8mwobVQCO2SuZKr
         lwhRcPvw0bAPJvptQrmx6LjG1l9paX7l5VQ1fjiLYF2fwVDGQxaHgHBhMoZaZVgjV//S
         1UgCCGM4QN/VYErdizdWo7MiHmuvRm+7kZmkLieG5+6Mt12fOT9I9QRxcqNDmbnsw6vf
         3Q4w==
X-Gm-Message-State: AJIora+HtUjcyyIB2k3J2Ad0AqxrltcSrt6Xvmlz4qvWBh613tjsH4dV
        6sjsc29WwahfL2AejWqVByL3pQQXNYXAjmI08M0Y4fCz
X-Google-Smtp-Source: AGRyM1v2tW449sRr9tqYFGm74Yg+p4fyhpjTpTFbXrg2eawnWtDkfiduZxsy194fWltVSrf9IaIU6TcP4JW02GTbn3w=
X-Received: by 2002:aa7:c9d3:0:b0:43a:67b9:6eea with SMTP id
 i19-20020aa7c9d3000000b0043a67b96eeamr8041322edt.94.1657750833695; Wed, 13
 Jul 2022 15:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220711083220.2175036-1-asavkov@redhat.com> <20220711083220.2175036-4-asavkov@redhat.com>
 <CAPhsuW7xTRpLf1kyj5ejH0fV_aHCMQjUwn-uhWeNytXedh4+TQ@mail.gmail.com>
 <CAADnVQ+ju04JAqyEbA_7oVj9uBAuL-fUP1FBr_OTygGf915RfQ@mail.gmail.com> <Ys7JL9Ih3546Eynf@wtfbox.lan>
In-Reply-To: <Ys7JL9Ih3546Eynf@wtfbox.lan>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 13 Jul 2022 15:20:22 -0700
Message-ID: <CAADnVQ+6aN5nMwaTjoa9ddnT6rakgwb9oPhtdWSsgyaHP8kZ6Q@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/4] bpf: add bpf_panic() helper
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, dvacek@redhat.com
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

On Wed, Jul 13, 2022 at 6:31 AM Artem Savkov <asavkov@redhat.com> wrote:
>
> On Tue, Jul 12, 2022 at 11:08:54AM -0700, Alexei Starovoitov wrote:
> > On Tue, Jul 12, 2022 at 10:53 AM Song Liu <song@kernel.org> wrote:
> > >
> > > >
> > > > +BPF_CALL_1(bpf_panic, const char *, msg)
> > > > +{
> > > > +       panic(msg);
> > >
> > > I think we should also check
> > >
> > >    capable(CAP_SYS_BOOT) && destructive_ebpf_enabled()
> > >
> > > here. Or at least, destructive_ebpf_enabled(). Otherwise, we
> > > may trigger panic after the sysctl is disabled.
> > >
> > > In general, I don't think sysctl is a good API, as it is global, and
> > > the user can easily forget to turn it back off. If possible, I would
> > > rather avoid adding new BPF related sysctls.
> >
> > +1. New syscal isn't warranted here.
> > Just CAP_SYS_BOOT would be enough here.
>
> Point taken, I'll remove sysctl knob in any further versions.
>
> > Also full blown panic() seems unnecessary.
> > If the motivation is to get a memory dump then crash_kexec() helper
> > would be more suitable.
> > If the goal is to reboot the system then the wrapper of sys_reboot()
> > is better.
> > Unfortunately the cover letter lacks these details.
>
> The main goal is to get the memory dump, so crash_kexec() should be enough.
> However panic() is a bit more versatile and it's consequences are configurable
> to some extent. Are there any downsides to using it?

versatile? In what sense? That it does a lot more than kexec?
That's a disadvantage.
We should provide bpf with minimal building blocks and let
bpf program decide what to do.
If dmesg (that is part of panic) is useful it should be its
own kfunc.
If halt is necessary -> separate kfunc as well.
reboot -> another kfunc.

Also panic() is not guaranteed to do kexec and just
panic is not what you stated is the goal of the helper.

>
> > Why this destructive action cannot be delegated to user space?
>
> Going through userspace adds delays and makes it impossible to hit "exactly
> the right moment" thus making it unusable in most cases.

What would be an example of that?
kexec is not instant either.

> I'll add this to the cover letter.
>
> > btw, we should avoid adding new uapi helpers in most cases.
> > Ideally all of them should be added as new kfunc-s, because they're
> > unstable and we can rip them out later if our judgement call
> > turns out to be problematic for whatever reason.
>
> Ok, I'll look into doing it this way.
>
> --
> Regards,
>   Artem
>
