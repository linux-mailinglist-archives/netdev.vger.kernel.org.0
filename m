Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0D76DE874
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 02:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjDLAUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 20:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjDLAUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 20:20:00 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFC22D50
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 17:19:58 -0700 (PDT)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EF7FC3F23C
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 00:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681258796;
        bh=nP8Flv97DA1Z4/7xjXXvC93Zd4pHVn/tz5sTuSk1w0Y=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=JMcD2WLTvwgODRmPGGavi5EAdbngLJ20J4KyZ2AVFOKWyLLCYwd0eBcu072fw+h63
         auk2CiuVCNPXY8Qq5THZm9NGncyozk3rohPF8wJgMExCmkFnC/dkpjoIek3EsJKgm2
         If3xXN/HoYtvqTIwtQLo9AB51f7VhV+ldVHQ35TgW66dJSO8fZ6cguETmA6yGuszIZ
         AiaaoFWaTltppW52XvM/KkfiuETI7wxLYqqF439ivRsMLpA/nNFvbxzaAtl79UpvCy
         2Jo62OcsO3SrOiIqEN8nCCjFFARPLzDsuV6HubC48Hi7mlCeWQi0h9LQDs1CUG6YBR
         24KbX3JUftJCA==
Received: by mail-pl1-f199.google.com with SMTP id d1-20020a170902cec100b001a639418d05so4318271plg.10
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 17:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681258795; x=1683850795;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nP8Flv97DA1Z4/7xjXXvC93Zd4pHVn/tz5sTuSk1w0Y=;
        b=OdfXqrXwfMxGpPbDSOqz5IgBNTaxpJuG2KCXsTuUVDRev6fa4oUaJ2WfBOzC6X+x57
         Cmy3oISd25tFyYl9OSsLle5gZFR2gB1r+Lu3ecK/XTNG/CYeu9T1rRXvnF846HwsBhp2
         x7Jgsr9QhFNJf/9mcXszY0vkxzkXt6t1Ew5D9dFgkm8fdiOqkL+LY6QYSot0i40AdUcM
         RH1qvtV/cG/3/f2BWrrqNqaBSWWYwN7Is/clvj3tMYBU83/vcl6EFp5ix8W30XFBkwqn
         on4Gd3pH9MjJrmZvI4TThKj66YfCNkKcurtwddWZ0rkrN3wdLn1MrGZghD6K77pEjfrF
         /pcQ==
X-Gm-Message-State: AAQBX9fJiU9mNuHLcBHXr3gAb6pJKpeDRwKm2lYSFmreUSV077rzIALP
        3wU+zDDgqDVlt0a729UOvsK56+GCTNSuxULLliTMNx8Q9SjFWUNlhV/VFoB3A91YnAZ22DNqGH5
        8QTA8iB3taUJhi4REJYXDnPQBQOhed+ZdlQ==
X-Received: by 2002:a17:90b:1e44:b0:246:88d1:aed4 with SMTP id pi4-20020a17090b1e4400b0024688d1aed4mr6265819pjb.45.1681258795441;
        Tue, 11 Apr 2023 17:19:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350bYqZdEjyQFtnF6e2od9e2qEYjctFijt5v7Jc5pxHmtzQ1AWmpsnHMfB22G1jHO32jJ39Dekg==
X-Received: by 2002:a17:90b:1e44:b0:246:88d1:aed4 with SMTP id pi4-20020a17090b1e4400b0024688d1aed4mr6265795pjb.45.1681258795101;
        Tue, 11 Apr 2023 17:19:55 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id co16-20020a17090afe9000b00246be20e216sm161844pjb.34.2023.04.11.17.19.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Apr 2023 17:19:54 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2056661E6E; Tue, 11 Apr 2023 17:19:54 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 18EB49FB79;
        Tue, 11 Apr 2023 17:19:54 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv3 net-next] bonding: add software tx timestamping support
