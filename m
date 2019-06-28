Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B0159BC3
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfF1Mka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:40:30 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:39671 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfF1Mk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:40:29 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MV6G0-1i5h3x3iFi-00SAKd; Fri, 28 Jun 2019 14:39:28 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kees Cook <keescook@chromium.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jmorris@namei.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/4] ipvs: reduce kernel stack usage
Date:   Fri, 28 Jun 2019 14:37:49 +0200
Message-Id: <20190628123819.2785504-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190628123819.2785504-1-arnd@arndb.de>
References: <20190628123819.2785504-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:HCGQWJM/jgYLfWjkaZqUrv2qOxBWq7KQGIVbLhAN9vz4+rQGEsU
 1e0OEfxV5X+IxxkESa/8ED8gQbJJZo1mFkHnxx4cuEdIFDG2E6kEU56AXXqllNDwrTx7Yqi
 rPQt0sWJJxsy/lqIVMY+IjOW7kDLES10VVBg99qKA3iWFFY1Bk9L4yVzcmIqkKZI6W1ghPE
 yyqN2UtepcKHX4ktJndTA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UFQTEIQsdI8=:4JSGSxh9Lq4IgSj6RbZGvw
 dFcGEbvKr9mbkRrkz56cKH8qN/i/cn7SspmrlOXlaHRNqZ/Ds/WiCiUXhgJGt/cK9A5c3YD7i
 oHjmFLpmqBSbCmuAWd5nndcufQKSo/Z+8KGa+YIFeZG4I2s6D3cfpNQR3Cov1U9Ni3aUm0uZb
 JIg0Zlz3z1X098a1zAm3KZ0Ko71tKEkNAbZamovoh/jLWPcD994C83G8iDf+Dta1wHAyRN3qw
 rSxWNTEYAsrlsmL9oeVbhZvD1Qer3DMh0/GMHwPCPeFhTcxCRLFjNZN1IeupJ/dsRsUHmyjIq
 GX8kB9g68EykZBIf2YkVRP+gKEYjVyI60WMudiPqV3hHsFiaY23lYQojGI6Uk34cKqjmgZfIg
 ncK2yWIFM5jeqQ05m7KNm2gaeAtwyqnlSX9Qr6/tqGnyQzdn2vDx+MeQJEwTnvZ8XDKwsNSve
 ndhLiulAGkKmSxi01Ff4tbjxThCRZdsaYr93bZ2ajCxZDXGE48o4tfsRK3or067qr5RyhYCeM
 BGTW+9FvvP1oeNNjuLeaUBmSIfrltlp5zBP4CBkvVv/VeqY7R68gaA0eAB5DI8PWCa89CplBL
 OW53sIBE0YKUXFN1QsL+o5iXlGUBo80cTSZNF4+YjcDlGLajgqLn3ll+Xj6kmI+HhkbrdAc0a
 FdIOGG520qWOR2RY+0oxwPZ3lgPR/iDfEqCg1g4gICWNnHpAorIYwzv7nNigCNMWnwr8DMdSw
 QyZdHAipo9ZCGX3CyMxOhlXbJ86PESqFHUSsHQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the new CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL option, the stack
usage in the ipvs debug output grows because each instance of
IP_VS_DBG_BUF() now has its own buffer of 160 bytes that add up
rather than reusing the stack slots:

net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_sched_persist':
net/netfilter/ipvs/ip_vs_core.c:427:1: error: the frame size of 1052 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_new_conn_out':
net/netfilter/ipvs/ip_vs_core.c:1231:1: error: the frame size of 1048 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_out':
net/netfilter/ipvs/ip_vs_ftp.c:397:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_in':
net/netfilter/ipvs/ip_vs_ftp.c:555:1: error: the frame size of 1200 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Since printk() already has a way to print IPv4/IPv6 addresses using
the %pIS format string, use that instead, combined with a macro that
creates a local sockaddr structure on the stack. These will still
add up, but the stack frames are now under 200 bytes.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I'm not sure this actually does what I think it does. Someone
needs to verify that we correctly print the addresses here.
I've also only added three files that caused the warning messages
to be reported. There are still a lot of other instances of
IP_VS_DBG_BUF() that could be converted the same way after the
basic idea is confirmed.
---
 include/net/ip_vs.h             | 71 +++++++++++++++++++--------------
 net/netfilter/ipvs/ip_vs_core.c | 44 ++++++++++----------
 net/netfilter/ipvs/ip_vs_ftp.c  | 20 +++++-----
 3 files changed, 72 insertions(+), 63 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 3759167f91f5..3dfbeef67be6 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -227,6 +227,16 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
 		       sizeof(ip_vs_dbg_buf), addr,			\
 		       &ip_vs_dbg_idx)
 
