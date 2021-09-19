Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320CA410AAD
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 10:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbhISIFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 04:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhISIE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 04:04:59 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1038C061574;
        Sun, 19 Sep 2021 01:03:33 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id w8so14254343pgf.5;
        Sun, 19 Sep 2021 01:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qbzdah+CUeMTuA04ejpGbdfLGYF3ScHZ8P9mrvS7/Rg=;
        b=VtW4eQm3YyFcxIgg/XYIk773VA7I62jWETmaKtCgVB/u1M/rBnz0SxqDl/ChB3Xvv/
         Ap2qOeDrmWeN6Uy4r70LapDkBZXbPfMthHx4yO8nKGdOzjx27GJo8d30DlDGXbSH6vnB
         hs1wTjmVtsFesbUQMEfVGZenOJh+SA2GrT32WNlN7HSjIgQwg6eb74ORuDRnoGEkOd3D
         7NxnJutM4S8nJXEfhnZnTQLWSs2ifxveGA4SauiQKqTAoNr6cfWhraBl92hO1QtoGGBB
         6xdmtEqEFmzihkA42C5Rkv7VU63mlOeZy6d3RPmjGcv3CaRRmIZVUyzKuFUjD2TWhKKx
         5Iww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qbzdah+CUeMTuA04ejpGbdfLGYF3ScHZ8P9mrvS7/Rg=;
        b=cjVzDd04MOovhSPVEo25CNfUcgPJIacFjqeu95DIqRK85JVwWuejMPEPE6ar+t+7N9
         R427NHnWTgLgHev+iWFQBqUH+4I3v7plD3w/e8K8MWLtanPAs8JMEBnOs5swahmN5NB7
         3ucvrCvNuygezarJPy4hkkuqKYbUjzB2P4rti68w9Gb7NUY3qv1YPsEa0ooSww+P0IW/
         iSXglwhlu5ecIE1QBE18x9g3MZHoHuCKmaIhdt7yc8qD54R9sqhoEs5ZtPZOjzaGAyWl
         gu7qw1fcidv1ciQpThjXfMne/eM9PhtlvfNvn08nwQktI5KA+ZoaoVEZkbPpfcsdUUN1
         8bbw==
X-Gm-Message-State: AOAM533sCA43UpzcFlw1LXHu77GTOcUdsrheofmd4g2t/SUYvRPN8dqH
        lB/T2+MTeOhwg5RzfHMn4mehOuE2GJY=
X-Google-Smtp-Source: ABdhPJxc55N+qw6s/wFct6EQWsTdGuX3l7RRLYvKCZR8b82PoizB5R+SMd2gSRBldAG0FU0Xy8LZOg==
X-Received: by 2002:a63:ce57:: with SMTP id r23mr18239323pgi.271.1632038613144;
        Sun, 19 Sep 2021 01:03:33 -0700 (PDT)
Received: from localhost.localdomain ([49.206.116.228])
        by smtp.googlemail.com with ESMTPSA id x18sm10593589pfq.130.2021.09.19.01.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 01:03:32 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH bpf-next 2/2] samples: bpf: convert ARP table network order fields into readable format
Date:   Sun, 19 Sep 2021 13:33:05 +0530
Message-Id: <20210919080305.173588-2-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919080305.173588-1-gokulkumar792@gmail.com>
References: <20210919080305.173588-1-gokulkumar792@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ARP table that is dumped when the xdp_router_ipv4 process is launched
has the IP address & MAC address in non-readable network byte order format,
also the alignment is off when printing the table.

Address HwAddress
160000e0                1600005e0001
ff96a8c0                ffffffffffff
faffffef                faff7f5e0001
196a8c0		9607871293ea
fb0000e0                fb00005e0001
0               0
196a8c0		9607871293ea
ffff11ac                ffffffffffff
faffffef                faff7f5e0001
fb0000e0                fb00005e0001
160000e0                1600005e0001
160000e0                1600005e0001
faffffef                faff7f5e0001
fb0000e0                fb00005e0001
40011ac         40011ac4202

Fix this by converting the "Address" field from network byte order Hex into
dotted decimal notation IPv4 format and "HwAddress" field from network byte
order Hex into Colon separated Hex format. Also fix the aligntment of the
fields in the ARP table.

Address         HwAddress
224.0.0.22      01:00:5e:00:00:16
192.168.150.255 ff:ff:ff:ff:ff:ff
239.255.255.250 01:00:5e:7f:ff:fa
192.168.150.1	ea:93:12:87:07:96
224.0.0.251     01:00:5e:00:00:fb
0.0.0.0         00:00:00:00:00:00
192.168.150.1	ea:93:12:87:07:96
172.17.255.255  ff:ff:ff:ff:ff:ff
239.255.255.250 01:00:5e:7f:ff:fa
224.0.0.251     01:00:5e:00:00:fb
224.0.0.22      01:00:5e:00:00:16
224.0.0.22      01:00:5e:00:00:16
239.255.255.250 01:00:5e:7f:ff:fa
224.0.0.251     01:00:5e:00:00:fb
172.17.0.4      02:42:ac:11:00:04

Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 samples/bpf/xdp_router_ipv4_user.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_ipv4_user.c
index 3e9db5a8c8c6..cfaf7e50e431 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -397,8 +397,12 @@ static void read_arp(struct nlmsghdr *nh, int nll)
 
 	if (nh->nlmsg_type == RTM_GETNEIGH)
 		printf("READING arp entry\n");
-	printf("Address\tHwAddress\n");
+	printf("Address         HwAddress\n");
 	for (; NLMSG_OK(nh, nll); nh = NLMSG_NEXT(nh, nll)) {
+		struct in_addr dst_addr;
+		char mac_str[18];
+		int len = 0, i;
+
 		rt_msg = (struct ndmsg *)NLMSG_DATA(nh);
 		rt_attr = (struct rtattr *)RTM_RTA(rt_msg);
 		ndm_family = rt_msg->ndm_family;
@@ -419,7 +423,14 @@ static void read_arp(struct nlmsghdr *nh, int nll)
 		}
 		arp_entry.dst = atoi(dsts);
 		arp_entry.mac = atol(mac);
-		printf("%x\t\t%llx\n", arp_entry.dst, arp_entry.mac);
+
+		dst_addr.s_addr = arp_entry.dst;
+		for (i = 0; i < 6; i++)
+			len += snprintf(mac_str + len, 18 - len, "%02llx%s",
+					((arp_entry.mac >> i * 8) & 0xff),
+					i < 5 ? ":" : "");
+		printf("%-16s%s\n", inet_ntoa(dst_addr), mac_str);
+
 		if (ndm_family == AF_INET) {
 			if (bpf_map_lookup_elem(exact_match_map_fd,
 						&arp_entry.dst,
@@ -728,7 +739,7 @@ int main(int ac, char **argv)
 
 	printf("\n*******************ROUTE TABLE*************************\n");
 	get_route_table(AF_INET);
-	printf("*******************ARP TABLE***************************\n\n\n");
+	printf("\n*******************ARP TABLE***************************\n");
 	get_arp_table(AF_INET);
 	if (monitor_route() < 0) {
 		printf("Error in receiving route update");
-- 
2.25.1

