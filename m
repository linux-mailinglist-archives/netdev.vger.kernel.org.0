Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B155A2AFE
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344440AbiHZPTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344436AbiHZPTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:19:02 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D97DEB6E
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:13:01 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id d18-20020a9d72d2000000b0063934f06268so1220260otk.0
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=MWZMc/+7Wyi/uH5iBX0ev6WW8TlaXh1EF/RFAjrq9cc=;
        b=O7KZCB0y1/yc3jLe5isYu8f/xlGryRQKFSDsS5+Hm9S2iSPTWg+/tkKRDJLMXqshhb
         +us7nVxANSqnydDjRDeuP/shH3xeBXZADJo3AVQV9nalnGzdZLGI6merUmjQoJjxUBCM
         DXrIOH91I9znXlCTNFB4gBesUnzcpxaogynP+8rVz+EbUHCgWuDPQcf7sEuC9LsM8Xvk
         UhzSK1m6W2F8HmZd6k+A7t06IkgtlVlv3EFIompATN0RSz1vsylQMclGBndBQXwxz9nK
         hJ2Adpznn4iVgzfZAfIjJOpwzy850Ob5dnoVTQh5W9UDec2uMqZNMK7/94JTxpJy2pUA
         1A2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=MWZMc/+7Wyi/uH5iBX0ev6WW8TlaXh1EF/RFAjrq9cc=;
        b=eQz1rWQ1/YDgl8QNt+e41psXaXmAg1Xr1en6hLaYpUhmqr+hqBfTkIUN4eW5SIDh6b
         R49Af0ldQ56awEsn8UO9aG4fD74RFgbOsrlVOqPU8jhHoeooM7cCNIH6La1inra742W9
         B+u/EkjoH+7tpm41FB+KzrifRgnKIrNuyW7Q6puc7CUGIxZtMNk5+UTZ5gmp8fPx99nF
         1esEA9Vnw+Jpti2l9k1b83AEoE61mx2o95+87FiFWKWcd+JDViSOBYcDe2Y8VRzwMenX
         E29rIGNgywghYcKErH2YLEWOnNHSFlkXqJvYnvDbGA3SEUQd8zVrKSzbaXaTnUcAtVLf
         dA9Q==
X-Gm-Message-State: ACgBeo1t56DBqjM+WPYVfelq6eM3/K0lS6bPE8n1RoF0Ff+EEXwDYg00
        qLKIVZzP/8X0Cek82pW+hT66nqixqoS/kzdUAiK4
X-Google-Smtp-Source: AA6agR7MDnpNbCR4YIuVIqyJJ5RWNbTAHPbId2dvXBf5nrjFi+9oTJaH2/L6j7qZudY3DqHaAnZxH1naaj8Dn8ifCxo=
X-Received: by 2002:a05:6830:449e:b0:638:c72b:68ff with SMTP id
 r30-20020a056830449e00b00638c72b68ffmr1561158otv.26.1661526780412; Fri, 26
 Aug 2022 08:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org> <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org> <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org> <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org> <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
 <20220819144537.GA16552@mail.hallyn.com> <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
 <875yigp4tp.fsf@email.froward.int.ebiederm.org> <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
 <CALrw=nHRFC-Ws2j-MJAs50oznfRC5fG3a3opmYRkxQCtK61EEg@mail.gmail.com>
In-Reply-To: <CALrw=nHRFC-Ws2j-MJAs50oznfRC5fG3a3opmYRkxQCtK61EEg@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 26 Aug 2022 11:12:49 -0400
Message-ID: <CAHC9VhT_yz4XBSqyfnYkeLtpdQR_Vo9=mKYu+DSBZtyrjLmiVQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org,
        Christian Brauner <brauner@kernel.org>, casey@schaufler-ca.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com, tixxdz@gmail.com
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

On Fri, Aug 26, 2022 at 5:11 AM Ignat Korchagin <ignat@cloudflare.com> wrote:
> I would also add here that seccomp allows more flexibility than just
> delivering SIGSYS to a violating application. We can program seccomp
> bpf to:
>   * deliver a signal
>   * return a CUSTOM error code (and BTW somehow this does not trigger
> any requirements to change userapi or document in manpages: in my toy
> example in [1] I'm delivering ENETDOWN from a uname(2) system call,
> which is not documented in the man pages, but totally valid from a
> seccomp usage perspective)
>   * do-nothing, but log the action
>
> So I would say the seccomp reference supports the current approach
> more than the alternative approach of delivering SIGSYS as technically
> an LSM implementation of the hook (at least in-kernel one) can chose
> to deliver a signal to a task via kernel-api, but BPF-LSM (and others)
> can deliver custom error codes and log the actions as well.

I agree that seccomp mode 2 allows for more flexibility than was
mentioned earlier, however seccomp filtering has some limitations in
this particular case which can be an issue for some.  The first, and
perhaps most important, is that some of the information that a seccomp
filter might want to inspect is effectively hidden with the clone3(2)
syscall due to the clone_args struct; this would make it difficult for
a seccomp filter to identify namespace related operations.  The second
issue is that a seccomp mode 2 based approach requires the
applications themselves to "Do The Right Thing" and ensure that the
proper seccomp filter is loaded into the kernel before the target
fork()/clone()/unshare() call is executed; a LSM which implements a
proper mandatory access control mechanism does not rely on the
application, it enforces the system's security policy regardless of
what actions userspace performs.

-- 
paul-moore.com
