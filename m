Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830EB4B753F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbiBOUJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 15:09:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242569AbiBOUJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 15:09:06 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E80CB0C40
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 12:08:54 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id vz16so7211896ejb.0
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 12:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BhJlt5ZCYoidBqqNJ5EsFOz8HUlOmyfI7AV8Vc3JkYk=;
        b=ADoOeEn89ke3US6l0YM5nqedXSf+e9ChVnMnFsvfT7bO8qng9v6Ta1Rj8Ds/J4fnho
         JC3kI6BGKVlJgdUYnf82vkkoyXm/N71P0w6DJKZrzd5Cu2zgnNl0NhFzos5niPdtMbSU
         /MILDymIqGvkOWWPqa6cWe4U7kVCqXpjwmKgrV1zBUhAGK3e/8SCtoYhjzWpNOQT9g6n
         hCMwtfdf6Zb5rSnDACVc3b0BhSXs8+Jbakg1KlxkGOFZ/8pexlNdDMUNwSWZeFvOqi/o
         1rnk/qIn72rf6ybZ3U8mlqscNN1JRZYSq23BpzPUuDC9AQzkkxmqYrHEGoA5LH1Pr/2N
         c60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhJlt5ZCYoidBqqNJ5EsFOz8HUlOmyfI7AV8Vc3JkYk=;
        b=VkFvamw6UmLCxTV809/sOfV7lT0ug8XTQnTnrbVcFunXefqMHpm+kW+vHIvcUHqm9F
         lGqorPp1lArlfWWialia50Fy7q2osVIsm7+l2Otkpgt98UgfseQnYmUCHKCDS11spcSX
         ZQEw90e/RDuejDpBH/Wbaei+8rP3CWCUM/WfEQtcqGuYG4U4iOiirpMytyMp04zX8Rjp
         trq9W1/ekojz57jMNr91Jj6Z/oCkTiUFXX0NHlGu+SbV2Si5gCrKVO7BSsyWRlXDZmov
         iPN0mYn5cbw2JTxpNtp+7rewCS9kK8Rk9duOgnyNWlY/R3QlDgovgiAaqpQ5odytVhG9
         P8Rw==
X-Gm-Message-State: AOAM530bGN0SEVayMMGWQTL2uTkwQa+9SHnDy9YQOuPjNMmRmMp3mSpZ
        2RGMfmcIyrdopRhuTtsVX+4PYE+Whqpp7JcXgdjUuzYsaw==
X-Google-Smtp-Source: ABdhPJwZfMoC74QO9F+UqNNbECHuXUN/j7hFbn1Broo/RJdOcztLDt/AZzopuLRcYVoSxv2IibHJvuduoX2biLV87Os=
X-Received: by 2002:a17:906:6498:: with SMTP id e24mr639141ejm.12.1644955733109;
 Tue, 15 Feb 2022 12:08:53 -0800 (PST)
MIME-Version: 1.0
References: <20220212175922.665442-1-omosnace@redhat.com>
In-Reply-To: <20220212175922.665442-1-omosnace@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 15 Feb 2022 15:08:42 -0500
Message-ID: <CAHC9VhR3qjmq461HyO7OwgicmEmzDjgshdocSqvYEZMk_BfceQ@mail.gmail.com>
Subject: Re: [PATCH net v3 0/2] security: fixups for the security hooks in sctp
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        selinux@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sat, Feb 12, 2022 at 12:59 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
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

This patchset has been merged into selinux/next, thanks everyone!

-- 
paul-moore.com
