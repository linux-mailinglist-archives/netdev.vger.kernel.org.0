Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E74419F96
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 16:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfEJOvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 10:51:48 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:43702 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbfEJOvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 10:51:47 -0400
Received: by mail-wr1-f43.google.com with SMTP id r4so8224632wro.10
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 07:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5Nx6DKYjRH/S3UFhKToHF83aEKiWRiGWoiR2FaHMQnI=;
        b=JiepDImx3WZHjL5/MJp0nxhPAZ27iDgUDmJU1uxlKHXHIaf+SR7KLxwgrPjISi4QSY
         tjic//cPW5zXAC7T9aW1qZXFzkHp6/tz3FVTMx3FF3xL6LoW0eGVNbzzPbKUO10Pr83S
         J5LDqj6Q1sBlALsR9VQlCyJcOHrDUaxLfV5sz/rs5qPm8hPam1Z7KaL3lKgh/m0XXo65
         SsyzeqPcoN0Cqjp9of2NxvGcZMnyjOUVCpBaVNlDj49DctgjlWaPNHlN/tMjqXILtIV2
         z1H/ZXzuGhWh7rl2mgtGaitNFykruwyPSQQ35H3R5Sgo2Ekw4ipo9LJHXF9+T5Ei7KLe
         MsvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5Nx6DKYjRH/S3UFhKToHF83aEKiWRiGWoiR2FaHMQnI=;
        b=YhoZUaKD/suyqCZ4eQtPEYoJwYmUWBZ+Yl5ckTohb5LQzwqpdhzqElkGk2A18K/elU
         j7sZwgEObvC2C8BWpbHJbkViML3ACFu3lfTjNKz9jOrI1lg/VAU14FaZlfvh4ihvYqHu
         8cATEgJo2iGdnDAU2WfxolXyW6dvcMPb/XoMTlZuCDZYDvk8wKp5+q+vPuXBcbOzS7SB
         DIT+IYdA+VCQK7j7DP0H0oWP0ZN6YgVyou28HKKTWYhA6stKnWSdjjRRlc6vITSX7Szi
         0VbWhV3JBj4U+++i2TOW54mt1/tN3ZCVwj/ukDYy+T6kj5pKZmalqvaXsC+ZG1wBLIbc
         niPQ==
X-Gm-Message-State: APjAAAW38FHbZzoMrHUnvTRAsS1ckgOw94KKFVOt/2iJYlsoeJp3Fmqb
        Ww3btT7XweAzpT28qbqezj6i4Q11ijA=
X-Google-Smtp-Source: APXvYqxHG/gdePAi+dWSR92CqU7h/6kTd3bb2DU0k0DcUitxGhJ2BLMs1ZZbwlFAscwBoH6hV55jUw==
X-Received: by 2002:adf:e30d:: with SMTP id b13mr40824wrj.246.1557499903684;
        Fri, 10 May 2019 07:51:43 -0700 (PDT)
