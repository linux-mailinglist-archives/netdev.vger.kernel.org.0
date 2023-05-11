Return-Path: <netdev+bounces-1982-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1076FFD6E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:44:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1535281738
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B431B18C17;
	Thu, 11 May 2023 23:44:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB6F8F7C
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:44:06 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63025FD2
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:44:04 -0700 (PDT)
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E65263F4A8
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1683848641;
	bh=IjXsRvfc2ev2tBmQbawqXKBxHJzqgNk7jmV/0D9IEMI=;
	h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
	 Content-Type:Date:Message-ID;
	b=N0x94hl8nWtn3EuM1EmFKEUGpo2XoGDMStmAWofaWPc5YfnPVRLGLTU4D48QKsLfu
	 Iml6bfAfARP32/7e9VXm8eJMaCOzFpGoYJLCbH9QymNBdi1liFjOFtXriwsjA9a8Dy
	 jp6043bVBOeOm5Qm0Dhr8sCCNdCFsxjUd3/P/oZfqFrr09uS7lpgf7pFgBJhIOsvvr
	 he8rSSw7AC48TM9Op2esJCUR4+b9+BF1OuwA/BJcvy3IMYQQgX9L9j8bkBlFuChr7S
	 FUKIHb4tB0+7T105bemsggbEl6W0sJ5tS72IiTpWzfr+iqMLM9B5dIhRxoXAsr3KWW
	 FB/PMWfJeuh3w==
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-643fdfb437aso31830838b3a.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:44:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848639; x=1686440639;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjXsRvfc2ev2tBmQbawqXKBxHJzqgNk7jmV/0D9IEMI=;
        b=B6pzxaz/cxN0sopZaJkoSv8+ycKc8uIhNlf+u9yyS+M99f0vN9ReUVls4v4wjra9+a
         PEG+dBI99/pJXUoGQ5uCOdiLYOr0oSSMT7HZurcrvWVeG76MO2g2wK8oCvPTO34Y6L1l
         EP/Twif/R8BZO/RBfxcC/S0+HSySdXz7P4olPtL/WFSZlJwfQ+hOU0OavLkXZfoY+h1C
         no5Zy7qFdda3dYBMoq5+77sKvctuwZkLqjO2+GLUbMB04ngd/5ZrBD30efF1YKPfoWVG
         1wAQP8C8vTq0aY1VlFPSRGCg5P0u13CnULgI0ILirzbLU3BSjFZT0AdkVV0APCwk63cO
         ro4w==
X-Gm-Message-State: AC+VfDyEbtl2/Mlwp6kTA2+zBIbzMVKQ5n19Oy108mGr0qdNab5wetmv
	DZKIwWVThhsBO9abzTK8zx4ZCjDAFBn7QJIrn0+0qsvSr+vmltIhKOLCN3C1J4uVxQR9NkYY8b3
	FmkBAJpj84f+rI0foHgqhZMvVrp0soWRlpA==
X-Received: by 2002:a17:90a:34c2:b0:247:1605:6e1a with SMTP id m2-20020a17090a34c200b0024716056e1amr27311505pjf.0.1683848639046;
        Thu, 11 May 2023 16:43:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7u7Hyjw99jr1rbNn0b+KhrWO3D8YIGkMRkM4PohyWr1T6zBSciMVKOvGKUnsPVDZtTo21Gig==
X-Received: by 2002:a17:90a:34c2:b0:247:1605:6e1a with SMTP id m2-20020a17090a34c200b0024716056e1amr27311491pjf.0.1683848638701;
        Thu, 11 May 2023 16:43:58 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id g24-20020a17090a579800b0024dee5cbe29sm20449613pji.27.2023.05.11.16.43.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 May 2023 16:43:58 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
	id D719D5FEAC; Thu, 11 May 2023 16:43:57 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
	by famine.localdomain (Postfix) with ESMTP id D1B8E9FAA4;
	Thu, 11 May 2023 16:43:57 -0700 (PDT)
