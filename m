Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B2651958E
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 04:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344096AbiEDCnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344059AbiEDCmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:42:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001EB1F63C
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 19:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651631952; x=1683167952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2BkymHnE1Mt2kivWlHUEWIz6yV1Ia0s1YJXsf02tjIk=;
  b=YqWnapAVRKhMRdB4IZkzCfwehe8k8ndJjzVpF33W6GVH80xUsDEnNQVU
   NHDOiscdSWWO6HY+SOygn/NuMr84uFlW/bOoRt2qzHpcZTbwtBrCqPq9Q
   Bd92vvS1YfLYtPK3tuWT2MJ0pRS73dG6YhysvS2Lxn0GvGgtceIjTaF1l
   EyMHow4uxPhHM/Fzj/D+EGXDwxA5zAfRV5tYyu4P8BOqlRqf1BPi6X9GJ
   WtwL4WRR4ISuu+jxnYEtNtDJw6txctrZYXrPjAnHuxPrH61Q8Oc5zmFnT
   ra3YkwFGm/JJBTwGeyEVCmg6yixGEplEcYDWd/IxiTFwRcla9Pbb4CsQc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267799852"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267799852"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="584493397"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.20.240])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:08 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/13] selftests: mptcp: support MPTCP_PM_CMD_SUBFLOW_DESTROY
Date:   Tue,  3 May 2022 19:38:58 -0700
Message-Id: <20220504023901.277012-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504023901.277012-1-mathew.j.martineau@linux.intel.com>
References: <20220504023901.277012-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

This change updates the "pm_nl_ctl" testing sample with a "dsf"
(destroy subflow) option to support the newly added netlink interface
command MPTCP_PM_CMD_SUBFLOW_DESTROY over the chosen MPTCP connection.

E.g. ./pm_nl_ctl dsf lip 10.0.2.1 lport 44567 rip 10.0.2.2 rport 56789
token 823274047

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 115 ++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index e2437bacd133..8d74fcb04929 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -30,6 +30,7 @@ static void syntax(char *argv[])
 	fprintf(stderr, "\tann <local-ip> id <local-id> token <token> [port <local-port>] [dev <name>]\n");
 	fprintf(stderr, "\trem id <local-id> token <token>\n");
 	fprintf(stderr, "\tcsf lip <local-ip> lid <local-id> rip <remote-ip> rport <remote-port> token <token>\n");
+	fprintf(stderr, "\tdsf lip <local-ip> lport <local-port> rip <remote-ip> rport <remote-port> token <token>\n");
 	fprintf(stderr, "\tdel <id> [<ip>]\n");
 	fprintf(stderr, "\tget <id>\n");
 	fprintf(stderr, "\tset [<ip>] [id <nr>] flags [no]backup|[no]fullmesh [port <nr>]\n");
@@ -174,6 +175,118 @@ static int resolve_mptcp_pm_netlink(int fd)
 	return genl_parse_getfamily((void *)data);
 }
 
