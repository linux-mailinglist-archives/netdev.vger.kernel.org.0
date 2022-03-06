Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9964CED34
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 19:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiCFSbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 13:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbiCFSbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 13:31:53 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7346C21E1C
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 10:31:00 -0800 (PST)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 224363F616
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 18:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646591454;
        bh=TA8KjR6S17gXFGKtkIb2JMGZEDPFAMBrDvNRC4af/Ko=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=uCQu9DwxFebbTlhXAnenuN23+NppyFNvBQfZ87ZVeRHQSdo59Wcl0W9ocFiMaJ+bl
         ymIY7XrmM+zJVHcx28YwKxtWyKuQl80EN1+z+WoVupt0oxkSHww6CDKfnw8XJ9H1E5
         93Yq/xILuT7vh00BXnUoqQ0dSUmKe5MVSzJnrmUv0Z3nl5E3YhuE8DEc2j8cGSPorD
         R3hnsUQXxAAvnrk7UXLZSXRuydPrgFyud/qwrjrPAgfr9qnkuhu4Apy7ImcDqXt4I5
         y/PyOMcvpwu2hZsI0OoKE6vukn146RWzXMKV8tMFeYCWDTs3/Nfo+4YjysVT+WEh/s
         tRFKiyBVdY3Fg==
Received: by mail-pf1-f197.google.com with SMTP id n135-20020a628f8d000000b004e16d5bdcdbso9007656pfd.20
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 10:30:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=TA8KjR6S17gXFGKtkIb2JMGZEDPFAMBrDvNRC4af/Ko=;
        b=AG+XDl3J4yCPvEOR95WiteVK4Ey5bo1Ilpom5qaWkKFxalA1rhF1XLP1nlw/fjaE81
         yWh1tAbGu7aER/peABZWDlDfLuKRtlYnPJt6NcoFCShV7RU6SmVlJHVFheIHtF8oigWZ
         BIl3YcYJiOPwN0w1UzsP6SZQhKnMt+U9cBvElRJbNrIvDgtmlt0kIrzyrimEpWyhRwHa
         e9Pa0zZ3N5EIVOtDYUHPp/w4D/0K0oLRX/xBzU57o+WkGxBPzbqbIumo8BO205X9E5pF
         0tHdY9B3TWdFEY8Rb72FMiq4VT3KkV2Vq7GrXUdkXqiRnyesj16NapkjABmmiK1eBrft
         vAvg==
X-Gm-Message-State: AOAM5333qMErMYZDClBLbG3HT/AncPIeKCaSOH4hcyF47FEnuH2xV2EZ
        dU2eh2/cECVcpj8EgX1DsPmxVd4hBw8f0WJ3A2H9Hu6Wila4kVLDa13th6al9VFlo28G2Ily2gG
        8B8V+Ptz2ckZ+hsAUUTic5336tjWAhrO6iQ==
X-Received: by 2002:a63:1651:0:b0:342:b566:57c4 with SMTP id 17-20020a631651000000b00342b56657c4mr6944386pgw.258.1646591452551;
        Sun, 06 Mar 2022 10:30:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQi8U+TTTetLTi4EWqCjwCcAlhxeEPHIymhU/wDHDR2O7G9m5BX8Y+01rkdeWUn6VVZa4lUg==
X-Received: by 2002:a63:1651:0:b0:342:b566:57c4 with SMTP id 17-20020a631651000000b00342b56657c4mr6944366pgw.258.1646591452194;
        Sun, 06 Mar 2022 10:30:52 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id t8-20020a6549c8000000b00372eb3a7fb3sm9566731pgs.92.2022.03.06.10.30.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Mar 2022 10:30:51 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id A8A2960DD1; Sun,  6 Mar 2022 10:30:50 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A0E109FAC3;
        Sun,  6 Mar 2022 10:30:50 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Lianjie Zhang <zhanglianjie@uniontech.com>
cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Veaceslav Falico <vfalico@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding: helper macro __ATTR_RO to make code more clear
In-reply-to: <20220306082808.85844-1-zhanglianjie@uniontech.com>
References: <20220306082808.85844-1-zhanglianjie@uniontech.com>
Comments: In-reply-to Lianjie Zhang <zhanglianjie@uniontech.com>
   message dated "Sun, 06 Mar 2022 16:28:08 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24907.1646591450.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Sun, 06 Mar 2022 10:30:50 -0800
Message-ID: <24908.1646591450@famine>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lianjie Zhang <zhanglianjie@uniontech.com> wrote:

>Signed-off-by: Lianjie Zhang <zhanglianjie@uniontech.com>

	I'm ok with the change, but this needs a sentence or two in the
commit log message to explain what's going on, so that future readers of
the log don't have to read the diff to figure out why this change makes
sense.

	-J

>diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding=
/bond_sysfs_slave.c
>index 6a6cdd0bb258..69b0a3751dff 100644
>--- a/drivers/net/bonding/bond_sysfs_slave.c
>+++ b/drivers/net/bonding/bond_sysfs_slave.c
>@@ -15,14 +15,8 @@ struct slave_attribute {
> 	ssize_t (*show)(struct slave *, char *);
> };
>
>-#define SLAVE_ATTR(_name, _mode, _show)				\
>-const struct slave_attribute slave_attr_##_name =3D {		\
>-	.attr =3D {.name =3D __stringify(_name),			\
>-		 .mode =3D _mode },				\
>-	.show	=3D _show,					\
>-};
> #define SLAVE_ATTR_RO(_name)					\
>-	SLAVE_ATTR(_name, 0444, _name##_show)
>+const struct slave_attribute slave_attr_##_name =3D __ATTR_RO(_name)
>
> static ssize_t state_show(struct slave *slave, char *buf)
> {
>--
>2.20.1

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