+#define IP_VS_DBG_SOCKADDR4(fam, addr, port)				\
+	(struct sockaddr*)&(struct sockaddr_in)				\
+	{ .sin_family = (fam), .sin_addr = (addr)->in, .sin_port = (port) }
+#define IP_VS_DBG_SOCKADDR6(fam, addr, port)				\
+	(struct sockaddr*)&(struct sockaddr_in6) \
+	{ .sin6_family = (fam), .sin6_addr = (addr)->in6, .sin6_port = (port) }
+#define IP_VS_DBG_SOCKADDR(fam, addr, port) (fam == AF_INET ?		\
+			IP_VS_DBG_SOCKADDR4(fam, addr, port) :		\
+			IP_VS_DBG_SOCKADDR6(fam, addr, port))
+
 #define IP_VS_DBG(level, msg, ...)					\
 	do {								\
 		if (level <= ip_vs_get_debug_level())			\
@@ -251,6 +261,7 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
 #else	/* NO DEBUGGING at ALL */
 #define IP_VS_DBG_BUF(level, msg...)  do {} while (0)
 #define IP_VS_ERR_BUF(msg...)  do {} while (0)
+#define IP_VS_DBG_SOCKADDR(fam, addr, port) NULL
 #define IP_VS_DBG(level, msg...)  do {} while (0)
 #define IP_VS_DBG_RL(msg...)  do {} while (0)
 #define IP_VS_DBG_PKT(level, af, pp, skb, ofs, msg)	do {} while (0)
@@ -1244,31 +1255,31 @@ static inline void ip_vs_control_del(struct ip_vs_conn *cp)
 {
 	struct ip_vs_conn *ctl_cp = cp->control;
 	if (!ctl_cp) {
-		IP_VS_ERR_BUF("request control DEL for uncontrolled: "
-			      "%s:%d to %s:%d\n",
-			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
-			      ntohs(cp->cport),
-			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
-			      ntohs(cp->vport));
+		pr_err("request control DEL for uncontrolled: "
+		       "%pISp to %pISp\n",
+		       IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr,
+		       ntohs(cp->cport)),
+		       IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr,
+		       ntohs(cp->vport)));
 
 		return;
 	}
 
-	IP_VS_DBG_BUF(7, "DELeting control for: "
-		      "cp.dst=%s:%d ctl_cp.dst=%s:%d\n",
-		      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
-		      ntohs(cp->cport),
-		      IP_VS_DBG_ADDR(cp->af, &ctl_cp->caddr),
-		      ntohs(ctl_cp->cport));
+	IP_VS_DBG(7, "DELeting control for: "
+		  "cp.dst=%pISp ctl_cp.dst=%pISp\n",
+		  IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr,
+		  ntohs(cp->cport)),
+		  IP_VS_DBG_SOCKADDR(cp->af, &ctl_cp->caddr,
+		  ntohs(ctl_cp->cport)));
 
 	cp->control = NULL;
 	if (atomic_read(&ctl_cp->n_control) == 0) {
-		IP_VS_ERR_BUF("BUG control DEL with n=0 : "
-			      "%s:%d to %s:%d\n",
-			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
-			      ntohs(cp->cport),
-			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
-			      ntohs(cp->vport));
+		pr_err("BUG control DEL with n=0 : "
+		       "%pISp to %pISp\n",
+		       IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr,
+		       ntohs(cp->cport)),
+		       IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr,
+		       ntohs(cp->vport)));
 
 		return;
 	}
