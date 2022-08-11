Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B180258FE3A
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiHKO1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbiHKO1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:27:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4848E6E2C4
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 07:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660228019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zeekItEVQnyKl69WtmyNs/a5QRMc+ZgwUrSeL+HnQvA=;
        b=TLsa0ECQDdAiVopl/rQ2jBVbS46AtAtiYsoR/QdTwsXVcTxUtUp5Bn1fQCRSljOIR2sjg7
        L+9aegRO6bg6v4fRG7bLFdxea0/ea+xGdD4Wi1/yMDIczaMQZIcpXAmd807If+AlZsJVvS
        1JUjArAkN7dkQSpsYxjej4wxmfct+pM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-477-zN5CfthbNYSbI879bOEeNA-1; Thu, 11 Aug 2022 10:26:58 -0400
X-MC-Unique: zN5CfthbNYSbI879bOEeNA-1
Received: by mail-wm1-f72.google.com with SMTP id r5-20020a1c4405000000b003a534ec2570so2721734wma.7
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 07:26:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=zeekItEVQnyKl69WtmyNs/a5QRMc+ZgwUrSeL+HnQvA=;
        b=vrxWCFxKsQJUp6x+Tfb8XMBil5BLcRb1ONLx8j3XBrsK7Yskp9g/HN0ETHVc14/v6q
         m97shbCpG69tmJ2hwFojEM7gWrdKh6pqmAKdcuzeEO6dFVqLfNP9Ky6+LJeiJ9umpGw9
         LvzDybuvqKNVOa+6SoIwLKepRrny6GiFfQwr623O91QiSVn1Bv+uGE0pd2ag6d9/vRHB
         5Hd2abxEuzjAuHY0P0Dy4JEo28O6H0K8l5NGzrGHXeABXw8Vytrh6vvS1/hs7akndUB2
         /25YFbp6w0PielvK3yJewNKxqyCuKIknFMiA7jyrhpJ2CIw7+7KQOqw6xTC531kpHaN4
         Au5g==
X-Gm-Message-State: ACgBeo1LjBNGHJQTM+d25t8NgU1eWtloCyXvQrSFRbPyWkdux8JFBY7w
        ilo0QAJPW9U8ximS6QPVGitMgXrfcfUuxNkon7FQzrc44HYZggp3c3oib6S2VoHI1fpx5We5zeS
        hv0T4OmVKiTwmIy5w
X-Received: by 2002:a05:600c:1c99:b0:3a5:b62a:52fa with SMTP id k25-20020a05600c1c9900b003a5b62a52famr5109125wms.161.1660228016039;
        Thu, 11 Aug 2022 07:26:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6+IJlet3aEzUO8y5VhCnYLctJP3x49czlIfVqz4vShsNR+xBRdqkqhZE0dXaNlwMEa62lgHQ==
X-Received: by 2002:a05:600c:1c99:b0:3a5:b62a:52fa with SMTP id k25-20020a05600c1c9900b003a5b62a52famr5109100wms.161.1660228015630;
        Thu, 11 Aug 2022 07:26:55 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c4f9200b003a1980d55c4sm7237293wmq.47.2022.08.11.07.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 07:26:55 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH 1/2] sched/topology: Introduce sched_numa_hop_mask()
In-Reply-To: <03aaf512-3ac5-fdfe-da2d-3fecd24591e2@gmail.com>
References: <xhsmhtu6kbckc.mognet@vschneid.remote.csb>
 <20220810105119.2684079-1-vschneid@redhat.com>
 <db20e6fe-4368-15ec-65c5-ead28fc7981b@gmail.com>
 <03aaf512-3ac5-fdfe-da2d-3fecd24591e2@gmail.com>