Received: from reblochon.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id p17sm7561027wrg.92.2019.05.10.07.51.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 07:51:42 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf 4/4] tools: bpf: synchronise BPF UAPI header with tools
Date:   Fri, 10 May 2019 15:51:25 +0100
Message-Id: <20190510145125.8416-5-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20190510145125.8416-1-quentin.monnet@netronome.com>
References: <20190510145125.8416-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synchronise the bpf.h header under tools, to report the fixes and
additions recently brought to the documentation for the BPF helpers.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/include/uapi/linux/bpf.h | 145 +++++++++++++++++++++--------------------
 1 file changed, 75 insertions(+), 70 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 72336bac7573..63e0cf66f01a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -629,7 +629,7 @@ union bpf_attr {
  * 		**BPF_F_INVALIDATE_HASH** (set *skb*\ **->hash**, *skb*\
  * 		**->swhash** and *skb*\ **->l4hash** to 0).
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -654,7 +654,7 @@ union bpf_attr {
  * 		flexibility and can handle sizes larger than 2 or 4 for the
  * 		checksum to update.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -686,7 +686,7 @@ union bpf_attr {
  * 		flexibility and can handle sizes larger than 2 or 4 for the
  * 		checksum to update.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -741,7 +741,7 @@ union bpf_attr {
  * 		efficient, but it is handled through an action code where the
  * 		redirection happens only after the eBPF program has returned.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -806,7 +806,7 @@ union bpf_attr {
  * 		**ETH_P_8021Q** and **ETH_P_8021AD**, it is considered to
  * 		be **ETH_P_8021Q**.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -818,7 +818,7 @@ union bpf_attr {
  * 	Description
  * 		Pop a VLAN header from the packet associated to *skb*.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1168,7 +1168,7 @@ union bpf_attr {
  * 		All values for *flags* are reserved for future usage, and must
  * 		be left at zero.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1281,7 +1281,7 @@ union bpf_attr {
  * 		implicitly linearizes, unclones and drops offloads from the
  * 		*skb*.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1317,7 +1317,7 @@ union bpf_attr {
  * 		**bpf_skb_pull_data()** to effectively unclone the *skb* from
  * 		the very beginning in case it is indeed cloned.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1369,7 +1369,7 @@ union bpf_attr {
  * 		All values for *flags* are reserved for future usage, and must
  * 		be left at zero.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1384,7 +1384,7 @@ union bpf_attr {
  * 		can be used to prepare the packet for pushing or popping
  * 		headers.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1518,20 +1518,20 @@ union bpf_attr {
  *		* **BPF_F_ADJ_ROOM_FIXED_GSO**: Do not adjust gso_size.
  *		  Adjusting mss in this way is not allowed for datagrams.
  *
- *		* **BPF_F_ADJ_ROOM_ENCAP_L3_IPV4 **:
- *		* **BPF_F_ADJ_ROOM_ENCAP_L3_IPV6 **:
+ *		* **BPF_F_ADJ_ROOM_ENCAP_L3_IPV4**,
+ *		  **BPF_F_ADJ_ROOM_ENCAP_L3_IPV6**:
  *		  Any new space is reserved to hold a tunnel header.
  *		  Configure skb offsets and other fields accordingly.
  *
- *		* **BPF_F_ADJ_ROOM_ENCAP_L4_GRE **:
- *		* **BPF_F_ADJ_ROOM_ENCAP_L4_UDP **:
+ *		* **BPF_F_ADJ_ROOM_ENCAP_L4_GRE**,
+ *		  **BPF_F_ADJ_ROOM_ENCAP_L4_UDP**:
  *		  Use with ENCAP_L3 flags to further specify the tunnel type.
  *
- *		* **BPF_F_ADJ_ROOM_ENCAP_L2(len) **:
+ *		* **BPF_F_ADJ_ROOM_ENCAP_L2**\ (*len*):
  *		  Use with ENCAP_L3/L4 flags to further specify the tunnel
- *		  type; **len** is the length of the inner MAC header.
+ *		  type; *len* is the length of the inner MAC header.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1610,7 +1610,7 @@ union bpf_attr {
  * 		more flexibility as the user is free to store whatever meta
  * 		data they need.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1852,7 +1852,7 @@ union bpf_attr {
  * 		copied if necessary (i.e. if data was not linear and if start
  * 		and end pointers do not point to the same chunk).
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1886,7 +1886,7 @@ union bpf_attr {
  * 		only possible to shrink the packet as of this writing,
  * 		therefore *delta* must be a negative integer.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -2061,18 +2061,18 @@ union bpf_attr {
  *		**BPF_LWT_ENCAP_IP**
  *			IP encapsulation (GRE/GUE/IPIP/etc). The outer header
  *			must be IPv4 or IPv6, followed by zero or more
- *			additional headers, up to LWT_BPF_MAX_HEADROOM total
- *			bytes in all prepended headers. Please note that
- *			if skb_is_gso(skb) is true, no more than two headers
- *			can be prepended, and the inner header, if present,
- *			should be either GRE or UDP/GUE.
- *
- *		BPF_LWT_ENCAP_SEG6*** types can be called by bpf programs of
- *		type BPF_PROG_TYPE_LWT_IN; BPF_LWT_ENCAP_IP type can be called
- *		by bpf programs of types BPF_PROG_TYPE_LWT_IN and
- *		BPF_PROG_TYPE_LWT_XMIT.
- *
- * 		A call to this helper is susceptible to change the underlaying
+ *			additional headers, up to **LWT_BPF_MAX_HEADROOM**
+ *			total bytes in all prepended headers. Please note that
+ *			if **skb_is_gso**\ (*skb*) is true, no more than two
+ *			headers can be prepended, and the inner header, if
+ *			present, should be either GRE or UDP/GUE.
+ *
+ *		**BPF_LWT_ENCAP_SEG6**\ \* types can be called by BPF programs
+ *		of type **BPF_PROG_TYPE_LWT_IN**; **BPF_LWT_ENCAP_IP** type can
+ *		be called by bpf programs of types **BPF_PROG_TYPE_LWT_IN** and
+ *		**BPF_PROG_TYPE_LWT_XMIT**.
+ *
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -2087,7 +2087,7 @@ union bpf_attr {
  *		inside the outermost IPv6 Segment Routing Header can be
  *		modified through this helper.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -2103,7 +2103,7 @@ union bpf_attr {
  *		after the segments are accepted. *delta* can be as well
  *		positive (growing) as negative (shrinking).
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -2126,13 +2126,13 @@ union bpf_attr {
  *			Type of *param*: **int**.
  *		**SEG6_LOCAL_ACTION_END_B6**
  *			End.B6 action: Endpoint bound to an SRv6 policy.
- *			Type of param: **struct ipv6_sr_hdr**.
+ *			Type of *param*: **struct ipv6_sr_hdr**.
  *		**SEG6_LOCAL_ACTION_END_B6_ENCAP**
  *			End.B6.Encap action: Endpoint bound to an SRv6
  *			encapsulation policy.
- *			Type of param: **struct ipv6_sr_hdr**.
+ *			Type of *param*: **struct ipv6_sr_hdr**.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -2285,7 +2285,8 @@ union bpf_attr {
  *	Return
  *		Pointer to **struct bpf_sock**, or **NULL** in case of failure.
  *		For sockets with reuseport option, the **struct bpf_sock**
- *		result is from **reuse->socks**\ [] using the hash of the tuple.
+ *		result is from *reuse*\ **->socks**\ [] using the hash of the
+ *		tuple.
  *
  * struct bpf_sock *bpf_sk_lookup_udp(void *ctx, struct bpf_sock_tuple *tuple, u32 tuple_size, u64 netns, u64 flags)
  *	Description
@@ -2321,7 +2322,8 @@ union bpf_attr {
  *	Return
  *		Pointer to **struct bpf_sock**, or **NULL** in case of failure.
  *		For sockets with reuseport option, the **struct bpf_sock**
- *		result is from **reuse->socks**\ [] using the hash of the tuple.
+ *		result is from *reuse*\ **->socks**\ [] using the hash of the
+ *		tuple.
  *
  * int bpf_sk_release(struct bpf_sock *sock)
  *	Description
@@ -2490,31 +2492,34 @@ union bpf_attr {
  *		network namespace *netns*. The return value must be checked,
  *		and if non-**NULL**, released via **bpf_sk_release**\ ().
  *
- *		This function is identical to bpf_sk_lookup_tcp, except that it
- *		also returns timewait or request sockets. Use bpf_sk_fullsock
- *		or bpf_tcp_socket to access the full structure.
+ *		This function is identical to **bpf_sk_lookup_tcp**\ (), except
+ *		that it also returns timewait or request sockets. Use
+ *		**bpf_sk_fullsock**\ () or **bpf_tcp_sock**\ () to access the
+ *		full structure.
  *
  *		This helper is available only if the kernel was compiled with
  *		**CONFIG_NET** configuration option.
  *	Return
  *		Pointer to **struct bpf_sock**, or **NULL** in case of failure.
  *		For sockets with reuseport option, the **struct bpf_sock**
- *		result is from **reuse->socks**\ [] using the hash of the tuple.
+ *		result is from *reuse*\ **->socks**\ [] using the hash of the
+ *		tuple.
  *
  * int bpf_tcp_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
  * 	Description
- * 		Check whether iph and th contain a valid SYN cookie ACK for
- * 		the listening socket in sk.
+ * 		Check whether *iph* and *th* contain a valid SYN cookie ACK for
+ * 		the listening socket in *sk*.
  *
- * 		iph points to the start of the IPv4 or IPv6 header, while
- * 		iph_len contains sizeof(struct iphdr) or sizeof(struct ip6hdr).
+ * 		*iph* points to the start of the IPv4 or IPv6 header, while
+ * 		*iph_len* contains **sizeof**\ (**struct iphdr**) or
+ * 		**sizeof**\ (**struct ip6hdr**).
  *
- * 		th points to the start of the TCP header, while th_len contains
- * 		sizeof(struct tcphdr).
+ * 		*th* points to the start of the TCP header, while *th_len*
+ * 		contains **sizeof**\ (**struct tcphdr**).
  *
  * 	Return
- * 		0 if iph and th are a valid SYN cookie ACK, or a negative error
- * 		otherwise.
+ * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
+ * 		error otherwise.
  *
  * int bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf_len, u64 flags)
  *	Description
@@ -2592,17 +2597,17 @@ union bpf_attr {
  *		and save the result in *res*.
  *
  *		The string may begin with an arbitrary amount of white space
- *		(as determined by isspace(3)) followed by a single optional '-'
- *		sign.
+ *		(as determined by **isspace**\ (3)) followed by a single
+ *		optional '**-**' sign.
  *
  *		Five least significant bits of *flags* encode base, other bits
  *		are currently unused.
  *
  *		Base must be either 8, 10, 16 or 0 to detect it automatically
- *		similar to user space strtol(3).
+ *		similar to user space **strtol**\ (3).
  *	Return
  *		Number of characters consumed on success. Must be positive but
- *		no more than buf_len.
+ *		no more than *buf_len*.
  *
  *		**-EINVAL** if no valid digits were found or unsupported base
  *		was provided.
@@ -2616,16 +2621,16 @@ union bpf_attr {
  *		given base and save the result in *res*.
  *
  *		The string may begin with an arbitrary amount of white space
- *		(as determined by isspace(3)).
+ *		(as determined by **isspace**\ (3)).
  *
  *		Five least significant bits of *flags* encode base, other bits
  *		are currently unused.
  *
  *		Base must be either 8, 10, 16 or 0 to detect it automatically
- *		similar to user space strtoul(3).
+ *		similar to user space **strtoul**\ (3).
  *	Return
  *		Number of characters consumed on success. Must be positive but
- *		no more than buf_len.
+ *		no more than *buf_len*.
  *
  *		**-EINVAL** if no valid digits were found or unsupported base
  *		was provided.
@@ -2634,26 +2639,26 @@ union bpf_attr {
  *
  * void *bpf_sk_storage_get(struct bpf_map *map, struct bpf_sock *sk, void *value, u64 flags)
  *	Description
- *		Get a bpf-local-storage from a sk.
+ *		Get a bpf-local-storage from a *sk*.
  *
  *		Logically, it could be thought of getting the value from
  *		a *map* with *sk* as the **key**.  From this
  *		perspective,  the usage is not much different from
- *		**bpf_map_lookup_elem(map, &sk)** except this
- *		helper enforces the key must be a **bpf_fullsock()**
- *		and the map must be a BPF_MAP_TYPE_SK_STORAGE also.
+ *		**bpf_map_lookup_elem**\ (*map*, **&**\ *sk*) except this
+ *		helper enforces the key must be a full socket and the map must
+ *		be a **BPF_MAP_TYPE_SK_STORAGE** also.
  *
  *		Underneath, the value is stored locally at *sk* instead of
- *		the map.  The *map* is used as the bpf-local-storage **type**.
- *		The bpf-local-storage **type** (i.e. the *map*) is searched
- *		against all bpf-local-storages residing at sk.
+ *		the *map*.  The *map* is used as the bpf-local-storage
+ *		"type". The bpf-local-storage "type" (i.e. the *map*) is
+ *		searched against all bpf-local-storages residing at *sk*.
  *
- *		An optional *flags* (BPF_SK_STORAGE_GET_F_CREATE) can be
+ *		An optional *flags* (**BPF_SK_STORAGE_GET_F_CREATE**) can be
  *		used such that a new bpf-local-storage will be
  *		created if one does not exist.  *value* can be used
- *		together with BPF_SK_STORAGE_GET_F_CREATE to specify
+ *		together with **BPF_SK_STORAGE_GET_F_CREATE** to specify
  *		the initial value of a bpf-local-storage.  If *value* is
- *		NULL, the new bpf-local-storage will be zero initialized.
+ *		**NULL**, the new bpf-local-storage will be zero initialized.
  *	Return
  *		A bpf-local-storage pointer is returned on success.
  *
@@ -2662,7 +2667,7 @@ union bpf_attr {
  *
  * int bpf_sk_storage_delete(struct bpf_map *map, struct bpf_sock *sk)
  *	Description
- *		Delete a bpf-local-storage from a sk.
+ *		Delete a bpf-local-storage from a *sk*.
  *	Return
  *		0 on success.
  *
-- 
2.14.1

