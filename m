Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939B440EB3F
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbhIPUD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbhIPUDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 16:03:53 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C591CC061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 13:02:31 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id c10so10186131qko.11
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 13:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KXU1PgDVKXGgm73qRuoIwr3PauWts7o33gZEp4l1l9w=;
        b=6Mq4r/dhOWXADHTJ/D3bar34DvlOC8Xets9mSxmYc2ps94Mrvt53ZdJL4FhNpYmDO6
         HZGz6nkvT88TY4OSiUXskEoUqwBRgPxJyYAK8K9rnIGW0W8qT4EAuXWhUXU4xAUVv9j1
         vRTnt8OCaywu3kv+Q8qRy2WD5lQEqiNdAWb0QQYhKbJy9an3mXtqMf1WqobIIsSsZeAq
         yQQnwByd2auzyy9yza0XcMvrBOUiLESmAdzvnG7R+twkRWY8U4zF7V3wMQRqksL1slQd
         FBFebdTtlXLy/ZPwtE99NjdfRqXAscQdnKVSidpd/VTmeZZwoh9Dsq8gwx3GfDXtxM21
         zmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KXU1PgDVKXGgm73qRuoIwr3PauWts7o33gZEp4l1l9w=;
        b=lwlviCWrdcWW4BRSo6+hvenRMrShPbQ8SQdJpqEBfid1VeSMnPEPmSFj6obfEgEk34
         jNdffa2Ig6ZvenfBSn+xA67osrVdOEQHuTLgUCWR35+YckbAEi0dGi/9cpemgMLOWR42
         MusU4s5+2YcOz9iIF2M2Js16doI+gPFTAeQzIyHA2mQKq4Fp7R3029KyarhL9e2zYQCS
         Qlve16b6qGih/6iAjaWWf5qP4sS+07peTum5u4VH5Bb7dUjO/53qUSOYhSFmtvvuxtj1
         qzPqTmyHkR/PBi8inUH7wzxgW1CuS8aNxPx7E8JjtYV79LBgHszqOGavLaylVtYGaGIC
         Yf2g==
X-Gm-Message-State: AOAM533G8VqqA3woXK11jFfMA7fvi0Ft0uTIBL6lg+dz4jLnEwu1rdFO
        zXI9lXpYxY5OPQXsaBsAZ/Tllw==
X-Google-Smtp-Source: ABdhPJxqc/fngr1i3pfa1GUU/Od8iCrVg7QnQJHJGXwD6zHwU87g+Cz5kTI49VaTbWAmEh7vX0LssQ==
X-Received: by 2002:a05:620a:2f1:: with SMTP id a17mr6875481qko.122.1631822550071;
        Thu, 16 Sep 2021 13:02:30 -0700 (PDT)
Received: from localhost.localdomain (200.146.127.228.dynamic.adsl.gvt.net.br. [200.146.127.228])
        by smtp.googlemail.com with ESMTPSA id a24sm1307043qtp.90.2021.09.16.13.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 13:02:29 -0700 (PDT)
From:   Felipe Magno de Almeida <felipe@sipanda.io>
X-Google-Original-From: Felipe Magno de Almeida <felipe@expertise.dev>
To:     jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, boris.sukholitko@broadcom.com,
        vadym.kochan@plvision.eu, ilya.lifshits@broadcom.com,
        vladbu@nvidia.com, idosch@idosch.org, paulb@nvidia.com,
        dcaratti@redhat.com, marcelo.leitner@gmail.com,
        amritha.nambiar@intel.com, sridhar.samudrala@intel.com,
        tom@sipanda.io, pctammela@mojatatu.com, eric.dumazet@gmail.com,
        Felipe Magno de Almeida <felipe@sipanda.io>
Subject: [PATCH RFC net-next 2/2] net/sched: Add flower2 packet classifier based on flower and PANDA parser
Date:   Thu, 16 Sep 2021 17:00:41 -0300
Message-Id: <20210916200041.810-3-felipe@expertise.dev>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916200041.810-1-felipe@expertise.dev>
References: <20210916200041.810-1-felipe@expertise.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felipe Magno de Almeida <felipe@sipanda.io>

This commit reimplements the flower classifier, the main consumer of
flow dissector, on top of the PANDA parser by mostly cutnpastying the
flower code and modifying where the parser is used (fl_classify). The
new classifier is called "flower2". The iproute2 patch is sent
separately - but you'll notice other than replacing the user space tc
commands with "flower2", the syntax is exactly the same. This
classifier illustrates the flexibility of the PANDA parser and shows a
few simple encapsulation use cases that become convoluted and complex
because of flowdissector's intricacies below:

- Customizing parsing behavior is impossible and requires multiple
   workarounds on client code to avoid pitfalls in special cases
   handled by flow dissector and to avoid unnecessary overhead.

- Due to its rigid nature, there's non-trivial loss of information when
   you have multiple layers of encap (eg multiple repeated ethernet
   headers, or ip headers etc).

- It is not flexible enough to map well to the semantics of hardware
   offloading of parsers i.e the software twin in the kernel and
   specific hardware semantics may have different capabilities.

This parser lets us match three levels of encapsulation and check for
properties in four stacked protocols simultaneously in a single pass.

Some usage examples of the flower2 classifier:

To show how flower2 is compatible with current flower classifier,
let's see how we would create a filter for the following packet
(captured via tcpdump):

```
(oui Ethernet) > Broadcast, ethertype IPv4 (0x0800), length 60: \
  localhost.22 > localhost.80: Flags [S], seq 0, win 8192, length
```

As you can expect, the line command is almost identical for flower2:

```
tc filter add dev lo parent ffff: protocol ip prio 1 flower2 \
  ip_proto tcp dst_port 80 action drop
```

Which will create the following filter after a single packet
illuistrated earlier (via tcpdump) is seen:

```
filter protocol ip flower2 chain 0
filter protocol ip flower2 chain 0 handle 0x1
  eth_type ipv4
  ip_proto tcp
  dst_port 80
  not_in_hw
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 4 sec used 4 sec
        Action statistics:
        Sent 46 bytes 1 pkt (dropped 1, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
```

However, by using PANDA, flower2, due to its use of PANDA, can be
extended to easily cover more complex cases with ease relative to
flower. Let us take an example of the following packet (captured via
tcpdump) which is subject to discussions in [1]:

```
(oui Ethernet) > Broadcast, ethertype 802.1Q (0x8100), length 85: \
  vlan 2, p 0, ethertype PPPoE S (0x8864), PPPoE  IP6 (0x0057), \
  length 61: localhost.ftp-data > localhost.http: Flags [S], \
  seq 0, win 8192, length 0
```

The above packet has three encapsulation layers, vlan, pppoe, ppp,
ipv6, to drop ipv6 encapsulated packets with dst ip ::1, we would
write a filter as such:

```
tc filter add dev lo parent ffff: protocol 802.1Q prio 1 flower2 \
  vlan_id 2 vlan_ethtype 0x8864 ppp_proto ppp_ipv6 dst_ip ::1  \
  action drop
```

And the result after a single such packet is seen:

```
filter protocol 802.1Q flower2 chain 0
filter protocol 802.1Q flower2 chain 0 handle 0x1
  ppp_proto ppp_ipv6
  vlan_id 2
  vlan_ethtype ppp_ses
  eth_type 8864
  dst_ip ::1
  not_in_hw
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 59 sec used 36 sec firstused 36 sec
        Action statistics:
        Sent 67 bytes 1 pkt (dropped 1, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
```

[1]: https://patchwork.kernel.org/project/netdevbpf/patch/20210830080849.18695-1-boris.sukholitko@broadcom.com/

Signed-off-by: Felipe Magno de Almeida <felipe@sipanda.io>
---
 net/sched/Kconfig                   |   11 +
 net/sched/Makefile                  |    2 +
 net/sched/cls_flower2_main.c        | 3289 +++++++++++++++++++++++++++
 net/sched/cls_flower2_panda_noopt.c |  305 +++
 net/sched/cls_flower2_panda_opt.c   | 1536 +++++++++++++
 5 files changed, 5143 insertions(+)
 create mode 100644 net/sched/cls_flower2_main.c
 create mode 100644 net/sched/cls_flower2_panda_noopt.c
 create mode 100644 net/sched/cls_flower2_panda_opt.c

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 1e8ab4749c6c..02cd86492992 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -630,6 +630,17 @@ config NET_CLS_FLOWER
 	  To compile this code as a module, choose M here: the module will
 	  be called cls_flower.
 
+config NET_CLS_FLOWER2
+	tristate "Flower PANDA classifier"
+	select NET_CLS
+	depends on NET_PANDA
+	help
+	  If you say Y here, you will be able to classify packets based on
+	  a configurable combination of packet keys and masks.
+
+	  To compile this code as a module, choose M here: the module will
+	  be called cls_flower.
+
 config NET_CLS_MATCHALL
 	tristate "Match-all classifier"
 	select NET_CLS
diff --git a/net/sched/Makefile b/net/sched/Makefile
index dd14ef413fda..d97f86ea9f4e 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -77,6 +77,8 @@ obj-$(CONFIG_NET_CLS_FLOW)	+= cls_flow.o
 obj-$(CONFIG_NET_CLS_CGROUP)	+= cls_cgroup.o
 obj-$(CONFIG_NET_CLS_BPF)	+= cls_bpf.o
 obj-$(CONFIG_NET_CLS_FLOWER)	+= cls_flower.o
+obj-$(CONFIG_NET_CLS_FLOWER2)	+= cls_flower2.o
+cls_flower2-y := cls_flower2_main.o cls_flower2_panda_opt.o
 obj-$(CONFIG_NET_CLS_MATCHALL)	+= cls_matchall.o
 obj-$(CONFIG_NET_EMATCH)	+= ematch.o
 obj-$(CONFIG_NET_EMATCH_CMP)	+= em_cmp.o
