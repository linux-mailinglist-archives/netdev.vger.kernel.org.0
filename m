Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCE458F3BA
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 23:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiHJVJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 17:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiHJVJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 17:09:48 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EDF7D1FA
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 14:09:47 -0700 (PDT)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id CB6AD3F139
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 21:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660165785;
        bh=CxzHwVKB4MkSWjx3IucGMQ0jDVaIvK8hJ8cizd+65EI=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=nxaoEe3ZjrCir9JBQODQFg8Xvartv4cKdlOTzMbZ0tgtZOVD0sscQFSnyCn6+rXkz
         VG/eI1HKNh0ZRWQ8iPcePZ6ezWuTu/t43n8iKBfi5BUG9mPfHiQ8rcuoCqA0d9s9p5
         pkPS1dBEaxLrJthEFP5j0j3hGYZ2QFyEmhdO20aY9KCfvKCeBfgYDmUfVKug8oxML8
         DMqR5c5hjqFknrBsWjiNSqkD81ajp5E72xR0DFxOgVFjcxq0ISJevLaCliN/RlCIEg
         A9bJMHpyDXQsrO9lBDc3ZttIefoc+mivER1ie1SmnxDNqA3sW85NvBMn2MdgiSMUfF
         tgKrsuFxvO5CA==
Received: by mail-pj1-f71.google.com with SMTP id c5-20020a17090a8d0500b001f559e228f4so1704884pjo.1
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 14:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=CxzHwVKB4MkSWjx3IucGMQ0jDVaIvK8hJ8cizd+65EI=;
        b=Dnq/+ottEDL9R1MsKWiBMXqS5GojxQgDr5FonJJXdwcH0XsHPsb+7+mOkYIn8y5VkJ
         ZPvWgmYcMe/3o448G5AilcEGE3cLENhy8L/laHNhpx+HfzEJaGLjfWhiYpYab9R6Yqd4
         I0gO2v2JOmUd+mhyUNxIcrcW0ic5KlAo8wwj70Xa9EaHhXonQJ6o3pUWIEA7DjyLr7v/
         zaRwSXAHe5B5AOvaZbtj5t4AKsvgp1sOsTOcGIt4Vw4Z735SGdsVvdGLA6bo6kyBP4bi
         wY5KBC8nCMtCeTCq15cEvCQv2GhUIuYc222N8h8FnC+KQ9E+hqF0n/MJ2gEG1FKAZSeh
         OqfA==
X-Gm-Message-State: ACgBeo10ukIGTgvuu4iIndk9tIBRuIGl/WvMVT1QgFqkf15sTmHI2OYh
        dd9b6er/KbCqh8Pd2Hg4KSJtwyBhczRv0E1sZCzXv6lZpkAw/3qa68Ra/8efrcHVuGfmp7NoQfx
        Wo5ngxT3V8nWzGelS0481/HqfbJazmgBLOA==
X-Received: by 2002:a05:6a00:1c53:b0:52d:d673:2241 with SMTP id s19-20020a056a001c5300b0052dd6732241mr28451682pfw.71.1660165784367;
        Wed, 10 Aug 2022 14:09:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4rIkCDNCZg52ppYVfEwuN8eecOggD+c8yXn5icQNlfB3zCkNXbeNI29RIbk82gZn6rJ4TpsA==
X-Received: by 2002:a05:6a00:1c53:b0:52d:d673:2241 with SMTP id s19-20020a056a001c5300b0052dd6732241mr28451663pfw.71.1660165784052;
        Wed, 10 Aug 2022 14:09:44 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id y27-20020aa79e1b000000b0052df34124b4sm2464912pfq.84.2022.08.10.14.09.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Aug 2022 14:09:43 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id D84446119B; Wed, 10 Aug 2022 14:09:42 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id D11429FA79;
        Wed, 10 Aug 2022 14:09:42 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     patchwork-bot+netdevbpf@kernel.org
cc:     Sun Shouxin <sunshouxin@chinatelecom.cn>, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, razor@blackwall.org,
        huyd12@chinatelecom.cn
Subject: Re: [PATCH v2] net:bonding:support balance-alb interface with vlan to bridge
In-reply-to: <166013581540.3703.5149069391225440733.git-patchwork-notify@kernel.org>
References: <20220809062103.31213-1-sunshouxin@chinatelecom.cn> <166013581540.3703.5149069391225440733.git-patchwork-notify@kernel.org>
Comments: In-reply-to patchwork-bot+netdevbpf@kernel.org
   message dated "Wed, 10 Aug 2022 12:50:15 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3916.1660165782.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 10 Aug 2022 14:09:42 -0700
Message-ID: <3917.1660165782@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patchwork-bot+netdevbpf@kernel.org wrote:

>Hello:
>
>This patch was applied to netdev/net.git (master)
>by David S. Miller <davem@davemloft.net>:
>
>On Mon,  8 Aug 2022 23:21:03 -0700 you wrote:
>> In my test, balance-alb bonding with two slaves eth0 and eth1,
>> and then Bond0.150 is created with vlan id attached bond0.
>> After adding bond0.150 into one linux bridge, I noted that Bond0,
>> bond0.150 and  bridge were assigned to the same MAC as eth0.
>> Once bond0.150 receives a packet whose dest IP is bridge's
>> and dest MAC is eth1's, the linux bridge will not match
>> eth1's MAC entry in FDB, and not handle it as expected.
>> The patch fix the issue, and diagram as below:
>> =

>> [...]
>
>Here is the summary with links:
>  - [v2] net:bonding:support balance-alb interface with vlan to bridge
>    https://git.kernel.org/netdev/net/c/d5410ac7b0ba
>
>You are awesome, thank you!

	There looks to be a reference count leak in the existing patch
(ip_dev_find acquires a reference that is not released).  I.e., it needs
something like:

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb=
.c
index 60cb9a0225aa..b9dbad3a8af8 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -668,8 +668,11 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb=
, struct bonding *bond)
 =

 	dev =3D ip_dev_find(dev_net(bond->dev), arp->ip_src);
 	if (dev) {
-		if (netif_is_bridge_master(dev))
+		if (netif_is_bridge_master(dev)) {
+			dev_put(dev);
 			return NULL;
+		}
+		dev_put(dev);
 	}
 =

 	if (arp->op_code =3D=3D htons(ARPOP_REPLY)) {

	I haven't tested this, but it seems correct.  Comments?

	I'll create a formal submission here in a bit.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
