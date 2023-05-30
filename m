Return-Path: <netdev+bounces-6441-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E5C7164B5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BBBE2811EA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F9A1F164;
	Tue, 30 May 2023 14:47:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881CB17ACA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:47:11 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D74A7;
	Tue, 30 May 2023 07:47:10 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-64d2da69fdfso5257297b3a.0;
        Tue, 30 May 2023 07:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685458029; x=1688050029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1pwOgc9n/HYgJgD3pK1AViRx5U8Q3xr/lijbDwiXcs=;
        b=ItLNle/AtaJDssP0ydBaLH2dQdKFKRG0Fhn9BmqYS4D2kqvSylS++lU2JSMsVpvu3T
         2IJ8Myu1OgVnVxKFQ+i74r7vo0pAa7L7NYq7r9WxfPq6XY0rx3hQXKwXdQ/QmVyNGdtN
         sMmDOPgQYe+fJkaPUoMMYbX1c9uYVz9dOXb8mNLQ3fO1Y/6C7xuFhBzCIPSE4JHPtqz4
         XjB7ArA026DlXk+NESgMCTHDf2IIAWBsDg5WRhvNDjID4c+SO9STC2rBljjuEffjveHq
         J6OvQO8yniEnhe0tl5DMZ2iDdF3oCIFq69ooLrxpxWuCfRsew5klhNnOlHmUkY8xswOn
         MG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685458029; x=1688050029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A1pwOgc9n/HYgJgD3pK1AViRx5U8Q3xr/lijbDwiXcs=;
        b=F+VN9odUS73sR3fL5wG3bSpd7dHN9/gfDAFY9fntGXIHEp29D9my0EEUnHAcKEEGnk
         xERX8pVEQ8Ytq8tP5+2mAPTkhYCb5qJG56tAsB9tJb7/Plh3XNRPS627pHGl5idrIqTH
         xdyt/awPjLKqGaGhZmylXllaN+gtxk8O3KfiDV6GgxrItaoKS/CZGbl3ccoqIb1/1uqv
         /4jTO+avphgbt4OupyjczsAYyRR5vMfWAFTbvJpccCV0hR5J1iE9pBEXr3pjwhBYj5Yj
         RR3JF4BaQeFImEqm0dGvs7I68uHN6MbZ/owA/6BJ2UZFOWV1tsd+kkmV5YguxtB3loCU
         oFPg==
X-Gm-Message-State: AC+VfDxwbTae/+WCCrHmtYy5ACyT8ZIe4WS6xeYCa4xtOZ6XCWg1+j9C
	ZHXrJSaK4FRn9n/POjUQsn0=
X-Google-Smtp-Source: ACHHUZ6p4UF8ym+TgHVNdvt/TeMrI4MiecPinNK6UJIlGNopkVIT/+feLIyhaYjHaR51RYwYy0WJiw==
X-Received: by 2002:a05:6a00:9a5:b0:641:39cb:1716 with SMTP id u37-20020a056a0009a500b0064139cb1716mr3537861pfg.20.1685458029243;
        Tue, 30 May 2023 07:47:09 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id e3-20020aa78c43000000b0063a04905379sm1703193pfd.137.2023.05.30.07.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 07:47:08 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
	linux-can@vger.kernel.org,
	Thomas.Kopp@microchip.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
	netdev@vger.kernel.org,
	marex@denx.de,
	Simon Horman <simon.horman@corigine.com>,
	linux-kernel@vger.kernel.org,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 0/3] can: length: fix definitions and add bit length calculation
Date: Tue, 30 May 2023 23:46:34 +0900
Message-Id: <20230530144637.4746-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.39.3
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

This series introduces can_frame_bits(): a function-like macro that
can calculate the exact size of a CAN(-FD) frame in bits with or
without bitsuffing.

[1] commit 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce
    function to get data length of frame in data link layer")
Link: https://git.kernel.org/torvalds/c/85d99c3e2a13

[2] RE: [PATCH] can: mcp251xfd: Increase poll timeout
Link: https://lore.kernel.org/linux-can/BL3PR11MB64846C83ACD04E9330B0FE66FB729@BL3PR11MB6484.namprd11.prod.outlook.com/


* Changelog *

v2 -> v3:

  * turn can_frame_bits() and can_frame_bytes() into function-like
    macros. The fact that inline functions can not be used to
    initialize constant structure fields was bothering me. I did my
    best to make the macro look as less ugly as possible.

  * as reported by Simon Horman, add missing document for the is_fd
    argument of can_frame_bits().

Link: https://lore.kernel.org/linux-can/20230523065218.51227-1-mailhol.vincent@wanadoo.fr/

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

Link: https://lore.kernel.org/linux-can/20230507155506.3179711-1-mailhol.vincent@wanadoo.fr/

Vincent Mailhol (3):
  can: length: fix bitstuffing count
  can: length: fix description of the RRS field
  can: length: refactor frame lengths definition to add size in bits

 drivers/net/can/dev/length.c |  15 +-
 include/linux/can/length.h   | 295 +++++++++++++++++++++++++----------
 2 files changed, 213 insertions(+), 97 deletions(-)

-- 
2.39.3


