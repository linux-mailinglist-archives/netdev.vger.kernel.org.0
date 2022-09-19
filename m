Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155365BC985
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 12:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiISK0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 06:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiISKUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 06:20:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8F82654D
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 03:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663582694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YOTFQL5o5jEs+7jz+YoectNCuvyj33bVFuVLnBFO+1g=;
        b=YfKKdrZ+oRIaySyS9ZMxSrjEZnuVLzBQn4JlMh/1JgeeitsOuDdqwGzdfvEggxmDgJjb2V
        JjPnCxaKpWvmsPRQarOQ2ZvDWhcd0qs3XyVFl4/87bRpZB3DqAGnX7z7vgRQATiqhaqcUe
        OTea0zZPRWfLKNx2/QTX5w0g17IXqaQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-288-0-5NfxKENJ-KiU6O5p8fKA-1; Mon, 19 Sep 2022 06:18:13 -0400
X-MC-Unique: 0-5NfxKENJ-KiU6O5p8fKA-1
Received: by mail-ed1-f69.google.com with SMTP id z9-20020a05640235c900b0044f0575e9ddso19924764edc.1
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 03:18:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=YOTFQL5o5jEs+7jz+YoectNCuvyj33bVFuVLnBFO+1g=;
        b=greLHk1NbJ3wGI+l+xEjx09sHCPtOsW31uvXskAB1o0QUMhMXZ9OT37sQjyAGjwy1K
         tVyx4wPW7UXmHWQwXtKY3R/kxfNJ853Z4ej6iNpZGKyZTTYkTUdyr/CkCbBtyYWKV9CQ
         my2ZfPziHvIa8JPPCrKWwIfRnalKJdzwKhVAjKSlZESPx6SLJrL5ZYRjKHAE2oUWn6Fm
         GTexQq92DOnshsZbasg0NQMmpL0pPWoSgY49w7tIQpiIolC52sxpKXUzm0T/7I9nWIhT
         RsIDlh7qpB5iiKS/hbrKhSpL/dWQXAJVXjO97jyUpcGssXwqtIQA8CU+VnYd0ILJA5iE
         +NEA==
X-Gm-Message-State: ACrzQf2+0Idcsan9FbsoRh9SkMvvaekG6ZE7U/rJ83TeHJruir3zwBWr
        6+iz/csarlEsi3N1d3MqdLNc7QnKpnjDowz87Rq0oTxvHtigbzxF7Ftm9vNp5iwGHr0h3+p4W1L
        hmmaSaeKisywUZCXU
X-Received: by 2002:a17:907:97cd:b0:780:6829:cb9d with SMTP id js13-20020a17090797cd00b007806829cb9dmr12454919ejc.344.1663582692261;
        Mon, 19 Sep 2022 03:18:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6Qj8IpM8UAQyvhXFI9wneRh9xZguxnRaXxgDoIO9Siz4AB7fJxQt+dATnRn5Hgl0uT1QLKCw==
X-Received: by 2002:a17:907:97cd:b0:780:6829:cb9d with SMTP id js13-20020a17090797cd00b007806829cb9dmr12454906ejc.344.1663582691962;
        Mon, 19 Sep 2022 03:18:11 -0700 (PDT)
Received: from [10.39.192.161] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id e10-20020a1709062c0a00b0073d638a7a89sm15454862ejh.99.2022.09.19.03.18.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Sep 2022 03:18:11 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dev@openvswitch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ovs-dev] [PATCH] [PATCH 1/2] openvswitch: Add support to count
 upall packets
Date:   Mon, 19 Sep 2022 12:18:10 +0200
X-Mailer: MailMate (1.14r5915)
Message-ID: <4B4708B6-C411-4AAF-B141-5D0C275483F4@redhat.com>
In-Reply-To: <20220914121459.1384093-1-wangchuanlei@inspur.com>
References: <20220914121459.1384093-1-wangchuanlei@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Sep 2022, at 14:14, wangchuanlei wrote:

> Add support to count upcall packets on every interface.
> I always encounter high cpu use of ovs-vswictchd, this
> help to check which interface send too many packets
> without open vlog/set switch, and have no influence
> on datapath.

Hi,

I did not do a full review, but I think we should not try to make the sam=
e mistake as before and embed a structure inside a netlink message.

