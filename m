Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36319595CE6
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbiHPNLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235667AbiHPNLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:11:51 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D859FB4439
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:11:46 -0700 (PDT)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id DF8E4401B9
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 13:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660655504;
        bh=eHhfrWU8RHvyLZDM+CLnwGals98f4PWGdfD845uzJd4=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=euIRzmNrbSp1qqaxRKnj8/6UtT7gACGn+lT1I+r+mJUP/CKuSgYtzQYZlPY/n2Jt2
         1KwFr+bd3nf/SWTND/SFnWS4/UuyGKU4AvzlezrsNCg9v6d6tmZil50/BVkurQztV2
         3SPa/moNGQdOqoBC/0ShjnteeJOEaMj7K80pOxgDdePWLdJBlK9eHZQch0iLW+xb6+
         /6SQwF26lMmywW2IH+JIywHWLdUiwQ8T5O7NtTMtjVjkSYOv6qFnx4O0lt5qKRu9Gw
         aPcHqgVrz/MNNBaRmaNKEy5Yew31hsXQr0ho+w0529GlX+yL7yA1X/P8FCSLSbel56
         56uMCCiGzeA8g==
Received: by mail-pf1-f197.google.com with SMTP id c142-20020a621c94000000b005324991c5b8so3774584pfc.15
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:11:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-id:mime-version:comments:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=eHhfrWU8RHvyLZDM+CLnwGals98f4PWGdfD845uzJd4=;
        b=DFTz91v7mjJa4juqHAPVpeFcD+PEwrj0J2mKyVQG2kIHsVqaHn997AJ0IDpxa3iF3B
         dM3CD9To3SeZUrzTBrQXxeazbt/prGevVBHAiuQehlLH7YMM2NKNlVrWlUz7megd8i8p
         W6Wn+SZ+qAfC6yKrxxpx4uOdwmW5XgctgyGP5A+PXmpCwAFo10csNq4uDIFtyjn02ErP
         J+wUa1/5h39FTZLUnaQEg8k5hNR+fmaUU9c+rh0b1XwYIGCnlwDo5lVxP70doUH+lmin
         kYDLkErR6nE7CFV0YRmJxm5daHmfoafkfwCLI+s0PLYkfZUXA8NJj4EdvCVF6ZwH67uP
         ytvA==
X-Gm-Message-State: ACgBeo1uie2nQxVTnhL2ajae5AVVyNRwVrR9KAV+hQ9EJi6gDuklDGMT
        uxk6VapurZpNQeDBqeo0URQ8k9Ie/Ilz0V8xWnV+ndX4HDIvQMFT3qtwMCrYn8D6E60qS+h9/Mi
        T96D98h6Nr1bqcqXFAwTYKnd4kNI7OO3ULw==
X-Received: by 2002:a63:81c3:0:b0:41e:17df:aed0 with SMTP id t186-20020a6381c3000000b0041e17dfaed0mr18004793pgd.395.1660655503471;
        Tue, 16 Aug 2022 06:11:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6qWaWGJQfgQuLFWYHsdjajgOYDRj/I3G+VvmwGS+VfnZp1QsTgdGSoYDMIqkN1xTCLe9kmcA==
X-Received: by 2002:a63:81c3:0:b0:41e:17df:aed0 with SMTP id t186-20020a6381c3000000b0041e17dfaed0mr18004768pgd.395.1660655503073;
        Tue, 16 Aug 2022 06:11:43 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902ce8200b0015e8d4eb1d7sm9008094plg.33.2022.08.16.06.11.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Aug 2022 06:11:42 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id ED18561193; Tue, 16 Aug 2022 06:11:41 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id E7B929FA79;
        Tue, 16 Aug 2022 06:11:41 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     netdev@vger.kernel.org, liuhangbin@gmail.com,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] bonding: 802.3ad: fix no transmission of LACPDUs
In-reply-to: <0639f1e3d366c5098d561a947fd416fa5277e7f4.1660572700.git.jtoppins@redhat.com>
References: <cover.1660572700.git.jtoppins@redhat.com> <0639f1e3d366c5098d561a947fd416fa5277e7f4.1660572700.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Mon, 15 Aug 2022 11:08:35 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16999.1660655501.1@famine>
Date:   Tue, 16 Aug 2022 06:11:41 -0700
Message-ID: <17000.1660655501@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>This is caused by the global variable ad_ticks_per_sec being zero as
>demonstrated by the reproducer script discussed below. This causes
>all timer values in __ad_timer_to_ticks to be zero, resulting
>in the periodic timer to never fire.
>
>To reproduce:
>Run the script in
>`tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh` which
>puts bonding into a state where it never transmits LACPDUs.
>
>line 44: ip link add fbond type bond mode 4 miimon 200 \
>            xmit_hash_policy 1 ad_actor_sys_prio 65535 lacp_rate fast
>setting bond param: ad_actor_sys_prio
>given:
>    params.ad_actor_system = 0
>call stack:
>    bond_option_ad_actor_sys_prio()
>    -> bond_3ad_update_ad_actor_settings()
>       -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
>       -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
>            params.ad_actor_system == 0
>results:
>     ad.system.sys_mac_addr = bond->dev->dev_addr
>
>line 48: ip link set fbond address 52:54:00:3B:7C:A6
>setting bond MAC addr
>call stack:
>    bond->dev->dev_addr = new_mac
>
>line 52: ip link set fbond type bond ad_actor_sys_prio 65535
>setting bond param: ad_actor_sys_prio
>given:
>    params.ad_actor_system = 0
>call stack:
>    bond_option_ad_actor_sys_prio()
>    -> bond_3ad_update_ad_actor_settings()
>       -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
>       -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
>            params.ad_actor_system == 0
>results:
>     ad.system.sys_mac_addr = bond->dev->dev_addr
>
>line 60: ip link set veth1-bond down master fbond
>given:
>    params.ad_actor_system = 0
>    params.mode = BOND_MODE_8023AD
>    ad.system.sys_mac_addr == bond->dev->dev_addr
>call stack:
>    bond_enslave
>    -> bond_3ad_initialize(); because first slave
>       -> if ad.system.sys_mac_addr != bond->dev->dev_addr
>          return
>results:
>     Nothing is run in bond_3ad_initialize() because dev_add equals
>     sys_mac_addr leaving the global ad_ticks_per_sec zero as it is
>     never initialized anywhere else.
>
>Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>---
>
>Notes:
>    v2:
>     * split this fix from the reproducer
>    v3:
>     * rebased to latest net/master
>
> drivers/net/bonding/bond_3ad.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>index d7fb33c078e8..957d30db6f95 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -84,7 +84,8 @@ enum ad_link_speed_type {
> static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
> 	0, 0, 0, 0, 0, 0
> };
>-static u16 ad_ticks_per_sec;
>+
>+static u16 ad_ticks_per_sec = 1000 / AD_TIMER_INTERVAL;
> static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;

	I still feel like this is kind of a hack, as it's not really
fixing bond_3ad_initialize to actually work (which is the real problem
as I understand it).  If it's ok to skip all that for this case, then
why do we ever need to call bond_3ad_initialize?

	-J

> static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
>-- 
>2.31.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
