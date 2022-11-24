Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EFF637335
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 08:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiKXH7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 02:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKXH7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 02:59:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32DEC5636
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 23:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669276726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7BSse/GgXaVxARdtvwgzu/g/qTpt/zDvXHsnw/jcFqA=;
        b=OKg6zGA3GYFIVW0HPExCgYflE3+6pNuWcTC1p08uwh7mZti0heUWtnTYuwYg8eAWxVQ1NN
        oTZkBxOOL0JEP7TGo5mzJcste4YmZZSmb/uGkajywpJuXznUAUxjnj+CZcaBiCa+aH03Hc
        r+fo7nlR6rbXY/7SMizQJfWzymJkA/Y=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-54-42DafqHtOviPXLoOA63NLw-1; Thu, 24 Nov 2022 02:58:44 -0500
X-MC-Unique: 42DafqHtOviPXLoOA63NLw-1
Received: by mail-ed1-f69.google.com with SMTP id z15-20020a05640240cf00b00461b253c220so531097edb.3
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 23:58:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7BSse/GgXaVxARdtvwgzu/g/qTpt/zDvXHsnw/jcFqA=;
        b=zcW6f5E3Vxz8V0u9bgaOkmEk3qmYUPTq2Urs7BeRHZ60R/8uPJ+pFng3Z19A1xhW7H
         2t/fh7lDJDP7Iz1oiGLfYTNG1RzhgH2NW77i1Gmin5Xi6IjQksOgBOcF+ZiocLWZSxKQ
         RMcqJRoNogPctmtYfa664/HbNZPHMHvCpwkQJ1iUEI/OCE49HpLOMz2bp88kMi7rraZy
         wliElPHWCPbjdFh3h+AUTW+mOHCSX/cpqVRPBOz7zMZQPrt8iwbXxb3cdZDwwGa1MDJh
         8BJ8SszZ0RofvYQWbaqh2zG34CEqmBV+JIbAeXZUKaPuro3gS8lqA4h5gANK++NqKKc5
         QcTA==
X-Gm-Message-State: ANoB5pn+o6LB3aWLz8iHNk6KGR8vDyEqbrAkT1illXXnRFjrc5QTE1pV
        TXg53NDuXwqXM1mBFQ1EkJk2v6425hJcq33ePHL84LuLMwdjIU4Ax0Q7qGcFHR7w2ylHUms4RqK
        I1euox00+p3KefrUj
X-Received: by 2002:a17:906:4e14:b0:7b2:b15e:8ab1 with SMTP id z20-20020a1709064e1400b007b2b15e8ab1mr19062769eju.659.1669276722779;
        Wed, 23 Nov 2022 23:58:42 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5jx1TDKnhSKwqGKKvGXHmHkNAptecLVa6vPTSOPqrwI+S4fZwdd7MtEsYTLRzB3WQUB9rEuw==
X-Received: by 2002:a17:906:4e14:b0:7b2:b15e:8ab1 with SMTP id z20-20020a1709064e1400b007b2b15e8ab1mr19062751eju.659.1669276722416;
        Wed, 23 Nov 2022 23:58:42 -0800 (PST)
Received: from [10.39.192.198] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id t12-20020aa7d4cc000000b00458824aee80sm217618edr.38.2022.11.23.23.58.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Nov 2022 23:58:41 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     pabeni@redhat.com, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, wangpeihui@inspur.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [openvswitch v4] openvswitch: Add support to count upcall
 packets
Date:   Thu, 24 Nov 2022 08:58:40 +0100
X-Mailer: MailMate (1.14r5927)
Message-ID: <2E85BE67-3BA6-465B-8F39-218E733DBEFA@redhat.com>
In-Reply-To: <20221123091843.3414856-1-wangchuanlei@inspur.com>
References: <20221123091843.3414856-1-wangchuanlei@inspur.com>
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



On 23 Nov 2022, at 10:18, wangchuanlei wrote:

