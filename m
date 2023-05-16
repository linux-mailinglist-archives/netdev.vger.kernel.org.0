Return-Path: <netdev+bounces-3028-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A6A7051CB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:15:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 339212815B4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82FB528C29;
	Tue, 16 May 2023 15:15:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F92E34CEC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:15:52 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED5540E8
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:15:48 -0700 (PDT)
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D61DB3F4D8
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684250145;
	bh=iTvlFKSwib93tIKFKt+HnqYlA/ksROMfbN2GQTLTXB8=;
	h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
	 Content-Type:Date:Message-ID;
	b=rx7UWIe4zLbK0WaPpGFOQGI2HwBd4nXdDIroFcBad3A2XvQB2C/v545boT5d47eoK
	 AJzrUvBCMYFAsFpWkybWJmO0Za3P22PscntOL08FAFUXVL1/+A2y63j5ld04Ca9xfZ
	 l4uwjlHStOQ1/hABkTzrPeb90epUP2J233QmlMLvwedau2lKZHuNlGAR3weEVtnO2/
	 shb5u+rtmZXJi42peM1StGRYmGIKQDFYSEIwjLKAbPWFo+/9daBxq0qE0+8xHn/0al
	 InwdrCL1sas26nW85kyGsOxl/5kdnSGtqn6CyShTP6OmbhcA0LNgNL7xXqc1qSdxi3
	 Mw0rMExqYwJDA==
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-64378a8b332so8307680b3a.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684250144; x=1686842144;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iTvlFKSwib93tIKFKt+HnqYlA/ksROMfbN2GQTLTXB8=;
        b=ffKKrYQsBh3mWdFx5PqrouFGIxQ2lRuFKj6+cT9UmgskSHh4XmVv+XykOchDU5VARd
         8FhR9o0ulZwuD2nv2QRuyOoevPbrFM6cuwHNJo5DIaiXeEVjtYU+ZgRXOXl36pliWBsD
         tfVKWNSQpxTpskrGy2b0wI0GRAWlgekTpYhrg02JiKp18x+sie75GnROM0p6kNxMcRqP
         P0OcaP76H6+2r3itjuYKuN/Uk3Kmhgyk6r5y5y8sbCoCgnGHuyfM5LPULNTV8huwGZ/x
         DhaoWRClPd4WntkilkIyrVTpL/ucznktKb9CY11FyIysoaqxzycTuKnq0oqmNCheGAbX
         luAQ==
X-Gm-Message-State: AC+VfDxHMz9HHBKTGVvwBrf3vVTcDdpwuHs4VVFW4VwgOVbgvOi0tPRG
	JlDaKyRUYNzdBEZGbtULyAo9KpVZ5o2n8Nf6bMGqZVaMs3ezftjEVXd7xVfT/jF4Ubl+anqyfus
	xC+0RRAi6HV9IjtDTA/HeJeS4GX/vR9sqkg==
X-Received: by 2002:a17:902:b08c:b0:1a1:ee8c:eef7 with SMTP id p12-20020a170902b08c00b001a1ee8ceef7mr40074953plr.48.1684250144291;
        Tue, 16 May 2023 08:15:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4HdnQri2vBDojSeMXzhQ/Kg3CFAbObWMUuLf6FCcHU8PLL8nvl4lJAozdWpffiiE0Clk/y7A==
X-Received: by 2002:a17:902:b08c:b0:1a1:ee8c:eef7 with SMTP id p12-20020a170902b08c00b001a1ee8ceef7mr40074921plr.48.1684250143933;
        Tue, 16 May 2023 08:15:43 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id iz3-20020a170902ef8300b001ac444fd07fsm11895135plb.100.2023.05.16.08.15.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 08:15:43 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
	id EC208608D4; Tue, 16 May 2023 08:15:42 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
	by famine.localdomain (Postfix) with ESMTP id DC7179FAA4;
	Tue, 16 May 2023 08:15:42 -0700 (PDT)
From: Jay Vosburgh <jay.vosburgh@canonical.com>
To: Mateusz Palczewski <mateusz.palczewski@intel.com>
cc: andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
    kuba@kernel.org, pabeni@redhat.com, dbanerje@akamai.com,
    netdev@vger.kernel.org,
    Sebastian Basierski <sebastianx.basierski@intel.com>
Subject: Re: [PATCH iwl-net v1 2/2] drivers/net/bonding: Added some delay while checking for VFs link
In-reply-to: <20230516134447.193511-3-mateusz.palczewski@intel.com>
References: <20230516134447.193511-1-mateusz.palczewski@intel.com> <20230516134447.193511-3-mateusz.palczewski@intel.com>
Comments: In-reply-to Mateusz Palczewski <mateusz.palczewski@intel.com>
   message dated "Tue, 16 May 2023 09:44:47 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32199.1684250142.1@famine>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 May 2023 08:15:42 -0700
Message-ID: <32200.1684250142@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mateusz Palczewski <mateusz.palczewski@intel.com> wrote:

>From: Sebastian Basierski <sebastianx.basierski@intel.com>
>
>Right now bonding driver checks if link is ready once.
>VF interface takes a little more time to get ready than PF,
>so driver needs to wait for it to be ready.
>1000ms delay was set, if VF link will not be set within given amount
>of time, for sure problems should be investigated elsewhere.

	Why is the "updelay" mechanism that's already available
insufficient for this purpose?

	Even without updelay, I'd expect the behavior to simply be that
the carrier state flaps once or twice (because the VF is delayed in
asserting carrier up).  This is reflecting reality; I'm unsure why we
would want to hack in an extra delay to cover that up.

	Regardless of whether updelay handles this case or not, adding a
1 second busy wait loop as this patch does is not a reasonable
implementation.  This would cause a 1 second stall in the link state
check for every bond interface that is carrier down.

	-J

>Fixes: b3c898e20b18 ("Revert "bonding: allow carrier and link status to d=
etermine link state"")
>Signed-off-by: Sebastian Basierski <sebastianx.basierski@intel.com>
>Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
>---
> drivers/net/bonding/bond_main.c | 14 +++++++++++++-
> 1 file changed, 13 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 710548dbd0c1..6d49fb25969e 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -736,6 +736,8 @@ const char *bond_slave_link_status(s8 link)
>  * It'd be nice if there was a good way to tell if a driver supports
>  * netif_carrier, but there really isn't.
>  */
>+#define BOND_CARRIER_CHECK_TIMEOUT 1000
>+
> static int bond_check_dev_link(struct bonding *bond,
> 			       struct net_device *slave_dev, int reporting)
> {
>@@ -743,12 +745,22 @@ static int bond_check_dev_link(struct bonding *bond=
,
> 	int (*ioctl)(struct net_device *, struct ifreq *, int);
> 	struct ifreq ifr;
> 	struct mii_ioctl_data *mii;
>+	int delay;
> =

> 	if (!reporting && !netif_running(slave_dev))
> 		return 0;
> =

>+	for (delay =3D 0; delay < BOND_CARRIER_CHECK_TIMEOUT; delay++) {
>+		mdelay(1);
>+
>+		if (bond->params.use_carrier &&
>+		    netif_carrier_ok(slave_dev)) {
>+			return BMSR_LSTATUS;
>+		}
>+	}
>+
> 	if (bond->params.use_carrier)
>-		return netif_carrier_ok(slave_dev) ? BMSR_LSTATUS : 0;
>+		return 0;
> =

> 	/* Try to get link status using Ethtool first. */
> 	if (slave_dev->ethtool_ops->get_link)
>-- =

>2.31.1
>
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

