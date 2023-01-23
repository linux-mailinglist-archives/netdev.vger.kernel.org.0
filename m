Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02FF678B9F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 00:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjAWXCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 18:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjAWXCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 18:02:33 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9883928D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 15:02:10 -0800 (PST)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A448544216
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 23:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1674514895;
        bh=ws4I49gzal9OMpseAqlgTMxeS+K4PzsbLrV3ypXSgOQ=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Q4xmO8ukmC8AAHgsAhD41RKYP7PgXeJ+aiJuFbPIMm+MEnPQZ4f6L5yASzXLqb83s
         0ooo2kDgxaW6bBu/Z+CNDgrRn2XUSkkttxnszZ2QwyVmit0p/uy0Ob9cMO+LfzrySC
         S3OuA90sf3KuDkYXh5gAX3l+D/AQuVBn9oMGTH/o3o3jTZj9RwaI9qMlQl/qJvwh67
         Jogc0xw1WDjjk041PGNb/XEBEpcGqpihPSnhpVwHlNBtbQnaBf6DxfLH8CSr+ayyoc
         vWOVOu/CB0vc5dxAC6z9XxmjCamicYwOr2O2h0eAGw+LsHMgatzSJgqJXG3olYd8tH
         Ij4qQSALrMO7Q==
Received: by mail-pl1-f199.google.com with SMTP id s5-20020a170903214500b00195e3b26848so5825114ple.7
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 15:01:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ws4I49gzal9OMpseAqlgTMxeS+K4PzsbLrV3ypXSgOQ=;
        b=s4BksTAmUl4HFUpWBleoYC64CWfrQw9shmCdGFEvk8lvExsj+UTFyH3rUbM2iq9dAR
         LIkzPZHMoNBU8Ly+PxTdXbQGsOmPLmDZKq4xbI4pRZjZeu+1HfLJyw6dvbfQ7A4bGwAK
         vTZ8uKkoSam/YzDx6Ob5nFFWroB7Cw2nxg75VIPkYVBui0Vn/Qlr7Y1YcpR/IHB4N4q6
         83wxyLH6Lam+fqBe9JGqydEO9vVhUeIsJ3pvhQgXIiPgQzu8lwl2O2ac7qQwpZ5cVvyq
         Exbmn2zbMlW5knf4OkJZ3Jjssg8gA1MWq6kaMebrJer1v3+cFbyZeajYuXuDRtYICvLe
         ccxw==
X-Gm-Message-State: AFqh2kreO7KIjb88lUMaLQiujuC/oAq7Zlvo/SB3CboDDfuSqQMhRoHT
        qWjHgfTDbv98H2hhNzcyUrODdZLXlKzn9hgEl55ZXxDvcvg2PMsIjLiAlGosPHJL3DPt7i4NoXW
        VMGIgnq4TR5ioc5BjaZf2y+nlYdw9f7rj/w==
X-Received: by 2002:a62:ab02:0:b0:58d:982a:f1ed with SMTP id p2-20020a62ab02000000b0058d982af1edmr24276302pff.27.1674514894087;
        Mon, 23 Jan 2023 15:01:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv06FZ22qYDSbiHlRRzdN+ym7mY/jj4yLHKaDeEBtmszT7tu35ck+5fnK0SVdJqtyl59pVEFw==
X-Received: by 2002:a62:ab02:0:b0:58d:982a:f1ed with SMTP id p2-20020a62ab02000000b0058d982af1edmr24276280pff.27.1674514893770;
        Mon, 23 Jan 2023 15:01:33 -0800 (PST)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id w1-20020aa79541000000b00580fb018e4bsm96558pfq.211.2023.01.23.15.01.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Jan 2023 15:01:33 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id D1F24604E3; Mon, 23 Jan 2023 15:01:32 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id C37019FB5C;
        Mon, 23 Jan 2023 15:01:32 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Leon Romanovsky <leon@kernel.org>
cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Corbet <corbet@lwn.net>, oss-drivers@corigine.com,
        linux-doc@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [Intel-wired-lan] [PATCH net-next 09/10] bonding: fill IPsec state validation failure reason
In-reply-to: <d563de401d6fdc1c52959300eebb2bbb27c6c181.1674481435.git.leon@kernel.org>
References: <cover.1674481435.git.leon@kernel.org> <d563de401d6fdc1c52959300eebb2bbb27c6c181.1674481435.git.leon@kernel.org>
Comments: In-reply-to Leon Romanovsky <leon@kernel.org>
   message dated "Mon, 23 Jan 2023 16:00:22 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5063.1674514892.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 23 Jan 2023 15:01:32 -0800
Message-ID: <5064.1674514892@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky <leon@kernel.org> wrote:

>From: Leon Romanovsky <leonro@nvidia.com>
>
>Rely on extack to return failure reason.
>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>Signed-off-by: Leon Romanovsky <leon@kernel.org>
>---
> drivers/net/bonding/bond_main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 686b2a6fd674..00646aa315c3 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -444,7 +444,7 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs,
> 	if (!slave->dev->xfrmdev_ops ||
> 	    !slave->dev->xfrmdev_ops->xdo_dev_state_add ||
> 	    netif_is_bond_master(slave->dev)) {
>-		slave_warn(bond_dev, slave->dev, "Slave does not support ipsec offload=
\n");
>+		NL_SET_ERR_MSG_MOD(extack, "Slave does not support ipsec offload");
> 		rcu_read_unlock();
> 		return -EINVAL;
> 	}

	Why only this one, and not include the other similar
slave_warn() calls in the bond_ipsec_* functions?  That would seem to
make some failures show up in dmesg, and others returned to the caller
via extack.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
