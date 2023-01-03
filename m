Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38AD65C93B
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjACWMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjACWMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:12:35 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214CB14003
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 14:12:34 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id t15so34655070ybq.4
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 14:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qL2EYp3pqOLQtvgMhIKXgxCRVXJwycFM/gvyiXFULq0=;
        b=eOqnKSiB2G5NNhowZtcPeoX3tvJlJV2ajnSXyp4qizMYWknadhAcU0SCImfKuJXp3Y
         8tFBp5M/K7Z+MPL5rMw25zS5vgHj3SNLlhdARZ8m2Nl+zEXt5is/ETzMET+aABfF50pR
         2qBNG+oHGMbMi/uY/3Ir/C89xal+Gm0YhunamEe8yo5xmtBdg6b93xrmbq6R6FqQfcBE
         YTsTgm9g778OzvayqLUXeQxKw8uSkTxU1JvF6aGICtkcWUHMlftF+/BTFmgNcLM2j9iu
         7ppOhYd354Ktp6PhWAMqPMybbAhW+AcAxOidcUoSVSqXXTqx1gn6Sden+zJCSX5t3aq2
         lGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qL2EYp3pqOLQtvgMhIKXgxCRVXJwycFM/gvyiXFULq0=;
        b=ULIJsRkI5UTLFmN11Tf5Z1CSG0XYX7v7LX9gS5wMofTFYkeQG2pFmkaREZeHxwg1Is
         tkXOzuLNu47pCTLHdUfjxXKbEFwzaEZkFv/z/ZCQTDSg74RW4G9WahGLefrEZvcgAVgU
         SU2Tt0pgXxLTMyGjpEPkwCbeu8+CEYaa6j41EltLx/CC8z1vJobSZL6z31j3grOFNDn8
         PTPdaBxJgeXIxwJhWmUY0qkSnyiKrLHRPOQP1Wu0eGkcRk13MIm0Vjaj+16GdNukMDcN
         5pmw9one7iEt3Pf3OM2EoFz5uFRbfpsY7cDTRfWvwVcQhvjJdV7M6Jz/FMSWD4dS81TE
         Xnuw==
X-Gm-Message-State: AFqh2koRjo3xdL32vf9itoapoIjKr9zw76czHnFeHFF0F5tdDCQPdbv6
        z6Z5vvyJNfPsoSEXccRJabQN/j33v6u4YM3HZ4Sjiw==
X-Google-Smtp-Source: AMrXdXtpK4SZR8Fc1bPVhq7V6mXB4uGAlSGvpMsVQP2C05CuDZOF3vtzGgdVeYAwAQRfVYvmtaYvngQq1XZ8suTypYA=
X-Received: by 2002:a25:3f06:0:b0:769:e5aa:4ac9 with SMTP id
 m6-20020a253f06000000b00769e5aa4ac9mr3909818yba.598.1672783953040; Tue, 03
 Jan 2023 14:12:33 -0800 (PST)
MIME-Version: 1.0
References: <0000000000002ae67f05f0f191aa@google.com> <ea9c2977-f05f-3acd-ee3e-2443229b7b55@amd.com>
 <3e531d65-72a7-a82a-3d18-004aeab9144b@redhat.com> <a47b840f-b2b8-95d7-ddc0-c9d5dde3c28c@amd.com>
 <2b35515e-5ad0-ee84-c90f-cb61428be4e4@I-love.SAKURA.ne.jp>
In-Reply-To: <2b35515e-5ad0-ee84-c90f-cb61428be4e4@I-love.SAKURA.ne.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 Jan 2023 23:12:21 +0100
Message-ID: <CANn89iL+mEJv_tq6TAFgR86QUmRXJ0CKe=auuQeGOmE2QV2PZw@mail.gmail.com>
Subject: Re: [syzbot] WARNING: locking bug in inet_autobind
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Felix Kuehling <felix.kuehling@amd.com>,
        Waiman Long <longman@redhat.com>, jakub@cloudflare.com,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        syzbot <syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com>,
        Alexander.Deucher@amd.com, Christian.Koenig@amd.com,
        David1.Zhou@amd.com, Evan.Quan@amd.com, Harry.Wentland@amd.com,
        Oak.Zeng@amd.com, Ray.Huang@amd.com, Yong.Zhao@amd.com,
        airlied@linux.ie, ast@kernel.org, boqun.feng@gmail.com,
        daniel@ffwll.ch, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@kernel.org, gautammenghani201@gmail.com, kafai@fb.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru, mingo@redhat.com,
        ozeng@amd.com, pabeni@redhat.com, peterz@infradead.org,
        rex.zhu@amd.com, songliubraving@fb.com, will@kernel.org,
        yhs@fb.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 3, 2023 at 11:08 PM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> On 2023/01/04 1:20, Felix Kuehling wrote:
> >
> > Am 2023-01-03 um 11:05 schrieb Waiman Long:
> >> On 1/3/23 10:39, Felix Kuehling wrote:
> >>> The regression point doesn't make sense. The kernel config doesn't enable CONFIG_DRM_AMDGPU, so there is no way that a change in AMDGPU could have caused this regression.
> >>>
> >> I agree. It is likely a pre-existing problem or caused by another commit that got triggered because of the change in cacheline alignment caused by commit c0d9271ecbd ("drm/amdgpu: Delete user queue doorbell variable").
> > I don't think the change can affect cache line alignment. The entire amdgpu driver doesn't even get compiled in the kernel config that was used, and the change doesn't touch any files outside drivers/gpu/drm/amd/amdgpu:
> >
> > # CONFIG_DRM_AMDGPU is not set
> >
> > My guess would be that it's an intermittent bug that is confusing bisect.
> >
> > Regards,
> >   Felix
>
> This was already explained in https://groups.google.com/g/syzkaller-bugs/c/1rmGDmbXWIw/m/nIQm0EmxBAAJ .
>
> Jakub Sitnicki suggested
>
>   What if we revisit Eric's lockdep splat fix in 37159ef2c1ae ("l2tp: fix
>   a lockdep splat") and:
>
>   1. remove the lockdep_set_class_and_name(...) call in l2tp; it looks
>      like an odd case within the network stack, and
>
>   2. switch to bh_lock_sock_nested in l2tp_xmit_core so that we don't
>      break what has been fixed in 37159ef2c1ae.
>
> and we are waiting for response from Eric Dumazet.
>

Eric Dumazet has been very busy.

Send a patch, instead of an idea/description.

Thanks.
