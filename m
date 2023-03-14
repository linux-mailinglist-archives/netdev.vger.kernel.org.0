Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D926B99C0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjCNPhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjCNPgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:36:42 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA67B1B37
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:35:29 -0700 (PDT)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id AE3B1445B5
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 15:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678808098;
        bh=67d6NdEVpeH9JN58ysK6VRVXeCXuf3MwOPI0MBEl86Q=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=gLak5t/IAJg7PxDvxXEEgNVlRdfQ/qM9jzOgbLs4HEznLKTokZGSUB5ynYf8W5+eJ
         Ptd7TGq2gJVDfrBShqNAv4yHgOOmScqp4IxJlVRPl4lDDUIfp5mL20GIpze0uHPgnA
         rjb0RSfbggzg/BLWN6mPmC0W+hKaUw/nZI01+Hwg/wrLsY0LuzFZ/m21D7EI20gtMY
         Bw9pN/pc3sAUVeqIVM+XVTBMsF3CIM1Nfh7l+pDlzAtReGEpIQxf1CxoqwAknxDs82
         2s4kTpwoFaBYgE+VvuGGvSaqO66sPomWQPxRGa6V0M+pPVWjwiMEMLYVrkfbjpZ0Bt
         3ret8nCUhwRBA==
Received: by mail-pl1-f200.google.com with SMTP id i6-20020a170902c94600b0019d16e4ac0bso8947028pla.5
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808097;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=67d6NdEVpeH9JN58ysK6VRVXeCXuf3MwOPI0MBEl86Q=;
        b=dC8Rr0UoeqCdMLEinX+i79RA9v3Jz4IgKBrL+YEqaSUJBTaqRqjH2hdZArxO8WPmzk
         MGd5PLnELzODpKmvxD4jvxbvV9y3cAJ/Fj/GEyrQiiI2cqn1KJ5nte44rpgz80JqI/bV
         qAt8M9k0zCPohQOHqnNgLd//ehscaGBV/o/OlNN90gthPBdsBd3uKU2+J+F9y5ZTflLe
         9u/3Kk+WZXjzueHyP1BaVmmj+MZ46Q/Cj2RDDIfDSHSTZ7a5c6OHWPH0FFsmOUZOHWO+
         ZuOnh0SegkTX7J4R4smEzy1lgpd8npn9rUjp7wqGGnlux1TZTFhPC7J1sWcylcHFi1Cg
         ghHg==
X-Gm-Message-State: AO0yUKWOyLWG26kS1n7sAkEq00mAK4Bs6cgrcmXtV17NfQpDr4zWMXaI
        GSmBjQab6Pa/5uQkOhMwnVeAVYFt4eyzRVTOIMtxyE7R5xPxgcIWiVQ7CFU4soBqr/xWDuPZWFv
        BftT7Pzalg5cBylZsYZzgLWMt/1RvE4rI0g==
X-Received: by 2002:a62:1785:0:b0:5a8:e3dc:4337 with SMTP id 127-20020a621785000000b005a8e3dc4337mr15521649pfx.16.1678808096872;
        Tue, 14 Mar 2023 08:34:56 -0700 (PDT)
X-Google-Smtp-Source: AK7set9Z+8uXbLeEdjHP1+rqmXergfD4y+XJlUu3kjcUiS0F9JILKNkfi/k+ODgk2KAvrv/ZMjzvIQ==
X-Received: by 2002:a62:1785:0:b0:5a8:e3dc:4337 with SMTP id 127-20020a621785000000b005a8e3dc4337mr15521629pfx.16.1678808096566;
        Tue, 14 Mar 2023 08:34:56 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id x52-20020a056a000bf400b005a8b4dcd21asm1851025pfu.15.2023.03.14.08.34.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:34:56 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id A73F25FEAC; Tue, 14 Mar 2023 08:34:55 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A1BCB9FA5F;
        Tue, 14 Mar 2023 08:34:55 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
cc:     netdev@vger.kernel.org, monis@voltaire.com, syoshida@redhat.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2 1/4] bonding: add bond_ether_setup helper
In-reply-to: <20230314111426.1254998-2-razor@blackwall.org>
References: <20230314111426.1254998-1-razor@blackwall.org> <20230314111426.1254998-2-razor@blackwall.org>
Comments: In-reply-to Nikolay Aleksandrov <razor@blackwall.org>
   message dated "Tue, 14 Mar 2023 13:14:23 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28496.1678808095.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 14 Mar 2023 08:34:55 -0700
Message-ID: <28497.1678808095@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nikolay Aleksandrov <razor@blackwall.org> wrote:

>Add bond_ether_setup helper which will be used in the following patches
>to fix all ether_setup() calls in the bonding driver. It takes care of bo=
th
>IFF_MASTER and IFF_SLAVE flags, the former is always restored and the
>latter only if it was set.
>
>Fixes: e36b9d16c6a6d ("bonding: clean muticast addresses when device chan=
ges type")
>Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on en=
slave failure")
>Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>---
> drivers/net/bonding/bond_main.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 00646aa315c3..d41024ad2c18 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1775,6 +1775,18 @@ void bond_lower_state_changed(struct slave *slave)
> 		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
> } while (0)
> =

>+/* ether_setup() resets bond_dev's flags so we always have to restore
>+ * IFF_MASTER, and only restore IFF_SLAVE if it was set
>+ */
>+static void bond_ether_setup(struct net_device *bond_dev)
>+{
>+	unsigned int slave_flag =3D bond_dev->flags & IFF_SLAVE;
>+
>+	ether_setup(bond_dev);
>+	bond_dev->flags |=3D IFF_MASTER | slave_flag;
>+	bond_dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
>+}

	Is setting IFF_MASTER always correct here?  I note that patch #2
is replacing code that does not set IFF_MASTER, whereas patch #3 is
replacing code that does set IFF_MASTER.

	Presuming that this is the desired behavior, perhaps mention
explicitly in the commentary that bond_ether_setup() is only for use on
a bond master device.  The nomenclature "bond_dev" does imply that, but
it's not explicit.

	Also, why is the call to ether_setup() from bond_setup() not
also being converted to bond_ether_setup()?

	-J

>+
> /* enslave device <slave> to bond device <master> */
> int bond_enslave(struct net_device *bond_dev, struct net_device *slave_d=
ev,
> 		 struct netlink_ext_ack *extack)
>-- =

>2.39.2
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
