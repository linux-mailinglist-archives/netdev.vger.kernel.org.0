Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAEB643E27
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbiLFINI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiLFING (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:13:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C031057E
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 00:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670314327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GmpmjSbKHMulBvxZcweP4/nkndyxT09kD0wag8DfLnY=;
        b=FImgcqV3GZRPRQR5aBS6+L/3rle8NLIdJqwHnq9IPTajgbIGIyeAIdz+tx6Veas/e71ANb
        jL/6OqLF8rpoIXURqcXBtKXvwBY0PC4MfNvvcQBHApTUhwfhDpQpYRnw4WWkPXsz+VSZrm
        o7+BOB8XlNh5xjYI8z1YWFBEHRY/LPQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-297-LofjnhR4PyeegXsFc0EZQQ-1; Tue, 06 Dec 2022 03:12:06 -0500
X-MC-Unique: LofjnhR4PyeegXsFc0EZQQ-1
Received: by mail-ed1-f70.google.com with SMTP id j9-20020a05640211c900b004698365dc84so7372811edw.0
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 00:12:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GmpmjSbKHMulBvxZcweP4/nkndyxT09kD0wag8DfLnY=;
        b=7QP/L+9WSPmmt0RbJfT9k9s2Yb2Jp7txgHfVcRx+GEjD2xjJ65zrkuscdOrl4/cUGR
         5gr1rITmVTcomScUoDcclq84ymwY2S7RvQ7kxm51chHGLia9CMBzz8CHVx6Zp5GoADXQ
         tjpUeRntkvkD27a8FmeqJZxCdEizNnmRXksaERbQ65pM1EFLWNwVbEdxlvSyKtXmKHIJ
         L1yI8saxxkIa6WkR1xRJtbPWcTMLALb39k82t/tPh05OuHLNKWpIm7HJaDP6ELhkfKVl
         EzjEjv5+wTzuyOGXWuny3jX1MRgqzGY5IKADQvsIl3QnyVOWRav6dUemyDmh6tzFGR38
         3Wfg==
X-Gm-Message-State: ANoB5pmYCrtnfxmcxa2YgY8rjZa/THLN5NuEg8trttvDpvsr3AYwkea8
        ZzrpjBi9sLNnku+gGuQDisxneY1MXUvfSblENh0i8YI9VbjB1leZtruiL7MFQNFu0GX3WMdE8qT
        IopIqmYSFF5qLNa7M
X-Received: by 2002:a17:906:1914:b0:7c0:f213:f2ca with SMTP id a20-20020a170906191400b007c0f213f2camr7447385eje.21.1670314324682;
        Tue, 06 Dec 2022 00:12:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7RvWO/eVBwuF6KitHgx9D3Doy82/2BTXkQSwZfRvB8Suhd5n6JuuNEITYOzu9xPmeNN2AO6Q==
X-Received: by 2002:a17:906:1914:b0:7c0:f213:f2ca with SMTP id a20-20020a170906191400b007c0f213f2camr7447364eje.21.1670314324334;
        Tue, 06 Dec 2022 00:12:04 -0800 (PST)
Received: from [10.39.192.70] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id n14-20020aa7db4e000000b0046ae912ff36sm678855edt.84.2022.12.06.00.12.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 00:12:03 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     alexandr.lobakin@intel.com, pabeni@redhat.com, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        wangpeihui@inspur.com, netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH v7 net-next] net: openvswitch: Add support to
 count upcall packets
Date:   Tue, 06 Dec 2022 09:12:01 +0100
X-Mailer: MailMate (1.14r5929)
Message-ID: <E969E975-1D24-48F1-949E-3D5EE27AFA02@redhat.com>
In-Reply-To: <20221205030024.3990061-1-wangchuanlei@inspur.com>
References: <20221205030024.3990061-1-wangchuanlei@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5 Dec 2022, at 4:00, wangchuanlei wrote:

