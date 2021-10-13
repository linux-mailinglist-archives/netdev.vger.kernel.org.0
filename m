Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C944842CF14
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 01:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhJMXVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 19:21:00 -0400
Received: from sender11-of-o51.zoho.eu ([31.186.226.237]:21158 "EHLO
        sender11-of-o51.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhJMXU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 19:20:58 -0400
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2021 19:20:58 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1634166185; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Ws6DW6iaVmOQeOgvj/1xAl2e96DiBBNlGVyEGK+HaWcK06QZvHemdXeoR8JSStDyrWpmpwptWiP8Dji6pqgcnkqspFTYialhj9X+zgtPs5xiE1cLm1sL6sGqufFzIVhTxCN3KG6tJCLszhWY9qN5I1h7YGyz7YbISxRSGEB4fqs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1634166185; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=dKhAEuQQ8ZSPKMwkPGQQ+kxB1kBhERAFEa3uEU178Sk=; 
        b=UB4lrB+L8Y68mRwcYxLbRMVjtotwPLq6x3l2imDmSx+fDO0PIm2xHxjYCz+CLQce36vEh4FaazoHOiE1ZV2oA0AKN8vHAOF+95W7TaRZT61GL95pHC5jHFpuC+L5/eQkJ5TE3UAkQA54DZwt1YDlBnVev2sb9EQvCpfrdWL4v+Y=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1634166185;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=dKhAEuQQ8ZSPKMwkPGQQ+kxB1kBhERAFEa3uEU178Sk=;
        b=UUNox0nRzB+RTPCaZZqq9tW3u2bPtDyCJXLOCLG6NfMIpiLgc5DFcYKM1mZxQyKH
        BYoge4vMwv/vt74PdbzVi45yDqWxvyyXotok2fqOKBz2CByLZCJSVsHcx91/4C6h1/i
        9fWo/zCqHk6cJwNfmBCdTa9Xunpw/wZJ/fG2n7S0=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1634166180243665.469037042922; Thu, 14 Oct 2021 01:03:00 +0200 (CEST)
Date:   Thu, 14 Oct 2021 01:03:00 +0200
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Jakub Kicinski" <kuba@kernel.org>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "kuznet" <kuznet@ms2.inr.ac.ru>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "ek" <ek@google.com>, "Jscherpelz" <jscherpelz@google.com>
Message-ID: <17c7be50990.d8ff97ac1139678.6280958386678329804@shytyi.net>
In-Reply-To: <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
        <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
        <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
        <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net> <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net> <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net> <176458a838e.100a4c464143350.2864106687411861504@shytyi.net> <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net>
Subject: [PATCH net-next V10] net: Variable SLAAC: SLAAC with prefixes of
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

Variable SLAAC:
[Disabled by default. Can be activated via sysctl]
["Race to the bottom" problem is solved]
SLAAC with prefixes of arbitrary length in PIO (randomly 
generated hostID or stable privacy + privacy extensions). 
The main problem is that SLAAC RA allocates a /64 by the Wireless       
carrier 4G, 5G to a mobile hotspot, however segmentation of shorter net-
work prefix (ex. /48) is required so that downstream interfaces can be further
subnetted. 
Example: uCPE device (4G + WI-FI enabled) receives /48 via Wireless, and 
assigns /56 to VNF-Firewall, /56 to WIFI, /56 to Load-Balancer 
and /56 to wired connected devices. 
IETF document that defines problem statement: 
draft-mishra-v6ops-variable-slaac-problem-stmt 
IETF document that specifies variable slaac: 
draft-mishra-6man-variable-slaac 
 
Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net> 
--- 
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index ef4a69865737..076d99874797 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -79,6 +79,7 @@ struct ipv6_devconf {
 	__u32		ioam6_id;
 	__u32		ioam6_id_wide;
 	__u8		ioam6_enabled;
+	__s32		variable_slaac;
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index b243a53fa985..25606c267809 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -193,6 +193,7 @@ enum {
 	DEVCONF_IOAM6_ENABLED,
 	DEVCONF_IOAM6_ID,
 	DEVCONF_IOAM6_ID_WIDE,
+	DEVCONF_VARIABLE_SLAAC,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index c6a90b7bbb70..34a12d7f4fb8 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -241,6 +241,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.ioam6_enabled		= 0,
 	.ioam6_id               = IOAM6_DEFAULT_IF_ID,
 	.ioam6_id_wide		= IOAM6_DEFAULT_IF_ID_WIDE,
+	.variable_slaac		= 0,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -300,6 +301,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.ioam6_enabled		= 0,
 	.ioam6_id               = IOAM6_DEFAULT_IF_ID,
 	.ioam6_id_wide		= IOAM6_DEFAULT_IF_ID_WIDE,
+	.variable_slaac		= 0,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -1349,9 +1351,15 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
 		goto out;
 	}
 	in6_ifa_hold(ifp);
-	memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
-	ipv6_gen_rnd_iid(&addr);
 
+	if (ifp->prefix_len == 64) {
+		memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
+		ipv6_gen_rnd_iid(&addr);
+	} else if (ifp->prefix_len > 0 && ifp->prefix_len < 64 &&
+		   idev->cnf.variable_slaac) {
+		get_random_bytes(addr.s6_addr, 16);
+		ipv6_addr_prefix_copy(&addr, &ifp->addr, ifp->prefix_len);
+	}
 	age = (now - ifp->tstamp) / HZ;
 
 	regen_advance = idev->cnf.regen_max_retry *
@@ -2579,6 +2587,31 @@ static bool is_addr_mode_generate_stable(struct inet6_dev *idev)
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
@@ -2586,9 +2619,17 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 u32 addr_flags, bool sllao, bool tokenized,
 				 __u32 valid_lft, u32 prefered_lft)
 {
-	struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1);
+	struct inet6_ifaddr *ifp = NULL;
+	int plen = pinfo->prefix_len;
 	int create = 0;
 
+	if (plen > 0 && plen < 64 &&
+	    in6_dev->cnf.addr_gen_mode != IN6_ADDR_GEN_MODE_STABLE_PRIVACY &&
+	    in6_dev->cnf.variable_slaac)
+		ifp = ipv6_cmp_rcvd_prsnt_prfxs(ifp, in6_dev, net, pinfo);
+	else
+		ifp = ipv6_get_ifaddr(net, addr, dev, 1);
+
 	if (!ifp && valid_lft) {
 		int max_addresses = in6_dev->cnf.max_addresses;
 		struct ifa6_config cfg = {
@@ -2667,6 +2708,94 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
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
+	union data_union {
+		char __data[SHA1_BLOCK_SIZE];
+		struct {
+			struct in6_addr secret;
+			__be32 prefix[2];
+			unsigned char hwaddr[MAX_ADDR_LEN];
+			u8 dad_count;
+		} __packed;
+	};
+	union data_union *data;
+	struct in6_addr *secret;
+	struct in6_addr *temp;
+	struct net *net;
+	int *workspace;
+	int *digest;
+
+	workspace = kmalloc_array(SHA1_WORKSPACE_WORDS, sizeof(__u32), GFP_KERNEL);
+	digest = kmalloc_array(SHA1_DIGEST_WORDS, sizeof(__u32), GFP_KERNEL);
+	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	secret = kmalloc(sizeof(*secret), GFP_KERNEL);
+	temp = kmalloc(sizeof(*temp), GFP_KERNEL);
+	net = dev_net(idev->dev);
+
+	BUILD_BUG_ON(sizeof(data->__data) != sizeof(*data));
+
+	if (stable_privacy_mode) {
+		if (idev->cnf.stable_secret.initialized)
+			*secret = idev->cnf.stable_secret.secret;
+		else if (net->ipv6.devconf_dflt->stable_secret.initialized)
+			*secret = net->ipv6.devconf_dflt->stable_secret.secret;
+		else
+			return -1;
+	}
+
+retry:
+	if (stable_privacy_mode) {
+		sha1_init(digest);
+		memset(data, 0, sizeof(*data));
+		memset(workspace, 0, sizeof(*workspace));
+		memcpy(data->hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
+		data->prefix[0] = address->s6_addr32[0];
+		data->prefix[1] = address->s6_addr32[1];
+		data->secret = *secret;
+		data->dad_count = dad_count;
+
+		sha1_transform(digest, data->__data, workspace);
+
+		temp->s6_addr32[0] = (__force __be32)digest[0];
+		temp->s6_addr32[1] = (__force __be32)digest[1];
+		temp->s6_addr32[2] = (__force __be32)digest[2];
+		temp->s6_addr32[3] = (__force __be32)digest[3];
+	} else {
+		get_random_bytes(temp->s6_addr32, 16);
+	}
+
+	if (ipv6_reserved_interfaceid(*temp)) {
+		dad_count++;
+		if (dad_count > dev_net(idev->dev)->ipv6.sysctl.idgen_retries)
+			return -1;
+		goto retry;
+	}
+	ipv6_addr_prefix_copy(temp, address, rcvd_prfx_len);
+	*address = *temp;
+	return 0;
+}
+
 void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 {
 	struct prefix_info *pinfo;
@@ -2791,9 +2920,33 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 				dev_addr_generated = true;
 			}
 			goto ok;
+		} else if (pinfo->prefix_len > 0 && pinfo->prefix_len < 64 &&
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
@@ -5542,6 +5679,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_IOAM6_ENABLED] = cnf->ioam6_enabled;
 	array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
 	array[DEVCONF_IOAM6_ID_WIDE] = cnf->ioam6_id_wide;
+	array[DEVCONF_VARIABLE_SLAAC] = cnf->variable_slaac;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -6905,6 +7043,13 @@ static const struct ctl_table addrconf_sysctl[] = {
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
 		.procname	= "seg6_enabled",
 		.data		= &ipv6_devconf.seg6_enabled,

