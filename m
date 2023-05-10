Return-Path: <netdev+bounces-1546-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E8896FE408
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B12471C20DF4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8353174E7;
	Wed, 10 May 2023 18:28:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC44F3D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 18:28:31 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226242110
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:28:30 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-965ab8ed1fcso1376572766b.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683743308; x=1686335308;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UN4pOfYjSM4BvI5U0s6A7MYscK87B/Ax0Gy9aYIR5LU=;
        b=gsTmHmhdT0Zuulpg+GCybHJZGzuYHhoXUAadE6qTp3LKIYQY2KDR9lQTLNhK/YXyOr
         I3+1Vz6a84f9gx/XM6ks7Rv2sdcy8cmzYekUOkQt2s11pJftllct6B87itNRTgBiS+Hx
         vDDPS7UiH7i5vtng49Odd36ngHOEfrpPZJgx4ArAjTgKADiZSZT4/54qeWjkKVjy77Ya
         M2U4VnsiV7RFQ8wglMBrj9zm14fQ4dXCNbD26v1hHC3BQAaYf/SD3R0U+Knv7O5475FL
         hTx2XP3tu/ZULJjmDwLSNzGqlvfeUEh13ny4eo+wO7EyHVSdXphV0wkmkTJhh/vGJbde
         ITsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683743308; x=1686335308;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UN4pOfYjSM4BvI5U0s6A7MYscK87B/Ax0Gy9aYIR5LU=;
        b=dTxTWKgdLiLVHLfVz14NVF3IFBi8DfJk9pQefmC2deszD1hXrKDqrFIfxB6vT4eyZP
         iGz5OQ9mu37SEKTki5BTsBLN5l0f2MzViGqY+4BAsfgWyskaUfO1azX0dQgh7kwXJMcu
         ZwtQ5ZPmvDEj6z1sODHvC2U6u9lF7LOg0YXJUSXPSZcOVyiaS20AqzCdtZ7R6ODdZyQN
         0v+WOBZe0THh4LXIzZN3DGVaq+1Aw2DMk+CUARe6jzcsUvXcaB2vKUXR6gwoQntBAJ2g
         SeyBBZ1xBSst+ORJQ4N0xCmVIpI3R4Xt+cj/qwbLG78UlEeim7od926lqPcOKR/lV35p
         hXwQ==
X-Gm-Message-State: AC+VfDwE7NK+Zhkz3Gg0U75vyV69dC4oh5dedmgKFX5C4E4P5HNlbfkA
	LaUOteLaMZQvv6FioNdyVWk=
X-Google-Smtp-Source: ACHHUZ4koSilIKN3hOxIXfAMgI5F9B0VTQp77JPcsSqKf7+vC8lb5IAhWV6kN8fHrnepbBVuo5jaKQ==
X-Received: by 2002:a17:907:980a:b0:968:2bb1:f39d with SMTP id ji10-20020a170907980a00b009682bb1f39dmr10108814ejc.36.1683743308315;
        Wed, 10 May 2023 11:28:28 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id hg8-20020a1709072cc800b00932fa67b48fsm2950527ejc.183.2023.05.10.11.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 11:28:28 -0700 (PDT)
Date: Wed, 10 May 2023 21:28:26 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, tobias@waldekranz.com,
	Florian Fainelli <f.fainelli@gmail.com>,
	Steffen =?utf-8?B?QsOkdHo=?= <steffen@innosonix.de>,
	netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
Message-ID: <20230510182826.pxwiauia334vwvlh@skbuf>
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
 <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Fabio,

On Wed, May 10, 2023 at 11:05:46AM -0300, Fabio Estevam wrote:
> On Fri, May 5, 2023 at 10:02 AM Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > I'm not too familiar with all this VLAN stuff. So i could be telling
> > your wrong information.... 'self' is also importing in way's i don't
> > really understand. Vladimir and Tobias are the experts here.
> 
> Vladimir and Tobias,
> 
> Would you have any suggestions as to how to allow PTP multicast to be
> forwarded when
> vlan_filtering is active?
> 
> The whole thread is at:
> https://lore.kernel.org/netdev/5cd6a70c-ea13-4547-958f-5806f86bfa10@lunn.ch/T/#m6453e569a98478bf5bddf09895393c3a52b91727
> 
> Thanks,
> 
> Fabio Estevam

I checked out the v6.1.26 tag from linux-stable and I was able to
synchronize 2 stations attached to my Turris MOX (Marvell 6190) with
this commands: sudo ptp4l -i eth0 -4 -m
(also I was able to synchronize a third station behind a mvneta bridge
port foreign to the MV88E6190, using software forwarding)

My bridge configuration is VLAN-aware. FWIW, I'm using vlan_default_pvid
1000, but it should not make a difference.

In a bridging configuration where there are only 2 ports in the bridge
PVID (1 source and 1 destination), could you please run the following
command from a station attached to one of the Marvell switch ports:

board # ethtool -S lanX | grep -v ': 0'
station # mausezahn eth0 -B 224.0.1.129 -c 1000 -t udp "dp=319"
board # ethtool -S lanX | grep -v ': 0'

and tell me which counters increment?

I am also curious whether there is any difference to your setup between:
ip link add br0 type bridge
ip link set br0 type bridge vlan_filtering 1 # dynamic toggling of VLAN awareness
and:
ip link add br0 type bridge vlan_filtering 1 # static creation of VLAN-aware bridge

I've tested both forms on my setup, and both work. Who knows, maybe
something happens differently on your particular kernel, or with your
particular switch model.

Is it vanilla v6.1.26 or something else?

