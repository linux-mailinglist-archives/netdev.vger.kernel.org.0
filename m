Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D596ED703
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 23:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjDXVxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 17:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDXVxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 17:53:17 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C7F55B2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 14:53:16 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-54fb9384c2dso59315457b3.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 14:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682373195; x=1684965195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMBze88YlKmcCWtwKJfLIKwFr2v3/4J4XaQCXWpL9iM=;
        b=okUMlqI0vRhMJwBg5WlXSpK8r6W75vCbvIJCbPe987QHMJPJ8yzjQkXFEPWieEtQ0K
         FscVopns9CtLGZ2V/cT06FEkn1S7VOZ9ixZK/eY94AckIZecbNtVKxj/NdH2s/sjnfSF
         KdC2jdD0B2tFbY/dGsd8a7ySU/yFu4h4SsVhwpMZYaCnxG0tyIaK71TrmlU8nyS4HBIT
         1RKuq3Zn2DQ1hVKfWHot9xVEGzzPswSR6FodLadbWvKNt5GQQKfoaSMVvQWvTsWpPFHq
         KuAHkuIm8F0pR7NTHPRqMPfUv8tDzhMKt2JUk1n+JtkfIY2vr7XHpVKb5r3vrIFsY6VL
         vSkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682373195; x=1684965195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EMBze88YlKmcCWtwKJfLIKwFr2v3/4J4XaQCXWpL9iM=;
        b=aNbtcpkUXqoSHz4N5z6hZUHB7tnXKrdOmGC67ok5J4VxC6ju3jA9qNN/HWNkamRvCr
         PsJAm6os4rhOEJNTc0shkfIYKg6Hn6ETlxfExZD7KzomCZhijAEJr2EBRUgrxuq3hzL3
         JmUVjqhA7EniA55JrEQbgKef0kGmBubH1evi6B3AcJxLDFlzg5t3fFAKXW3pyv6QZHmq
         /ikPeAtQL+GeQ0VTVswUiGKmKNPFfIs1Atr9/nKLR+yPiExungPNbk5yJI5XO9hV11n8
         mnE+xsBB+sv19MnDosTlTEs7TmFrnd1Vr29KLg0qIqBeg0G+WxcTtyqVtD+xS+XJ0KGg
         WfCA==
X-Gm-Message-State: AAQBX9dZmH8XEaUgBFOfTJ5sRHgMyUsyekmYZbJAZ3XBMxTalvrMd86k
        vtwt/YlefEXgtLktnpojqrbFBaao5yo1RXrePmW2YA==
X-Google-Smtp-Source: AKy350bYvTzKz8N96fzkAhPQPKrW6VeAhAZHq1ltQYtTAnIYL67F4V6Ju8Su232MY/xC75IAnD29dZUx8WACc9GUL8o=
X-Received: by 2002:a0d:e80e:0:b0:552:9fae:d0b with SMTP id
 r14-20020a0de80e000000b005529fae0d0bmr8755385ywe.16.1682373194622; Mon, 24
 Apr 2023 14:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230424170832.549298-1-victor@mojatatu.com> <20230424173602.GA27649@unreal>
 <20230424104408.63ba1159@hermes.local> <CAM0EoMnM-s4M4HFpK1MVr+ey6PkU=uzwYsUipc1zBA5RPhzt-A@mail.gmail.com>
 <20230424143651.53137be4@kernel.org>
In-Reply-To: <20230424143651.53137be4@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 24 Apr 2023 17:53:03 -0400
Message-ID: <CAM0EoM==4T=64FH7t4taURugM4d0Stv2oXFgr5+qNBNEe9bjwQ@mail.gmail.com>
Subject: Re: [PATCH net v2] net/sched: act_mirred: Add carrier check
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Leon Romanovsky <leon@kernel.org>,
        Victor Nogueira <victor@mojatatu.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kernel@mojatatu.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 5:36=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Mon, 24 Apr 2023 13:59:15 -0400 Jamal Hadi Salim wrote:
> > > Then fix the driver. It shouldn't hang.
> > > Other drivers just drop packets if link is down.
> >
> > We didnt do extensive testing of drivers but consider this a safeguard
> > against buggy driver (its a huge process upgrading drivers in some
> > environments). It may even make sense to move this to dev_queue_xmit()
> > i.e the arguement is: why is the core sending a packet to hardware
> > that has link down to begin with? BTW, I believe the bridge behaves
> > this way ...
>
> I'm with Stephen, even if the check makes sense in general we should
> first drill down into the real bug, and squash it.

Ok then, I guess in keeping up with the spirit of trivial patches
generating the most discussion, these are two separate issues in my
opinion: IOW, the driver bug should be fixed (we have reached out to
the  vendor) - but the patch stands on its own.

cheers,
jamal

> --
> pw-bot: cr
