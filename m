Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6CB6BCB4D
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjCPJpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCPJpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:45:47 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CA0132C1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:45:40 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id v196so1101410ybe.9
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678959939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PL0tQXf5SFCsGKBMuc8bU2oCMePhl+bBRd8wAwAZ5XA=;
        b=T7Vq9U2jhaMBYnMKzxU9JoOzqhwzpnMHSsuYU6GCzR2pYojcaXm4aQnvmJlZ7Lgaa7
         9/flfJLCKQfoljq8U51RaA98EhAiwk3HvBavEcZtZ88XEYQcu6c/EhZ2vj/7qvKtLBj6
         2UxKroOaUiXJPHYrevbDz1VZGOZrP2Gu10nR/XQu8eJOd31H1VVmWfyzGKUy+Ms8z5zK
         /+QhRFnkG1M12Xg8p3PLziv3A+NMagngJmU0Ro+dV3zjM5/nwDYREC4+1riJ9cpSYR2s
         7ZBGx3u1fBRFumvMjXTG/37QkD519fYrm7d2uXzIxDOJAU2n9YYwidpzcYerhyFYIrB4
         BL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678959939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PL0tQXf5SFCsGKBMuc8bU2oCMePhl+bBRd8wAwAZ5XA=;
        b=urRTj1GEpPdJKQYbAh1vhumqFfHit4ha2zordqTPnpSiA6xw6LKqIrkTPyeQQdhGQN
         P+aqYuWs4I7bg3T4JOK6LBkvnuZ30FLv20b/VrQIS0qHl4jG6qPez/kcvZveu7nkX6gR
         Ci9xpbFWrbFzHkfgI4e4ZHmCBhakWWXaF7Fgep8HIsNPye4uTBu3rKU7olaJvYXUGdw3
         uXA/JTwa7MNb1Lx53C2HgkytkanDvb2QXE2LVqtHcYgPIF4RGoB/+J15BHlKRJ1eZRQO
         CduZ1q3McVEnJf5ONkOLRBblS+0zDJooccl3Th3HoarHMvaaiWaTxI0nobeaWV96Tma1
         fzUA==
X-Gm-Message-State: AO0yUKWkM2fBs6Q1FSjq+7AS9plevyU4PtXD19XnhvuDMV8qp7W6YjaS
        +l0r5SwRkUl0EqUI4Upk3hLYA0vYmXwg9bXmPchzag==
X-Google-Smtp-Source: AK7set80xJrXTllzuta4NMY7WbV3u2cfRrAAofd5p2sAz+McWIdxP+QTUmfMy9XFmL3j0ednaHAlcofioNvLvyH/Vig=
X-Received: by 2002:a05:6902:208:b0:acd:7374:f154 with SMTP id
 j8-20020a056902020800b00acd7374f154mr28011335ybs.7.1678959939479; Thu, 16 Mar
 2023 02:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230316033753.2320557-1-liuhangbin@gmail.com> <ZBKTPrBONJwvm+rP@Laptop-X1>
In-Reply-To: <ZBKTPrBONJwvm+rP@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 16 Mar 2023 05:45:28 -0400
Message-ID: <CAM0EoMkytZ26ZafxKBG3-EpXow_nWyrxye18Prr8JQ-VTVovpg@mail.gmail.com>
Subject: Re: [PATCHv2 net 0/2] net/sched: fix parsing of TCA_EXT_WARN_MSG for
 tc action
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 11:55=E2=80=AFPM Hangbin Liu <liuhangbin@gmail.com>=
 wrote:
>
> On Thu, Mar 16, 2023 at 11:37:51AM +0800, Hangbin Liu wrote:
> > In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_M=
SG
> > to report tc extact message") I didn't notice the tc action use differe=
nt
> > enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc acti=
on.
> >
> > Let's rever the previous fix 923b2e30dc9c ("net/sched: act_api: move
> > TCA_EXT_WARN_MSG to the correct hierarchy") and add a new
> > TCA_ROOT_EXT_WARN_MSG for tc action specifically.
>
> Sigh. Sorry I sent the mail too quick and forgot to add
>
> Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>

For next time: instead of saying in the commit message "suggested by
foo" specify it using "suggested-by: foo" semantics.

cheers,
jamal
