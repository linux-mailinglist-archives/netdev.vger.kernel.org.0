Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1475739746A
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhFANhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhFANhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 09:37:18 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3E3C061574;
        Tue,  1 Jun 2021 06:35:36 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id 76so14186126qkn.13;
        Tue, 01 Jun 2021 06:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=j0tjXHeNN7AUurB5cLI8o1ISAdFy04hANqw0zoPSSR8=;
        b=ZmwvfbzRwq9tDJ8ZnNRxlvjFocOiIkAElFNefGxNjIopHdBDJ33SHsLeKT2uxKGwe0
         oRufSNOcROmpzuuPDuAwvCEQoxQ1XymhEh2vGhlm92Ln0tIBBccBKeVETmQNZ1UJ+QUA
         pc2c0MTGpgqYdAr8+TjXYTs/Edq58r3oVftblwGyqfTcDlSdhfbvDx1CFuBrvHVReYRp
         vwZhxnvPxOGxP3pH+0+fqgsdikZiV69/j7JkvtCZ/TNZG2aczlu5Xo+hBL4fS/iwtmY0
         Hop2ZqavR9uXs5SYjn8i82GLh7HeUCa3qGbWZskd4pqxNIVstsMoKRG0f/wN4M88wT9N
         irfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=j0tjXHeNN7AUurB5cLI8o1ISAdFy04hANqw0zoPSSR8=;
        b=gbM98qKpfXRazu9l2n/QbDpixO69UkuysLsCj7m8Gfi86ZP53KYuZYnTsjWoN1J6wk
         +cHRwtQmAaNvTb/44qrmUdtm+d06iiQKhQYqvO7yj03CpaZAboXaPsIFUN6x8a1h3DeF
         Pmhc5geHGuuI6NXpLDCzJHyRoSh9an1LZn7pNbm25ShbA44khgpiU4w3l6XQSTfTCZWm
         1qn2QrfD3LOvlWfGpMeWHiHwXDaWE2GXceO/QhSC4n4sxUqp2v+sq9hU8HUuW4ubB5+c
         80oGdrbrlFQQVxH/ZGGsN2AM89ZFTLBSifk2sC7+0K6szTnnDIZD+Sl7mCSl3svf4VNV
         QBxA==
X-Gm-Message-State: AOAM532D3GhBeJUfNMeYtvolLFbVhctBWsvdPhWPntFs6m0lxwWB+N0f
        RjlKxrNQE8ws13/0FDswfLlEe+3fdfOCtGq6NFYZug==
X-Google-Smtp-Source: ABdhPJyo9FtbWaJQJ6+6YZ2IYGf6xevE3PVWpSK+6lgLZtF6oG68bO59WtJ+lItFO3c4TFnwtyyzbg==
X-Received: by 2002:a05:620a:e12:: with SMTP id y18mr21748529qkm.106.1622554535402;
        Tue, 01 Jun 2021 06:35:35 -0700 (PDT)
Received: from fedora (cpe-68-174-153-112.nyc.res.rr.com. [68.174.153.112])
        by smtp.gmail.com with ESMTPSA id c14sm10109443qtw.42.2021.06.01.06.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 06:35:35 -0700 (PDT)
Date:   Tue, 1 Jun 2021 09:35:33 -0400
From:   Nigel Christian <nigel.l.christian@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] NFC: microread: Remove redundant assignment to variable
 err
Message-ID: <YLY3pSMrpbQxIJxO@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case MICROREAD_CB_TYPE_READER_ALL clang reports a dead code
warning. The error code assigned to variable err is already passed
to async_cb(). The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
---
 drivers/nfc/microread/microread.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
index 8d3988457c58..b1d3975e8a81 100644
--- a/drivers/nfc/microread/microread.c
+++ b/drivers/nfc/microread/microread.c
@@ -364,7 +364,6 @@ static void microread_im_transceive_cb(void *context, struct sk_buff *skb,
 	case MICROREAD_CB_TYPE_READER_ALL:
 		if (err == 0) {
 			if (skb->len == 0) {
-				err = -EPROTO;
 				kfree_skb(skb);
 				info->async_cb(info->async_cb_context, NULL,
 					       -EPROTO);
-- 
2.31.1

