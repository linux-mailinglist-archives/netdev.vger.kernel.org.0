Return-Path: <netdev+bounces-3025-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6183F705172
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A34C8281571
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5C928C13;
	Tue, 16 May 2023 15:03:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1A534CEC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:03:14 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F117690
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:03:06 -0700 (PDT)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 69FF13F200
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684249380;
	bh=zmoYM7JBHbKSv6t2frRQHd87oRp2fYbHQIOlsbVAY7M=;
	h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
	 Content-Type:Date:Message-ID;
	b=OajQ1Fc9pncCjYTWOtxTfO+a3sAf3j3NEmAs1Hzlv6XhHuF/5D2NNEfbKlC5B2YY4
	 Xlmz4CvqgZNhiMgZ1u2lFCfjr/q127MCPUiz8VjdV3+N5VXuH/L5EgcPOsRcQsAYl/
	 3UinHwD4vuEYSvpQkgEiLzpBZ2FmxyRZ3ASFUfMzxfAXnSTSZ6rUZYKftFwYm85Ayu
	 IvaVn/G2l7QmIreKbDj+T6ITeoKnfxpSNjQ/e76iVMl2Iez578IzB+rlqH5jL5h/9G
	 RozozRVkutJvSCu3/QYu8m1xU8+G9f2pCs3Meb7RtybrwdHmkynbx7OEUG/NjwgtqW
	 VEGKs83i9uoaw==
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-250109c729eso7780627a91.3
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684249378; x=1686841378;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zmoYM7JBHbKSv6t2frRQHd87oRp2fYbHQIOlsbVAY7M=;
        b=J3kCFUjI/b7v/Qzdx1EL8Cs10Wvls6PEKKvMXynpsgACYHQMi4gXqCN3V4ShenDiWn
         pYkLMyGBFwAUbKymaAkgbOZyDWLO2Ay93dcOdmgh4zUVmGfOYwe7oQakEdcDNtnh0T+E
         1G+ilAl014YkWco49eAvJpYeIb392iAi0D+sd8W2+GsH96zkjYU4hzN6VJ5maq6ad6n4
         Ti/RRSnHij0wXQggJGiYr2DOx6QW5VbC7wBt/gAXX43NQZKvLTJoWHpqYD/vsmcFnPek
         2gc9tjgq76BO5JByISypujpxYu2RAmjnhfnoPSxnLZse0WFHjXnggI26Pl2hWJReLmfC
         E7aA==
X-Gm-Message-State: AC+VfDz0W9IZDaqquSnbgM9qFN7+1vE/+DhnmVjoKZtLgaFOjjqG8lh+
	AOPCA2HpOpREZ6A+sSzOCAgj8z4mUv/1iSsJOpI/xSgpf549O9YIoa49a+UYfkIVF6MueiT3fzo
	retTykUgnuTTHqrbYjU7Y4exvamFCso07Pw==
X-Received: by 2002:a17:90a:f3d5:b0:24d:fb8f:6c16 with SMTP id ha21-20020a17090af3d500b0024dfb8f6c16mr38458892pjb.16.1684249378572;
        Tue, 16 May 2023 08:02:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7GJTtlEnzG1c1DQ9t3FzDRb7PgPVH2EOTVSNFYsMlfd42J10qwbY+HeL8jBEhQek2vxoDtmQ==
X-Received: by 2002:a17:90a:f3d5:b0:24d:fb8f:6c16 with SMTP id ha21-20020a17090af3d500b0024dfb8f6c16mr38458859pjb.16.1684249378265;
        Tue, 16 May 2023 08:02:58 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id d4-20020a17090a2a4400b00253311d508esm785282pjg.27.2023.05.16.08.02.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 08:02:57 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
	id E7EF7608D4; Tue, 16 May 2023 08:02:56 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
	by famine.localdomain (Postfix) with ESMTP id E2A1B9FAA4;
	Tue, 16 May 2023 08:02:56 -0700 (PDT)
From: Jay Vosburgh <jay.vosburgh@canonical.com>
To: Mateusz Palczewski <mateusz.palczewski@intel.com>
cc: andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
    kuba@kernel.org, pabeni@redhat.com, dbanerje@akamai.com,
    netdev@vger.kernel.org,
    Sebastian Basierski <sebastianx.basierski@intel.com>
Subject: Re: [PATCH iwl-net v1 1/2] drivers/net/bonding/bond_3ad: Use updated MAC address for lacpdu packets
In-reply-to: <20230516134447.193511-2-mateusz.palczewski@intel.com>
References: <20230516134447.193511-1-mateusz.palczewski@intel.com> <20230516134447.193511-2-mateusz.palczewski@intel.com>
Comments: In-reply-to Mateusz Palczewski <mateusz.palczewski@intel.com>
   message dated "Tue, 16 May 2023 09:44:46 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31752.1684249376.1@famine>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 May 2023 08:02:56 -0700
Message-ID: <31753.1684249376@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mateusz Palczewski <mateusz.palczewski@intel.com> wrote:

>From: Sebastian Basierski <sebastianx.basierski@intel.com>
>
>After changing VFs MAC address, bonding driver shouldn't use
>the old address. Otherwise lapcdu packets will have set wrong
>source MAC address.

	This patch is incorrect, the existing code is behaving
correctly.

	Bonding uses the original device MAC address deliberately, as
IEEE 802.1AX-2014 6.2.1.i requires that each port utilize a MAC address
that is "unique over the LAG" as the source address for LACPDUs.

	As bonding sets all ports of the bond to the same MAC (so that
non-control traffic uses the same source MAC per 802.1AX 6.2.1.j), this
change would cause every port of the bond to use a single MAC address
for the LACPDU source address, thus violating 802.1AX.

	-J

>Fixes: ada0f8633c5b ("bonding: Convert memcpy(foo, bar, ETH_ALEN) to ethe=
r_addr_copy(foo, bar)")
>Signed-off-by: Sebastian Basierski <sebastianx.basierski@intel.com>
>Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
>---
> drivers/net/bonding/bond_3ad.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3a=
d.c
>index c99ffe6c683a..b5202af79f20 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -869,10 +869,10 @@ static int ad_lacpdu_send(struct port *port)
> 	lacpdu_header =3D skb_put(skb, length);
> =

> 	ether_addr_copy(lacpdu_header->hdr.h_dest, lacpdu_mcast_addr);
>-	/* Note: source address is set to be the member's PERMANENT address,
>+	/* Note: source address is set to be the member's CURRENT address,
> 	 * because we use it to identify loopback lacpdus in receive.
> 	 */
>-	ether_addr_copy(lacpdu_header->hdr.h_source, slave->perm_hwaddr);
>+	ether_addr_copy(lacpdu_header->hdr.h_source, slave->dev->dev_addr);
> 	lacpdu_header->hdr.h_proto =3D PKT_TYPE_LACPDU;
> =

> 	lacpdu_header->lacpdu =3D port->lacpdu;
>-- =

>2.31.1

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

