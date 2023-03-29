Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4186CD0C0
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 05:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjC2DhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 23:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjC2DhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 23:37:07 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B7F30E9
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:37:03 -0700 (PDT)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 768093F232
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 03:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680061021;
        bh=7A7ekfj5sQ6iv3lk4aiAagfDfK0Tkfi9yZr2OJnvZnA=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=tN3kNZDPQ5HL9GhHOhsKnlA3BFnPyKXYjswP0d7d6v7ohVCX0waJXU3p55phBLyLH
         dLpn+JoEdgNfyJLYyRZmz8gaYXPASmJWr19ZwqFKPH2U7d2ey31QL8Oh1PQzvOvHVg
         71kpGu6ZcLsD3e9LRndP7SLr1q+5PROY/exiD3xgmNkRU6wvCTMZZx4RCld41Tc1wP
         CtsbwmDVvIwMV6q8NJ8Oc/Tcs35QRm4ZUFYOwsZ0HTx5uuuDxt5fE6B0qE4FRBPM1q
         HMQt0HE2FHgwybaMeg4wETRj8d1wK0exVxSzTwy7m4tNGr+qB7Ci5rbdZcPHCQpqH0
         z47oqOBI6mq9A==
Received: by mail-pl1-f197.google.com with SMTP id kw3-20020a170902f90300b001a274ccf620so134562plb.8
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:37:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680061020;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7A7ekfj5sQ6iv3lk4aiAagfDfK0Tkfi9yZr2OJnvZnA=;
        b=Q5FmpdNaUjf2TQj738yqrIKqv6mGu7NEpzl1X1MZLYL2vmW2qIDMp6296nVK2ev8nu
         tSjaMNKeJ0Q0o5BesnH20glLWMVmZMhxes/BR2rf795WCLNrGeslS4ge8qHxo5ItVZcp
         09vgt+QNBm00Y9Gp5klcJUj1aL7baM6O1VjtDDCEheDvmDPr0EAcCyKko72FlV3W6tlx
         91T7qll2Nx82pc2qGm2WI9xzZwXuJcvGCJBY0ti1NyX0rO3kXe6xJquBxHd+yRr7MR8G
         XLmAInLkSIY4/2WSYucw3pXbZIZ0QwFmhFzmC5xbcf5WObHuuwOHyuICgcla4NZFU4/g
         vfzA==
X-Gm-Message-State: AAQBX9e+IF2nIEIUBfZNjrxeANE6sbACVefsrvNdpvCmPKwyQcsL+cyS
        umUE+0srZctm9nubc9+aOt7dt45ZiAlTqg4Bjy6yWeJhb6GlLRhY/A5wGUUu4anwF204+XQNiC/
        foGU2tFQQyHwwPTS+rsVIcZrFaa0Y0P17GG8eqZyLpw==
X-Received: by 2002:a17:903:41c1:b0:19a:839f:435 with SMTP id u1-20020a17090341c100b0019a839f0435mr1030803ple.3.1680061020114;
        Tue, 28 Mar 2023 20:37:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZwNpRVi3qEQHPCBN74PLckik0mbo8gbXd6/1owgbhrSkYY8egIz6ancjYRKKdr1YsJSS6Iwg==
X-Received: by 2002:a17:903:41c1:b0:19a:839f:435 with SMTP id u1-20020a17090341c100b0019a839f0435mr1030792ple.3.1680061019795;
        Tue, 28 Mar 2023 20:36:59 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id jm18-20020a17090304d200b001888cadf8f6sm21759598plb.49.2023.03.28.20.36.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Mar 2023 20:36:59 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 0D5FB61E6A; Tue, 28 Mar 2023 20:36:59 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 05A5E9FB79;
        Tue, 28 Mar 2023 20:36:59 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] bonding: add software timestamping support
In-reply-to: <20230329031337.3444547-1-liuhangbin@gmail.com>
References: <20230329031337.3444547-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Wed, 29 Mar 2023 11:13:37 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26872.1680061018.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 28 Mar 2023 20:36:58 -0700
Message-ID: <26873.1680061018@famine>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>At present, bonding attempts to obtain the timestamp (ts) information of
>the active slave. However, this feature is only available for mode 1, 5,
>and 6. For other modes, bonding doesn't even provide support for software
>timestamping. To address this issue, let's call ethtool_op_get_ts_info
>when there is no primary active slave. This will enable the use of softwa=
re
>timestamping for the bonding interface.

	If I'm reading the patch below correctly, the actual functional
change here is to additionally set SOF_TIMESTAMPING_TX_SOFTWARE in
so_timestamping for the active-backup, balance-tlb and balance-alb modes
(or whenever there's no active slave, but that's less interesting).  So,
this patch only changes the behavior with regards to transmit
timestamping, correct?

	I'm not objecting to the patch per se, but the description above
does not appear to correctly describe the change.

	-J

>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>---
> drivers/net/bonding/bond_main.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 00646aa315c3..f0856bec59f5 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -5709,9 +5709,7 @@ static int bond_ethtool_get_ts_info(struct net_devi=
ce *bond_dev,
> 		}
> 	}
> =

>-	info->so_timestamping =3D SOF_TIMESTAMPING_RX_SOFTWARE |
>-				SOF_TIMESTAMPING_SOFTWARE;
>-	info->phc_index =3D -1;
>+	ret =3D ethtool_op_get_ts_info(bond_dev, info);
> =

> out:
> 	dev_put(real_dev);
>-- =

>2.38.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
