Return-Path: <netdev+bounces-2309-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D376A701168
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:36:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8BEB1C2133E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB58261EC;
	Fri, 12 May 2023 21:36:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1500138F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:36:21 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C21268D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:36:20 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1aaebed5bd6so75176175ad.1
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683927380; x=1686519380;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=otETqQzNZyulO3E1uxu7+DonGaJWlmgFnDEKB8wSWQo=;
        b=Aq9g75jalELg3IdAdPG2rRm6NRimHYBGJ1QsdNegF9qvzx7e5nWgABWGOrlIYFnC0s
         SR0Cetyum9LaJ86hr9tu5yAd4NWTcoiafKwuXDgLNrpzq8Ctgyrpx3ShVnv0397HBbry
         sRY75i88y+/SDdyFarX6LnkFrv25ySzxsv696GjEBzbSO8V7cGZSizWn+L+rm9fP2AZA
         Gw1rwGJ10QpRkPYe6GRayBfIvJVXuj3U1DMecLnVpjWDu2kiNSpPURfHnVKyNdHEsyKs
         VGA+ufPk2+6XTXN2pgdQjWdN2TIKx3i9HWfcXh03K4DnNYTIuVhxWtKR1lWdlWpNP89R
         QNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683927380; x=1686519380;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=otETqQzNZyulO3E1uxu7+DonGaJWlmgFnDEKB8wSWQo=;
        b=NDwLZ85in5DLAL9KlDNmJe7uOpmpZ2J1FvNyUxebD+/BWOUWMiwm/DLrtoC7Cxuc+L
         Zef8NJXuvLUCi2DK6bgMoDnRdasmpsjSDzg8usCQkjTUXblXRFm+AxQpPvGHFZqsKzmj
         IdlKlOHyxMF83Qsi4EJH2MaPv5vNZ8S2RkfwN0Gc1PKXfqA6XmwZUjHGTU4Kg3BoEcyV
         +gXfLuzGZ+oVzJVfoD/mUnBtTdOIFhsAjzdYoEtzY+F3mg4OpT6pFh7XNxgo3hkgdPQP
         xjZViXJO7N26bOTzshrBREevMa9jqO8T4evgLM3uxKcVj66KQsu/dC0KEGBhlIdAsNrl
         1s4w==
X-Gm-Message-State: AC+VfDz3oFwSGhcTFFNsWqySmlcSpmBSSuepbpKJn0srAsN4B1Rt2scV
	NSq8WfYbPFaaQGJz5KSp/MWWZEyRt4nygVsVuLU=
X-Google-Smtp-Source: ACHHUZ7P1mJ+DheReHwcZhGo1jOJd51bumktXFzY0uHSfGORgXd7Mn0D1Cg8jPr/GyJrHC1Z0+/EXDYmYqnCmmYXaVM=
X-Received: by 2002:a17:903:234c:b0:1a6:ff51:270 with SMTP id
 c12-20020a170903234c00b001a6ff510270mr31331781plh.29.1683927379808; Fri, 12
 May 2023 14:36:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sundar Nagarajan <sun.nagarajan@gmail.com>
Date: Fri, 12 May 2023 14:36:08 -0700
Message-ID: <CALnajPCmN37AU0Dz8NuwZdW3MX2QWiSdyoKSAHGbD0B+dvHoCA@mail.gmail.com>
Subject: IPV6_VTI config declaration: tristate line is not indented
To: "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 658bfed1d..c4f6bfd20 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -152,7 +152,7 @@ config INET6_TUNNEL
  default n

 config IPV6_VTI
-tristate "Virtual (secure) IPv6: tunneling"
+ tristate "Virtual (secure) IPv6: tunneling"
  select IPV6_TUNNEL
  select NET_IP_TUNNEL
  select XFRM

