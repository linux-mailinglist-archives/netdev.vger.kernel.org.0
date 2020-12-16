Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64CF2DC8AB
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 23:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbgLPWEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 17:04:35 -0500
Received: from sender11-of-o51.zoho.eu ([31.186.226.237]:21182 "EHLO
        sender11-of-o51.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgLPWEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 17:04:35 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1608156096; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=CDTLt8qA5a/Drb7M7WNOHr2dkzvv6SucFUXJy8CzjnrxExcx7QDT4FUDkV+JQMHVsH/BR4sX4yuQQsd8iGMZyk++F8tEDQyxRWTk3WOwhl0l0LDVf08X67n/4VkwdbHWldPIKGYrJxpB0qouAX+iNy3i/Uu+i35GCIxD722mrYE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1608156096; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qxToXvsqcaznoj2JP9SDejwABhssN1vHUTvgBnaiirc=; 
        b=HkPDzww6Jb/kqJkn2WLgkPbiyCE0YaDnujK1TCZtRcGenG85IJ1VgkuFTM+1B5fDCoyzXDcv5HpwYRMWMqbHOPGmzL+9IHwc/mX2zQWOcjy0gTBiCtZqFEcPmq1GcZnjaW2WJtxqO/ZU8EZFn0hL2dZX69KxX5JVENSR0k4bjrY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1608156096;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=qxToXvsqcaznoj2JP9SDejwABhssN1vHUTvgBnaiirc=;
        b=KOXvnpSfM6AeSK8mbq1I9q57nh8Ty7uIPvibLJvdNni8zTLCCA3MDUG6TzTuzHiS
        U6cvXYP+Vsx32JRIEntTB9pj/fsnHn/xQ0hvjt/fC6icx7VTn8Cy5QtCMbpCTb8oLDU
        YC3UE2OxhYT/E9oHWNNVJPCOVKw7eey1WMrCAylE=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1608156089538793.9095160443956; Wed, 16 Dec 2020 23:01:29 +0100 (CET)
Date:   Wed, 16 Dec 2020 23:01:29 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Jakub Kicinski" <kuba@kernel.org>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "kuznet" <kuznet@ms2.inr.ac.ru>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net>
In-Reply-To: <176458a838e.100a4c464143350.2864106687411861504@shytyi.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
        <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
        <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
        <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net> <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net> <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net> <176458a838e.100a4c464143350.2864106687411861504@shytyi.net>
Subject: [PATCH net-next V9] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable SLAAC [Can be activated via sysctl]: 
SLAAC with prefixes of arbitrary length in PIO (randomly
generated hostID or stable privacy + privacy extensions).
The main problem is that SLAAC RA or PD allocates a /64 by the Wireless
carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 via
SLAAC is required so that downstream interfaces can be further subnetted.
Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, and
assigns /72 to VNF-Firewall, /72 to WIFI, /72 to Load-Balancer 
and /72 to wired connected devices.
IETF document that defines problem statement:
draft-mishra-v6ops-variable-slaac-problem-stmt
IETF document that specifies variable slaac:
draft-mishra-6man-variable-slaac

Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
---
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index dda61d150a13..67ca3925463c 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -75,6 +75,7 @@ struct ipv6_devconf {
 	__s32		disable_policy;
 	__s32           ndisc_tclass;
 	__s32		rpl_seg_enabled;
+	__s32		variable_slaac;
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 13e8751bf24a..f2af4f9fba2d 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -189,7 +189,8 @@ enum {
 	DEVCONF_ACCEPT_RA_RT_INFO_MIN_PLEN,
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
-	DEVCONF_MAX
+	DEVCONF_MAX,
+	DEVCONF_VARIABLE_SLAAC
 };
 
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index eff2cacd5209..4afaf2bc8d8b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -236,6 +236,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.variable_slaac		= 0,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -291,6 +292,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.variable_slaac		= 0,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -1340,9 +1342,15 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
 		goto out;
 	}
 	in6_ifa_hold(ifp);
-	memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
-	ipv6_gen_rnd_iid(&addr);
 
+	if (ifp->prefix_len == 64) {
+		memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
+		ipv6_gen_rnd_iid(&addr);
+	} else if (ifp->prefix_len > 0 && ifp->prefix_len <= 128 &&
+		   idev->cnf.variable_slaac) {
+		get_random_bytes(addr.s6_addr, 16);
+		ipv6_addr_prefix_copy(&addr, &ifp->addr, ifp->prefix_len);
+	}
 	age = (now - ifp->tstamp) / HZ;
 
 	regen_advance = idev->cnf.regen_max_retry *
@@ -2569,6 +2577,31 @@ static bool is_addr_mode_generate_stable(struct inet6_dev *idev)
 	       idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_RANDOM;
 }
 
