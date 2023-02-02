Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6926886E8
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbjBBSnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbjBBSnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:43:14 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BB7113C0
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:42:44 -0800 (PST)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 020D841AE4
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 18:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675363300;
        bh=5/sqWycvEAPjqsnTBo2U8a25upaJIykotUumaHLpuvI=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Jp0SLAwAjgWlgrMPH+V08scSUlhMWZhTGvHYNSIbXaetUh7lvWIc1MhmGvELSkuEB
         QaSYL7Msya+q+q5GOjqSu11oStJJg598XFy4/e8idIXt0+GSsBSvuw8PV9HRfY+0Hr
         IUsqPQnDK3p6jgmMY7lwfFJRYsuPwYPd8r9zpjfEPHEGTsKvNOu5F+dR98bWbI8adf
         nFCG6+vzKNQzOVxybiwEa7DQyhLhT8CbcfNl8wHbuH6LX9CgpEmbxebjSjaoHr9SqK
         G4IfBuJ3JF6URMLHPTUoaSe0p8sSANtyAeiobQx5/TxOVTs7jVAFHiJNGI1LxgRWYH
         Nn8I2sxlUDhjw==
Received: by mail-pg1-f197.google.com with SMTP id t138-20020a635f90000000b004f1ab9ee9ecso1388652pgb.16
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 10:41:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5/sqWycvEAPjqsnTBo2U8a25upaJIykotUumaHLpuvI=;
        b=5Gu/qz6NIqQIB1cLHeGA69Ll/ylFAjihnqhofWeVVAxOsqbYhMRRXTFr53aFQHV++l
         q4ztSXjcH1ZC9lVmbp8V8xv3KN1IbPJy7gmwoHrS/JHoI3ggfDQFPwqpEXfW0UzsseNj
         5aSJ2L0mXx+pANroTq0R8jG+oFXh9tTKP0hYrarr1fxzXHuCrHU7+g2vcY0iEWEF12yY
         iDR0tZTLM/oknrtRJpwdcl7MdhXwnqHGqkO/5s5OTYvMmr7buZ0BniB7+er3kt6EjN6k
         dPB9Fo0ryMmhNR8qBkXfyMhFWfzRzANPvGOpEaUd9xlKcs3bqXFWn3xs5Wa3YLU/AETX
         nQqg==
X-Gm-Message-State: AO0yUKXKlkKRU+fPYsrAWf0XE9VzbgAOw1c5KnaETnxWOt89GTyQDKI4
        zpAWSoHxB/iLAbAablYSyB6HTnQtlGllxToL3NWJjv5N2AMYT2uIiBHtcK1YV7a9wO/K6q6FwCG
        lmkCSIitRKgFThNildqOxqPCTh4WHWe019A==
X-Received: by 2002:a17:90b:1d82:b0:22c:169b:ec44 with SMTP id pf2-20020a17090b1d8200b0022c169bec44mr7704073pjb.31.1675363298635;
        Thu, 02 Feb 2023 10:41:38 -0800 (PST)
X-Google-Smtp-Source: AK7set/iID5T6tsp9eWmtXNZbOFdFo2GTi9PEDvqAxvwzPCco64WaniWJlyIzIuuMqZESDriKrnLfQ==
X-Received: by 2002:a17:90b:1d82:b0:22c:169b:ec44 with SMTP id pf2-20020a17090b1d8200b0022c169bec44mr7704065pjb.31.1675363298369;
        Thu, 02 Feb 2023 10:41:38 -0800 (PST)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090aa58100b00229d7f2abd4sm163842pjq.54.2023.02.02.10.41.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Feb 2023 10:41:37 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 6FD985FEAC; Thu,  2 Feb 2023 10:41:37 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 680F29FB5C;
        Thu,  2 Feb 2023 10:41:37 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
cc:     gregkh@linuxfoundation.org, rafael@kernel.org, vfalico@gmail.com,
        andy@greyhouse.net, vireshk@kernel.org, nm@ti.com,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] bonding: fix error checking in bond_debug_reregister()
In-reply-to: <20230202093256.32458-3-zhengqi.arch@bytedance.com>
References: <20230202093256.32458-1-zhengqi.arch@bytedance.com> <20230202093256.32458-3-zhengqi.arch@bytedance.com>
Comments: In-reply-to Qi Zheng <zhengqi.arch@bytedance.com>
   message dated "Thu, 02 Feb 2023 17:32:55 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20120.1675363297.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 02 Feb 2023 10:41:37 -0800
Message-ID: <20121.1675363297@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qi Zheng <zhengqi.arch@bytedance.com> wrote:

>Since commit ff9fb72bc077 ("debugfs: return error values,
>not NULL") changed return value of debugfs_rename() in
>error cases from %NULL to %ERR_PTR(-ERROR), we should
>also check error values instead of NULL.
>
>Fixes: ff9fb72bc077 ("debugfs: return error values, not NULL")
>Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
> drivers/net/bonding/bond_debugfs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bon=
d_debugfs.c
>index 4f9b4a18c74c..594094526648 100644
>--- a/drivers/net/bonding/bond_debugfs.c
>+++ b/drivers/net/bonding/bond_debugfs.c
>@@ -76,7 +76,7 @@ void bond_debug_reregister(struct bonding *bond)
> =

> 	d =3D debugfs_rename(bonding_debug_root, bond->debug_dir,
> 			   bonding_debug_root, bond->dev->name);
>-	if (d) {
>+	if (!IS_ERR(d)) {
> 		bond->debug_dir =3D d;
> 	} else {
> 		netdev_warn(bond->dev, "failed to reregister, so just unregister old o=
ne\n");
>-- =

>2.20.1
>
