Return-Path: <netdev+bounces-340-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E6E6F733F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:41:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14E0A1C212EB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82BEEEDD;
	Thu,  4 May 2023 19:41:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D785EEDC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:41:06 +0000 (UTC)
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3522961AF
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 12:41:05 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ab0b1ee76eso1323375ad.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 12:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683229264; x=1685821264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q9YSMqbos6Lm0Mu7ecCbIm7Uvwg+s3D7TbmUe7hhEwU=;
        b=oEiKXSvOvfF3i/XXfnVXZ8CoZbyZegrVrGHw814nVnxxRcLtxIx8rKAjP7U5Vt2zwE
         fOFTm+9ZVBITcVi2aKjEBYQ3bSrAk9c9RMpzPdm6k4kpXupW+g68xU8rKohsU2mKfc/h
         uzMBGuMQt2EqPfQLaX3vUGllkY4cAZEyfbKvbnjMxWaf9dwIBrAzhWsn5RSMBNrNWwfP
         /D5NR+uIYLlWPAclTJaQuaEre+Q63Hm2zEaiJa2OLELLEYXwOPr8pzPTJ1OH0lVKXyI7
         TWFxPeVw2aCGlDuoh90UcheaJ+8PzXi18rcCYOALxBQvOBOCjBtRBdxjtrazRxNl0SQt
         KqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683229264; x=1685821264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q9YSMqbos6Lm0Mu7ecCbIm7Uvwg+s3D7TbmUe7hhEwU=;
        b=Eg+IWqLjEBJLM1s1OpkrHD7/ya4SDS/MP6aXT2u7SxP8SLML/MXk4R9gC0anlviIlD
         LHSRpLmj6JPmj9ElPsER/KBeWj4u5Sf0vlSyZJFlCZNnf9cJz24BvnJDDXgLTAlJLFDJ
         34qNETIGiOxMZbHE7egsOYFuewBqWbMVv7aEmhvk5GcSwIkai8tN8mBWoR4YDu/KOizK
         m4CocuLu1qu21kobsbBMNRr3tsdZvyjHreAPWTqRJFh42rei4TZE8pN9AujzDhhXGRGY
         tnW8t8fxcxrE0D/XKbVI//k1FavRqZRSyeyGVaEzlcyRLDI/BLU8PFF1oFrFMN9wvFmX
         CWTw==
X-Gm-Message-State: AC+VfDxyUZQoGrn02hyuI/vF9h302ZdvBLwwRA76bhDZi2nR9PPv+bji
	99LKicQx3pe984LaAMvFvA+GfWYJYyMAyPAL38s=
X-Google-Smtp-Source: ACHHUZ4rbCqg0lIH4ewfYsRcjMlB2JPkD5ML4hMrlU5+1mOJM2ulG2Ypf/x2lEm8RQD/JCgjxNSiBcsAnA/xqTm3Fqc=
X-Received: by 2002:a17:903:2307:b0:1aa:d544:c5bb with SMTP id
 d7-20020a170903230700b001aad544c5bbmr12702130plh.4.1683229264605; Thu, 04 May
 2023 12:41:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
In-Reply-To: <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 4 May 2023 16:40:53 -0300
Message-ID: <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
Subject: Re: mv88e6320: Failed to forward PTP multicast
To: Andrew Lunn <andrew@lunn.ch>
Cc: Vladimir Oltean <olteanv@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>, 
	=?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>, 
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andrew,

On Thu, May 4, 2023 at 4:21=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:

> Do you see the PTP traffic on eth1?

Yes, PTP traffic is seen on eth1.

> What MAC address is the PTP traffic using? Is it a link local MAC
> address? There are some range of MAC addresses which you are not
> supposed to forward across a bridge. e.g. you don't forward BPDUs.
> Take a look at br_handle_frame(). Maybe you can play with
> group_fwd_mask.

In our case, it is a multicast MAC.

The same traffic flows correctly when the bridge is not VLAN aware.

After VLAN is activated:

# Activate VLAN filtering
ip link set dev br0 type bridge vlan_filtering 1

Then the flow stops.

Thanks

