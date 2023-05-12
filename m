Return-Path: <netdev+bounces-2008-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8826FFF38
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 05:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D3CB2819E3
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154C480E;
	Fri, 12 May 2023 03:22:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E5E7E9
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 03:22:35 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A251FF6
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:22:34 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1ab0c697c2bso87387045ad.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683861754; x=1686453754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7aFZd4R4YnGRb/EV3ODGZoJJmGtvxkBqJdpndMYiF1c=;
        b=DiV/s4ZO9Y4X+jZW4uz6b/QshAsB4Oy72j45hpHbPBu57ybOfNLDCsZhFhp5AWNXlS
         ete/E3q5lwkfgEfV4LjALHwhPcQdql9JlvvYjexpGYWutMS+q0qxYnBk+AQGcBstBivQ
         P+pU2QQwjGWRmz6MJm7s4iFn0g8vQOqap2t00vekaqvc0JXRT07iDcAtOjm1xLrw4KMD
         2lx7to+BYzXT3R+fxS/gc91ZDPBobiMORWgo0+na22kuYisqVGHUb9liUvtTSLM/qzqf
         FrRxKtonOSCSyLFMBR4tvH4lQ/Vsaexb2ag8QUDUAEzJM6T/B7LPQmeWUM0sIDs4D5cd
         NuyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683861754; x=1686453754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7aFZd4R4YnGRb/EV3ODGZoJJmGtvxkBqJdpndMYiF1c=;
        b=a0lOG+A8WIf7vaVlq6QxL++6gayIgmh/Rdy/vmjxlfHB6TRL49RguzZnH+A9aE/muh
         i4RnOUu7rq25r2Tb86CRsHSit9oVydP7wml+jiqB8gxoNXC+nD+qxZkb2olSs5pEU9d6
         npM3fE3DMURO84V+jy+K/tkqpI/fYKuSKYmSw2kKPNjjHgxV7YLnXqtTRvSqMVFp5ADF
         9/xqnelu5ciFRQLk1G6Jxs6ZFpiADbHhTLAlIPvpe2jIAncqneUdy70b1eohvbUl49rc
         Di1zqhn+aWTXKHMtkAU6X81SV+FF9Zr9jfLvoP7COf1KzGE8C207s6fligISG1p5dWfJ
         rW4A==
X-Gm-Message-State: AC+VfDzexO6teuMfXRd+Z3g8OaLcjz1fsNfvF7pWky9TfhxMdSN7nHhL
	335K8lJw79sJ7u6EkjGkyxZWpSGZBfVpNYMRf12U0wqsy1jxiA==
X-Google-Smtp-Source: ACHHUZ6e4S7UTUrbxDU4hejrJBsAHBaGgUGSecKxm/2zFnQQbOBtOlT8fm3Qn1pAM+O74GcB2hKak62IpvyPvfhogWM=
X-Received: by 2002:a17:902:d50d:b0:1ac:5382:6e24 with SMTP id
 b13-20020a170902d50d00b001ac53826e24mr25299174plg.10.1683861753866; Thu, 11
 May 2023 20:22:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230502043150.17097-1-glipus@gmail.com> <20230502043150.17097-2-glipus@gmail.com>
 <20230511123245.rs5gskwukood3ger@skbuf>
In-Reply-To: <20230511123245.rs5gskwukood3ger@skbuf>
From: Max Georgiev <glipus@gmail.com>
Date: Thu, 11 May 2023 21:22:23 -0600
Message-ID: <CAP5jrPEL-RAPr4NADfGtqw1UJq+uKAVyRiz3wmAjMXhXAgit4w@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 1/5] net: Add NDOs for hardware timestamp get/set
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org, 
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev, 
	richardcochran@gmail.com, gerhard@engleder-embedded.com, liuhangbin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 6:32=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nx=
p.com> wrote:
>
> On Mon, May 01, 2023 at 10:31:46PM -0600, Maxim Georgiev wrote:
> >  struct net_device_ops {
> >       int                     (*ndo_init)(struct net_device *dev);
> > @@ -1649,6 +1659,12 @@ struct net_device_ops {
> >       ktime_t                 (*ndo_get_tstamp)(struct net_device *dev,
> >                                                 const struct skb_shared=
_hwtstamps *hwtstamps,
> >                                                 bool cycles);
> > +     int                     (*ndo_hwtstamp_get)(struct net_device *de=
v,
> > +                                                 struct kernel_hwtstam=
p_config *kernel_config,
> > +                                                 struct netlink_ext_ac=
k *extack);
>
> I'm not sure it is necessary to pass an extack to "get". That should
> only give a more detailed reason if the driver refuses something.

I have to admit I just followed Jakub's guidance adding "extack" to the
list of parametres. I'll let Jakub to comment on that.

>
> For that matter, now that ndo_hwtstamp_get() should no longer be
> concerned with the copy_to_user(), I'm not even sure that it should
> return int at all, and not void. The transition is going to be slightly
> problematic though, with the generic_hwtstamp_get_lower() necessarily
> still calling dev_eth_ioctl() -> copy_to_user(), so we probably can't
> make it void just now.

Would it make sense to keep the return int value here "for future extension=
s"?

