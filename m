Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00E5543FB8
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 01:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiFHXBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 19:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiFHXBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 19:01:11 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395BD3A5C5
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 16:01:07 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-3137eb64b67so23016187b3.12
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 16:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yDmHaHfbP+V5NY5ockejgPMau+3mt71MxfGCliwuimo=;
        b=U5ZIepD986IE19Jdtz/JfQMpmGlOdj0Ma4qhBU6FvPG2yVumX/iIIxTkGWJvdARXmm
         crsUsGKAq+kZMs6Hsp0nX0/r6mck2nTRwjJ7WYltXAly8x2IeLGDEZSyxkyQ+CouzR+b
         GItTca7O9lML9JZiCZp9jl/ZrV9mXpgSAtsak14LlmxBcGt3919lfyPt1EtJt9+JsFq6
         6YCWY8yLavOYfz/nthcyHUBmrA4V3xKtIYPD7qH6NsA7jUdazC0A7h7D+2MgMR0wM2st
         fP/2jPgNzHEg2YS3QcplziHBkH2gfNGSQnrGm26XbAAvxK6HwQT9ZDG/CPFb8tzYzNSq
         zJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yDmHaHfbP+V5NY5ockejgPMau+3mt71MxfGCliwuimo=;
        b=uPSdWqzK99vZQ9Krkb957OFZmGRgcBEL19Kz+gtNWC5IzuimNBOi1oO7h+sZtKSytm
         Xwbi7xS7s3ou62lvNAUD5HZFb+G6zSh2FZuO0ju0EYK0Oqi/WH0tJ/Uo0gHWOrFhh868
         nMZfWkfXJFgs2VINdM+QWECJ30n0kVKTpBg8DdaeRKAOrt+ekqh150QmS7VWIlxr/taQ
         pBLuTW5RB1xyjKAWzDCrtrDxKRJceWemjXuM5z/H1e0AcS7kuka5soIPYdzI3Qx7YokG
         PYFakpxJaJxLcipT33Vzb7OMXeYhjY4QkPXi7jmEQ+v48VrGksdQBLokHt4qFa+zWVJw
         fOAw==
X-Gm-Message-State: AOAM533eQFU7cvoLQTvFJsMqx62vYS2qut80Oig+EiN79KchDD2rDYZj
        o9pzAQZ+eRFddLfjHaPVtV2Y18Ll3l8Bs5Z08Eqf1Q==
X-Google-Smtp-Source: ABdhPJwXPAtFJ3hcM0FYypq2XpNnECxN58WQ6asEspJUeRhsllm3ijXI6/gj4cz2GW5rMuEbXfKHAfOJyU3ee4JxYGY=
X-Received: by 2002:a81:4811:0:b0:30c:8021:4690 with SMTP id
 v17-20020a814811000000b0030c80214690mr40028374ywa.47.1654729266114; Wed, 08
 Jun 2022 16:01:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220608043955.919359-1-kuba@kernel.org> <YqBdY0NzK9XJG7HC@nanopsycho>
 <20220608075827.2af7a35f@kernel.org> <f263209c-509c-5f6b-865c-cd5d38d29549@kernel.org>
In-Reply-To: <f263209c-509c-5f6b-865c-cd5d38d29549@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Jun 2022 16:00:54 -0700
Message-ID: <CANn89i+RCCXQDVVTB+hHasGmjdXwdm8CvkPQv3nYSLgr=MYmpA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: rename reference+tracking helpers
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        jreuter@yaina.de, razor@blackwall.org,
        Karsten Graul <kgraul@linux.ibm.com>, ivecera@redhat.com,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Xin Long <lucien.xin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Yajun Deng <yajun.deng@linux.dev>,
        Antoine Tenart <atenart@kernel.org>, richardsonnick@google.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-hams@vger.kernel.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 3:58 PM David Ahern <dsahern@kernel.org> wrote:
>
> On 6/8/22 8:58 AM, Jakub Kicinski wrote:
> > IMO to encourage use of the track-capable API we could keep their names
> > short and call the legacy functions __netdev_hold() as I mentioned or
> > maybe netdev_hold_notrack().
>
> I like that option. Similar to the old nla_parse functions that were
> renamed with _deprecated - makes it easier to catch new uses.

I think we need to clearly document the needed conversions for future
bugfix backports.

Alternative would be to _backport_ the renaming for all stable versions ;)
