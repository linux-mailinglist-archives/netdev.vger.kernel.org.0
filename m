Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CE257AD49
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbiGTBlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241718AbiGTBlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:41:04 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD387AC29
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 18:32:44 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r1-20020a05600c35c100b003a326685e7cso1216648wmq.1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 18:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tQp/N6Uk+UKd7eDu5UmzGuGhmF0Y+ibaoFPpIegLF+Y=;
        b=by6T/E8VkX8oFtD8dnsR64IT7UFDcrTPCAIRCgOPa/LJUI8JOCFbfiz7J364/bCOeH
         rd2SkAx8XnmkmyymE0WIWkYVOzMHAWDtTOM7/pu4iS/Fe00JFXhg564o71FrfrqpBCLX
         kNQx4x/jPUrpwvMLbAB7FQyDSSJU5xbxfQ3JJ8oycJgKPUTeAw2TRAoGo85orXqi0A8u
         Xs58+Hntk7L9VAArrtF/7CD3yaGAuk+/qXl0aNv10D0zU/SEvOHRpjy0Q2PZ1bdEhEgl
         88w2QZanxV32ADu69Bwbh0ecfaxCfSbzFZyoWEIAXF445J3pol4ru5Qh5EMeLZvIwOIM
         TLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tQp/N6Uk+UKd7eDu5UmzGuGhmF0Y+ibaoFPpIegLF+Y=;
        b=l++4oje1AjIFiE/54ZRVD0/AUrp0YCMIjiFhVGb0qd7iy4aS9zFxTPErfTr2y3CnF6
         shpQgeEMi8Ngb5CS8OQ8JOpZAY3iKsfGQM5Z21q8E72juRSqZA5J6nVVqqM/p8Pxs/ei
         EhNVZBTyOguq3Xv9T4NNFa6sKTb/leJPr2oY6zEvneRRUc9xRdNJ5WIg8vPfqsDhOY6U
         /7bhh+BcUaZ/4tUDlk0QoUNHf0jBSOkO46RunTLPk8UqfikONUPR32vUfv1wAChJCUMm
         OUbB9TzcSlR+sKneTHLgCUzvbJaQCMrtTPhIoPBdAM0RgZPwXRCyHsIR9NZ6+KrPcP3r
         XuBA==
X-Gm-Message-State: AJIora864ZLtQdXW+9WGXBDd0K654JrrAYPZHCpfknHidFDcVQlUaWvL
        y1lSJqQHIuPg+qU15Obtgze+z8E7z47yCp1uk7l6
X-Google-Smtp-Source: AGRyM1ubeyz5pphxIFoknkif5zSYvGormRenvsTvDWi7UK6OclfHHNS+LtozRpPhZOyHN270g6dMP5377DarcQ4fJ5w=
X-Received: by 2002:a7b:ce8f:0:b0:3a2:ff2d:915f with SMTP id
 q15-20020a7bce8f000000b003a2ff2d915fmr1512608wmj.165.1658280762556; Tue, 19
 Jul 2022 18:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220707223228.1940249-1-fred@cloudflare.com> <CAJ2a_DezgSpc28jvJuU_stT7V7et-gD7qjy409oy=ZFaUxJneg@mail.gmail.com>
 <3dbd5b30-f869-b284-1383-309ca6994557@cloudflare.com> <84fbd508-65da-1930-9ed3-f53f16679043@schaufler-ca.com>
In-Reply-To: <84fbd508-65da-1930-9ed3-f53f16679043@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 19 Jul 2022 21:32:31 -0400
Message-ID: <CAHC9VhQ-mBYH-GwSULDyyQ6mNC6K8GNB4fra0pJ+s0ZnEpCgcg@mail.gmail.com>
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

On Fri, Jul 8, 2022 at 12:11 PM Casey Schaufler <casey@schaufler-ca.com> wr=
ote:
> On 7/8/2022 7:01 AM, Frederick Lawler wrote:
> > On 7/8/22 7:10 AM, Christian G=C3=B6ttsche wrote:
> >> ,On Fri, 8 Jul 2022 at 00:32, Frederick Lawler <fred@cloudflare.com>
> >> wrote:

...

> >> Also I think the naming scheme is <object>_<verb>.
> >
> > That's a good call out. I was originally hoping to keep the
> > security_*() match with the hook name matched with the caller function
> > to keep things all aligned. If no one objects to renaming the hook, I
> > can rename the hook for v3.

No objection from me.

[Sorry for the delay, the last week or two has been pretty busy.]

> >> III.
> >>
> >> Maybe even attach a security context to namespaces so they can be
> >> further governed?
>
> That would likely add confusion to the existing security module namespace
> efforts. SELinux, Smack and AppArmor have all developed namespace models.

I'm not sure I fully understand what Casey is saying here as SELinux
does not yet have an established namespace model to the best of my
understanding, but perhaps we are talking about different concepts for
the word "namespace"?

From a SELinux perspective, if we are going to control access to a
namespace beyond simple creation, we would need to assign the
namespace a label (inherited from the creating process).  Although
that would need some discussion among the SELinux folks as this would
mean treating a userns as a proper system entity from a policy
perspective which is ... interesting.

> That, or it could replace the various independent efforts with a single,
> unified security module namespace effort.

We've talked about this before and I just don't see how that could
ever work, the LSM implementations are just too different to do
namespacing at the LSM layer.  If a LSM is going to namespace
themselves, they need the ability to define what that means without
having to worry about what other LSMs want to do.


--
paul-moore.com
