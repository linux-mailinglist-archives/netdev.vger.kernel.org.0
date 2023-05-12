Return-Path: <netdev+bounces-2311-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C75CA70116E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8288D281C32
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2286261E7;
	Fri, 12 May 2023 21:38:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F38138F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:38:59 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991596A4F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:38:55 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-643b7b8f8ceso5763457b3a.1
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683927535; x=1686519535;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Djd2glYCoXtMAi8uMNHt1OZRkjvlHu9budSpLUd929I=;
        b=VCuHGOjf+gCpEolyK1paPF6u3j2kj6e3VJDrz6sSiF7z0db6uIFdPboBBhzpWFiK6I
         c2tRKpNaS5cnKQwZCbuwrAmsHX4s4DcY3XicX1e/LvV//Q09vdbpO26WeFeO2VpUMsOT
         aWi3mA7s/1BbUkQD1xjaTC42zoKwIH3fr8CUKvJq0U1EyaKtSnlM8tpziR47pmpp+dme
         Ga2DxixzMQk0sM825xby9sCib5z2cr+jok+46SuRjG1vRqusoX3Bro+5tJj+FRT2096n
         PYbYGRw3xa0i8D/U1/QM95ZIfnPDUGpZ+D3SbpWTxIwP5DX5unQZ0AfsgBuDSPy9y41Z
         bZig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683927535; x=1686519535;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Djd2glYCoXtMAi8uMNHt1OZRkjvlHu9budSpLUd929I=;
        b=Wv2N4cVfejkbYFauOvNFubdi0QYHS8McduLJWjsUwMbN0i3gE7H4Ht52/ll09QLgCH
         cQis5i80fFiHT7hAF/RamDojZzp6v1zIe0ofkVDV7gh1iVYb+8cxUflOa67QP3fmH2bd
         pDUJ2PdlkVia7H5lIMCt//jRP8Jrt+6sE0LT8j4iNrxjsisDnE71gncMkRcMAcLp/+zC
         R1CPv6t8uTMPD0Ex3JOHMmN2t1Ah3HjeazIEB4QOPemd59odATtz6S5C+TWWNbW6h+UK
         nn3Ri9i75jTOuyqKuf27v1hl9sWyO2sZUkKE52TrSfdcCCIvKxvFGgtmMePR3qC/v6It
         thXA==
X-Gm-Message-State: AC+VfDznHz5Ve/UJ8RBuHcJwfLxvIAT/AcRsAwHjBg/2huLz+9dtE4z8
	QbiYTDtJixfOZ0pL2/A7vuCJP6sYH0q93XK80XA=
X-Google-Smtp-Source: ACHHUZ6Q3jaExdrKrysNpvRR0YFArAOzwR8zPvGvseSlm5d0Th8CLkIe6kxWw654tK/4Js3DqHF8dj5XEEu7Zu0blvw=
X-Received: by 2002:a05:6a20:4296:b0:103:a9ee:d732 with SMTP id
 o22-20020a056a20429600b00103a9eed732mr11206375pzj.9.1683927535043; Fri, 12
 May 2023 14:38:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sundar Nagarajan <sun.nagarajan@gmail.com>
Date: Fri, 12 May 2023 14:38:44 -0700
Message-ID: <CALnajPCaJfR+N=vP0R6bXoUwMbopQK6JsJ+pXxS=T6KT5NXswg@mail.gmail.com>
Subject: NET_DSA_SJA1105 config declaration: tristate is not indented
To: Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>, 
	Florian Fainelli <f.fainelli@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 1291bba3f..63c9b049f 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NET_DSA_SJA1105
-tristate "NXP SJA1105 Ethernet switch family support"
+ tristate "NXP SJA1105 Ethernet switch family support"
  depends on NET_DSA && SPI
  depends on PTP_1588_CLOCK_OPTIONAL
  select NET_DSA_TAG_SJA1105

