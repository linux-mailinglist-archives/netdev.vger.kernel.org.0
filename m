Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3238292213
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 07:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgJSFGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 01:06:08 -0400
Received: from smtp50.i.mail.ru ([94.100.177.110]:58992 "EHLO smtp50.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgJSFGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 01:06:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail3;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=BXTaUBQNlMDZgmvmEJTTxq5QjfesDSI192hntm7w5W0=;
        b=N1E3tzKfw+fUrojgm2HnuZtR7Tw1m8L4BGHJuEsMiB8nPX+HN0UgMu6TYGlUqdbnIkNKznWiLRS6Hc4reMDPlD4TV4Wqiu7RO9OhDGyjJZiADon1VkGrwuFDEbetmAqHfy/gl//hEvz+cHuvq4RcMIc4Hn7OqzPSEu40eXY3eQs=;
Received: by smtp50.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1kUNMy-0007J4-AN; Mon, 19 Oct 2020 08:06:04 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v4] net: dsa: seville: the packet buffer is 2 megabits, not megabytes
Date:   Mon, 19 Oct 2020 08:06:25 +0300
Message-Id: <20201019050625.21533-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp50.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9E98D72920672523073C8E603BFC46BCB7CA76E629226B169182A05F538085040176D44483BC12988060B5EE486DFC3DAE199F9F6A81E0294FF887870AEEAEE28
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE72E4E5201E1C2E308EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F790063716A4A39B750036BB8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC6F3A0D60C54BEF5F37DC2421EE8A0202DB4588BE88252EB7389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C02F11D39E7306DD338941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C327ED053E960B195E117882F4460429728AD0CFFFB425014E592AE0A758652A3D76E601842F6C81A19E625A9149C048EE902A1BE408319B29EA93887B71B66F2BD8FC6C240DEA76429449624AB7ADAF37B2D370F7B14D4BC40A6AB1C7CE11FEE37C7DAE56957A78C8302FCEF25BFAB345C4224003CC8364767A15B7713DBEF166A7F4EDE966BC389F9E8FC8737B5C22493E1A6EFE1E551EE8089D37D7C0E48F6CCF19DD082D7633A0E7DDDDC251EA7DABAAAE862A0553A39223F8577A6DFFEA7C9CE98F2F28ED12C043847C11F186F3C5E7DDDDC251EA7DABCC89B49CDF41148FA8EF81845B15A4842623479134186CDE6BA297DBC24807EABDAD6C7F3747799A
X-C8649E89: B8C3AB898BF6DBE79BE47974967AB252CDEAA1D6D635C0FCFD2A454D30892B09E3D94FCD835E4469
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojC0nGpAkmluYkNRJlPKTH2w==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB245DDCC623EF77559472539640D29D35BDF32E1261470A5294EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC9953 Seville switch has 2 megabits of buffer split into 4360
words of 60 bytes each. 2048 * 1024 is 2 megabytes instead of 2 megabits.
2 megabits is (2048 / 8) * 1024 = 256 * 1024.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Fixes: a63ed92d217f ("net: dsa: seville: fix buffer size of the queue system")
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 76576cf0ba8a..1d420c4a2f0f 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1181,7 +1181,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.stats_layout		= vsc9953_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9953_stats_layout),
 	.vcap			= vsc9953_vcap_props,
-	.shared_queue_sz	= 2048 * 1024,
+	.shared_queue_sz	= 256 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
-- 
2.27.0

