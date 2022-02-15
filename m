Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA434B6210
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 05:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiBOE0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 23:26:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBOE0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 23:26:21 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1CAA8ED5;
        Mon, 14 Feb 2022 20:26:12 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id p190-20020a4a2fc7000000b0031820de484aso21804399oop.9;
        Mon, 14 Feb 2022 20:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UTelz8ULof2gSjsBcmY6Zg1fgejCRlE5fSYm6lKKjy4=;
        b=VDHh7z+IwcbBeMbqb/ts7h9CtBJtyvfF8FwWbf6emVp/mYymuVKbMMqRANFT8nLPpW
         VCm425TEHngvz36JYjLZN+4o8vveeIyJZaKUMd7trP9ccSMivUMMNwjn4fxk0mnJi+1B
         mDhTeO5C1X9Fmmc5uoX9AoY+zT2aFZjs5950zzjJiusCHSPv//q5Oh7wfs6GOiiqBQ8t
         6PwX/37UFBXhs/cunn5Y/Sy6ojbvNmdK2A3/PXXJQ+1JR9V32r1bI4HnwmtdBv0YHi0l
         t9V5MRgouIoHU2sxJrO6MdaJgO8dJYeD1LkGRzWS5Yb2gJppiVVTIzXgqI5YzgegKT5S
         Onjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UTelz8ULof2gSjsBcmY6Zg1fgejCRlE5fSYm6lKKjy4=;
        b=rn2/HaG3J/ZC0NA+c3YsGbmnttCQQp+fNskAMsJYhJCMGUTGi8jTzTrSHfsk4gw5rx
         X7T0LvD0d5Bg7HNs6Km99YO87bcm2FV82uTom4hix89ucR3mVujhNG+Bg8fSb/x19xwq
         5IEd4XQDoFInXo2NocMvmN1BH+EcVYnvSdlIV/MzGnQFDucLBsts0/QC6vIYmnCJreDA
         mPj++dpWpph0MF9FCtADFfpJ/OCn10AlE0GWxWaS9yFO0a8aKC5OnGIx1P00/QBYyX2r
         2MBU6agsBB49ogpCux/C50guulXDPsgFvOwZsOr0PBN5ZByStwm8Smo1UZhYfmKwhT3N
         Z2cw==
X-Gm-Message-State: AOAM53328K+i8f13wNf4+xu5ojgcVmjRbuzUU2lc1U+zsYZyJTbewDSZ
        961cS9oKZ6GlUwS6jvMHnnyqQEdV1+gRyWhqR/Q=
X-Google-Smtp-Source: ABdhPJyfCYYB1BeuPkdtK8hzETRmsfqVIwKFs5eK9bz8dTFd9F5vPFVAHjTsTuDovb1hAFiLRDHFqiYsSDF5dR5nZoY=
X-Received: by 2002:a05:6870:d606:b0:ce:c0c9:657 with SMTP id
 a6-20020a056870d60600b000cec0c90657mr791380oaq.169.1644899171351; Mon, 14 Feb
 2022 20:26:11 -0800 (PST)
MIME-Version: 1.0
References: <20220212175922.665442-1-omosnace@redhat.com>
In-Reply-To: <20220212175922.665442-1-omosnace@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 15 Feb 2022 12:26:00 +0800
Message-ID: <CADvbK_dZc-ErLHVBgzqhaMQaYyzM8_R3cado3oSTj+JE9tCiHQ@mail.gmail.com>
Subject: Re: [PATCH net v3 0/2] security: fixups for the security hooks in sctp
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Sun, Feb 13, 2022 at 1:59 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> This is a third round of patches to fix the SCTP-SELinux interaction
> w.r.t. client-side peeloff. The patches are a modified version of Xin
> Long's patches posted previously, of which only a part was merged (the
> rest was merged for a while, but was later reverted):
> https://lore.kernel.org/selinux/cover.1635854268.git.lucien.xin@gmail.com/T/
>
> In gist, these patches replace the call to
> security_inet_conn_established() in SCTP with a new hook
> security_sctp_assoc_established() and implement the new hook in SELinux
> so that the client-side association labels are set correctly (which
> matters in case the association eventually gets peeled off into a
> separate socket).
>
> Note that other LSMs than SELinux don't implement the SCTP hooks nor
> inet_conn_established, so they shouldn't be affected by any of these
> changes.
>
> These patches were tested by selinux-testsuite [1] with an additional
> patch [2] and by lksctp-tools func_tests [3].
>
> Changes since v2:
> - patches 1 and 2 dropped as they are already in mainline (not reverted)
> - in patch 3, the return value of security_sctp_assoc_established() is
>   changed to int, the call is moved earlier in the function, and if the
>   hook returns an error value, the packet will now be discarded,
>   aborting the association
> - patch 4 has been changed a lot - please see the patch description for
>   details on how the hook is now implemented and why
>
> [1] https://github.com/SELinuxProject/selinux-testsuite/
> [2] https://patchwork.kernel.org/project/selinux/patch/20211021144543.740762-1-omosnace@redhat.com/
> [3] https://github.com/sctp/lksctp-tools/tree/master/src/func_tests
>
> Ondrej Mosnacek (2):
>   security: add sctp_assoc_established hook
>   security: implement sctp_assoc_established hook in selinux
>
>  Documentation/security/SCTP.rst | 22 ++++----
>  include/linux/lsm_hook_defs.h   |  2 +
>  include/linux/lsm_hooks.h       |  5 ++
>  include/linux/security.h        |  8 +++
>  net/sctp/sm_statefuns.c         |  8 +--
>  security/security.c             |  7 +++
>  security/selinux/hooks.c        | 90 ++++++++++++++++++++++++---------
>  7 files changed, 103 insertions(+), 39 deletions(-)
>
> --
> 2.34.1
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
