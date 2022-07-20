Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AFD57C026
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 00:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiGTWjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 18:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiGTWjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 18:39:19 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D592A267
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 15:39:17 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h8so5330966wrw.1
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 15:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gjQxo0hKIVF1YVkSJ8Tt3ejloLl3VpIsO9hirXnFH+U=;
        b=zI4b6Z/wGUUgwWeOD3pQ7dMozzrzLOSSr5UB4/ki36H/h/zC0Qb1NCR/RhxeQdHB+Z
         3FCKUbPYT5+bU3pmhLvpKxSDvhXulocHKjQJIK9p2OWuINXr0ivOwxxFVq8r2AsYJL0k
         h2jIEJlNGTvnLKbR2B1DBtIZIcqD7gzg4o3ocXh3FpoC1frMzUOTzgFrhv924XvD3qy6
         bGkXIyFJEC3lxyxyiCQL50o2Lakud4qBn1yd2/Ofteeaj17Q+3Q2Y9JWICUkKp2nG3tu
         nmWKI3COxvtxiKvkkyvYG9tb5TN1DQ3EJhT9fkaryBkGsfd6tZY/Q5QUvQapNTufNH1C
         bPlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gjQxo0hKIVF1YVkSJ8Tt3ejloLl3VpIsO9hirXnFH+U=;
        b=urokPief++BdfDjGf6ZeYJY8VctpobFTqQtrZqW63WEE4Apu3dLh7aszxWbvCrvVVQ
         ETY2RFqU4AnEITcfwuB5y1rr0DjYc1JdUrEeeLeDZUGC2DBYxL+EzhGi1pks1/51PRlh
         YE2YyJu14SWkOcucyJsZkUYRlrTZRNPVKkbRXGZPhHLbQCBPqF2gu3qcnQhbzYXnYs3I
         Yu5bbwVoQawbCQBCCciPBs+1CPqLxvGSyyC4c9eNbqxppA7fpqDGUhEuc6NZoOF9lzai
         eUssxhY5I3ObkpLDFeCL8FvTPGqY3vRCkoLa6pXc7Np0kMiW3Up5r7WOwkYD4cGujCs3
         yaag==
X-Gm-Message-State: AJIora8tKKf3Tk4g+dEHZN6p/tunlcHZEpBFa6ee6TT6FDgo8M7ICFQq
        XDP8fn0R0b9a9gMwEc0cayoFsZRPPM8zKT5V6jAL
X-Google-Smtp-Source: AGRyM1tdrjUF8cXJwhaIP6PHYKjrB2YVUyMErv5SbIcoUCr7yadS90weIQu40rllAkj9qSRNkrh4MkilhnWcTexYRQo=
X-Received: by 2002:adf:e492:0:b0:21e:45af:5070 with SMTP id
 i18-20020adfe492000000b0021e45af5070mr5887107wrm.483.1658356756213; Wed, 20
 Jul 2022 15:39:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220707223228.1940249-1-fred@cloudflare.com> <CAJ2a_DezgSpc28jvJuU_stT7V7et-gD7qjy409oy=ZFaUxJneg@mail.gmail.com>
 <3dbd5b30-f869-b284-1383-309ca6994557@cloudflare.com> <84fbd508-65da-1930-9ed3-f53f16679043@schaufler-ca.com>
 <CAHC9VhQ-mBYH-GwSULDyyQ6mNC6K8GNB4fra0pJ+s0ZnEpCgcg@mail.gmail.com> <f1f8b350-4dc5-b975-3854-ecbf9f4e54ba@schaufler-ca.com>
In-Reply-To: <f1f8b350-4dc5-b975-3854-ecbf9f4e54ba@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 20 Jul 2022 18:39:05 -0400
Message-ID: <CAHC9VhTFb7=FUyq4oM8ULtnZpZYj3ztpNhASy3WtHnn6QWwZig@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce security_create_user_ns()
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Frederick Lawler <fred@cloudflare.com>,
        =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>,
        KP Singh <kpsingh@kernel.org>, revest@chromium.org,
        jackmanb@chromium.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, shuah@kernel.org,
        Christian Brauner <brauner@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        SElinux list <selinux@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 5:42 PM Casey Schaufler <casey@schaufler-ca.com> wr=
ote:
> On 7/19/2022 6:32 PM, Paul Moore wrote:
> > On Fri, Jul 8, 2022 at 12:11 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
> >> On 7/8/2022 7:01 AM, Frederick Lawler wrote:
> >>> On 7/8/22 7:10 AM, Christian G=C3=B6ttsche wrote:
> >>>> ,On Fri, 8 Jul 2022 at 00:32, Frederick Lawler <fred@cloudflare.com>
> >>>> wrote:

...

> >>>> III.
> >>>>
> >>>> Maybe even attach a security context to namespaces so they can be
> >>>> further governed?
> >> That would likely add confusion to the existing security module namesp=
ace
> >> efforts. SELinux, Smack and AppArmor have all developed namespace mode=
ls.
> >
> > I'm not sure I fully understand what Casey is saying here as SELinux
> > does not yet have an established namespace model to the best of my
> > understanding, but perhaps we are talking about different concepts for
> > the word "namespace"?
>
> Stephen Smalley proposed a SELinux namespace model, with patches,
> some time back. It hasn't been adopted, but I've seen at least one
> attempt to revive it. You're right that there isn't an established
> model.

If it isn't in the mainline kernel, it isn't an established namespace model=
.

I ported Stephen's initial namespace patches to new kernels for quite
some time, look at the working-selinuxns branch in the main SELinux
repository, but that doesn't mean they are ready for upstreaming.
Aside from some pretty critical implementation holes, there is the
much larger conceptual issue of how to deal with persistent filesystem
objects.  We've discussed that quite a bit among the SELinux
developers but have yet to arrive at a good-enough solution.  I have
some thoughts on how we might be able to make forward progress on
that, but it's wildly off-topic for this patchset discussion.  I
mostly wanted to make sure I was understanding what you were
referencing when you talked about a "SELinux namespace model", and it
is what I suspected ... which I believe is unrelated to the patches
being discussed here.

> >> That, or it could replace the various independent efforts with a singl=
e,
> >> unified security module namespace effort.
> >
> > We've talked about this before and I just don't see how that could
> > ever work, the LSM implementations are just too different to do
> > namespacing at the LSM layer.
>
> It's possible that fresh eyes might see options that those who have
> been staring at the current state and historical proposals may have
> missed.

That's always a possibility, and I'm definitely open to a clever
approach that would resolve all the current issues and not paint us
into a corner in the future, but I haven't seen anything close (or any
serious effort for that matter).

... and this still remains way off-topic for a discussion around
adding a hook to allow LSMs to enforce access controls on user
namespace creation.

> >   If a LSM is going to namespace
> > themselves, they need the ability to define what that means without
> > having to worry about what other LSMs want to do.
>
> Possibly. On the other hand, if someone came up with a rational scheme
> for general xattr namespacing I don't see that anyone would pass it up.

Oh geez ...

Namespacing xattrs is not the same thing as namespacing LSMs.  LSMs
may make use of xattrs, and namespacing xattrs may make it easier to
namespace a given LSM, but I'm not aware of an in-tree LSM that would
be magically namespaced if xattrs were namespaced.

This patchset has nothing to do with xattrs, it deals with adding a
LSM hook to implement LSM-based access controls for user namespace
creation.

--=20
paul-moore.com
