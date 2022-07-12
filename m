Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433A9572234
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiGLSJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiGLSJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:09:08 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B972A712;
        Tue, 12 Jul 2022 11:09:07 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id k30so11135383edk.8;
        Tue, 12 Jul 2022 11:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yp1OmpY1y3vVYhTPvfPmHmX6dm6dSMFfYgW5f8nVVoA=;
        b=V4mM+z6VTxmp1Qzn39eT5HwOIxjSgejq39mLAAp1us24aatJLMZx+txxjyQgo0imyi
         kxFEYbZE+S0usVZnbvFjHdalXfPRZyrjPhw3FFSIk4g44jMrAbxMGf8YwMBTNDR5rayJ
         hxM3MYlmNOk8btngFeKDLxUYmd607gTbZbaHXaQ3iSjUsv7E/MWM027W1sS/cEGn4OB0
         mJacaAin0xAn20hBpvslY5abMexQ+QodkAc3dbw+13FOes/x3O6MZMbzo4TavZ3x6oVr
         c4yG8Ra2baUE+5RmpqjBiKUYhagV3vHP9a+pKt5pErBz1tosJRPs78iYeosp5JKD6PlA
         b5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yp1OmpY1y3vVYhTPvfPmHmX6dm6dSMFfYgW5f8nVVoA=;
        b=0tszMNvOARll8wXRybmjSUI3HdPpTqDP0ycIlVn1B5NsoSnhSTJU1toMcJOVlKlQ3O
         xM1we5mSDAsaIcTOxvtw/jpJX4xn3UPKkO4pXNEaUkPel0iJ8WAufoVSxF0EAFJ9th5V
         hMJ+0+uDvqMMjTC26xQKd70AzmCTA3RqxzLyEv/nksIFF1y+omPlNP+nZWKJw2EyBqzQ
         GA8rkeNkstQQKVeMjWR6Qkq2/dxEzPfPSkhtzLMtzIS+F/GryDcPb+VBirJLv7JQuDfj
         NXP4PBRklnFEVQz5B6wxEpwuHcOOEdriDArfHz/bmlYVltpqzRLtkISij+YKURm/Irhh
         HC/g==
X-Gm-Message-State: AJIora8u/3dE58kmzrSRY2mdM2jwS9389U7bSbYZHDLngkYJzGAHfolS
        FjeCJT9/uHWIMuj8SUBetAdjvpFJqPeclwmUpuc=
X-Google-Smtp-Source: AGRyM1saSErCrTNPa4aZDOBLpDXpTNVhuuM81/gv5HZTdRRDXX80C5hVGqz1cHsM/BZOGLgxxSyeLeHDgNxkvUzb9zI=
X-Received: by 2002:a05:6402:350c:b0:43a:e25f:d73 with SMTP id
 b12-20020a056402350c00b0043ae25f0d73mr10720783edd.66.1657649345743; Tue, 12
 Jul 2022 11:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220711083220.2175036-1-asavkov@redhat.com> <20220711083220.2175036-4-asavkov@redhat.com>
 <CAPhsuW7xTRpLf1kyj5ejH0fV_aHCMQjUwn-uhWeNytXedh4+TQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7xTRpLf1kyj5ejH0fV_aHCMQjUwn-uhWeNytXedh4+TQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 12 Jul 2022 11:08:54 -0700
Message-ID: <CAADnVQ+ju04JAqyEbA_7oVj9uBAuL-fUP1FBr_OTygGf915RfQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/4] bpf: add bpf_panic() helper
To:     Song Liu <song@kernel.org>
Cc:     Artem Savkov <asavkov@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
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

On Tue, Jul 12, 2022 at 10:53 AM Song Liu <song@kernel.org> wrote:
>
> >
> > +BPF_CALL_1(bpf_panic, const char *, msg)
> > +{
> > +       panic(msg);
>
> I think we should also check
>
>    capable(CAP_SYS_BOOT) && destructive_ebpf_enabled()
>
> here. Or at least, destructive_ebpf_enabled(). Otherwise, we
> may trigger panic after the sysctl is disabled.
>
> In general, I don't think sysctl is a good API, as it is global, and
> the user can easily forget to turn it back off. If possible, I would
> rather avoid adding new BPF related sysctls.

+1. New syscal isn't warranted here.
Just CAP_SYS_BOOT would be enough here.

Also full blown panic() seems unnecessary.
If the motivation is to get a memory dump then crash_kexec() helper
would be more suitable.
If the goal is to reboot the system then the wrapper of sys_reboot()
is better.
Unfortunately the cover letter lacks these details.
Why this destructive action cannot be delegated to user space?

btw, we should avoid adding new uapi helpers in most cases.
Ideally all of them should be added as new kfunc-s, because they're
unstable and we can rip them out later if our judgement call
turns out to be problematic for whatever reason.
