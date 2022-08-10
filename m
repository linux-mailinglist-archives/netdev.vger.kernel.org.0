Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F1A58EE69
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 16:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiHJOdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 10:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiHJOcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 10:32:32 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DAD29C92
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 07:32:31 -0700 (PDT)
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 65A413F470
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 14:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660141949;
        bh=BmcNJoX0tb4WJRJWcaohS0QcQ063FfE3jZ9bfdEJX58=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=hNBHOdMWe88AmtLH6odEqI4i45Mt4gaQ13M6LEk9auWqUisyKidhuyQ8FoME5kzY4
         q4zuTGxfLQ9CI/0I7cVxJfFQ5wrOSorehkHihWrWVcCbyDNx4DguWNhQnICSGhMoRD
         v+27fj4qAktE/NXVtynublg27RM3sl3GCv5T4nJZdKDkKB2emZwKqDl15h3QBXZXNA
         0zAl8bsuXKfwFYAwXt9ILC3mGQEUC3AtjyKcebGKxt//Z1yN06o0WqEGJlLSpu9nwI
         azsakcBKyYzDuqDhM7RbNZryWRFlak2V4MpZR1owPkbGxsM7uUT2z2vgNnK0Q6RTt5
         jMjgSFzD/w6HA==
Received: by mail-pf1-f199.google.com with SMTP id r13-20020aa7988d000000b0052ed235197bso5885482pfl.20
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 07:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=BmcNJoX0tb4WJRJWcaohS0QcQ063FfE3jZ9bfdEJX58=;
        b=aaU5PviuE5UvoN6TekMu8KvQD/XG/1zhR09ggJilNpsHFHP1EDcFZR6tI22Fxh28Os
         6sSJI5bw9scCda+cmmTFt607D5GJLn0PElyZs50D6D3jXfFTgueHJxt1CPt6fXsogEvx
         yISdLsWQygBiIOU1m6JZbEdzjnyYSqg/f8/QSzIemFE4ofQGxKGx0MAGcSq13gcmh/cs
         plHPuBbQihKm/zlZ60ZhZfME3tS2BZwDhOq+1VWLaTEuODMZOEFPE5gfKYfqrz0wrTWM
         KoPsrNPYwOdcUtKKu88pa1U5YmkPAAfXNClyF7Q3UyNaHvAY6COfmEoTXVOts2mFCtCK
         7Pgg==
X-Gm-Message-State: ACgBeo3cIrzRFrj+EMYkXio+acAtBTfyPOH8U08mKqybCX0OkzzoW9/M
        aHOggC8zZFIsMrj/lMo7LRJ+2jOJ7550LE6mvyafGRoRNVCwAlpmKdJbZrGqEhw8sJP3ucgXlSr
        4OJFk6i/H6ANRu/WOj9Y6RfrYszYEjzW/TA==
X-Received: by 2002:a63:e4f:0:b0:41a:9472:eca0 with SMTP id 15-20020a630e4f000000b0041a9472eca0mr23118300pgo.623.1660141947107;
        Wed, 10 Aug 2022 07:32:27 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6SbPfI4FRAXuP5uxoCn7uNxC6/UShze/WtduBxD/rL03D2ONXUpeGsOaLZdHoLfJiTG3cz2w==
X-Received: by 2002:a63:e4f:0:b0:41a:9472:eca0 with SMTP id 15-20020a630e4f000000b0041a9472eca0mr23118287pgo.623.1660141946874;
        Wed, 10 Aug 2022 07:32:26 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id r6-20020aa79ec6000000b0052d4ffac466sm2049832pfq.188.2022.08.10.07.32.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Aug 2022 07:32:26 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id E25016119B; Wed, 10 Aug 2022 07:32:25 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id DC8A49FA79;
        Wed, 10 Aug 2022 07:32:25 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        razor@blackwall.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v2] net:bonding:support balance-alb interface with vlan to bridge
In-reply-to: <20220809062103.31213-1-sunshouxin@chinatelecom.cn>
References: <20220809062103.31213-1-sunshouxin@chinatelecom.cn>
Comments: In-reply-to Sun Shouxin <sunshouxin@chinatelecom.cn>
   message dated "Mon, 08 Aug 2022 23:21:03 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14779.1660141945.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 10 Aug 2022 07:32:25 -0700
Message-ID: <14780.1660141945@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:

>In my test, balance-alb bonding with two slaves eth0 and eth1,
>and then Bond0.150 is created with vlan id attached bond0.
>After adding bond0.150 into one linux bridge, I noted that Bond0,
>bond0.150 and  bridge were assigned to the same MAC as eth0.
>Once bond0.150 receives a packet whose dest IP is bridge's
>and dest MAC is eth1's, the linux bridge will not match
>eth1's MAC entry in FDB, and not handle it as expected.
>The patch fix the issue, and diagram as below:
>
>eth1(mac:eth1_mac)--bond0(balance-alb,mac:eth0_mac)--eth0(mac:eth0_mac)
>                      |
>                   bond0.150(mac:eth0_mac)
>                      |
>                   bridge(ip:br_ip, mac:eth0_mac)--other port
>
>Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>

	As Nik suggested, please add some additional explanation here.
You can cut and paste my description from the original discussion if
you'd like.

>---
>
>changelog:
>v1->v2:
>  -declare variabls in reverse xmas tree order
>  -delete {}
>  -add explanation in commit message
>---
> drivers/net/bonding/bond_alb.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index 007d43e46dcb..60cb9a0225aa 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -653,6 +653,7 @@ static struct slave *rlb_choose_channel(struct sk_buf=
f *skb,
> static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *b=
ond)
> {
> 	struct slave *tx_slave =3D NULL;
>+	struct net_device *dev;
> 	struct arp_pkt *arp;
> =

> 	if (!pskb_network_may_pull(skb, sizeof(*arp)))
>@@ -665,6 +666,12 @@ static struct slave *rlb_arp_xmit(struct sk_buff *sk=
b, struct bonding *bond)
> 	if (!bond_slave_has_mac_rx(bond, arp->mac_src))
> 		return NULL;
> =

>+	dev =3D ip_dev_find(dev_net(bond->dev), arp->ip_src);
>+	if (dev) {
>+		if (netif_is_bridge_master(dev))
>+			return NULL;

	Stylistically, the "if dev" and "if netif_is_bridge_master"
could be one line, e.g., "if dev && netif_is_bridge_master".

	Functionally, ip_dev_find acquires a reference to dev, and this
code will need to release (dev_put) that reference.

	I'm also wondering if testing bond->dev for netif_if_bridge_port
before ip_dev_find would help here (as an optimization); I think so, for
the case where the bond is directly in the bridge without a VLAN in the
middle.

	-J


>+	}
>+
> 	if (arp->op_code =3D=3D htons(ARPOP_REPLY)) {
> 		/* the arp must be sent on the selected rx channel */
> 		tx_slave =3D rlb_choose_channel(skb, bond, arp);
>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
