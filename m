Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97066650EA2
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiLSPbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbiLSPa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:30:59 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF5921BA;
        Mon, 19 Dec 2022 07:30:57 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d82so6473994pfd.11;
        Mon, 19 Dec 2022 07:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AW2GlRcYIzwFd0FF5U4Py3ypyOgrWMB/b3sWQqDwzG8=;
        b=C7pQxfo9/JZ/CYjpCF6+ETurYI6L+Jn7sIh9/EKWflNzhjvszs/BUz1hmm1PLN7aNK
         LPFj4ICbKQ5ZhVNMo5d6Rqft8nBe43lx4EwCQmLci9Llcu55OaZF037OaYo3BW/nPVjm
         dw346t7+eGUATbbRuwfi+Qef0i8M6yASSQahSJZN5zn/h2f0/UaJVvPvaGk5Hp86RoGm
         o9QEScnwDjiRmRL4d4l7fzJUrHE/xW5VlZfuKAX+Jy1egDJIsOLvRhi3cFPDYzV8Ph65
         r0AbWeevNMud9q7wqBxCZRFOswK50yHwOoVRleSawOKAkaRvTZCg0YMqKbkmRzaUZq3n
         72Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AW2GlRcYIzwFd0FF5U4Py3ypyOgrWMB/b3sWQqDwzG8=;
        b=CgmPUmZoxG87F8gjJyNB9ZpUjdIGk9zHOVNh8elkU/uHU0gcyaLulM1h4n1P5tVOt8
         UauxYoRDWyrznvfySFJxqoSQlc5TD5G5RhzUQPeNkEA2GR09r5euXiK56Y64hg/g7PcR
         PffvIjYhN9h+Xpw4Ed8h0j3RhbSA07ve1q6FUh78+95LTO5dc7Ejh5W7VvGGfi3/gRu7
         z6kai6muJibMrC5mUef2IKUF8UWkVMYgSa/LEQ+e47fgbCoSYzFTQMO0yYJ8kV8LtAtn
         h3+f+pANr28MBUlKGkzM3mvN5fPNn2+bwmHU72WuCt/ZzQdWTtODZrM6p9h+x91Fp1KP
         BTIw==
X-Gm-Message-State: ANoB5plt91RFemucJPaBRkvw+ZfJA6sHtfx5GLOKapBRagocxDL1Fh2E
        gG0i9KP0oGqYLV0+bf5im9m+s9MqmTuiVbDmqP0=
X-Google-Smtp-Source: AA0mqf5PSWvs90NUbrlLS+dMj+p6JR2lluCE7gSgs/wsWna4lj2h3qnFitPSPVhI/sdNM1kdiMMgQlhhAPuBit5gjEE=
X-Received: by 2002:a05:6a00:d01:b0:577:ab75:cec9 with SMTP id
 k1-20020a056a000d0100b00577ab75cec9mr5476941pfv.44.1671463857255; Mon, 19 Dec
 2022 07:30:57 -0800 (PST)
MIME-Version: 1.0
References: <20221213074726.51756-1-lianglixuehao@126.com> <Y5l5pUKBW9DvHJAW@unreal>
 <20221214085106.42a88df1@kernel.org> <Y5obql8TVeYEsRw8@unreal>
 <20221214125016.5a23c32a@kernel.org> <Y57SPPmui6cwD5Ma@unreal>
In-Reply-To: <Y57SPPmui6cwD5Ma@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 19 Dec 2022 07:30:45 -0800
Message-ID: <CAKgT0UfZk3=b0q3AQiexaJ=gCz6vW_hnHRnFiYLFSCESYdenOw@mail.gmail.com>
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in case
 of invalid one
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lixue Liang <lianglixuehao@126.com>,
        anthony.l.nguyen@intel.com, linux-kernel@vger.kernel.org,
        jesse.brandeburg@intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        lianglixue@greatwall.com.cn
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 18, 2022 at 12:41 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Dec 14, 2022 at 12:50:16PM -0800, Jakub Kicinski wrote:
> > On Wed, 14 Dec 2022 20:53:30 +0200 Leon Romanovsky wrote:
> > > On Wed, Dec 14, 2022 at 08:51:06AM -0800, Jakub Kicinski wrote:
> > > > On Wed, 14 Dec 2022 09:22:13 +0200 Leon Romanovsky wrote:
> > > > > NAK to any module driver parameter. If it is applicable to all drivers,
> > > > > please find a way to configure it to more user-friendly. If it is not,
> > > > > try to do the same as other drivers do.
> > > >
> > > > I think this one may be fine. Configuration which has to be set before
> > > > device probing can't really be per-device.
> > >
> > > This configuration can be different between multiple devices
> > > which use same igb module. Module parameters doesn't allow such
> > > separation.
> >
> > Configuration of the device, sure, but this module param is more of
> > a system policy.
>
> And system policy should be controlled by userspace and applicable to as
> much as possible NICs, without custom module parameters.
>
> I would imagine global (at the beginning, till someone comes forward and
> requests this parameter be per-device) to whole stack parameter with policies:
>  * Be strict - fail if mac is not valid
>  * Fallback to random
>  * Random only ???
>
> Thanks

So are you suggesting you would rather see something like this as a
sysctl then? Maybe something like net.core.netdev_mac_behavior where
we have some enum with a predetermined set of behaviors available? I
would be fine with us making this a global policy if that is the route
we want to go. It would just be a matter of adding the sysctl and an
accessor so that drivers can determine if it is set or not.
