Return-Path: <netdev+bounces-3402-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86D39706EAA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF24528101E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6BA42106B;
	Wed, 17 May 2023 16:51:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34CE442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:51:18 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA486D2D9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:51:14 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-94a342f7c4cso186532366b.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684342273; x=1686934273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wbiCFj4HfZHR9GSOopG/VPXVdgYjV95t9H7iDfNawyE=;
        b=GHOfmj4fEe3Zp01EM5DNi1Fz9/k3FFXlLcLRqb498PsiPE5tqk+mdtFOneEVQm1VeC
         +gLOFtBCsbmlxRb9Q/lSSHkIiQVN1phuEzMQVqzqU++3W6EZZURnGwaP+LqMSDvuUtyI
         Ef3QrTDeyLOGCUfWf7Rg+d3itv1DeRaC5ag+gYiMm6+l3a3mMIRKLnAuVMV6KSNCGbLS
         PsDufHG7VWmbWdgx+dqHDcl7GsPtu3HWES1lhHJyiZFD2/W/EEOhSoDuxUTxuMJbdz+F
         gfakCVkuYG4BOmjI5pTfCNEwQZ2VA7eZkALQz6uCkHD9NeLMUK9zx61kuxYulP2WyUNb
         NvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684342273; x=1686934273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wbiCFj4HfZHR9GSOopG/VPXVdgYjV95t9H7iDfNawyE=;
        b=MNknRHWTxT95vzT7D5/w5cT1sh1RJ/AwwRg2oG/5u5wpv7+q6VZ8ZQ8bnCRRGtWGIO
         JcYvi03bMJD5lAgWZ78+LK3vh4H/fdGsd4eSjdkXPxPehQEFcgtA2zrzlFVUrI2iyOCU
         BloHNnMZXiup6HGFHDtypxTPmxw8tEkKBeNvyNl3HL2XSKbHId4HzphvWyqsFAF3b6a1
         B9kan9oA9KdYEiCg06DsCeq0nE6rcyFZ3YYCZ9hv2YcqLlKikFuJJluvSdVPawD43EHk
         7Hjf6TbuDB+3rImnYZ3znO6hNmzZ9qL/z67NpeVQfohvtw6c0ccfn+ZuhEBQb8Ld25Gg
         PlrQ==
X-Gm-Message-State: AC+VfDyiq6g4veQ75p/ZnHNip6V9PJ4NB7wZHkJTCuB/Jouse6hMVnzh
	x2x5LjxCKKRDFojAwhVG55o=
X-Google-Smtp-Source: ACHHUZ6oh8oKYrj3uQsco74M3CI6OJAU5wdWPCVuafnXrXWL3DrpiH6zar0z2DhrVLZbtGW7jX5duA==
X-Received: by 2002:a17:906:730c:b0:969:19ca:b856 with SMTP id di12-20020a170906730c00b0096919cab856mr35311753ejc.54.1684342272767;
        Wed, 17 May 2023 09:51:12 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id q18-20020a1709064cd200b0096f00d79d6asm1026256ejt.54.2023.05.17.09.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 09:51:12 -0700 (PDT)
Date: Wed, 17 May 2023 19:51:10 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Fabio Estevam <festevam@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc: tobias@waldekranz.com, Florian Fainelli <f.fainelli@gmail.com>,
	Steffen =?utf-8?B?QsOkdHo=?= <steffen@innosonix.de>,
	netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
Message-ID: <20230517165110.tp7pgraojuqazn2r@skbuf>
References: <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
 <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
 <20230510182826.pxwiauia334vwvlh@skbuf>
 <CAOMZO5Ad4_J4Jfyk8jaht07HMs7XU6puXtAw+wuQ70Szy3qa2A@mail.gmail.com>
 <20230511114629.uphhfwlbufte6oup@skbuf>
 <CAOMZO5BcwgujANLguNXCCZvJh8jwqUAcuu63D8dhwGhZ6oHffA@mail.gmail.com>
 <b2a5d9d6-5ae5-405f-b050-caa95807dd7c@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2a5d9d6-5ae5-405f-b050-caa95807dd7c@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:29:13PM +0200, Andrew Lunn wrote:
> > When I get into this "blocked" situation if I restart the bridge manually:
> > ip link set br0 down
> > ip link set br0 up
> > 
> > Then tcpdump starts showing the PTP traffic again, but only for a
> > short duration of time, and stops again.
> > 
> > Now that I have a more reliable way to reproduce the issue, I can run
> > more tests/debugging.
> > Please let me know if you have any suggestions.
> 
> This behaviour sounds like IGMP snooping, or something like that. The
> bridge is adding in an entry to say don't send the traffic to the CPU,
> nobody is interested in it.

This is more to Fabio: right now I don't really understand what's the
problem. In the initial message you reported that the switch doesn't
forward IPv4 PTP between bridged ports, but I guess that's not true?
Or if it is, the lack of IPv4 PTP in the tcpdump output on br0 is
completely unrelated. It would help if you could restate the real issue.

> I would add some debug prints into mv88e6xxx_port_fdb_add(),
> mv88e6xxx_port_fdb_del() mv88e6xxx_port_mdb_add() and
> mv88e6xxx_port_mdb_del() and see what entries are getting. You can
> then backtrack and see why the bridge is adding them.

FWIW, there's also a more "modern" way of debugging in net-next, which
is either to put "trace_event=dsa" in the kernel cmdline and to
cat /sys/kernel/debug/tracing/trace, or to run "trace-cmd record -e dsa <command ...>"
followed by "trace-cmd report".

> 
> Also, Tobias asked about the type of frame being passed from the
> switch to the host for PTP frames. Is it TO_CPU or FORWARD?  tcpdump
> -e on the FEC interface will show you additional information in the
> DSA header.

Seeing that these come and go to the host (eth0) based on the presence
of the 01:00:5e:00:01:81 entry in the ATU, I'd say these come with a
FORWARD tag, but indeed it would be good to confirm. Only
MV88E6XXX_VID_STANDALONE is installed with vlan.policy = true,
the others aren't, so I don't see a reason why IPv4 PTP would reach the
CPU via a trap here.