+static struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifaddr *ifp,
+						      struct inet6_dev *in6_dev,
+						      struct net *net,
+						      const struct prefix_info *pinfo)
+{
+	struct inet6_ifaddr *result = NULL;
+	bool prfxs_equal;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) {
+		if (!net_eq(dev_net(ifp->idev->dev), net))
+			continue;
+		prfxs_equal =
+			ipv6_prefix_equal(&pinfo->prefix, &ifp->addr, pinfo->prefix_len);
+		if (prfxs_equal && pinfo->prefix_len == ifp->prefix_len) {
+			result = ifp;
+			in6_ifa_hold(ifp);
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return result;
+}
+
 int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 const struct prefix_info *pinfo,
 				 struct inet6_dev *in6_dev,
@@ -2576,9 +2609,17 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 u32 addr_flags, bool sllao, bool tokenized,
 				 __u32 valid_lft, u32 prefered_lft)
 {
-	struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1);
+	struct inet6_ifaddr *ifp = NULL;
+	int plen = pinfo->prefix_len;
 	int create = 0;
 
+	if (plen > 0 && plen <= 128 && plen != 64 &&
+	    in6_dev->cnf.addr_gen_mode != IN6_ADDR_GEN_MODE_STABLE_PRIVACY &&
+	    in6_dev->cnf.variable_slaac)
+		ifp = ipv6_cmp_rcvd_prsnt_prfxs(ifp, in6_dev, net, pinfo);
+	else
+		ifp = ipv6_get_ifaddr(net, addr, dev, 1);
+
 	if (!ifp && valid_lft) {
 		int max_addresses = in6_dev->cnf.max_addresses;
 		struct ifa6_config cfg = {
@@ -2657,6 +2698,90 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(addrconf_prefix_rcv_add_addr);
 
+static bool ipv6_reserved_interfaceid(struct in6_addr address)
+{
+	if ((address.s6_addr32[2] | address.s6_addr32[3]) == 0)
+		return true;
+
+	if (address.s6_addr32[2] == htonl(0x02005eff) &&
+	    ((address.s6_addr32[3] & htonl(0xfe000000)) == htonl(0xfe000000)))
+		return true;
+
+	if (address.s6_addr32[2] == htonl(0xfdffffff) &&
+	    ((address.s6_addr32[3] & htonl(0xffffff80)) == htonl(0xffffff80)))
+		return true;
+
+	return false;
+}
+
+static int ipv6_gen_addr_var_plen(struct in6_addr *address,
+				  u8 dad_count,
+				  const struct inet6_dev *idev,
+				  unsigned int rcvd_prfx_len,
+				  bool stable_privacy_mode)
+{
+	static union {
+		char __data[SHA1_BLOCK_SIZE];
+		struct {
+			struct in6_addr secret;
+			__be32 prefix[2];
+			unsigned char hwaddr[MAX_ADDR_LEN];
+			u8 dad_count;
+		} __packed;
+	} data;
+	static __u32 workspace[SHA1_WORKSPACE_WORDS];
+	static __u32 digest[SHA1_DIGEST_WORDS];
+	struct net *net = dev_net(idev->dev);
+	static DEFINE_SPINLOCK(lock);
+	struct in6_addr secret;
+	struct in6_addr temp;
+
+	BUILD_BUG_ON(sizeof(data.__data) != sizeof(data));
+
+	if (stable_privacy_mode) {
+		if (idev->cnf.stable_secret.initialized)
+			secret = idev->cnf.stable_secret.secret;
+		else if (net->ipv6.devconf_dflt->stable_secret.initialized)
+			secret = net->ipv6.devconf_dflt->stable_secret.secret;
+		else
+			return -1;
+	}
+
+retry:
+	spin_lock_bh(&lock);
+	if (stable_privacy_mode) {
+		sha1_init(digest);
+		memset(&data, 0, sizeof(data));
+		memset(workspace, 0, sizeof(workspace));
+		memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
+		data.prefix[0] = address->s6_addr32[0];
+		data.prefix[1] = address->s6_addr32[1];
+		data.secret = secret;
+		data.dad_count = dad_count;
+
+		sha1_transform(digest, data.__data, workspace);
+
+		temp.s6_addr32[0] = (__force __be32)digest[0];
+		temp.s6_addr32[1] = (__force __be32)digest[1];
+		temp.s6_addr32[2] = (__force __be32)digest[2];
+		temp.s6_addr32[3] = (__force __be32)digest[3];
+	} else {
+		get_random_bytes(temp.s6_addr32, 16);
+	}
+
+	spin_unlock_bh(&lock);
+
+	if (ipv6_reserved_interfaceid(temp)) {
+		dad_count++;
+		if (dad_count > dev_net(idev->dev)->ipv6.sysctl.idgen_retries)
+			return -1;
+		goto retry;
+	}
+	ipv6_addr_prefix_copy(&temp, address, rcvd_prfx_len);
+	*address = temp;
+	return 0;
+}
+
 void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 {
 	struct prefix_info *pinfo;
@@ -2781,9 +2906,34 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 				dev_addr_generated = true;
 			}
 			goto ok;
+		} else if (pinfo->prefix_len != 64 &&
+			   pinfo->prefix_len > 0 && pinfo->prefix_len <= 128 &&
+			   in6_dev->cnf.variable_slaac) {
+			/* SLAAC with prefixes of arbitrary length (Variable SLAAC).
+			 * draft-mishra-6man-variable-slaac
+			 * draft-mishra-v6ops-variable-slaac-problem-stmt
+			 */
+			memcpy(&addr, &pinfo->prefix, 16);
+			if (in6_dev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_STABLE_PRIVACY) {
+				if (!ipv6_gen_addr_var_plen(&addr,
+							    0,
+							    in6_dev,
+							    pinfo->prefix_len,
+							    true)) {
+					addr_flags |= IFA_F_STABLE_PRIVACY;
+					goto ok;
+				}
+			} else if (!ipv6_gen_addr_var_plen(&addr,
+							   0,
+							   in6_dev,
+							   pinfo->prefix_len,
+							   false)) {
+				goto ok;
+			}
+		} else {
+			net_dbg_ratelimited("IPv6: Prefix with unexpected length %d\n",
+					    pinfo->prefix_len);
 		}
-		net_dbg_ratelimited("IPv6 addrconf: prefix with wrong length %d\n",
-				    pinfo->prefix_len);
 		goto put;
 
 ok:
@@ -3186,22 +3336,6 @@ void addrconf_add_linklocal(struct inet6_dev *idev,
 }
 EXPORT_SYMBOL_GPL(addrconf_add_linklocal);
 
-static bool ipv6_reserved_interfaceid(struct in6_addr address)
-{
-	if ((address.s6_addr32[2] | address.s6_addr32[3]) == 0)
-		return true;
-
-	if (address.s6_addr32[2] == htonl(0x02005eff) &&
-	    ((address.s6_addr32[3] & htonl(0xfe000000)) == htonl(0xfe000000)))
-		return true;
-
-	if (address.s6_addr32[2] == htonl(0xfdffffff) &&
-	    ((address.s6_addr32[3] & htonl(0xffffff80)) == htonl(0xffffff80)))
-		return true;
-
-	return false;
-}
-
 static int ipv6_generate_stable_address(struct in6_addr *address,
 					u8 dad_count,
 					const struct inet6_dev *idev)
@@ -5517,6 +5651,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_DISABLE_POLICY] = cnf->disable_policy;
 	array[DEVCONF_NDISC_TCLASS] = cnf->ndisc_tclass;
 	array[DEVCONF_RPL_SEG_ENABLED] = cnf->rpl_seg_enabled;
+	array[DEVCONF_VARIABLE_SLAAC] = cnf->variable_slaac;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -6897,6 +7032,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "variable_slaac",
+		.data		= &ipv6_devconf.variable_slaac,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		/* sentinel */
 	}
