Return-Path: <netdev+bounces-7171-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F37171EFD9
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 032841C20FD0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D3742511;
	Thu,  1 Jun 2023 16:57:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A75513AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:57:17 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328F2193;
	Thu,  1 Jun 2023 09:57:15 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b075e13a5eso9415485ad.3;
        Thu, 01 Jun 2023 09:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685638634; x=1688230634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3heb74JBl16wDJKB1mNo+GNjKJlaQnxiPl5JWu620PA=;
        b=kVbNiH4OCe3iCOwpvU24Kso5kf+or8Qv1NHstXz+o/BaR6m+9WCNPswOYV0SDRm6G5
         NvLWn0Kuqv4+3TfS/Hwftt/jiQOBrv0toyvqnEKpX/SOACKjKkpV+lTuPtx/jqPjMId1
         YqzDDCMUAyVMlpJ5jbhcdFmTzIQnDfuA6bIqGoq5FgOyTJ2tMEdBo4InFEy0z8lwTEOd
         XFSCNeJCKVfFrQCx1A5+as835T4Dn2SNL4ut+4YeOuDMQIRh8xyDxbwpYunE2+IYGuFs
         8jMvLjjSGgZ58AgDErf43zyO5kYfw0eTVBoa9mdsXGa0MwdifJquYyt9aWKpdoMX8JMv
         fdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685638634; x=1688230634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3heb74JBl16wDJKB1mNo+GNjKJlaQnxiPl5JWu620PA=;
        b=I3AFgiR6stGZ8swTEbtNizO23sVAAKKVlBsbndV6fUyg5sFPLHMgLUxIpbZ6eAV7/G
         a+Q26JWrUH3KLP1T21NRT3i68+nMGu2lSnpNILD1deC3JQujfFwR8zBjpJ4VLRJMQPmt
         CxGVTbMMELii11hdUCUGtZU5CaaP3Mbhlz5yPg5XXFXs2ASo0Ll+qCF9hJc/rvN+9BIx
         0z7cjeMsTGNRKPgUguBVr+cvRELHqrUVfmtk12JWqHEyvHnIjAIkqLwh/ZLm8s9EsVga
         7PuUJWOVhfBlpqV+BF9tqe7tSipQbfwiyYS8OMUWGtYUO+6vcl422nuL2JnBkivCJ5yg
         3EVg==
X-Gm-Message-State: AC+VfDyZ/SUZmqx0urc2yKY4RW/K9qD6GrjpuzcR74cQ9tOS+QSq05yZ
	lVup1BR6iKswS49jGTac3Ps=
X-Google-Smtp-Source: ACHHUZ5FKZ5i4bGZxYCQy9u9U0I9HY/29EtQ943EBssLBZj8oOHQaa1TPwgXs64EPCZplOEjK+ZExQ==
X-Received: by 2002:a17:903:1109:b0:1b0:43fb:407f with SMTP id n9-20020a170903110900b001b043fb407fmr51795plh.10.1685638634456;
        Thu, 01 Jun 2023 09:57:14 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902788500b001b0305757c3sm3744648pll.51.2023.06.01.09.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 09:57:13 -0700 (PDT)
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
Subject: [PATCH v4 0/3] can: length: fix definitions and add bit length calculation
Date: Fri,  2 Jun 2023 01:56:22 +0900
Message-Id: <20230601165625.100040-1-mailhol.vincent@wanadoo.fr>
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
 include/linux/can/length.h   | 300 +++++++++++++++++++++++++----------
 2 files changed, 217 insertions(+), 98 deletions(-)

-- 
2.39.3


