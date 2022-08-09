Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C0F58E358
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiHIWka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiHIWk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:40:28 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A805FAC0
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 15:40:25 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-10ee900cce0so15766295fac.5
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 15:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1P7bSaIcMszYR+JCa8vqV0slOGBPYXltybusx5DtRDM=;
        b=ymJZNj+3ZRh6BJ8sdJOKWq3WWbUkXw6pah7LZ66RWLPU/lUKblHjIWaSbD/M/HlxZG
         XvRNSo3oVXm145SSS41Ho65tqsFjNeoaSyRIP0bW6D/OrQGUY/gDwhF2RxO+RUiMyfX8
         raLd9fpQ1xyculvAnmt5+WPihY3ElIT/hyo2mQADbhYzhsin1meT8LB/8oVNtwdYglR2
         8BXLy2uW5Fa5RgTdW9YWJ9qrdQxzYFC7yR7a+zVgLQlWAzRxP+H9g8KpL7B+wKqVG4DB
         gCXguHSRTkIZ5oafCKhLHLSwYLU2AXjEnpPWXLLbU4c91UgqdOJ2Ccc/AD0eJ2fxHc/n
         nDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1P7bSaIcMszYR+JCa8vqV0slOGBPYXltybusx5DtRDM=;
        b=QaQ1/1OwREeKQ/7CF36tqo1Tg0O5yY37FQYZsAqog0Uf7xAvGS2TgqZSoMOMd7x42L
         EYUFOKFiZ1y26bIDf0M9uavLZmTxVMK4k0AnvZEY5lk3D4ysr6z3r+K6gsGyazuo/90E
         32SrYDBl8kdlay4qq43dQl6Oz73heXdyAV5lpjKcD8nDA1oIsQ0o77i+fzvtfokL8wyY
         k57ToSpDwAHVOHYaFe6kqI/Z3QlBxFvQiKSL/XgS+Nmr96tVYK2UVoUgfHxHWT9QKnmH
         oQzAAiCX+5JvS49Dpd5t4fcGF8z3njTUABqBP5NlMUiz2ZsOjPDq/3LkbFdkZhvG5wTW
         4BiA==
X-Gm-Message-State: ACgBeo0CS+x0vMfYD+VPHwQW+V4xfn/YKjtpofOahYifEErmh/2kNiar
        SCHTTVQvQUSpcuJDquZYpbuZRHfTrHmlt3cCPsDU
X-Google-Smtp-Source: AA6agR4ClJpq8r9ZKoAk/K/rs8TO1cCIg6yZNX6VC6EIP7MbESfv7l10f5WE4D8xn0xBGSvYXyQ13bhBRsm1jf8wpUM=
X-Received: by 2002:a05:6870:9588:b0:101:c003:bfe6 with SMTP id
 k8-20020a056870958800b00101c003bfe6mr292354oao.41.1660084825048; Tue, 09 Aug
 2022 15:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220801180146.1157914-1-fred@cloudflare.com> <87les7cq03.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com>
 <87wnbia7jh.fsf@email.froward.int.ebiederm.org> <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
 <877d3ia65v.fsf@email.froward.int.ebiederm.org> <87bksu8qs2.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhTEwD2y9Witj-1z3e2TC-NGjghQ4KT4Dqf3UOLzDcDc3Q@mail.gmail.com>
 <87czd95rjc.fsf@email.froward.int.ebiederm.org> <CAHC9VhQY6H4JxOvSYWk2cpH8E3LYeOkMP_ay+ih+ULKKdeob=Q@mail.gmail.com>
 <87a68dccyu.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87a68dccyu.fsf@email.froward.int.ebiederm.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 9 Aug 2022 18:40:14 -0400
Message-ID: <CAHC9VhRkHuwjrtOoK+vn9zzERU2TM_2PEbQGRAZsr-D1pFv9GQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 9, 2022 at 5:41 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Paul Moore <paul@paul-moore.com> writes:
> >
> > What level of due diligence would satisfy you Eric?
>
> Having a real conversation about what a change is doing and to talk
> about it's merits and it's pro's and cons.  I can't promise I would be
> convinced but that is the kind of conversation it would take.

Earlier today you talked about due diligence to ensure that userspace
won't break and I provided my reasoning on why userspace would not
break (at least not because of this change).  Userspace might be
blocked from creating a new user namespace due to a security policy,
but that would be the expected and desired outcome, not breakage.  As
far as your most recent comment regarding merit and pros/cons, I
believe we have had that discussion (quite a few times already); it
just seems you are not satisfied with the majority's conclusion.

Personally, I'm not sure there is anything more I can do to convince
you that this patchset is reasonable; I'm going to leave it to others
at this point, or we can all simply agree to disagree for the moment.
Just as you haven't heard a compelling argument for this patchset, I
haven't heard a compelling argument against it.  Barring some
significant new discussion point, or opinion, I still plan on merging
this into the LSM next branch when the merge window closes next week
so it has time to go through a full round of linux-next testing.
Assuming no unresolvable problems are found during the additional
testing I plan to send it to Linus during the v6.1 merge window and
I'm guessing we will get to go through this all again.  It's less than
ideal, but I think this is where we are at right now.

-- 
paul-moore.com