> Add support to count upall packets, when kmod of openvswitch
> upcall to userspace , here count the number of packets for
> upcall succeed and failed, which is a better way to see how
> many packets upcalled to userspace(ovs-vswitchd) on every
> interfaces.
>
> Here optimize the function used by comments of v3.
>
> Changes since v3:
> - use nested NLA_NESTED attribute in netlink message
>
> Changes since v2:
> - add count of upcall failed packets
>
> Changes since v1:
> - add count of upcall succeed packets

There is already a review from Alexander, so I only commented on some thi=
ngs that caught my attention after glazing over the patch.
I will do a full review of the next revisions.

//Eelco


> Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
> ---
>  include/uapi/linux/openvswitch.h | 19 ++++++++++++
>  net/openvswitch/datapath.c       | 52 ++++++++++++++++++++++++++++++++=

>  net/openvswitch/datapath.h       | 12 ++++++++
>  net/openvswitch/vport.c          | 48 +++++++++++++++++++++++++++++
>  net/openvswitch/vport.h          |  6 ++++
>  5 files changed, 137 insertions(+)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/open=
vswitch.h
> index 94066f87e9ee..fa13bce15fae 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -126,6 +126,11 @@ struct ovs_vport_stats {
>  	__u64   tx_dropped;		/* no space available in linux  */
>  };
>
> +struct ovs_vport_upcall_stats {
> +	uint64_t   upcall_success;	/* total packets upcalls succeed */
> +	uint64_t   upcall_fail;		/* total packets upcalls failed  */
> +};

This is no longer a user API data structure, so it should be removed from=
 this include.

> +
>  /* Allow last Netlink attribute to be unaligned */
>  #define OVS_DP_F_UNALIGNED	(1 << 0)
>
> @@ -277,11 +282,25 @@ enum ovs_vport_attr {
>  	OVS_VPORT_ATTR_PAD,
>  	OVS_VPORT_ATTR_IFINDEX,
>  	OVS_VPORT_ATTR_NETNSID,
> +	OVS_VPORT_ATTR_UPCALL_STATS, /* struct ovs_vport_upcall_stats */
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
> +	OVS_VPORT_UPCALL_SUCCESS, /* 64-bit upcall success packets */
> +	OVS_VPORT_UPCALL_FAIL, /* 64-bit upcall fail packets */
> +	__OVS_VPORT_UPCALL_MAX
> +};

Here you have comments ending with and without a dot (.), maybe make it u=
niform.
Maybe the comment on the structure can be removed as they are explained r=
ight above?


