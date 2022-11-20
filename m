Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC87C631511
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 17:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiKTQJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 11:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiKTQJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 11:09:33 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025602408D
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 08:09:33 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-39115d17f3dso86793357b3.1
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 08:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UO70B7phnyoLseCqZJMNls/H5oUiAGjgzVRSYZX7L1A=;
        b=KpX6rW7fECQJxtHXzd2KQkLTlszL1aCbc6RUwYhrWNrWzX0puI68W055/PalL9Zwxn
         9HGSFmIW+6pn0Lr0zEhDNk5ldSfPJe4TFjxCY9vnfF/1K7zjys4dD30xC3c1NwxTUfgj
         VdYeo/sJJCAByrJ1XkQewCbiwwCSeQIhHm21+YYCW80e+pc+hNZtAzUTHCQzSVThN7oU
         WcLcq0A3z/cnnvGGeA7qKOJvfGw72YLozpAushchpXTEklQELpGaNbB43BRUhbml+Xn7
         2rkt5OSnJosTcgrDas3KEJiyVSe0mf9zLWtXXqywOBL5OzojO/EXRMrZ4I/1N45Mr1tP
         8qwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UO70B7phnyoLseCqZJMNls/H5oUiAGjgzVRSYZX7L1A=;
        b=QjV2/J8w9OA59tkFLXRzpGfRrt4O+UrTNxOm6qSF3m4vIXIIPHAQH2UMUzvt8vagTf
         awsxdh4NsX7cu8aAZ83mp+VOwosu9+qWmWlEtZzasrf1vnEbeYjUI3nOhtXXIMuSdUYM
         2MiJwIlXmyfejeILaPUfxqTyKarXpSPb5hBgfUNcPRtAydHWPcanRAQaEu6XH8r0t0gh
         Fo7p6PtSA8YzzZToEl5lv87o0tYruDSmk0PiNUbatnUGCjYoVZLXR1TYQB3jZC6iKcEO
         CoqnsHmStWVKpUd3dJ1V91qqqnOlhgrtpnAX2xu9azHlJjDYi0D/ilKzY/52etVhHcVu
         D4EA==
X-Gm-Message-State: ANoB5pk8KUeSDKG6LZGWF2JdrWsg118gSpbCe6b3mOAJzkiuCs5PpTzK
        ycAuO2yzZk7MC9LLqxvqTSHZ0Wzdfd6ZwzyU/GOIFxk6bsU=
X-Google-Smtp-Source: AA0mqf5JNHf//F6jj7OtbLTnpMr6e8KHMHaL2A5DHRw8J3brjZV7gw00R7JZHrlCfSOb/tWIE8rontKNFEk5BwvCJeA=
X-Received: by 2002:a81:5f04:0:b0:393:ab0b:5a31 with SMTP id
 t4-20020a815f04000000b00393ab0b5a31mr12020079ywb.55.1668960571948; Sun, 20
 Nov 2022 08:09:31 -0800 (PST)
MIME-Version: 1.0
References: <20221018203258.2793282-1-edumazet@google.com> <162f9155-dfe3-9d78-c59f-f47f7dcf83f5@nvidia.com>
 <CANn89iKwN9tgrNTngYrqWdi_Ti0nb1-02iehJ=tL7oT5wOte2Q@mail.gmail.com>
 <20221103082751.353faa4d@kernel.org> <CANn89iJGcYDqiCHu25X7Eg=s2ypVNLfbNZMomcqvD-7f0SagMw@mail.gmail.com>
 <CAKErNvoCWWHrWGDT+rqKzGgzeaTexss=tNTm0+9Vr-TOH_8y=Q@mail.gmail.com>
 <CANn89iL2Jajn65L7YhqtjTAVMKNpkH0+-zJtQwFVcgrtJwxEWg@mail.gmail.com>
 <46dde206-53bf-8ba8-f964-6bcc22a303c7@nvidia.com> <15d10423-9f8b-668a-ba14-f9c15a3b3782@nvidia.com>
 <9f4c2ca9-bc6d-f2bf-6c03-e95affb55aae@nvidia.com>
In-Reply-To: <9f4c2ca9-bc6d-f2bf-6c03-e95affb55aae@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 20 Nov 2022 08:09:20 -0800
Message-ID: <CANn89iJkdQ9eBkwmWMcf7uKwB=cY8hbwo2Jqdtwo3mpjswAFHg@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix race condition in qdisc_graft()
To:     Gal Pressman <gal@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>, eric.dumazet@gmail.com,
        syzbot <syzkaller@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
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

On Sat, Nov 19, 2022 at 11:42 PM Gal Pressman <gal@nvidia.com> wrote:
>
> On 10/11/2022 11:08, Gal Pressman wrote:
> > On 06/11/2022 10:07, Gal Pressman wrote:

> >> It reproduces consistently:
> >> ip link set dev eth2 up
> >> ip addr add 194.237.173.123/16 dev eth2
> >> tc qdisc add dev eth2 clsact
> >> tc qdisc add dev eth2 root handle 1: htb default 1 offload
> >> tc class add dev eth2 classid 1: parent root htb rate 18000mbit ceil
> >> 22500.0mbit burst 450000kbit cburst 450000kbit
> >> tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst
> >> 89900kbit cburst 89900kbit
> >> tc qdisc delete dev eth2 clsact
> >> tc qdisc delete dev eth2 root handle 1: htb default 1
> >>
> >> Please let me know if there's anything else you want me to check.
> > Hi Eric, did you get a chance to take a look?
>
> No response for quite a long time, Jakub, should I submit a revert?

Sorry, I won't have time to look at this before maybe two weeks.

If you want to revert a patch which is correct, because some code
assumes something wrong,
I will simply say this seems not good.

I think this offload code path needs more care from nvidia folks.