From: Jay Vosburgh <jay.vosburgh@canonical.com>
To: Simon Horman <horms@kernel.org>
cc: Jakub Kicinski <kuba@kernel.org>,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    Andy Gospodarek <andy@greyhouse.net>,
    Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: Always assign be16 value to vlan_proto
In-reply-to: <20230420-bonding-be-vlan-proto-v2-1-9f594fabdbd9@kernel.org>
References: <20230420-bonding-be-vlan-proto-v2-1-9f594fabdbd9@kernel.org>
Comments: In-reply-to Simon Horman <horms@kernel.org>
   message dated "Thu, 11 May 2023 17:07:12 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8714.1683848637.1@famine>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 May 2023 16:43:57 -0700
Message-ID: <8715.1683848637@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Simon Horman <horms@kernel.org> wrote:

>The type of the vlan_proto field is __be16.
>And most users of the field use it as such.
>
>In the case of setting or testing the field for the special VLAN_N_VID
>value, host byte order is used. Which seems incorrect.
>
>It also seems somewhat odd to store a VLAN ID value in a field that is
>otherwise used to store Ether types.
>
>Address this issue by defining BOND_VLAN_PROTO_NONE, a big endian value.
>0xffff was chosen somewhat arbitrarily. What is important is that it
>doesn't overlap with any valid VLAN Ether types.

As I think you mentioned, 0xffff is marked as a reserved ethertype.

>I don't believe the problems described above are a bug because
>VLAN_N_VID in both little-endian and big-endian byte order does not
>conflict with any supported VLAN Ether types in big-endian byte order.
>
>Reported by sparse as:
>
> .../bond_main.c:2857:26: warning: restricted __be16 degrades to integer
> .../bond_main.c:2863:20: warning: restricted __be16 degrades to integer
> .../bond_main.c:2939:40: warning: incorrect type in assignment (differen=
t base types)
> .../bond_main.c:2939:40:    expected restricted __be16 [usertype] vlan_p=
roto
> .../bond_main.c:2939:40:    got int
>
>No functional changes intended.
>Compile tested only.
>
>Signed-off-by: Simon Horman <horms@kernel.org>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

>---
>Changes in v2:
>- Decribe Ether Type aspect of problem in patch description
>- Use an Ether Type rather than VID valie as sential
>- Link to v1: https://lore.kernel.org/r/20230420-bonding-be-vlan-proto-v1=
-1-754399f51d01@kernel.org
>---
> drivers/net/bonding/bond_main.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 3fed888629f7..ebf61c19dcef 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2871,6 +2871,8 @@ static bool bond_has_this_ip(struct bonding *bond, =
__be32 ip)
> 	return ret;
> }
> =

>+#define BOND_VLAN_PROTO_NONE cpu_to_be16(0xffff)
>+
> static bool bond_handle_vlan(struct slave *slave, struct bond_vlan_tag *=
tags,
> 			     struct sk_buff *skb)
> {
>@@ -2878,13 +2880,13 @@ static bool bond_handle_vlan(struct slave *slave,=
 struct bond_vlan_tag *tags,
> 	struct net_device *slave_dev =3D slave->dev;
> 	struct bond_vlan_tag *outer_tag =3D tags;
> =

>-	if (!tags || tags->vlan_proto =3D=3D VLAN_N_VID)
>+	if (!tags || tags->vlan_proto =3D=3D BOND_VLAN_PROTO_NONE)
> 		return true;
> =

> 	tags++;
> =

> 	/* Go through all the tags backwards and add them to the packet */
>-	while (tags->vlan_proto !=3D VLAN_N_VID) {
>+	while (tags->vlan_proto !=3D BOND_VLAN_PROTO_NONE) {
> 		if (!tags->vlan_id) {
> 			tags++;
> 			continue;
>@@ -2960,7 +2962,7 @@ struct bond_vlan_tag *bond_verify_device_path(struc=
t net_device *start_dev,
> 		tags =3D kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
> 		if (!tags)
> 			return ERR_PTR(-ENOMEM);
>-		tags[level].vlan_proto =3D VLAN_N_VID;
>+		tags[level].vlan_proto =3D BOND_VLAN_PROTO_NONE;
> 		return tags;
> 	}
> =

>
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

