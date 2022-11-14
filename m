Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A70A628CD7
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbiKNXBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbiKNXBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:01:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17E1DF3A;
        Mon, 14 Nov 2022 15:01:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C0F861484;
        Mon, 14 Nov 2022 23:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E285AC433D6;
        Mon, 14 Nov 2022 23:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668466863;
        bh=bgsf9poCZpz4u0fHQGh5vWi1vwxI1XHcpCqXFy31o5k=;
        h=Date:From:To:Cc:Subject:From;
        b=pijHEwz8nAQkQVXZx5cPZVRiTNbDf751haQK+oXa+lqLcKbVRu6haxrRmKosiWQe3
         XG+D8QF/eZSRhq7IOenJ3XzGnos7VhN0zn9o3UFv8s0PJxgFP3XL7/Q1KPCrFroY8i
         1DuH6KPTArsaYNGRgWR83dl5aVXC6N9fZ7taKO/FbTVcWCKDCPBURRYxj/HRkD6Hpg
         tY6zr+uMNACw8Xe0x4GVuR8iposzSMbXeWzzLbn+yyGDU3rS9BPLx1sPo0LtqRYBsv
         ylL8SLWWxHMxdEJ4CFtzQptnWKnU7RpwbdZK9Rt7HG5cw6OiiLu7nurO3CJg7SYfX4
         jD/DRLu+aP2Aw==
Date:   Mon, 14 Nov 2022 17:00:46 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 0/2][next] wifi: brcmfmac: Replace one-element array with
 flexible-array member
Message-ID: <cover.1668466470.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series aims to replace a one-element array with flexible-array
member in drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]

Gustavo A. R. Silva (2):
  wifi: brcmfmac: Replace one-element array with flexible-array member
  wifi: brcmfmac: Use struct_size() and array_size() in code ralated to
    struct brcmf_gscan_config

 .../net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h   | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c      | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.34.1

