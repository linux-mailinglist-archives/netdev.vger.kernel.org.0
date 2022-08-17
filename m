Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D098D597954
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 23:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242258AbiHQVvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 17:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242360AbiHQVvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 17:51:13 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2996D3205F
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 14:51:11 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-11c896b879bso283182fac.3
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 14:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=/CTcFk+7lIOz0f66/sW+yd0rIladiacxraDVQHveddU=;
        b=Z37nNyL7fO7ofqzBqhsC8MAbzHXk1QozG1ARlNgf2r4n9sGA4oerk97YgCUalxM2mT
         fhO9INMD4HzzQ1aPLW8N0XehhCLxHPUPhhB2ZRsd51SQdMmoonliVtb6BNO3XaXqioUP
         yEQ/n8yVyhV7BjCADUL3h32ZxYj9GekLs3//TVqThFKgw9sZdbJf86XYIr1DAlZ8bmwG
         xzmKfuAuIDGZVS8TsOPgiMbuIvDri9visdfG8qtZqt2pulyENYyUXIOotM2uhDYmrwUt
         GN+YjefZ6mInoiQ6Eclx15Ltm0cQmwqruPbM5Tyh00SFGnU2OPWk4LHlvYLnPX/vMlx7
         IPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/CTcFk+7lIOz0f66/sW+yd0rIladiacxraDVQHveddU=;
        b=D8rNj/+Dy/MCtFFQQaXmpl1Pa5j/ron2Xx+2c7UcslsG4cgRHNH7W7uF1cz16RGg5f
         k/qvPnCj1XvmhF2c9pb+OVQT08Y3ijSH/PBQVN6ogD6fS9hVJcAwELCTkGOe/owo93gL
         8SsHziMh9B8sURxrtyt47WJ9uAeCkCxOAIW8muzLq867x/q1yP6TdiPkwLULq2RFuavp
         gokftP91bexsC39D4vlj+NKqrH2CJslOwD513B4sgeIXQLCLXS/+SUtzEEb+GiVMJHgA
         OmQfGKGfykV/kdtdzto00uRayK1Cv5lLv4pdjDNA71dIRr6C94c6gXtWPjse+Sv+Uq8h
         9Jww==
X-Gm-Message-State: ACgBeo1bGvo+shmRGpeE93Y/vDGR6F8AfDYD0H5yniNRrpnFGUAg5+V6
        tNsZGyetIxYIZb7KIJ2Rd5/v0ku5ONYSjfqK0sXi
X-Google-Smtp-Source: AA6agR50Tcanb0vgcmzi8OeuXVsdfxGnJyO8cUD9VxdPHwqqDOjJ8rNBXuNdMQ+4DIsaFAJLlr1YMLOTZC7fMkQtyMY=
X-Received: by 2002:a05:6870:9588:b0:101:c003:bfe6 with SMTP id
 k8-20020a056870958800b00101c003bfe6mr2769479oao.41.1660773070428; Wed, 17 Aug
 2022 14:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220815162028.926858-1-fred@cloudflare.com> <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org> <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org> <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org> <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 17 Aug 2022 17:50:59 -0400
Message-ID: <CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com>
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

On Wed, Aug 17, 2022 at 5:24 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> I object to adding the new system configuration knob.
>
> Especially when I don't see people explaining why such a knob is a good
> idea.  What is userspace going to do with this new feature that makes it
> worth maintaining in the kernel?

From https://lore.kernel.org/all/CAEiveUdPhEPAk7Y0ZXjPsD=Vb5hn453CHzS9aG-tkyRa8bf_eg@mail.gmail.com/

 "We have valid use cases not specifically related to the
  attack surface, but go into the middle from bpf observability
  to enforcement. As we want to track namespace creation, changes,
  nesting and per task creds context depending on the nature of
  the workload."
 -Djalal Harouni

From https://lore.kernel.org/linux-security-module/CALrw=nGT0kcHh4wyBwUF-Q8+v8DgnyEJM55vfmABwfU67EQn=g@mail.gmail.com/

 "[W]e do want to embrace user namespaces in our code and some of
  our workloads already depend on it. Hence we didn't agree to
  Debian's approach of just having a global sysctl. But there is
  "our code" and there is "third party" code, which might not even
  be open source due to various reasons. And while the path exists
  for that code to do something bad - we want to block it."
 -Ignat Korchagin

From https://lore.kernel.org/linux-security-module/CAHC9VhSKmqn5wxF3BZ67Z+-CV7sZzdnO+JODq48rZJ4WAe8ULA@mail.gmail.com/

 "I've heard you talk about bugs being the only reason why people
  would want to ever block user namespaces, but I think we've all
  seen use cases now where it goes beyond that.  However, even if
  it didn't, the need to build high confidence/assurance systems
  where big chunks of functionality can be disabled based on a
  security policy is a very real use case, and this patchset would
  help enable that."
 -Paul Moore (with apologies for self-quoting)

From https://lore.kernel.org/linux-security-module/CAHC9VhRSCXCM51xpOT95G_WVi=UQ44gNV=uvvG23p8wn16uYSA@mail.gmail.com/

 "One of the selling points of the BPF LSM is that it allows for
  various different ways of reporting and logging beyond audit.
  However, even if it was limited to just audit I believe that
  provides some useful justification as auditing fork()/clone()
  isn't quite the same and could be difficult to do at scale in
  some configurations."
 -Paul Moore (my apologies again)

From https://lore.kernel.org/linux-security-module/20220722082159.jgvw7jgds3qwfyqk@wittgenstein/

 "Nice and straightforward."
 -Christian Brauner

-- 
paul-moore.com
