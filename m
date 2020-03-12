Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D3C183CD2
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgCLWwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:52:11 -0400
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:57298 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726513AbgCLWwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:52:10 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id D9A5118013516;
        Thu, 12 Mar 2020 22:52:08 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:4:41:355:379:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2194:2198:2199:2200:2393:2525:2560:2563:2682:2685:2828:2859:2898:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:6117:6119:7809:7903:9025:9592:10004:10848:11026:11473:11658:11914:12043:12048:12294:12296:12297:12438:12555:12679:12760:12986:13439:13972:14096:14097:14394:14659:14877:14915:21080:21433:21451:21483:21620:21809:21811:21939:21990:30003:30012:30045:30051:30054:30070:30075:30083,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: frame63_4c90d23140237
X-Filterd-Recvd-Size: 18330
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Thu, 12 Mar 2020 22:52:06 +0000 (UTC)
Message-ID: <68a79203af60110b3412155621cfc00381867c94.camel@perches.com>
Subject: [PATCH 2/3 V2] inet: Use fallthrough;
From:   Joe Perches <joe@perches.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Date:   Thu, 12 Mar 2020 15:50:22 -0700
In-Reply-To: <cover.1584040050.git.joe@perches.com>
References: <cover.1584040050.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the various uses of fallthrough comments to fallthrough;

Done via script
Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe@perches.com/

And by hand:

net/ipv6/ip6_fib.c has a fallthrough comment outside of an #ifdef block
that causes gcc to emit a warning if converted in-place.

So move the new fallthrough; inside the containing #ifdef/#endif too.

Signed-off-by: Joe Perches <joe@perches.com>
---

v2: Subject change

 net/ipv4/af_inet.c               | 4 ++--
 net/ipv4/ah4.c                   | 2 +-
 net/ipv4/arp.c                   | 2 +-
 net/ipv4/devinet.c               | 6 +++---
 net/ipv4/fib_semantics.c         | 4 ++--
 net/ipv4/icmp.c                  | 2 +-
 net/ipv4/ip_output.c             | 2 +-
 net/ipv4/ipmr.c                  | 2 +-
 net/ipv4/netfilter/nf_log_ipv4.c | 2 +-
 net/ipv4/netfilter/nf_nat_pptp.c | 4 ++--
 net/ipv4/nexthop.c               | 2 +-
 net/ipv4/tcp.c                   | 2 +-
 net/ipv4/tcp_input.c             | 6 +++---
 net/ipv4/tcp_ipv4.c              | 4 ++--
 net/ipv4/udp.c                   | 2 +-
 net/ipv6/addrconf.c              | 6 ++----
 net/ipv6/ah6.c                   | 2 +-
 net/ipv6/exthdrs.c               | 2 +-
 net/ipv6/icmp.c                  | 2 +-
 net/ipv6/ip6_fib.c               | 8 ++++----
 net/ipv6/ip6mr.c                 | 2 +-
 net/ipv6/ndisc.c                 | 2 +-
 net/ipv6/netfilter/nf_log_ipv6.c | 2 +-
 net/ipv6/raw.c                   | 8 ++++----
 net/ipv6/route.c                 | 2 +-
 net/ipv6/tcp_ipv6.c              | 2 +-
 26 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 2fe2954..bd7b4e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -872,7 +872,7 @@ int inet_shutdown(struct socket *sock, int how)
 		err = -ENOTCONN;
 		/* Hack to wake up other listeners, who can poll for
 		   EPOLLHUP, even on eg. unconnected UDP sockets -- RR */
-		/* fall through */
+		fallthrough;
 	default:
 		sk->sk_shutdown |= how;
 		if (sk->sk_prot->shutdown)
@@ -886,7 +886,7 @@ int inet_shutdown(struct socket *sock, int how)
 	case TCP_LISTEN:
 		if (!(how & RCV_SHUTDOWN))
 			break;
-		/* fall through */
+		fallthrough;
 	case TCP_SYN_SENT:
 		err = sk->sk_prot->disconnect(sk, O_NONBLOCK);
 		sock->state = err ? SS_DISCONNECTING : SS_UNCONNECTED;
diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 974179b..d99e1be 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -107,7 +107,7 @@ static int ip_clear_mutable_options(const struct iphdr *iph, __be32 *daddr)
 			if (optlen < 6)
 				return -EINVAL;
 			memcpy(daddr, optptr+optlen-4, 4);
-			/* Fall through */
+			fallthrough;
 		default:
 			memset(optptr, 0, optlen);
 		}
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 05eb42f..687971d 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1181,7 +1181,7 @@ int arp_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	case SIOCSARP:
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
-		/* fall through */
+		fallthrough;
 	case SIOCGARP:
 		err = copy_from_user(&r, arg, sizeof(struct arpreq));
 		if (err)
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index e4632b..30fa42 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1566,11 +1566,11 @@ static int inetdev_event(struct notifier_block *this, unsigned long event,
 			}
 		}
 		ip_mc_up(in_dev);
-		/* fall through */
+		fallthrough;
 	case NETDEV_CHANGEADDR:
 		if (!IN_DEV_ARP_NOTIFY(in_dev))
 			break;
-		/* fall through */
+		fallthrough;
 	case NETDEV_NOTIFY_PEERS:
 		/* Send gratuitous ARP to notify of link change */
 		inetdev_send_gratuitous_arp(dev, in_dev);
@@ -1588,7 +1588,7 @@ static int inetdev_event(struct notifier_block *this, unsigned long event,
 		if (inetdev_valid_mtu(dev->mtu))
 			break;
 		/* disable IP when MTU is not enough */
-		/* fall through */
+		fallthrough;
 	case NETDEV_UNREGISTER:
 		inetdev_destroy(in_dev);
 		break;
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index a803cd..e4c62b 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1962,7 +1962,7 @@ int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force)
 				case NETDEV_DOWN:
 				case NETDEV_UNREGISTER:
 					nexthop_nh->fib_nh_flags |= RTNH_F_DEAD;
-					/* fall through */
+					fallthrough;
 				case NETDEV_CHANGE:
 					nexthop_nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 					break;
@@ -1984,7 +1984,7 @@ int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force)
 			case NETDEV_DOWN:
 			case NETDEV_UNREGISTER:
 				fi->fib_flags |= RTNH_F_DEAD;
-				/* fall through */
+				fallthrough;
 			case NETDEV_CHANGE:
 				fi->fib_flags |= RTNH_F_LINKDOWN;
 				break;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index f369e7c..fc61f5 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -865,7 +865,7 @@ static bool icmp_unreach(struct sk_buff *skb)
 			case 3:
 				if (!icmp_tag_validation(iph->protocol))
 					goto out;
-				/* fall through */
+				fallthrough;
 			case 0:
 				info = ntohs(icmph->un.frag.mtu);
 			}
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d848198..aaaaf90 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -333,7 +333,7 @@ static int ip_mc_finish_output(struct net *net, struct sock *sk,
 	switch (ret) {
 	case NET_XMIT_CN:
 		do_cn = true;
-		/* fall through */
+		fallthrough;
 	case NET_XMIT_SUCCESS:
 		break;
 	default:
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6e68def..9cf83cc 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1465,7 +1465,7 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, char __user *optval,
 	case MRT_ADD_MFC:
 	case MRT_DEL_MFC:
 		parent = -1;
-		/* fall through */
+		fallthrough;
 	case MRT_ADD_MFC_PROXY:
 	case MRT_DEL_MFC_PROXY:
 		if (optlen != sizeof(mfc)) {
diff --git a/net/ipv4/netfilter/nf_log_ipv4.c b/net/ipv4/netfilter/nf_log_ipv4.c
index 4b2d49..0c7215 100644
--- a/net/ipv4/netfilter/nf_log_ipv4.c
+++ b/net/ipv4/netfilter/nf_log_ipv4.c
@@ -173,7 +173,7 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 		case ICMP_REDIRECT:
 			/* Max length: 24 "GATEWAY=255.255.255.255 " */
 			nf_log_buf_add(m, "GATEWAY=%pI4 ", &ich->un.gateway);
-			/* Fall through */
+			fallthrough;
 		case ICMP_DEST_UNREACH:
 		case ICMP_SOURCE_QUENCH:
 		case ICMP_TIME_EXCEEDED:
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index b2aeb7b..3c25a4 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -168,7 +168,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
 		pr_debug("unknown outbound packet 0x%04x:%s\n", msg,
 			 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] :
 					       pptp_msg_name[0]);
-		/* fall through */
+		fallthrough;
 	case PPTP_SET_LINK_INFO:
 		/* only need to NAT in case PAC is behind NAT box */
 	case PPTP_START_SESSION_REQUEST:
@@ -271,7 +271,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 		pr_debug("unknown inbound packet %s\n",
 			 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] :
 					       pptp_msg_name[0]);
-		/* fall through */
+		fallthrough;
 	case PPTP_START_SESSION_REQUEST:
 	case PPTP_START_SESSION_REPLY:
 	case PPTP_STOP_SESSION_REQUEST:
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index d072c32..fdfca5 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1327,7 +1327,7 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 	case AF_UNSPEC:
 		if (tb[NHA_GROUP])
 			break;
-		/* fallthrough */
+		fallthrough;
 	default:
 		NL_SET_ERR_MSG(extack, "Invalid address family");
 		goto out;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f62be8..e086e2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2307,7 +2307,7 @@ void tcp_set_state(struct sock *sk, int state)
 		if (inet_csk(sk)->icsk_bind_hash &&
 		    !(sk->sk_userlocks & SOCK_BINDPORT_LOCK))
 			inet_put_port(sk);
-		/* fall through */
+		fallthrough;
 	default:
 		if (oldstate == TCP_ESTABLISHED)
 			TCP_DEC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6b6b57..bf4ced9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2865,7 +2865,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		      (*ack_flag & FLAG_LOST_RETRANS)))
 			return;
 		/* Change state if cwnd is undone or retransmits are lost */
