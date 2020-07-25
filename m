Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6719022D91D
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 19:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgGYR5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 13:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgGYR5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 13:57:44 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC41C08C5C0;
        Sat, 25 Jul 2020 10:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:Subject:From:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=h53znqo50BBI6k34gkssxkyY0bumRYb9LTxmBY8PPFg=; b=QxGWSBKJ0ZvJZHoDS/TK06bNS5
        3ampj5St5kQrPmkrfrd6zY0St+lf+15e07v5guHAyDAEXB5Nr593OV5jjNke6NU8uDB78SeUCURya
        6H6PMvp/LsuxxQdw9aY/11U2XPEjS8qHx8u9vi/4Qj0ympMe/QGXpeHX+6yTma1EZNo0=;
Received: from p5b206d80.dip0.t-ipconnect.de ([91.32.109.128] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1jzOQG-00030H-1y; Sat, 25 Jul 2020 19:57:24 +0200
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 0/7] Add support to process rx packets in thread
To:     Hillf Danton <hdanton@sina.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Lunn <andrew@lunn.ch>,
        Rakesh Pillai <pillair@codeaurora.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        Markus Elfring <Markus.Elfring@web.de>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <20200721172514.GT1339445@lunn.ch> <20200725081633.7432-1-hdanton@sina.com>
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <a50ebfba-9733-48db-c90b-5fc106e67f29@nbd.name>
Date:   Sat, 25 Jul 2020 19:57:23 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200725081633.7432-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-25 10:16, Hillf Danton wrote:
> Hi folks
> 
> Below is a minimunm poc implementation I can imagine on top of workqueue
> to make napi threaded. Thoughts are appreciated.
Hi Hillf,

For some reason I don't see your mails on linux-wireless/netdev.
I've cleaned up your implementation a bit and I ran some tests with mt76
on an mt7621 embedded board. The results look pretty nice, performance
is a lot more consistent in my tests now.

Here are the changes that I've made compared to your version:

- remove the #ifdef, I think it's unnecessary
- add a state bit for threaded NAPI
- make netif_threaded_napi_add inline
- run queue_work outside of local_irq_save/restore (it does that
internally already)

If you don't mind, I'd like to propose this to netdev soon. Can I have
your Signed-off-by for that?

Thanks,

- Felix

---
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -347,6 +347,7 @@ struct napi_struct {
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
 	unsigned int		napi_id;
+	struct work_struct	work;
 };
 
 enum {
@@ -357,6 +358,7 @@ enum {
 	NAPI_STATE_HASHED,	/* In NAPI hash (busy polling possible) */
 	NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
 	NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
+	NAPI_STATE_THREADED,	/* Use threaded NAPI */
 };
 
 enum {
@@ -367,6 +369,7 @@ enum {
 	NAPIF_STATE_HASHED	 = BIT(NAPI_STATE_HASHED),
 	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
 	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
+	NAPIF_STATE_THREADED	 = BIT(NAPI_STATE_THREADED),
 };
 
 enum gro_result {
@@ -2315,6 +2318,26 @@ static inline void *netdev_priv(const struct net_device *dev)
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight);
 
+/**
+ *	netif_threaded_napi_add - initialize a NAPI context
+ *	@dev:  network device
+ *	@napi: NAPI context
+ *	@poll: polling function
+ *	@weight: default weight
+ *
+ * This variant of netif_napi_add() should be used from drivers using NAPI
+ * with CPU intensive poll functions.
+ * This will schedule polling from a high priority workqueue that
+ */
+static inline void netif_threaded_napi_add(struct net_device *dev,
+					   struct napi_struct *napi,
+					   int (*poll)(struct napi_struct *, int),
+					   int weight)
+{
+	set_bit(NAPI_STATE_THREADED, &napi->state);
+	netif_napi_add(dev, napi, poll, weight);
+}
+
 /**
  *	netif_tx_napi_add - initialize a NAPI context
  *	@dev:  network device
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -158,6 +158,7 @@ static DEFINE_SPINLOCK(offload_lock);
 struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 struct list_head ptype_all __read_mostly;	/* Taps */
 static struct list_head offload_base __read_mostly;
+static struct workqueue_struct *napi_workq;
 
 static int netif_rx_internal(struct sk_buff *skb);
 static int call_netdevice_notifiers_info(unsigned long val,
@@ -6286,6 +6287,11 @@ void __napi_schedule(struct napi_struct *n)
 {
 	unsigned long flags;
 
+	if (test_bit(NAPI_STATE_THREADED, &n->state)) {
+		queue_work(napi_workq, &n->work);
+		return;
+	}
+
 	local_irq_save(flags);
 	____napi_schedule(this_cpu_ptr(&softnet_data), n);
 	local_irq_restore(flags);
@@ -6333,6 +6339,11 @@ EXPORT_SYMBOL(napi_schedule_prep);
  */
 void __napi_schedule_irqoff(struct napi_struct *n)
 {
+	if (test_bit(NAPI_STATE_THREADED, &n->state)) {
+		queue_work(napi_workq, &n->work);
+		return;
+	}
+
 	____napi_schedule(this_cpu_ptr(&softnet_data), n);
 }
 EXPORT_SYMBOL(__napi_schedule_irqoff);
@@ -6601,6 +6612,29 @@ static void init_gro_hash(struct napi_struct *napi)
 	napi->gro_bitmask = 0;
 }
 
+static void napi_workfn(struct work_struct *work)
+{
+	struct napi_struct *n = container_of(work, struct napi_struct, work);
+
+	for (;;) {
+		if (!test_bit(NAPI_STATE_SCHED, &n->state))
+			return;
+
+		if (n->poll(n, n->weight) < n->weight)
+			return;
+
+		if (need_resched()) {
+			/*
+			 * have to pay for the latency of task switch even if
+			 * napi is scheduled
+			 */
+			if (test_bit(NAPI_STATE_SCHED, &n->state))
+				queue_work(napi_workq, work);
+			return;
+		}
+	}
+}
+
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -6621,6 +6655,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 #ifdef CONFIG_NETPOLL
 	napi->poll_owner = -1;
 #endif
+	INIT_WORK(&napi->work, napi_workfn);
 	set_bit(NAPI_STATE_SCHED, &napi->state);
 	napi_hash_add(napi);
 }
@@ -10676,6 +10711,10 @@ static int __init net_dev_init(void)
 		sd->backlog.weight = weight_p;
 	}
 
+	napi_workq = alloc_workqueue("napi_workq", WQ_UNBOUND | WQ_HIGHPRI,
+				     WQ_UNBOUND_MAX_ACTIVE);
+	BUG_ON(!napi_workq);
+
 	dev_boot_phase = 0;
 
 	/* The loopback device is special if any other network devices