@@ -1279,22 +1290,22 @@ static inline void
 ip_vs_control_add(struct ip_vs_conn *cp, struct ip_vs_conn *ctl_cp)
 {
 	if (cp->control) {
-		IP_VS_ERR_BUF("request control ADD for already controlled: "
-			      "%s:%d to %s:%d\n",
-			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
-			      ntohs(cp->cport),
-			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
-			      ntohs(cp->vport));
+		pr_err("request control ADD for already controlled: "
+		       "%pISp to %pISp\n",
+		       IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr,
+		     		     ntohs(cp->cport)),
+		       IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr,
+		     		     ntohs(cp->vport)));
 
 		ip_vs_control_del(cp);
 	}
 
-	IP_VS_DBG_BUF(7, "ADDing control for: "
-		      "cp.dst=%s:%d ctl_cp.dst=%s:%d\n",
-		      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
-		      ntohs(cp->cport),
-		      IP_VS_DBG_ADDR(cp->af, &ctl_cp->caddr),
-		      ntohs(ctl_cp->cport));
+	IP_VS_DBG(7, "ADDing control for: "
+		  "cp.dst=%pISp ctl_cp.dst=%pISp\n",
+		  IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr,
+				     ntohs(cp->cport)),
+		  IP_VS_DBG_SOCKADDR(cp->af, &ctl_cp->caddr,
+				     ntohs(ctl_cp->cport)));
 
 	cp->control = ctl_cp;
 	atomic_inc(&ctl_cp->n_control);
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index f662f198b458..0277cd3c5446 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -51,7 +51,6 @@
 #include <net/ip_vs.h>
 #include <linux/indirect_call_wrapper.h>
 
-
 EXPORT_SYMBOL(register_ip_vs_scheduler);
 EXPORT_SYMBOL(unregister_ip_vs_scheduler);
 EXPORT_SYMBOL(ip_vs_proto_name);
@@ -294,11 +293,11 @@ ip_vs_sched_persist(struct ip_vs_service *svc,
 #endif
 		snet.ip = src_addr->ip & svc->netmask;
 
-	IP_VS_DBG_BUF(6, "p-schedule: src %s:%u dest %s:%u "
-		      "mnet %s\n",
-		      IP_VS_DBG_ADDR(svc->af, src_addr), ntohs(src_port),
-		      IP_VS_DBG_ADDR(svc->af, dst_addr), ntohs(dst_port),
-		      IP_VS_DBG_ADDR(svc->af, &snet));
+	IP_VS_DBG(6, "p-schedule: src %pISp dest %pISp "
+		      "mnet %pIS\n",
+		      IP_VS_DBG_SOCKADDR(svc->af, src_addr, ntohs(src_port)),
+		      IP_VS_DBG_SOCKADDR(svc->af, dst_addr, ntohs(dst_port)),
+		      IP_VS_DBG_SOCKADDR(svc->af, &snet, 0));
 
 	/*
 	 * As far as we know, FTP is a very complicated network protocol, and
@@ -566,12 +565,12 @@ ip_vs_schedule(struct ip_vs_service *svc, struct sk_buff *skb,
 		}
 	}
 
-	IP_VS_DBG_BUF(6, "Schedule fwd:%c c:%s:%u v:%s:%u "
-		      "d:%s:%u conn->flags:%X conn->refcnt:%d\n",
+	IP_VS_DBG(6, "Schedule fwd:%c c:%pISp v:%pISp "
+		      "d:%pISp conn->flags:%X conn->refcnt:%d\n",
 		      ip_vs_fwd_tag(cp),
-		      IP_VS_DBG_ADDR(cp->af, &cp->caddr), ntohs(cp->cport),
-		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
-		      IP_VS_DBG_ADDR(cp->daf, &cp->daddr), ntohs(cp->dport),
+		      IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, ntohs(cp->cport)),
+		      IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr, ntohs(cp->vport)),
+		      IP_VS_DBG_SOCKADDR(cp->daf, &cp->daddr, ntohs(cp->dport)),
 		      cp->flags, refcount_read(&cp->refcnt));
 
 	ip_vs_conn_stats(cp, svc);
@@ -885,8 +884,8 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 	/* Ensure the checksum is correct */
 	if (!skb_csum_unnecessary(skb) && ip_vs_checksum_complete(skb, ihl)) {
 		/* Failed checksum! */
-		IP_VS_DBG_BUF(1, "Forward ICMP: failed checksum from %s!\n",
-			      IP_VS_DBG_ADDR(af, snet));
+		IP_VS_DBG(1, "Forward ICMP: failed checksum from %pISp!\n",
+			      IP_VS_DBG_SOCKADDR(af, snet, 0));
 		goto out;
 	}
 
@@ -1219,13 +1218,13 @@ struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
 	ip_vs_conn_stats(cp, svc);
 
 	/* return connection (will be used to handle outgoing packet) */
-	IP_VS_DBG_BUF(6, "New connection RS-initiated:%c c:%s:%u v:%s:%u "
-		      "d:%s:%u conn->flags:%X conn->refcnt:%d\n",
-		      ip_vs_fwd_tag(cp),
-		      IP_VS_DBG_ADDR(cp->af, &cp->caddr), ntohs(cp->cport),
-		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
-		      IP_VS_DBG_ADDR(cp->af, &cp->daddr), ntohs(cp->dport),
-		      cp->flags, refcount_read(&cp->refcnt));
+	IP_VS_DBG(6, "New connection RS-initiated:%c c:%pISp v:%pISp "
+		  "d:%pISp conn->flags:%X conn->refcnt:%d\n",
+		  ip_vs_fwd_tag(cp),
+		  IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, ntohs(cp->cport)),
+		  IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr, ntohs(cp->vport)),
+		  IP_VS_DBG_SOCKADDR(cp->af, &cp->daddr, ntohs(cp->dport)),
+		  cp->flags, refcount_read(&cp->refcnt));
 	LeaveFunction(12);
 	return cp;
 }
