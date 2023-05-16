Return-Path: <netdev+bounces-3077-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA2427055B2
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF9841C20B94
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00486209A7;
	Tue, 16 May 2023 18:10:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C96101CF
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 18:10:28 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C21BA7
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:10:12 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1ab0595fc69so22174825ad.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684260611; x=1686852611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3NEr7Io8PBBx2yH2u6u4gXKMqQe4Ae8HKCE8mLVMGEE=;
        b=C76hbUDHTNTkMLtYnnQwfRY8xqOqBHawZL7tmTxAnwMPxfjzrRV+zFXU7dsrn+grSL
         jKT4K5wvZnv2LrCSyWua3RADYe4d4QHHsb9AocK+LOdEJpy4b6Cd5lBxA9yvDh2S1UXn
         SZMBVXSKbE9A2kWGejFzye4/BK4pShl1254oFpq6zu3tB14Yaa/JofBdaMs4UKm5L8pE
         pSuPAKP+N2aVPoeqWZ6cmrWWajual+joUv7p4hiHt+I4gSHGBkrYcKQpB+K1Z9DfcR51
         TmLUKFmYa5M1Uqb2JS6U27ss2EWBuWGpdZkQK48RKr5qImYMPyajqwDbjV3Cpq5Algyy
         i4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684260611; x=1686852611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3NEr7Io8PBBx2yH2u6u4gXKMqQe4Ae8HKCE8mLVMGEE=;
        b=Fns5Z4P6CrNBuRo0/MuONN3Obv/iGuZkTu0pcVOzMJ7+9RH72Pq1rUnb7KOd8tf3cf
         Ctc/kUuvYIu56XwJnIbhKFeKa+jX8ugQla0aH74GohxRxXHa6FUutBv7UYBJfRbbAvot
         w+jcyuIHHIuMCwWjB2Fn69/e0O2fWsQmYbfvFgYxyhZ0duH4ztI84fO4FtYlUBqlUfci
         teGi5ekbLrtuvUl7Dt8RrGtuF3Tp0DXbuCqpesogEeLJopI7VS+YdTgKwnyIpHmzW66/
         JDYBrrMA/lHcedys6Q9Q/2qVRQt/uiskduq6esUQpqRAJE1dHbWRdbCqYlYsXiXEAS6p
         IzVA==
X-Gm-Message-State: AC+VfDxKe+VPtpf4oIfegEt6P9og9xQaNEjkHbA97VbF0O61FIsGno5o
	9/kKUiEWfe//e+W8+DAe3QlE1Ods3TPjVcSYNj4=
X-Google-Smtp-Source: ACHHUZ78gJTUh4b5MrxhFRj/Ulz6pLmhVKdANeSzmV9f81cHfnaQVrrf3fP7uYjyslYcWqX7UMMLUwyzba/8h7FDxNI=
X-Received: by 2002:a17:902:e80c:b0:1ae:1364:6086 with SMTP id
 u12-20020a170902e80c00b001ae13646086mr463466plg.2.1684260611253; Tue, 16 May
 2023 11:10:11 -0700 (PDT)
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
 <87pm77dg5i.fsf@waldekranz.com> <CAOMZO5CZoy12WrBEQFMupv5sPh2EjSPm+UmGz=-WkS7A97CtqQ@mail.gmail.com>
 <87wn1foze1.fsf@waldekranz.com>
In-Reply-To: <87wn1foze1.fsf@waldekranz.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 16 May 2023 15:10:00 -0300
Message-ID: <CAOMZO5AQtL1BNk2sm2v=c5fLbukkZSi6HSJXexp4QB4JjAyw-g@mail.gmail.com>
Subject: Re: mv88e6320: Failed to forward PTP multicast
To: Tobias Waldekranz <tobias@waldekranz.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>, 
	Florian Fainelli <f.fainelli@gmail.com>, =?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>, 
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Tobias,

On Thu, May 11, 2023 at 8:56=E2=80=AFAM Tobias Waldekranz <tobias@waldekran=
z.com> wrote:

> I imagine that if you were to open a socket and add a membership to the
> group, the packets would reach the CPU. What happens if you run:
>
> socat udp-recvfrom:1234,ip-add-membership=3D224.0.1.129:br0 gopen:/dev/nu=
ll &
>
> Can you see the PTP packets on the CPU now?

Yes, this seems to do the trick!

After adding a membership to the group, I don't see the PTP traffic
getting blocked anymore on a VLAN-aware configuration.

I will be running more tests, but this seems to be very promising.

Thanks a lot!

Fabio Estevam

