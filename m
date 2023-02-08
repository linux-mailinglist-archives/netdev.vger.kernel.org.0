Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1BC68E634
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjBHCoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 21:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjBHCoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:44:14 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CA642BC3;
        Tue,  7 Feb 2023 18:44:12 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id bg10-20020a17090b0d8a00b00230c7f312d4so839346pjb.3;
        Tue, 07 Feb 2023 18:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyqZcRW+GCugu4NS9vKOMBoBT0DqUhhKYXJJWlHHasM=;
        b=mp2V3kKaJjudKsbJwyzaBVBQhDL9Aqv6JEFZT6bcipjH6W83zFCNQbMombS4raOmgo
         djL3OSU7Pl1auFWMed2zIzkXR2YOce439ls0lXCMuOHGkEkBVbtbouC8YHRUbdglcqh2
         nT441af3nzdyEZpLafy3zVNO3bS9e0ffV3wWpTQ6WZi3fJcwcZjdmTInTB8bZgCfUAJm
         K1/JCGsscz8L2MyJ8UfkcUztjZX4YyNZ+o0TasQQ5AENhRrwcwC9hnasnFrFTJXQDePX
         9kiEarkcvkpxSnxE4guYS+j+bqk+awaEFyYEJZkN8ocH6VANoTTPx1CPbxprKia+3J7j
         qH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VyqZcRW+GCugu4NS9vKOMBoBT0DqUhhKYXJJWlHHasM=;
        b=IMRv7z7inF1uarlyBa7AiNI9nCUa+37th+1uJx++P+zFXvjMppvqN7zKY+wulcqAs5
         UOznLZF09OGUhIq4r09fjV36TWLz4aYm9H4puY7tKTCxyArIK7ONKFviWPheZp9KQPfX
         1H2q9GM0pk95YI38RQ3tKgJrWsjgolsS/vwgek/OuneP2ZTV1YTu1HU/shkq9OIzFA95
         5fe5Nd7UD8O/PB8RPzVX9AHzgDlkUaumAqo+TGsSAfEvpsecHcK67KBCYRToubnCcyys
         l6SXC9PhkZsjf/bVydPuh2DA7SaK6CKrdGhwHPPXq+quUVcrg1WozxJ/H1v+qzthGE/b
         IbVg==
X-Gm-Message-State: AO0yUKW2olEOLYRwi2aGGTOy9NqDzGCIx/xgBULLezsJFVZbDlr5CQOL
        MqRFri47C5ibA2CiBua9wyY=
X-Google-Smtp-Source: AK7set/4oeTEli8Ax7aBRx/+c9c1lZQ8VN9xNA+XYH6H2dBDKz8nuyieM3SD3X+Z800o+WRlK8yd8g==
X-Received: by 2002:a05:6a21:2c98:b0:b6:40ae:823e with SMTP id ua24-20020a056a212c9800b000b640ae823emr4795213pzb.5.1675824252275;
        Tue, 07 Feb 2023 18:44:12 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id jk3-20020a170903330300b001960735c652sm9660835plb.169.2023.02.07.18.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 18:44:11 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net v2 2/3] i40e: add double of VLAN header when computing the max MTU
Date:   Wed,  8 Feb 2023 10:43:33 +0800
Message-Id: <20230208024333.10465-2-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230208024333.10465-1-kerneljasonxing@gmail.com>
References: <20230208024333.10465-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Include the second VLAN HLEN into account when computing the maximum
MTU size as other drivers do.

Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
v2: drop the duplicate definition
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 53d0083e35da..d039928f3646 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2921,7 +2921,7 @@ static int i40e_change_mtu(struct net_device *netdev, int new_mtu)
 	struct i40e_pf *pf = vsi->back;
 
 	if (i40e_enabled_xdp_vsi(vsi)) {
-		int frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+		int frame_size = new_mtu + I40E_PACKET_HDR_PAD;
 
 		if (frame_size > i40e_max_xdp_frame_size(vsi))
 			return -EINVAL;
-- 
2.37.3

