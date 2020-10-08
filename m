Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C56286F3F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgJHHVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJHHVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 03:21:45 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5F0C061755;
        Thu,  8 Oct 2020 00:21:45 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4C6N1M6wHZzQjbW;
        Thu,  8 Oct 2020 09:21:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received; s=mail20150812; t=1602141700; bh=zyDz1+ViD4
        X4GEpN3D5om2c9OFBTBsXd//uJEZm7Xtg=; b=GmEMpsb0YMu63wFC0mFcfeoZCy
        /1og38lyci7usBibtdmR6Byza4RPaIfXHX0xwW0IaSGYEoy/R62Jzz40bjysI7SS
        5Sj/68kAoooXSR2qG/2S/5W96GGClNJAPiEsQoGc2cCnoZOLUXRLYMv513RYj0eH
        tKtvhM5FSCdJQQp4QHtYkbC3RRf6qqewXrPwkKcZ5/38Aocp4DVmOo0qEqIZ646+
        CerRBnXq4MwMrV9Q8z7loU1tydYauLkw274DY2cwNWTQLnRy42NskUeHzjcz8ae0
        B5/uKWL2Kaznleb71zfr+orr6ARMtV9CvTyoYaro316XKmhDNcDTxQu4d3aQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1602141702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0yuQpyOp1cOPijKH3KbjZ0G1rEfKqPtI1bSlIEuxGGE=;
        b=WloNyJBeI+dhm2eJjNiYIrAhrwcpcQZ6pNz2MnsHvO9NQ8cxE2UxqVu++glW/VlOMokzWO
        Wi2ky4w9+UHsSZRZh41+r4WYAzVv/XGqwGVYz68WTXreUKvi9DblXbsniHCAaVCVaLFKxX
        PQpP2Fo/MvG2wAVPDENz584EuPUMlX7VEu6l8KZ5RMTqdxDUj+4LH0COL+az7CDLuAtZFM
        2szDEBlh0b4HqqIfOAKTTTSxjOUSeLQGff6qS07Mok79eEecOHK9FS0wAHqBPvV0p1p0bv
        LYhZFBSr7gHjvR73SiUGu5Z1wBZ3xac2svW+da5IdKAagNVoM1F2ICd6XyBH4Q==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id I57ARDSTi1Qy; Thu,  8 Oct 2020 09:21:40 +0200 (CEST)
Date:   Thu, 8 Oct 2020 09:21:38 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     linux-kernel@vger.kernel.org
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH v2 1/2] net: usb: qmi_wwan: add Cellient MPL200 card
Message-ID: <f5858ed121df35460ef17591152d606a78aa65db.1602140720.git.wilken.gottwalt@mailbox.org>
References: <cover.1602140720.git.wilken.gottwalt@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1602140720.git.wilken.gottwalt@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.52 / 15.00 / 15.00
X-Rspamd-Queue-Id: D5AFD17DB
X-Rspamd-UID: a47df1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add usb ids of the Cellient MPL200 card.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 07c42c0719f5..5ca1356b8656 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1375,6 +1375,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x2cb7, 0x0104, 4)},	/* Fibocom NL678 series */
 	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
 	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM support*/
+	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},    /* Cellient MPL200 (rebranded Qualcomm 05c6:9025) */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
2.28.0