Date:   Thu, 11 Aug 2022 15:26:54 +0100
Message-ID: <xhsmhmtcac0up.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/22 15:57, Tariq Toukan wrote:
> On 8/10/2022 3:42 PM, Tariq Toukan wrote:
>>
>>
>> On 8/10/2022 1:51 PM, Valentin Schneider wrote:
>>> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
>>> index 8739c2a5a54e..f0236a0ae65c 100644
>>> --- a/kernel/sched/topology.c
>>> +++ b/kernel/sched/topology.c
>>> @@ -2067,6 +2067,34 @@ int sched_numa_find_closest(const struct
>>> cpumask *cpus, int cpu)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return found;
>>> =C2=A0 }
>>> +/**
>>> + * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops
>>> away.
>>> + * @node: The node to count hops from.
>>> + * @hops: Include CPUs up to that many hops away. 0 means local node.
>
> AFAIU, here you work with a specific level/num of hops, description is
> not accurate.
>

Hmph, unfortunately it's the other way around - the masks do include CPUs
*up to* a number of hops, but in my mlx5 example I've used it as if it only
included CPUs a specific distance away :/

As things stand we'd need a temporary cpumask to account for which CPUs we
have visited (which is what you had in your original submission), but with
a for_each_cpu_andnot() we don't need any of that.

Below is what I ended up with. I've tested it on a range of NUMA topologies
and it behaves as I'd expect, and on the plus side the code required in the
driver side is even simpler than before.

If you don't have major gripes with it, I'll shape that into a proper
series and will let you handle the mlx5/enic bits.

---

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/eq.c
index 229728c80233..0a5432903edd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -812,6 +812,7 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 	int ncomp_eqs =3D table->num_comp_eqs;
 	u16 *cpus;
 	int ret;
+	int cpu;
 	int i;
=20
 	ncomp_eqs =3D table->num_comp_eqs;
@@ -830,8 +831,15 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 		ret =3D -ENOMEM;
 		goto free_irqs;
 	}
-	for (i =3D 0; i < ncomp_eqs; i++)
-		cpus[i] =3D cpumask_local_spread(i, dev->priv.numa_node);
+
+	rcu_read_lock();
+	for_each_numa_hop_cpus(cpu, dev->priv.numa_node) {
+		cpus[i] =3D cpu;
+		if (++i =3D=3D ncomp_eqs)
+			goto spread_done;
+	}
+spread_done:
+	rcu_read_unlock();
 	ret =3D mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
 	kfree(cpus);
 	if (ret < 0)
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index fe29ac7cc469..ccd5d71aefef 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -157,6 +157,13 @@ static inline unsigned int cpumask_next_and(int n,
 	return n+1;
 }
=20
+static inline unsigned int cpumask_next_andnot(int n,
+					    const struct cpumask *srcp,
+					    const struct cpumask *andp)
+{
+	return n+1;
+}
+
 static inline unsigned int cpumask_next_wrap(int n, const struct cpumask *=
mask,
 					     int start, bool wrap)
 {
@@ -194,6 +201,8 @@ static inline int cpumask_any_distribute(const struct c=
pumask *srcp)
 	for ((cpu) =3D 0; (cpu) < 1; (cpu)++, (void)mask, (void)(start))
 #define for_each_cpu_and(cpu, mask1, mask2)	\
 	for ((cpu) =3D 0; (cpu) < 1; (cpu)++, (void)mask1, (void)mask2)
+#define for_each_cpu_andnot(cpu, mask1, mask2)	\
+	for ((cpu) =3D 0; (cpu) < 1; (cpu)++, (void)mask1, (void)mask2)
 #else
 /**
  * cpumask_first - get the first cpu in a cpumask
@@ -259,6 +268,7 @@ static inline unsigned int cpumask_next_zero(int n, con=
st struct cpumask *srcp)
 }
=20
 int __pure cpumask_next_and(int n, const struct cpumask *, const struct cp=
umask *);
+int __pure cpumask_next_andnot(int n, const struct cpumask *, const struct=
 cpumask *);
 int __pure cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
 unsigned int cpumask_local_spread(unsigned int i, int node);
 int cpumask_any_and_distribute(const struct cpumask *src1p,
@@ -324,6 +334,26 @@ extern int cpumask_next_wrap(int n, const struct cpuma=
sk *mask, int start, bool
 	for ((cpu) =3D -1;						\
 		(cpu) =3D cpumask_next_and((cpu), (mask1), (mask2)),	\
 		(cpu) < nr_cpu_ids;)
+
+/**
+ * for_each_cpu_andnot - iterate over every cpu in one mask but not in ano=
ther
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask1: the first cpumask pointer
+ * @mask2: the second cpumask pointer
+ *
+ * This saves a temporary CPU mask in many places.  It is equivalent to:
+ *	struct cpumask tmp;
+ *	cpumask_andnot(&tmp, &mask1, &mask2);
+ *	for_each_cpu(cpu, &tmp)
+ *		...
+ *
+ * After the loop, cpu is >=3D nr_cpu_ids.
+ */
+#define for_each_cpu_andnot(cpu, mask1, mask2)				\
+	for ((cpu) =3D -1;						\
+		(cpu) =3D cpumask_next_andnot((cpu), (mask1), (mask2)),	\
+		(cpu) < nr_cpu_ids;)
+
 #endif /* SMP */