+int dsf(int fd, int pm_family, int argc, char *argv[])
+{
+	char data[NLMSG_ALIGN(sizeof(struct nlmsghdr)) +
+		  NLMSG_ALIGN(sizeof(struct genlmsghdr)) +
+		  1024];
+	struct rtattr *rta, *addr;
+	u_int16_t family, port;
+	struct nlmsghdr *nh;
+	u_int32_t token;
+	int addr_start;
+	int off = 0;
+	int arg;
+
+	const char *params[5];
+
+	memset(params, 0, 5 * sizeof(const char *));
+
+	memset(data, 0, sizeof(data));
+	nh = (void *)data;
+	off = init_genl_req(data, pm_family, MPTCP_PM_CMD_SUBFLOW_DESTROY,
+			    MPTCP_PM_VER);
+
+	if (argc < 12)
+		syntax(argv);
+
+	/* Params recorded in this order:
+	 * <local-ip>, <local-port>, <remote-ip>, <remote-port>, <token>
+	 */
+	for (arg = 2; arg < argc; arg++) {
+		if (!strcmp(argv[arg], "lip")) {
+			if (++arg >= argc)
+				error(1, 0, " missing local IP");
+
+			params[0] = argv[arg];
+		} else if (!strcmp(argv[arg], "lport")) {
+			if (++arg >= argc)
+				error(1, 0, " missing local port");
+
+			params[1] = argv[arg];
+		} else if (!strcmp(argv[arg], "rip")) {
+			if (++arg >= argc)
+				error(1, 0, " missing remote IP");
+
+			params[2] = argv[arg];
+		} else if (!strcmp(argv[arg], "rport")) {
+			if (++arg >= argc)
+				error(1, 0, " missing remote port");
+
+			params[3] = argv[arg];
+		} else if (!strcmp(argv[arg], "token")) {
+			if (++arg >= argc)
+				error(1, 0, " missing token");
+
+			params[4] = argv[arg];
+		} else
+			error(1, 0, "unknown keyword %s", argv[arg]);
+	}
+
+	for (arg = 0; arg < 4; arg = arg + 2) {
+		/*  addr header */
+		addr_start = off;
+		addr = (void *)(data + off);
+		addr->rta_type = NLA_F_NESTED |
+			((arg == 0) ? MPTCP_PM_ATTR_ADDR : MPTCP_PM_ATTR_ADDR_REMOTE);
+		addr->rta_len = RTA_LENGTH(0);
+		off += NLMSG_ALIGN(addr->rta_len);
+
+		/*  addr data */
+		rta = (void *)(data + off);
+		if (inet_pton(AF_INET, params[arg], RTA_DATA(rta))) {
+			family = AF_INET;
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR4;
+			rta->rta_len = RTA_LENGTH(4);
+		} else if (inet_pton(AF_INET6, params[arg], RTA_DATA(rta))) {
+			family = AF_INET6;
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR6;
+			rta->rta_len = RTA_LENGTH(16);
+		} else
+			error(1, errno, "can't parse ip %s", params[arg]);
+		off += NLMSG_ALIGN(rta->rta_len);
+
+		/* family */
+		rta = (void *)(data + off);
+		rta->rta_type = MPTCP_PM_ADDR_ATTR_FAMILY;
+		rta->rta_len = RTA_LENGTH(2);
+		memcpy(RTA_DATA(rta), &family, 2);
+		off += NLMSG_ALIGN(rta->rta_len);
+
+		/*  port */
+		port = atoi(params[arg + 1]);
+		rta = (void *)(data + off);
+		rta->rta_type = MPTCP_PM_ADDR_ATTR_PORT;
+		rta->rta_len = RTA_LENGTH(2);
+		memcpy(RTA_DATA(rta), &port, 2);
+		off += NLMSG_ALIGN(rta->rta_len);
+
+		addr->rta_len = off - addr_start;
+	}
+
+	/* token */
+	token = atoi(params[4]);
+	rta = (void *)(data + off);
+	rta->rta_type = MPTCP_PM_ATTR_TOKEN;
+	rta->rta_len = RTA_LENGTH(4);
+	memcpy(RTA_DATA(rta), &token, 4);
+	off += NLMSG_ALIGN(rta->rta_len);
+
+	do_nl_req(fd, nh, off, 0);
+
+	return 0;
+}
+
 int csf(int fd, int pm_family, int argc, char *argv[])
 {
 	char data[NLMSG_ALIGN(sizeof(struct nlmsghdr)) +
@@ -1098,6 +1211,8 @@ int main(int argc, char *argv[])
 		return remove_addr(fd, pm_family, argc, argv);
 	else if (!strcmp(argv[1], "csf"))
 		return csf(fd, pm_family, argc, argv);
+	else if (!strcmp(argv[1], "dsf"))
+		return dsf(fd, pm_family, argc, argv);
 	else if (!strcmp(argv[1], "del"))
 		return del_addr(fd, pm_family, argc, argv);
 	else if (!strcmp(argv[1], "flush"))
-- 
2.36.0

