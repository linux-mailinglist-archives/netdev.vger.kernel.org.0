Return-Path: <netdev+bounces-3014-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32384705043
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2C86281662
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2408634CD9;
	Tue, 16 May 2023 14:12:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BAC28C15
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:12:28 +0000 (UTC)
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC8510F5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:12:27 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-52888681eebso1992484a12.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684246346; x=1686838346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q/GQgcen7nhF/yFttg3gPd0Mr3zEpH3X5F7IveJ9I4U=;
        b=Si629H8hLgnaLyJsxI4zXxk6cTV1l+CHr6UqbjS8kVtqtsBKNilobuPukWCZMrNgJL
         f1CMHJp9A9nAt1TqxkBLmXcXeIwOI0UZXhTtBlJjJ8E4sKiyPaE0CrW1ZLindcxtrISD
         mmHLwpRKE3Tkpr3UwAEr9sjPn4KRhEsCgFzj8N3qskZD7G+C8q7zuHrF16DIPsVVW/uL
         6I7Yf3qK6p2wb3mhtTkVBSQp0K8RjnXkWh5zW/3an2V648mS5nwPx8E+gw/ZxSbNFwCI
         Js421nnhtLyG0OL6T/THI2XEEccmE5Qr9UcOJ/1B88FVPvfWDUR7B2lU53fCmDFnjAct
         d1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684246346; x=1686838346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q/GQgcen7nhF/yFttg3gPd0Mr3zEpH3X5F7IveJ9I4U=;
        b=eNkBE9hXC8O2kimTahW+IiA3KstKAlM+DodjWfYR98q/nKp3dd2gAfEqXN76TSda77
         +P1y94aqwjZaX+VDxmzDTE4SC2ftroDNa89DZyZHZ3wh8stXqBrjSJjvu55bB8dTeKl/
         OaA1CkNhv1SmgvCq9W+F5fM3WsVzk4K9slE0fq+NntdNlozy81Yt2+yB4PsQwoe59XZ4
         4JKM2vqbOLQEvp07M3d1ufyGihMAr2ViiP35fJiYRfasxrSxBzkjI16Gr9U/HUE9lkFl
         vE/R4FQ4v/FDZsk5UCIa2V7/yNA4WlKXjPxUneRQxQ7L/B8E1dKY4ZkVyRJUOJUB+2h2
         2GSg==
X-Gm-Message-State: AC+VfDxxvoGEck6TJSYg6Bb3ZPFMFUPyKbSqu2hy7eSSKy5Fpz94m7cZ
	TUJ0v2iMQVvBJTAE4eag4JKz0LxjvyQUdXsHxuMsNQjhpd8=
X-Google-Smtp-Source: ACHHUZ6PKQLgsTiCzo0sJeNcOyFy5ZvorAN8lCmobkpKPc5QPrPiYTckO/rjivMW377Y6yGlaoq6L1KDUxflO8gNLT0=
X-Received: by 2002:a05:6a20:8f1e:b0:103:3802:cfbe with SMTP id
 b30-20020a056a208f1e00b001033802cfbemr4054662pzk.6.1684246346343; Tue, 16 May
 2023 07:12:26 -0700 (PDT)
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
 <20230510182826.pxwiauia334vwvlh@skbuf> <CAOMZO5Ad4_J4Jfyk8jaht07HMs7XU6puXtAw+wuQ70Szy3qa2A@mail.gmail.com>
 <20230511114629.uphhfwlbufte6oup@skbuf>
In-Reply-To: <20230511114629.uphhfwlbufte6oup@skbuf>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 16 May 2023 11:12:14 -0300
Message-ID: <CAOMZO5BcwgujANLguNXCCZvJh8jwqUAcuu63D8dhwGhZ6oHffA@mail.gmail.com>
Subject: Re: mv88e6320: Failed to forward PTP multicast
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, tobias@waldekranz.com, 
	Florian Fainelli <f.fainelli@gmail.com>, =?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>, 
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Vladimir,

On Thu, May 11, 2023 at 8:46=E2=80=AFAM Vladimir Oltean <olteanv@gmail.com>=
 wrote:

> I don't see the "eth0" name referenced in any of the attached files. By
> "connected to the i.MX8MN" you mean "separate from the board under test",
> right? To be more specific, it is always connected to the eth2 switch
> port, correct?

Our system looks like this:

https://ibb.co/F7d1tnK

I realized that I provided several scripts and that made things confusing.
Sorry about that.

I found a simpler and more reliable way to reproduce the problem.

Script 1: Non-VLAN-aware bridge script

ip link add br0 type bridge vlan_filtering 0
ip link set eth1 master br0
ip link set eth2 master br0
ip addr add 192.168.0.97/24 dev br0
ip link set br0 up
tcpdump -i br0 dst port 319 or dst port 320

Script 2: VLAN-aware bridge script

ip link add br0 type bridge vlan_filtering 1
ip link set eth1 master br0
ip link set eth2 master br0
ip addr add 192.168.0.97/24 dev br0
ip link set br0 up
tcpdump -i br0 dst port 319 or dst port 320

(only difference between them is 'vlan_filtering 0' versus 'vlan_filtering =
1').

On the Linux PC, I run:

"sudo ptp4l -i eth0 -m"

When I run script 1 on the imx8mn board, tcpdump constantly shows the
PTP traffic.

When I run script 2 on the imx8mn board, tcpdump shows the PTP traffic only
for a short duration of time (from 10 seconds to about 1 minute) and then
it no longer shows the PTP traffic.

When I get into this "blocked" situation if I restart the bridge manually:
ip link set br0 down
ip link set br0 up

Then tcpdump starts showing the PTP traffic again, but only for a
short duration of time, and stops again.

Now that I have a more reliable way to reproduce the issue, I can run
more tests/debugging.
Please let me know if you have any suggestions.

Thanks a lot,

Fabio Estevam

