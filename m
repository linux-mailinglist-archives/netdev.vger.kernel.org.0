Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8114C2B71C9
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgKQWoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbgKQWn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 17:43:59 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B104EC0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 14:43:59 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id t13so197123ilp.2
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 14:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8mEaGZ9JSgyO5QxbIh9RVYFKLSFIX0M76gaNGsdHHKY=;
        b=VBnxBm5vZAKEFgriIPutSnAPepw87PABWphpa7b9X87JIoOlMJ06AFLOLisNmtdhVb
         d+651rmahj02ehIG9ke8rL7mmf2gukmzFKrH6+L1cfON3OpxXmyoNXFN6ej/ytNnoslg
         Obxp79RCAjTETsy8dXJ0rGFXz+2l2NnFnyuTafK/ExBRZN9E4wpcxH74U8NM6QPw742O
         DPff5HP9dKb0WqsCukAlAii3C6uqiMh3i70AzmbKwPRjTqjFVqx8qNI3YzMqZYYXC7bB
         Jgo6ngPNpgZ/wSTGinxL6MUHatcGcOTjIS4QlJmCUhWKrjSqB1qMQoSRUE0X2Sced5di
         rUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8mEaGZ9JSgyO5QxbIh9RVYFKLSFIX0M76gaNGsdHHKY=;
        b=QDrGLVa93o8t7B806txZNyVGu2K8yJ5b2OkjBTQEvGDZia1/5MGi0MN24b/l/dWmuY
         sOFmSrxJ1wX2GH7aNucKP4Bm05XZKXaCcbhnqX3xireMiKqgVMaBJzeRussnGOZiDmre
         BMnYssHFlrFDcz7YHZN6rB+4NCr/d4miBoWS0hbSikQVnfoDeZYWNhU6hkC1fW0EFPsp
         JNMwl98x7Vay4nZrChooAUv9AsnUY5F9hPozkYfimFNZeBTjmlrYWmSdivF0catYnKUQ
         ULNYx8Kf6eQJltMyNdsuxT2vxxV8BHC//aVojC99TJkis33DArsM7Av9YPnIckjwp1Zg
         7g1Q==
X-Gm-Message-State: AOAM530P8FAgqNu2/yTgAhcez/nMESqACLbsKufsspURs+i5ZGarBnmM
        ItncIeb3IlQGXoPTvHnXCY6Za61k+lS4Ygi0DwQ=
X-Google-Smtp-Source: ABdhPJzK8JllimrjNnrVx9XrRQ/bi2i2+Apl00vllPlq10413sllRQElNPT3ui7qJecCFgzwHjXSm98FQ9VyiOgDE84=
X-Received: by 2002:a92:de50:: with SMTP id e16mr14002927ilr.144.1605653039069;
 Tue, 17 Nov 2020 14:43:59 -0800 (PST)
MIME-Version: 1.0
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
 <1605151497-29986-4-git-send-email-wenxu@ucloud.cn> <CAM_iQpUu7feBGrunNPqn8FhEhgvfB_c854uEEuo5MQYcEvP_bg@mail.gmail.com>
 <459a1453-8026-cca1-fb7c-ded0890992cf@ucloud.cn> <CAM_iQpXDzKEEVic5SOiWsc30ipppYMHL4q0-J6mP6u0Brr1KGw@mail.gmail.com>
 <2fe1ec73-eeeb-f32e-b006-afd135e03433@ucloud.cn>
In-Reply-To: <2fe1ec73-eeeb-f32e-b006-afd135e03433@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 17 Nov 2020 14:43:48 -0800
Message-ID: <CAM_iQpXtw4YLWjoSGwxhZMnG8Kismiu-nmqgFJpsZ6AuzX82tg@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
To:     wenxu <wenxu@ucloud.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 8:06 PM wenxu <wenxu@ucloud.cn> wrote:
>
>
> On 11/17/2020 3:01 AM, Cong Wang wrote:
> > On Sun, Nov 15, 2020 at 5:06 AM wenxu <wenxu@ucloud.cn> wrote:
> >>
> >> =E5=9C=A8 2020/11/15 2:05, Cong Wang =E5=86=99=E9=81=93:
> >>> On Wed, Nov 11, 2020 at 9:44 PM <wenxu@ucloud.cn> wrote:
> >>>> diff --git a/net/sched/act_frag.c b/net/sched/act_frag.c
> >>>> new file mode 100644
> >>>> index 0000000..3a7ab92
> >>>> --- /dev/null
> >>>> +++ b/net/sched/act_frag.c
> >>> It is kinda confusing to see this is a module. It provides some
> >>> wrappers and hooks the dev_xmit_queue(), it belongs more to
> >>> the core tc code than any modularized code. How about putting
> >>> this into net/sched/sch_generic.c?
> >>>
> >>> Thanks.
> >> All the operations in the act_frag  are single L3 action.
> >>
> >> So we put in a single module. to keep it as isolated/contained as poss=
ible
> > Yeah, but you hook dev_queue_xmit() which is L2.
> >
> >> Maybe put this in a single file is better than a module? Buildin in th=
e tc core code or not.
> >>
> >> Enable this feature in Kconifg with NET_ACT_FRAG?
> > Sort of... If this is not an optional feature, that is a must-have
> > feature for act_ct,
> > we should just get rid of this Kconfig.
> >
> > Also, you need to depend on CONFIG_INET somewhere to use the IP
> > fragment, no?
> >
> > Thanks.
>
> Maybe the act_frag should rename to sch_frag and buildin kernel.

sch_frag still sounds like a module. ;) This is why I proposed putting
it into sch_generic.c.

>
> This fcuntion can be used for all tc subsystem. There is no need for
>
> CONFIG_INET. The sched system depends on NET.

CONFIG_INET is different from CONFIG_NET, right?

Thanks.
