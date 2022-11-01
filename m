Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243106151AB
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 19:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiKASkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 14:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiKASkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 14:40:24 -0400
Received: from mx0a-003ede02.pphosted.com (mx0a-003ede02.pphosted.com [205.220.169.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C721C101
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 11:40:22 -0700 (PDT)
Received: from pps.filterd (m0286614.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A1IeMn5032280
        for <netdev@vger.kernel.org>; Tue, 1 Nov 2022 11:40:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=ppemail; bh=TZN+nxD29A/mXjM1cTiRY1RyYzHigm/eAkBELU0CF14=;
 b=cA1YNKo/ElUALFXNlrUwD6xNYLkdcvPsSFHRoO2j+Sxr4kjnhmsTxvg+SQdWZRChz23a
 jLbdnQqTw2liZyaBf/sY0l4BgNCIh0GalmwcMfcpdE1soBTtdsXjVvq/+SkVXr5nm0Vi
 8994I0gZvevUECKneatLKdq0U187exSiKd00VTNfnczLKg3+zeOpXF/wUPQ6d11pjL+F
 CMjdw564Zf/6zTm3Nsu2p3CvlFLfOtTxlR9YrT5sVW71jgijsycHfGDG3OrrXrnBVbKN
 uvAbH9wukxpb/rOoIUT1xzR4pkJUs7ZCUUhaldXbX1KsvL/pJuLd07DNm8c7uhauoGBF 9g== 
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3kh16drub7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 11:40:22 -0700
Received: by mail-pl1-f200.google.com with SMTP id a6-20020a170902ecc600b00186f035ed74so10423440plh.12
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 11:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TZN+nxD29A/mXjM1cTiRY1RyYzHigm/eAkBELU0CF14=;
        b=kaNealaoGmf/RrPO8DwyZR6T+/tcWXGyYzK0SKjEnxcfOEiA8sRNfFOhnHZrSh7vND
         nbhi/gbGEhsSa2dR2Y11RXiYJlIpioQm1Vr7rWlxlmr+J857hqo32unyVe70tTeY86gY
         TJuhJDjpLlxMC+SZYzLr8o3qb2edlQvoGSKCX0DCCWxplz4NSdXmwBTSbHjiYiVqGnxL
         lq+ggrQ8+MSmiF6Ri/gNLJmNRFU60IPDxIhhVFL3Z9GdL5bjMtT9nenL5BXEfALwqfn6
         9uPoNkRhhkLyGOdI1/xqvohu3un7pjjoDE1mOPBSLWHf3wQwh6aErszAED4AQ7/7YjTc
         F71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TZN+nxD29A/mXjM1cTiRY1RyYzHigm/eAkBELU0CF14=;
        b=59T8Dy5usQuW7dSln+Tyh5jclOe6OaiC0P24PwmB5UflhMpVsWzx26W1aCb0ixcN0A
         ZYFL+IRuQLIOt38RC//ZNc4fGfvf1KPg5UEXTGgZHdoAbWcWBrBxKsilDTNcqXj9iY0B
         ahCnQ8AIcZTXbYGZh7qoiOdN96C54IMyBjYS/lgVUU3NPPSGLWJMJTQeclq/5N1mL/fE
         BaqN3ebRfgGldCLNOoe6C4vXRHerswX5hvIHlp4zS6qSHr62QC7y95JXlFMitnqPLE2B
         b+tqEP4gPlwIWOQD1pUPEI9llNkOAtypshAwmcJfC/XpKyxQluBJjaa6bbOjG2paB4ia
         1I+A==
X-Gm-Message-State: ACrzQf1ehRSBiv4bdcNom0y02qYG4mxLi4c+TA7qOtF/rZ+bekhNTvPk
        fQSfcu3gxykUWPPrT4FN+rJ7trb5AVkOqq+s2/IomJdkpASv7X4BskbAlNwAM8LuxADPKy3KwSI
        DC/+4lBnurUi/dFg=
X-Received: by 2002:a62:a503:0:b0:56b:cb10:2d87 with SMTP id v3-20020a62a503000000b0056bcb102d87mr21167771pfm.79.1667328021237;
        Tue, 01 Nov 2022 11:40:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4h7sjO7Pjd4/m+pe8D/lAg5yb26iD2UghyFQ1kUHbRrOa+BOyWQ+jEHR/N6AJpCu1UVjrmoA==
X-Received: by 2002:a62:a503:0:b0:56b:cb10:2d87 with SMTP id v3-20020a62a503000000b0056bcb102d87mr21167747pfm.79.1667328020908;
        Tue, 01 Nov 2022 11:40:20 -0700 (PDT)
Received: from 4VPLMR2-DT.corp.robot.car ([199.73.125.241])
        by smtp.gmail.com with ESMTPSA id l6-20020a622506000000b0056c08c87196sm6851935pfl.48.2022.11.01.11.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 11:40:20 -0700 (PDT)
From:   Andy Ren <andy.ren@getcruise.com>
To:     netdev@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        roman.gushchin@linux.dev, Andy Ren <andy.ren@getcruise.com>
Subject: [PATCH net-next] netconsole: Enable live renaming for network interfaces used by netconsole
Date:   Tue,  1 Nov 2022 11:40:05 -0700
Message-Id: <20221101184005.1278860-1-andy.ren@getcruise.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 3QvTYIK5OSS6OCaRqsv46SgWWHAtkqGm
X-Proofpoint-GUID: 3QvTYIK5OSS6OCaRqsv46SgWWHAtkqGm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_09,2022-11-01_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211010135
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables support for live renaming of network interfaces
initialized by netconsole.

This resolves an issue seen when netconsole is configured to boot as a
built-in kernel module with a kernel boot argument. As stated in the
kernel man page - As a built-in, netconsole initializes immediately
after NIC cards and will bring up the specified interface as soon as
possible. Consequently, the renaming of specified interfaces will fail
and return EBUSY. This is because by default, the kernel disallows live
renaming unless the device explicitly sets a priv_flags bit
(IFF_LIVE_RENAME_OK), and renaming after a network interface is up
returns EBUSY.

The changes to the kernel are as of following:

- Addition of a iface_live_renaming boolean flag to the netpoll struct,
used to enable/disable interface live renaming. False by default
- Changes to check for the aforementioned flag in network and ethernet
driver interface renaming code
- Adds a new optional "*" parameter to the netconsole configuration string
after interface device name that enables interface live renaming when
included (e.g. "eth0*"). When this parameter is included,
"iface_live_renaming" is set to true.
---
 Documentation/networking/netconsole.rst |  5 +++--
 include/linux/netpoll.h                 |  3 +++
 net/core/dev.c                          |  3 ++-
 net/core/netpoll.c                      | 18 +++++++++++++++++-
 net/ethernet/eth.c                      |  5 ++++-
 5 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/netconsole.rst b/Documentation/networking/netconsole.rst
index 1f5c4a04027c..c1255a4d9c9b 100644
--- a/Documentation/networking/netconsole.rst
+++ b/Documentation/networking/netconsole.rst
@@ -34,20 +34,21 @@ Sender and receiver configuration:
 It takes a string configuration parameter "netconsole" in the
 following format::
 
- netconsole=[+][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
+ netconsole=[+][src-port]@[src-ip]/[<dev>][*],[tgt-port]@<tgt-ip>/[tgt-macaddr]
 
    where
 	+             if present, enable extended console support
 	src-port      source for UDP packets (defaults to 6665)
 	src-ip        source IP to use (interface address)
 	dev           network interface (eth0)
+	*             if present, allow runtime network interface renaming
 	tgt-port      port for logging agent (6666)
 	tgt-ip        IP address for logging agent
 	tgt-macaddr   ethernet MAC address for logging agent (broadcast)
 
 Examples::
 
- linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
+ linux netconsole=4444@10.0.0.1/eth1*,9353@10.0.0.2/12:34:56:78:9a:bc
 
 or::
 
diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index bd19c4b91e31..f2ebdabf0959 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -32,6 +32,7 @@ struct netpoll {
 	bool ipv6;
 	u16 local_port, remote_port;
 	u8 remote_mac[ETH_ALEN];
+	bool iface_live_renaming;
 };
 
 struct netpoll_info {
@@ -51,9 +52,11 @@ struct netpoll_info {
 void netpoll_poll_dev(struct net_device *dev);
 void netpoll_poll_disable(struct net_device *dev);
 void netpoll_poll_enable(struct net_device *dev);
+bool netpoll_live_renaming_enabled(struct net_device *dev);
 #else
 static inline void netpoll_poll_disable(struct net_device *dev) { return; }
 static inline void netpoll_poll_enable(struct net_device *dev) { return; }
+static inline bool netpoll_live_renaming_enabled(struct net_device *dev) { return false; }
 #endif
 
 void netpoll_send_udp(struct netpoll *np, const char *msg, int len);
diff --git a/net/core/dev.c b/net/core/dev.c
index cfb68db040a4..67430bec1f33 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1176,7 +1176,8 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	 * directly.
 	 */
 	if (dev->flags & IFF_UP &&
-	    likely(!(dev->priv_flags & IFF_LIVE_RENAME_OK)))
+	    likely(!(dev->priv_flags & IFF_LIVE_RENAME_OK) &&
+		   !netpoll_live_renaming_enabled(dev)))
 		return -EBUSY;
 
 	down_write(&devnet_rename_sem);
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9be762e1d042..fcea265290c3 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -224,6 +224,15 @@ void netpoll_poll_enable(struct net_device *dev)
 }
 EXPORT_SYMBOL(netpoll_poll_enable);
 
+bool netpoll_live_renaming_enabled(struct net_device *dev)
+{
+	if (dev->npinfo && dev->npinfo->netpoll->iface_live_renaming)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(netpoll_live_renaming_enabled);
+
 static void refill_skbs(void)
 {
 	struct sk_buff *skb;
@@ -523,7 +532,7 @@ static int netpoll_parse_ip_addr(const char *str, union inet_addr *addr)
 
 int netpoll_parse_options(struct netpoll *np, char *opt)
 {
-	char *cur=opt, *delim;
+	char *cur = opt, *delim, *asterisk;
 	int ipv6;
 	bool ipversion_set = false;
 
@@ -556,6 +565,13 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 		if ((delim = strchr(cur, ',')) == NULL)
 			goto parse_failed;
 		*delim = 0;
+
+		asterisk = strchr(cur, '*');
+		if (asterisk) {
+			np->iface_live_renaming = true;
+			*asterisk = 0;
+		}
+
 		strscpy(np->dev_name, cur, sizeof(np->dev_name));
 		cur = delim;
 	}
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index e02daa74e833..bb341acfcf05 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -62,6 +62,7 @@
 #include <net/gro.h>
 #include <linux/uaccess.h>
 #include <net/pkt_sched.h>
+#include <linux/netpoll.h>
 
 /**
  * eth_header - create the Ethernet header
@@ -288,8 +289,10 @@ int eth_prepare_mac_addr_change(struct net_device *dev, void *p)
 {
 	struct sockaddr *addr = p;
 
-	if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev))
+	if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev) &&
+	    !netpoll_live_renaming_enabled(dev))
 		return -EBUSY;
+
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 	return 0;
-- 
2.38.1

