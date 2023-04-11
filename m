Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924126DD968
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjDKLbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjDKLbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:31:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A023E3AAB;
        Tue, 11 Apr 2023 04:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681212707; x=1712748707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lhb+T5/E552pdVpDB0h21avuKBJ4qz3RuhyW5iasgEM=;
  b=V8+7LvHeS3T2h72Q949BHLDzc/UbMKDmUlvNNkssRCYlhYYch7aeq7tM
   LbymrtA/DTqHsql8daruIzUXpRFlB8YXFHxBXT7ZwhhKYRhZcagxCzx26
   BnlqkUXNllyIRHktEcDmt7seP02KIjAfWPQS5SekM8qb7/ellTD7acOUj
   Otxbph37ybkOligB+jr3fNUezPSNV8/5YM9HItlic0vCRcheMaXgB/Q3+
   heyKbWochpT1YFPBhD8UDD+Qypxw0Km7g4ygTdS8Xeb3s4Vp7c63tlnGp
   csmFtj9NC7ECePjd9Vl0fY+QSkMyBg4SwIjGgGHWj5XZFypVIrig09+Bd
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,336,1673938800"; 
   d="scan'208";a="220340774"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Apr 2023 04:31:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 11 Apr 2023 04:31:46 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 11 Apr 2023 04:31:45 -0700
Date:   Tue, 11 Apr 2023 13:31:45 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Simon Horman <horms@kernel.org>
CC:     Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <lvs-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v2 3/4] ipvs: Remove {Enter,Leave}Function
Message-ID: <20230411113145.vjzmzuvea6yiv6jy@soft-dev3-1>
References: <20230409-ipvs-cleanup-v2-0-204cd17da708@kernel.org>
 <20230409-ipvs-cleanup-v2-3-204cd17da708@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230409-ipvs-cleanup-v2-3-204cd17da708@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/11/2023 09:10, Simon Horman wrote:
