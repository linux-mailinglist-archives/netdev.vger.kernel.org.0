Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B473634F7
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhDRMDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhDRMDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 08:03:35 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687BCC061761
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:06 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id w186so12131864wmg.3
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=piBsJVg8SSFD7g3ZzOjEi7IlK8Xhlh8XK9iu1OQWyes=;
        b=rRMD3xGslFTS9tZkFZ+uB7M/QzbV+D/Ofmuc/+g/bsQN6kOeOv2kF82rCMJxos95kg
         A3+C/zVdMpkpI/Imc2afXVf55NXdyGWN87BTirVZZDP2s7LkxlpNmptc55fTou6zVvWW
         7aHIVpX4LAt/iCK1reNADT29ldSVBHfDKT6M/zFUkbmMXWBLfRRzYcJCTDHc+xm+zT3V
         XUGZReMLWY0ibToeE0O5rSCOhOqXFFJEf9v1kyKdHJHvj9mN7bXkFkKfTINW015NU7ix
         dbm36sVHsi42nD0Lgi2Kb4ZwpzSeITHaMc7vLBg++kPA5yjzExq8m8PKk6+TdBcaQ2sY
         pwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=piBsJVg8SSFD7g3ZzOjEi7IlK8Xhlh8XK9iu1OQWyes=;
        b=HdQSJz+nqXlOYA6cipv0iN/y1LN8iLjFh3Gzb+NCeQmecnJx4wdMSnVKZuDe5d3NIK
         4TmvBmJhdFaedhVSm9f+Up4HNvcEHgOrG1O6KL0SH2hiXjBWUW9qeRmSFunmIo4pgbNA
         H8X4NOBRq7TsNTUfXm7OQGMfqBG6vdUhfqtxY/QDtmNePWMcm1ZQlJKj2Feo2R1ZXt7c
         +nFRO15WB2/CsoUGgwdcdrlC5DLKx+xMtC7FA7AqsIKs3b95/9uZtR36O27OtVwbNYxv
         JGSKLWp9Ffy5tt6B0NBvNCCkHEuezR/VBb1wRcgn7PPfqk6Ut6GVNgYKNZwyMl49ab8X
         Q0Mg==
X-Gm-Message-State: AOAM530vxoo8M1+KxujcbVOf+eQ9VHuYgVNOlImN53vNflaLmzdhrBT3
        00lYkEV2W2ADNSRCqH/WS54QuxMn7V7hVH/R
X-Google-Smtp-Source: ABdhPJzcl8NORbtec5SxpHatF3jOagi3EGgqaOnt+07CtrHxy5hlEIAv5yT4oPUTzpokIQ8SDzUX/A==
X-Received: by 2002:a05:600c:2d56:: with SMTP id a22mr16851246wmg.175.1618747384831;
        Sun, 18 Apr 2021 05:03:04 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x25sm16584763wmj.34.2021.04.18.05.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 05:03:04 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 3/6] bridge: vlan: add option set command and state option
Date:   Sun, 18 Apr 2021 15:01:34 +0300
Message-Id: <20210418120137.2605522-4-razor@blackwall.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418120137.2605522-1-razor@blackwall.org>
References: <20210418120137.2605522-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a new per-vlan option set command. It allows to manipulate vlan
options, those can be bridge-wide or per-port depending on what device
is specified. The first option that can be set is the vlan STP state,
it is identical to the bridge port STP state. The man page is also
updated accordingly.

Example:
 $ bridge vlan set vid 10 dev br0 state learning
or a range:
 $ bridge vlan set vid 10-20 dev swp1 state blocking

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 97 +++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/bridge.8 | 64 +++++++++++++++++++++++++++++++
 2 files changed, 161 insertions(+)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 0d142bc9055d..09884870df81 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -33,6 +33,7 @@ static void usage(void)
 		"Usage: bridge vlan { add | del } vid VLAN_ID dev DEV [ tunnel_info id TUNNEL_ID ]\n"
 		"                                                     [ pvid ] [ untagged ]\n"
 		"                                                     [ self ] [ master ]\n"
+		"       bridge vlan { set } vid VLAN_ID dev DEV [ state STP_STATE ]\n"
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
@@ -241,6 +242,100 @@ static int vlan_modify(int cmd, int argc, char **argv)
 	return 0;
 }
 
+static int vlan_option_set(int argc, char **argv)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct br_vlan_msg	bvm;
+		char			buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct br_vlan_msg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = RTM_NEWVLAN,
+		.bvm.family = PF_BRIDGE,
+	};
+	struct bridge_vlan_info vinfo = {};
+	struct rtattr *afspec;
+	short vid_end = -1;
+	char *d = NULL;
+	short vid = -1;
+	int state = -1;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			d = *argv;
+		} else if (strcmp(*argv, "vid") == 0) {
+			char *p;
+
+			NEXT_ARG();
+			p = strchr(*argv, '-');
+			if (p) {
+				*p = '\0';
+				p++;
+				vid = atoi(*argv);
+				vid_end = atoi(p);
+				if (vid >= vid_end || vid_end >= 4096) {
+					fprintf(stderr, "Invalid VLAN range \"%hu-%hu\"\n",
+						vid, vid_end);
+					return -1;
+				}
+			} else {
+				vid = atoi(*argv);
+			}
+		} else if (strcmp(*argv, "state") == 0) {
+			char *endptr;
+
+			NEXT_ARG();
+			state = strtol(*argv, &endptr, 10);
+			if (!(**argv != '\0' && *endptr == '\0'))
+				state = parse_stp_state(*argv);
+			if (state == -1) {
+				fprintf(stderr, "Error: invalid STP state\n");
+				return -1;
+			}
+		} else {
+			if (matches(*argv, "help") == 0)
+				NEXT_ARG();
+		}
+		argc--; argv++;
+	}
+
+	if (d == NULL || vid == -1) {
+		fprintf(stderr, "Device and VLAN ID are required arguments.\n");
+		return -1;
+	}
+
+	req.bvm.ifindex = ll_name_to_index(d);
+	if (req.bvm.ifindex == 0) {
+		fprintf(stderr, "Cannot find network device \"%s\"\n", d);
+		return -1;
+	}
+
+	if (vid >= 4096) {
+		fprintf(stderr, "Invalid VLAN ID \"%hu\"\n", vid);
+		return -1;
+	}
+	afspec = addattr_nest(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY);
+	afspec->rta_type |= NLA_F_NESTED;
+
+	vinfo.flags = BRIDGE_VLAN_INFO_ONLY_OPTS;
+	vinfo.vid = vid;
+	addattr_l(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY_INFO, &vinfo,
+		  sizeof(vinfo));
+	if (vid_end != -1)
+		addattr16(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY_RANGE,
+			  vid_end);
+	if (state >= 0)
+		addattr8(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY_STATE, state);
+	addattr_nest_end(&req.n, afspec);
+
+	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+		return -1;
+
+	return 0;
+}
+
 /* In order to use this function for both filtering and non-filtering cases
  * we need to make it a tristate:
  * return -1 - if filtering we've gone over so don't continue
@@ -667,6 +762,8 @@ int do_vlan(int argc, char **argv)
 		if (matches(*argv, "tunnelshow") == 0) {
 			return vlan_show(argc-1, argv+1, VLAN_SHOW_TUNNELINFO);
 		}
+		if (matches(*argv, "set") == 0)
+			return vlan_option_set(argc-1, argv+1);
 		if (matches(*argv, "help") == 0)
 			usage();
 	} else {
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 9d8663bd23cc..90dcae73ce71 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -138,6 +138,15 @@ bridge \- show / manipulate bridge addresses and devices
 .BR pvid " ] [ " untagged " ] [ "
 .BR self " ] [ " master " ] "
 
+.ti -8
+.BR "bridge vlan set"
+.B dev
+.I DEV
+.B vid
+.IR VID " [ "
+.B state
+.IR STP_STATE " ] "
+
 .ti -8
 .BR "bridge vlan" " [ " show " | " tunnelshow " ] [ "
 .B dev
@@ -813,6 +822,61 @@ The
 .BR "pvid " and " untagged"
 flags are ignored.
 
+.SS bridge vlan set - change vlan filter entry's options
+
+This command changes vlan filter entry's options.
+
+.TP
+.BI dev " NAME"
+the interface with which this vlan is associated.
+
+.TP
+.BI vid " VID"
+the VLAN ID that identifies the vlan.
+
+.TP
+.BI state " STP_STATE "
+the operation state of the vlan. One may enter STP state name (case insensitive), or one of the
+numbers below. Negative inputs are ignored, and unrecognized names return an
+error. Note that the state is set only for the vlan of the specified device, e.g. if it is
+a bridge port then the state will be set only for the vlan of the port.
+
+.B 0
+- vlan is in STP
+.B DISABLED
+state. Make this vlan completely inactive for STP. This is also called
+BPDU filter and could be used to disable STP on an untrusted vlan.
+.sp
+
+.B 1
+- vlan is in STP
+.B LISTENING
+state. Only valid if STP is enabled on the bridge. In this
+state the vlan listens for STP BPDUs and drops all other traffic frames.
+.sp
+
+.B 2
+- vlan is in STP
+.B LEARNING
+state. Only valid if STP is enabled on the bridge. In this
+state the vlan will accept traffic only for the purpose of updating MAC
+address tables.
+.sp
+
+.B 3
+- vlan is in STP
+.B FORWARDING
+state. This is the default vlan state.
+.sp
+
+.B 4
+- vlan is in STP
+.B BLOCKING
+state. Only valid if STP is enabled on the bridge. This state
+is used during the STP election process. In this state, the vlan will only process
+STP BPDUs.
+.sp
+
 .SS bridge vlan show - list vlan configuration.
 
 This command displays the current VLAN filter table.
-- 
2.30.2

