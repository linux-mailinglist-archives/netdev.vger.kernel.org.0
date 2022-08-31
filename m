Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037A65A746D
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 05:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiHaD0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 23:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiHaD0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 23:26:00 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711146717B
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 20:25:58 -0700 (PDT)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 761343F483
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 03:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1661916356;
        bh=8sF6aawFDPMNlKmqkeYI2Hq5XD9SQnHzuOjJ17Aw5yU=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=ugYG0/ulLA0XmII+GJNELumkN0ufBUw4C4b0zBpsqbO/LNtfssdWeSvR9xlZWuP9V
         Ln5ZPu8+XgE+laCCFhmy4ZP2FMQ07s+PLlv8aGc/dRUbLB2uJX+Gtg2tAn9+veCPnm
         mjp3MRL5HM+zyOmCb8wsQm539fAu/IJYr/c6Cl2FSnvx260ugYZqvVYgPU4xNBVsyk
         Pcgkffl7VzkB5tsOx0+m7QwB+ics9N9rXOOYo1caM0uoZE3nHKI2MBpG+/JImElFfq
         rrDHTj/+65JCRwa728E17x3m4RFF/Zuq2ocLaY5XOorcTs20mvI6hHy/NNlykVhSEd
         2TgYFTqaSlpLw==
Received: by mail-io1-f72.google.com with SMTP id g12-20020a5d8c8c000000b006894fb842e3so7999663ion.21
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 20:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8sF6aawFDPMNlKmqkeYI2Hq5XD9SQnHzuOjJ17Aw5yU=;
        b=Ia6OQGwKYH8jzLDRcCYMlS0QqobGdVfE3UDMnI1AyH0jXwhRg2TOzJ/+QSl9gyNB1T
         rWA/AG+uLZUIYymuQzUfvB23rayqgpZvgqMlHMDI0oLF8685JZg2rXKMHdnvkEYOgFbp
         LbLPBI3HsNYTXydpT2YYgiWSuzdF2fbYxKKGiD2HH4ArRFZbFCcUZDGQlcdVxSEaS+4s
         w2Rwrw3t4OwVW/1Vw3mFixpDR0nZt5oK2ma6rNRHcRHOptKqsY1AeP5X04J8s1ZHIrM8
         FcUeW1cIuF/31vX2owHGX47RTFxw94++FZFeWS1Hmzjo0QKkAOC3Sunu6yZP/bviFHvY
         NN1A==
X-Gm-Message-State: ACgBeo0M57aVviCbfip7xoqhG1xv110oOh37hL3cEXixR3aA5eYXV6qo
        fuL/NHrHIYSPUcE1vYFjZSrpVTUZP/vAUBxFTKgO4ypGN4yYY9VDzYHoMcqFyl29cob2dRISECy
        A+0ezCm6JI8Vc9JNsARxqsuBlTTiSxtxHpA==
X-Received: by 2002:a05:6602:2d53:b0:689:60e8:a644 with SMTP id d19-20020a0566022d5300b0068960e8a644mr12375459iow.35.1661916355028;
        Tue, 30 Aug 2022 20:25:55 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7MKRvyxRm+QJM/8vScKjMQL/MYbX4KkEVkGE53q0Lf22ghvKwU16K/1o5A/OGpW5eoQWKfgA==
X-Received: by 2002:a05:6602:2d53:b0:689:60e8:a644 with SMTP id d19-20020a0566022d5300b0068960e8a644mr12375452iow.35.1661916354826;
        Tue, 30 Aug 2022 20:25:54 -0700 (PDT)
Received: from nyx.localdomain ([204.77.137.230])
        by smtp.gmail.com with ESMTPSA id x12-20020a0566022c4c00b0068994e773e7sm6963058iov.26.2022.08.30.20.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 20:25:54 -0700 (PDT)
Received: by nyx.localdomain (Postfix, from userid 1000)
        id C8C9E2410F8; Tue, 30 Aug 2022 20:25:53 -0700 (PDT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id BBEAF2808B5;
        Tue, 30 Aug 2022 20:25:53 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Benjamin Poirier <bpoirier@nvidia.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 1/3] net: bonding: Unsync device addresses on ndo_stop
In-reply-to: <20220831025836.207070-2-bpoirier@nvidia.com>
References: <20220831025836.207070-1-bpoirier@nvidia.com> <20220831025836.207070-2-bpoirier@nvidia.com>
Comments: In-reply-to Benjamin Poirier <bpoirier@nvidia.com>
   message dated "Wed, 31 Aug 2022 11:58:34 +0900."
X-Mailer: MH-E 8.6+git; nmh 1.7.1; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <195899.1661916353.1@nyx>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 30 Aug 2022 20:25:53 -0700
Message-ID: <195900.1661916353@nyx>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Poirier <bpoirier@nvidia.com> wrote:

