Return-Path: <netdev+bounces-1753-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C1B6FF0BE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82B562816EB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B4619BD2;
	Thu, 11 May 2023 11:56:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC7E65B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:56:14 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C66C8A47
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:56:10 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2ad819ab8a9so61262171fa.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20221208.gappssmtp.com; s=20221208; t=1683806168; x=1686398168;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qlgsbM95wxzBDVtCpqeljs1MnoAn3ZYpdWMjdcqESPM=;
        b=mCCS+0MHQWXYZOzjSHa1TCrHAAicEItxcmsCZ2PIkw1hEWL0xujQcylo0nSvE1/oz8
         8jqnL78HVBCvaMUm6NExmFxYM+RjKnTvF7EOp3vpC/txBEhCvzNWxmk43oteum27O08U
         p2FK1rm9TaV1AHC+JZdNjMWhwbTMXJzT9XREYZdm0PmZhCbergz/eJu5s2CVVQrQg9FS
         RMlcQ4RISnjBYQsnnyWxbdjSksuJ8AUzZsbb2Lc6APrYoD8oqtLHqDMG2DS2uwN/xDQz
         O2VcN7IMv6eltVX0UYJipP+mmh0ckvy/B/aAZWYxe7UfJ6WMVzlMrDbOzbWyQepAV1LU
         MuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683806168; x=1686398168;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qlgsbM95wxzBDVtCpqeljs1MnoAn3ZYpdWMjdcqESPM=;
        b=NLLD5YmeWoN6mlf9yrisNxtJD05LWHGnksTfRl152mgckStgUXkGcDdcylF6nFxO7v
         q84BLc8bw9aKZzc6eX9cQSZYmSceBa4e/KkMOEKZR8FjHQvIXklPUYsLl9o4pbhc0Trt
         zqAz60QP6gIRtECXJdnEarXmivK0UL/LyL0A0cxIqPQMfaKkQMgJRpHHaWKgaGKgR+rK
         xPbFVynh6Dbq61EN+D60xXhTJJQLl4tLO8fD9YaolwCCIdaTqzq13HwBmGd0Y3ghDaUv
         M1DioywkIj79nmHHMTszl/xC4gRc1NNsu3GDj/fUhPoZLwQpGkaTCAF3d3SA12FfL2Zc
         RbTA==
X-Gm-Message-State: AC+VfDxg//xrQevvEx+5IHsy167WD6C8UeV++Hqi38zvZ6ADZOEHW2gx
	kohSteycpfQr/DdHQBJ8oxaGHgAEUu2qJIIyNrY=
X-Google-Smtp-Source: ACHHUZ6kbxI7zAnUqCrcAenZC3q/gFC66uIu+DQS1J739fg0FpJm4/Ev9R5V7J0S9hEwlFvZnEkd7g==
X-Received: by 2002:a2e:350f:0:b0:2a8:ac69:bfe with SMTP id z15-20020a2e350f000000b002a8ac690bfemr2508704ljz.42.1683806167760;
        Thu, 11 May 2023 04:56:07 -0700 (PDT)
Received: from wkz-x13 (h-176-10-137-178.NA.cust.bahnhof.se. [176.10.137.178])
        by smtp.gmail.com with ESMTPSA id m24-20020a2e8718000000b002a8aa82654asm2296752lji.60.2023.05.11.04.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 04:56:06 -0700 (PDT)
From: Tobias Waldekranz <tobias@waldekranz.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
 Florian Fainelli <f.fainelli@gmail.com>, Steffen =?utf-8?Q?B=C3=A4tz?=
 <steffen@innosonix.de>, netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
In-Reply-To: <CAOMZO5CZoy12WrBEQFMupv5sPh2EjSPm+UmGz=-WkS7A97CtqQ@mail.gmail.com>
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
 <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
 <87pm77dg5i.fsf@waldekranz.com>
 <CAOMZO5CZoy12WrBEQFMupv5sPh2EjSPm+UmGz=-WkS7A97CtqQ@mail.gmail.com>
Date: Thu, 11 May 2023 13:56:06 +0200
Message-ID: <87wn1foze1.fsf@waldekranz.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On tor, maj 11, 2023 at 08:16, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Tobias,
>
> On Wed, May 10, 2023 at 6:34=E2=80=AFPM Tobias Waldekranz <tobias@waldekr=
anz.com> wrote:
>
>> If possible, could you install mdio-tools and paste the output of `mvls`
>> on your board from the two configurations above?
>>
>> Unfortunately, you will have to patch it to support your device. Based
>> on a quick view of the datasheet, this should probably work:
>
> I have installed mdio-tools with the suggested patch to support 88E6320.

Good, that seems to at least partially work. From the VTU dump (first
table), we can see that all VLANs appear to be using FID 0, which they
shouldn't do. Do you have any patches on mv88e6xxx? It might also be a
bug in mvls, in that Pearl is not completely compatible with Opal w.r.t
to the VTU.

> Please find attached two tests with their mvls results.
>
> Test 1: netconfig_PTP30s_mvls_test.sh

In this case, we can see that the PTP group (224.0.1.129, aka
01:00:5e:00:01:81) is not in the ATU. Therefore, the message will be
flooded to all ports that allow flooding of unknown multicast, i.e. have
their "m" bit set in the "FL" column of the port table. Therefore, you
should see the packet both on the CPU and on eth2.

This assumes that there is no active config to trap PTP packets. I am
not familiar with how that is setup. To verify this, you can run a
tcpdump on the interface connected to the cpu port of the switch, with
the "-e" flag set, and check whether the PTP packets arrive with a
FORWARD or a TO_CPU tag.

> Test 2: netconfig_NOPTP_mvls_test.sh

In this case, this line in the ATU...

01:00:5e:00:01:81     0  static     -  -  .  .  .  3  4  .  .

Shows that the group is treated as registered multicast, and is
therefore only allowed to egress through port 3 (eth1) and 4 (eth2). You
should therefore see it on eth2, but it would not show up at the CPU.

I imagine that if you were to open a socket and add a membership to the
group, the packets would reach the CPU. What happens if you run:

socat udp-recvfrom:1234,ip-add-membership=3D224.0.1.129:br0 gopen:/dev/null=
 &

Can you see the PTP packets on the CPU now?

> The only difference between these two tests is that the second one adds:
> ip link set dev br0 type bridge vlan_filtering 1
>
> In the first case, PTP traffic is seen for about 30 seconds and then it s=
tops.
> In the second case, no PTP traffic is seen at all.

I would guess that this is when br0 gives up on finding a multicast
router on the network, and assumes the role of querier. How does the
output of mvls change before and after this point in time?

