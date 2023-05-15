Return-Path: <netdev+bounces-2686-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BB997031AD
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8FC7281376
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BED1DF57;
	Mon, 15 May 2023 15:36:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A812C8E5
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 15:36:58 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2D4128
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:36:54 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-64ab2a37812so20909410b3a.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684165014; x=1686757014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZcPbRxMsw4pplNTCHpJ8/H+7WYPHqdQAzfX8DwwmgE=;
        b=okUK+v7GoWYTlMEd4IKONwymXv+s596j6S7U83/ZUYsPaeKrjb8zdOTXo+32C0O5ZT
         BlG0kCTHlsfBbv2MrtRAVoktpCWpUvt6j3cF3Wx/p1A8q3w7MCrQF6Qr4Uf7lqVxOSM4
         jI/wvqytk13UIu0MINMzsBnqd+vT6eCjzlJsJ+OrNv4WMfMFmjWNKMdlQwkHY9+rXwg8
         0QxbGa5BABpnTJRiZLkrrSGzGkRBFriUvynSIuRIsiBOemQ4xX48DOD+IaugAPpTgdn1
         ewxZE1LJFO7pRbGmivF8opeweizrQsKziECP65iPM93+2aUN+GpD1qRvaaHKCkyBxvky
         5dIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684165014; x=1686757014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QZcPbRxMsw4pplNTCHpJ8/H+7WYPHqdQAzfX8DwwmgE=;
        b=ZfEvElQEO3lr12Iml51z+7xoK9hA9rE3qDGCn5bg69X4PYpnC26CwidZYi7w/iLYuX
         kv9H14XJEiEXCRrK81FgpDJgN0P1AepsPJjQmfwL2mH4oLtHcVPJqBL7qXvedYAmlc41
         93QIDcyS6NPGlDA5RpUoY/cxWCLbV7dilnaKEm6RPAbwPTH5MriQ8CYfyhtcWBLRXXfz
         R1dnsKN+wwWN9ekrZ8YXMAhuIdNGCzzThVZnXcpNuFF9fKPViOCtfmhug0dr8mpymV6K
         3+Zg9WBbT4N7eKSLS8CVUWFYqqZfZhzOUtw2xbQGfdzVwJbvsvwhKtAMMZmX3Qxbv3b1
         7O1w==
X-Gm-Message-State: AC+VfDzoUmmCfyYnB3I6AlVUrTbmvDcvm90oVaez14K2gnOxxhk6bm7Y
	Se5wdLEvyjBjYCs7fz9Ji3ehEJnYsA6sUWhnjVk=
X-Google-Smtp-Source: ACHHUZ7gRj0ka3I/7XRtwTCPmXcMKQpucURL7tdrHOGql+0dLvThoe7EgyWVyuEMTM+bJRRU5mNPwXfM27YX6igkYls=
X-Received: by 2002:a17:90b:1e51:b0:24e:d06:6912 with SMTP id
 pi17-20020a17090b1e5100b0024e0d066912mr42251346pjb.18.1684165014082; Mon, 15
 May 2023 08:36:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230502043150.17097-1-glipus@gmail.com> <20230502043150.17097-2-glipus@gmail.com>
 <20230511123245.rs5gskwukood3ger@skbuf> <CAP5jrPEL-RAPr4NADfGtqw1UJq+uKAVyRiz3wmAjMXhXAgit4w@mail.gmail.com>
 <20230512104105.6bc78950@kernel.org>
In-Reply-To: <20230512104105.6bc78950@kernel.org>
From: Max Georgiev <glipus@gmail.com>
Date: Mon, 15 May 2023 09:36:43 -0600
Message-ID: <CAP5jrPEFjnHEJi3RHRmQmz3-5RmTXcXLdOp6r4me3z2Z8Fw_BA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 1/5] net: Add NDOs for hardware timestamp get/set
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>, kory.maincent@bootlin.com, 
	netdev@vger.kernel.org, maxime.chevallier@bootlin.com, 
	vadim.fedorenko@linux.dev, richardcochran@gmail.com, 
	gerhard@engleder-embedded.com, liuhangbin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 11:41=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Thu, 11 May 2023 21:22:23 -0600 Max Georgiev wrote:
> > > > +     int                     (*ndo_hwtstamp_get)(struct net_device=
 *dev,
> > > > +                                                 struct kernel_hwt=
stamp_config *kernel_config,
> > > > +                                                 struct netlink_ex=
t_ack *extack);
> > >
> > > I'm not sure it is necessary to pass an extack to "get". That should
> > > only give a more detailed reason if the driver refuses something.
> >
> > I have to admit I just followed Jakub's guidance adding "extack" to the
> > list of parametres. I'll let Jakub to comment on that.
>
> We can drop it from get, I can't think of any strong use case.

Got it. Will remove the  "extack" parameter from ndo_hwtstamp_get() in the
next revision.

