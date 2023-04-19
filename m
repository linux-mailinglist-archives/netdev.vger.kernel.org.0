Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCC86E83BE
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 23:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjDSVaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 17:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjDSVaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 17:30:20 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF7019AC
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 14:30:18 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-54fbee98814so18262577b3.8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 14:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681939817; x=1684531817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tx1Xtiel3L2MFB89VNbAU04okPQRWERynTRZmp6tgiw=;
        b=G5iwDX6cweWlz7Hf/pWh3HZS0MCCKDqZaqiYEt8GSmqwknO5x99+IPiI+KaHzG7GfM
         IHZZ8igfORP5yCbkf+YffzupwfG28YpDFBzq9wN9Y9FNZmkUWxUY6cvo8MiK4s6/vRXn
         68ZvnMOrcjLQtABq9ZPjbLEExe+cCRUIH9V81ZVptk3OKJpnL/UCoJNTIMFfIYo75V6m
         1BL3DOZon01TCLK2Czb54chOelLdVIByC1eDjixd5dyAQa47G64TbcOy/i2FlH313i9L
         JcQ2ln8E2jbIcis5rTTX+Ws5jJYtRb87sa/kdURclYJ9X82cVdTht8VGfvxQ7MviXANU
         IpYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681939817; x=1684531817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tx1Xtiel3L2MFB89VNbAU04okPQRWERynTRZmp6tgiw=;
        b=GxqVIvgQ+IenjvqZx8ssNr5UnnRiHDecSx3Awu9YDy1xDGycYQcPq5uZuvPqPRoBkS
         UwuBcVE1h79jiST4SrAEpXiS3SiVhA4t0K8mNYrtbQNYxK0CWdF/h3GmCtcZWssIAAfz
         fU1cfdFl3duf//w6KSPZuNKJZZ80x1Z1kHyrDAF9r7oeSUXYBu/j+C39rPgC1oyNK2YH
         qVxiiiCh3VDotPldq+0sn1CeZabJBiNh02MetroT3jSp62hRziidrHrPFwb3OeC0CChC
         0NxqUzT84K8w7QI8o+yMtnYPaOTdGMBclHNKSQPTqkcw1MK/yvq/a7/pcDd7GH2TGopw
         SJ9g==
X-Gm-Message-State: AAQBX9d7H21kTnzqzf/eJ1vAsilsBnACgWx9Nhnfx+xgKMcfhQ5e8HBl
        UliWqLkAJD4G6VdcGlNAdXiB4DQzDrXBux6WdSrs
X-Google-Smtp-Source: AKy350bIAwMPchN3cTyQgOT+YhMsccxTx95EhggySeUzeKO4Y7jWYi2JXXVLLYKlYtMqIXcC0YkgMw9DA9HBK0XY1vA=
X-Received: by 2002:a81:12c9:0:b0:54c:65b:9314 with SMTP id
 192-20020a8112c9000000b0054c065b9314mr3618294yws.19.1681939817566; Wed, 19
 Apr 2023 14:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-0-9d4064cb0075@tessares.net>
In-Reply-To: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-0-9d4064cb0075@tessares.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 19 Apr 2023 17:30:06 -0400
Message-ID: <CAHC9VhR68fw+0oaenL08tRecLEC_oCdYcfGaN_m6PW3KZYtdTQ@mail.gmail.com>
Subject: Re: [PATCH LSM 0/2] security: SELinux/LSM label with MPTCP and accept
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 1:44=E2=80=AFPM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> In [1], Ondrej Mosnacek explained they discovered the (userspace-facing)
> sockets returned by accept(2) when using MPTCP always end up with the
> label representing the kernel (typically system_u:system_r:kernel_t:s0),
> while it would make more sense to inherit the context from the parent
> socket (the one that is passed to accept(2)). Thanks to the
> participation of Paul Moore in the discussions, modifications on MPTCP
> side have started and the result is available here.
>
> Paolo Abeni worked hard to refactor the initialisation of the first
> subflow of a listen socket. The first subflow allocation is no longer
> done at the initialisation of the socket but later, when the connection
> request is received or when requested by the userspace. This was a
> prerequisite to proper support of SELinux/LSM labels with MPTCP and
> accept. The last batch containing the commit ddb1a072f858 ("mptcp: move
> first subflow allocation at mpc access time") [2] has been recently
> accepted and applied in netdev/net-next repo [3].
>
> This series of 2 patches is based on top of the lsm/next branch. Despite
> the fact they depend on commits that are in netdev/net-next repo to
> support the new feature, they can be applied in lsm/next without
> creating conflicts with net-next or causing build issues. These two
> patches on top of lsm/next still passes all the MPTCP-specific tests.
> The only thing is that the new feature only works properly with the
> patches that are on netdev/net-next. The tests with the new labels have
> been done on top of them.
>
> It then looks OK to us to send these patches for review on your side. We
> hope that's OK for you as well. If the patches look good to you and if
> you prefer, it is fine to apply these patches before or after having
> synced the lsm/next branch with Linus' tree when it will include the
> modifications from the netdev/net-next repo.
>
> Regarding the two patches, the first one introduces a new LSM hook
> called from MPTCP side when creating a new subflow socket. This hook
> allows the security module to relabel the subflow according to the owing
> process. The second one implements this new hook on the SELinux side.

Thank you so much for working on this, I really appreciate the help!

As far as potential merge issues with netdev/net-next and lsm/next, I
think we'll be okay.  I have a general policy[1] of not accepting new
patchsets, unless critical bugfixes, past rc5/rc6 so this would be
merged into lsm/next *after* the current merge window closes and
presumably after the netdev/net-next branch finds its way into Linus'
tree.

[1] https://github.com/LinuxSecurityModule/kernel/blob/main/README.md

--
paul-moore.com
