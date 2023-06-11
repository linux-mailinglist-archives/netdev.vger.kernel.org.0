Return-Path: <netdev+bounces-9864-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A549D72B007
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 04:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA6392813DF
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 02:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B6E1365;
	Sun, 11 Jun 2023 02:57:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285AE10F5
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 02:57:57 +0000 (UTC)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B2D94;
	Sat, 10 Jun 2023 19:57:55 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-25bc612be7cso281115a91.1;
        Sat, 10 Jun 2023 19:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686452275; x=1689044275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3awTdCuiTDqGcCqTnA1vhG9h33OMzW2smnHBjNchLQ4=;
        b=TckykcnM+TV79nPeXp177kqrjpgOY4FkrcwcYeuPqodiuaw+ScINxVVsiVQNEOHGHS
         18QB8pvNwIDhby0M6FHegcNl3lw00tqhxY6n6l/4bqwK6zqulxVLB5chNks5D1i0euks
         /IeAj+ePxskUK92BhXhUxVAVaWu375F/ht0ldxG/d5c6g/AnLAXHKK79fwJxDPK7vUL4
         1kOSXhrLIbDykoLjmdhVYk2Eahl65CvHZ4Whc1hbB7RfvkCKxOIgaIgUv6PrRqmpLfol
         X7vpHESxxvIJ2t+G4V4q8Huj0IkAMGwvpb+hOgWTOMMQhEGSpjMjM9+dMHIoqw3iRZqv
         ajPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686452275; x=1689044275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3awTdCuiTDqGcCqTnA1vhG9h33OMzW2smnHBjNchLQ4=;
        b=Lc0VHDnAOCvhhxLOFNaTILzmlAdp5dzpa1fNXhrFwmZmS4PnPjF6dPeCK9khmeLIvc
         nYxNsA181NRsIRd7HZTW3WN+j5ZvNK6S/UREPt19d85p2mw0OEMaNVwBqFjh12viEhs+
         GmdTXUrYl9xfoVdUrFghdw95zMHlqL+4waJzDtDKEX4FODY6mYz7QA8K/zTVThQFN3BI
         JtcsOPCFv93JyLhLUC7TovgC8U+kPFPvlxYMW0u9UVCiAMIR744A7PS3GuODzJTvCjJR
         pL/iZ/FcH4lVa/9LbhgsiAIKpYSh2FO0GImH2bvW8mfiVr9A/O8VoGPt8m8DF70v+knE
         vPxQ==
X-Gm-Message-State: AC+VfDzz9KzgdxNeGv7orDhM0vIRyjRjWWqA6yR+Hzga8tJPpIUmijDu
	+tFs2xpOPsuAtuIMunBOMnM=
X-Google-Smtp-Source: ACHHUZ5igU8LxM8i9dOvfy1rRJgvc5Q9EpahmP8duc6vcfNYjF7LX0oE7VAXaub+CR6tB8iHg/SpAg==
X-Received: by 2002:a17:90a:5b14:b0:25b:bcba:149f with SMTP id o20-20020a17090a5b1400b0025bbcba149fmr2303962pji.47.1686452274886;
        Sat, 10 Jun 2023 19:57:54 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id l7-20020a17090a150700b0025621aa4c6bsm1530319pja.25.2023.06.10.19.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 19:57:54 -0700 (PDT)
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
Subject: [PATCH v5 0/3] can: length: fix definitions and add bit length calculation
Date: Sun, 11 Jun 2023 11:57:25 +0900
Message-Id: <20230611025728.450837-1-mailhol.vincent@wanadoo.fr>
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

v4 -> v5:

  * In __can_cc_frame_bits() and __can_fd_frame_bits(), enclose
    data_len in brackets to prevent operator precedence issues.

  * Add a note in can_frame_bits() documentation to explain that
    data_len shall have no side effects.

  * While at it, make CAN(FD)_FRAME_LEN_MAX definition fit on a single
    line.

  * A few typo/grammar small fixes in the commit descriptions.

Link: https://lore.kernel.org/linux-can/20230601165625.100040-1-mailhol.vincent@wanadoo.fr/

v3 -> v4:

  * No functional changes.

  * as reported by Simon Horman, fix typo in the documentation of
    can_bitstuffing_len(): "bitstream_len" -> "destuffed_len".

  * as reported by Thomas Kopp, fix several other typos:
      - "indicatior" -> "indicator"
      - "in on the wire" -> "on the wire"
      - "bitsuffing" -> "bitstuffing".

  * in CAN_FRAME_LEN_MAX comment: specify that only the dynamic
    bitstuffing gets ignored but that the intermission is included.

  * move the Suggested-by: Thomas Kopp tag from patch 2 to patch 3.

  * add Reviewed-by: Thomas Kopp tag on the full series.

  * add an additional line of comment for the @intermission argument
    of can_frame_bits().

Link: https://lore.kernel.org/linux-can/20230530144637.4746-1-mailhol.vincent@wanadoo.fr/

v2 -> v3:

  * turn can_frame_bits() and can_frame_bytes() into function-like
    macros. The fact that inline functions can not be used to
    initialize constant struct fields was bothering me. I did my best
    to make the macro look as less ugly as possible.

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
    of definitions. Another reason is that because the dynamic bit
    stuff is calculated differently for CAN and CAN-FD, it is just not
    possible to multiply the existing CANFD_FRAME_OVERHEAD_SFF/EFF by
    the overhead ratio to get the bitsuffing: for CAN-FD, the CRC
    field is already stuffed by the fixed stuff bits and is out of
    scope of the dynamic bitstuffing.

Link: https://lore.kernel.org/linux-can/20230507155506.3179711-1-mailhol.vincent@wanadoo.fr/

Vincent Mailhol (3):
  can: length: fix bitstuffing count
  can: length: fix description of the RRS field
  can: length: refactor frame lengths definition to add size in bits

 drivers/net/can/dev/length.c |  15 +-
 include/linux/can/length.h   | 299 +++++++++++++++++++++++++----------
 2 files changed, 216 insertions(+), 98 deletions(-)

-- 
2.39.3


