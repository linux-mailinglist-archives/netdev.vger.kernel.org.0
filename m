Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6FF3D2B4E
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 19:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhGVRBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 13:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhGVRBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 13:01:45 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA79FC061575;
        Thu, 22 Jul 2021 10:42:19 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so6027433otq.11;
        Thu, 22 Jul 2021 10:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0CGpOumMEibr77QWwS4zy7AyFplRAoVkY0iJCco1AbQ=;
        b=bTxcFfWXYM6eebt68kA0Uho+6Yz61JuKR7fhZ8IxGDseK8vu1H96oJNE3mq6DBAFov
         13uHVs87HYpm2ILgkyU7JR+KAQjwDcZByzqjCHkf3MP26EiGhWCb9IKoE0pJs0IpIpSU
         3mmqszdQVYn1lKS11AYzlZWNk+z8pryRSCu+K1ewLj1ei1kfhQtZzZnogYpuUziV5rJ3
         Gn4/8E97324qU0cY1ETk1qtueGYVZ6+/LR1ANPaIEr/NR+Ef6Vp9DqMRc+/YhszYSkfM
         O0hmJdyr4zWQ0KRVjYBVNAESyla10F+PnmSlP8MCg/qyhQ1AXzF84/2AG1XGCLpAjD5m
         +CVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0CGpOumMEibr77QWwS4zy7AyFplRAoVkY0iJCco1AbQ=;
        b=jT+J/PsnzgQdxS2JH0Lgm+Zlh40wOsx9XEJUY4X6usOMb9hj0w/PxLwuaNJKHQmzhD
         vXOBae8pfJHCfUMTcASD3l2eogxnGV1YQuZRMMtMpZ7OIK/iVZi2TbLGhjSWJQmzgE/S
         +RZOBAeNrf205k3GBshOW3piKqs4vtSCHkiYBidHuIt/nRXyPokkvixj/aDJfCMO3Bft
         +Kk8HcaJZ7jjl6WEccXOvvubhwKIcL3ZOM858prQ7h2EN3TeuRIozO1Dlaz4nTNoyYTM
         y3BxZQeBprgFOJYZg0oN92tY0wO63zc3Dae/bVrRaj0UdACr4xPUPoKkFkXhILjN1eBP
         s6tQ==
X-Gm-Message-State: AOAM531LFrGKBWllsD3UVuT0pRkY4Qvfh9+pF64OVlwwhBk5MI8wCgFs
        HBO3FB1iSsWNPNF63P+0LKQXJvKJIFih5yPWe1Q=
X-Google-Smtp-Source: ABdhPJzkk91dUuIwWjikGhrLpWy2u4nHjEKnOJvDk4Nihpo/+0aGue2ZHLOJytSY2xu/UCB7fYWJ/Z4QodOLNAglm+k=
X-Received: by 2002:a9d:6d83:: with SMTP id x3mr609456otp.110.1626975738738;
 Thu, 22 Jul 2021 10:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <1626968964-17249-1-git-send-email-loic.poulain@linaro.org>
 <CAHNKnsS1yQq9vbuLaa0XuKQ2PEmsw--tx-Fb8sEpzUmiybzuRA@mail.gmail.com> <CAMZdPi_7-2tXGu0fqE4-Dx7MQpL=9St3JTgfTwov402BXBF5hg@mail.gmail.com>
In-Reply-To: <CAMZdPi_7-2tXGu0fqE4-Dx7MQpL=9St3JTgfTwov402BXBF5hg@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 22 Jul 2021 20:42:07 +0300
Message-ID: <CAHNKnsTskbtMYvZhSMW4FBE3NwbOyAQ73C6n__6wT7WoV_5HVw@mail.gmail.com>
Subject: Re: [PATCH] wwan: core: Fix missing RTM_NEWLINK event
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Network Development <netdev@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 7:44 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> On Thu, 22 Jul 2021 at 18:14, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>> On Thu, Jul 22, 2021 at 6:39 PM Loic Poulain <loic.poulain@linaro.org> wrote:
>>> By default there is no rtnetlink event generated when registering a
>>> netdev with rtnl_link_ops until its rtnl_link_state is switched to
>>> initialized (RTNL_LINK_INITIALIZED). This causes issues with user
>>> tools like NetworkManager which relies on such event to manage links.
>>>
>>> Fix that by setting link to initialized (via rtnl_configure_link).
>>
>> Shouldn't the __rtnl_newlink() function call rtnl_configure_link()
>> just after the newlink() callback invocation? Or I missed something?
>
> Ah right, but the first call of rtnl_configure_link() (uninitialized)
> does not cause RTM_NEWLINK event (cf __dev_notify_flags). It however
> seems to work for other link types (e,g, rmnet), so probably something
> to clarify here.

Just check additional netdev creation with hwsim:

# ip link add wwan0.3 parentdev wwan0 type wwan linkid 3

On the other console:

# ip -d mon
6: wwan0.3: <POINTOPOINT,NOARP> mtu 1500 qdisc noop state DOWN group default
    link/none  promiscuity 0 minmtu 68 maxmtu 65535
    wwan numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

But I saw no notification at the moment of wwan_hwsim module loading.
This happens since I missed the rtnl_configure_link() call in the
wwan_create_default_link() after the default link successful creation
:(

So we need your fix at least in the default link creation routine to
fix ca374290aaad ("wwan: core: support default netdev creation").
Something like this:

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 3e16c318e705..374aa2cc884c 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -984,6 +984,8 @@ static void wwan_create_default_link(struct
wwan_device *wwandev,
  goto unlock;
  }

+ rtnl_configure_link(dev, NULL); /* trigger the RTM_NEWLINK event */
+
 unlock:
  rtnl_unlock();

--
Sergey
