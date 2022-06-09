Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8652544E1B
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 15:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbiFINxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 09:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbiFINxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 09:53:35 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4406F1F2325
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 06:53:33 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r82so41822298ybc.13
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 06:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lxk3erEnK6X8l1h+c5LR7dYudSNnktRPy2YkDiUavZk=;
        b=bf+4vrjXiHJ31KIu4Gn9fz0kzCJfCOU1lBmNIi3MPCYOGfE+K+yZz1oe4L1g+wVUzE
         LNi2rjTseY7kRuZiBASR8T18LSqHIttiHYhOXHbfJASuY4nO5P0MjXUPUy+4QXCqQ7fC
         zgGR+NTJmwqnmycnN0CYnqt72iPvh/9kRB7iy+1bF6srWKu1VG90EwBAsbXMKIVy9p8s
         0S72jwsSQeSoBdx+gWSUIeOzQfx5ouizQ1XoVOqAo3zD+FDIH5a9G048GwSJhTs2GoOC
         00B1oEzBvVvfgVWdJ9rXYDIVasCp7iBVzWF92aj83aQp+MbBwJyDHHrCC5LeDJn91mm1
         bL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lxk3erEnK6X8l1h+c5LR7dYudSNnktRPy2YkDiUavZk=;
        b=MX/r2QDZJIMQHh6i4NhXiwfjHLOTZow3WdiTYHuSUJX2z+0dQ10FS7/gXQFOTVKXrb
         htTV1o8VuWgYzbbmmkaiqDsVs+NalNHJ+wVXndk29Tgh7+SgtqBUJz3YNSqlWJtd1uDj
         AOMCWU7KKEeFq42LqvnPd7Teq5iQgEA5UEYS8Ny+DLkF+1vfHmllg7v6E8ixBSZznbAE
         8Pwwt288fk27NTjgOU+lmS4qWg23o3y5lFO4RYCWu6rAmhmROKZsqMd9oAb95+ekASPi
         EjwEDoPGJkzkIIMvqFWGVZ66shhLLpumLkuowBmflheiHSl5HUPcfcetD31B6RE6gPUX
         y98A==
X-Gm-Message-State: AOAM531otvYhiqRaBlrCPKNX/z8gTUiHV1OLvWMrwqswi7fIZoy1JLdJ
        U6wwACpUyXJ1A2hR5b0Yc1bsnTLovSlX7sD2RE4DkA==
X-Google-Smtp-Source: ABdhPJw3jCDO7EzaAolIFjfqgZekBWsECCoOQScBqYlIlPgNDL+TjdXws2goS7JCvG7bHlkOzJhOqX9Tqqd4sB82cao=
X-Received: by 2002:a25:aa32:0:b0:65c:af6a:3502 with SMTP id
 s47-20020a25aa32000000b0065caf6a3502mr40088926ybi.598.1654782812194; Thu, 09
 Jun 2022 06:53:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220608043955.919359-1-kuba@kernel.org> <YqBdY0NzK9XJG7HC@nanopsycho>
 <20220608075827.2af7a35f@kernel.org> <f263209c-509c-5f6b-865c-cd5d38d29549@kernel.org>
 <CANn89i+RCCXQDVVTB+hHasGmjdXwdm8CvkPQv3nYSLgr=MYmpA@mail.gmail.com> <b00ab3c4a12fb11ed95b2a4634e50e3cba10ec28.camel@redhat.com>
In-Reply-To: <b00ab3c4a12fb11ed95b2a4634e50e3cba10ec28.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Jun 2022 06:53:21 -0700
Message-ID: <CANn89iLzAY1FAJASwrDcV9xB8UvhPAWfuFsjfiRiu1F9Tu0ciA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: rename reference+tracking helpers
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 4:50 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2022-06-08 at 16:00 -0700, Eric Dumazet wrote:
> > On Wed, Jun 8, 2022 at 3:58 PM David Ahern <dsahern@kernel.org> wrote:
> > >
> > > On 6/8/22 8:58 AM, Jakub Kicinski wrote:
> > > > IMO to encourage use of the track-capable API we could keep their names
> > > > short and call the legacy functions __netdev_hold() as I mentioned or
> > > > maybe netdev_hold_notrack().
> > >
> > > I like that option. Similar to the old nla_parse functions that were
> > > renamed with _deprecated - makes it easier to catch new uses.
> >
> > I think we need to clearly document the needed conversions for future
> > bugfix backports.
> >
>
> To be on the same page: do you think we need something under
> Documentation with this patch? or with the later dev_hold rename? or
> did I misunderstood completely?

Adding instructions in the comments describing the functions would probably help
stable teams (or ourselves because they will ask us to take care of conflicts)

And backport the dev_put()/dev_hold() rename to kernels without
CONFIG_NET_DEV_REFCNT_TRACKER infra.

s/dev_put()/netdev_put_notrack()/
s/dev_hold()/netdev_hold_notrack()/
