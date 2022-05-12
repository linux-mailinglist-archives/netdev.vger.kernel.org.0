Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42FC524E16
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354295AbiELNUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354291AbiELNUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:20:33 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38692250E8E
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:20:32 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id n24so6331287oie.12
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7nXoyyvMaAJUHyWawkV7HBFsvbJPTnL6l7Z/AXs6GGc=;
        b=fJihkF5OXbN06VgUDoi/X+5uPWdrRfGJQHny251XOs1JlxFcFMM0dIqAf8DvllqF1Q
         se1T++noJWRtUus9ostIHXpTjSTsSKu9qXRkEtfHEqw37jkiDeQsDstLx6PSo8x7msR9
         rUgGQc+7xNJhl4kK3nFCXLiBmLaxKArfObeQ2bOfYqV9I/SwnG0dJUVeMM1f+qJoKqY2
         5c+MvCLOURSu2HIrdsiWkVTTIBh5uHq+jkrNCTI8NYz5LV7HwcF7TSZY2y8udTW3NiPJ
         eTHUqdLh924M9z/nT8D6SmlzgvjXbg6XwAweDQQeRqazXVmi0Up2GLZcK33UFqsc8tPf
         ht3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7nXoyyvMaAJUHyWawkV7HBFsvbJPTnL6l7Z/AXs6GGc=;
        b=e2Sco5D4el3CH0U1wE8WUL8NuXU1eqCEvCefrEwk01+/A7mqtYBdQ0HIHL7eXKXerf
         yDQtt8+ZxZHVC6YMrmRCY3t2zI9OMQ4Dcvbzr3mRgGcQAnTHA1JARY4tOsrgMN38VjyL
         fDXGp6NrYHbh4BJ2FS4Pm28oKOwWKCMvfh6kcl6RazlRwo4t5HPnHpgIpvAwtDXyTA1X
         LEr48XBe2nGdwMu7rcJ0ciSVpffFBpXi/KWQCsdaQwrA+ah5lZRWH/yieJk4YLxSPWGJ
         5puU+7diOEnywERhtCOxmj38x00hV54LlywPEV0hzUEfSUH0qbM7lX6OHCn+qLvs3TM0
         6m0g==
X-Gm-Message-State: AOAM5325weNTYzQjKKR+t07q7xCXyUx/52fXSTKGviQ/4rLwDIj1G+oz
        Sm4d9fx94aunkH4KWRRMwbLtPMzpXIxHebDWtivBCg==
X-Google-Smtp-Source: ABdhPJzJX2XKFtTs2CMjlsmuOJXmk/1VJLZ9S6rNGjD9j0er5WpKb0AXain9zQmKFwH1J/ri42uATFiz4bshXiVVj/A=
X-Received: by 2002:a05:6808:16a4:b0:2f7:1fd1:f48 with SMTP id
 bb36-20020a05680816a400b002f71fd10f48mr5113912oib.163.1652361631336; Thu, 12
 May 2022 06:20:31 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000086205205b0fff8b2@google.com> <000000000000c86f9d05d57b594d@google.com>
In-Reply-To: <000000000000c86f9d05d57b594d@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 12 May 2022 15:20:19 +0200
Message-ID: <CACT4Y+ZqX84gCjcxtsRSan4Rf8C26rH5xQ7LfwnNHOqx0fDFjA@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in ieee80211_chanctx_num_assigned
To:     syzbot <syzbot+00ce7332120071df39b1@syzkaller.appspotmail.com>
Cc:     arunkumar@space-mep.com, davem@davemloft.net,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        phind.uet@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 at 20:04, syzbot
<syzbot+00ce7332120071df39b1@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 563fbefed46ae4c1f70cffb8eb54c02df480b2c2
> Author: Nguyen Dinh Phi <phind.uet@gmail.com>
> Date:   Wed Oct 27 17:37:22 2021 +0000
>
>     cfg80211: call cfg80211_stop_ap when switch from P2P_GO type
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16afe84bb00000
> start commit:   7f75285ca572 Merge tag 'for-5.12/dm-fixes-3' of git://git...
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b5591c832f889fd9
> dashboard link: https://syzkaller.appspot.com/bug?extid=00ce7332120071df39b1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1393cbf9d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1238ba29d00000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Looks legit:

#syz fix: cfg80211: call cfg80211_stop_ap when switch from P2P_GO type
