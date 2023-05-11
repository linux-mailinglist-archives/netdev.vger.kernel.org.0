Return-Path: <netdev+bounces-1746-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CEFF6FF0A4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 687BA281705
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8261D19BBD;
	Thu, 11 May 2023 11:46:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EEA65B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:46:35 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860A38A40
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:46:33 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50bcae898b2so15071076a12.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683805592; x=1686397592;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DOBgHqRdSxLAH6rssmzMx4sn09wPBvO07JVfzOYMBF0=;
        b=g2PD4AwiPZK7N9hNKN4KakBc8gM1R9vXjLvRS4jHmfCZkPkZjmazSpzLVFthkmTnJK
         zmw3hH0CbFazy7M7qGQJhQeWP1ItujAfzZUZjtgkU3+sDkEZdGZwCZHEz2eJ/t12dr7/
         lGqMY9109wplS7+12RpC63NpclzMd4kk8sDQA4OE9tzd8GTEw0Bn73w2kh6zgUiUL58D
         s9LguA80yhN67+rTE80JUSW2ydtrRPnJ4jos7rWD87YEPZoP1tg8qzTvk594kXwYdrOk
         n66h0sGNVFqeZERildVKdXdpJ9FwKtfuDpOKQOeyXHZfHSjFWOTT2RelDVvv/TJ3YRVz
         9RRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683805592; x=1686397592;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DOBgHqRdSxLAH6rssmzMx4sn09wPBvO07JVfzOYMBF0=;
        b=OLiSJ3AG4wuB1Uv2e9ahEXogg58dL5/2tyuOiKE4smUb3HIDLZm2BxNwGRrafytUlv
         o0ENeIyXBdHyymPgTu1ktEUKUGf9KygYj8duoWFc2dPPAX68aL52g/p75vrOqcYDFXql
         dMBcUlMDET1oCOOHSJz9Go4+9srcPXxdNlYDj1D5KRFiEx+i5sWUSZR0/3vV+E+geVaF
         2Qk08eyeISpZd6+aTjAGrEeu94ZHXAd3tdZW2qAXjjZQWaPsFeFiMlVB8IM+jexX0wlf
         RZHZMSMWyMgvVoys9q+fxq+MfKI41ZPvDRanNFId2USNx29ZHr1+Ug0MvZcBWoPdjD/O
         DdkQ==
X-Gm-Message-State: AC+VfDwxjQzmW4vNjGEZX1CNfSILwkKaUyeRtANmMXUfpWqbh+Agv9Bh
	JFGj22P27ixdGn/kAdH4q8M=
X-Google-Smtp-Source: ACHHUZ788v9VVwxiY0u29+mtUvh7zbAVTxMUu82sz0tGti6epUn/81ZwoOj1G/OQYfeU/cuJyGUAnw==
X-Received: by 2002:a17:907:6d8d:b0:96a:3e39:f567 with SMTP id sb13-20020a1709076d8d00b0096a3e39f567mr4708524ejc.47.1683805591615;
        Thu, 11 May 2023 04:46:31 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y12-20020aa7c24c000000b0050bf7ad9d71sm2844431edo.10.2023.05.11.04.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 04:46:31 -0700 (PDT)
Date: Thu, 11 May 2023 14:46:29 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, tobias@waldekranz.com,
	Florian Fainelli <f.fainelli@gmail.com>,
	Steffen =?utf-8?B?QsOkdHo=?= <steffen@innosonix.de>,
	netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
Message-ID: <20230511114629.uphhfwlbufte6oup@skbuf>
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
 <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
 <20230510182826.pxwiauia334vwvlh@skbuf>
 <CAOMZO5Ad4_J4Jfyk8jaht07HMs7XU6puXtAw+wuQ70Szy3qa2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5Ad4_J4Jfyk8jaht07HMs7XU6puXtAw+wuQ70Szy3qa2A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Fabio,

On Thu, May 11, 2023 at 08:03:01AM -0300, Fabio Estevam wrote:
> Hi Vladimir,
> 
> On Wed, May 10, 2023 at 3:28 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > I checked out the v6.1.26 tag from linux-stable and I was able to
> > synchronize 2 stations attached to my Turris MOX (Marvell 6190) with
> > this commands: sudo ptp4l -i eth0 -4 -m
> > (also I was able to synchronize a third station behind a mvneta bridge
> > port foreign to the MV88E6190, using software forwarding)
> 
> Thanks for testing it, appreciate it.
> 
> > My bridge configuration is VLAN-aware. FWIW, I'm using vlan_default_pvid
> > 1000, but it should not make a difference.
> >
> > In a bridging configuration where there are only 2 ports in the bridge
> > PVID (1 source and 1 destination), could you please run the following
> > command from a station attached to one of the Marvell switch ports:
> >
> > board # ethtool -S lanX | grep -v ': 0'
> > station # mausezahn eth0 -B 224.0.1.129 -c 1000 -t udp "dp=319"
> > board # ethtool -S lanX | grep -v ': 0'
> >
> > and tell me which counters increment?
> 
> In our tests:
> eth0 is the port connected to the i.MX8MN.

I don't see the "eth0" name referenced in any of the attached files. By
"connected to the i.MX8MN" you mean "separate from the board under test",
right? To be more specific, it is always connected to the eth2 switch
port, correct?

> eth1 and eth2 are the Marvell switch ports
> 
> Please find attached two configurations and the results.
> 
> Some notes:
> 
> - We have bridged (eth1+eth2) = br0, no matter if it is VLAN aware or not.
> - PTP traffic flows correctly over eth1+eth2 (the 2 hardware switch interfaces)

"Flows correctly" with vlan_filtering=1? (netconfig_mausezahn_test1.sh, right)?

> - PTP traffic appears shortly, (like during 30 seconds) on the
> non-VLAN-aware case br0 interface.

Which test case is this? Both test1 and test2 are fully VLAN-aware from
the start.

What happens after 30 seconds? PTP traffic disappears? Is the bridge
still VLAN-unaware when this happens?

> - PTP traffic does not appear on the VLAN-aware br0 interface

The collected statistics are a bit noisy. The $(after - before) for
in_multicasts is 1400, and for out_multicasts is 1026. So it appears
that multicast traffic is flowing bidirectionally. Could you either stop
the other sources of traffic while repeating the experiment, or send a
higher number of mausezahn packets, so they stand out more clearly in
the delta? The mausezahn packets should have the same basic characteristics
to the switch as the PTP traffic, so you shouldn't need PTP to figure
out what's wrong for now.

Also, result_mausezahn_test1.txt says:
| Station that generates the traffic with mausezahn is connected to eth2, statistics on eth1

Could you take the statistics on the ingress switch port please? (eth2)

As for result_mausezahn_test2.txt, it says:
| Station that generates the traffic with mausezahn is connected to eth2, statistics on br0

but eth2 is not one of the ports under br0! (only eth1 and veth1 are)
So you don't expect eth2 to forward these packets, do you?

Also, the same comment: please capture the statistics at the ingress
port, not at the expected egress port. I am operating under the
assumption that in the case which doesn't work for you, the switch drops
the packets somewhere, and I want to find out the reason (which should
be on the ingress port).

