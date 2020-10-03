Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9528233B
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJCJkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCJkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:40:01 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64272C0613D0;
        Sat,  3 Oct 2020 02:40:01 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4C3MKC0VcKzKmXH;
        Sat,  3 Oct 2020 11:39:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received; s=mail20150812; t=1601717997; bh=rBxwB7GQD7
        xMs4KvdLsiKe4ixDpCg+QsAthMDwNNmzg=; b=KxhsAobcUqt2nOaRc0h+eSIUEi
        EafCKVW8jtuAlobbAaeQvZQlOZRxvejxEi3vd4D9xq0QYUOzeGwtXrN9kOPntCUC
        wDmkNqcXUPCav7D3eNTlImV3K+8AsjVi0/JfHXfNliFH598JmYuiw2mEFRB5ejdj
        GeScEcwVRh8kuCSFoLt4Xh58+p6ny0EILvpImM4qUj85AiV2MdNNBEQpUMfOnQ9B
        LizhgMHzi2sMjgCpT/pRA2z4+865vVrkf1jz0MN+kO6YwvKidCGCYkfzGt/QbMB8
        CWu9wzeNrKKon9WZbAfFArPX/zGt+1SHCcjpQOQPXjWU2c7ZnRQQfoWVSOaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1601717998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nQTM4S8lqJOdVBmjZRBxc7nIZEPkK4V4IZ7UNorSIMM=;
        b=vpt+6ylJIRhaqRjwMTfHjylVMihycO83mci3nswUmxunJCwkl4ZED2NEseHiRbodai4gi2
        R9hI8I/IP50bEDpOYKlnyNySpeM7EbCFKzqi4NoUo2jIaSqLI95UdzbDDd+C+gdQfCIitO
        C1jzBOYWP7/2GWC73TTaVeLliYScPXoqQnwcj2Wi1dus3TopmnyfT5qhKsjxfvVwIBw6MW
        t+YWue/LXjJyweRpTmWUqiBUM7ccjdv7tgsUB4JTNQq167weYe7hOZctb80B9HEcGGRSdA
        uziBzuHrwSRgeUDlHUqG+UlRkMJF2Od2H/CMa6/3Wwuufa/wq86EdGnGMuFnbA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id 46fwVTbI7Rnk; Sat,  3 Oct 2020 11:39:57 +0200 (CEST)
Date:   Sat, 3 Oct 2020 11:39:55 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     linux-kernel@vger.kernel.org
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 1/2] usb: serial: qmi_wwan: add Cellient MPL200 card
Message-ID: <4688927cbf36fe0027340ea5e0c3aaf1445ba256.1601715478.git.wilken.gottwalt@mailbox.org>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.53 / 15.00 / 15.00
X-Rspamd-Queue-Id: B5879108B
X-Rspamd-UID: f41f0f
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add usb ids of the Cellient MPL200 card.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 07c42c0719f5..0bf2b19d5d54 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1432,6 +1432,7 @@ static const struct usb_device_id products[] = {
 	{QMI_GOBI_DEVICE(0x1199, 0x901b)},	/* Sierra Wireless MC7770 */
 	{QMI_GOBI_DEVICE(0x12d1, 0x14f1)},	/* Sony Gobi 3000 Composite */
 	{QMI_GOBI_DEVICE(0x1410, 0xa021)},	/* Foxconn Gobi 3000 Modem device (Novatel E396) */
+	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},	/* Cellient MPL200 (rebranded Qualcomm 0x05c6) */
 
 	{ }					/* END */
 };
-- 
2.28.0

