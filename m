Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B65A58E43B
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 02:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiHJAwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 20:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiHJAwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 20:52:04 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3D374E14;
        Tue,  9 Aug 2022 17:52:03 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z2so17203982edc.1;
        Tue, 09 Aug 2022 17:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Il1Pi56tAdbHD2xkzMpWzGBdztzd5zgrSb7IoS2zT/U=;
        b=FkIsMzd+v0083XugBqAhPXZbO1+72jhsZHlw61FcLI/wavV+QldtPeUl3OCyrp3Fyh
         rhAQdPX6jx45sT0czdTuoyR4h4UMXOXYwZyHsQszuQnRbHvpbEzMmxgRiSA3QEaM4mBs
         SKnFU5ejLzWtXKmbxN0Pv3GwI6XLv0/y97ibV5XVZh9PpNh9njFEPsRyWFQKgVwo42SK
         NOv+UA+ZWUQRCDhdQALBJTWOeVt+T6mbPxZ31MNAfAPfMd+Nn+IFB7c5Ic20smmRk/GZ
         IatX2zC7jb3XV6vxFp30NlaQJISIXCVKNKMc6255KHq7r6W83s3bHHAcV8ZBnIOpZTnc
         Q3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Il1Pi56tAdbHD2xkzMpWzGBdztzd5zgrSb7IoS2zT/U=;
        b=RkPuR3xKm1Yy1S9fNO4QQta6e5zXhgYKcoHzIyv7iSws68N1tSDTFxmk24OsPyhTEB
         YjuqrtRAgmaufFvIdBXMhWlphuQL9ziwnfswTtv6cy3tqaACrNH0GVCSTwiZ1b4NbC2g
         aWtnZ9WmVW9oevVlNhbpEd/ntRW9y2kglJmFmJ1ywoaZ4sQChZGk8PKfZ7nxRZYYYAYK
         xg3Opz/uuUk6JSsmvdjsssZjnlfDzh/7nWNXY0cMsBBp7+XFOa6tBaSQAlI+v6QhuATM
         6VnnN6EgfIESj/l5KSeeW+qBNgFaIRXbcAd8Q+2MMdQ7oOuUbFw8HhI2oeRbnaz48rSo
         MIIA==
X-Gm-Message-State: ACgBeo0rDDfMQB09McPgc3JNMh7yCZJBe70UzdqzhZnbnip6sojPdrji
        INfF+0FcXo/ICe/Ag79nzVEkMdHwjZuJ5jSqn/M=
X-Google-Smtp-Source: AA6agR6sLH6713PplNbjRmTeKN+KUJlbDRD64uMge0GGzpH/dD2DRuAtHnMwxGID1u5AP+Pk550sA76uQe/IBLWBCeE=
X-Received: by 2002:a05:6402:28cb:b0:43b:c6d7:ef92 with SMTP id
 ef11-20020a05640228cb00b0043bc6d7ef92mr24499717edb.333.1660092722224; Tue, 09
 Aug 2022 17:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220801180146.1157914-1-fred@cloudflare.com> <87les7cq03.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com>
 <87wnbia7jh.fsf@email.froward.int.ebiederm.org> <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
 <877d3ia65v.fsf@email.froward.int.ebiederm.org> <87bksu8qs2.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhTEwD2y9Witj-1z3e2TC-NGjghQ4KT4Dqf3UOLzDcDc3Q@mail.gmail.com>
 <87czd95rjc.fsf@email.froward.int.ebiederm.org> <CAHC9VhQY6H4JxOvSYWk2cpH8E3LYeOkMP_ay+ih+ULKKdeob=Q@mail.gmail.com>
 <87a68dccyu.fsf@email.froward.int.ebiederm.org> <CAHC9VhRkHuwjrtOoK+vn9zzERU2TM_2PEbQGRAZsr-D1pFv9GQ@mail.gmail.com>
In-Reply-To: <CAHC9VhRkHuwjrtOoK+vn9zzERU2TM_2PEbQGRAZsr-D1pFv9GQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 9 Aug 2022 17:51:50 -0700
Message-ID: <CAADnVQJcvwb_5dY-FomsDzJWZQG_5EWLmjBFJYNqomd0f9XO+w@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
To:     Paul Moore <paul@paul-moore.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederick Lawler <fred@cloudflare.com>,
        KP Singh <kpsingh@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Brendan Jackman <jackmanb@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        eparis@parisplace.org, Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        bpf <bpf@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>,
        karl@bigbadwolfsecurity.com
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

On Tue, Aug 9, 2022 at 3:40 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Tue, Aug 9, 2022 at 5:41 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Paul Moore <paul@paul-moore.com> writes:
> > >
> > > What level of due diligence would satisfy you Eric?
> >
> > Having a real conversation about what a change is doing and to talk
> > about it's merits and it's pro's and cons.  I can't promise I would be
> > convinced but that is the kind of conversation it would take.
>
> Earlier today you talked about due diligence to ensure that userspace
> won't break and I provided my reasoning on why userspace would not
> break (at least not because of this change).  Userspace might be
> blocked from creating a new user namespace due to a security policy,
> but that would be the expected and desired outcome, not breakage.  As
> far as your most recent comment regarding merit and pros/cons, I
> believe we have had that discussion (quite a few times already); it
> just seems you are not satisfied with the majority's conclusion.
>
> Personally, I'm not sure there is anything more I can do to convince
> you that this patchset is reasonable; I'm going to leave it to others
> at this point, or we can all simply agree to disagree for the moment.
> Just as you haven't heard a compelling argument for this patchset, I
> haven't heard a compelling argument against it.  Barring some
> significant new discussion point, or opinion, I still plan on merging
> this into the LSM next branch when the merge window closes next week
> so it has time to go through a full round of linux-next testing.
> Assuming no unresolvable problems are found during the additional
> testing I plan to send it to Linus during the v6.1 merge window and
> I'm guessing we will get to go through this all again.  It's less than
> ideal, but I think this is where we are at right now.

+1
