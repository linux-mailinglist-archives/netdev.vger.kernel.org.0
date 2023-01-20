Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426A1676178
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 00:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjATXY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 18:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjATXYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 18:24:55 -0500
Received: from rpt-cro-asav2.external.tpg.com.au (rpt-cro-asav2.external.tpg.com.au [60.241.0.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5E3573EE2;
        Fri, 20 Jan 2023 15:24:53 -0800 (PST)
X-IPAS-Result: =?us-ascii?q?A2FAAQCYIctj//EjqMpaHQEBAQEJARIBBQUBSYEyCAELA?=
 =?us-ascii?q?YULjG6JYQGCNIgOMAKHMAOKN4F+DwEDAQEBAQFNBAEBhQaFIyY0CQ4BAQEEA?=
 =?us-ascii?q?QEBAQECBQEBAQEBAQMBAQEFAQIBAQEEBQEBAQKBGYUvRoI4IoQJNgEpHSZcA?=
 =?us-ascii?q?k2CfoJuAQMxrC0FAhaBAZ4ZChkoDWgDgWSBQAGEUlCCE4QoiBOCUYIsgiCCc?=
 =?us-ascii?q?YVQIgSNW4xRAQMCAgMCAgMGBAICAgUEAgEDBAILBQQOAwEBAgIBAQIECAICA?=
 =?us-ascii?q?wMCAggPFQMHAgEGBQEDAQIGBAIEAQsCAgUCAQoBAgQBAgICAQUJAQMBAwELA?=
 =?us-ascii?q?gIGAgIDBQYEAgMEBgICBQIBAQMCAgINAwIDAgQBBQUBAQIQAgYECQEGAwsCB?=
 =?us-ascii?q?QEEAwECBQcBAwcDAgICAggEEgIDAgIEBQICAgECBAUCBwIGAgECAgIEAgEDA?=
 =?us-ascii?q?gQCAgQCAgQDEQoCAwUDDgICAgICAQkLAgMCBwQCAwMBBwICAgEMAQMYAwICA?=
 =?us-ascii?q?gICAgIBAwkKAgQKBAIFAQIBBAsBBQEPAgQBAgICAgIDAgEBAwcIAQUDCwIHB?=
 =?us-ascii?q?AICAwMGCQ8EBQoZAwMCIAMJAwcFSQIJAyMPAwsJCAcMARYoBgMBCgcMJQQED?=
 =?us-ascii?q?CgBCgwHBQECAgEHAwMFBQIHDgMEAgEDAwIFDwMBBgUBAgECAgIEAggCBAUCB?=
 =?us-ascii?q?QMCBAIDAgIIAwIDAQIBBQQDBAEEAgQDDQQDBAIDAgIFAgICAgIFAgIDAQICA?=
 =?us-ascii?q?gICAgUCAwIBBQECAgECAgIEAQICBwQCAwEDBA4EAwICBwECAgEGAgcDAQIBB?=
 =?us-ascii?q?AMBAQQCBAECBQIEAQMGAgMBAwoCAwIBAQIDAwUDAgIICAIDBQIEAQECBAMEA?=
 =?us-ascii?q?gILAQYCBwICAwICBAQEAQECAQQFAgMBAgMDCQICAwIEAgIKAQEBAQIBBwIEB?=
 =?us-ascii?q?QYCBQICAgMBAgIBAwIBAgIKEQEBAgMDAwQGBQMDAwEVBQIBAQICAwMCBgIBA?=
 =?us-ascii?q?ggCBAEEBQIBAgEBAgIEAQMGAgIBAQECAQICAQMCAQICAgQDAwECAQICAwICA?=
 =?us-ascii?q?gMCAgENAgYGAQICAgICAgICAgYBAgECAwECBwIEAwIBAgIFAgICAwEBBgIEC?=
 =?us-ascii?q?wEDAgICAgEIAQECBQECAgIDAQMDBAMDBQYDAgwIAQUBAwEfAwICCAIHAgEFA?=
 =?us-ascii?q?wMCAQ8DAgIDAgIBBAoCAwUCBAIBBAgHAgQBAgkDAgYCBgUYAQICBwQMCgECA?=
 =?us-ascii?q?gUGBAEBAgICAQECAwMCAwIEBQEFAgECBAICAgEBAgUNAQEDBAIEAgcCAgIDA?=
 =?us-ascii?q?QQCAQIBAwMCAwEBAQMGBgIEBAIDAwcCAgMBAQECAgMEDQEFAgIGAwQBDQUGB?=
 =?us-ascii?q?QQDAggBAgEBBwIEAgcJDgIBAgQBBQICAwICAQMCAgECBAMBAgICAgUHBQMEA?=
 =?us-ascii?q?QQDCgkDAQEEAwIBAgECAwIDBwMCBAIDAQIDBAYGAQkEBgQBDQMEAgIBAgEBA?=
 =?us-ascii?q?wQEBAICAQICAwEEAgIBAQMDAwICAgMEAgMDCwQKBwMDAgEFCwICAgMCAQEDB?=
 =?us-ascii?q?wQFBAICBgECBAICAgICAgIDAQEDCgQCAQMCAgQDBgIBAgEJBQIBCQMBAgEDB?=
 =?us-ascii?q?AEDCQECAgQJAgMHBQoCAgICCAICDgMDAgEBBAICBAMCCQECBwIFAQEDBQcCA?=
 =?us-ascii?q?gECAgEEAwEJBAECAwIBAQMSAwMBBAIFAwMNCQYCAgEDAgENAwECAQIDAQUFF?=
 =?us-ascii?q?wMIBxQDBQICBAQBBwICAwMDAgECCQYBAwEFAg4DAgIEBAIBAgEBAgMQAgMBA?=
 =?us-ascii?q?QEBFwEDBAIDAQQDAQECAQIDAg4EAQQFDAMBAhEMAgQBBgIIAgICAgMBAgMFA?=
 =?us-ascii?q?QIDBAIBCAYEAgICAgoCCgMCAwEDBQEDAgkDAQUBAgcCBgEBAQICCAIIAgMLA?=
 =?us-ascii?q?QMCAwYCAQICAQUCAQICBQMFAgICAgQNAgUCAgIGAQIHBAICAgMBAgIGAgUBA?=
 =?us-ascii?q?gcHAgUCAgIDAwoEBAIKBAEDAQEFAQIBAwQBAgQBAgECBQMGAgICAgECAgECA?=
 =?us-ascii?q?QEIAgICAgICAgMEAgUDnn0BYiuBMXiBUAEBlHOsNUQhCQEGAluBV30aKZpih?=
 =?us-ascii?q?W0aMqkqLZcekTqRHIVugS2CFk0jgQFtgUlSGQ+dBGE7AgcLAQEDCYwjAQE?=
IronPort-PHdr: A9a23:UiwpshI+hBGohu82DNmcuCBhWUAX0o4c3iYr45Yqw4hDbr6kt8y7e
 hCFuLM01QSCBdWTwskHotSVmpioYXYH75eFvSJKW713fDhBt/8rmRc9CtWOE0zxIa2iRSU7G
 MNfSA0tpCnjYgBaF8nkelLdvGC54yIMFRXjLwp1Ifn+FpLPg8it2O2+5Z3ebx9ViDagb75+I
 wm6oAbMvcQKnIVuLbo8xRTOrnZUYepd2HlmJUiUnxby58ew+IBs/iFNsP8/9MBOTLv3cb0gQ
 bNXEDopPWY15Nb2tRbYVguA+mEcUmQNnRVWBQXO8Qz3UY3wsiv+sep9xTWaMMjrRr06RTiu8
 6FmQwLuhSwaNTA27XvXh9RwgqxFvh+vuhJxzY3Tbo6aO/RzZb/RcNAASGZdRMtdSzBND4WhZ
 IUPFeoBOuNYopH5qVsJqxu1GA6iC/ngyz5GmHD22ak62PkmHAHE2QwvBd0PsXrKo9XxMKcfX
 +K4wbLHzTXGdfxW2DP95JLUfRAmpPGBRLR9etfexkczDQ3KlEmQqZD7MDOP0OQAq2iW4epuW
 O+yiGMppQF/rzety8syhYTEm5wZx07A+Ch53os4Od21RUF0b9K5H5Vdtj2WO5Z4T80tTG9lu
 Sk0x74AtJWmfyYK0IwqywDDZ/CZaYSE/xPuWeWLLTp2hH9pYqyzihmv/UWm1+byTNO70ExQo
 SpAitTMs3cN2AHN5cWfUft9+1uh2S6I1wDO9uFIOUA0mrTfK54m2rMwlJ8Tvl7MHy74hkr2i
 KuWel8++ue27uTnZanmqYGGO4BokQHxKbwims25AesmLggDR3aX9fii2LH54EH0QbZHguc4n
 6TZqpzWO8sWqrOhDw9QyIkj6hK/Dzm80NQfmHkKNFBFeBedgInmNVDBPvT4DfOxjlmuizpry
 PXGMafgApXJNHTMjLDhfbNl505a0wU81cpf6I5MCrEdPPLzXVf8uMHXAxMhKQy73/7nCMlh1
 oMZQW+AH7WWML3Mvl+N/e8gPvODZJELtzb4L/gl4PDujWMjlV8bY6apwYMbaGqkEfR+P0WZf
 X3sj88fHmgXowo+SfbliVycXj5PfHuyUKU85jY0CIKiE4jPXJyigLuE3CujBJ1ZenhGCkyQE
 Xfvb4iEWOoMZzmILcJ6kTwLS6KhS4k/2hGqrgP6zKBnLuXM9i0CqZ3jzMR15/HUlRwq7Tx7F
 d+S3H+LT2F1hW4IXSE5071/oUNn1lePy7R3g/tdFdBL/fNGTh86NYLAz+x9E93zWgXBfsyJS
 FaoX9WmAzAxQ8k1w98PZUZ9BtqjggnC3yqyHb8YlqaHBJsu8qLTjDDNIJNxwmjL0YEthkcrR
 89IO3HggKNjpCbJAIucsUKf34OjZbsR2CqFoGWGxHqRsUVcC1FYXqDMXHRZbUzT+4eqrnjeR
 qOjXOx0ejBKztSPf/MiVw==
IronPort-Data: A9a23:3tQR66jF9bYdxHFZcY3Y35ytX161FRAKZh0ujC45NGQN5FlHY01je
 htvUGCOOviLYGDwKo1yatnj8h5U7ZGGyNAyTAQ4+SEwFi8W8JqUDtmwEBz9bniYRiHhoOOLz
 Cm8hv3odp1coqr0/0/1WlTZhSAgk/vOH9IQMcacUghpXwhoVSw9vhxqnu89k+ZAjMOwa++3k
 YqaT/b3ZRn0hFaYDkpOs/jY8Eo15Kyp0N8llgVWic5j7Ae2e0Y9Ucp3yZGZdxPQXoRSF+imc
 OfPpJnRErTxpkpF5nuNy94XQ2VSKlLgFVHmZkl+AsBOtiN/Shkaic7XAha+hXB/0F1ll/gpo
 DlEncDrE19xZsUgksxFO/VTO3kW0aGrZNYriJVw2CCe5xSuTpfi/xlhJB8MIMof+/dUOn1h1
 vM+chIWbimumO3jldpXSsE07igiBMvuNZMAt3VkiyvUCPE6TNbIWK+iCd1whm9qwJkQTbCFO
 oxDNWMHgBfoOnWjPn8VDZsug+qsgiKgWzJdoVOR46Ew5gA/ySQrjOK1aoCPIIfiqcN9vlrDm
 TifoGbDDS4gG+2Pkjuk42zzibqa9c/8cMdIfFGizdZmiUOew0QfAQMbUF+8r+X/jEOiM/pSJ
 1ER8zgjsYA980ukStS7VBq9yFaHoxQVc9ldCes37EeK0KW8yx6QDGUCTxZbZdAmvdNwTjsvv
 neYmMjpCyFtsZWRSHSA5vKVtS3sfy8PIgcqaTQNTQYf5fHgrZs1gxaJScxseIawh8fpGDe2x
 zmXhCsznbMeiYgMzarT1VLAjjaEpJ/ESgA4/APeWG6o9UV+foHNT5Sh9Fze5vVoL4uDSFSF+
 n8elKC24fEHCdeHlTaCTf8lE7Sg5vLDOzrZ6XZpEoUt+iqF5XGuZ8ZT7St4KUMvNdwLERftY
 UnOqUZS6YVVMX+Cc6B6ecSyBt4swKymEs7qPtjdaNZUb5E3cQaW8TtGeEiRxWfomRJqkL1XE
 ZWeeNazAHIeUvtPwz+/RuNb2rgurh3S3kuJHcq+lkr3lOHDISTJEPEZKFSPKOs+6eWNvW057
 upiCidD8D0HOMWWX8Ud2dN7wYwiRZTwOXw6RwG7uAJOzsqK1VzN08Ps/I4=
IronPort-HdrOrdr: A9a23:PSRT6a6fId5McRt0yQPXwNPXdLJyesId70hD6qkXc203TiX4ra
 CTdZsgvyMc5Ax9ZJhCo7G90cu7Lk80nKQdieIs1NyZMjUO1lHFEGgY1/qB/wHd
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.97,233,1669035600"; 
   d="scan'208";a="242022223"
Received: from 202-168-35-241.tpgi.com.au (HELO jmaxwell.remote.csb) ([202.168.35.241])
  by rpt-cro-asav2.external.tpg.com.au with ESMTP; 21 Jan 2023 10:23:51 +1100
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, martin.lau@kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, eyal.birger@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it, Jon Maxwell <jmaxwell37@gmail.com>
Subject: [net-next v4] ipv6: Document that max_size sysctl is deprecated
Date:   Sat, 21 Jan 2023 10:23:31 +1100
Message-Id: <20230120232331.1273881-1-jmaxwell37@gmail.com>
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

v4: fix deprecated typo.

Document that max_size is deprecated due to:

commit af6d10345ca7 ("ipv6: remove max_size check inline with ipv4")

Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 7fbd060d6047..4cc2fab58dea 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -156,6 +156,9 @@ route/max_size - INTEGER
 	From linux kernel 3.6 onwards, this is deprecated for ipv4
 	as route cache is no longer used.
 
+	From linux kernel 6.3 onwards, this is deprecated for ipv6
+	as garbage collection manages cached route entries.
+
 neigh/default/gc_thresh1 - INTEGER
 	Minimum number of entries to keep.  Garbage collector will not
 	purge entries if there are fewer than this number.
-- 
2.31.1

