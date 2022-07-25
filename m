Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D555807D8
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 00:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbiGYWxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 18:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237598AbiGYWxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 18:53:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8393E24BC4
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 15:53:39 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u5so17911384wrm.4
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 15:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/W5yt/hqpa2H9l51KPyc7KtGFLwJRO5GtKdVuzCYcYE=;
        b=eRiyLuxpX5qC8hQzrRkg9frLl3gSC//o1oyul/HoGdiNoF4so6toscBjafhGAfLQqp
         UCQghoJOnPMwYy0xIHbRlsbkOyD4ektNaPpsrnGpnIlwnydmsHdNvVWSDXiObsYavolQ
         7R9fpfH9/S4xUCE48oVAhrrLdNjiAmJBq47B5m9UMaOVMHUD9QB7mJrifTVcP6fdgeH8
         wIXb/bkULIJKGTX2mtNfykVdShVFSTtMxCwl2eqvu7rrTu8g5gyuddq7KlYNBQws6Mb2
         fnbp/R1KutfkZXIE80k12jmE3KUrvJxhFXu33hIrDM9gJvLIwcHEpdtbMY4NQG2VxAbg
         71dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/W5yt/hqpa2H9l51KPyc7KtGFLwJRO5GtKdVuzCYcYE=;
        b=Us7pNnvIuzcr9uBYwd2tebdBcVeFJdNXvSYRn/L3So5S9Z4NkJL8yFJwVaD4/J3Q+o
         oMo6Txzd2hzsBSdx6Xsb6QIHnO/xmVDtsNrcWdJSKoiMrDFL9VZZ81/0R6ZqcWZsvFW9
         wyiD/6MHTvQDfmyuqgFBMmdL3gDPhs8jfiB5CCEAia0xiQt5Bccna7XH7MN/8WiwFhzL
         9Dv+9Z6A5JLchYfzuQwzseDHke2CVTqDFoZ7cdVAdMWR2106c/BZ1J7Lwa3v7WSGPpE6
         ciBk5BAKHV9zg9KOD6p1qMfxkXooYD4I/cNRkYoCPTADpIVDKhLSlg5GYEo+tETqLMCZ
         KPKg==
X-Gm-Message-State: AJIora+Q1sc78XmYLjRoYDiw1zJ5ugInmlazMdvfqS0DGQA6xBFbcEzf
        +VRxsq9i3tATSF3VlPuSI4AoN8wz2eYfMfnRPOX6
X-Google-Smtp-Source: AGRyM1sHda4R7slO2THldYmCB6hufThJf2miVQonTYTic0+WRH9UBEOBbGg/X6g4BlFU1purnp8Q+Tj47z8FJeAvPUY=
X-Received: by 2002:adf:fb86:0:b0:21e:3cc8:a917 with SMTP id
 a6-20020adffb86000000b0021e3cc8a917mr9220347wrr.538.1658789617917; Mon, 25
 Jul 2022 15:53:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220721172808.585539-1-fred@cloudflare.com> <877d45kri4.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <877d45kri4.fsf@email.froward.int.ebiederm.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 25 Jul 2022 18:53:26 -0400
Message-ID: <CAHC9VhQXSXWv=+WYwU=Qq0w3rd+zOFPHL5yut1JdV2K=DDRmmg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce security_create_user_ns()
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 1:05 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Frederick Lawler <fred@cloudflare.com> writes:
>
> > While creating a LSM BPF MAC policy to block user namespace creation, we
> > used the LSM cred_prepare hook because that is the closest hook to prevent
> > a call to create_user_ns().
>
> That description is wrong.  Your goal his is not to limit access to
> the user namespace.  Your goal is to reduce the attack surface of the
> kernel by not allowing some processes access to a user namespace.
>
> You have already said that you don't have concerns about the
> fundamentals of the user namespace, and what it enables only that
> it allows access to exploitable code.
>
> Achieving the protection you seek requires talking and thinking clearly
> about the goal.

Providing a single concrete goal for a LSM hook is always going to be
a challenge due to the nature of the LSM layer and the great unknown
of all the different LSMs that are implemented underneath the LSM
abstraction.  However, we can make some very general statements such
that up to this point the LSMs that have been merged into mainline
generally provide some level of access control, observability, or
both.  While that may change in the future (the LSM layer does not
attempt to restrict LSMs to just these two ideas), I think they are
"good enough" goals for this discussion.

In addition to thinking about these goals, I think it also important
to take a step back and think about the original motivation for the
LSM and why it, and Linux itself, has proven to be popular with
everything from the phone in your hand to the datacenter servers
powering ... pretty much everything :)  Arguably Linux has seen such
profound success because of its malleability; the open nature of the
kernel development process has allowed the Linux Kernel to adopt
capabilities well beyond what any one dev team could produce, and as
Linux continues to grow in adoption, its ability to flex into new use
cases only increases.  The kernel namespace concept is an excellent
example of this: virtualizing core kernel ideas, such as user
credentials, to provide better, safer solutions.  It is my belief that
the LSM layer is very much built around this same idea of abstracting
and extending core kernel concepts, in this case security controls, to
provide better solutions.  Integrating the LSM into the kernel's
namespaces is a natural fit, and one that is long overdue.

If we can't find a way to make everyone happy here, let's at least try
to find a way to make everyone "okay" with adding a LSM hook to the
user namespace.  If you want to NACK this approach Eric, that's okay,
but please provide some alternative paths forward that we can discuss.

-- 
paul-moore.com
