Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EE62D363F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbgLHW0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:26:55 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:45671 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730297AbgLHW0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 17:26:54 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 8EC2A10ED;
        Tue,  8 Dec 2020 17:26:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 08 Dec 2020 17:26:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nkwarfield.io;
         h=date:from:to:cc:subject:message-id:mime-version:content-type;
         s=fm3; bh=93kAimUHuURvl/m8SQ6dsmBkazfQnzIkpniefjGMWU0=; b=qsi7z
        D62duOvWPi4ET9Smy9P8MKlIoAXC13tu6wsyZyjGUvRmZDOhgMHFiSbdxNg+Vpwy
        h9Dj3CMJnthvP6X77f+7pSMSbc/aST8SkCsgRFb82yPiNBrHWTuwVXTrS4F0DgEV
        EPgPanSLqUs31Un4CjGKLkkh94rZ1wVLSFH5kilmKnHcH4Z6F/fjID/nqDYt90hX
        Db+ZYoNYzVCp2vlg6UK5czw8BgDccaWyUpF3gwbdd908YJe1pYEFYIljESE6V50L
        V32+dTCDjiLwh1bt+AHIGtnHxFn2hxMYxxuNTQUvJnHCGNFKKXFigYd8aDo9BHJv
        gC3fvYWVQaDTPDT9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=93kAimUHuURvl/m8SQ6dsmBkazfQn
        zIkpniefjGMWU0=; b=bvvCNF2PVTLkBG5Z9iTVQ4hqAapTc0vYH4YtYI2OxC6zB
        UECGV+NitvLPzkSZPKGfeGvaXjIwEQeCRkg+6ggfjYYhQXiBXPL/tb+KyTvzlMW2
        2d/EpVcx0hi6SJ9D/4DhoQGereliWLOocUB9RrNg8ysUzFagzH/3b6uFmfdeBiMR
        l0TWqPH6ALtuoVMXVU4OrSH/k73L+66/NTIUfp1EmQ3SPS2c2PU6NyH23fu3ofQR
        I4h9C7wGJHfj0txk01W54sj1YHjfL9Q0BkRZxLu4FfcDk5iEukh2VFg8/IAoKf2i
        mxLYAykw9REfD1F4n+KtVXRr28J7i1ecUfEAiTBLQ==
X-ME-Sender: <xms:f_3PX57uHuVVnysGIRx5pAftp0LRJJU2NS1BkVdZ7asJ5jodiX27rg>
    <xme:f_3PXxebH8Rv5nMe8LzM8Vyl70tzs-m5UZHxWim0jLy9VecWrx7HFC7RKV-26aRbn
    MmXiOXdwBjz6uhN0ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgudeifecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkgggtugesthdtredttddtvdenucfhrhhomheppfhitghhohhl
    rghsucghrghrfhhivghlugcuoehnihgtkhesnhhkfigrrhhfihgvlhgurdhioheqnecugg
    ftrfgrthhtvghrnhepgfdugfekhefftdekuedukedvheettdehudeugfffgfffjeevgfdu
    udffgffhjeejnecukfhppedutdegrdefgedrleelrdejieenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnihgtkhesnhhkfigrrhhfihgvlhgu
    rdhioh
X-ME-Proxy: <xmx:f_3PX9DAH6ve09LwgWj3DJWtzTYYIFxPsWi0_M50zKZ4PMcXFR7sLA>
    <xmx:f_3PX08uwTBb5YV_OZDVVCgV9TTH-YukttFHFp3nLBdlZD4i7MQ04A>
    <xmx:f_3PX4L_RdOiwlHPronP8CX7SJ1TDAE1yukKOIVf6B76KjM2yPPDcw>
    <xmx:gP3PX3VmchpQn9vAaziq_l7jP4r43dcFVH72q7xC9wSc_gkUXnhKig>
Received: from coffee.localdomain (cpe-104-34-99-76.socal.res.rr.com [104.34.99.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id B490A24005C;
        Tue,  8 Dec 2020 17:26:06 -0500 (EST)
Date:   Tue, 8 Dec 2020 14:25:29 -0800
From:   Nicholas Warfield <nick@nkwarfield.io>
To:     Manish Chopra <manishc@marvell.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        nick@nkwarfield.io
Subject: [PATCH] staging: qlge: remove duplicate word in comment
Message-ID: <X8/9WWP3S1GrVNaa@coffee.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the checkpatch warning:

WARNING: Possible repeated word: 'each'
1712: FILE: qlge.h:1712.h
+ * that are each each 64-bits in length. There are a total of

Signed-off-by: Nicholas Warfield <nick@nkwarfield.io>
---
 drivers/staging/qlge/qlge.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index b295990e361b..0381f3f56bc7 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1709,7 +1709,7 @@ enum {
 #define ETS_REGS_DUMP_WORD_COUNT		10
 
 /* Each probe mux entry stores the probe type plus 64 entries
- * that are each each 64-bits in length. There are a total of
+ * that are each 64-bits in length. There are a total of
  * 34 (PRB_MX_ADDR_VALID_TOTAL) valid probes.
  */
 #define PRB_MX_ADDR_PRB_WORD_COUNT		(1 + (PRB_MX_ADDR_MAX_MUX * 2))
-- 
2.29.2

