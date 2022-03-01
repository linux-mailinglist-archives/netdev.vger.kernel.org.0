Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AB04C9874
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 23:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbiCAWob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 17:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiCAWoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 17:44:30 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9585177AB2
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 14:43:47 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id w27so29380521lfa.5
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 14:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=BfOsWUaqYnefAhkDcjp/TmBsYEFnOUkgtIpV2qlzGqA=;
        b=OAgykOEf12VlgySQrE5Ekx6CEzOh13B6AM8tMeJOIYTYtzgKsH+TtjlNfqSWtXiVcg
         ZkzbvWsXfMu7iXrICaZrQVGtSqd2EUES0PqJPprgEk3XrLVPbzeaOkncFohpnJiQKX5q
         6oe4pVql5jHAlF0BPYICnSdsD5EQaccNerWq2hCNXGaSNnYBcoRUoKxfeI/dw/JSpDNm
         9Ka8KgK2mn2xGrLPVApOWWxPh0saRIp5IJe21LfbFOMQoeyq2zgFB6eN1QRETM8q+WO5
         QD5J8TPtJvPSDrctIGhlkcALoszJlqN6OdjVqpLHUZGMuDLo0fLImWNuGve40JBDi3J1
         1lBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=BfOsWUaqYnefAhkDcjp/TmBsYEFnOUkgtIpV2qlzGqA=;
        b=4PfZjbqyzkIEqNHcTvm0fpUTU2FWOmSGODfHLLKrrOh1gilEWlVfHWWW974ikF4GMn
         8K/Zx+AFs9z+qdrY08RyweQUOG+SvUQEvTZ8y5N0PiD+mplD0cwQ99SR8GgBX/4aFxgH
         tTK1jevcmLAj5ijp7wSZz/iKd1wbcNObof34u1RqfPzsgcfnuK8wDUo3d9f2Wy09Q8sP
         csRYziOxSNQCu5c01t5/xhoPotBJuKAooVntWmJ8Ux+A1zaH6Gbm/cziRJWma4UECO14
         EwLUhCGRqHp/1rI7BftubtceoMKiTGopOuKp+jA6PHhLUjYzYBS4/BiRejceMOsbGJ8G
         odfA==
X-Gm-Message-State: AOAM532J/hSmoIK52w53djOP5bW5OAh0CFIfv8cwqZ9W1409m+8pDxQ3
        uCaRhY3fi/UsSL63xHIMq7NnIA==
X-Google-Smtp-Source: ABdhPJzFOQFrsR31eeEgv8WmsWECNX2g36ULz6Ks3v7wg3sz1ww29W/Un4EY7/AjI5XB6Z3ot/dnOw==
X-Received: by 2002:a05:6512:481:b0:43d:f703:721e with SMTP id v1-20020a056512048100b0043df703721emr17115586lfq.55.1646174624762;
        Tue, 01 Mar 2022 14:43:44 -0800 (PST)
Received: from [127.0.0.1] ([213.239.67.158])
        by smtp.gmail.com with ESMTPSA id r25-20020ac25a59000000b0044394f8a312sm1711510lfn.75.2022.03.01.14.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 14:43:44 -0800 (PST)
