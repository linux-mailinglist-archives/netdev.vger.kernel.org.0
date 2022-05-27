Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC6053692F
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 01:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbiE0X2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 19:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiE0X2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 19:28:07 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810299344F
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 16:28:06 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E72D23FBF6
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 23:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1653694083;
        bh=hBUEvppxPawVIssNIcuHNZaHyNY0rY2RrRmZ9JuFW6c=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=fpGKEZuwh/PXjOAtIBgW3yCoNmMDr9M4sP84YSticktCqCLuZynPlLkSFkwb7bUMp
         046VZf81TIRDPUKK4ZMcMI9ToSGx4YRvfzgphb4I928BIKDu9rqzGYnuwo2bNwmK0v
         uaScWTzqDhsl70tOGir4veEAhF0WZDIHddFpuFWKws3Vl3miyj4WW9WHe4dklzT5aS
         Y6XlZadPJeFSS0geWVR4dmIBeqWPY3iGJ+duWR7U1EHC4gruOM/oP/I6WOtiVvHT4E
         fvdWoShRvuRk/4RCreG9xUMkGq9h38eY1k35Kny1kmL/jDiUlSLYT1o/tvrP9C5F6B
         HqSCeYqMd1Y3w==
Received: by mail-pj1-f70.google.com with SMTP id pg2-20020a17090b1e0200b001e27c731924so1892343pjb.7
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 16:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=hBUEvppxPawVIssNIcuHNZaHyNY0rY2RrRmZ9JuFW6c=;
        b=bFn/d4zNgVoUn3AICMGdWQMcgVIilmJnqlqTbgVbPKmC0/R/LHV5YE8E97Ba0XJZai
         YMBYEu9K3/n5btIcC+oyeMUqSrG3IdBOvGtTAAZq8B5cpYjCAouNmBzfxYtkqNpye8m6
         SdSPGT8B74bjFfjU8/1CD2mNKfdGJx+bDV4kiiVKy0I/22vSYHwhYLQVWa7XvZhrUSXu
         HJJKkrJGHXyMke6UMBnRvZXcNoElzNC7d6MohXNquLYIJCUazcRDsJ0u6cQurokOU+ZK
         AIcA6P54GuOg7PyhXZRCBILlwXvGqvNIWzWL+vJ8vmiGFGjnrRCkhBr2rorgmc3eWLqG
         NwFQ==
X-Gm-Message-State: AOAM533XRXHVDXcl02/Ey+BOvIYTG1Phjp3NZNJ7XIDyFZCCu1ZpgOou
        viNsXdLCHkauZv0lppzez8kpXkQZFEWqflaUJckwymx5YuFllpv6M5NxoOUsFiX927RLCXBuQhy
        LmvkSF7cKLaXu971rVdPai1Zt4lAdxP+yGA==
X-Received: by 2002:a05:6a00:1494:b0:518:b738:5876 with SMTP id v20-20020a056a00149400b00518b7385876mr24090220pfu.58.1653694082375;
        Fri, 27 May 2022 16:28:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx85h+weBo8Q2ces+iL3RHc5RyeOp2Jm65ZX3hN7kdbKQ0Jid2gBdnI4YFAqLhxxSRF6RE1KA==
X-Received: by 2002:a05:6a00:1494:b0:518:b738:5876 with SMTP id v20-20020a056a00149400b00518b7385876mr24090195pfu.58.1653694082134;
        Fri, 27 May 2022 16:28:02 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id n15-20020a170902968f00b001617ffc6d25sm2605525plp.19.2022.05.27.16.28.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 May 2022 16:28:01 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 53F606093D; Fri, 27 May 2022 16:28:01 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 4A01EA0B20;
        Fri, 27 May 2022 16:28:01 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] bonding: NS target should accept link local address
In-reply-to: <20220527064439.1837544-1-liuhangbin@gmail.com>
References: <20220527064439.1837544-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Fri, 27 May 2022 14:44:39 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18369.1653694081.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 27 May 2022 16:28:01 -0700
Message-ID: <18370.1653694081@famine>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>When setting bond NS target, we use bond_is_ip6_target_ok() to check
>if the address valid. The link local address was wrongly rejected in
>bond_changelink(), as most time the user just set the ARP/NS target to
>gateway, while the IPv6 gateway is always a link local address when user
>set up interface via SLAAC.
>
>So remove the link local addr check when setting bond NS target.
>
>Fixes: 129e3c1bab24 ("bonding: add new option ns_ip6_target")
>Reported-by: Li Liang <liali@redhat.com>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
> drivers/net/bonding/bond_netlink.c | 5 -----
> 1 file changed, 5 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bon=
d_netlink.c
>index f427fa1737c7..6f404f9c34e3 100644
>--- a/drivers/net/bonding/bond_netlink.c
>+++ b/drivers/net/bonding/bond_netlink.c
>@@ -290,11 +290,6 @@ static int bond_changelink(struct net_device *bond_d=
ev, struct nlattr *tb[],
> =

> 			addr6 =3D nla_get_in6_addr(attr);
> =

>-			if (ipv6_addr_type(&addr6) & IPV6_ADDR_LINKLOCAL) {
>-				NL_SET_ERR_MSG(extack, "Invalid IPv6 addr6");
>-				return -EINVAL;
>-			}
>-
> 			bond_opt_initextra(&newval, &addr6, sizeof(addr6));
> 			err =3D __bond_opt_set(bond, BOND_OPT_NS_TARGETS,
> 					     &newval);
>-- =

>2.35.1
>
