Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E8E6E2B00
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 22:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDNUNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 16:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDNUNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 16:13:20 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A6D65B7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 13:13:17 -0700 (PDT)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2CC643F46A
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 20:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681503193;
        bh=j+2C3bAGLZY5j/j5vsOTAv/QyDazrqmaWqDTFOuzdy8=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=iA8M8iQFhe50W4yaJPLcKnN1nhCkgAvW4JT70iC3YRxid0KZib8zenCwFRXjWnzga
         ufAB9KyVrYoCnpqwF8uDprwl/liNcwq98Om4r3Kl7roxHJ0M/SeSF37ScxqZnoC0UQ
         E0Adz1qXNP+Lca+xx8j+udjI1kGschSCqVgtbFslyLvOsUowGwwm+repNGQ2xpguwD
         EfIkmgqu8nDoMW/3w3a9VNxJEIdDSr6P4IQ4xZ/twu3RzUwAJDyWujB8HMXGbTINoE
         3AZquj+YFC+uCJ+tKdjMiuJdblZu9YzYPezx8bqyEckBruN37nfwBzNSTmaNgzwGr7
         06J8I74BBMTBQ==
Received: by mail-pj1-f69.google.com with SMTP id nn5-20020a17090b38c500b00246772f5325so7686784pjb.6
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 13:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681503192; x=1684095192;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j+2C3bAGLZY5j/j5vsOTAv/QyDazrqmaWqDTFOuzdy8=;
        b=GDad8BsYFrRs9cUXxPlwvhSQUKgpZubJ/SvvOCNw3+7AjSD5W7v9gogI9UYDAyEA3V
         tPRSZsNW/kiZDtAtQCoYS+3ewbAWmiplfRf0DvgAsJAnhqbyLg9RXhtcXT7o5+wqTSfA
         yTORmYLDRHAAmfRaU0V5KdKhB8CWm1DvcDOujWWbZSR+YYmJW+Xdl64CZUzpWMNCleTa
         Jmu3Wqk3d6fvcZL1S69Asa+KHexRhcvIpLhzoPHcnuOJpQvpQB9IlbHeotYacsaTdFwR
         hBZ/yt3ZYe23SiA0DidnikBzk+Y+9GNb2frVNqGpuwF0BRcCXt3x9SFGxbyT72gBS784
         QdCA==
X-Gm-Message-State: AAQBX9cfjJVNGUMyyDiZaUQMXOgdB2B9QRD4MxfHBI8CYYCqWkYVR9ef
        uEEB8iPDU5F/XvuBfHJ113nIcXIZPdYAtfeCaN00RdvGeXror8inNsP6s7bvKylNjTrpqt0cnl2
        R2GhiJ6eGCT8iF6sY9FWFbBjYhrJqDZkNJw==
X-Received: by 2002:a05:6a20:29a2:b0:d4:9d94:8e7c with SMTP id f34-20020a056a2029a200b000d49d948e7cmr6454704pzh.2.1681503191770;
        Fri, 14 Apr 2023 13:13:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350awS9BNT5jrDx+qrxvYm8aFaxvtxQiPNuPQ+oKWy94+el4l8QaWGdCmLRd45xElXRurD9ARdQ==
X-Received: by 2002:a05:6a20:29a2:b0:d4:9d94:8e7c with SMTP id f34-20020a056a2029a200b000d49d948e7cmr6454689pzh.2.1681503191458;
        Fri, 14 Apr 2023 13:13:11 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id r11-20020a65498b000000b004e28be19d1csm3184505pgs.32.2023.04.14.13.13.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Apr 2023 13:13:11 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 878E461E6E; Fri, 14 Apr 2023 13:13:10 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 824FE9FB79;
        Fri, 14 Apr 2023 13:13:10 -0700 (PDT)
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
Subject: Re: [PATCHv4 net-next] bonding: add software tx timestamping support
In-reply-to: <20230414083526.1984362-1-liuhangbin@gmail.com>
References: <20230414083526.1984362-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Fri, 14 Apr 2023 16:35:26 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16052.1681503190.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 14 Apr 2023 13:13:10 -0700
Message-ID: <16053.1681503190@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

	-J

>---
>v4: add ASSERT_RTNL to make sure bond_ethtool_get_ts_info() called via
>    RTNL. Only check _TX_SOFTWARE for the slaves.
>v3: remove dev_hold/dev_put. remove the '\' for line continuation.
>v2: check each slave's ts info to make sure bond support sw tx
>    timestamping
>---
> drivers/net/bonding/bond_main.c | 32 ++++++++++++++++++++++++++++++++
> 1 file changed, 32 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 00646aa315c3..9cf49b61f4b3 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -5686,11 +5686,17 @@ static int bond_ethtool_get_ts_info(struct net_de=
vice *bond_dev,
> 				    struct ethtool_ts_info *info)
> {
> 	struct bonding *bond =3D netdev_priv(bond_dev);
>+	struct ethtool_ts_info ts_info;
> 	const struct ethtool_ops *ops;
> 	struct net_device *real_dev;
>+	bool sw_tx_support =3D false;
> 	struct phy_device *phydev;
>+	struct list_head *iter;
>+	struct slave *slave;
> 	int ret =3D 0;
> =

>+	ASSERT_RTNL();
>+
> 	rcu_read_lock();
> 	real_dev =3D bond_option_active_slave_get_rcu(bond);
> 	dev_hold(real_dev);
>@@ -5707,10 +5713,36 @@ static int bond_ethtool_get_ts_info(struct net_de=
vice *bond_dev,
> 			ret =3D ops->get_ts_info(real_dev, info);
> 			goto out;
> 		}
>+	} else {
>+		/* Check if all slaves support software tx timestamping */
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
>+			if (!ret && (ts_info.so_timestamping & SOF_TIMESTAMPING_TX_SOFTWARE))=
 {
>+				sw_tx_support =3D true;
>+				continue;
>+			}
>+
>+			sw_tx_support =3D false;
>+			break;
>+		}
>+		rcu_read_unlock();
> 	}
> =

>+	ret =3D 0;
> 	info->so_timestamping =3D SOF_TIMESTAMPING_RX_SOFTWARE |
> 				SOF_TIMESTAMPING_SOFTWARE;
>+	if (sw_tx_support)
>+		info->so_timestamping |=3D SOF_TIMESTAMPING_TX_SOFTWARE;
>+
> 	info->phc_index =3D -1;
> =

> out:
>-- =

>2.38.1
>
