Return-Path: <netdev+bounces-2255-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DCDD700EA7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:22:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B09D41C212E6
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D161E53F;
	Fri, 12 May 2023 18:22:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3841E519
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 18:22:49 +0000 (UTC)
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71510D850
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:22:09 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5301ed4ba6bso4079814a12.1
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683915727; x=1686507727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ecjJ7O+Mzotkif8qEpSvDOQyNOxY/QN8mV6roFLc+zA=;
        b=ujeh8deGpv41AOLGcRm1/L1t4pd75Tx1FAu4bzT87poyz260T0rXIIti8bLPYqSBUj
         Kav2BTf9SXfcy7Gx6WvdoviOLkyCAcqM0JqxFlwttGUReeO30mn8ZS4Qk+y2D9TNcR1H
         zEB1SKmOkkAY2Kxqc7RQAocyOBXzzfm2/MuSny4Ocbf5q+WSaPxBlSIMSNKSvy9nLqO9
         coJRSPPNwRqNTXmPjB9qOgF7H/lNhSpDQW/yHhtfLAX/kT9G3075Q8QRJWi1AjEBD4gV
         hjL0heA3+cPhg/zG+CVwRhMaLpZ4zzfa7V8F6NnOEfuQvyqh1hkH8axU9cDU3ao6SKSB
         fHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683915727; x=1686507727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ecjJ7O+Mzotkif8qEpSvDOQyNOxY/QN8mV6roFLc+zA=;
        b=lu3ec9boj8Ae1OPMp6M6MXTSiwabVCSoHSWy+lU9qZn+w1Gc9rqapFUl/OAb921QxT
         Oqjzx2nohKOKtRXRiC2oQdoQZ54ec+GKME/HG+5fRAalfbqy7lIvqtRNr9slv24t7l3Y
         Cos5AZ8TMgJtvWzP8CI14yb/VlKNFDXJYKGKsubE1VR/5yJPYUnZT9QmTDzydp7YZS6o
         eqBpjdyQr3vLBjW0hCl8ZFURo0YGC/tZHT2ZsuMJAWaKUjfeefeVM/y60cPb9CFi1fqm
         rXDD0DZL6PPmXLJul3usHQh4n4e/UH/GW7bH1IgjIjJ9xWreQ2y15kAvJMHQ/Qn5yGt3
         +MLA==
X-Gm-Message-State: AC+VfDwoIiPDfl2zxH+vFuv7Cnb+kmWyBAUZRCGTfwVKSUKx7vm32d9R
	Bie0bx9h4DPN5IrunG+vsysujPg=
X-Google-Smtp-Source: ACHHUZ67zK47QOPLujTPjQy94v3FKoMHqiX7ZF9Oj000h56nskjuWoy5itwibeE2sKEE72uCldU5/ww=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a63:2782:0:b0:530:866e:c3c0 with SMTP id
 n124-20020a632782000000b00530866ec3c0mr1521319pgn.10.1683915727429; Fri, 12
 May 2023 11:22:07 -0700 (PDT)
Date: Fri, 12 May 2023 11:22:05 -0700
In-Reply-To: <20230512152607.992209-8-larysa.zaremba@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230512152607.992209-1-larysa.zaremba@intel.com> <20230512152607.992209-8-larysa.zaremba@intel.com>
Message-ID: <ZF6DzbBlhOyIa+3N@google.com>
Subject: Re: [PATCH RESEND bpf-next 07/15] ice: Support RX hash XDP hint
From: Stanislav Fomichev <sdf@google.com>
To: Larysa Zaremba <larysa.zaremba@intel.com>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Jiri Olsa <jolsa@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Anatoly Burakov <anatoly.burakov@intel.com>, 
	Jesper Dangaard Brouer <brouer@redhat.com>, Alexander Lobakin <alexandr.lobakin@intel.com>, 
	Magnus Karlsson <magnus.karlsson@gmail.com>, Maryam Tahhan <mtahhan@redhat.com>, 
	xdp-hints@xdp-project.net, netdev@vger.kernel.org, 
	intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/12, Larysa Zaremba wrote:
