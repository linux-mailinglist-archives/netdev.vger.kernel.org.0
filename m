Return-Path: <netdev+bounces-4573-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9175070D456
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 993751C20CC0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC76C1B908;
	Tue, 23 May 2023 06:52:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B50479CA
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:52:54 +0000 (UTC)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2E7119;
	Mon, 22 May 2023 23:52:53 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1ae3f6e5d70so63934965ad.1;
        Mon, 22 May 2023 23:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684824772; x=1687416772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLZF78elZ5fywU4ggbjiempk1JzD13372+eqZZhE/fU=;
        b=cvJWnD2kQdi+LzN7svo4PxJAY0WHhqoM1vavUUyyvgSQ0zxkR2VaeRau9lZ7eAETjj
         jpr2M/pq/TOy6wFQp3z7yb6fnggo0sjdyFj8NValhSO6IAwv4ETYXKBdq14kCLErbIjY
         TTVit5ylXO7J7CCF2LH4e/LpbiP0Fx0rkvG0sD/wtDkhMeawL5WAGcXo20qYzakPfKEr
         lIgR0qQ8lCkl4WiM7pAal35Oy+fD5pqfYzZgVCSu///crm4XZRKKrZEP4JE7U5Qv6IR3
         4ZYP9fJH9kslLQ/nSWrSvyHhlGAT3egX/Cfs8h7AfIhmx2tG8DVhvyKOEyllu3zK5hYa
         jE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684824772; x=1687416772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cLZF78elZ5fywU4ggbjiempk1JzD13372+eqZZhE/fU=;
        b=iLliyB31PZ3UxneTXs5yknlMmfze9QVHVE07ehRBfwByBHV2eobrM/mG3hVOrr9AWa
         evKPt9I8IVGbq7xQsu27PXkNIQehgY25P1zyAwfhAor2SCb0auCJrLsenzAU2r9GFUUl
         oHGvejP4cezp43z+wKrDpYVh7WceuFy6JMVckfN/nXgPQveok717Z1ItqjjhKzgORdIC
         SK1XSBryN9Zi/i/htVbCw83FOFenowGe44Z5PlsDNyuI9arXbTyz98dcnYrQDYPPQuXe
         Ivop+B79XYhks/7eBcWXBv5dLtLqVuGIpm2b53sHHyhKwA9y4nPMOfAbKpDmQH/n47TX
         iuOw==
X-Gm-Message-State: AC+VfDzR6Z73HNOinlDUeMBFmWgAno8XnenD5pMiqbAuG1jIydOnkZ+k
	meyBiPnOQY8Vd3Paa+alob4=
X-Google-Smtp-Source: ACHHUZ6QQekh2zqaE63vIhPpBu0Tktbw+k/ntY3lepRohD8A7cdvGkll8SHqFD4mVlxiMBiYFpwPsA==
X-Received: by 2002:a17:902:6b8c:b0:1af:bae0:6bed with SMTP id p12-20020a1709026b8c00b001afbae06bedmr3240770plk.56.1684824772460;
        Mon, 22 May 2023 23:52:52 -0700 (PDT)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902ceca00b001aafa2e212esm5963920plg.52.2023.05.22.23.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 23:52:52 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
	linux-can@vger.kernel.org,
	Thomas.Kopp@microchip.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	netdev@vger.kernel.org,
	marex@denx.de,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 0/3] can: length: fix definitions and add bit length calculation
Date: Tue, 23 May 2023 15:52:15 +0900
Message-Id: <20230523065218.51227-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When created in [1], frames length definitions were added to implement
byte queue limits (bql). Because bql expects lengths in bytes, bit
length definitions were not considered back then.
    
Recently, a need to refer to the exact frame length in bits, with CAN
bit stuffing, appeared in [2].

This series introduces can_frame_bits(): an inline function that can
calculate the exact size of a CAN(-FD) frame in bits with or without
bitsuffing.

The review of v1, pointed out a few discrepancies of the current
length definitions. This series got extended to fix those
discrepancies.

[1] commit 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce
    function to get data length of frame in data link layer")
Link: https://git.kernel.org/torvalds/c/85d99c3e2a13

[2] RE: [PATCH] can: mcp251xfd: Increase poll timeout
Link: https://lore.kernel.org/linux-can/BL3PR11MB64846C83ACD04E9330B0FE66FB729@BL3PR11MB6484.namprd11.prod.outlook.com/


* Changelog *

v1 -> v2:

  * as suggested by Thomas Kopp, add a new patch to the series to fix
    the stuff bit count and the fixed stuff bits definitions

  * and another patch to fix documentation of the Remote Request
    Substitution (RRS).

  * refactor the length definition. Instead of using individual macro,
    rely on an inline function. One reason is to minimize the number
    of definitions. An other reason is that because the dynamic bit
    stuff is calculated differently for CAN and CAN-FD, it is just not
    possible to multiply the existing CANFD_FRAME_OVERHEAD_SFF/EFF by
    the overhead ratio to get the bitsuffing: for CAN-FD, the CRC
    field is already stuffed by the fix stuff bits and is out of scope
    of the dynamic bitstuffing.

Link: https://lore.kernel.org/linux-can/20230507155506.3179711-1-mailhol.vincent@wanadoo.fr/T/#u

Vincent Mailhol (3):
  can: length: fix bitstuffing count
  can: length: fix description of the RRS field
  can: length: refactor frame lengths definition to add size in bits

 drivers/net/can/dev/length.c |  15 +-
 include/linux/can/length.h   | 323 +++++++++++++++++++++++++----------
 2 files changed, 238 insertions(+), 100 deletions(-)

-- 
2.25.1