=20
 #define CPU_BITS_NONE						\
diff --git a/include/linux/find.h b/include/linux/find.h
index 424ef67d4a42..454cde69b30b 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -10,7 +10,8 @@
=20
 extern unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert, unsigned long le);
+		unsigned long start, unsigned long invert, unsigned long le,
+		bool negate);
 extern unsigned long _find_first_bit(const unsigned long *addr, unsigned l=
ong size);
 extern unsigned long _find_first_and_bit(const unsigned long *addr1,
 					 const unsigned long *addr2, unsigned long size);
@@ -41,7 +42,7 @@ unsigned long find_next_bit(const unsigned long *addr, un=
signed long size,
 		return val ? __ffs(val) : size;
 	}
=20
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 0, 0);
 }
 #endif
=20
@@ -71,7 +72,38 @@ unsigned long find_next_and_bit(const unsigned long *add=
r1,
 		return val ? __ffs(val) : size;
 	}
=20
-	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0, 0);
+}
+#endif
+
+#ifndef find_next_andnot_bit
+/**
+ * find_next_andnot_bit - find the next set bit in one memory region
+ *                        but not in the other
+ * @addr1: The first address to base the search on
+ * @addr2: The second address to base the search on
+ * @size: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_next_andnot_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long size,
+		unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >=3D size))
+			return size;
+
+		val =3D *addr1 & ~*addr2 & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0, 1);
 }
 #endif
=20
@@ -99,7 +131,7 @@ unsigned long find_next_zero_bit(const unsigned long *ad=
dr, unsigned long size,
 		return val =3D=3D ~0UL ? size : ffz(val);
 	}
=20
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0, 0);
 }
 #endif
=20
@@ -247,7 +279,7 @@ unsigned long find_next_zero_bit_le(const void *addr, u=
nsigned
 		return val =3D=3D ~0UL ? size : ffz(val);
 	}
=20
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1, 0);
 }
 #endif
=20
@@ -266,7 +298,7 @@ unsigned long find_next_bit_le(const void *addr, unsign=
ed
 		return val ? __ffs(val) : size;
 	}
=20
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 1, 0);
 }
 #endif
=20
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4564faafd0e1..41bed4b883d3 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -245,5 +245,50 @@ static inline const struct cpumask *cpu_cpu_mask(int c=
pu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
=20
+#ifdef CONFIG_NUMA
+extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
+#else
+static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+#endif	/* CONFIG_NUMA */
+
+/**
+ * for_each_numa_hop_cpu - iterate over CPUs by increasing NUMA distance,
+ *                         starting from a given node.
+ * @cpu: the iteration variable.
+ * @node: the NUMA node to start the search from.
+ *
+ * Requires rcu_lock to be held.
+ * Careful: this is a double loop, 'break' won't work as expected.
+ *
+ *
+ * Implementation notes:
+ *
+ * Providing it is valid, the mask returned by
+ *  sched_numa_hop_mask(node, hops+1)
+ * is a superset of the one returned by
+ *   sched_numa_hop_mask(node, hops)
+ * which may not be that useful for drivers that try to spread things out =
and
+ * want to visit a CPU not more than once.
+ *
+ * To accomodate for that, we use for_each_cpu_andnot() to iterate over th=
e cpus
+ * of sched_numa_hop_mask(node, hops+1) with the CPUs of
+ * sched_numa_hop_mask(node, hops) removed, IOW we only iterate over CPUs
+ * a given distance away (rather than *up to* a given distance).
+ *
+ * h=3D0 forces us to play silly games and pass cpu_none_mask to
+ * for_each_cpu_andnot(), which turns it into for_each_cpu().
+ */
+#define for_each_numa_hop_cpu(cpu, node)				       \
+	for (struct { const struct cpumask *mask; int hops; } __v__ =3D	       \
+		     { sched_numa_hop_mask(node, 0), 0 };		       \
+	     !IS_ERR_OR_NULL(__v__.mask);				       \
+	     __v__.hops++, __v__.mask =3D sched_numa_hop_mask(node, __v__.hops)) \
+		for_each_cpu_andnot(cpu, __v__.mask,			       \
+				    __v__.hops ?			       \
+				    sched_numa_hop_mask(node, __v__.hops - 1) :\
+				    cpu_none_mask)
=20
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 976092b7bd45..9182101f2c4f 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -29,6 +29,6 @@ endif
 # build parallelizes well and finishes roughly at once:
 #
 obj-y +=3D core.o