Date:   Tue, 01 Mar 2022 23:43:41 +0100
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: Re: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
User-Agent: K-9 Mail for Android
In-Reply-To: <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com> <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
Message-ID: <520758A5-F615-4B36-A24C-6F03C527DDC5@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1 March 2022 13:31:02 CET, Mattias Forsblad <mattias=2Eforsblad@gmail=2E=
com> wrote:
>This patch implements the bridge flag local_receive=2E When this
>flag is cleared packets received on bridge ports will not be forwarded up=
=2E
>This makes is possible to only forward traffic between the port members
>of the bridge=2E
>
>Signed-off-by: Mattias Forsblad <mattias=2Eforsblad+netdev@gmail=2Ecom>
>---
> include/linux/if_bridge=2Eh      |  6 ++++++
> include/net/switchdev=2Eh        |  2 ++
> include/uapi/linux/if_bridge=2Eh |  1 +
> include/uapi/linux/if_link=2Eh   |  1 +
> net/bridge/br=2Ec                | 18 ++++++++++++++++++
> net/bridge/br_device=2Ec         |  1 +
> net/bridge/br_input=2Ec          |  3 +++
> net/bridge/br_ioctl=2Ec          |  1 +
> net/bridge/br_netlink=2Ec        | 14 +++++++++++++-
> net/bridge/br_private=2Eh        |  2 ++
> net/bridge/br_sysfs_br=2Ec       | 23 +++++++++++++++++++++++
> net/bridge/br_vlan=2Ec           |  8 ++++++++
> 12 files changed, 79 insertions(+), 1 deletion(-)
>
>diff --git a/include/linux/if_bridge=2Eh b/include/linux/if_bridge=2Eh
>index 3aae023a9353=2E=2Ee6b77d18c1d2 100644
>--- a/include/linux/if_bridge=2Eh
>+++ b/include/linux/if_bridge=2Eh
>@@ -157,6 +157,7 @@ static inline int br_vlan_get_info_rcu(const struct n=
et_device *dev, u16 vid,
> struct net_device *br_fdb_find_port(const struct net_device *br_dev,
> 				    const unsigned char *addr,
> 				    __u16 vid);
>+bool br_local_receive_enabled(const struct net_device *dev);
> void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
> bool br_port_flag_is_set(const struct net_device *dev, unsigned long fla=
g);
> u8 br_port_get_stp_state(const struct net_device *dev);
>@@ -170,6 +171,11 @@ br_fdb_find_port(const struct net_device *br_dev,
> 	return NULL;
> }
>=20
>+static inline bool br_local_receive_enabled(const struct net_device *dev=
)
>+{
>+	return true;
>+}
>+
> static inline void br_fdb_clear_offload(const struct net_device *dev, u1=
6 vid)
> {
> }
>diff --git a/include/net/switchdev=2Eh b/include/net/switchdev=2Eh
>index 3e424d40fae3=2E=2Eaec5c1f9b5c7 100644
>--- a/include/net/switchdev=2Eh
>+++ b/include/net/switchdev=2Eh
>@@ -25,6 +25,7 @@ enum switchdev_attr_id {
> 	SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME,
> 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
> 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
>+	SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RECEIVE,
> 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
> 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
> 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
>@@ -50,6 +51,7 @@ struct switchdev_attr {
> 		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
> 		bool mc_disabled;			/* MC_DISABLED */
> 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
>+		bool local_receive;			/* BRIDGE_LOCAL_RECEIVE */
> 	} u;
> };
>=20
>diff --git a/include/uapi/linux/if_bridge=2Eh b/include/uapi/linux/if_bri=
dge=2Eh
>index 2711c3522010=2E=2Efc889b5ccd69 100644
>--- a/include/uapi/linux/if_bridge=2Eh
>+++ b/include/uapi/linux/if_bridge=2Eh
>@@ -72,6 +72,7 @@ struct __bridge_info {
> 	__u32 tcn_timer_value;
> 	__u32 topology_change_timer_value;
> 	__u32 gc_timer_value;
>+	__u8 local_receive;
> };
>=20
> struct __port_info {
>diff --git a/include/uapi/linux/if_link=2Eh b/include/uapi/linux/if_link=
=2Eh
>index e315e53125f4=2E=2Ebb7c25e1c89c 100644
>--- a/include/uapi/linux/if_link=2Eh
>+++ b/include/uapi/linux/if_link=2Eh
>@@ -482,6 +482,7 @@ enum {
> 	IFLA_BR_VLAN_STATS_PER_PORT,
> 	IFLA_BR_MULTI_BOOLOPT,
> 	IFLA_BR_MCAST_QUERIER_STATE,
>+	IFLA_BR_LOCAL_RECEIVE,

Please use the boolopt api for new boolean options
We're trying to limit the nl options expansion as the bridge is the
largest user=2E

> 	__IFLA_BR_MAX,
> };
>=20
>diff --git a/net/bridge/br=2Ec b/net/bridge/br=2Ec
>index b1dea3febeea=2E=2Eff7eb4f269ec 100644
>--- a/net/bridge/br=2Ec
>+++ b/net/bridge/br=2Ec
>@@ -325,6 +325,24 @@ void br_boolopt_multi_get(const struct net_bridge *b=
r,
> 	bm->optmask =3D GENMASK((BR_BOOLOPT_MAX - 1), 0);
> }
>=20
>+int br_local_receive_change(struct net_bridge *p,
>+			    bool local_receive)
>+{
>+	struct switchdev_attr attr =3D {
>+		=2Eorig_dev =3D p->dev,
>+		=2Eid =3D SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RECEIVE,
>+		=2Eflags =3D SWITCHDEV_F_DEFER,
>+		=2Eu=2Elocal_receive =3D local_receive,
>+	};
>+	int ret;
>+
>+	ret =3D switchdev_port_attr_set(p->dev, &attr, NULL);
>+	if (!ret)
>+		br_opt_toggle(p, BROPT_LOCAL_RECEIVE, local_receive);
>+
>+	return ret;
>+}
>+
> /* private bridge options, controlled by the kernel */
> void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool=
 on)
> {
>diff --git a/net/bridge/br_device=2Ec b/net/bridge/br_device=2Ec
>index 8d6bab244c4a=2E=2E7cd9c5880d18 100644
>--- a/net/bridge/br_device=2Ec
>+++ b/net/bridge/br_device=2Ec
>@@ -524,6 +524,7 @@ void br_dev_setup(struct net_device *dev)
> 	br->bridge_hello_time =3D br->hello_time =3D 2 * HZ;
> 	br->bridge_forward_delay =3D br->forward_delay =3D 15 * HZ;
> 	br->bridge_ageing_time =3D br->ageing_time =3D BR_DEFAULT_AGEING_TIME;
>+	br_opt_toggle(br, BROPT_LOCAL_RECEIVE, true);
> 	dev->max_mtu =3D ETH_MAX_MTU;
>=20
> 	br_netfilter_rtable_init(br);
>diff --git a/net/bridge/br_input=2Ec b/net/bridge/br_input=2Ec
>index e0c13fcc50ed=2E=2E5864b61157d3 100644
>--- a/net/bridge/br_input=2Ec
>+++ b/net/bridge/br_input=2Ec
>@@ -163,6 +163,9 @@ int br_handle_frame_finish(struct net *net, struct so=
ck *sk, struct sk_buff *skb
> 		break;
> 	}
>=20
>+	if (local_rcv && !br_opt_get(br, BROPT_LOCAL_RECEIVE))
>+		local_rcv =3D false;
>+

this affects the whole fast path, it can be better localized to make sure
it will not affect all use cases

> 	if (dst) {
> 		unsigned long now =3D jiffies;
>=20
>diff --git a/net/bridge/br_ioctl=2Ec b/net/bridge/br_ioctl=2Ec
>index f213ed108361=2E=2Eabe538129290 100644
>--- a/net/bridge/br_ioctl=2Ec
>+++ b/net/bridge/br_ioctl=2Ec
>@@ -177,6 +177,7 @@ int br_dev_siocdevprivate(struct net_device *dev, str=
uct ifreq *rq,
> 		b=2Etopology_change =3D br->topology_change;
> 		b=2Etopology_change_detected =3D br->topology_change_detected;
> 		b=2Eroot_port =3D br->root_port;
>+		b=2Elocal_receive =3D br_opt_get(br, BROPT_LOCAL_RECEIVE) ? 1 : 0;

ioctl is not being extended anymore, please drop it

>=20
> 		b=2Estp_enabled =3D (br->stp_enabled !=3D BR_NO_STP);
> 		b=2Eageing_time =3D jiffies_to_clock_t(br->ageing_time);
>diff --git a/net/bridge/br_netlink=2Ec b/net/bridge/br_netlink=2Ec
>index 7d4432ca9a20=2E=2E5e7f99950195 100644
>--- a/net/bridge/br_netlink=2Ec
>+++ b/net/bridge/br_netlink=2Ec
>@@ -1163,6 +1163,7 @@ static const struct nla_policy br_policy[IFLA_BR_MA=
X + 1] =3D {
> 	[IFLA_BR_MCAST_IGMP_VERSION] =3D { =2Etype =3D NLA_U8 },
> 	[IFLA_BR_MCAST_MLD_VERSION] =3D { =2Etype =3D NLA_U8 },
> 	[IFLA_BR_VLAN_STATS_PER_PORT] =3D { =2Etype =3D NLA_U8 },
>+	[IFLA_BR_LOCAL_RECEIVE] =3D { =2Etype =3D NLA_U8 },
> 	[IFLA_BR_MULTI_BOOLOPT] =3D
> 		NLA_POLICY_EXACT_LEN(sizeof(struct br_boolopt_multi)),
> };
>@@ -1434,6 +1435,14 @@ static int br_changelink(struct net_device *brdev,=
 struct nlattr *tb[],
> 			return err;
> 	}
>=20
>+	if (data[IFLA_BR_LOCAL_RECEIVE]) {
>+		u8 val =3D nla_get_u8(data[IFLA_BR_LOCAL_RECEIVE]);
>+
>+		err =3D br_local_receive_change(br, !!val);
>+		if (err)
>+			return err;
>+	}
>+
> 	return 0;
> }
>=20
>@@ -1514,6 +1523,7 @@ static size_t br_get_size(const struct net_device *=
brdev)
> 	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_NF_CALL_ARPTABLES */
> #endif
> 	       nla_total_size(sizeof(struct br_boolopt_multi)) + /* IFLA_BR_MUL=
TI_BOOLOPT */
>+	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_LOCAL_RECEIVE */
> 	       0;
> }
>=20
>@@ -1527,6 +1537,7 @@ static int br_fill_info(struct sk_buff *skb, const =
struct net_device *brdev)
> 	u32 stp_enabled =3D br->stp_enabled;
> 	u16 priority =3D (br->bridge_id=2Eprio[0] << 8) | br->bridge_id=2Eprio[=
1];
> 	u8 vlan_enabled =3D br_vlan_enabled(br->dev);
>+	u8 local_receive =3D br_opt_get(br, BROPT_LOCAL_RECEIVE) ? 1 : 0;
> 	struct br_boolopt_multi bm;
> 	u64 clockval;
>=20
>@@ -1563,7 +1574,8 @@ static int br_fill_info(struct sk_buff *skb, const =
struct net_device *brdev)
> 	    nla_put_u8(skb, IFLA_BR_TOPOLOGY_CHANGE_DETECTED,
> 		       br->topology_change_detected) ||
> 	    nla_put(skb, IFLA_BR_GROUP_ADDR, ETH_ALEN, br->group_addr) ||
>-	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm))
>+	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm) ||
>+	    nla_put_u8(skb, IFLA_BR_LOCAL_RECEIVE, local_receive))
> 		return -EMSGSIZE;
>=20
> #ifdef CONFIG_BRIDGE_VLAN_FILTERING
>diff --git a/net/bridge/br_private=2Eh b/net/bridge/br_private=2Eh
>index 48bc61ebc211=2E=2E01fa5426094b 100644
>--- a/net/bridge/br_private=2Eh
>+++ b/net/bridge/br_private=2Eh
>@@ -445,6 +445,7 @@ enum net_bridge_opts {
> 	BROPT_NO_LL_LEARN,
> 	BROPT_VLAN_BRIDGE_BINDING,
> 	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
>+	BROPT_LOCAL_RECEIVE,
> };
>=20
> struct net_bridge {
>@@ -720,6 +721,7 @@ int br_boolopt_multi_toggle(struct net_bridge *br,
> void br_boolopt_multi_get(const struct net_bridge *br,
> 			  struct br_boolopt_multi *bm);
> void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool=
 on);
>+int br_local_receive_change(struct net_bridge *p, bool local_receive);
>=20
> /* br_device=2Ec */
> void br_dev_setup(struct net_device *dev);
>diff --git a/net/bridge/br_sysfs_br=2Ec b/net/bridge/br_sysfs_br=2Ec
>index 3f7ca88c2aa3=2E=2E9af0c2ba929c 100644
>--- a/net/bridge/br_sysfs_br=2Ec
>+++ b/net/bridge/br_sysfs_br=2Ec
>@@ -84,6 +84,28 @@ static ssize_t forward_delay_store(struct device *d,
> }
> static DEVICE_ATTR_RW(forward_delay);
>=20
>+static ssize_t local_receive_show(struct device *d,
>+				  struct device_attribute *attr, char *buf)
>+{
>+	struct net_bridge *br =3D to_bridge(d);
>+
>+	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_LOCAL_RECEIVE));
>+}
>+
>+static int set_local_receive(struct net_bridge *br, unsigned long val,
>+			     struct netlink_ext_ack *extack)
>+{
>+	return br_local_receive_change(br, !!val);
>+}
>+
>+static ssize_t local_receive_store(struct device *d,
>+				   struct device_attribute *attr,
>+				   const char *buf, size_t len)
>+{
>+	return store_bridge_parm(d, buf, len, set_local_receive);
>+}
>+static DEVICE_ATTR_RW(local_receive);
>+