-		/* fall through */
+		fallthrough;
 	default:
 		if (tcp_is_reno(tp)) {
 			if (flag & FLAG_SND_UNA_ADVANCED)
@@ -6367,7 +6367,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 				mptcp_incoming_options(sk, skb, &tp->rx_opt);
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case TCP_FIN_WAIT1:
 	case TCP_FIN_WAIT2:
 		/* RFC 793 says to queue data in these states,
@@ -6382,7 +6382,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 				return 1;
 			}
 		}
-		/* Fall through */
+		fallthrough;
 	case TCP_ESTABLISHED:
 		tcp_data_queue(sk, skb);
 		queued = 1;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 52acf0b..83a5d24 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2072,7 +2072,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		}
 	}
 		/* to ACK */
-		/* fall through */
+		fallthrough;
 	case TCP_TW_ACK:
 		tcp_v4_timewait_ack(sk, skb);
 		break;
@@ -2368,7 +2368,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 			break;
 		st->bucket = 0;
 		st->state = TCP_SEQ_STATE_ESTABLISHED;
-		/* Fallthrough */
+		fallthrough;
 	case TCP_SEQ_STATE_ESTABLISHED:
 		if (st->bucket > tcp_hashinfo.ehash_mask)
 			break;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index a68e2a..2633fc2 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2563,7 +2563,7 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		case UDP_ENCAP_ESPINUDP_NON_IKE:
 			up->encap_rcv = xfrm4_udp_encap_rcv;
 #endif