> Add support to count upall packets, when kmod of openvswitch
> upcall to userspace , here count the number of packets for
> upcall succeed and failed, which is a better way to see how
> many packets upcalled to userspace(ovs-vswitchd) on every
> interfaces.

Thanks for including my suggestions, one more comment below.

> Here modify format of code used by comments of v6.
>
> Changes since v4 & v5 & v6:
> - optimize the function used by comments
>
> Changes since v3:
> - use nested NLA_NESTED attribute in netlink message
>
> Changes since v2:
> - add count of upcall failed packets
>
> Changes since v1:
> - add count of upcall succeed packets
>
> Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
> ---
>  include/uapi/linux/openvswitch.h | 14 ++++++++++
>  net/openvswitch/datapath.c       | 47 ++++++++++++++++++++++++++++++++=

>  net/openvswitch/vport.c          | 40 +++++++++++++++++++++++++++
>  net/openvswitch/vport.h          | 16 +++++++++++
>  4 files changed, 117 insertions(+)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/open=
vswitch.h
> index 94066f87e9ee..8422ebf6885b 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -277,11 +277,25 @@ enum ovs_vport_attr {
>  	OVS_VPORT_ATTR_PAD,
>  	OVS_VPORT_ATTR_IFINDEX,
>  	OVS_VPORT_ATTR_NETNSID,
> +	OVS_VPORT_ATTR_UPCALL_STATS,
>  	__OVS_VPORT_ATTR_MAX
>  };
>
>  #define OVS_VPORT_ATTR_MAX (__OVS_VPORT_ATTR_MAX - 1)
>
> +/**
> + * enum ovs_vport_upcall_attr - attributes for %OVS_VPORT_UPCALL* comm=
ands
> + * @OVS_VPORT_UPCALL_SUCCESS: 64-bit upcall success packets.
> + * @OVS_VPORT_UPCALL_FAIL: 64-bit upcall fail packets.
> + */
> +enum ovs_vport_upcall_attr {
> +	OVS_VPORT_UPCALL_SUCCESS,
> +	OVS_VPORT_UPCALL_FAIL,
> +	__OVS_VPORT_UPCALL_MAX
> +};
> +
> +#define OVS_VPORT_UPCALL_MAX (__OVS_VPORT_UPCALL_MAX - 1)
> +
>  enum {
>  	OVS_VXLAN_EXT_UNSPEC,
>  	OVS_VXLAN_EXT_GBP,	/* Flag or __u32 */
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index c8a9075ddd0a..d8ca73dac3b0 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -209,6 +209,26 @@ static struct vport *new_vport(const struct vport_=
parms *parms)
>  	return vport;
>  }
>
> +static void ovs_vport_update_upcall_stats(struct sk_buff *skb,
> +					  const struct dp_upcall_info *upcall_info,
> +					  bool upcall_result)
> +{
> +	struct vport *p =3D OVS_CB(skb)->input_vport;
> +	struct vport_upcall_stats_percpu *stats;
> +
> +	if (upcall_info->cmd !=3D OVS_PACKET_CMD_MISS &&
> +	    upcall_info->cmd !=3D OVS_PACKET_CMD_ACTION)
> +		return;
> +
> +	stats =3D this_cpu_ptr(p->upcall_stats);
> +	u64_stats_update_begin(&stats->syncp);
> +	if (upcall_result)
> +		u64_stats_inc(&stats->n_success);
> +	else
> +		u64_stats_inc(&stats->n_fail);
> +	u64_stats_update_end(&stats->syncp);
> +}
> +
>  void ovs_dp_detach_port(struct vport *p)
>  {
>  	ASSERT_OVSL();
> @@ -216,6 +236,9 @@ void ovs_dp_detach_port(struct vport *p)
>  	/* First drop references to device. */
>  	hlist_del_rcu(&p->dp_hash_node);
>
> +	/* Free percpu memory */
> +	free_percpu(p->upcall_stats);
> +
>  	/* Then destroy it. */
>  	ovs_vport_del(p);
>  }
> @@ -305,6 +328,8 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_bu=
ff *skb,
>  		err =3D queue_userspace_packet(dp, skb, key, upcall_info, cutlen);
>  	else
>  		err =3D queue_gso_packets(dp, skb, key, upcall_info, cutlen);
> +
> +	ovs_vport_update_upcall_stats(skb, upcall_info, !err);
>  	if (err)
>  		goto err;
>
> @@ -1825,6 +1850,12 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, s=
truct genl_info *info)
>  		goto err_destroy_portids;
>  	}
>
> +	vport->upcall_stats =3D netdev_alloc_pcpu_stats(struct vport_upcall_s=
tats_percpu);
> +	if (!vport->upcall_stats) {
> +		err =3D -ENOMEM;
> +		goto err_destroy_portids;
> +	}
> +
>  	err =3D ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
>  	BUG_ON(err < 0);
> @@ -2068,6 +2099,7 @@ static int ovs_vport_cmd_fill_info(struct vport *=
vport, struct sk_buff *skb,
>  {
>  	struct ovs_header *ovs_header;
>  	struct ovs_vport_stats vport_stats;
> +	struct nlattr *nla;
>  	int err;
>
>  	ovs_header =3D genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
> @@ -2097,6 +2129,14 @@ static int ovs_vport_cmd_fill_info(struct vport =
*vport, struct sk_buff *skb,
>  			  OVS_VPORT_ATTR_PAD))
>  		goto nla_put_failure;
>
> +	nla =3D nla_nest_start_noflag(skb, OVS_VPORT_ATTR_UPCALL_STATS);
> +	if (!nla)
> +		goto nla_put_failure;
> +
> +	if (ovs_vport_get_upcall_stats(vport, skb))
> +		goto nla_put_failure;
> +	nla_nest_end(skb, nla);
> +

The whole nesting part should also be handled in the ovs_vport_get_upcall=
_stats() code.
So here all there should be is:

+	if (ovs_vport_get_upcall_stats(vport, skb))
+		goto nla_put_failure;

>  	if (ovs_vport_get_upcall_portids(vport, skb))
>  		goto nla_put_failure;
>
> @@ -2278,6 +2318,12 @@ static int ovs_vport_cmd_new(struct sk_buff *skb=
, struct genl_info *info)
>  		goto exit_unlock_free;
>  	}
>
> +	vport->upcall_stats =3D netdev_alloc_pcpu_stats(struct vport_upcall_s=
tats_percpu);
> +	if (!vport->upcall_stats) {
> +		err =3D -ENOMEM;
> +		goto exit_unlock_free;
> +	}
> +
>  	err =3D ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
>  				      info->snd_portid, info->snd_seq, 0,
>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
> @@ -2507,6 +2553,7 @@ static const struct nla_policy vport_policy[OVS_V=
PORT_ATTR_MAX + 1] =3D {
>  	[OVS_VPORT_ATTR_OPTIONS] =3D { .type =3D NLA_NESTED },
>  	[OVS_VPORT_ATTR_IFINDEX] =3D { .type =3D NLA_U32 },
>  	[OVS_VPORT_ATTR_NETNSID] =3D { .type =3D NLA_S32 },
> +	[OVS_VPORT_ATTR_UPCALL_STATS] =3D { .type =3D NLA_NESTED },
>  };
>
>  static const struct genl_small_ops dp_vport_genl_ops[] =3D {
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 82a74f998966..832109e3217e 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -284,6 +284,46 @@ void ovs_vport_get_stats(struct vport *vport, stru=
ct ovs_vport_stats *stats)
>  	stats->tx_packets =3D dev_stats->tx_packets;
>  }
>
> +/**
> + *	ovs_vport_get_upcall_stats - retrieve upcall stats
> + *
> + * @vport: vport from which to retrieve the stats.
> + * @skb: sk_buff where upcall stats should be appended.
> + *
> + * Retrieves upcall stats for the given device.
> + *
> + * Must be called with ovs_mutex or rcu_read_lock.
> + */
> +int ovs_vport_get_upcall_stats(struct vport *vport, struct sk_buff *sk=
b)
> +{
- > +	int i;
- > +
> +	__u64 tx_success =3D 0;
> +	__u64 tx_fail =3D 0;
  + int i;
> +
> +	for_each_possible_cpu(i) {
> +		const struct vport_upcall_stats_percpu *upcall_stats;
> +		unsigned int start;
> +
> +		upcall_stats =3D per_cpu_ptr(vport->upcall_stats, i);
> +		do {
> +			start =3D u64_stats_fetch_begin(&upcall_stats->syncp);
> +			tx_success +=3D u64_stats_read(&upcall_stats->n_success);
> +			tx_fail +=3D u64_stats_read(&upcall_stats->n_fail);
> +		} while (u64_stats_fetch_retry(&upcall_stats->syncp, start));
> +	}
> +

See above, I guess something like this (not tested):

+	nla =3D nla_nest_start_noflag(skb, OVS_VPORT_ATTR_UPCALL_STATS);
+	if (!nla)
+		return -EMSGSIZE;
+

> +	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_SUCCESS, tx_success,
> +			      OVS_VPORT_ATTR_PAD)) {
  +     nla_nest_cancel(skb, nla);
> + 	return -EMSGSIZE;
  + }