> +
> +#define OVS_VPORT_UPCALL_MAX (__OVS_VPORT_UPCALL_MAX-1)
> +
>  enum {
>  	OVS_VXLAN_EXT_UNSPEC,
>  	OVS_VXLAN_EXT_GBP,	/* Flag or __u32 */
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index c8a9075ddd0a..5254c51cfa60 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -209,6 +209,25 @@ static struct vport *new_vport(const struct vport_=
parms *parms)
>  	return vport;
>  }
>
> +static void ovs_vport_upcalls(struct sk_buff *skb,
> +			      const struct dp_upcall_info *upcall_info,
> +			      bool upcall_success)
> +{
> +	if (upcall_info->cmd =3D=3D OVS_PACKET_CMD_MISS ||
> +	    upcall_info->cmd =3D=3D OVS_PACKET_CMD_ACTION) {
> +		const struct vport *p =3D OVS_CB(skb)->input_vport;
> +		struct vport_upcall_stats_percpu *vport_stats;
> +
> +		vport_stats =3D this_cpu_ptr(p->vport_upcall_stats_percpu);
> +		u64_stats_update_begin(&vport_stats->syncp);
> +		if (upcall_success)
> +			u64_stats_inc(&vport_stats->n_upcall_success);
> +		else
> +			u64_stats_inc(&vport_stats->n_upcall_fail);
> +		u64_stats_update_end(&vport_stats->syncp);
> +	}
> +}
> +
>  void ovs_dp_detach_port(struct vport *p)
>  {
>  	ASSERT_OVSL();
> @@ -216,6 +235,9 @@ void ovs_dp_detach_port(struct vport *p)
>  	/* First drop references to device. */
>  	hlist_del_rcu(&p->dp_hash_node);
>
> +	/* Free percpu memory */
> +	free_percpu(p->vport_upcall_stats_percpu);
> +
>  	/* Then destroy it. */
>  	ovs_vport_del(p);
>  }
> @@ -305,6 +327,8 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_bu=
ff *skb,
>  		err =3D queue_userspace_packet(dp, skb, key, upcall_info, cutlen);
>  	else
>  		err =3D queue_gso_packets(dp, skb, key, upcall_info, cutlen);
> +
> +	ovs_vport_upcalls(skb, upcall_info, !err);
>  	if (err)
>  		goto err;
>
> @@ -1825,6 +1849,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, s=
truct genl_info *info)
>  		goto err_destroy_portids;
>  	}
>
> +	vport->vport_upcall_stats_percpu =3D
> +				netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +	if (!vport->vport_upcall_stats_percpu) {
> +		err =3D -ENOMEM;
> +		goto err_destroy_upcall_stats;
> +	}
> +
>  	err =3D ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
>  	BUG_ON(err < 0);
> @@ -1837,6 +1868,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, st=
ruct genl_info *info)
>  	ovs_notify(&dp_datapath_genl_family, reply, info);
>  	return 0;
>
> +err_destroy_upcall_stats:
>  err_destroy_portids:
>  	kfree(rcu_dereference_raw(dp->upcall_portids));
>  err_unlock_and_destroy_meters:
> @@ -2068,6 +2100,8 @@ static int ovs_vport_cmd_fill_info(struct vport *=
vport, struct sk_buff *skb,
>  {
>  	struct ovs_header *ovs_header;
>  	struct ovs_vport_stats vport_stats;
> +	struct ovs_vport_upcall_stats stat;
> +	struct nlattr *nla;
>  	int err;
>
>  	ovs_header =3D genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
> @@ -2097,6 +2131,15 @@ static int ovs_vport_cmd_fill_info(struct vport =
*vport, struct sk_buff *skb,
>  			  OVS_VPORT_ATTR_PAD))
>  		goto nla_put_failure;
>
> +	nla =3D nla_nest_start_noflag(skb, OVS_VPORT_ATTR_UPCALL_STATS);
> +	if (!nla)
> +		goto nla_put_failure;
> +
> +	ovs_vport_get_upcall_stats(vport, &stat);
> +	if (ovs_vport_put_upcall_stats(skb, &stat))
> +		goto nla_put_failure;
> +	nla_nest_end(skb, nla);
> +
>  	if (ovs_vport_get_upcall_portids(vport, skb))
>  		goto nla_put_failure;
>
> @@ -2278,6 +2321,14 @@ static int ovs_vport_cmd_new(struct sk_buff *skb=
, struct genl_info *info)
>  		goto exit_unlock_free;
>  	}
>
> +	vport->vport_upcall_stats_percpu =3D
> +		netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +
> +	if (!vport->vport_upcall_stats_percpu) {
> +		err =3D -ENOMEM;
> +		goto exit_unlock_free;
> +	}
> +
>  	err =3D ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
>  				      info->snd_portid, info->snd_seq, 0,
>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
> @@ -2507,6 +2558,7 @@ static const struct nla_policy vport_policy[OVS_V=
PORT_ATTR_MAX + 1] =3D {
>  	[OVS_VPORT_ATTR_OPTIONS] =3D { .type =3D NLA_NESTED },
>  	[OVS_VPORT_ATTR_IFINDEX] =3D { .type =3D NLA_U32 },
>  	[OVS_VPORT_ATTR_NETNSID] =3D { .type =3D NLA_S32 },
> +	[OVS_VPORT_ATTR_UPCALL_STATS] =3D { .type =3D NLA_NESTED },
>  };
>
>  static const struct genl_small_ops dp_vport_genl_ops[] =3D {
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index 0cd29971a907..933dec5e4175 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -50,6 +50,18 @@ struct dp_stats_percpu {
>  	struct u64_stats_sync syncp;
>  };
>
> +/**
> + * struct vport_upcall_stats_percpu - per-cpu packet upcall statistics=
 for
> + * a given vport.
> + * @n_upcall_success: Number of packets that upcall to userspace succe=
ed.
> + * @n_upcall_fail:    Number of packets that upcall to userspace faile=
d.
> + */
> +struct vport_upcall_stats_percpu {
> +	u64_stats_t n_upcall_success;
> +	u64_stats_t n_upcall_fail;
> +	struct u64_stats_sync syncp;
> +};
> +
>  /**
>   * struct dp_nlsk_pids - array of netlink portids of for a datapath.
>   *                       This is used when OVS_DP_F_DISPATCH_UPCALL_PE=
R_CPU
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 82a74f998966..a69c9356b57c 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -284,6 +284,54 @@ void ovs_vport_get_stats(struct vport *vport, stru=
ct ovs_vport_stats *stats)
>  	stats->tx_packets =3D dev_stats->tx_packets;
>  }
>
> +/**
> + *	ovs_vport_get_upcall_stats - retrieve upcall stats
> + *
> + * @vport: vport from which to retrieve the stats
> + * @ovs_vport_upcall_stats: location to store stats
> + *
> + * Retrieves upcall stats for the given device.
> + *
> + * Must be called with ovs_mutex or rcu_read_lock.
> + */
> +void ovs_vport_get_upcall_stats(struct vport *vport, struct ovs_vport_=
upcall_stats *stats)
> +{
> +	int i;
> +
> +	stats->upcall_success =3D 0;
> +	stats->upcall_fail =3D 0;
> +
> +	for_each_possible_cpu(i) {
> +		const struct vport_upcall_stats_percpu *percpu_upcall_stats;
> +		unsigned int start;
> +
> +		percpu_upcall_stats =3D per_cpu_ptr(vport->vport_upcall_stats_percpu=
, i);
> +		do {
> +			start =3D u64_stats_fetch_begin(&percpu_upcall_stats->syncp);
> +			stats->upcall_success +=3D
> +				u64_stats_read(&percpu_upcall_stats->n_upcall_success);
> +			stats->upcall_fail +=3D u64_stats_read(&percpu_upcall_stats->n_upca=
ll_fail);
> +		} while (u64_stats_fetch_retry(&percpu_upcall_stats->syncp, start));=

> +	}
> +}
> +
> +int ovs_vport_put_upcall_stats(struct sk_buff *skb,
> +			       struct ovs_vport_upcall_stats *stats)
> +{
> +	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_SUCCESS, stats->upcall_su=
ccess,
> +			      OVS_VPORT_ATTR_PAD))
> +		goto nla_put_failure;
> +
> +	if (nla_put_u64_64bit(skb, OVS_VPORT_UPCALL_FAIL, stats->upcall_fail,=

> +			      OVS_VPORT_ATTR_PAD))
> +		goto nla_put_failure;
> +
> +	return 0;
> +
> +nla_put_failure:
> +	return -EMSGSIZE;
> +}
> +
>  /**
>   *	ovs_vport_get_options - retrieve device options
>   *
> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
> index 7d276f60c000..02cf8c589588 100644
> --- a/net/openvswitch/vport.h
> +++ b/net/openvswitch/vport.h
> @@ -32,6 +32,11 @@ struct vport *ovs_vport_locate(const struct net *net=
, const char *name);
>
>  void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
>
> +void ovs_vport_get_upcall_stats(struct vport *vport,
> +				struct ovs_vport_upcall_stats *stats);
> +int ovs_vport_put_upcall_stats(struct sk_buff *skb,
> +			       struct ovs_vport_upcall_stats *stats);
> +
>  int ovs_vport_set_options(struct vport *, struct nlattr *options);
>  int ovs_vport_get_options(const struct vport *, struct sk_buff *);
>
> @@ -78,6 +83,7 @@ struct vport {
>  	struct hlist_node hash_node;
>  	struct hlist_node dp_hash_node;
>  	const struct vport_ops *ops;
> +	struct vport_upcall_stats_percpu __percpu *vport_upcall_stats_percpu;=

>
>  	struct list_head detach_list;
>  	struct rcu_head rcu;
> -- =

> 2.27.0

