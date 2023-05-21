Return-Path: <netdev+bounces-4096-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95AB670AD2F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 11:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03011280F83
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 09:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0406210EF;
	Sun, 21 May 2023 09:20:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED4010E8
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 09:20:14 +0000 (UTC)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B352493;
	Sun, 21 May 2023 02:20:13 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-528dd896165so3372953a12.2;
        Sun, 21 May 2023 02:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684660813; x=1687252813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8HwM6KmZId1WNbACaRjkfOnAGeuoeekyl1zBNcHd9TA=;
        b=XryRZG9kjgR04Bo7y5DJ1NWf9L1YacHwnzTTjdMy6+HRQxSLhryJA2mwGII3zz4uHf
         ZXFo68HzIhcQfxvylfF9alveHChOjBEwKQCFSm5fugwpEwaDvScEd6S6CPs2iwj6uZdG
         2FglrwCM1ZXbqReWy0LC9/5fiet6G2k2OEcpPL3emVJ+OQq5KgeD18i0yP3VNGbB1oW+
         8i7Ilei2iPMa4mAaSB4YRKswINobG23Be6ot5vYOkzlWRqbloU+H6O94Aqr7b11LkFoE
         /pzCE2TMoq+92poT6Yp6pJKyEs7rvrsrb7zBntWzm6Ls2FmkiZS67RqSeCJKC4vrP1ZU
         bNgw==
X-Gm-Message-State: AC+VfDw9cdKdoBQOuy+PYdJ/FObCY6UhgDGhvE8Xc/oW9qVVOajWK5hS
	Ffm1gGwIWtsCLVC8cVQLTALl+zGqxJbiohJt+mI=
X-Google-Smtp-Source: ACHHUZ5EcacBz0A46K/VKH3jwBK9qhZjbtZFgrRtmxBbmqtC0ruud8NkHVNYVHupcXDOIoSnjQ9K+XwaOO3YjxUV2t8=
X-Received: by 2002:a17:90a:e2d3:b0:246:5f9e:e4cf with SMTP id
 fr19-20020a17090ae2d300b002465f9ee4cfmr7011890pjb.43.1684660813127; Sun, 21
 May 2023 02:20:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230519195600.420644-1-frank.jungclaus@esd.eu>
In-Reply-To: <20230519195600.420644-1-frank.jungclaus@esd.eu>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Sun, 21 May 2023 18:20:02 +0900
Message-ID: <CAMZ6Rq+hYcDks2MWz5fuhHogKYhAhSHg0J7bpKQ8DZaxpXRriw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] can: esd_usb: More preparation before supporting
 esd CAN-USB/3
To: Frank Jungclaus <frank.jungclaus@esd.eu>
Cc: linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>, 
	Wolfgang Grandegger <wg@grandegger.com>, =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Frank,

On Sat. 20 mai 2023 =C3=A0 04:57, Frank Jungclaus <frank.jungclaus@esd.eu> =
wrote:
> Apply another small batch of patches as preparation for adding support
> of the newly available esd CAN-USB/3 to esd_usb.c.
> ---

I sent two nitpicks but aside from that the series looks good. Thank
you for taking time to clean-up the existing code before introducing
the new changes.

I do not think I will need to review the v3, so in advance:

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

