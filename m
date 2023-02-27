Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6416E6A4D88
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjB0Vr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjB0Vr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:47:58 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05CA9ED0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 13:47:57 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-536cb25982eso214916477b3.13
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 13:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e/RgTSfKlXNNnsZvow/ifAIK9Ucmx7lb5B49quU+Z7w=;
        b=E1iqZOpeXUZPFhhXuhFx5dSqIW7ldCxomSAk7+FBNKUy8He6tPlqHZLZgbz4GP9j1J
         1mEBv2aznT2/q1ir4+R9avD21vSdZWb1cAG9E7N8Lf70/HWQelTbkaISrRS93IXqJIlm
         TLKl8JyZiLxG7oAhiTdIQIWmKWdIujbOo7qrBxCMcMySJQWrBh8W1G2taXZ24Om//Bmt
         u1DiiHUH1aUE29cvaP2GE9vm83isDCY5OT6b7Zk5upAz5In3/UUlsHUy1zg6XSB8Krs/
         m5ug5vPMcblereeLjAvNxmaeQgxd1QgNb0yrhASC3PdosPCqm5zqnMmdfuQRYTIg9/Ku
         cAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e/RgTSfKlXNNnsZvow/ifAIK9Ucmx7lb5B49quU+Z7w=;
        b=B7dcILufDplgR5zVSvHF3ECHchT7zwFQYdRmj/G026Kx9U6PvG0NtzrR0iB9VvQpro
         Iz/UrbawqWNEDQQiclBGRqdXNONCXK0njR8T21pH+TqQzkGcRgYwsOwFdbtEcGqc9v5Z
         ASREY1g5Ib+kzwVxEm70pRDs3L6Xaa/KzR9Mk7CpsQrjgEqx090t3SQpk3Hn9ELhtyGD
         1V9daGswiZfN1A6GJLoTZG6Xx9cxe5H7bTPjW8vSlgFjckW0ct5xravUJymPmQX/fj36
         X5CyPILDhkYGi4zsT5/3fPBb+ALbIlNnsER1hE4202F3QmKz3NK8PTFDThfvS/lsigM+
         hJjA==
X-Gm-Message-State: AO0yUKW/f+Okd8Qpz8q8p6KmPS2jkQMBb17VmpyBY35+1V3sQHlRo3us
        FSuVDwRXukoU1rj4OO7PJaN0mHnwpuRbTQ6fBxBeMA==
X-Google-Smtp-Source: AK7set/tGhFfKQCD4Pm+cRt8KrXs0EZGdt1GAEwGSUEO0e2G186Sq9c44MJLFs/gDDnymBZee5ug1/0jbggrTnu9lHE=
X-Received: by 2002:a5b:911:0:b0:a02:a3a6:78fa with SMTP id
 a17-20020a5b0911000000b00a02a3a678famr64282ybq.12.1677534476995; Mon, 27 Feb
 2023 13:47:56 -0800 (PST)
MIME-Version: 1.0
References: <20230224150058.149505-1-pctammela@mojatatu.com>
 <20230224150058.149505-2-pctammela@mojatatu.com> <Y/oIWNU5ryYmPPO1@corigine.com>
 <a15d21c6-8a88-6c9a-ca7e-77a31ecfbe28@mojatatu.com> <Y/o0BDsoepfkakiG@corigine.com>
 <20230227113641.574dd3bf@kernel.org> <CAM0EoMmx7As2RL4hnuH8ja_B7Dpx86DWL3JmPQKjB+2B+XYQww@mail.gmail.com>
 <20230227120420.152a9b32@kernel.org> <20230227134137.51079d41@kernel.org>
In-Reply-To: <20230227134137.51079d41@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 27 Feb 2023 16:47:45 -0500
Message-ID: <CAM0EoMmEYJpezGcfvNYOjBESFTq73O=Vr2QsjWQPxPArE1J2AQ@mail.gmail.com>
Subject: Re: [PATCH net 1/3] net/sched: act_pedit: fix action bind logic
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, amir@vadai.me,
        dcaratti@redhat.com, willemb@google.com, ozsh@nvidia.com,
        paulb@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 4:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 27 Feb 2023 12:04:20 -0800 Jakub Kicinski wrote:
> > > > I'm with Simon - this is a long standing problem, and we weren't getting
> > > > any user complaints about this. So I also prefer to route this via
> > > > net-next, without the Fixes tags.
> > >
> > > At minimum the pedit is a fix.
> >
> > How come? What makes pedit different?
> > It's kinda hard to parse from the diff and the commit messages
> > look copy/pasted.
>
> Ah, looks like DaveM already applied this (not v2), so the discussion
> is moot.

for completion's sake:
pedit worked and then got broken at some point. The others, I believe
the review  missed the details unfortunately; those features are a
requirement but someone cutnpasted and missed something.

Note: The only reason we even found this is because some hardware
(nameless at this point) capable of offloading and sharing pedit
actions didnt work. Looking closely we found the other two.

cheers,
jamal
