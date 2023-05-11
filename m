Return-Path: <netdev+bounces-1738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 912656FF06D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:16:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B718C2816BA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D2918C12;
	Thu, 11 May 2023 11:16:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A403AA57
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:16:25 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DF63C39
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:16:24 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6439bf89cb7so1638707b3a.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683803784; x=1686395784;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v3vyC10siQ7Y2seGxbyl1YrdTBwmIN8AlkCcH6u/hFQ=;
        b=Ss/dEI4qUjdLqaeFwmXlQxq7o5sHC2DKeYL0hqZhjc+rEKsJeq3Vmn+tB1olwIB5KR
         l6Zj27e84Qf7XcrX0dx53p2L9/Bk56X19K99YaX8gGYOp+mvezBDE7y42sM/jhLmDDlz
         gk/op/hjSjE9Hq92WZK8V7f8e22E46aLpTuW/wPvWoFnPb4QEau7PA5bnepC43qX63Dh
         8h+cRfas9f8PWH+uSziaxbYEn9vD1D/WwrzJctIVFmO6ff2zy4K11Mg2+WdY12EHpuLa
         lKRzGD3D56RDfrhDsNMmC7klqJiDCJGGt5ph3XUt0Hzc+MCmauGHOFfpnjSVO3tsc41V
         UUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683803784; x=1686395784;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v3vyC10siQ7Y2seGxbyl1YrdTBwmIN8AlkCcH6u/hFQ=;
        b=MNgVfkbcgAFFymZGBOgq4sblZZ8I1cZAXX3HnZq74XKGiDu4ormYtVz8I+uc4BQsP9
         NXfc5m++5eXyCgb6IYwFyCMVs5XW4G5zCeUfcxwiRFLqdSM3PdaMpUFEK7R/FVSixaOz
         SEYI5Dl9J9L4tPHlmAga756r4zhaQ/dg/LXMHKtz4w9fZ7+0FU/+q0h4g9XBFHe1GOZh
         HYPM4ydXlJHbM1AKVRw6acvZ0Gxhary2IseQ/sgrg2m/0JIsF2gq1wtPhvxMVqXckqBY
         Bj3opbr3hDelojuW7d7Yo0zYlb6r0IUY2XH15ISA0qee31McPRTyTg3urLcb31vVaiuT
         njgQ==
X-Gm-Message-State: AC+VfDyQD//e1B5zo1McGdS1pdzKlOiFW+2ZDTvCLSTP2s51T7CuaKIz
	5fx1lWXNX/0yMLPGW1P+7TSg44zcMtIGmhxCOLhhy0nEEjw=
X-Google-Smtp-Source: ACHHUZ6PupNAv+X2eIzXxZ0Z4+08awPpfpkrf8YD4XexmzkIv3g5x3l8efv4E+4bIxOW2b20dq3Zoe3z2ZA187nNkjk=
X-Received: by 2002:a17:90b:4c86:b0:252:75c8:d0a4 with SMTP id
 my6-20020a17090b4c8600b0025275c8d0a4mr3692036pjb.2.1683803783699; Thu, 11 May
 2023 04:16:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch> <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch> <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
 <87pm77dg5i.fsf@waldekranz.com>
In-Reply-To: <87pm77dg5i.fsf@waldekranz.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 11 May 2023 08:16:11 -0300
Message-ID: <CAOMZO5CZoy12WrBEQFMupv5sPh2EjSPm+UmGz=-WkS7A97CtqQ@mail.gmail.com>
Subject: Re: mv88e6320: Failed to forward PTP multicast
To: Tobias Waldekranz <tobias@waldekranz.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>, 
	Florian Fainelli <f.fainelli@gmail.com>, =?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>, 
	netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000006679c905fb691e17"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--0000000000006679c905fb691e17
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tobias,

On Wed, May 10, 2023 at 6:34=E2=80=AFPM Tobias Waldekranz <tobias@waldekran=
z.com> wrote:

> If possible, could you install mdio-tools and paste the output of `mvls`
> on your board from the two configurations above?
>
> Unfortunately, you will have to patch it to support your device. Based
> on a quick view of the datasheet, this should probably work:

I have installed mdio-tools with the suggested patch to support 88E6320.

Please find attached two tests with their mvls results.

Test 1: netconfig_PTP30s_mvls_test.sh
Test 2: netconfig_NOPTP_mvls_test.sh

The only difference between these two tests is that the second one adds:
ip link set dev br0 type bridge vlan_filtering 1

In the first case, PTP traffic is seen for about 30 seconds and then it sto=
ps.
In the second case, no PTP traffic is seen at all.

Thanks,

Fabio Estevam

--0000000000006679c905fb691e17
Content-Type: application/x-xz; name="mvls.tar.xz"
Content-Disposition: attachment; filename="mvls.tar.xz"
Content-Transfer-Encoding: base64
Content-ID: <f_lhj18rgm0>
X-Attachment-Id: f_lhj18rgm0

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
ozMAAb4LgHAAAKJJ7S2xxGf7AgAAAAAEWVo=
--0000000000006679c905fb691e17--

