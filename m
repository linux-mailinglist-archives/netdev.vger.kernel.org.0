Return-Path: <netdev+bounces-4322-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC5C70C140
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BE2D281033
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7FAD50B;
	Mon, 22 May 2023 14:37:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A61BE70
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:37:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99899E
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684766275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=4iS5eRWVWa1PA7kfVw7qwCDMePt/C3UhYEQfnrp2y9g=;
	b=Y85ovx8YFT8V2kfATpo45f8kQpcYdquNy50dcoJisVByn+oGh9+JkMZPCfhfbmYFJnjwhC
	XyvSwBp17G3+fPXtNuA1BwKcBrGumqUjBjxv6fCfVzqiDqMdjJoesDr/5QzPXPb0vrr4XT
	wIQMlo8RG2FgIE+gL80uGjmnQEqkKN4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-Ct3RFD-ZOIetKWsgYw_htA-1; Mon, 22 May 2023 10:37:54 -0400
X-MC-Unique: Ct3RFD-ZOIetKWsgYw_htA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f6038dc351so4799255e9.3
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:37:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684766273; x=1687358273;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4iS5eRWVWa1PA7kfVw7qwCDMePt/C3UhYEQfnrp2y9g=;
        b=UqayV4nRzCDw5nO+VdJnbKnVRjfHUz3tWsoFDwebCpYJL1JcbxTrUMjcG03Kt9TLZf
         WtbX0tlIdHOBnwJFcc3knGnj1XjA2N84+HBxsz2ekAXMR9qHgGmk+D2LBLfvI1T66A34
         Khy9Ja9Pt1Q3yXwqPIsoyZ3ompYoOI9l9pIvfH5XVIdbcLEcgowPPpIKkBk7ULKeIh9K
         Bp0NAiotWULly18etoF1c7eyqNNMhn5fehLsZeNgacj3/IrWnvtPQQwOhs5rW/puHtak
         DcH2fx5Xu4Bp2mJctqj0dc8ltqLfjOkpe/M+xLXgepEXekd9dq8zTe5Lrsy5oAxcHlhh
         9Pvw==
X-Gm-Message-State: AC+VfDyN1D7sKESF175b80w+vqd23ng1cKE8/E74voK1nZ+Xl9hunvTu
	lEg3TJurkkuzcYMWXb4+k2H+4+z2dX9t0JP2olYr4k2kQ8wN5e6k3Xsmxj/N9LDjq6IePONDNK+
	IRMNnqFa+73oYnGD+
X-Received: by 2002:a05:600c:28b:b0:3f6:69f:75cd with SMTP id 11-20020a05600c028b00b003f6069f75cdmr1540116wmk.0.1684766273383;
        Mon, 22 May 2023 07:37:53 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Vnf09Uh7TpmDuy/sEQjynh7eqbzaA/qrrbkCx93F9Yd4a0dnDd9mIyCQCj0/64LisJoe0LA==
X-Received: by 2002:a05:600c:28b:b0:3f6:69f:75cd with SMTP id 11-20020a05600c028b00b003f6069f75cdmr1540107wmk.0.1684766273067;
        Mon, 22 May 2023 07:37:53 -0700 (PDT)
Received: from debian (2a01cb058d652b001c6f8f132b579d2b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:1c6f:8f13:2b57:9d2b])
        by smtp.gmail.com with ESMTPSA id a5-20020a05600c224500b003f5ffba9ae1sm7267059wmm.24.2023.05.22.07.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 07:37:52 -0700 (PDT)
Date: Mon, 22 May 2023 16:37:50 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next 0/3] ipv4: Remove RTO_ONLINK from udp, ping and raw
 sockets.
Message-ID: <cover.1684764727.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

udp_sendmsg(), ping_v4_sendmsg() and raw_sendmsg() use similar patterns
for restricting their route lookup to on-link hosts. Although they use
slightly different code, they all use RTO_ONLINK to override the least
significant bit of their tos value.

RTO_ONLINK is used to restrict the route scope even when the scope is
set to RT_SCOPE_UNIVERSE. Therefore it isn't necessary: we can properly
set the scope to RT_SCOPE_LINK instead.

Removing RTO_ONLINK will allow to convert .flowi4_tos to dscp_t in the
future, thus allowing to properly separate the DSCP from the ECN bits
in the networking stack.

This patch series defines a common helper to figure out what's the
scope of the route lookup. This unifies the way udp, ping and raw
sockets get their routing scope and removes their dependency on
RTO_ONLINK.

Guillaume Nault (3):
  ping: Stop using RTO_ONLINK.
  raw: Stop using RTO_ONLINK.
  udp: Stop using RTO_ONLINK.

 include/net/ip.h | 16 ++++++++++++----
 net/ipv4/ping.c  | 15 +++++----------
 net/ipv4/raw.c   | 10 ++++------
 net/ipv4/udp.c   | 17 ++++++-----------
 4 files changed, 27 insertions(+), 31 deletions(-)

-- 
2.39.2