> 
> Remove EnterFunction and LeaveFunction.
> 
> These debugging macros seem well past their use-by date.  And seem to
> have little value these days. Removing them allows some trivial cleanup
> of some exit paths for some functions. These are also included in this
> patch. There is likely scope for further cleanup of both debugging and
> unwind paths. But let's leave that for another day.
> 
> Only intended to change debug output, and only when CONFIG_IP_VS_DEBUG
> is enabled. Compile tested only.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
>  include/net/ip_vs.h             | 20 -------------
>  net/netfilter/ipvs/ip_vs_core.c |  8 ------
>  net/netfilter/ipvs/ip_vs_ctl.c  | 26 +----------------
>  net/netfilter/ipvs/ip_vs_sync.c |  5 ----
>  net/netfilter/ipvs/ip_vs_xmit.c | 62 ++++++-----------------------------------
>  5 files changed, 9 insertions(+), 112 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index e20f1f92066d..a3adc246ee31 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -265,26 +265,6 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
>                         pr_err(msg, ##__VA_ARGS__);                     \
>         } while (0)
> 
> -#ifdef CONFIG_IP_VS_DEBUG
> -#define EnterFunction(level)                                           \
> -       do {                                                            \
> -               if (level <= ip_vs_get_debug_level())                   \
> -                       printk(KERN_DEBUG                               \
> -                              pr_fmt("Enter: %s, %s line %i\n"),       \
> -                              __func__, __FILE__, __LINE__);           \
> -       } while (0)
> -#define LeaveFunction(level)                                           \
> -       do {                                                            \
> -               if (level <= ip_vs_get_debug_level())                   \
> -                       printk(KERN_DEBUG                               \
> -                              pr_fmt("Leave: %s, %s line %i\n"),       \
> -                              __func__, __FILE__, __LINE__);           \
> -       } while (0)
> -#else
> -#define EnterFunction(level)   do {} while (0)
> -#define LeaveFunction(level)   do {} while (0)
> -#endif
> -
>  /* The port number of FTP service (in network order). */
>  #define FTPPORT  cpu_to_be16(21)
>  #define FTPDATA  cpu_to_be16(20)
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 2fcc26507d69..cb83ca506c5c 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1140,7 +1140,6 @@ struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
>         __be16 vport;
>         unsigned int flags;
> 
> -       EnterFunction(12);
>         vaddr = &svc->addr;
>         vport = svc->port;
>         daddr = &iph->saddr;
> @@ -1208,7 +1207,6 @@ struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
>                       IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
>                       IP_VS_DBG_ADDR(cp->af, &cp->daddr), ntohs(cp->dport),
>                       cp->flags, refcount_read(&cp->refcnt));
> -       LeaveFunction(12);
>         return cp;
>  }
> 
> @@ -1316,13 +1314,11 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
>                 ip_vs_update_conntrack(skb, cp, 0);
>         ip_vs_conn_put(cp);
> 
> -       LeaveFunction(11);
>         return NF_ACCEPT;
> 
>  drop:
>         ip_vs_conn_put(cp);
>         kfree_skb(skb);
> -       LeaveFunction(11);
>         return NF_STOLEN;
>  }
> 
> @@ -1341,8 +1337,6 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
>         int af = state->pf;
>         struct sock *sk;
> 
> -       EnterFunction(11);
> -
>         /* Already marked as IPVS request or reply? */
>         if (skb->ipvs_property)
>                 return NF_ACCEPT;
> @@ -2365,7 +2359,6 @@ static void __net_exit __ip_vs_dev_cleanup_batch(struct list_head *net_list)
>         struct netns_ipvs *ipvs;
>         struct net *net;
> 
> -       EnterFunction(2);
>         list_for_each_entry(net, net_list, exit_list) {
>                 ipvs = net_ipvs(net);
>                 ip_vs_unregister_hooks(ipvs, AF_INET);
> @@ -2374,7 +2367,6 @@ static void __net_exit __ip_vs_dev_cleanup_batch(struct list_head *net_list)
>                 smp_wmb();
>                 ip_vs_sync_net_cleanup(ipvs);
>         }
> -       LeaveFunction(2);
>  }
> 
>  static struct pernet_operations ipvs_core_ops = {
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 2a5ed71c82c3..62606fb44d02 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -1061,8 +1061,6 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>         unsigned int atype;
>         int ret;
> 
> -       EnterFunction(2);
> -
>  #ifdef CONFIG_IP_VS_IPV6
>         if (udest->af == AF_INET6) {
>                 atype = ipv6_addr_type(&udest->addr.in6);
> @@ -1111,7 +1109,6 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>         spin_lock_init(&dest->dst_lock);
>         __ip_vs_update_dest(svc, dest, udest, 1);
> 
> -       LeaveFunction(2);
>         return 0;
> 
>  err_stats:
> @@ -1134,8 +1131,6 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>         __be16 dport = udest->port;
>         int ret;
> 
> -       EnterFunction(2);
> -
>         if (udest->weight < 0) {
>                 pr_err("%s(): server weight less than zero\n", __func__);
>                 return -ERANGE;
> @@ -1183,7 +1178,7 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
> 
>                 ret = ip_vs_start_estimator(svc->ipvs, &dest->stats);
>                 if (ret < 0)
> -                       goto err;
> +                       return ret;
>                 __ip_vs_update_dest(svc, dest, udest, 1);
>         } else {
>                 /*
> @@ -1192,9 +1187,6 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>                 ret = ip_vs_new_dest(svc, udest);
>         }
> 
> -err:
> -       LeaveFunction(2);
> -
>         return ret;
>  }
> 
> @@ -1209,8 +1201,6 @@ ip_vs_edit_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>         union nf_inet_addr daddr;
>         __be16 dport = udest->port;
> 
> -       EnterFunction(2);
> -
>         if (udest->weight < 0) {
>                 pr_err("%s(): server weight less than zero\n", __func__);
>                 return -ERANGE;
> @@ -1242,7 +1232,6 @@ ip_vs_edit_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>         }
> 
>         __ip_vs_update_dest(svc, dest, udest, 0);
> -       LeaveFunction(2);
> 
>         return 0;
>  }
> @@ -1317,8 +1306,6 @@ ip_vs_del_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>         struct ip_vs_dest *dest;
>         __be16 dport = udest->port;
> 
> -       EnterFunction(2);
> -
>         /* We use function that requires RCU lock */
>         rcu_read_lock();
>         dest = ip_vs_lookup_dest(svc, udest->af, &udest->addr, dport);
> @@ -1339,8 +1326,6 @@ ip_vs_del_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>          */
>         __ip_vs_del_dest(svc->ipvs, dest, false);
> 
> -       LeaveFunction(2);
> -
>         return 0;
>  }
> 
> @@ -1746,7 +1731,6 @@ void ip_vs_service_nets_cleanup(struct list_head *net_list)
>         struct netns_ipvs *ipvs;
>         struct net *net;
> 
> -       EnterFunction(2);
>         /* Check for "full" addressed entries */
>         mutex_lock(&__ip_vs_mutex);
>         list_for_each_entry(net, net_list, exit_list) {
> @@ -1754,7 +1738,6 @@ void ip_vs_service_nets_cleanup(struct list_head *net_list)
>                 ip_vs_flush(ipvs, true);
>         }
>         mutex_unlock(&__ip_vs_mutex);
> -       LeaveFunction(2);
>  }
> 
>  /* Put all references for device (dst_cache) */
> @@ -1792,7 +1775,6 @@ static int ip_vs_dst_event(struct notifier_block *this, unsigned long event,
>         if (event != NETDEV_DOWN || !ipvs)
>                 return NOTIFY_DONE;
>         IP_VS_DBG(3, "%s() dev=%s\n", __func__, dev->name);
> -       EnterFunction(2);
>         mutex_lock(&__ip_vs_mutex);
>         for (idx = 0; idx < IP_VS_SVC_TAB_SIZE; idx++) {
>                 hlist_for_each_entry(svc, &ip_vs_svc_table[idx], s_list) {
> @@ -1821,7 +1803,6 @@ static int ip_vs_dst_event(struct notifier_block *this, unsigned long event,
>         }
>         spin_unlock_bh(&ipvs->dest_trash_lock);
>         mutex_unlock(&__ip_vs_mutex);
> -       LeaveFunction(2);
>         return NOTIFY_DONE;
>  }
> 
> @@ -4537,8 +4518,6 @@ int __init ip_vs_control_init(void)
>         int idx;
>         int ret;
> 
> -       EnterFunction(2);
> -
>         /* Initialize svc_table, ip_vs_svc_fwm_table */
>         for (idx = 0; idx < IP_VS_SVC_TAB_SIZE; idx++) {
>                 INIT_HLIST_HEAD(&ip_vs_svc_table[idx]);
> @@ -4551,15 +4530,12 @@ int __init ip_vs_control_init(void)
>         if (ret < 0)
>                 return ret;
> 
> -       LeaveFunction(2);
>         return 0;
>  }
> 
> 
>  void ip_vs_control_cleanup(void)
>  {
> -       EnterFunction(2);
>         unregister_netdevice_notifier(&ip_vs_dst_notifier);
>         /* relying on common rcu_barrier() in ip_vs_cleanup() */
> -       LeaveFunction(2);
>  }
> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index d4fe7bb4f853..264f2f87a437 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -1582,13 +1582,11 @@ ip_vs_send_async(struct socket *sock, const char *buffer, const size_t length)
>         struct kvec     iov;
>         int             len;
> 
> -       EnterFunction(7);
>         iov.iov_base     = (void *)buffer;
>         iov.iov_len      = length;
> 
>         len = kernel_sendmsg(sock, &msg, &iov, 1, (size_t)(length));
> 
> -       LeaveFunction(7);
>         return len;
>  }
> 
> @@ -1614,15 +1612,12 @@ ip_vs_receive(struct socket *sock, char *buffer, const size_t buflen)
>         struct kvec             iov = {buffer, buflen};
>         int                     len;
> 
> -       EnterFunction(7);
> -
>         /* Receive a packet */
>         iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, buflen);
>         len = sock_recvmsg(sock, &msg, MSG_DONTWAIT);
>         if (len < 0)
>                 return len;
> 
> -       LeaveFunction(7);
>         return len;
>  }
> 
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index 99c349c0d968..feb1d7fcb09f 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -706,8 +706,6 @@ ip_vs_bypass_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>  {
>         struct iphdr  *iph = ip_hdr(skb);
> 
> -       EnterFunction(10);
> -
>         if (__ip_vs_get_out_rt(cp->ipvs, cp->af, skb, NULL, iph->daddr,
>                                IP_VS_RT_MODE_NON_LOCAL, NULL, ipvsh) < 0)
>                 goto tx_error;
> @@ -719,12 +717,10 @@ ip_vs_bypass_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
> 
>         ip_vs_send_or_cont(NFPROTO_IPV4, skb, cp, 0);
> 
> -       LeaveFunction(10);
>         return NF_STOLEN;
> 
>   tx_error:
>         kfree_skb(skb);
> -       LeaveFunction(10);
>         return NF_STOLEN;
>  }
> 
> @@ -735,8 +731,6 @@ ip_vs_bypass_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>  {
>         struct ipv6hdr *iph = ipv6_hdr(skb);
> 
> -       EnterFunction(10);
> -
>         if (__ip_vs_get_out_rt_v6(cp->ipvs, cp->af, skb, NULL,
>                                   &iph->daddr, NULL,
>                                   ipvsh, 0, IP_VS_RT_MODE_NON_LOCAL) < 0)
> @@ -747,12 +741,10 @@ ip_vs_bypass_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
> 
>         ip_vs_send_or_cont(NFPROTO_IPV6, skb, cp, 0);
> 
> -       LeaveFunction(10);
>         return NF_STOLEN;
> 
>   tx_error:
>         kfree_skb(skb);
> -       LeaveFunction(10);
>         return NF_STOLEN;
>  }
>  #endif
> @@ -768,8 +760,6 @@ ip_vs_nat_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>         struct rtable *rt;              /* Route to the other host */
>         int local, rc, was_input;
> 
> -       EnterFunction(10);
> -
>         /* check if it is a connection of no-client-port */
>         if (unlikely(cp->flags & IP_VS_CONN_F_NO_CPORT)) {
>                 __be16 _pt, *p;
> @@ -839,12 +829,10 @@ ip_vs_nat_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
> 
>         rc = ip_vs_nat_send_or_cont(NFPROTO_IPV4, skb, cp, local);
> 
> -       LeaveFunction(10);
>         return rc;
> 
>    tx_error:
>         kfree_skb(skb);
> -       LeaveFunction(10);
>         return NF_STOLEN;
>  }
> 
> @@ -856,8 +844,6 @@ ip_vs_nat_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>         struct rt6_info *rt;            /* Route to the other host */
>         int local, rc;
> 
> -       EnterFunction(10);
> -
>         /* check if it is a connection of no-client-port */
>         if (unlikely(cp->flags & IP_VS_CONN_F_NO_CPORT && !ipvsh->fragoffs)) {
>                 __be16 _pt, *p;
> @@ -927,11 +913,9 @@ ip_vs_nat_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
> 
>         rc = ip_vs_nat_send_or_cont(NFPROTO_IPV6, skb, cp, local);
> 
> -       LeaveFunction(10);
>         return rc;
> 
>  tx_error:
> -       LeaveFunction(10);
>         kfree_skb(skb);
>         return NF_STOLEN;
>  }
> @@ -1149,8 +1133,6 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>         int tun_type, gso_type;
>         int tun_flags;
> 
> -       EnterFunction(10);
> -
>         local = __ip_vs_get_out_rt(ipvs, cp->af, skb, cp->dest, cp->daddr.ip,
>                                    IP_VS_RT_MODE_LOCAL |
>                                    IP_VS_RT_MODE_NON_LOCAL |
> @@ -1199,7 +1181,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>                                          &next_protocol, NULL, &dsfield,
>                                          &ttl, dfp);
>         if (IS_ERR(skb))
> -               goto tx_error;
> +               return NF_STOLEN;
> 
>         gso_type = __tun_gso_type_mask(AF_INET, cp->af);
>         if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
> @@ -1267,14 +1249,10 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>         else if (ret == NF_DROP)
>                 kfree_skb(skb);
> 
> -       LeaveFunction(10);
> -
>         return NF_STOLEN;
> 
>    tx_error:
> -       if (!IS_ERR(skb))
> -               kfree_skb(skb);
> -       LeaveFunction(10);
> +       kfree_skb(skb);
>         return NF_STOLEN;
>  }
> 
> @@ -1298,8 +1276,6 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>         int tun_type, gso_type;
>         int tun_flags;
> 
> -       EnterFunction(10);
> -
>         local = __ip_vs_get_out_rt_v6(ipvs, cp->af, skb, cp->dest,
>                                       &cp->daddr.in6,
>                                       &saddr, ipvsh, 1,
> @@ -1347,7 +1323,7 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>                                          &next_protocol, &payload_len,
>                                          &dsfield, &ttl, NULL);
>         if (IS_ERR(skb))
> -               goto tx_error;
> +               return NF_STOLEN;
> 
>         gso_type = __tun_gso_type_mask(AF_INET6, cp->af);
>         if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
> @@ -1414,14 +1390,10 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>         else if (ret == NF_DROP)
>                 kfree_skb(skb);
> 
> -       LeaveFunction(10);
> -
>         return NF_STOLEN;
> 
>  tx_error:
> -       if (!IS_ERR(skb))
> -               kfree_skb(skb);
> -       LeaveFunction(10);
> +       kfree_skb(skb);
>         return NF_STOLEN;
>  }
>  #endif
> @@ -1437,8 +1409,6 @@ ip_vs_dr_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>  {
>         int local;
> 
> -       EnterFunction(10);
> -
>         local = __ip_vs_get_out_rt(cp->ipvs, cp->af, skb, cp->dest, cp->daddr.ip,
>                                    IP_VS_RT_MODE_LOCAL |
>                                    IP_VS_RT_MODE_NON_LOCAL |
> @@ -1455,12 +1425,10 @@ ip_vs_dr_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
> 
>         ip_vs_send_or_cont(NFPROTO_IPV4, skb, cp, 0);
> 
> -       LeaveFunction(10);
>         return NF_STOLEN;
> 
>    tx_error:
>         kfree_skb(skb);
> -       LeaveFunction(10);
>         return NF_STOLEN;
>  }
> 
> @@ -1471,8 +1439,6 @@ ip_vs_dr_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>  {
>         int local;
> 
> -       EnterFunction(10);
> -
>         local = __ip_vs_get_out_rt_v6(cp->ipvs, cp->af, skb, cp->dest,
>                                       &cp->daddr.in6,
>                                       NULL, ipvsh, 0,
> @@ -1489,12 +1455,10 @@ ip_vs_dr_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
> 
>         ip_vs_send_or_cont(NFPROTO_IPV6, skb, cp, 0);
> 
> -       LeaveFunction(10);
>         return NF_STOLEN;
> 
>  tx_error:
>         kfree_skb(skb);
> -       LeaveFunction(10);
>         return NF_STOLEN;
>  }
>  #endif
> @@ -1514,8 +1478,6 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>         int local;
>         int rt_mode, was_input;
> 
> -       EnterFunction(10);
> -
>         /* The ICMP packet for VS/TUN, VS/DR and LOCALNODE will be
>            forwarded directly here, because there is no need to
>            translate address/port back */
> @@ -1526,7 +1488,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>                         rc = NF_ACCEPT;
>                 /* do not touch skb anymore */
>                 atomic_inc(&cp->in_pkts);
> -               goto out;
> +               return rc;
>         }
> 
>         /*
> @@ -1582,14 +1544,11 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>         /* Another hack: avoid icmp_send in ip_fragment */
>         skb->ignore_df = 1;
> 
> -       rc = ip_vs_nat_send_or_cont(NFPROTO_IPV4, skb, cp, local);
> -       goto out;
> +       return ip_vs_nat_send_or_cont(NFPROTO_IPV4, skb, cp, local);
> 
>    tx_error:
>         kfree_skb(skb);
>         rc = NF_STOLEN;
> -  out:
> -       LeaveFunction(10);
>         return rc;
>  }
> 
> @@ -1604,8 +1563,6 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>         int local;
>         int rt_mode;
> 
> -       EnterFunction(10);
> -
>         /* The ICMP packet for VS/TUN, VS/DR and LOCALNODE will be
>            forwarded directly here, because there is no need to
>            translate address/port back */
> @@ -1616,7 +1573,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>                         rc = NF_ACCEPT;
>                 /* do not touch skb anymore */
>                 atomic_inc(&cp->in_pkts);
> -               goto out;
> +               return rc;
>         }
> 
>         /*
> @@ -1671,14 +1628,11 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>         /* Another hack: avoid icmp_send in ip_fragment */
>         skb->ignore_df = 1;
> 
> -       rc = ip_vs_nat_send_or_cont(NFPROTO_IPV6, skb, cp, local);
> -       goto out;
> +       return ip_vs_nat_send_or_cont(NFPROTO_IPV6, skb, cp, local);
> 
>  tx_error:
>         kfree_skb(skb);
>         rc = NF_STOLEN;
> -out:
> -       LeaveFunction(10);
>         return rc;
>  }
>  #endif
> 
> --
> 2.30.2
> 

-- 
/Horatiu