You are adding =E2=80=9Cstruct ovs_vport_upcall_stats=E2=80=9D but in the=
ory, you could have just added the new entry to =E2=80=9Covs_vport_stats=E2=
=80=9D. But this is breaking userspace as it expects an exact structure s=
ize :(

So I think the right approach would be to have =E2=80=9COVS_VPORT_ATTR_UP=
CALL_STATS=E2=80=9D be an NLA_NESTED type, and have individual stat attri=
butes as NLA_U64 (or whatever type you need).

What is also confusing is that you use upcall_packets in ovs_vport_upcall=
_stats, which to me are the total of up calls, but you called it n_missed=
 in your stats. I think you should try to avoid missed in the upcall path=
, and just call it n_upcall_packets also.

In addition, I think you should keep two types of statics, and make them =
available, namely the total number of upcalls and the total of upcall fai=
lures.

Cheers,

Eelco

> Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
> ---
>  include/uapi/linux/openvswitch.h |  5 ++++
>  net/openvswitch/datapath.c       | 45 ++++++++++++++++++++++++++++++++=

>  net/openvswitch/datapath.h       | 10 +++++++
>  net/openvswitch/vport.c          | 31 ++++++++++++++++++++++
>  net/openvswitch/vport.h          |  4 +++
>  5 files changed, 95 insertions(+)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/open=
vswitch.h
> index 94066f87e9ee..8ec45511bc41 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -126,6 +126,10 @@ struct ovs_vport_stats {
>  	__u64   tx_dropped;		/* no space available in linux  */
>  };
>
> +struct ovs_vport_upcall_stats {
> +	__u64   upcall_packets;             /* total packets upcalls */
> +};
> +
>  /* Allow last Netlink attribute to be unaligned */
>  #define OVS_DP_F_UNALIGNED	(1 << 0)
>
> @@ -277,6 +281,7 @@ enum ovs_vport_attr {
>  	OVS_VPORT_ATTR_PAD,
>  	OVS_VPORT_ATTR_IFINDEX,
>  	OVS_VPORT_ATTR_NETNSID,
> +	OVS_VPORT_ATTR_UPCALL_STATS, /* struct ovs_vport_upcall_stats */
>  	__OVS_VPORT_ATTR_MAX
>  };
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index c8a9075ddd0a..f4e1f67dc57a 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -209,6 +209,23 @@ static struct vport *new_vport(const struct vport_=
parms *parms)
>  	return vport;
>  }
>
> +static void ovs_vport_upcalls(struct sk_buff *skb,
> +			      const struct dp_upcall_info *upcall_info)
> +{
> +	if (upcall_info->cmd =3D=3D OVS_PACKET_CMD_MISS ||
> +	    upcall_info->cmd =3D=3D OVS_PACKET_CMD_ACTION) {
> +		const struct vport *p =3D OVS_CB(skb)->input_vport;
> +		struct vport_upcall_stats_percpu *vport_stats;
> +		u64 *stats_counter_upcall;
> +
> +		vport_stats =3D this_cpu_ptr(p->vport_upcall_stats_percpu);
> +		stats_counter_upcall =3D &vport_stats->n_missed;
> +		u64_stats_update_begin(&vport_stats->syncp);
> +		(*stats_counter_upcall)++;
> +		u64_stats_update_end(&vport_stats->syncp);
> +	}
> +}
> +
>  void ovs_dp_detach_port(struct vport *p)
>  {
>  	ASSERT_OVSL();
> @@ -216,6 +233,9 @@ void ovs_dp_detach_port(struct vport *p)
>  	/* First drop references to device. */
>  	hlist_del_rcu(&p->dp_hash_node);
>
> +	/* Free percpu memory */
> +	free_percpu(p->vport_upcall_stats_percpu);
> +
>  	/* Then destroy it. */
>  	ovs_vport_del(p);
>  }
> @@ -308,6 +328,8 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_bu=
ff *skb,
>  	if (err)
>  		goto err;
>
> +	ovs_vport_upcalls(skb, upcall_info);
> +
>  	return 0;
>
>  err:
> @@ -1825,6 +1847,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, s=
truct genl_info *info)
>  		goto err_destroy_portids;
>  	}
>
> +	vport->vport_upcall_stats_percpu =3D
> +				netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> +	if (!vport->vport_upcall_stats_percpu) {
> +		err =3D -ENOMEM;
> +		goto err_destroy_portids;
> +	}
> +
>  	err =3D ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
>  	BUG_ON(err < 0);
> @@ -2068,6 +2097,7 @@ static int ovs_vport_cmd_fill_info(struct vport *=
vport, struct sk_buff *skb,
>  {
>  	struct ovs_header *ovs_header;
>  	struct ovs_vport_stats vport_stats;
> +	struct ovs_vport_upcall_stats vport_upcall_stats;
>  	int err;
>
>  	ovs_header =3D genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
> @@ -2097,6 +2127,13 @@ static int ovs_vport_cmd_fill_info(struct vport =
*vport, struct sk_buff *skb,
>  			  OVS_VPORT_ATTR_PAD))
>  		goto nla_put_failure;
>
> +	ovs_vport_get_upcall_stats(vport, &vport_upcall_stats);
> +	if (nla_put_64bit(skb, OVS_VPORT_ATTR_UPCALL_STATS,
> +			  sizeof(struct ovs_vport_upcall_stats),
> +			  &vport_upcall_stats,
> +			  OVS_VPORT_ATTR_PAD))
> +		goto nla_put_failure;
> +
>  	if (ovs_vport_get_upcall_portids(vport, skb))
>  		goto nla_put_failure;
>
> @@ -2278,6 +2315,14 @@ static int ovs_vport_cmd_new(struct sk_buff *skb=
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
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index 0cd29971a907..57fc002142a3 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -50,6 +50,16 @@ struct dp_stats_percpu {
>  	struct u64_stats_sync syncp;
>  };
>
> +/**
> + * struct vport_upcall_stats_percpu - per-cpu packet upcall statistics=
 for
> + * a given vport.
> + * @n_missed: Number of packets that upcall to userspace.
> + */
> +struct vport_upcall_stats_percpu {
> +	u64 n_missed;
> +	struct u64_stats_sync syncp;
> +};
> +
>  /**
>   * struct dp_nlsk_pids - array of netlink portids of for a datapath.
>   *                       This is used when OVS_DP_F_DISPATCH_UPCALL_PE=
R_CPU
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 82a74f998966..c05056f907f0 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -284,6 +284,37 @@ void ovs_vport_get_stats(struct vport *vport, stru=
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
> +	stats->upcall_packets =3D 0;
> +
> +	for_each_possible_cpu(i) {
> +		const struct vport_upcall_stats_percpu *percpu_upcall_stats;
> +		struct vport_upcall_stats_percpu local_stats;
> +		unsigned int start;
> +
> +		percpu_upcall_stats =3D per_cpu_ptr(vport->vport_upcall_stats_percpu=
, i);
> +		do {
> +			start =3D u64_stats_fetch_begin_irq(&percpu_upcall_stats->syncp);
> +			local_stats =3D *percpu_upcall_stats;
> +		} while (u64_stats_fetch_retry_irq(&percpu_upcall_stats->syncp, star=
t));
> +
> +		stats->upcall_packets +=3D local_stats.n_missed;
> +	}
> +}
> +
>  /**
>   *	ovs_vport_get_options - retrieve device options
>   *
> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
> index 7d276f60c000..6defacd6d718 100644
> --- a/net/openvswitch/vport.h
> +++ b/net/openvswitch/vport.h
> @@ -32,6 +32,9 @@ struct vport *ovs_vport_locate(const struct net *net,=
 const char *name);
>
>  void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
>
> +void ovs_vport_get_upcall_stats(struct vport *vport,
> +				struct ovs_vport_upcall_stats *stats);
> +
>  int ovs_vport_set_options(struct vport *, struct nlattr *options);
>  int ovs_vport_get_options(const struct vport *, struct sk_buff *);
>
> @@ -78,6 +81,7 @@ struct vport {
>  	struct hlist_node hash_node;
>  	struct hlist_node dp_hash_node;
>  	const struct vport_ops *ops;
> +	struct vport_upcall_stats_percpu __percpu *vport_upcall_stats_percpu;=

>
>  	struct list_head detach_list;
>  	struct rcu_head rcu;
> -- =

> 2.27.0
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev

