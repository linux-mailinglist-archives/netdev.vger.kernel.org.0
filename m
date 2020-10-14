Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7C428E144
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 15:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgJNN1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 09:27:42 -0400
Received: from smtp16.mail.ru ([94.100.176.153]:41150 "EHLO smtp16.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgJNN1m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 09:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail3;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=UEPi228wc92uoYP7+qr8qoUQaS6XHP6p2o3ilsefCp8=;
        b=KVH3V5k60N6jb3g7yla6elhXTlbXL45N1ZdhuyQt9oUCo7TRSVhqBa4hVBN5PWnx2DW2sVLv2ODN7ThsI0fyq5ZED6gitPT5vdCsOj/FEpPrbxIHZUyG3lV+Vx5fsAr0znaS1XJkoTiZKJyZRT9lPyrgivi6JGVfMaIeNqPrZBA=;
Received: by smtp16.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1kSgoc-0003w7-Hz; Wed, 14 Oct 2020 16:27:38 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 1/1] net: dsa: seville: the packet buffer is 2 megabits, not megabytes
Date:   Wed, 14 Oct 2020 16:27:43 +0300
Message-Id: <20201014132743.277619-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp16.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9E98D729206725230F4632E9A98CB8CA8E37E55D9B858C896182A05F5380850402CA73531FC7C81B33F2413D4F223D6E2E299247CB42F472F1B90157251FCE45A
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7544B1CCE26E01C74EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637FACF2191C0719DEE8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC3E59DFB0D167DDD5F434B1A626F5108DF6A57006690A4523389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C0B27420F9988F54058941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C3ED8438A78DFE0A9E117882F4460429728AD0CFFFB425014E592AE0A758652A3D76E601842F6C81A19E625A9149C048EEC8105B04EFE076281C9461EB66F04EBFD8FC6C240DEA76429449624AB7ADAF37B2D370F7B14D4BC40A6AB1C7CE11FEE3C824672CB62AFFF2302FCEF25BFAB345C4224003CC8364767A15B7713DBEF166A7F4EDE966BC389F9E8FC8737B5C2249A74BC3EA3CC982DF089D37D7C0E48F6CCF19DD082D7633A0E7DDDDC251EA7DABAAAE862A0553A39223F8577A6DFFEA7C304C8BA14588C48243847C11F186F3C5E7DDDDC251EA7DABCC89B49CDF41148FA8EF81845B15A4842623479134186CDE6BA297DBC24807EABDAD6C7F3747799A
X-C8649E89: 56E9B64B03B7C869D942D287BFB1DF2ECE028E36DF9F12111B5C02BBA25BFC995E41AAE8B1B653A6
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojwfNTBk2YwQHaxzq9zm1fiA==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB2428913D1A142C65B8B7BD59305098989B60094B85DEC50F7BEE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC9953 Seville switch has 2 megabits of buffer split into 4360
words of 60 bytes each. 2048 * 1024 is 2 megabytes instead of 2 megabits.
2 megabits is (2048 / 8) * 1024 = 256 * 1024.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Fixes: a63ed92d217f ("net: dsa: seville: fix buffer size of the queue system")
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 9e9fd19e1d00..e2cd49eec037 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1010,7 +1010,7 @@ static const struct felix_info seville_info_vsc9953 = {
	.vcap_is2_keys		= vsc9953_vcap_is2_keys,
	.vcap_is2_actions	= vsc9953_vcap_is2_actions,
	.vcap			= vsc9953_vcap_props,
-	.shared_queue_sz	= 2048 * 1024,
+	.shared_queue_sz	= 256 * 1024,
	.num_mact_rows		= 2048,
	.num_ports		= 10,
	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
--
2.27.0
