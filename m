Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9F827CEF9
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgI2NWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbgI2NWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:22:11 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A4D5208FE;
        Tue, 29 Sep 2020 13:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601385730;
        bh=b6cNApJ71KWPFc5afyfOtv/DriRF4+QdFvR4tXA/rRE=;
        h=Date:From:To:Cc:Subject:From;
        b=Hw9EXKwIQHqyXWnMuNwl2HnhlaciWu33MQho6DnCf61yEgql855tpWl7PbGpFTpBa
         LAAOdfkEBhDoCfR+4Sl7ILZ4JSA9f/UpX6+CfaT0xs/Bqx2TsagshlaeK0+zek9S3b
         C4AevuEmq/9XcIpljcc08FfZpguHroei45R1vrr0=
Date:   Tue, 29 Sep 2020 08:27:51 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] fddi/skfp: Avoid the use of one-element array
Message-ID: <20200929132751.GA29220@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One-element arrays are being deprecated[1]. Replace the one-element array
with a simple object of type u_char: 'u_char rm_pad1'[2], once it seems
this is just a placeholder for padding.

[1] https://www.kernel.org/doc/html/v5.9-rc1/process/deprecated.html#zero-length-and-one-element-arrays
[2] https://github.com/KSPP/linux/issues/86

Built-tested-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/5f72c23f.%2FkPBWcZBu+W6HKH4%25lkp@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/fddi/skfp/h/smc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/h/smc.h b/drivers/net/fddi/skfp/h/smc.h
index 991857f6a83c..706fa619b703 100644
--- a/drivers/net/fddi/skfp/h/smc.h
+++ b/drivers/net/fddi/skfp/h/smc.h
@@ -122,7 +122,7 @@ struct s_rmt {
 	u_char timer1_exp ;		/* flag : timer 1 expired */
 	u_char timer2_exp ;		/* flag : timer 2 expired */
 
-	u_char rm_pad1[1] ;
+	u_char rm_pad1;
 } ;
 
 /*
-- 
2.27.0