-obj-y +=3D fair.o
+obj-y +=3D fair.o yolo.o
 obj-y +=3D build_policy.o
 obj-y +=3D build_utility.o
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8739c2a5a54e..f0236a0ae65c 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2067,6 +2067,34 @@ int sched_numa_find_closest(const struct cpumask *cp=
us, int cpu)
 	return found;
 }
=20
+/**
+ * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away.
+ * @node: The node to count hops from.
+ * @hops: Include CPUs up to that many hops away. 0 means local node.
+ *
+ * Requires rcu_lock to be held. Returned cpumask is only valid within that
+ * read-side section, copy it if required beyond that.
+ *
+ * Note that not all hops are equal in size; see sched_init_numa() for how
+ * distances and masks are handled.
+ *
+ * Also note that this is a reflection of sched_domains_numa_masks, which =
may change
+ * during the lifetime of the system (offline nodes are taken out of the m=
asks).
+ */
+const struct cpumask *sched_numa_hop_mask(int node, int hops)
+{
+	struct cpumask ***masks =3D rcu_dereference(sched_domains_numa_masks);
+
+	if (node >=3D nr_node_ids || hops >=3D sched_domains_numa_levels)
+		return ERR_PTR(-EINVAL);
+
+	if (!masks)
+		return NULL;
+
+	return masks[hops][node];
+}
+EXPORT_SYMBOL_GPL(sched_numa_hop_mask);
+
 #endif /* CONFIG_NUMA */
=20
 static int __sdt_alloc(const struct cpumask *cpu_map)
diff --git a/lib/cpumask.c b/lib/cpumask.c
index a971a82d2f43..8bcf7e919193 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -42,6 +42,25 @@ int cpumask_next_and(int n, const struct cpumask *src1p,
 }
 EXPORT_SYMBOL(cpumask_next_and);
=20
+/**
+ * cpumask_next_andnot - get the next cpu in *src1p & ~*src2p
+ * @n: the cpu prior to the place to search (ie. return will be > @n)
+ * @src1p: the first cpumask pointer
+ * @src2p: the second cpumask pointer
+ *
+ * Returns >=3D nr_cpu_ids if no further cpus set in both.
+ */
+int cpumask_next_andnot(int n, const struct cpumask *src1p,
+		     const struct cpumask *src2p)
+{
+	/* -1 is a legal arg here. */
+	if (n !=3D -1)
+		cpumask_check(n);
+	return find_next_andnot_bit(cpumask_bits(src1p), cpumask_bits(src2p),
+		nr_cpumask_bits, n + 1);
+}
+EXPORT_SYMBOL(cpumask_next_andnot);
+
 /**
  * cpumask_any_but - return a "random" in a cpumask, but not this one.
  * @mask: the cpumask to search
diff --git a/lib/find_bit.c b/lib/find_bit.c
index 1b8e4b2a9cba..6e5f42c621a9 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -21,17 +21,19 @@
=20
 #if !defined(find_next_bit) || !defined(find_next_zero_bit) ||			\
 	!defined(find_next_bit_le) || !defined(find_next_zero_bit_le) ||	\
-	!defined(find_next_and_bit)
+	!defined(find_next_and_bit) || !defined(find_next_andnot_bit)
 /*
  * This is a common helper function for find_next_bit, find_next_zero_bit,=
 and
  * find_next_and_bit. The differences are:
  *  - The "invert" argument, which is XORed with each fetched word before
  *    searching it for one bits.
- *  - The optional "addr2", which is anded with "addr1" if present.
+ *  - The optional "addr2", negated if "negate" and ANDed with "addr1" if
+ *    present.
  */
 unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert, unsigned long le)
+		unsigned long start, unsigned long invert, unsigned long le,
+		bool negate)
 {
 	unsigned long tmp, mask;
=20
@@ -40,7 +42,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
=20
 	tmp =3D addr1[start / BITS_PER_LONG];
 	if (addr2)
-		tmp &=3D addr2[start / BITS_PER_LONG];
+		tmp &=3D negate ?
+		       ~addr2[start / BITS_PER_LONG] :
+			addr2[start / BITS_PER_LONG];
 	tmp ^=3D invert;
=20
 	/* Handle 1st word. */
@@ -59,7 +63,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
=20
 		tmp =3D addr1[start / BITS_PER_LONG];
 		if (addr2)
-			tmp &=3D addr2[start / BITS_PER_LONG];
+			tmp &=3D negate ?
+			       ~addr2[start / BITS_PER_LONG] :
+				addr2[start / BITS_PER_LONG];
 		tmp ^=3D invert;
 	}
=20

