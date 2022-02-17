Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2BE24BA887
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244542AbiBQSk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:40:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244440AbiBQSkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:40:45 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29B54E385
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:40:30 -0800 (PST)
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 60EA43F33A
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 18:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645123229;
        bh=7ooOvkO5crxAahOT6RtL+CQVZ5kUZYq///EEcKWp2OU=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=CkqDbVYmeSxzIP/DHPYvQRsrZg9pWdcKXbzGN3vNbBDomiDsOpJkwYEG7GkpORHev
         O4OznHuKkqznrY3oquwwRbgqysjRo/GI51+a8bzlqcCgEX+F+GpzBrHntO4sXNTv5s
         6kXgzK9CSG04vwYQeuyJqOTKBHHW4jqSoc9VV99V2SlCNdoc2Clq2R5gb/vfdGUX2i
         D0DPi1V+QTo71zmxwCesUxw4W8KJsybjR2IrNiOir0+ZrmSTjRKtvcTLDvHZNFrjDA
         scSwXOZKZHMNLozuwMHOjrmoomcfY4PytPZm6dAtuz1tpLlFHL27agsoNusrrqGGy7
         tiDCWhyXyf5IQ==
Received: by mail-pf1-f200.google.com with SMTP id i16-20020aa78d90000000b004be3e88d746so256493pfr.13
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:40:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=7ooOvkO5crxAahOT6RtL+CQVZ5kUZYq///EEcKWp2OU=;
        b=M5HUSYCobb1aYl+RbJaaMT3zTUhmgcNXke/u91NOygJs/LTBBfMXyAWogas+ry1AJE
         karIoOwbD6etuCBoXRu37xY0U9UFDZojAoNNFgY6/zW9OmfV5zcNzgpefinPq4Hg+3QI
         Veo2S/8sfbN3vHtoh/S6cordHm25j1/E8KA2ynyU0PMdFBd/5fkVg13bfC5kfQYe/4Jy
         Q1FjN7wf83EzKMXWiJ4GofnNblABPOZxtlrx9lZCs0WncH4yW+24sX5ilZByvEudTvf2
         jAFNcsoaTzTo5BLerd01qXdghZywnArtrV/blEkQl7OjaKGSUJPArApJDWLrq6/BrtRm
         B0IA==
X-Gm-Message-State: AOAM5320CbBBycO5wsg8H+IxSh/vlr2wQrPXbvxvtXV96sUjqDxS1/QS
        XzFCYoiXWbU/HUrEvnwzWib6x5PyG2eUEsB0SOnSJkXR8TySUGlVFfauNI797z7Sx2AMP+N6gdx
        1t/O3zTvwAOnldXgi9mS3QIQQIqRfQqmh9A==
X-Received: by 2002:a62:7c41:0:b0:4e1:3185:cb21 with SMTP id x62-20020a627c41000000b004e13185cb21mr4335304pfc.82.1645123228103;
        Thu, 17 Feb 2022 10:40:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw1j6hRPt8S+AGRaraH0lCVlpuJ00sUt6A84+Z9qKaSDnJRW84LHgbvW3WQnWrn497XT88kXA==
X-Received: by 2002:a62:7c41:0:b0:4e1:3185:cb21 with SMTP id x62-20020a627c41000000b004e13185cb21mr4335291pfc.82.1645123227869;
        Thu, 17 Feb 2022 10:40:27 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id n29sm8929844pgc.10.2022.02.17.10.40.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Feb 2022 10:40:27 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id AC2D960DD1; Thu, 17 Feb 2022 10:40:26 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A4DFB9FAC3;
        Thu, 17 Feb 2022 10:40:26 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] bonding: force carrier update when releasing slave
In-reply-to: <1645021088-38370-1-git-send-email-zhangchangzhong@huawei.com>
References: <1645021088-38370-1-git-send-email-zhangchangzhong@huawei.com>
Comments: In-reply-to Zhang Changzhong <zhangchangzhong@huawei.com>
   message dated "Wed, 16 Feb 2022 22:18:08 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18165.1645123226.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 17 Feb 2022 10:40:26 -0800
Message-ID: <18166.1645123226@famine>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> wrote:

>In __bond_release_one(), bond_set_carrier() is only called when bond
>device has no slave. Therefore, if we remove the up slave from a master
>with two slaves and keep the down slave, the master will remain up.
>
>Fix this by moving bond_set_carrier() out of if (!bond_has_slaves(bond))
>statement.
>
>Reproducer:
>$ insmod bonding.ko mode=3D0 miimon=3D100 max_bonds=3D2
>$ ifconfig bond0 up
>$ ifenslave bond0 eth0 eth1
>$ ifconfig eth0 down
>$ ifenslave -d bond0 eth1
>$ cat /proc/net/bonding/bond0
>
>Fixes: ff59c4563a8d ("[PATCH] bonding: support carrier state for master")
>Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
> drivers/net/bonding/bond_main.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 238b56d..aebeb46 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2379,10 +2379,9 @@ static int __bond_release_one(struct net_device *b=
ond_dev,
> 		bond_select_active_slave(bond);
> 	}
> =

>-	if (!bond_has_slaves(bond)) {
>-		bond_set_carrier(bond);
>+	bond_set_carrier(bond);
>+	if (!bond_has_slaves(bond))
> 		eth_hw_addr_random(bond_dev);
>-	}
> =

> 	unblock_netpoll_tx();
> 	synchronize_rcu();
>-- =

>2.9.5
>