> +
> +	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_FAIL, tx_fail,
> +			      OVS_VPORT_ATTR_PAD)) {
  +     nla_nest_cancel(skb, nla);
> +		return -EMSGSIZE;
  + }
> +
+   nla_nest_end(skb, nla);
> +	return 0;
> +}
> +
>  /**
>   *	ovs_vport_get_options - retrieve device options
>   *
> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
> index 7d276f60c000..3af18b5faa95 100644
> --- a/net/openvswitch/vport.h
> +++ b/net/openvswitch/vport.h
> @@ -32,6 +32,8 @@ struct vport *ovs_vport_locate(const struct net *net,=
 const char *name);
>
>  void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
>
> +int ovs_vport_get_upcall_stats(struct vport *vport, struct sk_buff *sk=
b);
> +
>  int ovs_vport_set_options(struct vport *, struct nlattr *options);
>  int ovs_vport_get_options(const struct vport *, struct sk_buff *);
>
> @@ -65,6 +67,7 @@ struct vport_portids {
>   * @hash_node: Element in @dev_table hash table in vport.c.
>   * @dp_hash_node: Element in @datapath->ports hash table in datapath.c=
=2E
>   * @ops: Class structure.
> + * @upcall_stats: Upcall stats of every ports.
>   * @detach_list: list used for detaching vport in net-exit call.
>   * @rcu: RCU callback head for deferred destruction.
>   */
> @@ -78,6 +81,7 @@ struct vport {
>  	struct hlist_node hash_node;
>  	struct hlist_node dp_hash_node;
>  	const struct vport_ops *ops;
> +	struct vport_upcall_stats_percpu __percpu *upcall_stats;
>
>  	struct list_head detach_list;
>  	struct rcu_head rcu;
> @@ -137,6 +141,18 @@ struct vport_ops {
>  	struct list_head list;
>  };
>
> +/**
> + * struct vport_upcall_stats_percpu - per-cpu packet upcall statistics=
 for
> + * a given vport.
> + * @n_success: Number of packets that upcall to userspace succeed.
> + * @n_fail:    Number of packets that upcall to userspace failed.
> + */
> +struct vport_upcall_stats_percpu {
> +	struct u64_stats_sync syncp;
> +	u64_stats_t n_success;
> +	u64_stats_t n_fail;
> +};
> +
>  struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *,=

>  			      const struct vport_parms *);
>  void ovs_vport_free(struct vport *);
> -- =

> 2.27.0