Drop sysfs too, netlink only

> static ssize_t hello_time_show(struct device *d, struct device_attribute=
 *attr,
> 			       char *buf)
> {
>@@ -950,6 +972,7 @@ static struct attribute *bridge_attrs[] =3D {
> 	&dev_attr_group_addr=2Eattr,
> 	&dev_attr_flush=2Eattr,
> 	&dev_attr_no_linklocal_learn=2Eattr,
>+	&dev_attr_local_receive=2Eattr,
> #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
> 	&dev_attr_multicast_router=2Eattr,
> 	&dev_attr_multicast_snooping=2Eattr,
>diff --git a/net/bridge/br_vlan=2Ec b/net/bridge/br_vlan=2Ec
>index 7557e90b60e1=2E=2E57dd14d5e360 100644
>--- a/net/bridge/br_vlan=2Ec
>+++ b/net/bridge/br_vlan=2Ec
>@@ -905,6 +905,14 @@ bool br_vlan_enabled(const struct net_device *dev)
> }
> EXPORT_SYMBOL_GPL(br_vlan_enabled);
>=20
>+bool br_local_receive_enabled(const struct net_device *dev)
>+{
>+	struct net_bridge *br =3D netdev_priv(dev);
>+
>+	return br_opt_get(br, BROPT_LOCAL_RECEIVE);
>+}
>+EXPORT_SYMBOL_GPL(br_local_receive_enabled);
>+

What the hell is this doing in br_vlan=2Ec???

> int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto)
> {
> 	struct net_bridge *br =3D netdev_priv(dev);