> RX hash XDP hint requests both hash value and type.
> Type is XDP-specific, so we need a separate way to map
> these values to the hardware ptypes, so create a lookup table.
> 
> Instead of creating a new long list, reuse contents
> of ice_decode_rx_desc_ptype[] through preprocessor.
> 
> Current hash type enum does not contain ICMP packet type,
> but ice devices support it, so also add a new type into core code.
> 
> Then use previously refactored code and create a function
> that allows XDP code to read RX hash.
> 
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> ---
>  .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 412 +++++++++---------
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  72 +++
>  include/net/xdp.h                             |   3 +
>  3 files changed, 283 insertions(+), 204 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
> index 89f986a75cc8..d384ddfcb83e 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
> +++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
> @@ -673,6 +673,212 @@ struct ice_tlan_ctx {
>   *      Use the enum ice_rx_l2_ptype to decode the packet type
>   * ENDIF
>   */
> +#define ICE_PTYPES								\
> +	/* L2 Packet types */							\
> +	ICE_PTT_UNUSED_ENTRY(0),						\
> +	ICE_PTT(1, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),			\
> +	ICE_PTT_UNUSED_ENTRY(2),						\
> +	ICE_PTT_UNUSED_ENTRY(3),						\
> +	ICE_PTT_UNUSED_ENTRY(4),						\
> +	ICE_PTT_UNUSED_ENTRY(5),						\
> +	ICE_PTT(6, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),			\
> +	ICE_PTT(7, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),			\
> +	ICE_PTT_UNUSED_ENTRY(8),						\
> +	ICE_PTT_UNUSED_ENTRY(9),						\
> +	ICE_PTT(10, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),		\
> +	ICE_PTT(11, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),		\
> +	ICE_PTT_UNUSED_ENTRY(12),						\
> +	ICE_PTT_UNUSED_ENTRY(13),						\
> +	ICE_PTT_UNUSED_ENTRY(14),						\
> +	ICE_PTT_UNUSED_ENTRY(15),						\
> +	ICE_PTT_UNUSED_ENTRY(16),						\
> +	ICE_PTT_UNUSED_ENTRY(17),						\
> +	ICE_PTT_UNUSED_ENTRY(18),						\
> +	ICE_PTT_UNUSED_ENTRY(19),						\
> +	ICE_PTT_UNUSED_ENTRY(20),						\
> +	ICE_PTT_UNUSED_ENTRY(21),						\
> +										\
> +	/* Non Tunneled IPv4 */							\
> +	ICE_PTT(22, IP, IPV4, FRG, NONE, NONE, NOF, NONE, PAY3),		\
> +	ICE_PTT(23, IP, IPV4, NOF, NONE, NONE, NOF, NONE, PAY3),		\
> +	ICE_PTT(24, IP, IPV4, NOF, NONE, NONE, NOF, UDP,  PAY4),		\
> +	ICE_PTT_UNUSED_ENTRY(25),						\
> +	ICE_PTT(26, IP, IPV4, NOF, NONE, NONE, NOF, TCP,  PAY4),		\
> +	ICE_PTT(27, IP, IPV4, NOF, NONE, NONE, NOF, SCTP, PAY4),		\
> +	ICE_PTT(28, IP, IPV4, NOF, NONE, NONE, NOF, ICMP, PAY4),		\
> +										\
> +	/* IPv4 --> IPv4 */							\
> +	ICE_PTT(29, IP, IPV4, NOF, IP_IP, IPV4, FRG, NONE, PAY3),		\
> +	ICE_PTT(30, IP, IPV4, NOF, IP_IP, IPV4, NOF, NONE, PAY3),		\
> +	ICE_PTT(31, IP, IPV4, NOF, IP_IP, IPV4, NOF, UDP,  PAY4),		\
> +	ICE_PTT_UNUSED_ENTRY(32),						\
> +	ICE_PTT(33, IP, IPV4, NOF, IP_IP, IPV4, NOF, TCP,  PAY4),		\
> +	ICE_PTT(34, IP, IPV4, NOF, IP_IP, IPV4, NOF, SCTP, PAY4),		\
> +	ICE_PTT(35, IP, IPV4, NOF, IP_IP, IPV4, NOF, ICMP, PAY4),		\
> +										\
> +	/* IPv4 --> IPv6 */							\
> +	ICE_PTT(36, IP, IPV4, NOF, IP_IP, IPV6, FRG, NONE, PAY3),		\
> +	ICE_PTT(37, IP, IPV4, NOF, IP_IP, IPV6, NOF, NONE, PAY3),		\
> +	ICE_PTT(38, IP, IPV4, NOF, IP_IP, IPV6, NOF, UDP,  PAY4),		\
> +	ICE_PTT_UNUSED_ENTRY(39),						\
> +	ICE_PTT(40, IP, IPV4, NOF, IP_IP, IPV6, NOF, TCP,  PAY4),		\
> +	ICE_PTT(41, IP, IPV4, NOF, IP_IP, IPV6, NOF, SCTP, PAY4),		\
> +	ICE_PTT(42, IP, IPV4, NOF, IP_IP, IPV6, NOF, ICMP, PAY4),		\
> +										\
> +	/* IPv4 --> GRE/NAT */							\
> +	ICE_PTT(43, IP, IPV4, NOF, IP_GRENAT, NONE, NOF, NONE, PAY3),		\
> +										\
> +	/* IPv4 --> GRE/NAT --> IPv4 */						\
> +	ICE_PTT(44, IP, IPV4, NOF, IP_GRENAT, IPV4, FRG, NONE, PAY3),		\
> +	ICE_PTT(45, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, NONE, PAY3),		\
> +	ICE_PTT(46, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, UDP,  PAY4),		\
> +	ICE_PTT_UNUSED_ENTRY(47),						\
> +	ICE_PTT(48, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, TCP,  PAY4),		\
> +	ICE_PTT(49, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, SCTP, PAY4),		\
> +	ICE_PTT(50, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, ICMP, PAY4),		\
> +										\
> +	/* IPv4 --> GRE/NAT --> IPv6 */						\
> +	ICE_PTT(51, IP, IPV4, NOF, IP_GRENAT, IPV6, FRG, NONE, PAY3),		\
> +	ICE_PTT(52, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, NONE, PAY3),		\
> +	ICE_PTT(53, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, UDP,  PAY4),		\
> +	ICE_PTT_UNUSED_ENTRY(54),						\
> +	ICE_PTT(55, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, TCP,  PAY4),		\
> +	ICE_PTT(56, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, SCTP, PAY4),		\
> +	ICE_PTT(57, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, ICMP, PAY4),		\
> +										\
> +	/* IPv4 --> GRE/NAT --> MAC */						\
> +	ICE_PTT(58, IP, IPV4, NOF, IP_GRENAT_MAC, NONE, NOF, NONE, PAY3),	\
> +										\
> +	/* IPv4 --> GRE/NAT --> MAC --> IPv4 */					\
> +	ICE_PTT(59, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, FRG, NONE, PAY3),	\
> +	ICE_PTT(60, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, NONE, PAY3),	\
> +	ICE_PTT(61, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, UDP,  PAY4),	\
> +	ICE_PTT_UNUSED_ENTRY(62),						\
> +	ICE_PTT(63, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, TCP,  PAY4),	\
> +	ICE_PTT(64, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, SCTP, PAY4),	\
> +	ICE_PTT(65, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, ICMP, PAY4),	\
> +										\
> +	/* IPv4 --> GRE/NAT -> MAC --> IPv6 */					\
> +	ICE_PTT(66, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, FRG, NONE, PAY3),	\
> +	ICE_PTT(67, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, NONE, PAY3),	\
> +	ICE_PTT(68, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, UDP,  PAY4),	\
> +	ICE_PTT_UNUSED_ENTRY(69),						\
> +	ICE_PTT(70, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, TCP,  PAY4),	\
> +	ICE_PTT(71, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, SCTP, PAY4),	\
> +	ICE_PTT(72, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, ICMP, PAY4),	\
> +										\
> +	/* IPv4 --> GRE/NAT --> MAC/VLAN */					\
> +	ICE_PTT(73, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, NONE, NOF, NONE, PAY3),	\
> +										\
> +	/* IPv4 ---> GRE/NAT -> MAC/VLAN --> IPv4 */				\
> +	ICE_PTT(74, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, FRG, NONE, PAY3),	\
> +	ICE_PTT(75, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, NONE, PAY3),	\
> +	ICE_PTT(76, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, UDP,  PAY4),	\
> +	ICE_PTT_UNUSED_ENTRY(77),						\
> +	ICE_PTT(78, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, TCP,  PAY4),	\
> +	ICE_PTT(79, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, SCTP, PAY4),	\
> +	ICE_PTT(80, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, ICMP, PAY4),	\
> +										\
> +	/* IPv4 -> GRE/NAT -> MAC/VLAN --> IPv6 */				\
> +	ICE_PTT(81, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, FRG, NONE, PAY3),	\
> +	ICE_PTT(82, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, NONE, PAY3),	\
> +	ICE_PTT(83, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, UDP,  PAY4),	\
> +	ICE_PTT_UNUSED_ENTRY(84),						\
> +	ICE_PTT(85, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, TCP,  PAY4),	\
> +	ICE_PTT(86, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, SCTP, PAY4),	\
> +	ICE_PTT(87, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),	\
> +										\
> +	/* Non Tunneled IPv6 */							\
> +	ICE_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),		\
> +	ICE_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),		\
> +	ICE_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),		\
> +	ICE_PTT_UNUSED_ENTRY(91),						\
> +	ICE_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),		\
> +	ICE_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),		\
> +	ICE_PTT(94, IP, IPV6, NOF, NONE, NONE, NOF, ICMP, PAY4),		\
> +										\
> +	/* IPv6 --> IPv4 */							\
> +	ICE_PTT(95, IP, IPV6, NOF, IP_IP, IPV4, FRG, NONE, PAY3),		\
> +	ICE_PTT(96, IP, IPV6, NOF, IP_IP, IPV4, NOF, NONE, PAY3),		\
> +	ICE_PTT(97, IP, IPV6, NOF, IP_IP, IPV4, NOF, UDP,  PAY4),		\
> +	ICE_PTT_UNUSED_ENTRY(98),						\
> +	ICE_PTT(99, IP, IPV6, NOF, IP_IP, IPV4, NOF, TCP,  PAY4),		\
> +	ICE_PTT(100, IP, IPV6, NOF, IP_IP, IPV4, NOF, SCTP, PAY4),		\
> +	ICE_PTT(101, IP, IPV6, NOF, IP_IP, IPV4, NOF, ICMP, PAY4),		\
> +										\
> +	/* IPv6 --> IPv6 */							\
> +	ICE_PTT(102, IP, IPV6, NOF, IP_IP, IPV6, FRG, NONE, PAY3),		\
> +	ICE_PTT(103, IP, IPV6, NOF, IP_IP, IPV6, NOF, NONE, PAY3),		\
> +	ICE_PTT(104, IP, IPV6, NOF, IP_IP, IPV6, NOF, UDP,  PAY4),		\
> +	ICE_PTT_UNUSED_ENTRY(105),						\
> +	ICE_PTT(106, IP, IPV6, NOF, IP_IP, IPV6, NOF, TCP,  PAY4),		\
> +	ICE_PTT(107, IP, IPV6, NOF, IP_IP, IPV6, NOF, SCTP, PAY4),		\
> +	ICE_PTT(108, IP, IPV6, NOF, IP_IP, IPV6, NOF, ICMP, PAY4),		\
> +										\
> +	/* IPv6 --> GRE/NAT */							\
> +	ICE_PTT(109, IP, IPV6, NOF, IP_GRENAT, NONE, NOF, NONE, PAY3),		\
> +										\
> +	/* IPv6 --> GRE/NAT -> IPv4 */						\
> +	ICE_PTT(110, IP, IPV6, NOF, IP_GRENAT, IPV4, FRG, NONE, PAY3),		\
> +	ICE_PTT(111, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, NONE, PAY3),		\
> +	ICE_PTT(112, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, UDP,  PAY4),		\
> +	ICE_PTT_UNUSED_ENTRY(113),						\
> +	ICE_PTT(114, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, TCP,  PAY4),		\
> +	ICE_PTT(115, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, SCTP, PAY4),		\
> +	ICE_PTT(116, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, ICMP, PAY4),		\
> +										\
> +	/* IPv6 --> GRE/NAT -> IPv6 */						\
> +	ICE_PTT(117, IP, IPV6, NOF, IP_GRENAT, IPV6, FRG, NONE, PAY3),		\
> +	ICE_PTT(118, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, NONE, PAY3),		\
> +	ICE_PTT(119, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, UDP,  PAY4),		\
> +	ICE_PTT_UNUSED_ENTRY(120),						\
> +	ICE_PTT(121, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, TCP,  PAY4),		\
> +	ICE_PTT(122, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, SCTP, PAY4),		\
> +	ICE_PTT(123, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, ICMP, PAY4),		\
> +										\
> +	/* IPv6 --> GRE/NAT -> MAC */						\
> +	ICE_PTT(124, IP, IPV6, NOF, IP_GRENAT_MAC, NONE, NOF, NONE, PAY3),	\
> +										\
> +	/* IPv6 --> GRE/NAT -> MAC -> IPv4 */					\
> +	ICE_PTT(125, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, FRG, NONE, PAY3),	\
> +	ICE_PTT(126, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, NONE, PAY3),	\
> +	ICE_PTT(127, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, UDP,  PAY4),	\
> +	ICE_PTT_UNUSED_ENTRY(128),						\
> +	ICE_PTT(129, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, TCP,  PAY4),	\
> +	ICE_PTT(130, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, SCTP, PAY4),	\
> +	ICE_PTT(131, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, ICMP, PAY4),	\
> +										\
> +	/* IPv6 --> GRE/NAT -> MAC -> IPv6 */					\
> +	ICE_PTT(132, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, FRG, NONE, PAY3),	\
> +	ICE_PTT(133, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, NONE, PAY3),	\
> +	ICE_PTT(134, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, UDP,  PAY4),	\
> +	ICE_PTT_UNUSED_ENTRY(135),						\
> +	ICE_PTT(136, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, TCP,  PAY4),	\
> +	ICE_PTT(137, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, SCTP, PAY4),	\
> +	ICE_PTT(138, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, ICMP, PAY4),	\
> +										\
> +	/* IPv6 --> GRE/NAT -> MAC/VLAN */					\
> +	ICE_PTT(139, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, NONE, NOF, NONE, PAY3),	\
> +										\
> +	/* IPv6 --> GRE/NAT -> MAC/VLAN --> IPv4 */				\
> +	ICE_PTT(140, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, FRG, NONE, PAY3),	\
> +	ICE_PTT(141, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, NONE, PAY3),	\
> +	ICE_PTT(142, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, UDP,  PAY4),	\
> +	ICE_PTT_UNUSED_ENTRY(143),						\
> +	ICE_PTT(144, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, TCP,  PAY4),	\
> +	ICE_PTT(145, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, SCTP, PAY4),	\
> +	ICE_PTT(146, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, ICMP, PAY4),	\
> +										\
> +	/* IPv6 --> GRE/NAT -> MAC/VLAN --> IPv6 */				\
> +	ICE_PTT(147, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, FRG, NONE, PAY3),	\
> +	ICE_PTT(148, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, NONE, PAY3),	\
> +	ICE_PTT(149, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, UDP,  PAY4),	\
> +	ICE_PTT_UNUSED_ENTRY(150),						\
> +	ICE_PTT(151, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, TCP,  PAY4),	\
> +	ICE_PTT(152, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, SCTP, PAY4),	\
> +	ICE_PTT(153, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
> +
> +#define ICE_NUM_DEFINED_PTYPES	154
>  
>  /* macro to make the table lines short, use explicit indexing with [PTYPE] */
>  #define ICE_PTT(PTYPE, OUTER_IP, OUTER_IP_VER, OUTER_FRAG, T, TE, TEF, I, PL)\
> @@ -695,212 +901,10 @@ struct ice_tlan_ctx {
>  
>  /* Lookup table mapping in the 10-bit HW PTYPE to the bit field for decoding */
>  static const struct ice_rx_ptype_decoded ice_ptype_lkup[BIT(10)] = {
> -	/* L2 Packet types */
> -	ICE_PTT_UNUSED_ENTRY(0),
> -	ICE_PTT(1, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
> -	ICE_PTT_UNUSED_ENTRY(2),
> -	ICE_PTT_UNUSED_ENTRY(3),
> -	ICE_PTT_UNUSED_ENTRY(4),
> -	ICE_PTT_UNUSED_ENTRY(5),
> -	ICE_PTT(6, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
> -	ICE_PTT(7, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
> -	ICE_PTT_UNUSED_ENTRY(8),
> -	ICE_PTT_UNUSED_ENTRY(9),
> -	ICE_PTT(10, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
> -	ICE_PTT(11, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
> -	ICE_PTT_UNUSED_ENTRY(12),
> -	ICE_PTT_UNUSED_ENTRY(13),
> -	ICE_PTT_UNUSED_ENTRY(14),
> -	ICE_PTT_UNUSED_ENTRY(15),
> -	ICE_PTT_UNUSED_ENTRY(16),
> -	ICE_PTT_UNUSED_ENTRY(17),
> -	ICE_PTT_UNUSED_ENTRY(18),
> -	ICE_PTT_UNUSED_ENTRY(19),
> -	ICE_PTT_UNUSED_ENTRY(20),
> -	ICE_PTT_UNUSED_ENTRY(21),
> -
> -	/* Non Tunneled IPv4 */
> -	ICE_PTT(22, IP, IPV4, FRG, NONE, NONE, NOF, NONE, PAY3),
> -	ICE_PTT(23, IP, IPV4, NOF, NONE, NONE, NOF, NONE, PAY3),
> -	ICE_PTT(24, IP, IPV4, NOF, NONE, NONE, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(25),
> -	ICE_PTT(26, IP, IPV4, NOF, NONE, NONE, NOF, TCP,  PAY4),
> -	ICE_PTT(27, IP, IPV4, NOF, NONE, NONE, NOF, SCTP, PAY4),
> -	ICE_PTT(28, IP, IPV4, NOF, NONE, NONE, NOF, ICMP, PAY4),
> -
> -	/* IPv4 --> IPv4 */
> -	ICE_PTT(29, IP, IPV4, NOF, IP_IP, IPV4, FRG, NONE, PAY3),
> -	ICE_PTT(30, IP, IPV4, NOF, IP_IP, IPV4, NOF, NONE, PAY3),
> -	ICE_PTT(31, IP, IPV4, NOF, IP_IP, IPV4, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(32),
> -	ICE_PTT(33, IP, IPV4, NOF, IP_IP, IPV4, NOF, TCP,  PAY4),
> -	ICE_PTT(34, IP, IPV4, NOF, IP_IP, IPV4, NOF, SCTP, PAY4),
> -	ICE_PTT(35, IP, IPV4, NOF, IP_IP, IPV4, NOF, ICMP, PAY4),
> -
> -	/* IPv4 --> IPv6 */
> -	ICE_PTT(36, IP, IPV4, NOF, IP_IP, IPV6, FRG, NONE, PAY3),
> -	ICE_PTT(37, IP, IPV4, NOF, IP_IP, IPV6, NOF, NONE, PAY3),
> -	ICE_PTT(38, IP, IPV4, NOF, IP_IP, IPV6, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(39),
> -	ICE_PTT(40, IP, IPV4, NOF, IP_IP, IPV6, NOF, TCP,  PAY4),
> -	ICE_PTT(41, IP, IPV4, NOF, IP_IP, IPV6, NOF, SCTP, PAY4),
> -	ICE_PTT(42, IP, IPV4, NOF, IP_IP, IPV6, NOF, ICMP, PAY4),
> -
> -	/* IPv4 --> GRE/NAT */
> -	ICE_PTT(43, IP, IPV4, NOF, IP_GRENAT, NONE, NOF, NONE, PAY3),
> -
> -	/* IPv4 --> GRE/NAT --> IPv4 */
> -	ICE_PTT(44, IP, IPV4, NOF, IP_GRENAT, IPV4, FRG, NONE, PAY3),
> -	ICE_PTT(45, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, NONE, PAY3),
> -	ICE_PTT(46, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(47),
> -	ICE_PTT(48, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, TCP,  PAY4),
> -	ICE_PTT(49, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, SCTP, PAY4),
> -	ICE_PTT(50, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, ICMP, PAY4),
> -
> -	/* IPv4 --> GRE/NAT --> IPv6 */
> -	ICE_PTT(51, IP, IPV4, NOF, IP_GRENAT, IPV6, FRG, NONE, PAY3),
> -	ICE_PTT(52, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, NONE, PAY3),
> -	ICE_PTT(53, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(54),
> -	ICE_PTT(55, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, TCP,  PAY4),
> -	ICE_PTT(56, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, SCTP, PAY4),
> -	ICE_PTT(57, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, ICMP, PAY4),
> -
> -	/* IPv4 --> GRE/NAT --> MAC */
> -	ICE_PTT(58, IP, IPV4, NOF, IP_GRENAT_MAC, NONE, NOF, NONE, PAY3),
> -
> -	/* IPv4 --> GRE/NAT --> MAC --> IPv4 */
> -	ICE_PTT(59, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, FRG, NONE, PAY3),
> -	ICE_PTT(60, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, NONE, PAY3),
> -	ICE_PTT(61, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(62),
> -	ICE_PTT(63, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, TCP,  PAY4),
> -	ICE_PTT(64, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, SCTP, PAY4),
> -	ICE_PTT(65, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, ICMP, PAY4),
> -
> -	/* IPv4 --> GRE/NAT -> MAC --> IPv6 */
> -	ICE_PTT(66, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, FRG, NONE, PAY3),
> -	ICE_PTT(67, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, NONE, PAY3),
> -	ICE_PTT(68, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(69),
> -	ICE_PTT(70, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, TCP,  PAY4),
> -	ICE_PTT(71, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, SCTP, PAY4),
> -	ICE_PTT(72, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, ICMP, PAY4),
> -
> -	/* IPv4 --> GRE/NAT --> MAC/VLAN */
> -	ICE_PTT(73, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, NONE, NOF, NONE, PAY3),
> -
> -	/* IPv4 ---> GRE/NAT -> MAC/VLAN --> IPv4 */
> -	ICE_PTT(74, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, FRG, NONE, PAY3),
> -	ICE_PTT(75, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, NONE, PAY3),
> -	ICE_PTT(76, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(77),
> -	ICE_PTT(78, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, TCP,  PAY4),
> -	ICE_PTT(79, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, SCTP, PAY4),
> -	ICE_PTT(80, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, ICMP, PAY4),
> -
> -	/* IPv4 -> GRE/NAT -> MAC/VLAN --> IPv6 */
> -	ICE_PTT(81, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, FRG, NONE, PAY3),
> -	ICE_PTT(82, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, NONE, PAY3),
> -	ICE_PTT(83, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(84),
> -	ICE_PTT(85, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, TCP,  PAY4),
> -	ICE_PTT(86, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, SCTP, PAY4),
> -	ICE_PTT(87, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
> -
> -	/* Non Tunneled IPv6 */
> -	ICE_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
> -	ICE_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
> -	ICE_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(91),
> -	ICE_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
> -	ICE_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
> -	ICE_PTT(94, IP, IPV6, NOF, NONE, NONE, NOF, ICMP, PAY4),
> -
> -	/* IPv6 --> IPv4 */
> -	ICE_PTT(95, IP, IPV6, NOF, IP_IP, IPV4, FRG, NONE, PAY3),
> -	ICE_PTT(96, IP, IPV6, NOF, IP_IP, IPV4, NOF, NONE, PAY3),
> -	ICE_PTT(97, IP, IPV6, NOF, IP_IP, IPV4, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(98),
> -	ICE_PTT(99, IP, IPV6, NOF, IP_IP, IPV4, NOF, TCP,  PAY4),
> -	ICE_PTT(100, IP, IPV6, NOF, IP_IP, IPV4, NOF, SCTP, PAY4),
> -	ICE_PTT(101, IP, IPV6, NOF, IP_IP, IPV4, NOF, ICMP, PAY4),
> -
> -	/* IPv6 --> IPv6 */
> -	ICE_PTT(102, IP, IPV6, NOF, IP_IP, IPV6, FRG, NONE, PAY3),
> -	ICE_PTT(103, IP, IPV6, NOF, IP_IP, IPV6, NOF, NONE, PAY3),
> -	ICE_PTT(104, IP, IPV6, NOF, IP_IP, IPV6, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(105),
> -	ICE_PTT(106, IP, IPV6, NOF, IP_IP, IPV6, NOF, TCP,  PAY4),
> -	ICE_PTT(107, IP, IPV6, NOF, IP_IP, IPV6, NOF, SCTP, PAY4),
> -	ICE_PTT(108, IP, IPV6, NOF, IP_IP, IPV6, NOF, ICMP, PAY4),
> -
> -	/* IPv6 --> GRE/NAT */
> -	ICE_PTT(109, IP, IPV6, NOF, IP_GRENAT, NONE, NOF, NONE, PAY3),
> -
> -	/* IPv6 --> GRE/NAT -> IPv4 */
> -	ICE_PTT(110, IP, IPV6, NOF, IP_GRENAT, IPV4, FRG, NONE, PAY3),
> -	ICE_PTT(111, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, NONE, PAY3),
> -	ICE_PTT(112, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(113),
> -	ICE_PTT(114, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, TCP,  PAY4),
> -	ICE_PTT(115, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, SCTP, PAY4),
> -	ICE_PTT(116, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, ICMP, PAY4),
> -
> -	/* IPv6 --> GRE/NAT -> IPv6 */
> -	ICE_PTT(117, IP, IPV6, NOF, IP_GRENAT, IPV6, FRG, NONE, PAY3),
> -	ICE_PTT(118, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, NONE, PAY3),
> -	ICE_PTT(119, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(120),
> -	ICE_PTT(121, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, TCP,  PAY4),
> -	ICE_PTT(122, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, SCTP, PAY4),
> -	ICE_PTT(123, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, ICMP, PAY4),
> -
> -	/* IPv6 --> GRE/NAT -> MAC */
> -	ICE_PTT(124, IP, IPV6, NOF, IP_GRENAT_MAC, NONE, NOF, NONE, PAY3),
> -
> -	/* IPv6 --> GRE/NAT -> MAC -> IPv4 */
> -	ICE_PTT(125, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, FRG, NONE, PAY3),
> -	ICE_PTT(126, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, NONE, PAY3),
> -	ICE_PTT(127, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(128),
> -	ICE_PTT(129, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, TCP,  PAY4),
> -	ICE_PTT(130, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, SCTP, PAY4),
> -	ICE_PTT(131, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, ICMP, PAY4),
> -
> -	/* IPv6 --> GRE/NAT -> MAC -> IPv6 */
> -	ICE_PTT(132, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, FRG, NONE, PAY3),
> -	ICE_PTT(133, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, NONE, PAY3),
> -	ICE_PTT(134, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(135),
> -	ICE_PTT(136, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, TCP,  PAY4),
> -	ICE_PTT(137, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, SCTP, PAY4),
> -	ICE_PTT(138, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, ICMP, PAY4),
> -
> -	/* IPv6 --> GRE/NAT -> MAC/VLAN */
> -	ICE_PTT(139, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, NONE, NOF, NONE, PAY3),
> -
> -	/* IPv6 --> GRE/NAT -> MAC/VLAN --> IPv4 */
> -	ICE_PTT(140, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, FRG, NONE, PAY3),
> -	ICE_PTT(141, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, NONE, PAY3),
> -	ICE_PTT(142, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(143),
> -	ICE_PTT(144, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, TCP,  PAY4),
> -	ICE_PTT(145, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, SCTP, PAY4),
> -	ICE_PTT(146, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, ICMP, PAY4),
> -
> -	/* IPv6 --> GRE/NAT -> MAC/VLAN --> IPv6 */
> -	ICE_PTT(147, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, FRG, NONE, PAY3),
> -	ICE_PTT(148, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, NONE, PAY3),
> -	ICE_PTT(149, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, UDP,  PAY4),
> -	ICE_PTT_UNUSED_ENTRY(150),
> -	ICE_PTT(151, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, TCP,  PAY4),
> -	ICE_PTT(152, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, SCTP, PAY4),
> -	ICE_PTT(153, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
> +	ICE_PTYPES
>  
>  	/* unused entries */
> -	[154 ... 1023] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
> +	[ICE_NUM_DEFINED_PTYPES ... 1023] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
>  };
>  
>  static inline struct ice_rx_ptype_decoded ice_decode_rx_desc_ptype(u16 ptype)
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> index e9589cadf811..1caa73644e7b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> @@ -556,6 +556,78 @@ static int ice_xdp_rx_hw_ts(const struct xdp_md *ctx, u64 *ts_ns)
>  	return 0;
>  }
>  
> +/* Define a ptype index -> XDP hash type lookup table.
> + * It uses the same ptype definitions as ice_decode_rx_desc_ptype[],
> + * avoiding possible copy-paste errors.
> + */
> +#undef ICE_PTT
> +#undef ICE_PTT_UNUSED_ENTRY
> +
> +#define ICE_PTT(PTYPE, OUTER_IP, OUTER_IP_VER, OUTER_FRAG, T, TE, TEF, I, PL)\
> +	[PTYPE] = XDP_RSS_L3_##OUTER_IP_VER | XDP_RSS_L4_##I | XDP_RSS_TYPE_##PL
> +
> +#define ICE_PTT_UNUSED_ENTRY(PTYPE) [PTYPE] = 0
> +
> +/* A few supplementary definitions for when XDP hash types do not coincide
> + * with what can be generated from ptype definitions
> + * by means of preprocessor concatenation.
> + */
> +#define XDP_RSS_L3_NONE		XDP_RSS_TYPE_NONE
> +#define XDP_RSS_L4_NONE		XDP_RSS_TYPE_NONE
> +#define XDP_RSS_TYPE_PAY2	XDP_RSS_TYPE_L2
> +#define XDP_RSS_TYPE_PAY3	XDP_RSS_TYPE_NONE
> +#define XDP_RSS_TYPE_PAY4	XDP_RSS_L4
> +
> +static const enum xdp_rss_hash_type
> +ice_ptype_to_xdp_hash[ICE_NUM_DEFINED_PTYPES] = {
> +	ICE_PTYPES
> +};
> +
> +#undef XDP_RSS_L3_NONE
> +#undef XDP_RSS_L4_NONE
> +#undef XDP_RSS_TYPE_PAY2
> +#undef XDP_RSS_TYPE_PAY3
> +#undef XDP_RSS_TYPE_PAY4
> +
> +#undef ICE_PTT
> +#undef ICE_PTT_UNUSED_ENTRY
> +
> +/**
> + * ice_xdp_rx_hash_type - Get XDP-specific hash type from the RX descriptor
> + * @eop_desc: End of Packet descriptor
> + */
> +static enum xdp_rss_hash_type
> +ice_xdp_rx_hash_type(union ice_32b_rx_flex_desc *eop_desc)
> +{
> +	u16 ptype = ice_get_ptype(eop_desc);
> +
> +	if (unlikely(ptype >= ICE_NUM_DEFINED_PTYPES))
> +		return 0;
> +
> +	return ice_ptype_to_xdp_hash[ptype];
> +}
> +
> +/**
> + * ice_xdp_rx_hash - RX hash XDP hint handler
> + * @ctx: XDP buff pointer
> + * @hash: hash destination address
> + * @rss_type: XDP hash type destination address
> + *
> + * Copy RX hash (if available) and its type to the destination address.
> + */
> +static int ice_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
> +			   enum xdp_rss_hash_type *rss_type)
> +{
> +	const struct ice_xdp_buff *xdp_ext = (void *)ctx;
> +
> +	*rss_type = ice_xdp_rx_hash_type(xdp_ext->eop_desc);
> +	if (!ice_copy_rx_hash_from_desc(xdp_ext->eop_desc, hash))
> +		return -EOPNOTSUPP;

Same here? See the following for the context:
https://lore.kernel.org/bpf/167940675120.2718408.8176058626864184420.stgit@firesoul/

