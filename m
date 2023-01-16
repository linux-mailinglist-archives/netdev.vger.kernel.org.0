Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A9E66B4EF
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 01:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbjAPAWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 19:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjAPAWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 19:22:36 -0500
Received: from rpt-cro-asav3.external.tpg.com.au (rpt-cro-asav3.external.tpg.com.au [60.241.0.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34C001350F;
        Sun, 15 Jan 2023 16:22:33 -0800 (PST)
X-IPAS-Result: =?us-ascii?q?A2EQGgBDmMRj//EjqMpaHQEBPAEFBQECAQkBHoFGAoUKl?=
 =?us-ascii?q?k8BgjSIDjAChzCKOoF+DwEDAQEBAQEdAS8EAQGFBoUZJjQJDgEBAQQBAQEBA?=
 =?us-ascii?q?QIFAQEBAQEBAwEBAQUBAgEBAQQFAQEBAoEZhS9GgjgihAk2ASkdJlwCTYJ+g?=
 =?us-ascii?q?m4BAzGuDwUCFoEBnhkKGSgNaAOBZIFAAYRSUIIThCiIE4JRgiyCIIJxhU8iB?=
 =?us-ascii?q?I09jEIBAwICAwICAwYEAgICBQMDAgEDBAIOBA4DAQECAgEBAgQIAgIDAwICC?=
 =?us-ascii?q?A8VAwcCAQYFAQMBAgYEAgQBCwICBQIBCgECBAECAgIBBQkBAgMBAwELAgIGA?=
 =?us-ascii?q?gIDBQYEAgMEBgICBQIBAQMCAgINAwIDAgQBBQUBAQIQAgYECQEGAwsCBQEEA?=
 =?us-ascii?q?wECBQcBAwcDAgICAggEEgIDAgIEBQICAgECBAUCBwIGAgECAgIEAgEDAgQCA?=
 =?us-ascii?q?gQCAgQDEQoCAwUDDgICAgICAQkLAgIDAgcEAgMDAQcCAgIBDAEDHQMCAgICA?=
 =?us-ascii?q?gICAQMJCgIECgIEAgYCAgQEDAEFAQQHBAUKGQMDAiADCQMHBUkCCQMjDwMLC?=
 =?us-ascii?q?QgHDAEWKAYDAQoHDCUEBAwoAQoMBwUBAgIBBwMDBQUCBw4DBAIBAwMCBQ8DA?=
 =?us-ascii?q?QYFAQIBAgICBAIIAgQFAgUDAgQCAwICCAMCAwECAQcEAwQBBAIEAw0EAwQCA?=
 =?us-ascii?q?wICBQICAgICBQICAwECAgICAgIFAgMCAQUBAgIBAgICBAECAgcEAgMBAwQOB?=
 =?us-ascii?q?AMCAgcBAgIBBgIHAwECAQQDAQEEAgQBAgUCBAEDBgIDAQMKAgMCAQECAwMFA?=
 =?us-ascii?q?wICCAgCAwUCBAEBAgQDBAICCwEGAgcCAgMCAgQEBAEBAgEEBQIDAQIDAwkCA?=
 =?us-ascii?q?gMCBAICCgEBAQECAQcCBAUGAgUCAgIDAQICAQMCAQICChEBAQIDAwMEBgUDA?=
 =?us-ascii?q?wMCARUFAgEBAgIDAwIGAgECCAIEAQQFAgECAQECAgQBCAICAQEBAgECAgMDA?=
 =?us-ascii?q?gECAgIEAwMBAgECAgMCAgIDAgIBDQIGBgECAgICAgICAgIGAQIBAgMBAgcCB?=
 =?us-ascii?q?AMCAQICBQICAgMBAQYCBAsBAwICAgIBCAEBAgUBAgICAwEDAwQDAwUGAwIMC?=
 =?us-ascii?q?AEFAQMBHwMCAggCBwIBBgMCAQ8DAgIDAgIBBAoCAwUCBAIBBAgHAgQBAgkDA?=
 =?us-ascii?q?gYCBgUYAQICBwQMCgECAgUGBAEBAgMBAgEBAgMDAgMCBAUBBQIBAgQCAgIBA?=
 =?us-ascii?q?QIFDQEBAwQCBAIHAgICAwEEAgECAQMDAgMBAQEDBgYCBgQCAwMHAgIDAQICA?=
 =?us-ascii?q?wQNAQQCAgYDBAENBQYFBAMCCAECAQEHAgQCBwkOAgECBAEFAgIDAgIBAwICA?=
 =?us-ascii?q?QIEAwECAgICBQcFAwQBBAMKCQMBAQQDAgECAQIDAgMHAwIEAgMBAgMEBgYBC?=
 =?us-ascii?q?QQGBAENAwQCAgECAQEDBAQEAgIBAgIDAQQCAgEBAwMDAgICAwQCAwMLBAoHA?=
 =?us-ascii?q?wMCAQULAgICAwIBAwcEBQQCAgYBAgQCAgICAgICAwEBAwoEAgEDAgIEAwYCA?=
 =?us-ascii?q?QIBCQUCAQkDAQIBAwQBAwkBAgIECQIDBwUKAgICAggCAg4DAwIBAQQCAgQDA?=
 =?us-ascii?q?gkBAgcCBQEBAwUHAgIBAgIBBAMBCQQBAgMCAQEDEgMDAQQCAgUDAw0JBgICA?=
 =?us-ascii?q?QMCAQ0DAQIBAgMBBQUXAwgHFAMFAgIEBAEHAgIDAwMCAQIJBgEDAQUCDgMCA?=
 =?us-ascii?q?gMDBAIBAgEBAgMQAgMBAQEBFwEDBAIDAQQDAQECAQIDAg4EAQQFDAMBAhEMA?=
 =?us-ascii?q?gQBBgIIAgICAgMBAwMFAQIDBAIBCAYEAgICAgoCCgMCAwEDBQEDAgkDAQUBA?=
 =?us-ascii?q?gcCBgEBAQICCAIIAgMLAQMCAwYCAQICAQUCAQICBQMFAgICAgQNAgUCAgIGA?=
 =?us-ascii?q?QIHBAICAgMBAgIGAgUBAgcHAgUCAgIDAwoEBAIKBAEDAQEFAQIBAwQBAgQBA?=
 =?us-ascii?q?gECBQMGAgICAgECAgECAQEIAgICAgICAgMEAgUDnkIBYiuBMXiBUAEBlHGsN?=
 =?us-ascii?q?UQhCQEGAluBV30aKZphhW0aMqkqLZcekTiRG4VugS2CFk0jgQFtgUlSGQ+dB?=
 =?us-ascii?q?GE7AgcLAQEDCYwjAQE?=
IronPort-PHdr: A9a23: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
IronPort-Data: A9a23:8PK1eqoTYJGc6DQqtgVRbvYa2HteBmJ0ZRIvgKrLsJaIsI4StFCzt
 garIBmGPfzeNjSmKtB0Odyy90NX7ZPWy98xSAQ4q3xjRSpHopacVYWSI27OZC7DdceroGCLT
 ik9hnssCOhuExcwcz/0auCJQUFUjP3OHPylYAL9EngZbRd+Tys8gg5Ulec8g4p56fC0GArlV
 ena+qUzA3f4nW8rWo4ow/jb8kg35a2v4GlwUmEWPJingneOzxH5M7pCfcldH1OgKqFIE+izQ
 fr0zb3R1gs1KD90V7tJOp6iGqE7aua60Tqm0xK6aID76vR2nRHe545gXBYqheW7vB3S9zx54
 I0lWZWYFVxzZvWU8AgXe0Ew/ypWZcWq9FJbSJQWXAP6I0DuKhPRL/tS4E4eB50S2fZqMFl0/
 qIBEDkfQDyHouys3+fuIgVsrpxLwMjDPoYWqm5tyTWfBvEjKXzBa/+Sv5kBgmd23Z0IR6qHD
 yYaQWMHgBDoYRhGKkgaDJZlw8+ng3D+d3tTr1f9Sa8fuTGDl1ItgeeyWDbTUsXaePtnhHydm
 lzL4mL9Ohw0Ct+jmQPQpxpAgceKx0sXQrk6GLSm+/tCjFSNy2kXDxMKE122vZGRh0KjXttNJ
 lA89S0poqw/skesS7HVXACyqVaHswQaVt4WFPc1gCmVw6DZ5QexHGUITjddLtchsaceVDsx1
 lGUndLBAT1pra3QSGqDqPGTtzzaESQOJG8PfyksTgYf5dTn5oYpgXrnS995DK+zyNn8BBnzz
 iqMoSx4gK8c5eYJ0Ki/1VLAjjaiq4LPRwg56x6RWXiqhithbZOhYoerwVvW9/BNKMCeVFbpl
 HUVkszY5uEUApyXvCOISeQJWrqu4p6tNjDAjVNxN4cu+i7r+HO5e41UpjZkKy9BNscCZC+sY
 0LJvw5VzIFcMWHsbqJtZY+1TcMwwsDIHNLpTP3dKN9Hc5VrXBKB/TtpYEfKmWHx+GAulKgvJ
 pqfdZ3zJXkfAKVjijGxQo8gPaQDnHhkgDqNFdWgklH9jePYeGaaSPEON17IZ/1RAL64nTg5O
 u13b6OioyizmsWkCsUL2eb/5mzm4ZT26V4aZiCXmiO+ztJaJVwc
IronPort-HdrOrdr: A9a23:mab1GaojTg0QTSRwgcH5pJcaV5oyeYIsimQD101hICG9vPb0qy
 nIpoV56faaslkssR0b8uxoW5PhfZqjz/BICOAqVN+ftWLd1FdAQrsJ0WKb+VzdJxE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.97,219,1669035600"; 
   d="scan'208";a="218364977"
Received: from 202-168-35-241.tpgi.com.au (HELO jmaxwell.com) ([202.168.35.241])
  by rpt-cro-asav3.external.tpg.com.au with ESMTP; 16 Jan 2023 11:22:32 +1100
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, martin.lau@kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, eyal.birger@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it, Jon Maxwell <jmaxwell37@gmail.com>
Subject: [net-next] ipv6: Document that max_size sysctl is depreciated
Date:   Mon, 16 Jan 2023 11:21:57 +1100
Message-Id: <20230116002157.513502-1-jmaxwell37@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,
        SPOOF_GMAIL_MID autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document that max_size is depreciated due to:

af6d10345ca7 ipv6: remove max_size check inline with ipv4

Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 7fbd060d6047..edf1fcd10c5c 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -156,6 +156,9 @@ route/max_size - INTEGER
 	From linux kernel 3.6 onwards, this is deprecated for ipv4
 	as route cache is no longer used.
 
+	From linux kernel 6.2 onwards, this is deprecated for ipv6
+	as garbage collection manages cached route entries.
+
 neigh/default/gc_thresh1 - INTEGER
 	Minimum number of entries to keep.  Garbage collector will not
 	purge entries if there are fewer than this number.
-- 
2.31.1

