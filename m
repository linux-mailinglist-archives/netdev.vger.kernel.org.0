Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7BF5978BF
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 23:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242323AbiHQVJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 17:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242315AbiHQVJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 17:09:17 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9224E3E746
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 14:09:14 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-11c5ee9bf43so2697365fac.5
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 14:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3nAF7A4zag+lbZIR/JeYceDw3xmVGJHxEljejc4+EMk=;
        b=drRJBjO8ZtYFWGv/xY6rGxrJuTubV5RfziGsueXADRqxRSQZsg8Dcv7T6sgwov1s1o
         1cugYMMRd9VAhocoLUz+CFVkc+pIiqYIShCZewfgGMwc27fEMcjrr5tkVochcYJsr2K7
         Qf4YzeaH+UsGXUNG07W+7MayVhDPPoAtkLY1RJPexfHPes+hA1COp3Qu+PUiivC7z3g9
         FmozmoPv+QeTerF12DpUIbJfigr83yCgiygRITJISaSSQMkmvVaNi87LBM1O+/3HCh+T
         mrLIGsrXUBqW4+AvRNyY435qZuTangAOUK/Jd69gqGcD9APbQFG+UhAiY9ZXBiucW8cR
         H3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3nAF7A4zag+lbZIR/JeYceDw3xmVGJHxEljejc4+EMk=;
        b=wUhzb/FY6fiWcjTZezN/ggRWvMzMNZJNV0wMfpcY57hjkX66W6imFr8lscHa2RpAN+
         CabnFUhsnJeoeVpAa6G2xeTkqepPPIxSnPpPeoRb9yCjrLRTMZko4N0BYEz+uiB6q6y6
         18jX2SMvuU0Tcq2x+FY8idK0YdcNEU34zBdmbbHyVtM9oY8V2R+HOFwQfoWqvQkM69Tx
         GVzIk8RSX4etahNdTPKmB1+CVhjHYfTLpzYmMm5CCWtpqXRkzghwRUYty4nSmMVaW5K7
         y+dwJsXEjGXmwk4UPhsT6xvyQzE7u7sp2xc6o9No+ZzlSrfPfbFMqrA9CPpCdAV78lhl
         +Aqg==
X-Gm-Message-State: ACgBeo3h3xanRFxlean5zYyQrK11dsZWtKbm5s/LTc7/7FvfrFfq8amN
        SLtxjoRsbWSiZGhphixMNw8N7PywOBrMEPildNlv
X-Google-Smtp-Source: AA6agR6UtJcD0LCRVD5ZxpCbZU30Dth24rP1kcXpw+C/3aIhO30r/ueUbSJqc2APx0isNDq4wdyzZLK541ijjU5Fhd4=
X-Received: by 2002:a05:6870:a78d:b0:11c:437b:ec70 with SMTP id
 x13-20020a056870a78d00b0011c437bec70mr2771915oao.136.1660770553733; Wed, 17
 Aug 2022 14:09:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220815162028.926858-1-fred@cloudflare.com> <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org> <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org> <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <8735du7fnp.fsf@email.froward.int.ebiederm.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 17 Aug 2022 17:09:07 -0400
Message-ID: <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
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
        karl@bigbadwolfsecurity.com, tixxdz@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 4:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Paul Moore <paul@paul-moore.com> writes:
> > On Wed, Aug 17, 2022 at 3:58 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> Paul Moore <paul@paul-moore.com> writes:
> >>
> >> > At the end of the v4 patchset I suggested merging this into lsm/next
> >> > so it could get a full -rc cycle in linux-next, assuming no issues
> >> > were uncovered during testing
> >>
> >> What in the world can be uncovered in linux-next for code that has no in
> >> tree users.
> >
> > The patchset provides both BPF LSM and SELinux implementations of the
> > hooks along with a BPF LSM test under tools/testing/selftests/bpf/.
> > If no one beats me to it, I plan to work on adding a test to the
> > selinux-testsuite as soon as I'm done dealing with other urgent
> > LSM/SELinux issues (io_uring CMD passthrough, SCTP problems, etc.); I
> > run these tests multiple times a week (multiple times a day sometimes)
> > against the -rcX kernels with the lsm/next, selinux/next, and
> > audit/next branches applied on top.  I know others do similar things.
>
> A layer of hooks that leaves all of the logic to userspace is not an
> in-tree user for purposes of understanding the logic of the code.

The BPF LSM selftests which are part of this patchset live in-tree.
The SELinux hook implementation is completely in-tree with the
subject/verb/object relationship clearly described by the code itself.
After all, the selinux_userns_create() function consists of only two
lines, one of which is an assignment.  Yes, it is true that the
SELinux policy lives outside the kernel, but that is because there is
no singular SELinux policy for everyone.  From a practical
perspective, the SELinux policy is really just a configuration file
used to setup the kernel at runtime; it is not significantly different
than an iptables script, /etc/sysctl.conf, or any of the other myriad
of configuration files used to configure the kernel during boot.

-- 
paul-moore.com
