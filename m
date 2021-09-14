Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B77240AC6C
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhINL3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:29:34 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:45587 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232187AbhINL3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 07:29:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id CA9865805A9;
        Tue, 14 Sep 2021 07:28:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 14 Sep 2021 07:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Y2MBCAQ2jQEtDQ0uaBisEZ1yTBQijJXAFFk/J1keLdM=; b=TcdhUgun
        sao8WhZwwD5LUlgKT9X4oKHREUfEp1A4XI/rnhXGRW7Y0dFp7dy67z8C6SgUVJ02
        67bCusdBUYooFUjDq9NJZBRiNFb8PYU7ZT7TKqOMZaWaRIHO4S68XN120E2KDgjL
        /NMQ8VvRJewwNnnlI17T2DaCHl5kabxl8offNgbuxExMp5T2JmedNuuwKtLhJDfu
        SP4/XtjeWy7SEkFC2MFxstJ0DCULgdloCV+Xk4ZKNrBxwQ1OTIg2bI67TBfsI3Mr
        VbUekqv+mHHPnoCQs28XPwbJBvh66sJOcA7O/1vBIjzBhB4ZOshaEgfHNnZ4pVIt
        jXwg11dZYEfCZQ==
X-ME-Sender: <xms:TIdAYTTv0RQPoCuabvlwg1u835wd9E7gVNgz_WENZEW9img71CuYSA>
    <xme:TIdAYUytMV4zNNWfxsL2VRu7eYFguFVmDt8BSuaU47ejnpRUv1OYRh4vYX4FENjd7
    ca2LmyTKQdfcZY>
X-ME-Received: <xmr:TIdAYY1pSV4W1tpH15LM5N1E4atcUEHdSS6lXcv7ps6XfFdZWWoyQnvgSkOyTSpEvZSj0IJlJ-RSU1iJg6TREUN8Wnjnyt7_fQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegledgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:TIdAYTAL9vKLlzra9H7B1N7ry5oJhOhclKJBWWH5_c3btNhZWLKcCg>
    <xmx:TIdAYcinU61b9DQwa7clXPCnWGcu3kkxjrNZvDN9iw20giWrwQ3FBg>
    <xmx:TIdAYXq8opLo-EzdbeKYPHMed3Jbir2kOh0vNo-aOwmK8KnZeVsqsg>
    <xmx:TIdAYVXPCW_ekHSTLuijFFtMSLjir-ZdvGyZfq_ntwFDdCuiQME3_Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 07:28:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        vladyslavt@nvidia.com, moshe@nvidia.com, popadrian1996@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool 5/5] netlink: eeprom: Fix compilation when pretty dump is disabled
Date:   Tue, 14 Sep 2021 14:27:38 +0300
Message-Id: <20210914112738.358627-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914112738.358627-1-idosch@idosch.org>
References: <20210914112738.358627-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When pretty dump is disabled (i.e., configure --disable-pretty-dump),
the following errors are emitted:

/usr/bin/ld: netlink/module-eeprom.o: in function `decoder_print':
netlink/module-eeprom.c:330: undefined reference to `sff8636_show_all_paged'
netlink/module-eeprom.c:334: undefined reference to `cmis_show_all'
netlink/module-eeprom.c:325: undefined reference to `sff8079_show_all'

The else clause is unreachable when pretty dump is disabled, so wrap it
with ifdef directive.

This will be re-worked in future patches where the netlink code only
queries the SFF-8024 Identifier Value and defers page requests to
individual parsers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 netlink/module-eeprom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index e9a122df3259..48cd2cc55bee 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -275,6 +275,7 @@ static int page_fetch(struct nl_context *nlctx, const struct ethtool_module_eepr
 	return nlsock_process_reply(nlsock, nomsg_reply_cb, NULL);
 }
 
+#ifdef ETHTOOL_ENABLE_PRETTY_DUMP
 static int decoder_prefetch(struct nl_context *nlctx)
 {
 	struct ethtool_module_eeprom *page_zero_lower = cache_get(0, 0, ETH_I2C_ADDRESS_LOW);
@@ -338,6 +339,7 @@ static void decoder_print(void)
 		break;
 	}
 }
+#endif
 
 int nl_getmodule(struct cmd_context *ctx)
 {
@@ -414,10 +416,12 @@ int nl_getmodule(struct cmd_context *ctx)
 		else
 			dump_hex(stdout, eeprom_data, dump_length, request.offset);
 	} else {
+#ifdef ETHTOOL_ENABLE_PRETTY_DUMP
 		ret = decoder_prefetch(nlctx);
 		if (ret)
 			goto cleanup;
 		decoder_print();
+#endif
 	}
 
 cleanup:
-- 
2.31.1