>Netdev drivers are expected to call dev_{uc,mc}_sync() in their
>ndo_set_rx_mode method and dev_{uc,mc}_unsync() in their ndo_stop method.
>This is mentioned in the kerneldoc for those dev_* functions.
>
>The bonding driver calls dev_{uc,mc}_unsync() during ndo_uninit instead o=
f
>ndo_stop. This is ineffective because address lists (dev->{uc,mc}) have
>already been emptied in unregister_netdevice_many() before ndo_uninit is
>called. This mistake can result in addresses being leftover on former bon=
d
>slaves after a bond has been deleted; see test_LAG_cleanup() in the last
>patch in this series.
>
>Add unsync calls, via bond_hw_addr_flush(), at their expected location,
>bond_close().
>Add dev_mc_add() call to bond_open() to match the above change.
>The existing call __bond_release_one->bond_hw_addr_flush is left in place
>because there are other call chains that lead to __bond_release_one(), no=
t
>just ndo_uninit.
>
>Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

	I'm just going from memory here, so I'm probably wrong, but
didn't the sync/unsync stuff for HW addresses happen several years after
the git transition?

>Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
>---
> drivers/net/bonding/bond_main.c | 31 +++++++++++++++++++++----------
> 1 file changed, 21 insertions(+), 10 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 2f4da2c13c0a..5784fbe03552 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -254,6 +254,8 @@ static const struct flow_dissector_key flow_keys_bond=
ing_keys[] =3D {
> =

> static struct flow_dissector flow_keys_bonding __read_mostly;
> =

>+static const u8 lacpdu_multicast[] =3D MULTICAST_LACPDU_ADDR;
>+
> /*-------------------------- Forward declarations ----------------------=
-----*/
> =

> static int bond_init(struct net_device *bond_dev);
>@@ -865,12 +867,8 @@ static void bond_hw_addr_flush(struct net_device *bo=
nd_dev,
> 	dev_uc_unsync(slave_dev, bond_dev);
> 	dev_mc_unsync(slave_dev, bond_dev);
> =

>-	if (BOND_MODE(bond) =3D=3D BOND_MODE_8023AD) {
>-		/* del lacpdu mc addr from mc list */
>-		u8 lacpdu_multicast[ETH_ALEN] =3D MULTICAST_LACPDU_ADDR;
>-
>+	if (BOND_MODE(bond) =3D=3D BOND_MODE_8023AD)
> 		dev_mc_del(slave_dev, lacpdu_multicast);
>-	}
> }
> =

> /*--------------------------- Active slave change ----------------------=
-----*/
>@@ -2171,12 +2169,8 @@ int bond_enslave(struct net_device *bond_dev, stru=
ct net_device *slave_dev,
> 		dev_uc_sync_multiple(slave_dev, bond_dev);
> 		netif_addr_unlock_bh(bond_dev);
> =

>-		if (BOND_MODE(bond) =3D=3D BOND_MODE_8023AD) {
>-			/* add lacpdu mc addr to mc list */
>-			u8 lacpdu_multicast[ETH_ALEN] =3D MULTICAST_LACPDU_ADDR;
>-
>+		if (BOND_MODE(bond) =3D=3D BOND_MODE_8023AD)
> 			dev_mc_add(slave_dev, lacpdu_multicast);
>-		}
> 	}

	Just to make sure I'm clear, the above changes regarding
lacpdu_multicast have no functional impact, correct?  They appear to
move lacpdu_multicast to global scope for use in the change just below.

> =

> 	bond->slave_cnt++;
>@@ -4211,6 +4205,9 @@ static int bond_open(struct net_device *bond_dev)
> 		/* register to receive LACPDUs */
> 		bond->recv_probe =3D bond_3ad_lacpdu_recv;
> 		bond_3ad_initiate_agg_selection(bond, 1);
>+
>+		bond_for_each_slave(bond, slave, iter)
>+			dev_mc_add(slave->dev, lacpdu_multicast);
> 	}

	After this patch, am I understanding correctly that both
bond_enslave and bond_open will call dev_mc_add for lacpdu_multicast?
Since __dev_mc_add calls __hw_addr_add_ex with sync=3Dfalse and
exclusive=3Dfalse, doesn't that allow us to end up with two references?

	-J

> 	if (bond_mode_can_use_xmit_hash(bond))
>@@ -4222,6 +4219,7 @@ static int bond_open(struct net_device *bond_dev)
> static int bond_close(struct net_device *bond_dev)
> {
> 	struct bonding *bond =3D netdev_priv(bond_dev);
>+	struct slave *slave;
> =

> 	bond_work_cancel_all(bond);
> 	bond->send_peer_notif =3D 0;
>@@ -4229,6 +4227,19 @@ static int bond_close(struct net_device *bond_dev)
> 		bond_alb_deinitialize(bond);
> 	bond->recv_probe =3D NULL;
> =

>+	if (bond_uses_primary(bond)) {
>+		rcu_read_lock();
>+		slave =3D rcu_dereference(bond->curr_active_slave);
>+		if (slave)
>+			bond_hw_addr_flush(bond_dev, slave->dev);
>+		rcu_read_unlock();
>+	} else {
>+		struct list_head *iter;
>+
>+		bond_for_each_slave(bond, slave, iter)
>+			bond_hw_addr_flush(bond_dev, slave->dev);
>+	}
>+
> 	return 0;
> }
> =

>-- =

>2.36.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
