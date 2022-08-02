Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE17F58838C
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 23:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbiHBV2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 17:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiHBV1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 17:27:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A4B54CA6
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 14:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41109B8208F
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 21:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3FEC4347C
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 21:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659475652;
        bh=f8sXEmjzCVWO9SdsToGcbb/52oVj4biGgRxKUZX9cL0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=q9vUSzAel24rmlOUSqFk8hIfhPuNyGq0JwqWtqMGAQAhpmHc0xU/2HmoK1QuoB8yj
         xl52AU6D1XPeLbiID50nCzQVJPuAWEf9m1y9RMtpsloipyAFYLe29qbFf9kozvlA90
         E7xjQQNYnyG1nV2PTSSw71Z7lWtwiZjehNsLLbKBXwYZ8VmDMngdHZgFMon78MzI9V
         fyDq1MiW39oKSqY2RZ7Y97apN8U4dYBxIomCe1uXJ3W3ITSHONat+qBTvX8PAgTUAt
         /czLdwz2bbHKxeBwg7++R9ld+KqlCmo+mteV13l3Pax622SK5h7+yD2RaYPptdLwYS
         2wlTip2Tho0Qg==
Received: by mail-yb1-f174.google.com with SMTP id 21so2884404ybf.4
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 14:27:31 -0700 (PDT)
X-Gm-Message-State: ACgBeo2SV3q4kXsrLTT9ex8w261/tyRuPVsUxfyOjytQY9Ab2S44aLBt
        lIm8Xh+phgYKz/GEsgF9QHmzWyCNeU7Po5xzTxkelA==
X-Google-Smtp-Source: AA6agR7JinRXkeCaJ5iefkcmIgve6ME8Mm5zo+J7U3kFFPHDt8uq88NL4Vzh4y50CW3ZVwUTqLvZCLIQnwxxgoeJPB4=
X-Received: by 2002:a81:14c7:0:b0:328:25f0:9c89 with SMTP id
 190-20020a8114c7000000b0032825f09c89mr2444233ywu.476.1659475640618; Tue, 02
 Aug 2022 14:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220721172808.585539-1-fred@cloudflare.com> <20220722061137.jahbjeucrljn2y45@kafai-mbp.dhcp.thefacebook.com>
 <18225d94bf0.28e3.85c95baa4474aabc7814e68940a78392@paul-moore.com>
 <a4db1154-94bc-9833-1665-a88a5eee48de@cloudflare.com> <9eee1d03-3153-67d3-fe21-14fcb5fe8d27@schaufler-ca.com>
 <CAHC9VhS9NN9a0=4ANwOf1e74+mKMD5BwE+rKhXcno3dtrZ7GVg@mail.gmail.com>
In-Reply-To: <CAHC9VhS9NN9a0=4ANwOf1e74+mKMD5BwE+rKhXcno3dtrZ7GVg@mail.gmail.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 2 Aug 2022 23:27:10 +0200
X-Gmail-Original-Message-ID: <CACYkzJ5EH5t+-jC=FkLxJHQwrkVVPBdR3jAnEFPm-KVmLxBQjQ@mail.gmail.com>
Message-ID: <CACYkzJ5EH5t+-jC=FkLxJHQwrkVVPBdR3jAnEFPm-KVmLxBQjQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce security_create_user_ns()
To:     Paul Moore <paul@paul-moore.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Frederick Lawler <fred@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, revest@chromium.org,
        jackmanb@chromium.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, ebiederm@xmission.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 6:35 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Mon, Aug 1, 2022 at 11:25 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > On 8/1/2022 6:13 AM, Frederick Lawler wrote:
> > > On 7/22/22 7:20 AM, Paul Moore wrote:
> > >> On July 22, 2022 2:12:03 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > >>
> > >>> On Thu, Jul 21, 2022 at 12:28:04PM -0500, Frederick Lawler wrote:
> > >>>> While creating a LSM BPF MAC policy to block user namespace
> > >>>> creation, we
> > >>>> used the LSM cred_prepare hook because that is the closest hook to
> > >>>> prevent
> > >>>> a call to create_user_ns().
> > >>>>
> > >>>> The calls look something like this:
> > >>>>
> > >>>> cred = prepare_creds()
> > >>>> security_prepare_creds()
> > >>>> call_int_hook(cred_prepare, ...
> > >>>> if (cred)
> > >>>> create_user_ns(cred)
> > >>>>
> > >>>> We noticed that error codes were not propagated from this hook and
> > >>>> introduced a patch [1] to propagate those errors.
> > >>>>
> > >>>> The discussion notes that security_prepare_creds()
> > >>>> is not appropriate for MAC policies, and instead the hook is
> > >>>> meant for LSM authors to prepare credentials for mutation. [2]
> > >>>>
> > >>>> Ultimately, we concluded that a better course of action is to
> > >>>> introduce
> > >>>> a new security hook for LSM authors. [3]
> > >>>>
> > >>>> This patch set first introduces a new security_create_user_ns()
> > >>>> function
> > >>>> and userns_create LSM hook, then marks the hook as sleepable in BPF.
> > >>> Patch 1 and 4 still need review from the lsm/security side.
> > >>
> > >>
> > >> This patchset is in my review queue and assuming everything checks
> > >> out, I expect to merge it after the upcoming merge window closes.
> > >>
> > >> I would also need an ACK from the BPF LSM folks, but they're CC'd on
> > >> this patchset.
> > >
> > > Based on last weeks comments, should I go ahead and put up v4 for
> > > 5.20-rc1 when that drops, or do I need to wait for more feedback?
> >
> > As the primary consumer of this hook is BPF I would really expect their
> > reviewed-by before accepting this.
>
> We love all our in-tree LSMs equally.  As long as there is at least
> one LSM which provides an implementation and has ACK'd the hook, and
> no other LSMs have NACK'd the hook, then I have no problem merging it.
> I doubt it will be necessary in this case, but if we need to tweak the
> hook in the future we can definitely do that; we've done this in the
> past when it has made sense.
>
> As a reminder, the LSM hooks are *not* part of the "don't break
> userspace" promise.  I know it gets a little muddy with the way the

That's correct. Also, with BPF LSM, we encourage users to
build the application / bpf program logic to be resilient to changes
in the LSM hooks.

I am happy to share how we've done it, if folks are interested.

- KP

> BPF LSM works, but just as we don't want to allow one LSM to impact
> the runtime controls on another, we don't want to allow one LSM to
> freeze the hooks for everyone.
>
> --
> paul-moore.com