In-reply-to: <20230410082351.1176466-1-liuhangbin@gmail.com>
References: <20230410082351.1176466-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Mon, 10 Apr 2023 16:23:51 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9322.1681258794.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 11 Apr 2023 17:19:54 -0700
Message-ID: <9323.1681258794@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>Currently, bonding only obtain the timestamp (ts) information of
>the active slave, which is available only for modes 1, 5, and 6.
>For other modes, bonding only has software rx timestamping support.
>
>However, some users who use modes such as LACP also want tx timestamp
>support. To address this issue, let's check the ts information of each
>slave. If all slaves support tx timestamping, we can enable tx
>timestamping support for the bond.
>
>Suggested-by: Miroslav Lichvar <mlichvar@redhat.com>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
>v3: remove dev_hold/dev_put. remove the '\' for line continuation.
>v2: check each slave's ts info to make sure bond support sw tx
>    timestamping
>---
> drivers/net/bonding/bond_main.c | 36 +++++++++++++++++++++++++++++++--
> include/uapi/linux/net_tstamp.h |  3 +++
> 2 files changed, 37 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 00646aa315c3..3b643739bbe7 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -5686,9 +5686,13 @@ static int bond_ethtool_get_ts_info(struct net_dev=
ice *bond_dev,
> 				    struct ethtool_ts_info *info)
> {
> 	struct bonding *bond =3D netdev_priv(bond_dev);
>+	struct ethtool_ts_info ts_info;
> 	const struct ethtool_ops *ops;
> 	struct net_device *real_dev;
> 	struct phy_device *phydev;
>+	bool soft_support =3D false;
>+	struct list_head *iter;
>+	struct slave *slave;
> 	int ret =3D 0;
> =

> 	rcu_read_lock();
>@@ -5707,10 +5711,38 @@ static int bond_ethtool_get_ts_info(struct net_de=
vice *bond_dev,
> 			ret =3D ops->get_ts_info(real_dev, info);
> 			goto out;
> 		}
>+	} else {
>+		/* Check if all slaves support software rx/tx timestamping */
>+		rcu_read_lock();
>+		bond_for_each_slave_rcu(bond, slave, iter) {
>+			ret =3D -1;
>+			ops =3D slave->dev->ethtool_ops;
>+			phydev =3D slave->dev->phydev;
>+
>+			if (phy_has_tsinfo(phydev))
>+				ret =3D phy_ts_info(phydev, &ts_info);
>+			else if (ops->get_ts_info)
>+				ret =3D ops->get_ts_info(slave->dev, &ts_info);
>+
>+			if (!ret && (ts_info.so_timestamping & SOF_TIMESTAMPING_SOFTRXTX) =3D=
=3D
>+				    SOF_TIMESTAMPING_SOFTRXTX) {
>+				soft_support =3D true;
>+				continue;
>+			}
>+
>+			soft_support =3D false;
>+			break;
>+		}
>+		rcu_read_unlock();
> 	}
> =

>-	info->so_timestamping =3D SOF_TIMESTAMPING_RX_SOFTWARE |
>-				SOF_TIMESTAMPING_SOFTWARE;
>+	ret =3D 0;
>+	if (soft_support) {
>+		info->so_timestamping =3D SOF_TIMESTAMPING_SOFTRXTX;
>+	} else {
>+		info->so_timestamping =3D SOF_TIMESTAMPING_RX_SOFTWARE |
>+					SOF_TIMESTAMPING_SOFTWARE;
>+	}
> 	info->phc_index =3D -1;
> =

> out:
>diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tst=
amp.h
>index a2c66b3d7f0f..2adaa0008434 100644
>--- a/include/uapi/linux/net_tstamp.h
>+++ b/include/uapi/linux/net_tstamp.h
>@@ -48,6 +48,9 @@ enum {
> 					 SOF_TIMESTAMPING_TX_SCHED | \
> 					 SOF_TIMESTAMPING_TX_ACK)
> =

>+#define SOF_TIMESTAMPING_SOFTRXTX (SOF_TIMESTAMPING_TX_SOFTWARE | \
>+				   SOF_TIMESTAMPING_RX_SOFTWARE | \
>+				   SOF_TIMESTAMPING_SOFTWARE)
> /**
>  * struct so_timestamping - SO_TIMESTAMPING parameter
>  *
>-- =

>2.38.1
>