@@ -1931,7 +1930,6 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 }
 #endif
 
-
 /*
  *	Check if it's for virtual services, look it up,
  *	and send it on its way...
@@ -1960,10 +1958,10 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 		      hooknum != NF_INET_LOCAL_OUT) ||
 		     !skb_dst(skb))) {
 		ip_vs_fill_iph_skb(af, skb, false, &iph);
-		IP_VS_DBG_BUF(12, "packet type=%d proto=%d daddr=%s"
+		IP_VS_DBG(12, "packet type=%d proto=%d daddr=%pIS"
 			      " ignored in hook %u\n",
 			      skb->pkt_type, iph.protocol,
-			      IP_VS_DBG_ADDR(af, &iph.daddr), hooknum);
+			      IP_VS_DBG_SOCKADDR(af, &iph.daddr, 0), hooknum);
 		return NF_ACCEPT;
 	}
 	/* ipvs enabled in this netns ? */
diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index cf925906f59b..d57dcc2b4396 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -306,9 +306,9 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 					   &start, &end) != 1)
 			return 1;
 
-		IP_VS_DBG_BUF(7, "EPSV response (%s:%u) -> %s:%u detected\n",
-			      IP_VS_DBG_ADDR(cp->af, &from), ntohs(port),
-			      IP_VS_DBG_ADDR(cp->af, &cp->caddr), 0);
+		IP_VS_DBG(7, "EPSV response (%pISp) -> %pISp detected\n",
+			  IP_VS_DBG_SOCKADDR(cp->af, &from, ntohs(port)),
+			  IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, 0));
 	} else {
 		return 1;
 	}
@@ -510,15 +510,15 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
 					  &to, &port, cp->af,
 					  &start, &end) == 1) {
 
-		IP_VS_DBG_BUF(7, "EPRT %s:%u detected\n",
-			      IP_VS_DBG_ADDR(cp->af, &to), ntohs(port));
+		IP_VS_DBG(7, "EPRT %pISp detected\n",
+			  IP_VS_DBG_SOCKADDR(cp->af, &to, ntohs(port)));
 
 		/* Now update or create a connection entry for it */
-		IP_VS_DBG_BUF(7, "protocol %s %s:%u %s:%u\n",
-			      ip_vs_proto_name(ipvsh->protocol),
-			      IP_VS_DBG_ADDR(cp->af, &to), ntohs(port),
-			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
-			      ntohs(cp->vport)-1);
+		IP_VS_DBG(7, "protocol %s %pISp %pISp\n",
+			  ip_vs_proto_name(ipvsh->protocol),
+			  IP_VS_DBG_SOCKADDR(cp->af, &to, ntohs(port)),
+			  IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr,
+			  ntohs(cp->vport)-1));
 	} else {
 		return 1;
 	}
-- 
2.20.0