-			/* FALLTHROUGH */
+			fallthrough;
 		case UDP_ENCAP_L2TPINUDP:
 			up->encap_type = val;
 			lock_sock(sk);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 46d614..5b9de7 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3301,7 +3301,7 @@ static void addrconf_addr_gen(struct inet6_dev *idev, bool prefix_route)
 	switch (idev->cnf.addr_gen_mode) {
 	case IN6_ADDR_GEN_MODE_RANDOM:
 		ipv6_gen_mode_random_init(idev);
-		/* fallthrough */
+		fallthrough;
 	case IN6_ADDR_GEN_MODE_STABLE_PRIVACY:
 		if (!ipv6_generate_stable_address(&addr, 0, idev))
 			addrconf_add_linklocal(idev, &addr,
@@ -3523,9 +3523,7 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 			break;
 
 		run_pending = 1;
-
-		/* fall through */
-
+		fallthrough;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
 		if (dev->flags & IFF_SLAVE)
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 871d6e5..45e2adc 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -259,7 +259,7 @@ static int ipv6_clear_mutable_options(struct ipv6hdr *iph, int len, int dir)
 		case NEXTHDR_DEST:
 			if (dir == XFRM_POLICY_OUT)
 				ipv6_rearrange_destopt(iph, exthdr.opth);
-			/* fall through */
+			fallthrough;
 		case NEXTHDR_HOP:
 			if (!zero_out_mutable_opts(exthdr.opth)) {
 				net_dbg_ratelimited("overrun %sopts\n",
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index ab5add..bcb9f5 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -97,7 +97,7 @@ static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
 		 */
 		if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr))
 			break;
-		/* fall through */
+		fallthrough;
 	case 2: /* send ICMP PARM PROB regardless and drop packet */
 		icmpv6_param_prob(skb, ICMPV6_UNK_OPTION, optoff);
 		return false;
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index ef408a5..2688f3 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -898,7 +898,7 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		hdr = icmp6_hdr(skb);
 
 		/* to notify */
-		/* fall through */
+		fallthrough;
 	case ICMPV6_DEST_UNREACH:
 	case ICMPV6_TIME_EXCEED:
 	case ICMPV6_PARAMPROB:
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 72abf8..46ed567 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2068,8 +2068,8 @@ static int fib6_walk_continue(struct fib6_walker *w)
 				continue;
 			}
 			w->state = FWS_L;
+			fallthrough;
 #endif
-			/* fall through */
 		case FWS_L:
 			left = rcu_dereference_protected(fn->left, 1);
 			if (left) {
@@ -2078,7 +2078,7 @@ static int fib6_walk_continue(struct fib6_walker *w)
 				continue;
 			}
 			w->state = FWS_R;
-			/* fall through */
+			fallthrough;
 		case FWS_R:
 			right = rcu_dereference_protected(fn->right, 1);
 			if (right) {
@@ -2088,7 +2088,7 @@ static int fib6_walk_continue(struct fib6_walker *w)
 			}
 			w->state = FWS_C;
 			w->leaf = rcu_dereference_protected(fn->leaf, 1);
-			/* fall through */
+			fallthrough;
 		case FWS_C:
 			if (w->leaf && fn->fn_flags & RTN_RTINFO) {
 				int err;
@@ -2107,7 +2107,7 @@ static int fib6_walk_continue(struct fib6_walker *w)
 			}
 skip:
 			w->state = FWS_U;
-			/* fall through */
+			fallthrough;
 		case FWS_U:
 			if (fn == w->root)
 				return 0;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index d64839..65a54d7 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1691,7 +1691,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, char __user *optval, uns
 	case MRT6_ADD_MFC:
 	case MRT6_DEL_MFC:
 		parent = -1;
-		/* fall through */
+		fallthrough;
 	case MRT6_ADD_MFC_PROXY:
 	case MRT6_DEL_MFC_PROXY:
 		if (optlen < sizeof(mfc))
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 53caf59..4a3fecc 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1782,7 +1782,7 @@ static int ndisc_netdev_event(struct notifier_block *this, unsigned long event,
 	case NETDEV_CHANGEADDR:
 		neigh_changeaddr(&nd_tbl, dev);
 		fib6_run_gc(0, net, false);
-		/* fallthrough */
+		fallthrough;
 	case NETDEV_UP:
 		idev = in6_dev_get(dev);
 		if (!idev)
diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
index 22b80db..da6455 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -248,7 +248,7 @@ static void dump_ipv6_packet(struct net *net, struct nf_log_buf *m,
 			/* Max length: 17 "POINTER=ffffffff " */
 			nf_log_buf_add(m, "POINTER=%08x ",
 				       ntohl(ic->icmp6_pointer));
-			/* Fall through */
+			fallthrough;
 		case ICMPV6_DEST_UNREACH:
 		case ICMPV6_PKT_TOOBIG:
 		case ICMPV6_TIME_EXCEED:
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index dfe5e6..0028aa 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1076,7 +1076,7 @@ static int rawv6_setsockopt(struct sock *sk, int level, int optname,
 		if (optname == IPV6_CHECKSUM ||
 		    optname == IPV6_HDRINCL)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		return ipv6_setsockopt(sk, level, optname, optval, optlen);
 	}
@@ -1099,7 +1099,7 @@ static int compat_rawv6_setsockopt(struct sock *sk, int level, int optname,
 		if (optname == IPV6_CHECKSUM ||
 		    optname == IPV6_HDRINCL)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		return compat_ipv6_setsockopt(sk, level, optname,
 					      optval, optlen);
@@ -1161,7 +1161,7 @@ static int rawv6_getsockopt(struct sock *sk, int level, int optname,
 		if (optname == IPV6_CHECKSUM ||
 		    optname == IPV6_HDRINCL)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		return ipv6_getsockopt(sk, level, optname, optval, optlen);
 	}
@@ -1184,7 +1184,7 @@ static int compat_rawv6_getsockopt(struct sock *sk, int level, int optname,
 		if (optname == IPV6_CHECKSUM ||
 		    optname == IPV6_HDRINCL)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		return compat_ipv6_getsockopt(sk, level, optname,
 					      optval, optlen);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 293122..2430c2 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4370,7 +4370,7 @@ static int ip6_pkt_drop(struct sk_buff *skb, u8 code, int ipstats_mib_noroutes)
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_INADDRERRORS);
 			break;
 		}
-		/* FALLTHROUGH */
+		fallthrough;
 	case IPSTATS_MIB_OUTNOROUTES:
 		IP6_INC_STATS(net, idev, ipstats_mib_noroutes);
 		break;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index eaf09e6..413b34 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1742,7 +1742,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		}
 	}
 		/* to ACK */
-		/* fall through */
+		fallthrough;
 	case TCP_TW_ACK:
 		tcp_v6_timewait_ack(sk, skb);
 		break;