diff --git a/net/sched/cls_flower2_main.c b/net/sched/cls_flower2_main.c
new file mode 100644
index 000000000000..8b92117a23d7
--- /dev/null
+++ b/net/sched/cls_flower2_main.c
@@ -0,0 +1,3289 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/cls_flower2.c		Flower classifier
+ *
+ * Copyright (c) 2015 Jiri Pirko <jiri@resnulli.us>
+ * Copyright (c) 2021 SiPanda
+ *   Authors: Felipe Magno de Almeida <felipe@sipanda.io>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/rhashtable.h>
+#include <linux/workqueue.h>
+#include <linux/refcount.h>
+
+#include <linux/if_ether.h>
+#include <linux/in6.h>
+#include <linux/ip.h>
+#include <linux/ppp_defs.h>
+#include <linux/mpls.h>
+
+#include <net/sch_generic.h>
+#include <net/pkt_cls.h>
+#include <net/ip.h>
+#include <net/flow_dissector.h>
+#include <net/geneve.h>
+#include <net/vxlan.h>
+#include <net/erspan.h>
+#include <net/panda/parser.h>
+
+#include <net/dst.h>
+#include <net/dst_metadata.h>
+
+#include <uapi/linux/netfilter/nf_conntrack_common.h>
+
+#include <net/panda/parser.h>
+
+PANDA_PARSER_KMOD_EXTERN(panda_parser_big_ether);
+
+//pkt_cls redefination for TCA_FLOWER_KEY_PPP_PROTO
+#define TCA_FLOWER2_KEY_PPP_PROTO 102
+#define TCA_FLOWER2_MAX 102
+
+#define TCA_FLOWER_KEY_CT_FLAGS_MAX \
+		((__TCA_FLOWER_KEY_CT_FLAGS_MAX - 1) << 1)
+#define TCA_FLOWER_KEY_CT_FLAGS_MASK \
+		(TCA_FLOWER_KEY_CT_FLAGS_MAX - 1)
+
+struct flow_dissector_key_ppp {
+	__be16 ppp_proto;
+};
+
+struct fl2_flow_key {
+	struct flow_dissector_key_meta meta;
+	struct flow_dissector_key_control control;
+	struct flow_dissector_key_control enc_control;
+	struct flow_dissector_key_basic basic;
+	struct flow_dissector_key_eth_addrs eth;
+	struct flow_dissector_key_vlan vlan;
+	struct flow_dissector_key_vlan cvlan;
+	union {
+		struct flow_dissector_key_ipv4_addrs ipv4;
+		struct flow_dissector_key_ipv6_addrs ipv6;
+	};
+	struct flow_dissector_key_ports tp;
+	struct flow_dissector_key_icmp icmp;
+	struct flow_dissector_key_arp arp;
+	struct flow_dissector_key_keyid enc_key_id;
+	union {
+		struct flow_dissector_key_ipv4_addrs enc_ipv4;
+		struct flow_dissector_key_ipv6_addrs enc_ipv6;
+	};
+	struct flow_dissector_key_ports enc_tp;
+	struct flow_dissector_key_mpls mpls;
+	struct flow_dissector_key_tcp tcp;
+	struct flow_dissector_key_ip ip;
+	struct flow_dissector_key_ip enc_ip;
+	struct flow_dissector_key_enc_opts enc_opts;
+	union {
+		struct flow_dissector_key_ports tp;
+		struct {
+			struct flow_dissector_key_ports tp_min;
+			struct flow_dissector_key_ports tp_max;
+		};
+	} tp_range;
+	struct flow_dissector_key_ct ct;
+	struct flow_dissector_key_hash hash;
+	struct flow_dissector_key_ppp ppp;
+} __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
+
+struct fl2_flow_mask_range {
+	unsigned short int start;
+	unsigned short int end;
+};
+
+struct fl2_flow_mask {
+	struct fl2_flow_key key;
+	struct fl2_flow_mask_range range;
+	u32 flags;
+	struct rhash_head ht_node;
+	struct rhashtable ht;
+	struct rhashtable_params filter_ht_params;
+	struct flow_dissector dissector;
+	struct list_head filters;
+	struct rcu_work rwork;
+	struct list_head list;
+	refcount_t refcnt;
+};
+
+struct fl2_flow_tmplt {
+	struct fl2_flow_key dummy_key;
+	struct fl2_flow_key mask;
+	struct flow_dissector dissector;
+	struct tcf_chain *chain;
+};
+
+struct cls_fl2_head {
+	struct rhashtable ht;
+	spinlock_t masks_lock; /* Protect masks list */
+	struct list_head masks;
+	struct list_head hw_filters;
+	struct rcu_work rwork;
+	struct idr handle_idr;
+};
+
+struct cls_fl2_filter {
+	struct fl2_flow_mask *mask;
+	struct rhash_head ht_node;
+	struct fl2_flow_key mkey;
+	struct tcf_exts exts;
+	struct tcf_result res;
+	struct fl2_flow_key key;
+	struct list_head list;
+	struct list_head hw_list;
+	u32 handle;
+	u32 flags;
+	u32 in_hw_count;
+	struct rcu_work rwork;
+	struct net_device *hw_dev;
+	/* Flower classifier is unlocked, which means that its reference counter
+	 * can be changed concurrently without any kind of external
+	 * synchronization. Use atomic reference counter to be concurrency-safe.
+	 */
+	refcount_t refcnt;
+	bool deleted;
+};
+
+/* Meta data structure for just one frame */
+struct panda_parser_big_metadata_one {
+	struct panda_metadata panda_data;
+	struct fl2_flow_key frame;
+};
+
+static const struct rhashtable_params mask_ht_params = {
+	.key_offset = offsetof(struct fl2_flow_mask, key),
+	.key_len = sizeof(struct fl2_flow_key),
+	.head_offset = offsetof(struct fl2_flow_mask, ht_node),
+	.automatic_shrinking = true,
+};
+
+static unsigned short int fl2_mask_range(const struct fl2_flow_mask *mask)
+{
+	return mask->range.end - mask->range.start;
+}
+
+static void fl2_mask_update_range(struct fl2_flow_mask *mask)
+{
+	const u8 *bytes = (const u8 *) &mask->key;
+	size_t size = sizeof(mask->key);
+	size_t i, first = 0, last;
+
+	for (i = 0; i < size; i++) {
+		if (bytes[i]) {
+			first = i;
+			break;
+		}
+	}
+	last = first;
+	for (i = size - 1; i != first; i--) {
+		if (bytes[i]) {
+			last = i;
+			break;
+		}
+	}
+	mask->range.start = rounddown(first, sizeof(long));
+	mask->range.end = roundup(last + 1, sizeof(long));
+}
+
+static void *fl2_key_get_start(struct fl2_flow_key *key,
+			      const struct fl2_flow_mask *mask)
+{
+	return (u8 *) key + mask->range.start;
+}
+
+static void fl2_set_masked_key(struct fl2_flow_key *mkey, struct fl2_flow_key *key,
+			      struct fl2_flow_mask *mask)
+{
+	const long *lkey = fl2_key_get_start(key, mask);
+	const long *lmask = fl2_key_get_start(&mask->key, mask);
+	long *lmkey = fl2_key_get_start(mkey, mask);
+	int i;
+
+	for (i = 0; i < fl2_mask_range(mask); i += sizeof(long))
+		*lmkey++ = *lkey++ & *lmask++;
+}
+
+static bool fl2_mask_fits_tmplt(struct fl2_flow_tmplt *tmplt,
+			       struct fl2_flow_mask *mask)
+{
+	const long *lmask = fl2_key_get_start(&mask->key, mask);
+	const long *ltmplt;
+	int i;
+
+	if (!tmplt)
+		return true;
+	ltmplt = fl2_key_get_start(&tmplt->mask, mask);
+	for (i = 0; i < fl2_mask_range(mask); i += sizeof(long)) {
+		if (~*ltmplt++ & *lmask++)
+			return false;
+	}
+	return true;
+}
+
+static void fl2_clear_masked_range(struct fl2_flow_key *key,
+				  struct fl2_flow_mask *mask)
+{
+	memset(fl2_key_get_start(key, mask), 0, fl2_mask_range(mask));
+}
+
+static bool fl2_range_port_dst_cmp(struct cls_fl2_filter *filter,
+				  struct fl2_flow_key *key,
+				  struct fl2_flow_key *mkey)
+{
+	u16 min_mask, max_mask, min_val, max_val;
+
+	min_mask = ntohs(filter->mask->key.tp_range.tp_min.dst);
+	max_mask = ntohs(filter->mask->key.tp_range.tp_max.dst);
+	min_val = ntohs(filter->key.tp_range.tp_min.dst);
+	max_val = ntohs(filter->key.tp_range.tp_max.dst);
+
+	if (min_mask && max_mask) {
+		if (ntohs(key->tp_range.tp.dst) < min_val ||
+		    ntohs(key->tp_range.tp.dst) > max_val)
+			return false;
+
+		/* skb does not have min and max values */
+		mkey->tp_range.tp_min.dst = filter->mkey.tp_range.tp_min.dst;
+		mkey->tp_range.tp_max.dst = filter->mkey.tp_range.tp_max.dst;
+	}
+	return true;
+}
+
+static bool fl2_range_port_src_cmp(struct cls_fl2_filter *filter,
+				  struct fl2_flow_key *key,
+				  struct fl2_flow_key *mkey)
+{
+	u16 min_mask, max_mask, min_val, max_val;
+
+	min_mask = ntohs(filter->mask->key.tp_range.tp_min.src);
+	max_mask = ntohs(filter->mask->key.tp_range.tp_max.src);
+	min_val = ntohs(filter->key.tp_range.tp_min.src);
+	max_val = ntohs(filter->key.tp_range.tp_max.src);
+
+	if (min_mask && max_mask) {
+		if (ntohs(key->tp_range.tp.src) < min_val ||
+		    ntohs(key->tp_range.tp.src) > max_val)
+			return false;
+
+		/* skb does not have min and max values */
+		mkey->tp_range.tp_min.src = filter->mkey.tp_range.tp_min.src;
+		mkey->tp_range.tp_max.src = filter->mkey.tp_range.tp_max.src;
+	}
+	return true;
+}
+
+static struct cls_fl2_filter *__fl2_lookup(struct fl2_flow_mask *mask,
+					 struct fl2_flow_key *mkey)
+{
+	return rhashtable_lookup_fast(&mask->ht, fl2_key_get_start(mkey, mask),
+				      mask->filter_ht_params);
+}
+
+static struct cls_fl2_filter *fl2_lookup_range(struct fl2_flow_mask *mask,
+					     struct fl2_flow_key *mkey,
+					     struct fl2_flow_key *key)
+{
+	struct cls_fl2_filter *filter, *f;
+
+	list_for_each_entry_rcu(filter, &mask->filters, list) {
+		if (!fl2_range_port_dst_cmp(filter, key, mkey))
+			continue;
+
+		if (!fl2_range_port_src_cmp(filter, key, mkey))
+			continue;
+
+		f = __fl2_lookup(mask, mkey);
+		if (f)
+			return f;
+	}
+	return NULL;
+}
+
+static noinline_for_stack
+struct cls_fl2_filter *fl2_mask_lookup(struct fl2_flow_mask *mask, struct fl2_flow_key *key)
+{
+	struct fl2_flow_key mkey;
+
+	fl2_set_masked_key(&mkey, key, mask);
+	if ((mask->flags & TCA_FLOWER_MASK_FLAGS_RANGE))
+		return fl2_lookup_range(mask, &mkey, key);
+
+	return __fl2_lookup(mask, &mkey);
+}
+
+int fl2_panda_parse(struct sk_buff *skb, struct fl2_flow_key* frame)
+{
+	int err;
+	struct panda_parser_big_metadata_one mdata;
+	void *data;
+	size_t pktlen;
+
+	memset(&mdata, 0, sizeof(mdata.panda_data));
+	memcpy(&mdata.frame, frame, sizeof(struct fl2_flow_key));
+
+	err = skb_linearize(skb);
+	if (err < 0)
+		return err;
+
+	BUG_ON(skb->data_len);
+
+	data = skb_mac_header(skb);
+	pktlen = skb_mac_header_len(skb) + skb->len;
+
+	err = panda_parse(PANDA_PARSER_KMOD_NAME(panda_parser_big_ether), data,
+			  pktlen, &mdata.panda_data, 0, 1);
+
+	if (err != PANDA_STOP_OKAY) {
+                pr_err("Failed to parse packet! (%d)", err);
+		return -1;
+        }
+
+	memcpy(frame, &mdata.frame, sizeof(struct fl2_flow_key));
+
+	return 0;
+}
+
+static int fl2_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+		       struct tcf_result *res)
+{
+	struct cls_fl2_head *head = rcu_dereference_bh(tp->root);
+	struct fl2_flow_key skb_key;
+	struct fl2_flow_mask *mask;
+	struct cls_fl2_filter *f;
+
+	list_for_each_entry_rcu(mask, &head->masks, list) {
+		flow_dissector_init_keys(&skb_key.control, &skb_key.basic);
+		fl2_clear_masked_range(&skb_key, mask);
+
+		skb_flow_dissect_meta(skb, &mask->dissector, &skb_key);
+		/* skb_flow_dissect() does not set n_proto in case an unknown
+		 * protocol, so do it rather here.
+		 */
+		skb_key.basic.n_proto = skb_protocol(skb, false);
+
+		if(skb->vlan_present) {
+			skb_key.basic.n_proto = skb_protocol(skb, true);
+			skb_key.vlan.vlan_id = skb_vlan_tag_get_id(skb);
+			skb_key.vlan.vlan_priority = skb_vlan_tag_get_prio(skb);
+			skb_key.vlan.vlan_tpid = skb->vlan_proto;
+		}
+		
+		fl2_panda_parse(skb, &skb_key);
+
+		f = fl2_mask_lookup(mask, &skb_key);
+		if (f && !tc_skip_sw(f->flags)) {
+			*res = f->res;
+			return tcf_exts_exec(skb, &f->exts, res);
+		}
+	}
+	return -1;
+}
+
+static int fl2_init(struct tcf_proto *tp)
+{
+	struct cls_fl2_head *head;
+
+	head = kzalloc(sizeof(*head), GFP_KERNEL);
+	if (!head)
+		return -ENOBUFS;
+
+	spin_lock_init(&head->masks_lock);
+	INIT_LIST_HEAD_RCU(&head->masks);
+	INIT_LIST_HEAD(&head->hw_filters);
+	rcu_assign_pointer(tp->root, head);
+	idr_init(&head->handle_idr);
+
+	return rhashtable_init(&head->ht, &mask_ht_params);
+}
+
+static void fl2_mask_free(struct fl2_flow_mask *mask, bool mask_init_done)
+{
+	/* temporary masks don't have their filters list and ht initialized */
+	if (mask_init_done) {
+		WARN_ON(!list_empty(&mask->filters));
+		rhashtable_destroy(&mask->ht);
+	}
+	kfree(mask);
+}
+
+static void fl2_mask_free_work(struct work_struct *work)
+{
+	struct fl2_flow_mask *mask = container_of(to_rcu_work(work),
+						 struct fl2_flow_mask, rwork);
+
+	fl2_mask_free(mask, true);
+}
+
+static void fl2_uninit_mask_free_work(struct work_struct *work)
+{
+	struct fl2_flow_mask *mask = container_of(to_rcu_work(work),
+						 struct fl2_flow_mask, rwork);
+
+	fl2_mask_free(mask, false);
+}
+
+static bool fl2_mask_put(struct cls_fl2_head *head, struct fl2_flow_mask *mask)
+{
+	if (!refcount_dec_and_test(&mask->refcnt))
+		return false;
+
+	rhashtable_remove_fast(&head->ht, &mask->ht_node, mask_ht_params);
+
+	spin_lock(&head->masks_lock);
+	list_del_rcu(&mask->list);
+	spin_unlock(&head->masks_lock);
+
+	tcf_queue_work(&mask->rwork, fl2_mask_free_work);
+
+	return true;
+}
+
+static struct cls_fl2_head *fl2_head_dereference(struct tcf_proto *tp)
+{
+	/* Flower classifier only changes root pointer during init and destroy.
+	 * Users must obtain reference to tcf_proto instance before calling its
+	 * API, so tp->root pointer is protected from concurrent call to
+	 * fl2_destroy() by reference counting.
+	 */
+	return rcu_dereference_raw(tp->root);
+}
+
+static void __fl2_destroy_filter(struct cls_fl2_filter *f)
+{
+	tcf_exts_destroy(&f->exts);
+	tcf_exts_put_net(&f->exts);
+	kfree(f);
+}
+
+static void fl2_destroy_filter_work(struct work_struct *work)
+{
+	struct cls_fl2_filter *f = container_of(to_rcu_work(work),
+					struct cls_fl2_filter, rwork);
+
+	__fl2_destroy_filter(f);
+}
+
+static void fl2_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl2_filter *f,
+				 bool rtnl_held, struct netlink_ext_ack *extack)
+{
+	struct tcf_block *block = tp->chain->block;
+	struct flow_cls_offload cls_flower = {};
+
+	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
+	cls_flower.command = FLOW_CLS_DESTROY;
+	cls_flower.cookie = (unsigned long) f;
+
+	tc_setup_cb_destroy(block, tp, TC_SETUP_CLSFLOWER, &cls_flower, false,
+			    &f->flags, &f->in_hw_count, rtnl_held);
+
+}
+
+static int fl2_hw_replace_filter(struct tcf_proto *tp,
+				struct cls_fl2_filter *f, bool rtnl_held,
+				struct netlink_ext_ack *extack)
+{
+	struct tcf_block *block = tp->chain->block;
+	struct flow_cls_offload cls_flower = {};
+	bool skip_sw = tc_skip_sw(f->flags);
+	int err = 0;
+
+	cls_flower.rule = flow_rule_alloc(tcf_exts_num_actions(&f->exts));
+	if (!cls_flower.rule)
+		return -ENOMEM;
+
+	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
+	cls_flower.command = FLOW_CLS_REPLACE;
+	cls_flower.cookie = (unsigned long) f;
+	cls_flower.rule->match.dissector = &f->mask->dissector;
+	cls_flower.rule->match.mask = &f->mask->key;
+	cls_flower.rule->match.key = &f->mkey;
+	cls_flower.classid = f->res.classid;
+
+	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+	if (err) {
+		kfree(cls_flower.rule);
+		if (skip_sw) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
+			return err;
+		}
+		return 0;
+	}
+
+	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
+			      skip_sw, &f->flags, &f->in_hw_count, rtnl_held);
+	tc_cleanup_flow_action(&cls_flower.rule->action);
+	kfree(cls_flower.rule);
+
+	if (err) {
+		fl2_hw_destroy_filter(tp, f, rtnl_held, NULL);
+		return err;
+	}
+
+	if (skip_sw && !(f->flags & TCA_CLS_FLAGS_IN_HW))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void fl2_hw_update_stats(struct tcf_proto *tp, struct cls_fl2_filter *f,
+			       bool rtnl_held)
+{
+	struct tcf_block *block = tp->chain->block;
+	struct flow_cls_offload cls_flower = {};
+
+	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, NULL);
+	cls_flower.command = FLOW_CLS_STATS;
+	cls_flower.cookie = (unsigned long) f;
+	cls_flower.classid = f->res.classid;
+
+	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
+			 rtnl_held);
+
+	tcf_exts_stats_update(&f->exts, cls_flower.stats.bytes,
+			      cls_flower.stats.pkts,
+			      cls_flower.stats.drops,
+			      cls_flower.stats.lastused,
+			      cls_flower.stats.used_hw_stats,
+			      cls_flower.stats.used_hw_stats_valid);
+}
+
+static void __fl2_put(struct cls_fl2_filter *f)
+{
+	if (!refcount_dec_and_test(&f->refcnt))
+		return;
+
+	if (tcf_exts_get_net(&f->exts))
+		tcf_queue_work(&f->rwork, fl2_destroy_filter_work);
+	else
+		__fl2_destroy_filter(f);
+}
+
+static struct cls_fl2_filter *__fl2_get(struct cls_fl2_head *head, u32 handle)
+{
+	struct cls_fl2_filter *f;
+
+	rcu_read_lock();
+	f = idr_find(&head->handle_idr, handle);
+	if (f && !refcount_inc_not_zero(&f->refcnt))
+		f = NULL;
+	rcu_read_unlock();
+
+	return f;
+}
+
+static int __fl2_delete(struct tcf_proto *tp, struct cls_fl2_filter *f,
+		       bool *last, bool rtnl_held,
+		       struct netlink_ext_ack *extack)
+{
+	struct cls_fl2_head *head = fl2_head_dereference(tp);
+
+	*last = false;
+
+	spin_lock(&tp->lock);
+	if (f->deleted) {
+		spin_unlock(&tp->lock);
+		return -ENOENT;
+	}
+
+	f->deleted = true;
+	rhashtable_remove_fast(&f->mask->ht, &f->ht_node,
+			       f->mask->filter_ht_params);
+	idr_remove(&head->handle_idr, f->handle);
+	list_del_rcu(&f->list);
+	spin_unlock(&tp->lock);
+
+	*last = fl2_mask_put(head, f->mask);
+	if (!tc_skip_hw(f->flags))
+		fl2_hw_destroy_filter(tp, f, rtnl_held, extack);
+	tcf_unbind_filter(tp, &f->res);
+	__fl2_put(f);
+
+	return 0;
+}
+
+static void fl2_destroy_sleepable(struct work_struct *work)
+{
+	struct cls_fl2_head *head = container_of(to_rcu_work(work),
+						struct cls_fl2_head,
+						rwork);
+
+	rhashtable_destroy(&head->ht);
+	kfree(head);
+	module_put(THIS_MODULE);
+}
+
+static void fl2_destroy(struct tcf_proto *tp, bool rtnl_held,
+		       struct netlink_ext_ack *extack)
+{
+	struct cls_fl2_head *head = fl2_head_dereference(tp);
+	struct fl2_flow_mask *mask, *next_mask;
+	struct cls_fl2_filter *f, *next;
+	bool last;
+
+	list_for_each_entry_safe(mask, next_mask, &head->masks, list) {
+		list_for_each_entry_safe(f, next, &mask->filters, list) {
+			__fl2_delete(tp, f, &last, rtnl_held, extack);
+			if (last)
+				break;
+		}
+	}
+	idr_destroy(&head->handle_idr);
+
+	__module_get(THIS_MODULE);
+	tcf_queue_work(&head->rwork, fl2_destroy_sleepable);
+}
+
+static void fl2_put(struct tcf_proto *tp, void *arg)
+{
+	struct cls_fl2_filter *f = arg;
+
+	__fl2_put(f);
+}
+
+static void *fl2_get(struct tcf_proto *tp, u32 handle)
+{
+	struct cls_fl2_head *head = fl2_head_dereference(tp);
+
+	return __fl2_get(head, handle);
+}
+
+static const struct nla_policy fl2_policy[TCA_FLOWER2_MAX + 1] = {
+	[TCA_FLOWER_UNSPEC]		= { .type = NLA_UNSPEC },
+	[TCA_FLOWER_CLASSID]		= { .type = NLA_U32 },
+	[TCA_FLOWER_INDEV]		= { .type = NLA_STRING,
+					    .len = IFNAMSIZ },
+	[TCA_FLOWER_KEY_ETH_DST]	= { .len = ETH_ALEN },
+	[TCA_FLOWER_KEY_ETH_DST_MASK]	= { .len = ETH_ALEN },
+	[TCA_FLOWER_KEY_ETH_SRC]	= { .len = ETH_ALEN },
+	[TCA_FLOWER_KEY_ETH_SRC_MASK]	= { .len = ETH_ALEN },
+	[TCA_FLOWER_KEY_ETH_TYPE]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_IP_PROTO]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_IPV4_SRC]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_IPV4_SRC_MASK]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_IPV4_DST]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_IPV4_DST_MASK]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_IPV6_SRC]	= { .len = sizeof(struct in6_addr) },
+	[TCA_FLOWER_KEY_IPV6_SRC_MASK]	= { .len = sizeof(struct in6_addr) },
+	[TCA_FLOWER_KEY_IPV6_DST]	= { .len = sizeof(struct in6_addr) },
+	[TCA_FLOWER_KEY_IPV6_DST_MASK]	= { .len = sizeof(struct in6_addr) },
+	[TCA_FLOWER_KEY_TCP_SRC]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_TCP_DST]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_UDP_SRC]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_UDP_DST]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_VLAN_ID]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_VLAN_PRIO]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_VLAN_ETH_TYPE]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_ENC_KEY_ID]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ENC_IPV4_SRC]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ENC_IPV4_SRC_MASK] = { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ENC_IPV4_DST]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ENC_IPV4_DST_MASK] = { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ENC_IPV6_SRC]	= { .len = sizeof(struct in6_addr) },
+	[TCA_FLOWER_KEY_ENC_IPV6_SRC_MASK] = { .len = sizeof(struct in6_addr) },
+	[TCA_FLOWER_KEY_ENC_IPV6_DST]	= { .len = sizeof(struct in6_addr) },
+	[TCA_FLOWER_KEY_ENC_IPV6_DST_MASK] = { .len = sizeof(struct in6_addr) },
+	[TCA_FLOWER_KEY_TCP_SRC_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_TCP_DST_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_UDP_SRC_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_UDP_DST_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_SCTP_SRC_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_SCTP_DST_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_SCTP_SRC]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_SCTP_DST]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_ENC_UDP_SRC_PORT]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_ENC_UDP_SRC_PORT_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_ENC_UDP_DST_PORT]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_ENC_UDP_DST_PORT_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_FLAGS]		= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_FLAGS_MASK]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ICMPV4_TYPE]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ICMPV4_TYPE_MASK] = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ICMPV4_CODE]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ICMPV4_CODE_MASK] = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ICMPV6_TYPE]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ICMPV6_TYPE_MASK] = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ICMPV6_CODE]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ICMPV6_CODE_MASK] = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ARP_SIP]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ARP_SIP_MASK]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ARP_TIP]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ARP_TIP_MASK]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ARP_OP]		= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ARP_OP_MASK]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ARP_SHA]	= { .len = ETH_ALEN },
+	[TCA_FLOWER_KEY_ARP_SHA_MASK]	= { .len = ETH_ALEN },
+	[TCA_FLOWER_KEY_ARP_THA]	= { .len = ETH_ALEN },
+	[TCA_FLOWER_KEY_ARP_THA_MASK]	= { .len = ETH_ALEN },
+	[TCA_FLOWER_KEY_MPLS_TTL]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_BOS]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_TC]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_LABEL]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_MPLS_OPTS]	= { .type = NLA_NESTED },
+	[TCA_FLOWER_KEY_TCP_FLAGS]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_TCP_FLAGS_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_IP_TOS]		= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_IP_TOS_MASK]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_IP_TTL]		= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_IP_TTL_MASK]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_CVLAN_ID]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CVLAN_PRIO]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_CVLAN_ETH_TYPE]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_ENC_IP_TOS]	= { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ENC_IP_TOS_MASK] = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ENC_IP_TTL]	 = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ENC_IP_TTL_MASK] = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ENC_OPTS]	= { .type = NLA_NESTED },
+	[TCA_FLOWER_KEY_ENC_OPTS_MASK]	= { .type = NLA_NESTED },
+	[TCA_FLOWER_KEY_CT_STATE]	=
+		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
+	[TCA_FLOWER_KEY_CT_STATE_MASK]	=
+		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
+	[TCA_FLOWER_KEY_CT_ZONE]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_ZONE_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_MARK]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_CT_MARK_MASK]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_CT_LABELS]	= { .type = NLA_BINARY,
+					    .len = 128 / BITS_PER_BYTE },
+	[TCA_FLOWER_KEY_CT_LABELS_MASK]	= { .type = NLA_BINARY,
+					    .len = 128 / BITS_PER_BYTE },
+	[TCA_FLOWER_FLAGS]		= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_HASH]		= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_HASH_MASK]	= { .type = NLA_U32 },
+	[TCA_FLOWER2_KEY_PPP_PROTO]	= { .type = NLA_U16 },
+
+};
+
+static const struct nla_policy
+enc_opts_policy[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1] = {
+	[TCA_FLOWER_KEY_ENC_OPTS_UNSPEC]        = {
+		.strict_start_type = TCA_FLOWER_KEY_ENC_OPTS_VXLAN },
+	[TCA_FLOWER_KEY_ENC_OPTS_GENEVE]        = { .type = NLA_NESTED },
+	[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]         = { .type = NLA_NESTED },
+	[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN]        = { .type = NLA_NESTED },
+};
+
+static const struct nla_policy
+geneve_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX + 1] = {
+	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_CLASS]      = { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_TYPE]       = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_DATA]       = { .type = NLA_BINARY,
+						       .len = 128 },
+};
+
+static const struct nla_policy
+vxlan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1] = {
+	[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]         = { .type = NLA_U32 },
+};
+
+static const struct nla_policy
+erspan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1] = {
+	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]        = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]      = { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR]        = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]       = { .type = NLA_U8 },
+};
+
+static const struct nla_policy
+mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
+	[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]    = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL]      = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS]      = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC]       = { .type = NLA_U8 },
+	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
+};
+
+static void fl2_set_key_val(struct nlattr **tb,
+			   void *val, int val_type,
+			   void *mask, int mask_type, int len)
+{
+	if (!tb[val_type])
+		return;
+	nla_memcpy(val, tb[val_type], len);
+	if (mask_type == TCA_FLOWER_UNSPEC || !tb[mask_type])
+		memset(mask, 0xff, len);
+	else
+		nla_memcpy(mask, tb[mask_type], len);
+}
+
+static int fl2_set_key_port_range(struct nlattr **tb, struct fl2_flow_key *key,
+				 struct fl2_flow_key *mask,
+				 struct netlink_ext_ack *extack)
+{
+	fl2_set_key_val(tb, &key->tp_range.tp_min.dst,
+		       TCA_FLOWER_KEY_PORT_DST_MIN, &mask->tp_range.tp_min.dst,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_min.dst));
+	fl2_set_key_val(tb, &key->tp_range.tp_max.dst,
+		       TCA_FLOWER_KEY_PORT_DST_MAX, &mask->tp_range.tp_max.dst,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.dst));
+	fl2_set_key_val(tb, &key->tp_range.tp_min.src,
+		       TCA_FLOWER_KEY_PORT_SRC_MIN, &mask->tp_range.tp_min.src,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_min.src));
+	fl2_set_key_val(tb, &key->tp_range.tp_max.src,
+		       TCA_FLOWER_KEY_PORT_SRC_MAX, &mask->tp_range.tp_max.src,
+		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.src));
+
+	if (mask->tp_range.tp_min.dst && mask->tp_range.tp_max.dst &&
+	    ntohs(key->tp_range.tp_max.dst) <=
+	    ntohs(key->tp_range.tp_min.dst)) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[TCA_FLOWER_KEY_PORT_DST_MIN],
+				    "Invalid destination port range (min must be strictly smaller than max)");
+		return -EINVAL;
+	}
+	if (mask->tp_range.tp_min.src && mask->tp_range.tp_max.src &&
+	    ntohs(key->tp_range.tp_max.src) <=
+	    ntohs(key->tp_range.tp_min.src)) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[TCA_FLOWER_KEY_PORT_SRC_MIN],
+				    "Invalid source port range (min must be strictly smaller than max)");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int fl2_set_key_mpls_lse(const struct nlattr *nla_lse,
+			       struct flow_dissector_key_mpls *key_val,
+			       struct flow_dissector_key_mpls *key_mask,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1];
+	struct flow_dissector_mpls_lse *lse_mask;
+	struct flow_dissector_mpls_lse *lse_val;
+	u8 lse_index;
+	u8 depth;
+	int err;
+
+	err = nla_parse_nested(tb, TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX, nla_lse,
+			       mpls_stack_entry_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]) {
+		NL_SET_ERR_MSG(extack, "Missing MPLS option \"depth\"");
+		return -EINVAL;
+	}
+
+	depth = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]);
+
+	/* LSE depth starts at 1, for consistency with terminology used by
+	 * RFC 3031 (section 3.9), where depth 0 refers to unlabeled packets.
+	 */
+	if (depth < 1 || depth > FLOW_DIS_MPLS_MAX) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH],
+				    "Invalid MPLS depth");
+		return -EINVAL;
+	}
+	lse_index = depth - 1;
+
+	dissector_set_mpls_lse(key_val, lse_index);
+	dissector_set_mpls_lse(key_mask, lse_index);
+
+	lse_val = &key_val->ls[lse_index];
+	lse_mask = &key_mask->ls[lse_index];
+
+	if (tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL]) {
+		lse_val->mpls_ttl = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL]);
+		lse_mask->mpls_ttl = MPLS_TTL_MASK;
+	}
+	if (tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS]) {
+		u8 bos = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS]);
+
+		if (bos & ~MPLS_BOS_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS],
+					    "Bottom Of Stack (BOS) must be 0 or 1");
+			return -EINVAL;
+		}
+		lse_val->mpls_bos = bos;
+		lse_mask->mpls_bos = MPLS_BOS_MASK;
+	}
+	if (tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC]) {
+		u8 tc = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC]);
+
+		if (tc & ~MPLS_TC_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC],
+					    "Traffic Class (TC) must be between 0 and 7");
+			return -EINVAL;
+		}
+		lse_val->mpls_tc = tc;
+		lse_mask->mpls_tc = MPLS_TC_MASK;
+	}
+	if (tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]) {
+		u32 label = nla_get_u32(tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]);
+
+		if (label & ~MPLS_LABEL_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL],
+					    "Label must be between 0 and 1048575");
+			return -EINVAL;
+		}
+		lse_val->mpls_label = label;
+		lse_mask->mpls_label = MPLS_LABEL_MASK;
+	}
+
+	return 0;
+}
+
+static int fl2_set_key_mpls_opts(const struct nlattr *nla_mpls_opts,
+				struct flow_dissector_key_mpls *key_val,
+				struct flow_dissector_key_mpls *key_mask,
+				struct netlink_ext_ack *extack)
+{
+	struct nlattr *nla_lse;
+	int rem;
+	int err;
+
+	if (!(nla_mpls_opts->nla_type & NLA_F_NESTED)) {
+		NL_SET_ERR_MSG_ATTR(extack, nla_mpls_opts,
+				    "NLA_F_NESTED is missing");
+		return -EINVAL;
+	}
+
+	nla_for_each_nested(nla_lse, nla_mpls_opts, rem) {
+		if (nla_type(nla_lse) != TCA_FLOWER_KEY_MPLS_OPTS_LSE) {
+			NL_SET_ERR_MSG_ATTR(extack, nla_lse,
+					    "Invalid MPLS option type");
+			return -EINVAL;
+		}
+
+		err = fl2_set_key_mpls_lse(nla_lse, key_val, key_mask, extack);
+		if (err < 0)
+			return err;
+	}
+	if (rem) {
+		NL_SET_ERR_MSG(extack,
+			       "Bytes leftover after parsing MPLS options");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int fl2_set_key_mpls(struct nlattr **tb,
+			   struct flow_dissector_key_mpls *key_val,
+			   struct flow_dissector_key_mpls *key_mask,
+			   struct netlink_ext_ack *extack)
+{
+	struct flow_dissector_mpls_lse *lse_mask;
+	struct flow_dissector_mpls_lse *lse_val;
+
+	if (tb[TCA_FLOWER_KEY_MPLS_OPTS]) {
+		if (tb[TCA_FLOWER_KEY_MPLS_TTL] ||
+		    tb[TCA_FLOWER_KEY_MPLS_BOS] ||
+		    tb[TCA_FLOWER_KEY_MPLS_TC] ||
+		    tb[TCA_FLOWER_KEY_MPLS_LABEL]) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_OPTS],
+					    "MPLS label, Traffic Class, Bottom Of Stack and Time To Live must be encapsulated in the MPLS options attribute");
+			return -EBADMSG;
+		}
+
+		return fl2_set_key_mpls_opts(tb[TCA_FLOWER_KEY_MPLS_OPTS],
+					    key_val, key_mask, extack);
+	}
+
+	lse_val = &key_val->ls[0];
+	lse_mask = &key_mask->ls[0];
+
+	if (tb[TCA_FLOWER_KEY_MPLS_TTL]) {
+		lse_val->mpls_ttl = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_TTL]);
+		lse_mask->mpls_ttl = MPLS_TTL_MASK;
+		dissector_set_mpls_lse(key_val, 0);
+		dissector_set_mpls_lse(key_mask, 0);
+	}
+	if (tb[TCA_FLOWER_KEY_MPLS_BOS]) {
+		u8 bos = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_BOS]);
+
+		if (bos & ~MPLS_BOS_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_BOS],
+					    "Bottom Of Stack (BOS) must be 0 or 1");
+			return -EINVAL;
+		}
+		lse_val->mpls_bos = bos;
+		lse_mask->mpls_bos = MPLS_BOS_MASK;
+		dissector_set_mpls_lse(key_val, 0);
+		dissector_set_mpls_lse(key_mask, 0);
+	}
+	if (tb[TCA_FLOWER_KEY_MPLS_TC]) {
+		u8 tc = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_TC]);
+
+		if (tc & ~MPLS_TC_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_TC],
+					    "Traffic Class (TC) must be between 0 and 7");
+			return -EINVAL;
+		}
+		lse_val->mpls_tc = tc;
+		lse_mask->mpls_tc = MPLS_TC_MASK;
+		dissector_set_mpls_lse(key_val, 0);
+		dissector_set_mpls_lse(key_mask, 0);
+	}
+	if (tb[TCA_FLOWER_KEY_MPLS_LABEL]) {
+		u32 label = nla_get_u32(tb[TCA_FLOWER_KEY_MPLS_LABEL]);
+
+		if (label & ~MPLS_LABEL_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_LABEL],
+					    "Label must be between 0 and 1048575");
+			return -EINVAL;
+		}
+		lse_val->mpls_label = label;
+		lse_mask->mpls_label = MPLS_LABEL_MASK;
+		dissector_set_mpls_lse(key_val, 0);
+		dissector_set_mpls_lse(key_mask, 0);
+	}
+	return 0;
+}
+
+static void fl2_set_key_vlan(struct nlattr **tb,
+			    __be16 ethertype,
+			    int vlan_id_key, int vlan_prio_key,
+			    struct flow_dissector_key_vlan *key_val,
+			    struct flow_dissector_key_vlan *key_mask)
+{
+#define VLAN_PRIORITY_MASK	0x7
+
+	if (tb[vlan_id_key]) {
+		key_val->vlan_id =
+			nla_get_u16(tb[vlan_id_key]) & VLAN_VID_MASK;
+		key_mask->vlan_id = VLAN_VID_MASK;
+	}
+	if (tb[vlan_prio_key]) {
+		key_val->vlan_priority =
+			nla_get_u8(tb[vlan_prio_key]) &
+			VLAN_PRIORITY_MASK;
+		key_mask->vlan_priority = VLAN_PRIORITY_MASK;
+	}
+	key_val->vlan_tpid = ethertype;
+	key_mask->vlan_tpid = cpu_to_be16(~0);
+}
+
+static void fl2_set_key_flag(u32 flower_key, u32 flower_mask,
+			    u32 *dissector_key, u32 *dissector_mask,
+			    u32 flower_flag_bit, u32 dissector_flag_bit)
+{
+	if (flower_mask & flower_flag_bit) {
+		*dissector_mask |= dissector_flag_bit;
+		if (flower_key & flower_flag_bit)
+			*dissector_key |= dissector_flag_bit;
+	}
+}
+
+static int fl2_set_key_flags(struct nlattr **tb, u32 *flags_key,
+			    u32 *flags_mask, struct netlink_ext_ack *extack)
+{
+	u32 key, mask;
+
+	/* mask is mandatory for flags */
+	if (!tb[TCA_FLOWER_KEY_FLAGS_MASK]) {
+		NL_SET_ERR_MSG(extack, "Missing flags mask");
+		return -EINVAL;
+	}
+
+	key = be32_to_cpu(nla_get_be32(tb[TCA_FLOWER_KEY_FLAGS]));
+	mask = be32_to_cpu(nla_get_be32(tb[TCA_FLOWER_KEY_FLAGS_MASK]));
+
+	*flags_key  = 0;
+	*flags_mask = 0;
+
+	fl2_set_key_flag(key, mask, flags_key, flags_mask,
+			TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT, FLOW_DIS_IS_FRAGMENT);
+	fl2_set_key_flag(key, mask, flags_key, flags_mask,
+			TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST,
+			FLOW_DIS_FIRST_FRAG);
+
+	return 0;
+}
+
+static void fl2_set_key_ip(struct nlattr **tb, bool encap,
+			  struct flow_dissector_key_ip *key,
+			  struct flow_dissector_key_ip *mask)
+{
+	int tos_key = encap ? TCA_FLOWER_KEY_ENC_IP_TOS : TCA_FLOWER_KEY_IP_TOS;
+	int ttl_key = encap ? TCA_FLOWER_KEY_ENC_IP_TTL : TCA_FLOWER_KEY_IP_TTL;
+	int tos_mask = encap ? TCA_FLOWER_KEY_ENC_IP_TOS_MASK : TCA_FLOWER_KEY_IP_TOS_MASK;
+	int ttl_mask = encap ? TCA_FLOWER_KEY_ENC_IP_TTL_MASK : TCA_FLOWER_KEY_IP_TTL_MASK;
+
+	fl2_set_key_val(tb, &key->tos, tos_key, &mask->tos, tos_mask, sizeof(key->tos));
+	fl2_set_key_val(tb, &key->ttl, ttl_key, &mask->ttl, ttl_mask, sizeof(key->ttl));
+}
+
+static int fl2_set_geneve_opt(const struct nlattr *nla, struct fl2_flow_key *key,
+			     int depth, int option_len,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX + 1];
+	struct nlattr *class = NULL, *type = NULL, *data = NULL;
+	struct geneve_opt *opt;
+	int err, data_len = 0;
+
+	if (option_len > sizeof(struct geneve_opt))
+		data_len = option_len - sizeof(struct geneve_opt);
+
+	opt = (struct geneve_opt *)&key->enc_opts.data[key->enc_opts.len];
+	memset(opt, 0xff, option_len);
+	opt->length = data_len / 4;
+	opt->r1 = 0;
+	opt->r2 = 0;
+	opt->r3 = 0;
+
+	/* If no mask has been prodived we assume an exact match. */
+	if (!depth)
+		return sizeof(struct geneve_opt) + data_len;
+
+	if (nla_type(nla) != TCA_FLOWER_KEY_ENC_OPTS_GENEVE) {
+		NL_SET_ERR_MSG(extack, "Non-geneve option type for mask");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested_deprecated(tb,
+					  TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX,
+					  nla, geneve_opt_policy, extack);
+	if (err < 0)
+		return err;
+
+	/* We are not allowed to omit any of CLASS, TYPE or DATA
+	 * fields from the key.
+	 */
+	if (!option_len &&
+	    (!tb[TCA_FLOWER_KEY_ENC_OPT_GENEVE_CLASS] ||
+	     !tb[TCA_FLOWER_KEY_ENC_OPT_GENEVE_TYPE] ||
+	     !tb[TCA_FLOWER_KEY_ENC_OPT_GENEVE_DATA])) {
+		NL_SET_ERR_MSG(extack, "Missing tunnel key geneve option class, type or data");
+		return -EINVAL;
+	}
+
+	/* Omitting any of CLASS, TYPE or DATA fields is allowed
+	 * for the mask.
+	 */
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_GENEVE_DATA]) {
+		int new_len = key->enc_opts.len;
+
+		data = tb[TCA_FLOWER_KEY_ENC_OPT_GENEVE_DATA];
+		data_len = nla_len(data);
+		if (data_len < 4) {
+			NL_SET_ERR_MSG(extack, "Tunnel key geneve option data is less than 4 bytes long");
+			return -ERANGE;
+		}
+		if (data_len % 4) {
+			NL_SET_ERR_MSG(extack, "Tunnel key geneve option data is not a multiple of 4 bytes long");
+			return -ERANGE;
+		}
+
+		new_len += sizeof(struct geneve_opt) + data_len;
+		BUILD_BUG_ON(FLOW_DIS_TUN_OPTS_MAX != IP_TUNNEL_OPTS_MAX);
+		if (new_len > FLOW_DIS_TUN_OPTS_MAX) {
+			NL_SET_ERR_MSG(extack, "Tunnel options exceeds max size");
+			return -ERANGE;
+		}
+		opt->length = data_len / 4;
+		memcpy(opt->opt_data, nla_data(data), data_len);
+	}
+
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_GENEVE_CLASS]) {
+		class = tb[TCA_FLOWER_KEY_ENC_OPT_GENEVE_CLASS];
+		opt->opt_class = nla_get_be16(class);
+	}
+
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_GENEVE_TYPE]) {
+		type = tb[TCA_FLOWER_KEY_ENC_OPT_GENEVE_TYPE];
+		opt->type = nla_get_u8(type);
+	}
+
+	return sizeof(struct geneve_opt) + data_len;
+}
+
+static int fl2_set_vxlan_opt(const struct nlattr *nla, struct fl2_flow_key *key,
+			    int depth, int option_len,
+			    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1];
+	struct vxlan_metadata *md;
+	int err;
+
+	md = (struct vxlan_metadata *)&key->enc_opts.data[key->enc_opts.len];
+	memset(md, 0xff, sizeof(*md));
+
+	if (!depth)
+		return sizeof(*md);
+
+	if (nla_type(nla) != TCA_FLOWER_KEY_ENC_OPTS_VXLAN) {
+		NL_SET_ERR_MSG(extack, "Non-vxlan option type for mask");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX, nla,
+			       vxlan_opt_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!option_len && !tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]) {
+		NL_SET_ERR_MSG(extack, "Missing tunnel key vxlan option gbp");
+		return -EINVAL;
+	}
+
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]) {
+		md->gbp = nla_get_u32(tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]);
+		md->gbp &= VXLAN_GBP_MASK;
+	}
+
+	return sizeof(*md);
+}
+
+static int fl2_set_erspan_opt(const struct nlattr *nla, struct fl2_flow_key *key,
+			     int depth, int option_len,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1];
+	struct erspan_metadata *md;
+	int err;
+
+	md = (struct erspan_metadata *)&key->enc_opts.data[key->enc_opts.len];
+	memset(md, 0xff, sizeof(*md));
+	md->version = 1;
+
+	if (!depth)
+		return sizeof(*md);
+
+	if (nla_type(nla) != TCA_FLOWER_KEY_ENC_OPTS_ERSPAN) {
+		NL_SET_ERR_MSG(extack, "Non-erspan option type for mask");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX, nla,
+			       erspan_opt_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!option_len && !tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]) {
+		NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option ver");
+		return -EINVAL;
+	}
+
+	if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER])
+		md->version = nla_get_u8(tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]);
+
+	if (md->version == 1) {
+		if (!option_len && !tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]) {
+			NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option index");
+			return -EINVAL;
+		}
+		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]) {
+			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX];
+			memset(&md->u, 0x00, sizeof(md->u));
+			md->u.index = nla_get_be32(nla);
+		}
+	} else if (md->version == 2) {
+		if (!option_len && (!tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR] ||
+				    !tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID])) {
+			NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option dir or hwid");
+			return -EINVAL;
+		}
+		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR]) {
+			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR];
+			md->u.md2.dir = nla_get_u8(nla);
+		}
+		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]) {
+			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID];
+			set_hwid(&md->u.md2, nla_get_u8(nla));
+		}
+	} else {
+		NL_SET_ERR_MSG(extack, "Tunnel key erspan option ver is incorrect");
+		return -EINVAL;
+	}
+
+	return sizeof(*md);
+}
+
+static int fl2_set_enc_opt(struct nlattr **tb, struct fl2_flow_key *key,
+			  struct fl2_flow_key *mask,
+			  struct netlink_ext_ack *extack)
+{
+	const struct nlattr *nla_enc_key, *nla_opt_key, *nla_opt_msk = NULL;
+	int err, option_len, key_depth, msk_depth = 0;
+
+	err = nla_validate_nested_deprecated(tb[TCA_FLOWER_KEY_ENC_OPTS],
+					     TCA_FLOWER_KEY_ENC_OPTS_MAX,
+					     enc_opts_policy, extack);
+	if (err)
+		return err;
+
+	nla_enc_key = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS]);
+
+	if (tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]) {
+		err = nla_validate_nested_deprecated(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK],
+						     TCA_FLOWER_KEY_ENC_OPTS_MAX,
+						     enc_opts_policy, extack);
+		if (err)
+			return err;
+
+		nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
+		msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
+		if (!nla_ok(nla_opt_msk, msk_depth)) {
+			NL_SET_ERR_MSG(extack, "Invalid nested attribute for masks");
+			return -EINVAL;
+		}
+	}
+
+	nla_for_each_attr(nla_opt_key, nla_enc_key,
+			  nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS]), key_depth) {
+		switch (nla_type(nla_opt_key)) {
+		case TCA_FLOWER_KEY_ENC_OPTS_GENEVE:
+			if (key->enc_opts.dst_opt_type &&
+			    key->enc_opts.dst_opt_type != TUNNEL_GENEVE_OPT) {
+				NL_SET_ERR_MSG(extack, "Duplicate type for geneve options");
+				return -EINVAL;
+			}
+			option_len = 0;
+			key->enc_opts.dst_opt_type = TUNNEL_GENEVE_OPT;
+			option_len = fl2_set_geneve_opt(nla_opt_key, key,
+						       key_depth, option_len,
+						       extack);
+			if (option_len < 0)
+				return option_len;
+
+			key->enc_opts.len += option_len;
+			/* At the same time we need to parse through the mask
+			 * in order to verify exact and mask attribute lengths.
+			 */
+			mask->enc_opts.dst_opt_type = TUNNEL_GENEVE_OPT;
+			option_len = fl2_set_geneve_opt(nla_opt_msk, mask,
+						       msk_depth, option_len,
+						       extack);
+			if (option_len < 0)
+				return option_len;
+
+			mask->enc_opts.len += option_len;
+			if (key->enc_opts.len != mask->enc_opts.len) {
+				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
+				return -EINVAL;
+			}
+			break;
+		case TCA_FLOWER_KEY_ENC_OPTS_VXLAN:
+			if (key->enc_opts.dst_opt_type) {
+				NL_SET_ERR_MSG(extack, "Duplicate type for vxlan options");
+				return -EINVAL;
+			}
+			option_len = 0;
+			key->enc_opts.dst_opt_type = TUNNEL_VXLAN_OPT;
+			option_len = fl2_set_vxlan_opt(nla_opt_key, key,
+						      key_depth, option_len,
+						      extack);
+			if (option_len < 0)
+				return option_len;
+
+			key->enc_opts.len += option_len;
+			/* At the same time we need to parse through the mask
+			 * in order to verify exact and mask attribute lengths.
+			 */
+			mask->enc_opts.dst_opt_type = TUNNEL_VXLAN_OPT;
+			option_len = fl2_set_vxlan_opt(nla_opt_msk, mask,
+						      msk_depth, option_len,
+						      extack);
+			if (option_len < 0)
+				return option_len;
+
+			mask->enc_opts.len += option_len;
+			if (key->enc_opts.len != mask->enc_opts.len) {
+				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
+				return -EINVAL;
+			}
+			break;
+		case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
+			if (key->enc_opts.dst_opt_type) {
+				NL_SET_ERR_MSG(extack, "Duplicate type for erspan options");
+				return -EINVAL;
+			}
+			option_len = 0;
+			key->enc_opts.dst_opt_type = TUNNEL_ERSPAN_OPT;
+			option_len = fl2_set_erspan_opt(nla_opt_key, key,
+						       key_depth, option_len,
+						       extack);
+			if (option_len < 0)
+				return option_len;
+
+			key->enc_opts.len += option_len;
+			/* At the same time we need to parse through the mask
+			 * in order to verify exact and mask attribute lengths.
+			 */
+			mask->enc_opts.dst_opt_type = TUNNEL_ERSPAN_OPT;
+			option_len = fl2_set_erspan_opt(nla_opt_msk, mask,
+						       msk_depth, option_len,
+						       extack);
+			if (option_len < 0)
+				return option_len;
+
+			mask->enc_opts.len += option_len;
+			if (key->enc_opts.len != mask->enc_opts.len) {
+				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
+				return -EINVAL;
+			}
+			break;
+		default:
+			NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
+			return -EINVAL;
+		}
+
+		if (!msk_depth)
+			continue;
+
+		if (!nla_ok(nla_opt_msk, msk_depth)) {
+			NL_SET_ERR_MSG(extack, "A mask attribute is invalid");
+			return -EINVAL;
+		}
+		nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
+	}
+
+	return 0;
+}
+
+static int fl2_validate_ct_state(u16 state, struct nlattr *tb,
+				struct netlink_ext_ack *extack)
+{
+	if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "no trk, so no other flag can be set");
+		return -EINVAL;
+	}
+
+	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "new and est are mutually exclusive");
+		return -EINVAL;
+	}
+
+	if (state & TCA_FLOWER_KEY_CT_FLAGS_INVALID &&
+	    state & ~(TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
+		      TCA_FLOWER_KEY_CT_FLAGS_INVALID)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "when inv is set, only trk may be set");
+		return -EINVAL;
+	}
+
+	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_REPLY) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "new and rpl are mutually exclusive");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int fl2_set_key_ct(struct nlattr **tb,
+			 struct flow_dissector_key_ct *key,
+			 struct flow_dissector_key_ct *mask,
+			 struct netlink_ext_ack *extack)
+{
+	if (tb[TCA_FLOWER_KEY_CT_STATE]) {
+		int err;
+
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK)) {
+			NL_SET_ERR_MSG(extack, "Conntrack isn't enabled");
+			return -EOPNOTSUPP;
+		}
+		fl2_set_key_val(tb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
+			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
+			       sizeof(key->ct_state));
+
+		err = fl2_validate_ct_state(key->ct_state & mask->ct_state,
+					   tb[TCA_FLOWER_KEY_CT_STATE_MASK],
+					   extack);
+		if (err)
+			return err;
+
+	}
+	if (tb[TCA_FLOWER_KEY_CT_ZONE]) {
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
+			NL_SET_ERR_MSG(extack, "Conntrack zones isn't enabled");
+			return -EOPNOTSUPP;
+		}
+		fl2_set_key_val(tb, &key->ct_zone, TCA_FLOWER_KEY_CT_ZONE,
+			       &mask->ct_zone, TCA_FLOWER_KEY_CT_ZONE_MASK,
+			       sizeof(key->ct_zone));
+	}
+	if (tb[TCA_FLOWER_KEY_CT_MARK]) {
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)) {
+			NL_SET_ERR_MSG(extack, "Conntrack mark isn't enabled");
+			return -EOPNOTSUPP;
+		}
+		fl2_set_key_val(tb, &key->ct_mark, TCA_FLOWER_KEY_CT_MARK,
+			       &mask->ct_mark, TCA_FLOWER_KEY_CT_MARK_MASK,
+			       sizeof(key->ct_mark));
+	}
+	if (tb[TCA_FLOWER_KEY_CT_LABELS]) {
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS)) {
+			NL_SET_ERR_MSG(extack, "Conntrack labels aren't enabled");
+			return -EOPNOTSUPP;
+		}
+		fl2_set_key_val(tb, key->ct_labels, TCA_FLOWER_KEY_CT_LABELS,
+			       mask->ct_labels, TCA_FLOWER_KEY_CT_LABELS_MASK,
+			       sizeof(key->ct_labels));
+	}
+
+	return 0;
+}
+
+static int fl2_set_key(struct net *net, struct nlattr **tb,
+		      struct fl2_flow_key *key, struct fl2_flow_key *mask,
+		      struct netlink_ext_ack *extack)
+{
+	__be16 ethertype;
+	int ret = 0;
+
+	if (tb[TCA_FLOWER_INDEV]) {
+		int err = tcf_change_indev(net, tb[TCA_FLOWER_INDEV], extack);
+		if (err < 0)
+			return err;
+		key->meta.ingress_ifindex = err;
+		mask->meta.ingress_ifindex = 0xffffffff;
+	}
+
+
+	fl2_set_key_val(tb, key->eth.dst, TCA_FLOWER_KEY_ETH_DST,
+		       mask->eth.dst, TCA_FLOWER_KEY_ETH_DST_MASK,
+		       sizeof(key->eth.dst));
+	fl2_set_key_val(tb, key->eth.src, TCA_FLOWER_KEY_ETH_SRC,
+		       mask->eth.src, TCA_FLOWER_KEY_ETH_SRC_MASK,
+		       sizeof(key->eth.src));
+
+	if (tb[TCA_FLOWER_KEY_ETH_TYPE]) {
+		ethertype = nla_get_be16(tb[TCA_FLOWER_KEY_ETH_TYPE]);
+
+		if (eth_type_vlan(ethertype)) {
+			fl2_set_key_vlan(tb, ethertype, TCA_FLOWER_KEY_VLAN_ID,
+					TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan,
+					&mask->vlan);
+
+			if (tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]) {
+				ethertype = nla_get_be16(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]);
+				if (eth_type_vlan(ethertype)) {
+					fl2_set_key_vlan(tb, ethertype,
+							TCA_FLOWER_KEY_CVLAN_ID,
+							TCA_FLOWER_KEY_CVLAN_PRIO,
+							&key->cvlan, &mask->cvlan);
+					fl2_set_key_val(tb, &key->basic.n_proto,
+						       TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
+						       &mask->basic.n_proto,
+						       TCA_FLOWER_UNSPEC,
+						       sizeof(key->basic.n_proto));
+				} else {
+					key->basic.n_proto = ethertype;
+					mask->basic.n_proto = cpu_to_be16(~0);
+				}
+			}
+		} else {
+			key->basic.n_proto = ethertype;
+			mask->basic.n_proto = cpu_to_be16(~0);
+		}
+	}
+
+	if (tb[TCA_FLOWER2_KEY_PPP_PROTO]){
+		fl2_set_key_val(tb, &key->ppp.ppp_proto, TCA_FLOWER2_KEY_PPP_PROTO,
+			       &mask->ppp.ppp_proto, TCA_FLOWER_UNSPEC,
+		    	   sizeof(key->ppp.ppp_proto));
+	}
+	if (key->basic.n_proto == htons(ETH_P_IP) ||
+	    key->basic.n_proto == htons(ETH_P_IPV6) ||
+		key->ppp.ppp_proto == htons(PPP_IP)		||
+		key->ppp.ppp_proto == htons(PPP_IPV6)
+		) {
+		fl2_set_key_val(tb, &key->basic.ip_proto, TCA_FLOWER_KEY_IP_PROTO,
+			       &mask->basic.ip_proto, TCA_FLOWER_UNSPEC,
+			       sizeof(key->basic.ip_proto));
+		fl2_set_key_ip(tb, false, &key->ip, &mask->ip);
+	}
+
+	if (tb[TCA_FLOWER_KEY_IPV4_SRC] || tb[TCA_FLOWER_KEY_IPV4_DST]) {
+		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		mask->control.addr_type = ~0;
+		fl2_set_key_val(tb, &key->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC,
+			       &mask->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC_MASK,
+			       sizeof(key->ipv4.src));
+		fl2_set_key_val(tb, &key->ipv4.dst, TCA_FLOWER_KEY_IPV4_DST,
+			       &mask->ipv4.dst, TCA_FLOWER_KEY_IPV4_DST_MASK,
+			       sizeof(key->ipv4.dst));
+	} else if (tb[TCA_FLOWER_KEY_IPV6_SRC] || tb[TCA_FLOWER_KEY_IPV6_DST]) {
+		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		mask->control.addr_type = ~0;
+		fl2_set_key_val(tb, &key->ipv6.src, TCA_FLOWER_KEY_IPV6_SRC,
+			       &mask->ipv6.src, TCA_FLOWER_KEY_IPV6_SRC_MASK,
+			       sizeof(key->ipv6.src));
+		fl2_set_key_val(tb, &key->ipv6.dst, TCA_FLOWER_KEY_IPV6_DST,
+			       &mask->ipv6.dst, TCA_FLOWER_KEY_IPV6_DST_MASK,
+			       sizeof(key->ipv6.dst));
+	}
+
+	if (key->basic.ip_proto == IPPROTO_TCP) {
+		fl2_set_key_val(tb, &key->tp.src, TCA_FLOWER_KEY_TCP_SRC,
+			       &mask->tp.src, TCA_FLOWER_KEY_TCP_SRC_MASK,
+			       sizeof(key->tp.src));
+		fl2_set_key_val(tb, &key->tp.dst, TCA_FLOWER_KEY_TCP_DST,
+			       &mask->tp.dst, TCA_FLOWER_KEY_TCP_DST_MASK,
+			       sizeof(key->tp.dst));
+		fl2_set_key_val(tb, &key->tcp.flags, TCA_FLOWER_KEY_TCP_FLAGS,
+			       &mask->tcp.flags, TCA_FLOWER_KEY_TCP_FLAGS_MASK,
+			       sizeof(key->tcp.flags));
+	} else if (key->basic.ip_proto == IPPROTO_UDP) {
+		fl2_set_key_val(tb, &key->tp.src, TCA_FLOWER_KEY_UDP_SRC,
+			       &mask->tp.src, TCA_FLOWER_KEY_UDP_SRC_MASK,
+			       sizeof(key->tp.src));
+		fl2_set_key_val(tb, &key->tp.dst, TCA_FLOWER_KEY_UDP_DST,
+			       &mask->tp.dst, TCA_FLOWER_KEY_UDP_DST_MASK,
+			       sizeof(key->tp.dst));
+	} else if (key->basic.ip_proto == IPPROTO_SCTP) {
+		fl2_set_key_val(tb, &key->tp.src, TCA_FLOWER_KEY_SCTP_SRC,
+			       &mask->tp.src, TCA_FLOWER_KEY_SCTP_SRC_MASK,
+			       sizeof(key->tp.src));
+		fl2_set_key_val(tb, &key->tp.dst, TCA_FLOWER_KEY_SCTP_DST,
+			       &mask->tp.dst, TCA_FLOWER_KEY_SCTP_DST_MASK,
+			       sizeof(key->tp.dst));
+	} else if (key->basic.n_proto == htons(ETH_P_IP) &&
+		   key->basic.ip_proto == IPPROTO_ICMP) {
+		fl2_set_key_val(tb, &key->icmp.type, TCA_FLOWER_KEY_ICMPV4_TYPE,
+			       &mask->icmp.type,
+			       TCA_FLOWER_KEY_ICMPV4_TYPE_MASK,
+			       sizeof(key->icmp.type));
+		fl2_set_key_val(tb, &key->icmp.code, TCA_FLOWER_KEY_ICMPV4_CODE,
+			       &mask->icmp.code,
+			       TCA_FLOWER_KEY_ICMPV4_CODE_MASK,
+			       sizeof(key->icmp.code));
+	} else if (key->basic.n_proto == htons(ETH_P_IPV6) &&
+		   key->basic.ip_proto == IPPROTO_ICMPV6) {
+		fl2_set_key_val(tb, &key->icmp.type, TCA_FLOWER_KEY_ICMPV6_TYPE,
+			       &mask->icmp.type,
+			       TCA_FLOWER_KEY_ICMPV6_TYPE_MASK,
+			       sizeof(key->icmp.type));
+		fl2_set_key_val(tb, &key->icmp.code, TCA_FLOWER_KEY_ICMPV6_CODE,
+			       &mask->icmp.code,
+			       TCA_FLOWER_KEY_ICMPV6_CODE_MASK,
+			       sizeof(key->icmp.code));
+	} else if (key->basic.n_proto == htons(ETH_P_MPLS_UC) ||
+		   key->basic.n_proto == htons(ETH_P_MPLS_MC)) {
+		ret = fl2_set_key_mpls(tb, &key->mpls, &mask->mpls, extack);
+		if (ret)
+			return ret;
+	} else if (key->basic.n_proto == htons(ETH_P_ARP) ||
+		   key->basic.n_proto == htons(ETH_P_RARP)) {
+		fl2_set_key_val(tb, &key->arp.sip, TCA_FLOWER_KEY_ARP_SIP,
+			       &mask->arp.sip, TCA_FLOWER_KEY_ARP_SIP_MASK,
+			       sizeof(key->arp.sip));
+		fl2_set_key_val(tb, &key->arp.tip, TCA_FLOWER_KEY_ARP_TIP,
+			       &mask->arp.tip, TCA_FLOWER_KEY_ARP_TIP_MASK,
+			       sizeof(key->arp.tip));
+		fl2_set_key_val(tb, &key->arp.op, TCA_FLOWER_KEY_ARP_OP,
+			       &mask->arp.op, TCA_FLOWER_KEY_ARP_OP_MASK,
+			       sizeof(key->arp.op));
+		fl2_set_key_val(tb, key->arp.sha, TCA_FLOWER_KEY_ARP_SHA,
+			       mask->arp.sha, TCA_FLOWER_KEY_ARP_SHA_MASK,
+			       sizeof(key->arp.sha));
+		fl2_set_key_val(tb, key->arp.tha, TCA_FLOWER_KEY_ARP_THA,
+			       mask->arp.tha, TCA_FLOWER_KEY_ARP_THA_MASK,
+			       sizeof(key->arp.tha));
+	}
+
+	if (key->basic.ip_proto == IPPROTO_TCP ||
+	    key->basic.ip_proto == IPPROTO_UDP ||
+	    key->basic.ip_proto == IPPROTO_SCTP) {
+		ret = fl2_set_key_port_range(tb, key, mask, extack);
+		if (ret)
+			return ret;
+	}
+
+	if (tb[TCA_FLOWER_KEY_ENC_IPV4_SRC] ||
+	    tb[TCA_FLOWER_KEY_ENC_IPV4_DST]) {
+		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		mask->enc_control.addr_type = ~0;
+		fl2_set_key_val(tb, &key->enc_ipv4.src,
+			       TCA_FLOWER_KEY_ENC_IPV4_SRC,
+			       &mask->enc_ipv4.src,
+			       TCA_FLOWER_KEY_ENC_IPV4_SRC_MASK,
+			       sizeof(key->enc_ipv4.src));
+		fl2_set_key_val(tb, &key->enc_ipv4.dst,
+			       TCA_FLOWER_KEY_ENC_IPV4_DST,
+			       &mask->enc_ipv4.dst,
+			       TCA_FLOWER_KEY_ENC_IPV4_DST_MASK,
+			       sizeof(key->enc_ipv4.dst));
+	}
+
+	if (tb[TCA_FLOWER_KEY_ENC_IPV6_SRC] ||
+	    tb[TCA_FLOWER_KEY_ENC_IPV6_DST]) {
+		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		mask->enc_control.addr_type = ~0;
+		fl2_set_key_val(tb, &key->enc_ipv6.src,
+			       TCA_FLOWER_KEY_ENC_IPV6_SRC,
+			       &mask->enc_ipv6.src,
+			       TCA_FLOWER_KEY_ENC_IPV6_SRC_MASK,
+			       sizeof(key->enc_ipv6.src));
+		fl2_set_key_val(tb, &key->enc_ipv6.dst,
+			       TCA_FLOWER_KEY_ENC_IPV6_DST,
+			       &mask->enc_ipv6.dst,
+			       TCA_FLOWER_KEY_ENC_IPV6_DST_MASK,
+			       sizeof(key->enc_ipv6.dst));
+	}
+
+	fl2_set_key_val(tb, &key->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID,
+		       &mask->enc_key_id.keyid, TCA_FLOWER_UNSPEC,
+		       sizeof(key->enc_key_id.keyid));
+
+	fl2_set_key_val(tb, &key->enc_tp.src, TCA_FLOWER_KEY_ENC_UDP_SRC_PORT,
+		       &mask->enc_tp.src, TCA_FLOWER_KEY_ENC_UDP_SRC_PORT_MASK,
+		       sizeof(key->enc_tp.src));
+
+	fl2_set_key_val(tb, &key->enc_tp.dst, TCA_FLOWER_KEY_ENC_UDP_DST_PORT,
+		       &mask->enc_tp.dst, TCA_FLOWER_KEY_ENC_UDP_DST_PORT_MASK,
+		       sizeof(key->enc_tp.dst));
+
+	fl2_set_key_ip(tb, true, &key->enc_ip, &mask->enc_ip);
+
+	fl2_set_key_val(tb, &key->hash.hash, TCA_FLOWER_KEY_HASH,
+		       &mask->hash.hash, TCA_FLOWER_KEY_HASH_MASK,
+		       sizeof(key->hash.hash));
+	if (tb[TCA_FLOWER_KEY_ENC_OPTS]) {
+		ret = fl2_set_enc_opt(tb, key, mask, extack);
+		if (ret)
+			return ret;
+	}
+
+	ret = fl2_set_key_ct(tb, &key->ct, &mask->ct, extack);
+	if (ret)
+		return ret;
+
+	if (tb[TCA_FLOWER_KEY_FLAGS])
+		ret = fl2_set_key_flags(tb, &key->control.flags,
+				       &mask->control.flags, extack);
+
+	return ret;
+}
+
+static void fl2_mask_copy(struct fl2_flow_mask *dst,
+			 struct fl2_flow_mask *src)
+{
+	const void *psrc = fl2_key_get_start(&src->key, src);
+	void *pdst = fl2_key_get_start(&dst->key, src);
+
+	memcpy(pdst, psrc, fl2_mask_range(src));
+	dst->range = src->range;
+}
+
+static const struct rhashtable_params fl2_ht_params = {
+	.key_offset = offsetof(struct cls_fl2_filter, mkey), /* base offset */
+	.head_offset = offsetof(struct cls_fl2_filter, ht_node),
+	.automatic_shrinking = true,
+};
+
+static int fl2_init_mask_hashtable(struct fl2_flow_mask *mask)
+{
+	mask->filter_ht_params = fl2_ht_params;
+	mask->filter_ht_params.key_len = fl2_mask_range(mask);
+	mask->filter_ht_params.key_offset += mask->range.start;
+
+	return rhashtable_init(&mask->ht, &mask->filter_ht_params);
+}
+
+#define FL2_KEY_MEMBER_OFFSET(member) offsetof(struct fl2_flow_key, member)
+#define FL2_KEY_MEMBER_SIZE(member) sizeof_field(struct fl2_flow_key, member)
+
+#define FL2_KEY_IS_MASKED(mask, member)						\
+	memchr_inv(((char *)mask) + FL2_KEY_MEMBER_OFFSET(member),		\
+		   0, FL2_KEY_MEMBER_SIZE(member))				\
+
+#define FL2_KEY_SET(keys, cnt, id, member)					\
+	do {									\
+		keys[cnt].key_id = id;						\
+		keys[cnt].offset = FL2_KEY_MEMBER_OFFSET(member);		\
+		cnt++;								\
+	} while(0);
+
+#define FL2_KEY_SET_IF_MASKED(mask, keys, cnt, id, member)			\
+	do {									\
+		if (FL2_KEY_IS_MASKED(mask, member))				\
+			FL2_KEY_SET(keys, cnt, id, member);			\
+	} while(0);
+
+static void fl2_init_dissector(struct flow_dissector *dissector,
+			      struct fl2_flow_key *mask)
+{
+	struct flow_dissector_key keys[FLOW_DISSECTOR_KEY_MAX];
+	size_t cnt = 0;
+
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_META, meta);
+	FL2_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_CONTROL, control);
+	FL2_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_BASIC, basic);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ETH_ADDRS, eth);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_PORTS, tp);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_PORTS_RANGE, tp_range);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_IP, ip);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_TCP, tcp);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ICMP, icmp);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ARP, arp);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_MPLS, mpls);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_VLAN, vlan);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_CVLAN, cvlan);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ENC_KEYID, enc_key_id);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, enc_ipv4);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS, enc_ipv6);
+	if (FL2_KEY_IS_MASKED(mask, enc_ipv4) ||
+	    FL2_KEY_IS_MASKED(mask, enc_ipv6))
+		FL2_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_CONTROL,
+			   enc_control);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ENC_PORTS, enc_tp);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ENC_IP, enc_ip);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ENC_OPTS, enc_opts);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_CT, ct);
+	FL2_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_HASH, hash);
+
+	skb_flow_dissector_init(dissector, keys, cnt);
+}
+
+static struct fl2_flow_mask *fl2_create_new_mask(struct cls_fl2_head *head,
+					       struct fl2_flow_mask *mask)
+{
+	struct fl2_flow_mask *newmask;
+	int err;
+
+	newmask = kzalloc(sizeof(*newmask), GFP_KERNEL);
+	if (!newmask)
+		return ERR_PTR(-ENOMEM);
+
+	fl2_mask_copy(newmask, mask);
+
+	if ((newmask->key.tp_range.tp_min.dst &&
+	     newmask->key.tp_range.tp_max.dst) ||
+	    (newmask->key.tp_range.tp_min.src &&
+	     newmask->key.tp_range.tp_max.src))
+		newmask->flags |= TCA_FLOWER_MASK_FLAGS_RANGE;
+
+	err = fl2_init_mask_hashtable(newmask);
+	if (err)
+		goto errout_free;
+
+	fl2_init_dissector(&newmask->dissector, &newmask->key);
+
+	INIT_LIST_HEAD_RCU(&newmask->filters);
+
+	refcount_set(&newmask->refcnt, 1);
+	err = rhashtable_replace_fast(&head->ht, &mask->ht_node,
+				      &newmask->ht_node, mask_ht_params);
+	if (err)
+		goto errout_destroy;
+
+	spin_lock(&head->masks_lock);
+	list_add_tail_rcu(&newmask->list, &head->masks);
+	spin_unlock(&head->masks_lock);
+
+	return newmask;
+
+errout_destroy:
+	rhashtable_destroy(&newmask->ht);
+errout_free:
+	kfree(newmask);
+
+	return ERR_PTR(err);
+}
+
+static int fl2_check_assign_mask(struct cls_fl2_head *head,
+				struct cls_fl2_filter *fnew,
+				struct cls_fl2_filter *fold,
+				struct fl2_flow_mask *mask)
+{
+	struct fl2_flow_mask *newmask;
+	int ret = 0;
+
+	rcu_read_lock();
+
+	/* Insert mask as temporary node to prevent concurrent creation of mask
+	 * with same key. Any concurrent lookups with same key will return
+	 * -EAGAIN because mask's refcnt is zero.
+	 */
+	fnew->mask = rhashtable_lookup_get_insert_fast(&head->ht,
+						       &mask->ht_node,
+						       mask_ht_params);
+	if (!fnew->mask) {
+		rcu_read_unlock();
+
+		if (fold) {
+			ret = -EINVAL;
+			goto errout_cleanup;
+		}
+
+		newmask = fl2_create_new_mask(head, mask);
+		if (IS_ERR(newmask)) {
+			ret = PTR_ERR(newmask);
+			goto errout_cleanup;
+		}
+
+		fnew->mask = newmask;
+		return 0;
+	} else if (IS_ERR(fnew->mask)) {
+		ret = PTR_ERR(fnew->mask);
+	} else if (fold && fold->mask != fnew->mask) {
+		ret = -EINVAL;
+	} else if (!refcount_inc_not_zero(&fnew->mask->refcnt)) {
+		/* Mask was deleted concurrently, try again */
+		ret = -EAGAIN;
+	}
+	rcu_read_unlock();
+	return ret;
+
+errout_cleanup:
+	rhashtable_remove_fast(&head->ht, &mask->ht_node,
+			       mask_ht_params);
+	return ret;
+}
+
+static int fl2_set_parms(struct net *net, struct tcf_proto *tp,
+			struct cls_fl2_filter *f, struct fl2_flow_mask *mask,
+			unsigned long base, struct nlattr **tb,
+			struct nlattr *est,
+			struct fl2_flow_tmplt *tmplt, u32 flags,
+			struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = tcf_exts_validate(net, tp, tb, est, &f->exts, flags, extack);
+	if (err < 0)
+		return err;
+
+	if (tb[TCA_FLOWER_CLASSID]) {
+		f->res.classid = nla_get_u32(tb[TCA_FLOWER_CLASSID]);
+		if (flags & TCA_ACT_FLAGS_NO_RTNL)
+			rtnl_lock();
+		tcf_bind_filter(tp, &f->res, base);
+		if (flags & TCA_ACT_FLAGS_NO_RTNL)
+			rtnl_unlock();
+	}
+
+	err = fl2_set_key(net, tb, &f->key, &mask->key, extack);
+	if (err)
+		return err;
+
+	fl2_mask_update_range(mask);
+	fl2_set_masked_key(&f->mkey, &f->key, mask);
+
+	if (!fl2_mask_fits_tmplt(tmplt, mask)) {
+		NL_SET_ERR_MSG_MOD(extack, "Mask does not fit the template");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int fl2_ht_insert_unique(struct cls_fl2_filter *fnew,
+			       struct cls_fl2_filter *fold,
+			       bool *in_ht)
+{
+	struct fl2_flow_mask *mask = fnew->mask;
+	int err;
+
+	err = rhashtable_lookup_insert_fast(&mask->ht,
+					    &fnew->ht_node,
+					    mask->filter_ht_params);
+	if (err) {
+		*in_ht = false;
+		/* It is okay if filter with same key exists when
+		 * overwriting.
+		 */
+		return fold && err == -EEXIST ? 0 : err;
+	}
+
+	*in_ht = true;
+	return 0;
+}
+
+static int fl2_change(struct net *net, struct sk_buff *in_skb,
+		      struct tcf_proto *tp, unsigned long base,
+		      u32 handle, struct nlattr **tca,
+		      void **arg, u32 flags,
+		      struct netlink_ext_ack *extack)
+{
+	struct cls_fl2_head *head = fl2_head_dereference(tp);
+	bool rtnl_held = !(flags & TCA_ACT_FLAGS_NO_RTNL);
+	struct cls_fl2_filter *fold = *arg;
+	struct cls_fl2_filter *fnew;
+	struct fl2_flow_mask *mask;
+	struct nlattr **tb;
+	bool in_ht;
+	int err;
+
+	if (!tca[TCA_OPTIONS]) {
+		err = -EINVAL;
+		goto errout_fold;
+	}
+
+	mask = kzalloc(sizeof(struct fl2_flow_mask), GFP_KERNEL);
+	if (!mask) {
+		err = -ENOBUFS;
+		goto errout_fold;
+	}
+
+	tb = kcalloc(TCA_FLOWER2_MAX + 1, sizeof(struct nlattr *), GFP_KERNEL);
+	if (!tb) {
+		err = -ENOBUFS;
+		goto errout_mask_alloc;
+	}
+
+	err = nla_parse_nested_deprecated(tb, TCA_FLOWER2_MAX,
+					  tca[TCA_OPTIONS], fl2_policy, NULL);
+	if (err < 0)
+		goto errout_tb;
+
+	if (fold && handle && fold->handle != handle) {
+		err = -EINVAL;
+		goto errout_tb;
+	}
+
+	fnew = kzalloc(sizeof(*fnew), GFP_KERNEL);
+	if (!fnew) {
+		err = -ENOBUFS;
+		goto errout_tb;
+	}
+	INIT_LIST_HEAD(&fnew->hw_list);
+	refcount_set(&fnew->refcnt, 1);
+
+	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	if (err < 0)
+		goto errout;
+
+	if (tb[TCA_FLOWER_FLAGS]) {
+		fnew->flags = nla_get_u32(tb[TCA_FLOWER_FLAGS]);
+
+		if (!tc_flags_valid(fnew->flags)) {
+			err = -EINVAL;
+			goto errout;
+		}
+	}
+
+	err = fl2_set_parms(net, tp, fnew, mask, base, tb, tca[TCA_RATE],
+			   tp->chain->tmplt_priv, flags, extack);
+	if (err)
+		goto errout;
+
+	err = fl2_check_assign_mask(head, fnew, fold, mask);
+	if (err)
+		goto errout;
+
+	err = fl2_ht_insert_unique(fnew, fold, &in_ht);
+	if (err)
+		goto errout_mask;
+
+	if (!tc_skip_hw(fnew->flags)) {
+		err = fl2_hw_replace_filter(tp, fnew, rtnl_held, extack);
+		if (err)
+			goto errout_ht;
+	}
+
+	if (!tc_in_hw(fnew->flags))
+		fnew->flags |= TCA_CLS_FLAGS_NOT_IN_HW;
+
+	spin_lock(&tp->lock);
+
+	/* tp was deleted concurrently. -EAGAIN will cause caller to lookup
+	 * proto again or create new one, if necessary.
+	 */
+	if (tp->deleting) {
+		err = -EAGAIN;
+		goto errout_hw;
+	}
+
+	if (fold) {
+		/* Fold filter was deleted concurrently. Retry lookup. */
+		if (fold->deleted) {
+			err = -EAGAIN;
+			goto errout_hw;
+		}
+
+		fnew->handle = handle;
+
+		if (!in_ht) {
+			struct rhashtable_params params =
+				fnew->mask->filter_ht_params;
+
+			err = rhashtable_insert_fast(&fnew->mask->ht,
+						     &fnew->ht_node,
+						     params);
+			if (err)
+				goto errout_hw;
+			in_ht = true;
+		}
+
+		refcount_inc(&fnew->refcnt);
+		rhashtable_remove_fast(&fold->mask->ht,
+				       &fold->ht_node,
+				       fold->mask->filter_ht_params);
+		idr_replace(&head->handle_idr, fnew, fnew->handle);
+		list_replace_rcu(&fold->list, &fnew->list);
+		fold->deleted = true;
+
+		spin_unlock(&tp->lock);
+
+		fl2_mask_put(head, fold->mask);
+		if (!tc_skip_hw(fold->flags))
+			fl2_hw_destroy_filter(tp, fold, rtnl_held, NULL);
+		tcf_unbind_filter(tp, &fold->res);
+		/* Caller holds reference to fold, so refcnt is always > 0
+		 * after this.
+		 */
+		refcount_dec(&fold->refcnt);
+		__fl2_put(fold);
+	} else {
+		if (handle) {
+			/* user specifies a handle and it doesn't exist */
+			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
+					    handle, GFP_ATOMIC);
+
+			/* Filter with specified handle was concurrently
+			 * inserted after initial check in cls_api. This is not
+			 * necessarily an error if NLM_F_EXCL is not set in
+			 * message flags. Returning EAGAIN will cause cls_api to
+			 * try to update concurrently inserted rule.
+			 */
+			if (err == -ENOSPC)
+				err = -EAGAIN;
+		} else {
+			handle = 1;
+			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
+					    INT_MAX, GFP_ATOMIC);
+		}
+		if (err)
+			goto errout_hw;
+
+		refcount_inc(&fnew->refcnt);
+		fnew->handle = handle;
+		list_add_tail_rcu(&fnew->list, &fnew->mask->filters);
+		spin_unlock(&tp->lock);
+	}
+
+	*arg = fnew;
+
+	kfree(tb);
+	tcf_queue_work(&mask->rwork, fl2_uninit_mask_free_work);
+	return 0;
+
+errout_ht:
+	spin_lock(&tp->lock);
+errout_hw:
+	fnew->deleted = true;
+	spin_unlock(&tp->lock);
+	if (!tc_skip_hw(fnew->flags))
+		fl2_hw_destroy_filter(tp, fnew, rtnl_held, NULL);
+	if (in_ht)
+		rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
+				       fnew->mask->filter_ht_params);
+errout_mask:
+	fl2_mask_put(head, fnew->mask);
+errout:
+	__fl2_put(fnew);
+errout_tb:
+	kfree(tb);
+errout_mask_alloc:
+	tcf_queue_work(&mask->rwork, fl2_uninit_mask_free_work);
+errout_fold:
+	if (fold)
+		__fl2_put(fold);
+	return err;
+}
+
+static int fl2_delete(struct tcf_proto *tp, void *arg, bool *last,
+		     bool rtnl_held, struct netlink_ext_ack *extack)
+{
+	struct cls_fl2_head *head = fl2_head_dereference(tp);
+	struct cls_fl2_filter *f = arg;
+	bool last_on_mask;
+	int err = 0;
+
+	err = __fl2_delete(tp, f, &last_on_mask, rtnl_held, extack);
+	*last = list_empty(&head->masks);
+	__fl2_put(f);
+
+	return err;
+}
+
+static void fl2_walk(struct tcf_proto *tp, struct tcf_walker *arg,
+		    bool rtnl_held)
+{
+	struct cls_fl2_head *head = fl2_head_dereference(tp);
+	unsigned long id = arg->cookie, tmp;
+	struct cls_fl2_filter *f;
+
+	arg->count = arg->skip;
+
+	idr_for_each_entry_continue_ul(&head->handle_idr, f, tmp, id) {
+		/* don't return filters that are being deleted */
+		if (!refcount_inc_not_zero(&f->refcnt))
+			continue;
+		if (arg->fn(tp, f, arg) < 0) {
+			__fl2_put(f);
+			arg->stop = 1;
+			break;
+		}
+		__fl2_put(f);
+		arg->count++;
+	}
+	arg->cookie = id;
+}
+
+static struct cls_fl2_filter *
+fl2_get_next_hw_filter(struct tcf_proto *tp, struct cls_fl2_filter *f, bool add)
+{
+	struct cls_fl2_head *head = fl2_head_dereference(tp);
+
+	spin_lock(&tp->lock);
+	if (list_empty(&head->hw_filters)) {
+		spin_unlock(&tp->lock);
+		return NULL;
+	}
+
+	if (!f)
+		f = list_entry(&head->hw_filters, struct cls_fl2_filter,
+			       hw_list);
+	list_for_each_entry_continue(f, &head->hw_filters, hw_list) {
+		if (!(add && f->deleted) && refcount_inc_not_zero(&f->refcnt)) {
+			spin_unlock(&tp->lock);
+			return f;
+		}
+	}
+
+	spin_unlock(&tp->lock);
+	return NULL;
+}
+
+static int fl2_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
+			void *cb_priv, struct netlink_ext_ack *extack)
+{
+	struct tcf_block *block = tp->chain->block;
+	struct flow_cls_offload cls_flower = {};
+	struct cls_fl2_filter *f = NULL;
+	int err;
+
+	/* hw_filters list can only be changed by hw offload functions after
+	 * obtaining rtnl lock. Make sure it is not changed while reoffload is
+	 * iterating it.
+	 */
+	ASSERT_RTNL();
+
+	while ((f = fl2_get_next_hw_filter(tp, f, add))) {
+		cls_flower.rule =
+			flow_rule_alloc(tcf_exts_num_actions(&f->exts));
+		if (!cls_flower.rule) {
+			__fl2_put(f);
+			return -ENOMEM;
+		}
+
+		tc_cls_common_offload_init(&cls_flower.common, tp, f->flags,
+					   extack);
+		cls_flower.command = add ?
+			FLOW_CLS_REPLACE : FLOW_CLS_DESTROY;
+		cls_flower.cookie = (unsigned long)f;
+		cls_flower.rule->match.dissector = &f->mask->dissector;
+		cls_flower.rule->match.mask = &f->mask->key;
+		cls_flower.rule->match.key = &f->mkey;
+
+		err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+		if (err) {
+			kfree(cls_flower.rule);
+			if (tc_skip_sw(f->flags)) {
+				NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
+				__fl2_put(f);
+				return err;
+			}
+			goto next_flow;
+		}
+
+		cls_flower.classid = f->res.classid;
+
+		err = tc_setup_cb_reoffload(block, tp, add, cb,
+					    TC_SETUP_CLSFLOWER, &cls_flower,
+					    cb_priv, &f->flags,
+					    &f->in_hw_count);
+		tc_cleanup_flow_action(&cls_flower.rule->action);
+		kfree(cls_flower.rule);
+
+		if (err) {
+			__fl2_put(f);
+			return err;
+		}
+next_flow:
+		__fl2_put(f);
+	}
+
+	return 0;
+}
+
+static void fl2_hw_add(struct tcf_proto *tp, void *type_data)
+{
+	struct flow_cls_offload *cls_flower = type_data;
+	struct cls_fl2_filter *f =
+		(struct cls_fl2_filter *) cls_flower->cookie;
+	struct cls_fl2_head *head = fl2_head_dereference(tp);
+
+	spin_lock(&tp->lock);
+	list_add(&f->hw_list, &head->hw_filters);
+	spin_unlock(&tp->lock);
+}
+
+static void fl2_hw_del(struct tcf_proto *tp, void *type_data)
+{
+	struct flow_cls_offload *cls_flower = type_data;
+	struct cls_fl2_filter *f =
+		(struct cls_fl2_filter *) cls_flower->cookie;
+
+	spin_lock(&tp->lock);
+	if (!list_empty(&f->hw_list))
+		list_del_init(&f->hw_list);
+	spin_unlock(&tp->lock);
+}
+
+static int fl2_hw_create_tmplt(struct tcf_chain *chain,
+			      struct fl2_flow_tmplt *tmplt)
+{
+	struct flow_cls_offload cls_flower = {};
+	struct tcf_block *block = chain->block;
+
+	cls_flower.rule = flow_rule_alloc(0);
+	if (!cls_flower.rule)
+		return -ENOMEM;
+
+	cls_flower.common.chain_index = chain->index;
+	cls_flower.command = FLOW_CLS_TMPLT_CREATE;
+	cls_flower.cookie = (unsigned long) tmplt;
+	cls_flower.rule->match.dissector = &tmplt->dissector;
+	cls_flower.rule->match.mask = &tmplt->mask;
+	cls_flower.rule->match.key = &tmplt->dummy_key;
+
+	/* We don't care if driver (any of them) fails to handle this
+	 * call. It serves just as a hint for it.
+	 */
+	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false, true);
+	kfree(cls_flower.rule);
+
+	return 0;
+}
+
+static void fl2_hw_destroy_tmplt(struct tcf_chain *chain,
+				struct fl2_flow_tmplt *tmplt)
+{
+	struct flow_cls_offload cls_flower = {};
+	struct tcf_block *block = chain->block;
+
+	cls_flower.common.chain_index = chain->index;
+	cls_flower.command = FLOW_CLS_TMPLT_DESTROY;
+	cls_flower.cookie = (unsigned long) tmplt;
+
+	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false, true);
+}
+
+static void *fl2_tmplt_create(struct net *net, struct tcf_chain *chain,
+			     struct nlattr **tca,
+			     struct netlink_ext_ack *extack)
+{
+	struct fl2_flow_tmplt *tmplt;
+	struct nlattr **tb;
+	int err;
+
+	if (!tca[TCA_OPTIONS])
+		return ERR_PTR(-EINVAL);
+
+	tb = kcalloc(TCA_FLOWER2_MAX + 1, sizeof(struct nlattr *), GFP_KERNEL);
+	if (!tb)
+		return ERR_PTR(-ENOBUFS);
+	err = nla_parse_nested_deprecated(tb, TCA_FLOWER2_MAX,
+					  tca[TCA_OPTIONS], fl2_policy, NULL);
+	if (err)
+		goto errout_tb;
+
+	tmplt = kzalloc(sizeof(*tmplt), GFP_KERNEL);
+	if (!tmplt) {
+		err = -ENOMEM;
+		goto errout_tb;
+	}
+	tmplt->chain = chain;
+	err = fl2_set_key(net, tb, &tmplt->dummy_key, &tmplt->mask, extack);
+	if (err)
+		goto errout_tmplt;
+
+	fl2_init_dissector(&tmplt->dissector, &tmplt->mask);
+
+	err = fl2_hw_create_tmplt(chain, tmplt);
+	if (err)
+		goto errout_tmplt;
+
+	kfree(tb);
+	return tmplt;
+
+errout_tmplt:
+	kfree(tmplt);
+errout_tb:
+	kfree(tb);
+	return ERR_PTR(err);
+}
+
+static void fl2_tmplt_destroy(void *tmplt_priv)
+{
+	struct fl2_flow_tmplt *tmplt = tmplt_priv;
+
+	fl2_hw_destroy_tmplt(tmplt->chain, tmplt);
+	kfree(tmplt);
+}
+
+static int fl2_dump_key_val(struct sk_buff *skb,
+			   void *val, int val_type,
+			   void *mask, int mask_type, int len)
+{
+	int err;
+
+	if (!memchr_inv(mask, 0, len))
+		return 0;
+	err = nla_put(skb, val_type, len, val);
+	if (err)
+		return err;
+	if (mask_type != TCA_FLOWER_UNSPEC) {
+		err = nla_put(skb, mask_type, len, mask);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static int fl2_dump_key_port_range(struct sk_buff *skb, struct fl2_flow_key *key,
+				  struct fl2_flow_key *mask)
+{
+	if (fl2_dump_key_val(skb, &key->tp_range.tp_min.dst,
+			    TCA_FLOWER_KEY_PORT_DST_MIN,
+			    &mask->tp_range.tp_min.dst, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_min.dst)) ||
+	    fl2_dump_key_val(skb, &key->tp_range.tp_max.dst,
+			    TCA_FLOWER_KEY_PORT_DST_MAX,
+			    &mask->tp_range.tp_max.dst, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_max.dst)) ||
+	    fl2_dump_key_val(skb, &key->tp_range.tp_min.src,
+			    TCA_FLOWER_KEY_PORT_SRC_MIN,
+			    &mask->tp_range.tp_min.src, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_min.src)) ||
+	    fl2_dump_key_val(skb, &key->tp_range.tp_max.src,
+			    TCA_FLOWER_KEY_PORT_SRC_MAX,
+			    &mask->tp_range.tp_max.src, TCA_FLOWER_UNSPEC,
+			    sizeof(key->tp_range.tp_max.src)))
+		return -1;
+
+	return 0;
+}
+
+static int fl2_dump_key_mpls_opt_lse(struct sk_buff *skb,
+				    struct flow_dissector_key_mpls *mpls_key,
+				    struct flow_dissector_key_mpls *mpls_mask,
+				    u8 lse_index)
+{
+	struct flow_dissector_mpls_lse *lse_mask = &mpls_mask->ls[lse_index];
+	struct flow_dissector_mpls_lse *lse_key = &mpls_key->ls[lse_index];
+	int err;
+
+	err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH,
+			 lse_index + 1);
+	if (err)
+		return err;
+
+	if (lse_mask->mpls_ttl) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL,
+				 lse_key->mpls_ttl);
+		if (err)
+			return err;
+	}
+	if (lse_mask->mpls_bos) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS,
+				 lse_key->mpls_bos);
+		if (err)
+			return err;
+	}
+	if (lse_mask->mpls_tc) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_TC,
+				 lse_key->mpls_tc);
+		if (err)
+			return err;
+	}
+	if (lse_mask->mpls_label) {
+		err = nla_put_u32(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL,
+				  lse_key->mpls_label);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int fl2_dump_key_mpls_opts(struct sk_buff *skb,
+				 struct flow_dissector_key_mpls *mpls_key,
+				 struct flow_dissector_key_mpls *mpls_mask)
+{
+	struct nlattr *opts;
+	struct nlattr *lse;
+	u8 lse_index;
+	int err;
+
+	opts = nla_nest_start(skb, TCA_FLOWER_KEY_MPLS_OPTS);
+	if (!opts)
+		return -EMSGSIZE;
+
+	for (lse_index = 0; lse_index < FLOW_DIS_MPLS_MAX; lse_index++) {
+		if (!(mpls_mask->used_lses & 1 << lse_index))
+			continue;
+
+		lse = nla_nest_start(skb, TCA_FLOWER_KEY_MPLS_OPTS_LSE);
+		if (!lse) {
+			err = -EMSGSIZE;
+			goto err_opts;
+		}
+
+		err = fl2_dump_key_mpls_opt_lse(skb, mpls_key, mpls_mask,
+					       lse_index);
+		if (err)
+			goto err_opts_lse;
+		nla_nest_end(skb, lse);
+	}
+	nla_nest_end(skb, opts);
+
+	return 0;
+
+err_opts_lse:
+	nla_nest_cancel(skb, lse);
+err_opts:
+	nla_nest_cancel(skb, opts);
+
+	return err;
+}
+
+static int fl2_dump_key_mpls(struct sk_buff *skb,
+			    struct flow_dissector_key_mpls *mpls_key,
+			    struct flow_dissector_key_mpls *mpls_mask)
+{
+	struct flow_dissector_mpls_lse *lse_mask;
+	struct flow_dissector_mpls_lse *lse_key;
+	int err;
+
+	if (!mpls_mask->used_lses)
+		return 0;
+
+	lse_mask = &mpls_mask->ls[0];
+	lse_key = &mpls_key->ls[0];
+
+	/* For backward compatibility, don't use the MPLS nested attributes if
+	 * the rule can be expressed using the old attributes.
+	 */
+	if (mpls_mask->used_lses & ~1 ||
+	    (!lse_mask->mpls_ttl && !lse_mask->mpls_bos &&
+	     !lse_mask->mpls_tc && !lse_mask->mpls_label))
+		return fl2_dump_key_mpls_opts(skb, mpls_key, mpls_mask);
+
+	if (lse_mask->mpls_ttl) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_TTL,
+				 lse_key->mpls_ttl);
+		if (err)
+			return err;
+	}
+	if (lse_mask->mpls_tc) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_TC,
+				 lse_key->mpls_tc);
+		if (err)
+			return err;
+	}
+	if (lse_mask->mpls_label) {
+		err = nla_put_u32(skb, TCA_FLOWER_KEY_MPLS_LABEL,
+				  lse_key->mpls_label);
+		if (err)
+			return err;
+	}
+	if (lse_mask->mpls_bos) {
+		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_BOS,
+				 lse_key->mpls_bos);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static int fl2_dump_key_ip(struct sk_buff *skb, bool encap,
+			  struct flow_dissector_key_ip *key,
+			  struct flow_dissector_key_ip *mask)
+{
+	int tos_key = encap ? TCA_FLOWER_KEY_ENC_IP_TOS : TCA_FLOWER_KEY_IP_TOS;
+	int ttl_key = encap ? TCA_FLOWER_KEY_ENC_IP_TTL : TCA_FLOWER_KEY_IP_TTL;
+	int tos_mask = encap ? TCA_FLOWER_KEY_ENC_IP_TOS_MASK : TCA_FLOWER_KEY_IP_TOS_MASK;
+	int ttl_mask = encap ? TCA_FLOWER_KEY_ENC_IP_TTL_MASK : TCA_FLOWER_KEY_IP_TTL_MASK;
+
+	if (fl2_dump_key_val(skb, &key->tos, tos_key, &mask->tos, tos_mask, sizeof(key->tos)) ||
+	    fl2_dump_key_val(skb, &key->ttl, ttl_key, &mask->ttl, ttl_mask, sizeof(key->ttl)))
+		return -1;
+
+	return 0;
+}
+
+static int fl2_dump_key_vlan(struct sk_buff *skb,
+			    int vlan_id_key, int vlan_prio_key,
+			    struct flow_dissector_key_vlan *vlan_key,
+			    struct flow_dissector_key_vlan *vlan_mask)
+{
+	int err;
+
+	if (!memchr_inv(vlan_mask, 0, sizeof(*vlan_mask)))
+		return 0;
+	if (vlan_mask->vlan_id) {
+		err = nla_put_u16(skb, vlan_id_key,
+				  vlan_key->vlan_id);
+		if (err)
+			return err;
+	}
+	if (vlan_mask->vlan_priority) {
+		err = nla_put_u8(skb, vlan_prio_key,
+				 vlan_key->vlan_priority);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static void fl2_get_key_flag(u32 dissector_key, u32 dissector_mask,
+			    u32 *flower_key, u32 *flower_mask,
+			    u32 flower_flag_bit, u32 dissector_flag_bit)
+{
+	if (dissector_mask & dissector_flag_bit) {
+		*flower_mask |= flower_flag_bit;
+		if (dissector_key & dissector_flag_bit)
+			*flower_key |= flower_flag_bit;
+	}
+}
+
+static int fl2_dump_key_flags(struct sk_buff *skb, u32 flags_key, u32 flags_mask)
+{
+	u32 key, mask;
+	__be32 _key, _mask;
+	int err;
+
+	if (!memchr_inv(&flags_mask, 0, sizeof(flags_mask)))
+		return 0;
+
+	key = 0;
+	mask = 0;
+
+	fl2_get_key_flag(flags_key, flags_mask, &key, &mask,
+			TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT, FLOW_DIS_IS_FRAGMENT);
+	fl2_get_key_flag(flags_key, flags_mask, &key, &mask,
+			TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST,
+			FLOW_DIS_FIRST_FRAG);
+
+	_key = cpu_to_be32(key);
+	_mask = cpu_to_be32(mask);
+
+	err = nla_put(skb, TCA_FLOWER_KEY_FLAGS, 4, &_key);
+	if (err)
+		return err;
+
+	return nla_put(skb, TCA_FLOWER_KEY_FLAGS_MASK, 4, &_mask);
+}
+
+static int fl2_dump_key_geneve_opt(struct sk_buff *skb,
+				  struct flow_dissector_key_enc_opts *enc_opts)
+{
+	struct geneve_opt *opt;
+	struct nlattr *nest;
+	int opt_off = 0;
+
+	nest = nla_nest_start_noflag(skb, TCA_FLOWER_KEY_ENC_OPTS_GENEVE);
+	if (!nest)
+		goto nla_put_failure;
+
+	while (enc_opts->len > opt_off) {
+		opt = (struct geneve_opt *)&enc_opts->data[opt_off];
+
+		if (nla_put_be16(skb, TCA_FLOWER_KEY_ENC_OPT_GENEVE_CLASS,
+				 opt->opt_class))
+			goto nla_put_failure;
+		if (nla_put_u8(skb, TCA_FLOWER_KEY_ENC_OPT_GENEVE_TYPE,
+			       opt->type))
+			goto nla_put_failure;
+		if (nla_put(skb, TCA_FLOWER_KEY_ENC_OPT_GENEVE_DATA,
+			    opt->length * 4, opt->opt_data))
+			goto nla_put_failure;
+
+		opt_off += sizeof(struct geneve_opt) + opt->length * 4;
+	}
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int fl2_dump_key_vxlan_opt(struct sk_buff *skb,
+				 struct flow_dissector_key_enc_opts *enc_opts)
+{
+	struct vxlan_metadata *md;
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, TCA_FLOWER_KEY_ENC_OPTS_VXLAN);
+	if (!nest)
+		goto nla_put_failure;
+
+	md = (struct vxlan_metadata *)&enc_opts->data[0];
+	if (nla_put_u32(skb, TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP, md->gbp))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int fl2_dump_key_erspan_opt(struct sk_buff *skb,
+				  struct flow_dissector_key_enc_opts *enc_opts)
+{
+	struct erspan_metadata *md;
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, TCA_FLOWER_KEY_ENC_OPTS_ERSPAN);
+	if (!nest)
+		goto nla_put_failure;
+
+	md = (struct erspan_metadata *)&enc_opts->data[0];
+	if (nla_put_u8(skb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER, md->version))
+		goto nla_put_failure;
+
+	if (md->version == 1 &&
+	    nla_put_be32(skb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX, md->u.index))
+		goto nla_put_failure;
+
+	if (md->version == 2 &&
+	    (nla_put_u8(skb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR,
+			md->u.md2.dir) ||
+	     nla_put_u8(skb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID,
+			get_hwid(&md->u.md2))))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int fl2_dump_key_ct(struct sk_buff *skb,
+			  struct flow_dissector_key_ct *key,
+			  struct flow_dissector_key_ct *mask)
+{
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK) &&
+	    fl2_dump_key_val(skb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
+			    &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
+			    sizeof(key->ct_state)))
+		goto nla_put_failure;
+
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES) &&
+	    fl2_dump_key_val(skb, &key->ct_zone, TCA_FLOWER_KEY_CT_ZONE,
+			    &mask->ct_zone, TCA_FLOWER_KEY_CT_ZONE_MASK,
+			    sizeof(key->ct_zone)))
+		goto nla_put_failure;
+
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK_MARK) &&
+	    fl2_dump_key_val(skb, &key->ct_mark, TCA_FLOWER_KEY_CT_MARK,
+			    &mask->ct_mark, TCA_FLOWER_KEY_CT_MARK_MASK,
+			    sizeof(key->ct_mark)))
+		goto nla_put_failure;
+
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
+	    fl2_dump_key_val(skb, &key->ct_labels, TCA_FLOWER_KEY_CT_LABELS,
+			    &mask->ct_labels, TCA_FLOWER_KEY_CT_LABELS_MASK,
+			    sizeof(key->ct_labels)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int fl2_dump_key_options(struct sk_buff *skb, int enc_opt_type,
+			       struct flow_dissector_key_enc_opts *enc_opts)
+{
+	struct nlattr *nest;
+	int err;
+
+	if (!enc_opts->len)
+		return 0;
+
+	nest = nla_nest_start_noflag(skb, enc_opt_type);
+	if (!nest)
+		goto nla_put_failure;
+
+	switch (enc_opts->dst_opt_type) {
+	case TUNNEL_GENEVE_OPT:
+		err = fl2_dump_key_geneve_opt(skb, enc_opts);
+		if (err)
+			goto nla_put_failure;
+		break;
+	case TUNNEL_VXLAN_OPT:
+		err = fl2_dump_key_vxlan_opt(skb, enc_opts);
+		if (err)
+			goto nla_put_failure;
+		break;
+	case TUNNEL_ERSPAN_OPT:
+		err = fl2_dump_key_erspan_opt(skb, enc_opts);
+		if (err)
+			goto nla_put_failure;
+		break;
+	default:
+		goto nla_put_failure;
+	}
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int fl2_dump_key_enc_opt(struct sk_buff *skb,
+			       struct flow_dissector_key_enc_opts *key_opts,
+			       struct flow_dissector_key_enc_opts *msk_opts)
+{
+	int err;
+
+	err = fl2_dump_key_options(skb, TCA_FLOWER_KEY_ENC_OPTS, key_opts);
+	if (err)
+		return err;
+
+	return fl2_dump_key_options(skb, TCA_FLOWER_KEY_ENC_OPTS_MASK, msk_opts);
+}
+
+static int fl2_dump_key(struct sk_buff *skb, struct net *net,
+		       struct fl2_flow_key *key, struct fl2_flow_key *mask)
+{
+	if (mask->meta.ingress_ifindex) {
+		struct net_device *dev;
+
+		dev = __dev_get_by_index(net, key->meta.ingress_ifindex);
+		if (dev && nla_put_string(skb, TCA_FLOWER_INDEV, dev->name))
+			goto nla_put_failure;
+	}
+	if (fl2_dump_key_val(skb, &key->ppp.ppp_proto, TCA_FLOWER2_KEY_PPP_PROTO,
+			    &mask->ppp.ppp_proto, TCA_FLOWER_UNSPEC,
+			    sizeof(key->ppp.ppp_proto)))
+		goto nla_put_failure;
+	if (fl2_dump_key_val(skb, key->eth.dst, TCA_FLOWER_KEY_ETH_DST,
+			    mask->eth.dst, TCA_FLOWER_KEY_ETH_DST_MASK,
+			    sizeof(key->eth.dst)) ||
+	    fl2_dump_key_val(skb, key->eth.src, TCA_FLOWER_KEY_ETH_SRC,
+			    mask->eth.src, TCA_FLOWER_KEY_ETH_SRC_MASK,
+			    sizeof(key->eth.src)) ||
+	    fl2_dump_key_val(skb, &key->basic.n_proto, TCA_FLOWER_KEY_ETH_TYPE,
+			    &mask->basic.n_proto, TCA_FLOWER_UNSPEC,
+			    sizeof(key->basic.n_proto)))
+		goto nla_put_failure;
+
+	if (fl2_dump_key_mpls(skb, &key->mpls, &mask->mpls))
+		goto nla_put_failure;
+
+	if (fl2_dump_key_vlan(skb, TCA_FLOWER_KEY_VLAN_ID,
+			     TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan, &mask->vlan))
+		goto nla_put_failure;
+
+	if (fl2_dump_key_vlan(skb, TCA_FLOWER_KEY_CVLAN_ID,
+			     TCA_FLOWER_KEY_CVLAN_PRIO,
+			     &key->cvlan, &mask->cvlan) ||
+	    (mask->cvlan.vlan_tpid &&
+	     nla_put_be16(skb, TCA_FLOWER_KEY_VLAN_ETH_TYPE,
+			  key->cvlan.vlan_tpid)))
+		goto nla_put_failure;
+
+	if (mask->basic.n_proto) {
+		if (mask->cvlan.vlan_tpid) {
+			if (nla_put_be16(skb, TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
+					 key->basic.n_proto))
+				goto nla_put_failure;
+		} else if (mask->vlan.vlan_tpid) {
+			if (nla_put_be16(skb, TCA_FLOWER_KEY_VLAN_ETH_TYPE,
+					 key->basic.n_proto))
+				goto nla_put_failure;
+		}
+	}
+
+	if ((key->basic.n_proto == htons(ETH_P_IP) ||
+	     key->basic.n_proto == htons(ETH_P_IPV6) ||
+	     key->ppp.ppp_proto == htons(PPP_IP)	||
+	     key->ppp.ppp_proto == htons(PPP_IPV6)) &&
+	    (fl2_dump_key_val(skb, &key->basic.ip_proto, TCA_FLOWER_KEY_IP_PROTO,
+			    &mask->basic.ip_proto, TCA_FLOWER_UNSPEC,
+			    sizeof(key->basic.ip_proto)) ||
+	    fl2_dump_key_ip(skb, false, &key->ip, &mask->ip)))
+		goto nla_put_failure;
+
+	if (key->control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS &&
+	    (fl2_dump_key_val(skb, &key->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC,
+			     &mask->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC_MASK,
+			     sizeof(key->ipv4.src)) ||
+	     fl2_dump_key_val(skb, &key->ipv4.dst, TCA_FLOWER_KEY_IPV4_DST,
+			     &mask->ipv4.dst, TCA_FLOWER_KEY_IPV4_DST_MASK,
+			     sizeof(key->ipv4.dst))))
+		goto nla_put_failure;
+	else if (key->control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS &&
+		 (fl2_dump_key_val(skb, &key->ipv6.src, TCA_FLOWER_KEY_IPV6_SRC,
+				  &mask->ipv6.src, TCA_FLOWER_KEY_IPV6_SRC_MASK,
+				  sizeof(key->ipv6.src)) ||
+		  fl2_dump_key_val(skb, &key->ipv6.dst, TCA_FLOWER_KEY_IPV6_DST,
+				  &mask->ipv6.dst, TCA_FLOWER_KEY_IPV6_DST_MASK,
+				  sizeof(key->ipv6.dst))))
+		goto nla_put_failure;
+
+	if (key->basic.ip_proto == IPPROTO_TCP &&
+	    (fl2_dump_key_val(skb, &key->tp.src, TCA_FLOWER_KEY_TCP_SRC,
+			     &mask->tp.src, TCA_FLOWER_KEY_TCP_SRC_MASK,
+			     sizeof(key->tp.src)) ||
+	     fl2_dump_key_val(skb, &key->tp.dst, TCA_FLOWER_KEY_TCP_DST,
+			     &mask->tp.dst, TCA_FLOWER_KEY_TCP_DST_MASK,
+			     sizeof(key->tp.dst)) ||
+	     fl2_dump_key_val(skb, &key->tcp.flags, TCA_FLOWER_KEY_TCP_FLAGS,
+			     &mask->tcp.flags, TCA_FLOWER_KEY_TCP_FLAGS_MASK,
+			     sizeof(key->tcp.flags))))
+		goto nla_put_failure;
+	else if (key->basic.ip_proto == IPPROTO_UDP &&
+		 (fl2_dump_key_val(skb, &key->tp.src, TCA_FLOWER_KEY_UDP_SRC,
+				  &mask->tp.src, TCA_FLOWER_KEY_UDP_SRC_MASK,
+				  sizeof(key->tp.src)) ||
+		  fl2_dump_key_val(skb, &key->tp.dst, TCA_FLOWER_KEY_UDP_DST,
+				  &mask->tp.dst, TCA_FLOWER_KEY_UDP_DST_MASK,
+				  sizeof(key->tp.dst))))
+		goto nla_put_failure;
+	else if (key->basic.ip_proto == IPPROTO_SCTP &&
+		 (fl2_dump_key_val(skb, &key->tp.src, TCA_FLOWER_KEY_SCTP_SRC,
+				  &mask->tp.src, TCA_FLOWER_KEY_SCTP_SRC_MASK,
+				  sizeof(key->tp.src)) ||
+		  fl2_dump_key_val(skb, &key->tp.dst, TCA_FLOWER_KEY_SCTP_DST,
+				  &mask->tp.dst, TCA_FLOWER_KEY_SCTP_DST_MASK,
+				  sizeof(key->tp.dst))))
+		goto nla_put_failure;
+	else if (key->basic.n_proto == htons(ETH_P_IP) &&
+		 key->basic.ip_proto == IPPROTO_ICMP &&
+		 (fl2_dump_key_val(skb, &key->icmp.type,
+				  TCA_FLOWER_KEY_ICMPV4_TYPE, &mask->icmp.type,
+				  TCA_FLOWER_KEY_ICMPV4_TYPE_MASK,
+				  sizeof(key->icmp.type)) ||
+		  fl2_dump_key_val(skb, &key->icmp.code,
+				  TCA_FLOWER_KEY_ICMPV4_CODE, &mask->icmp.code,
+				  TCA_FLOWER_KEY_ICMPV4_CODE_MASK,
+				  sizeof(key->icmp.code))))
+		goto nla_put_failure;
+	else if (key->basic.n_proto == htons(ETH_P_IPV6) &&
+		 key->basic.ip_proto == IPPROTO_ICMPV6 &&
+		 (fl2_dump_key_val(skb, &key->icmp.type,
+				  TCA_FLOWER_KEY_ICMPV6_TYPE, &mask->icmp.type,
+				  TCA_FLOWER_KEY_ICMPV6_TYPE_MASK,
+				  sizeof(key->icmp.type)) ||
+		  fl2_dump_key_val(skb, &key->icmp.code,
+				  TCA_FLOWER_KEY_ICMPV6_CODE, &mask->icmp.code,
+				  TCA_FLOWER_KEY_ICMPV6_CODE_MASK,
+				  sizeof(key->icmp.code))))
+		goto nla_put_failure;
+	else if ((key->basic.n_proto == htons(ETH_P_ARP) ||
+		  key->basic.n_proto == htons(ETH_P_RARP)) &&
+		 (fl2_dump_key_val(skb, &key->arp.sip,
+				  TCA_FLOWER_KEY_ARP_SIP, &mask->arp.sip,
+				  TCA_FLOWER_KEY_ARP_SIP_MASK,
+				  sizeof(key->arp.sip)) ||
+		  fl2_dump_key_val(skb, &key->arp.tip,
+				  TCA_FLOWER_KEY_ARP_TIP, &mask->arp.tip,
+				  TCA_FLOWER_KEY_ARP_TIP_MASK,
+				  sizeof(key->arp.tip)) ||
+		  fl2_dump_key_val(skb, &key->arp.op,
+				  TCA_FLOWER_KEY_ARP_OP, &mask->arp.op,
+				  TCA_FLOWER_KEY_ARP_OP_MASK,
+				  sizeof(key->arp.op)) ||
+		  fl2_dump_key_val(skb, key->arp.sha, TCA_FLOWER_KEY_ARP_SHA,
+				  mask->arp.sha, TCA_FLOWER_KEY_ARP_SHA_MASK,
+				  sizeof(key->arp.sha)) ||
+		  fl2_dump_key_val(skb, key->arp.tha, TCA_FLOWER_KEY_ARP_THA,
+				  mask->arp.tha, TCA_FLOWER_KEY_ARP_THA_MASK,
+				  sizeof(key->arp.tha))))
+		goto nla_put_failure;
+
+	if ((key->basic.ip_proto == IPPROTO_TCP ||
+	     key->basic.ip_proto == IPPROTO_UDP ||
+	     key->basic.ip_proto == IPPROTO_SCTP) &&
+	     fl2_dump_key_port_range(skb, key, mask))
+		goto nla_put_failure;
+
+	if (key->enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS &&
+	    (fl2_dump_key_val(skb, &key->enc_ipv4.src,
+			    TCA_FLOWER_KEY_ENC_IPV4_SRC, &mask->enc_ipv4.src,
+			    TCA_FLOWER_KEY_ENC_IPV4_SRC_MASK,
+			    sizeof(key->enc_ipv4.src)) ||
+	     fl2_dump_key_val(skb, &key->enc_ipv4.dst,
+			     TCA_FLOWER_KEY_ENC_IPV4_DST, &mask->enc_ipv4.dst,
+			     TCA_FLOWER_KEY_ENC_IPV4_DST_MASK,
+			     sizeof(key->enc_ipv4.dst))))
+		goto nla_put_failure;
+	else if (key->enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS &&
+		 (fl2_dump_key_val(skb, &key->enc_ipv6.src,
+			    TCA_FLOWER_KEY_ENC_IPV6_SRC, &mask->enc_ipv6.src,
+			    TCA_FLOWER_KEY_ENC_IPV6_SRC_MASK,
+			    sizeof(key->enc_ipv6.src)) ||
+		 fl2_dump_key_val(skb, &key->enc_ipv6.dst,
+				 TCA_FLOWER_KEY_ENC_IPV6_DST,
+				 &mask->enc_ipv6.dst,
+				 TCA_FLOWER_KEY_ENC_IPV6_DST_MASK,
+			    sizeof(key->enc_ipv6.dst))))
+		goto nla_put_failure;
+
+	if (fl2_dump_key_val(skb, &key->enc_key_id, TCA_FLOWER_KEY_ENC_KEY_ID,
+			    &mask->enc_key_id, TCA_FLOWER_UNSPEC,
+			    sizeof(key->enc_key_id)) ||
+	    fl2_dump_key_val(skb, &key->enc_tp.src,
+			    TCA_FLOWER_KEY_ENC_UDP_SRC_PORT,
+			    &mask->enc_tp.src,
+			    TCA_FLOWER_KEY_ENC_UDP_SRC_PORT_MASK,
+			    sizeof(key->enc_tp.src)) ||
+	    fl2_dump_key_val(skb, &key->enc_tp.dst,
+			    TCA_FLOWER_KEY_ENC_UDP_DST_PORT,
+			    &mask->enc_tp.dst,
+			    TCA_FLOWER_KEY_ENC_UDP_DST_PORT_MASK,
+			    sizeof(key->enc_tp.dst)) ||
+	    fl2_dump_key_ip(skb, true, &key->enc_ip, &mask->enc_ip) ||
+	    fl2_dump_key_enc_opt(skb, &key->enc_opts, &mask->enc_opts))
+		goto nla_put_failure;
+
+	if (fl2_dump_key_ct(skb, &key->ct, &mask->ct))
+		goto nla_put_failure;
+
+	if (fl2_dump_key_flags(skb, key->control.flags, mask->control.flags))
+		goto nla_put_failure;
+
+	if (fl2_dump_key_val(skb, &key->hash.hash, TCA_FLOWER_KEY_HASH,
+			     &mask->hash.hash, TCA_FLOWER_KEY_HASH_MASK,
+			     sizeof(key->hash.hash)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int fl2_dump(struct net *net, struct tcf_proto *tp, void *fh,
+		   struct sk_buff *skb, struct tcmsg *t, bool rtnl_held)
+{
+	struct cls_fl2_filter *f = fh;
+	struct nlattr *nest;
+	struct fl2_flow_key *key, *mask;
+	bool skip_hw;
+
+	if (!f)
+		return skb->len;
+
+	t->tcm_handle = f->handle;
+
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
+	if (!nest)
+		goto nla_put_failure;
+
+	spin_lock(&tp->lock);
+
+	if (f->res.classid &&
+	    nla_put_u32(skb, TCA_FLOWER_CLASSID, f->res.classid))
+		goto nla_put_failure_locked;
+
+	key = &f->key;
+	mask = &f->mask->key;
+	skip_hw = tc_skip_hw(f->flags);
+
+	if (fl2_dump_key(skb, net, key, mask))
+		goto nla_put_failure_locked;
+
+	if (f->flags && nla_put_u32(skb, TCA_FLOWER_FLAGS, f->flags))
+		goto nla_put_failure_locked;
+
+	spin_unlock(&tp->lock);
+
+	if (!skip_hw)
+		fl2_hw_update_stats(tp, f, rtnl_held);
+
+	if (nla_put_u32(skb, TCA_FLOWER_IN_HW_COUNT, f->in_hw_count))
+		goto nla_put_failure;
+
+	if (tcf_exts_dump(skb, &f->exts))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+
+	if (tcf_exts_dump_stats(skb, &f->exts) < 0)
+		goto nla_put_failure;
+
+	return skb->len;
+
+nla_put_failure_locked:
+	spin_unlock(&tp->lock);
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -1;
+}
+
+static int fl2_terse_dump(struct net *net, struct tcf_proto *tp, void *fh,
+			 struct sk_buff *skb, struct tcmsg *t, bool rtnl_held)
+{
+	struct cls_fl2_filter *f = fh;
+	struct nlattr *nest;
+	bool skip_hw;
+
+	if (!f)
+		return skb->len;
+
+	t->tcm_handle = f->handle;
+
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
+	if (!nest)
+		goto nla_put_failure;
+
+	spin_lock(&tp->lock);
+
+	skip_hw = tc_skip_hw(f->flags);
+
+	if (f->flags && nla_put_u32(skb, TCA_FLOWER_FLAGS, f->flags))
+		goto nla_put_failure_locked;
+
+	spin_unlock(&tp->lock);
+
+	if (!skip_hw)
+		fl2_hw_update_stats(tp, f, rtnl_held);
+
+	if (tcf_exts_terse_dump(skb, &f->exts))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+
+	return skb->len;
+
+nla_put_failure_locked:
+	spin_unlock(&tp->lock);
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -1;
+}
+
+static int fl2_tmplt_dump(struct sk_buff *skb, struct net *net, void *tmplt_priv)
+{
+	struct fl2_flow_tmplt *tmplt = tmplt_priv;
+	struct fl2_flow_key *key, *mask;
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
+	if (!nest)
+		goto nla_put_failure;
+
+	key = &tmplt->dummy_key;
+	mask = &tmplt->mask;
+
+	if (fl2_dump_key(skb, net, key, mask))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+
+	return skb->len;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static void fl2_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			  unsigned long base)
+{
+	struct cls_fl2_filter *f = fh;
+
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
+}
+
+static bool fl2_delete_empty(struct tcf_proto *tp)
+{
+	struct cls_fl2_head *head = fl2_head_dereference(tp);
+
+	spin_lock(&tp->lock);
+	tp->deleting = idr_is_empty(&head->handle_idr);
+	spin_unlock(&tp->lock);
+
+	return tp->deleting;
+}
+
+static struct tcf_proto_ops cls_fl2_ops __read_mostly = {
+	.kind		= "flower2",
+	.classify	= fl2_classify,
+	.init		= fl2_init,
+	.destroy	= fl2_destroy,
+	.get		= fl2_get,
+	.put		= fl2_put,
+	.change		= fl2_change,
+	.delete		= fl2_delete,
+	.delete_empty	= fl2_delete_empty,
+	.walk		= fl2_walk,
+	.reoffload	= fl2_reoffload,
+	.hw_add		= fl2_hw_add,
+	.hw_del		= fl2_hw_del,
+	.dump		= fl2_dump,
+	.terse_dump	= fl2_terse_dump,
+	.bind_class	= fl2_bind_class,
+	.tmplt_create	= fl2_tmplt_create,
+	.tmplt_destroy	= fl2_tmplt_destroy,
+	.tmplt_dump	= fl2_tmplt_dump,
+	.owner		= THIS_MODULE,
+	.flags		= TCF_PROTO_OPS_DOIT_UNLOCKED,
+};
+
+static int __init cls_fl2_init(void)
+{
+	return register_tcf_proto_ops(&cls_fl2_ops);
+}
+
+static void __exit cls_fl2_exit(void)
+{
+	unregister_tcf_proto_ops(&cls_fl2_ops);
+}
+
+module_init(cls_fl2_init);
+module_exit(cls_fl2_exit);
+
+MODULE_AUTHOR("Jiri Pirko <jiri@resnulli.us>\nFelipe Magno de Almeida <felipe@sipanda.io>");
+MODULE_DESCRIPTION("Flower2 classifier based on PANDA parser");
+MODULE_LICENSE("GPL v2");
diff --git a/net/sched/cls_flower2_panda_noopt.c b/net/sched/cls_flower2_panda_noopt.c
new file mode 100644
index 000000000000..b5c5f61db668
--- /dev/null
+++ b/net/sched/cls_flower2_panda_noopt.c
@@ -0,0 +1,305 @@
+// SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+/*
+ * Copyright (c) 2020, 2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <net/panda/parser.h>
+#include <net/panda/parser_metadata.h>
+#include <net/panda/proto_nodes_def.h>
+
+/* PANDA Big Parser
+ *
+ * Implement flow dissector in PANDA. A protocol parse graph is created and
+ * metadata is extracted at various nodes.
+ */
+struct flow_dissector_key_ppp {
+	__be16 ppp_proto;
+};
+
+struct fl2_flow_key {
+	struct flow_dissector_key_meta meta;
+	struct flow_dissector_key_control control;
+	struct flow_dissector_key_control enc_control;
+	struct flow_dissector_key_basic basic;
+	struct flow_dissector_key_eth_addrs eth;
+	struct flow_dissector_key_vlan vlan;
+	struct flow_dissector_key_vlan cvlan;
+	union {
+		struct flow_dissector_key_ipv4_addrs ipv4;
+		struct flow_dissector_key_ipv6_addrs ipv6;
+	};
+	struct flow_dissector_key_ports tp;
+	struct flow_dissector_key_icmp icmp;
+	struct flow_dissector_key_arp arp;
+	struct flow_dissector_key_keyid enc_key_id;
+	union {
+		struct flow_dissector_key_ipv4_addrs enc_ipv4;
+		struct flow_dissector_key_ipv6_addrs enc_ipv6;
+	};
+	struct flow_dissector_key_ports enc_tp;
+	struct flow_dissector_key_mpls mpls;
+	struct flow_dissector_key_tcp tcp;
+	struct flow_dissector_key_ip ip;
+	struct flow_dissector_key_ip enc_ip;
+	struct flow_dissector_key_enc_opts enc_opts;
+	union {
+		struct flow_dissector_key_ports tp;
+		struct {
+			struct flow_dissector_key_ports tp_min;
+			struct flow_dissector_key_ports tp_max;
+		};
+	} tp_range;
+	struct flow_dissector_key_ct ct;
+	struct flow_dissector_key_hash hash;
+	struct flow_dissector_key_ppp ppp;
+} __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
+
+
+/* Meta data structure for just one frame */
+struct panda_parser_big_metadata_one {
+	struct panda_metadata panda_data;
+	struct fl2_flow_key frame;
+};
+
+/* Meta data functions for parser nodes. Use the canned templates
+ * for common metadata
+ */
+static void ether_metadata(const void *veth, void *iframe, struct panda_ctrl_data ctrl)
+{
+	struct fl2_flow_key *frame = iframe;
+
+	frame->basic.n_proto = ((struct ethhdr *)veth)->h_proto;
+	memcpy(&frame->eth, &((struct ethhdr *)veth)->h_dest,
+	       sizeof(frame->eth));
+}
+
+static void ipv4_metadata(const void *viph, void *iframe, struct panda_ctrl_data ctrl)
+{
+	struct fl2_flow_key *frame = iframe;
+	const struct iphdr *iph = viph;
+
+	frame->basic.ip_proto = iph->protocol;
+	
+	if (frame->vlan.vlan_id != 0 && frame->vlan.vlan_id != 1) {
+		frame->enc_control.addr_type = FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS;
+		memcpy(&frame->enc_ipv4.src, &iph->saddr,
+		       sizeof(frame->ipv4));
+	}
+	frame->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+	memcpy(&frame->ipv4.src, &iph->saddr,
+	       sizeof(frame->ipv4));
+}
+
+static void ipv6_metadata(const void *viph, void *iframe, struct panda_ctrl_data ctrl)
+{
+	struct fl2_flow_key *frame = iframe;
+	const struct ipv6hdr *iph = viph;
+
+	frame->basic.ip_proto = iph->nexthdr;
+
+	frame->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+	memcpy(&frame->ipv6.src, &iph->saddr,
+	       sizeof(frame->ipv6));
+
+}
+
+static void ppp_metadata(const void *vppph, void *iframe, struct panda_ctrl_data ctrl)
+{
+	struct fl2_flow_key *frame = iframe;
+	//ppp protocol can have 8 or 16 bits
+	frame->ppp.ppp_proto = __cpu_to_be16(
+		ctrl.hdr_len == sizeof(struct pppoe_hdr_proto8) ? 
+		((struct pppoe_hdr_proto8*)vppph)->protocol : 
+		((struct pppoe_hdr_proto16*)vppph)->protocol
+		);
+		
+}
+
+static void ports_metadata(const void *vphdr, void *iframe,			
+		 struct panda_ctrl_data ctrl)				
+{									
+	struct fl2_flow_key *frame = iframe;
+	frame->tp.ports = ((struct port_hdr *)vphdr)->ports;
+}
+
+static void arp_rarp_metadata(const void *vearp, void *iframe, struct panda_ctrl_data ctrl)
+{
+	
+	struct fl2_flow_key *frame = iframe;
+	const struct earphdr *earp = vearp;
+
+	frame->arp.op = ntohs(earp->arp.ar_op) & 0xff;
+
+	/* Record Ethernet addresses */
+	memcpy(frame->arp.sha, earp->ar_sha, ETH_ALEN);
+	memcpy(frame->arp.tha, earp->ar_tha, ETH_ALEN);
+
+	/* Record IP addresses */
+	memcpy(&frame->arp.sip, &earp->ar_sip, sizeof(frame->arp.sip));
+	memcpy(&frame->arp.tip, &earp->ar_tip, sizeof(frame->arp.tip));
+}
+
+static void icmp_metadata(const void *vicmp, void *iframe, struct panda_ctrl_data ctrl)
+{
+	struct fl2_flow_key *frame = iframe;
+	const struct icmphdr *icmp = vicmp;
+
+	frame->icmp.type = icmp->type;
+	frame->icmp.code = icmp->code;
+	if (icmp_has_id(icmp->type))
+		frame->icmp.id = icmp->un.echo.id ? : 1;
+	else
+		frame->icmp.id = 0;
+}
+
+static void e8021Q_metadata(const void *vvlan, void *iframe,
+		 struct panda_ctrl_data ctrl)
+{
+	struct fl2_flow_key *frame = iframe;
+	const struct vlan_hdr *vlan = vvlan;
+
+	frame->vlan.vlan_id = ntohs(vlan->h_vlan_TCI) &
+				VLAN_VID_MASK;
+	frame->vlan.vlan_priority = (ntohs(vlan->h_vlan_TCI) &
+				VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	frame->vlan.vlan_tpid = ETH_P_8021Q;
+}
+
+static void e8021AD_metadata(const void *vvlan, void *iframe,
+		 struct panda_ctrl_data ctrl)
+{
+	struct fl2_flow_key *frame = iframe;
+	const struct vlan_hdr *vlan = vvlan;
+
+	frame->vlan.vlan_id = ntohs(vlan->h_vlan_TCI) &
+				VLAN_VID_MASK;
+	frame->vlan.vlan_priority = (ntohs(vlan->h_vlan_TCI) &
+				VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	frame->vlan.vlan_tpid = ETH_P_8021AD;
+}
+
+/* Parse nodes. Parse nodes are composed of the common PANDA Parser protocol
+ * nodes, metadata functions defined above, and protocol tables defined
+ * below
+ */
+PANDA_MAKE_PARSE_NODE(ether_node, panda_parse_ether, ether_metadata,
+		      NULL, ether_table);
+PANDA_MAKE_PARSE_NODE(ip_overlay_node, panda_parse_ip, NULL,
+		      NULL, ip_table);
+PANDA_MAKE_PARSE_NODE(ipv4_check_node, panda_parse_ipv4_check, ipv4_metadata,
+		      NULL, ipv4_table);
+PANDA_MAKE_PARSE_NODE(ipv4_node, panda_parse_ipv4, ipv4_metadata, NULL,
+		      ipv4_table);
+PANDA_MAKE_PARSE_NODE(ipv6_node, panda_parse_ipv6, ipv6_metadata, NULL,
+		      ipv6_table);
+PANDA_MAKE_PARSE_NODE(ipv6_check_node, panda_parse_ipv6_check, ipv6_metadata,
+		      NULL, ipv6_table);
+PANDA_MAKE_PARSE_NODE(ipv6_eh_node, panda_parse_ipv6_eh, NULL,
+		      NULL, ipv6_table);
+PANDA_MAKE_PARSE_NODE(ipv6_frag_node, panda_parse_ipv6_frag_eh, NULL, NULL, ipv6_table);
+PANDA_MAKE_PARSE_NODE(ppp_node, panda_parse_ppp, NULL, NULL, ppp_table);
+PANDA_MAKE_PARSE_NODE(pppoe_node, panda_parse_pppoe, ppp_metadata, NULL,
+		      pppoe_table);
+
+PANDA_MAKE_PARSE_NODE(e8021AD_node, panda_parse_vlan, e8021AD_metadata, NULL,
+				ether_table);
+PANDA_MAKE_PARSE_NODE(e8021Q_node, panda_parse_vlan, e8021Q_metadata, NULL,
+		      	ether_table);
+PANDA_MAKE_OVERLAY_PARSE_NODE(ipv4ip_node, panda_parse_ipv4ip, NULL, NULL,
+			      &ipv4_node);
+PANDA_MAKE_OVERLAY_PARSE_NODE(ipv6ip_node, panda_parse_ipv6ip, NULL, NULL,
+			      &ipv6_node);
+
+PANDA_MAKE_LEAF_PARSE_NODE(ports_node, panda_parse_ports, ports_metadata,
+			   NULL);
+PANDA_MAKE_LEAF_PARSE_NODE(icmpv4_node, panda_parse_icmpv4, icmp_metadata,
+			   NULL);
+PANDA_MAKE_LEAF_PARSE_NODE(icmpv6_node, panda_parse_icmpv6, icmp_metadata,
+			   NULL);
+PANDA_MAKE_LEAF_PARSE_NODE(arp_node, panda_parse_arp, arp_rarp_metadata,
+			   NULL);
+PANDA_MAKE_LEAF_PARSE_NODE(rarp_node, panda_parse_rarp, arp_rarp_metadata,
+			   NULL);
+
+PANDA_MAKE_LEAF_PARSE_NODE(tcp_node, panda_parse_ports, ports_metadata,
+			   NULL);
+
+/* Protocol tables */
+PANDA_MAKE_PROTO_TABLE(ether_table,
+	{ __cpu_to_be16(ETH_P_IP), &ipv4_check_node },
+	{ __cpu_to_be16(ETH_P_IPV6), &ipv6_check_node },
+	{ __cpu_to_be16(ETH_P_8021AD), &e8021AD_node },
+	{ __cpu_to_be16(ETH_P_8021Q), &e8021Q_node },
+	{ __cpu_to_be16(ETH_P_ARP), &arp_node },
+	{ __cpu_to_be16(ETH_P_RARP), &rarp_node },
+	{ __cpu_to_be16(ETH_P_PPP_SES), &pppoe_node },
+);
+
+PANDA_MAKE_PROTO_TABLE(ipv4_table,
+	{ IPPROTO_TCP, &tcp_node },
+	{ IPPROTO_UDP, &ports_node },
+	{ IPPROTO_SCTP, &ports_node },
+	{ IPPROTO_DCCP, &ports_node },
+	{ IPPROTO_ICMP, &icmpv4_node },
+	{ IPPROTO_IPIP, &ipv4ip_node },
+	{ IPPROTO_IPV6, &ipv6ip_node },
+);
+
+PANDA_MAKE_PROTO_TABLE(ipv6_table,
+	{ IPPROTO_HOPOPTS, &ipv6_eh_node },
+	{ IPPROTO_ROUTING, &ipv6_eh_node },
+	{ IPPROTO_DSTOPTS, &ipv6_eh_node },
+	{ IPPROTO_FRAGMENT, &ipv6_frag_node },
+	{ IPPROTO_TCP, &tcp_node },
+	{ IPPROTO_UDP, &ports_node },
+	{ IPPROTO_SCTP, &ports_node },
+	{ IPPROTO_DCCP, &ports_node },
+	{ IPPROTO_ICMPV6, &icmpv6_node },
+	{ IPPROTO_IPIP, &ipv4ip_node },
+	{ IPPROTO_IPV6, &ipv6ip_node },
+);
+
+PANDA_MAKE_PROTO_TABLE(ip_table,
+	{ 4, &ipv4_node },
+	{ 6, &ipv6_node },
+);
+
+PANDA_MAKE_PROTO_TABLE(ppp_table,
+	{ __cpu_to_be16(PPP_IP), &ipv4_check_node },
+	{ __cpu_to_be16(PPP_IPV6), &ipv6_check_node },
+);
+
+PANDA_MAKE_PROTO_TABLE(pppoe_table,
+	{ __cpu_to_be16(PPP_IP), &ipv4_check_node },
+	{ __cpu_to_be16(PPP_IPV6), &ipv6_check_node },
+);
+
+/* Define parsers. Two of them: one for packets starting with an
+ * Ethernet header, and one for packets starting with an IP header.
+ */
+PANDA_PARSER_EXT(panda_parser_big_ether, "PANDA big parser for Ethernet",
+		 &ether_node);
+
diff --git a/net/sched/cls_flower2_panda_opt.c b/net/sched/cls_flower2_panda_opt.c
new file mode 100644
index 000000000000..a169b2059b49
--- /dev/null
+++ b/net/sched/cls_flower2_panda_opt.c
@@ -0,0 +1,1536 @@
+
+// SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+/*
+ * Copyright (c) 2020, 2021 by Mojatatu Networks.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+
+
+
+// SPDX-License-Identifier: BSD-2-Clause-FreeBSD
+/*
+ * Copyright (c) 2020, 2021 SiPanda Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#include "net/panda/parser.h"
+#include "net/panda/parser_metadata.h"
+#include "net/panda/proto_nodes_def.h"
+
+#include "cls_flower2_panda_noopt.c"
+
+#ifndef PANDA_LOOP_COUNT
+#define PANDA_LOOP_COUNT 8
+#endif
+
+#define PANDA_MAX_ENCAPS (PANDA_LOOP_COUNT + 32)
+enum {
+CODE_ether_node,
+CODE_ip_overlay_node,
+CODE_ipv4_check_node,
+CODE_ipv4_node,
+CODE_ipv6_node,
+CODE_ipv6_check_node,
+CODE_ipv6_eh_node,
+CODE_ipv6_frag_node,
+CODE_ppp_node,
+CODE_pppoe_node,
+CODE_e8021AD_node,
+CODE_e8021Q_node,
+CODE_ipv4ip_node,
+CODE_ipv6ip_node,
+CODE_ports_node,
+CODE_icmpv4_node,
+CODE_icmpv6_node,
+CODE_arp_node,
+CODE_rarp_node,
+CODE_tcp_node,
+CODE_IGNORE
+};
+
+/* Parser control */
+static long next = CODE_IGNORE;
+
+static inline __attribute__((always_inline)) int check_pkt_len(const void *hdr,
+		const struct panda_proto_node *pnode, size_t len, ssize_t *hlen)
+{
+	*hlen = pnode->min_len;
+
+	/* Protocol node length checks */
+	if (len < *hlen)
+		return PANDA_STOP_LENGTH;
+
+	if (pnode->ops.len) {
+		*hlen = pnode->ops.len(hdr);
+		if (len < *hlen)
+			return PANDA_STOP_LENGTH;
+		if (*hlen < pnode->min_len)
+			return *hlen < 0 ? *hlen : PANDA_STOP_LENGTH;
+	} else {
+		*hlen = pnode->min_len;
+	}
+
+	return PANDA_OKAY;
+}
+
+static inline __attribute__((always_inline)) int panda_encap_layer(
+		struct panda_metadata *metadata, unsigned int max_encaps,
+		void **frame, unsigned int *frame_num)
+{
+	/* New encapsulation layer. Check against number of encap layers
+	 * allowed and also if we need a new metadata frame.
+	 */
+	if (++metadata->encaps > max_encaps)
+		return PANDA_STOP_ENCAP_DEPTH;
+
+	if (metadata->max_frame_num > *frame_num) {
+		*frame += metadata->frame_size;
+		*frame_num = (*frame_num) + 1;
+	}
+
+	return PANDA_OKAY;
+}
+
+static inline __attribute__((always_inline)) int panda_parse_tlv(
+		const struct panda_parse_tlvs_node *parse_node,
+		const struct panda_parse_tlv_node *parse_tlv_node,
+		const __u8 *cp, void *frame, struct panda_ctrl_data tlv_ctrl) {
+	const struct panda_parse_tlv_node_ops *ops = &parse_tlv_node->tlv_ops;
+	const struct panda_proto_tlv_node *proto_tlv_node =
+					parse_tlv_node->proto_tlv_node;
+
+	if (proto_tlv_node && (tlv_ctrl.hdr_len < proto_tlv_node->min_len)) {
+		/* Treat check length error as an unrecognized TLV */
+		if (parse_node->tlv_wildcard_node)
+			return panda_parse_tlv(parse_node,
+					parse_node->tlv_wildcard_node,
+					cp, frame, tlv_ctrl);
+		else
+			return parse_node->unknown_tlv_type_ret;
+	}
+
+	if (ops->extract_metadata)
+		ops->extract_metadata(cp, frame, tlv_ctrl);
+
+	if (ops->handle_tlv)
+		ops->handle_tlv(cp, frame, tlv_ctrl);
+
+	return PANDA_OKAY;
+}
+
+
+
+
+static __always_inline int __ether_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ip_overlay_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ipv4_check_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ipv4_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ipv6_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ipv6_check_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ipv6_eh_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ipv6_frag_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ppp_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __pppoe_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __e8021AD_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __e8021Q_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ipv4ip_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ipv6ip_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __ports_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __icmpv4_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __icmpv6_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __arp_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __rarp_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+static __always_inline int __tcp_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata, unsigned int flags,
+		unsigned int max_encaps, void *frame, unsigned frame_num);
+
+static __always_inline int __ether_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ether_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case __cpu_to_be16(ETH_P_IP):
+		next = CODE_ipv4_check_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_IPV6):
+		next = CODE_ipv6_check_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_8021AD):
+		next = CODE_e8021AD_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_8021Q):
+		next = CODE_e8021Q_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_ARP):
+		next = CODE_arp_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_RARP):
+		next = CODE_rarp_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_PPP_SES):
+		next = CODE_pppoe_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __ip_overlay_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ip_overlay_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case 4:
+		next = CODE_ipv4_node;
+		return PANDA_STOP_OKAY;
+	case 6:
+		next = CODE_ipv6_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __ipv4_check_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ipv4_check_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case IPPROTO_TCP:
+		next = CODE_tcp_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_UDP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_SCTP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_DCCP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_ICMP:
+		next = CODE_icmpv4_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPIP:
+		next = CODE_ipv4ip_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPV6:
+		next = CODE_ipv6ip_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __ipv4_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ipv4_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case IPPROTO_TCP:
+		next = CODE_tcp_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_UDP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_SCTP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_DCCP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_ICMP:
+		next = CODE_icmpv4_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPIP:
+		next = CODE_ipv4ip_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPV6:
+		next = CODE_ipv6ip_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __ipv6_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ipv6_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case IPPROTO_HOPOPTS:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_ROUTING:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_DSTOPTS:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_FRAGMENT:
+		next = CODE_ipv6_frag_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_TCP:
+		next = CODE_tcp_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_UDP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_SCTP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_DCCP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_ICMPV6:
+		next = CODE_icmpv6_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPIP:
+		next = CODE_ipv4ip_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPV6:
+		next = CODE_ipv6ip_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __ipv6_check_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ipv6_check_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case IPPROTO_HOPOPTS:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_ROUTING:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_DSTOPTS:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_FRAGMENT:
+		next = CODE_ipv6_frag_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_TCP:
+		next = CODE_tcp_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_UDP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_SCTP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_DCCP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_ICMPV6:
+		next = CODE_icmpv6_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPIP:
+		next = CODE_ipv4ip_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPV6:
+		next = CODE_ipv6ip_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __ipv6_eh_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ipv6_eh_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case IPPROTO_HOPOPTS:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_ROUTING:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_DSTOPTS:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_FRAGMENT:
+		next = CODE_ipv6_frag_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_TCP:
+		next = CODE_tcp_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_UDP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_SCTP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_DCCP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_ICMPV6:
+		next = CODE_icmpv6_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPIP:
+		next = CODE_ipv4ip_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPV6:
+		next = CODE_ipv6ip_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __ipv6_frag_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ipv6_frag_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case IPPROTO_HOPOPTS:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_ROUTING:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_DSTOPTS:
+		next = CODE_ipv6_eh_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_FRAGMENT:
+		next = CODE_ipv6_frag_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_TCP:
+		next = CODE_tcp_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_UDP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_SCTP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_DCCP:
+		next = CODE_ports_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_ICMPV6:
+		next = CODE_icmpv6_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPIP:
+		next = CODE_ipv4ip_node;
+		return PANDA_STOP_OKAY;
+	case IPPROTO_IPV6:
+		next = CODE_ipv6ip_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __ppp_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ppp_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case __cpu_to_be16(PPP_IP):
+		next = CODE_ipv4_check_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(PPP_IPV6):
+		next = CODE_ipv6_check_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __pppoe_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&pppoe_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case __cpu_to_be16(PPP_IP):
+		next = CODE_ipv4_check_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(PPP_IPV6):
+		next = CODE_ipv6_check_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __e8021AD_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&e8021AD_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case __cpu_to_be16(ETH_P_IP):
+		next = CODE_ipv4_check_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_IPV6):
+		next = CODE_ipv6_check_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_8021AD):
+		next = CODE_e8021AD_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_8021Q):
+		next = CODE_e8021Q_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_ARP):
+		next = CODE_arp_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_RARP):
+		next = CODE_rarp_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_PPP_SES):
+		next = CODE_pppoe_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __e8021Q_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&e8021Q_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	{
+	int type = proto_node->ops.next_proto(*hdr);
+
+	if (type < 0)
+		return type;
+
+	if (!proto_node->overlay) {
+		*hdr += hlen;
+		*offset += hlen;
+		len -= hlen;
+	}
+
+	switch (type) {
+	case __cpu_to_be16(ETH_P_IP):
+		next = CODE_ipv4_check_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_IPV6):
+		next = CODE_ipv6_check_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_8021AD):
+		next = CODE_e8021AD_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_8021Q):
+		next = CODE_e8021Q_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_ARP):
+		next = CODE_arp_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_RARP):
+		next = CODE_rarp_node;
+		return PANDA_STOP_OKAY;
+	case __cpu_to_be16(ETH_P_PPP_SES):
+		next = CODE_pppoe_node;
+		return PANDA_STOP_OKAY;
+	}
+	/* Unknown protocol */
+	return PANDA_STOP_UNKNOWN_PROTO;
+	}
+}
+static __always_inline int __ipv4ip_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ipv4ip_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	next = CODE_IGNORE;
+	return PANDA_STOP_OKAY;
+}
+static __always_inline int __ipv6ip_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ipv6ip_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	next = CODE_IGNORE;
+	return PANDA_STOP_OKAY;
+}
+static __always_inline int __ports_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&ports_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	next = CODE_IGNORE;
+	return PANDA_STOP_OKAY;
+}
+static __always_inline int __icmpv4_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&icmpv4_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	next = CODE_IGNORE;
+	return PANDA_STOP_OKAY;
+}
+static __always_inline int __icmpv6_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&icmpv6_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	next = CODE_IGNORE;
+	return PANDA_STOP_OKAY;
+}
+static __always_inline int __arp_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&arp_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	next = CODE_IGNORE;
+	return PANDA_STOP_OKAY;
+}
+static __always_inline int __rarp_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&rarp_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	next = CODE_IGNORE;
+	return PANDA_STOP_OKAY;
+}
+static __always_inline int __tcp_node_panda_parse(const struct panda_parser *parser,
+		const void **hdr, size_t len, size_t *offset,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps,
+		void *frame, unsigned frame_num)
+{
+	const struct panda_parse_node *parse_node =
+		(const struct panda_parse_node *)&tcp_node;
+	const struct panda_proto_node *proto_node = parse_node->proto_node;
+	struct panda_ctrl_data ctrl;
+	ssize_t hlen;
+	int ret;
+
+	ret = check_pkt_len(*hdr, parse_node->proto_node, len, &hlen);
+	if (ret != PANDA_OKAY)
+		return ret;
+
+	ctrl.hdr_len = hlen;
+	ctrl.hdr_offset = *offset;
+
+	if (parse_node->ops.extract_metadata)
+		parse_node->ops.extract_metadata(*hdr, frame, ctrl);
+
+
+
+	if (proto_node->encap) {
+		ret = panda_encap_layer(metadata, max_encaps, &frame,
+					&frame_num);
+		if (ret != PANDA_OKAY)
+			return ret;
+	}
+
+	next = CODE_IGNORE;
+	return PANDA_STOP_OKAY;
+}
+
+static inline int panda_parser_big_ether_panda_parse_ether_node(
+		const struct panda_parser *parser,
+		const void *hdr, size_t len,
+		struct panda_metadata *metadata,
+		unsigned int flags, unsigned int max_encaps)
+{
+	void *frame = metadata->frame_data;
+	unsigned int frame_num = 0;
+	int ret = PANDA_STOP_OKAY;
+	int i;
+	size_t offset;
+
+	ret = __ether_node_panda_parse(parser, &hdr,
+		len, &offset, metadata, flags, max_encaps, frame, frame_num);
+
+	for (i = 0; i < PANDA_LOOP_COUNT; i++) {
+		if (ret != PANDA_STOP_OKAY)
+			break;
+		switch (next) {
+		case CODE_IGNORE:
+			break;
+		case CODE_ether_node:
+			ret = __ether_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ip_overlay_node:
+			ret = __ip_overlay_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ipv4_check_node:
+			ret = __ipv4_check_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ipv4_node:
+			ret = __ipv4_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ipv6_node:
+			ret = __ipv6_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ipv6_check_node:
+			ret = __ipv6_check_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ipv6_eh_node:
+			ret = __ipv6_eh_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ipv6_frag_node:
+			ret = __ipv6_frag_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ppp_node:
+			ret = __ppp_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_pppoe_node:
+			ret = __pppoe_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_e8021AD_node:
+			ret = __e8021AD_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_e8021Q_node:
+			ret = __e8021Q_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ipv4ip_node:
+			ret = __ipv4ip_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ipv6ip_node:
+			ret = __ipv6ip_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_ports_node:
+			ret = __ports_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_icmpv4_node:
+			ret = __icmpv4_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_icmpv6_node:
+			ret = __icmpv6_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_arp_node:
+			ret = __arp_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_rarp_node:
+			ret = __rarp_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		case CODE_tcp_node:
+			ret = __tcp_node_panda_parse(parser, &hdr, len, &offset,
+						     metadata, flags,
+						     max_encaps, frame,
+						     frame_num);
+			break;
+		default:
+			return PANDA_STOP_UNKNOWN_PROTO;
+		}
+	}
+
+	return ret;
+}
+
+PANDA_PARSER_KMOD(
+      panda_parser_big_ether,
+      "",
+      &ether_node,
+      panda_parser_big_ether_panda_parse_ether_node
+    );
-- 
2.33.0

