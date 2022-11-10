Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FFF62490F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 19:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiKJSHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 13:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiKJSHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 13:07:33 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06353BF76
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:07:29 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 131so3253690ybl.3
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EyAhSPI88oXlRwNpQRM5g7+QtFrLcuE/TcOa+Pp5OdY=;
        b=sGi5Sf+djWJ/Wjcy4WDUiCuoK2f5jb4wK+NFslXDH0XJvRd8yY+IMIRvj3Sj6qIajo
         936XJ37d/8knxE3vW97fDoIuzVcQJn1hHeJ1xvBm3ful6R1F5U/axhf4iWJFkDQxFHkF
         x4dfzwJ5ZH+qIM56xSopKQPFR4iPU40LwfWzcXRyfNBEy4d24kIg8ABoIeAM2vnwa/iR
         3Mv0/Qg0SabtMYzNroEzhV+PWp6yp+2Eh3YoH4qhRFGZQYHU5Q95HXWi1QRdJSUy2y0a
         0jre7v7H5AgXx7a6uixZxU0EdITIZT9IsJboPpHuVX524+h55iCLjjvLlqOT62xTgon5
         Si+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EyAhSPI88oXlRwNpQRM5g7+QtFrLcuE/TcOa+Pp5OdY=;
        b=xYBFxPCB3VFVRhtClvoOUsYGszZdrXNfqqncu/PV44wg3FJoeMTHu5TFi712fqiXfi
         08LPaFJBKGiJlUOpydchFr66fI8EimpjL7u2WucbhF8KbJbrEvqCRlRuVU1sIsisheYH
         8igpepwMFxjIHi2sTxDoHrEV3yKM/jxni0zKCyZLbmrnK70/L6gTidiDpaR8RizRAFuK
         bIgUbZz615GHmr2qtLFHrLpZLtc4oA/fEi2bGZeRWuTJ3mfmBtRxBrTFWKv7bhPXhYHU
         f+ZPML6DEMC0q1msD/bsSS1SgpIOJavc+uaLdp0oM9jkmz+XPqUT0KCzXEjcYxkXsd/j
         Q9Yg==
X-Gm-Message-State: ANoB5pky3dY6BDT9ntOZIvOC6C9B8V1RkmBueGuuVw6D9VC9rrbZAq0Q
        +FVfH2SJnXaXD/yl3rPio0moLbiFM0RX/jd8hWbo9A==
X-Google-Smtp-Source: AA0mqf5V/6r259p+syK30cxNZizZjC7GivlxLK6+nAsj5PKTnWthjYFBQRjmK34GMvNFk6XDlo6Uqb3hPcJfw68ZVBw=
X-Received: by 2002:a25:50c9:0:b0:6dd:c761:8db6 with SMTP id
 e192-20020a2550c9000000b006ddc7618db6mr1003865ybb.36.1668103647973; Thu, 10
 Nov 2022 10:07:27 -0800 (PST)
MIME-Version: 1.0
References: <20221108132208.938676-1-jiri@resnulli.us> <20221108132208.938676-4-jiri@resnulli.us>
 <Y2uT1AZHtL4XJ20E@shredder> <CANn89iJgTLe0EJ61xYji6W-VzQAGtoXpZJAxgKe-nE9ESw=p7w@mail.gmail.com>
 <20221109134536.447890fb@kernel.org> <Y2yuK8kccunmEiYd@nanopsycho>
 <CANn89iLhbTB8kZwE7BhK76ZsLmm5aKv78q+1QYcbs7gDFCU6iA@mail.gmail.com> <Y209Hb95UX3Wcb6r@shredder>
In-Reply-To: <Y209Hb95UX3Wcb6r@shredder>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Nov 2022 10:07:16 -0800
Message-ID: <CANn89iLZmF_YN-J009EmgQXhf9b6J6mKw4eY=Ui029T6oV6m1A@mail.gmail.com>
Subject: Re: [patch net-next v2 3/3] net: devlink: add WARN_ON to check return
 value of unregister_netdevice_notifier_net() call
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com
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

On Thu, Nov 10, 2022 at 10:04 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Nov 10, 2022 at 09:21:23AM -0800, Eric Dumazet wrote:
> > On Wed, Nov 9, 2022 at 11:54 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > >
> > > Wed, Nov 09, 2022 at 10:45:36PM CET, kuba@kernel.org wrote:
> > > >On Wed, 9 Nov 2022 08:26:10 -0800 Eric Dumazet wrote:
> > > >> > On Tue, Nov 08, 2022 at 02:22:08PM +0100, Jiri Pirko wrote:
> > > >> > > From: Jiri Pirko <jiri@nvidia.com>
> > > >> > >
> > > >> > > As the return value is not 0 only in case there is no such notifier
> > > >> > > block registered, add a WARN_ON() to yell about it.
> > > >> > >
> > > >> > > Suggested-by: Ido Schimmel <idosch@idosch.org>
> > > >> > > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> > > >> >
> > > >> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> > > >>
> > > >> Please consider WARN_ON_ONCE(), or DEBUG_NET_WARN_ON_ONCE()
> > > >
> > > >Do you have any general guidance on when to pick WARN() vs WARN_ONCE()?
> > > >Or should we always prefer _ONCE() going forward?
> > >
> > > Good question. If so, it should be documented or spotted by checkpatch.
> > >
> > > >
> > > >Let me take the first 2 in, to lower the syzbot volume.
> >
> > Well, I am not sure what you call 'lower syzbot volume'
> >
> > netdevsim netdevsim0 netdevsim3 (unregistering): unset [1, 0] type 2
> > family 0 port 6081 - 0
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 41 at net/core/devlink.c:10001
> > devl_port_unregister+0x2f6/0x390 net/core/devlink.c:10001
>
> Hi Eric,
>
> That's a different bug than the one fixed by this patchset. Should be
> fixed by this patch:
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20221110085150.520800-1-idosch@nvidia.com/

OK, I will dup the new syzbot report, thanks.
