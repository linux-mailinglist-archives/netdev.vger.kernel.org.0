Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF69844151D
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 09:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhKAIO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 04:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhKAIOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 04:14:19 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5DEC061203;
        Mon,  1 Nov 2021 01:11:46 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g10so61396807edj.1;
        Mon, 01 Nov 2021 01:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yb6wWrUbG7viwzKLb+1mNEqFRnMxKsiQ/RoGbQMQPPI=;
        b=Hq1x1YFpGyGQ2qsQwEZSRbX0ksnJwrTlqtAZcHnn1WlTd32QEqTUbbVAHLPPyY7Fhp
         /9QJDDovb7J5tyqpJC8iWD155fi7hThKAVDza+/Ky7TR3g/RlygG2toNMowubwmbW6TX
         kRuxF750VZsT2y3PbEJlkmGtbWMY5JOowZaXIb9MKjpN0D9PPDCgwcLiE1ev7zUiKMuS
         azkpLpbrvZe8mk+eBMD0d+HGCesTTqJVcn7xlld83YcFK+nT2O1yXDHScY0rbF4GiKgm
         TpriSTwLu69Pa5dT074fOkYgiE2aGtGYqs8TEsO9lvktAH1tePN0uh0JrS4uO4HW0rtz
         NFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yb6wWrUbG7viwzKLb+1mNEqFRnMxKsiQ/RoGbQMQPPI=;
        b=lOAQCvL+7sqJc90QwDhcEKLlvNP/fv1ge8FCN7C5j8/P08WShdVqzPhUbEmOL9NYyc
         3dhtV6BC8dvdfVwB8pOSSZFRn7Sd3rGJ/YH3RPFhw7cJ/Xf1hmHD6PCKfnuwQNdJ3vew
         jj6nIGe2VpMJtcN2H4iJTXItaEfcpF9HZIYEAxPeC2qhVT7yCH35U2onL2Hov1raBpCD
         ZhPB4mqzxrDfMEK5YR+It5EYpr+dNDv63QDmC8p2e4lG/fk6D7OieIGQJ8aBscvYU3Xq
         FN1CnXLJGA+MuALONayTu7tKzoYsd3v1SjqM5FpQV5Ij+rDX94KanyNxfWkaoOMu0uTg
         QVlQ==
X-Gm-Message-State: AOAM533nSUYLksVlsXA4DG1zgiNry2STEO+DaBkUMyVP+UuiuYz4JsZ9
        rAH49a1KLVEmCSCSjaZKHKnDu/shlNK/m91Nt10=
X-Google-Smtp-Source: ABdhPJwNhVh/tYLsqn4p6XyUPSYAYem5Kg5yeGGvbKvzWmOHpDpy6n7G8yoBWYI7//3lGluZv9dqDNflYGBTN/aC65k=
X-Received: by 2002:a17:906:6dd2:: with SMTP id j18mr34607249ejt.468.1635754304577;
 Mon, 01 Nov 2021 01:11:44 -0700 (PDT)
MIME-Version: 1.0
References: <20211101040103.388646-1-mudongliangabcd@gmail.com> <3170956.dbteMgFBTL@ripper>
In-Reply-To: <3170956.dbteMgFBTL@ripper>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 1 Nov 2021 16:11:18 +0800
Message-ID: <CAD-N9QUFFchS=rWjy1GN14CKM+9NXE0C4tnR7zS3h-jZR_T9wA@mail.gmail.com>
Subject: Re: [PATCH] net: batman-adv: fix warning in batadv_v_ogm_free
To:     Sven Eckelmann <sven@narfation.org>
Cc:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antonio Quartulli <antonio@open-mesh.com>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 3:46 PM Sven Eckelmann <sven@narfation.org> wrote:
>
> On Monday, 1 November 2021 05:01:02 CET Dongliang Mu wrote:
> > Call Trace:
> >  __cancel_work_timer+0x1c9/0x280 kernel/workqueue.c:3170
> >  batadv_v_ogm_free+0x1d/0x50 net/batman-adv/bat_v_ogm.c:1076
> >  batadv_mesh_free+0x35/0xa0 net/batman-adv/main.c:244
> >  batadv_mesh_init+0x22a/0x240 net/batman-adv/main.c:226
> >  batadv_softif_init_late+0x1ad/0x240 net/batman-adv/soft-interface.c:804
> >  register_netdevice+0x15d/0x810 net/core/dev.c:10229
>
> This is definitely not a backtrace of the current code and its error handling.
> Please check the current code [1] and explain the situation against this
> version.

Yes, you're right. The error handling code in the upstream is not
prone to this bug.

My local syzkaller instance is fuzzing on 5.14-rc5


>
> Kind regards,
>         Sven
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/batman-adv/main.c?id=ae0393500e3b0139210749d52d22b29002c20e16#n237
