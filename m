Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF501CAA18
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgEHLze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:55:34 -0400
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:6099
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbgEHLzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 07:55:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8EKIqkXvsLm3nE3UFTPzsu36tKFHaW0V7OyKcxnmwdvuaGl8owibQ+T9Fe/Q7DEIyVRtmhNRvEQPgmCdq5/nCBuFQSMQOVc11BbZF9R7ewRBw5x2HcQH6suBSYQU2lyZ6h/3s1U4ZBwGzU4xxj3KJk94KaKmy4MlrYxetlHmojrDUvheN9YR3uGEiEbrc+YpK1djJ6uRGKJvKJjjm0kjfQLOrLg7OV0oCE/YmEBVHzNdiTh9aqu9JV7ykh2Hn1Rv0C/xiOaLEGDAoNjQVSBD8bf3+JJKH8WHalkGqTi7GWBXzyZICfKV1BV78NXaQsz11vzAPNg18fIL4GPkS+y3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFScmQP1piVa3a6cUYQZVgH3N2GRl1eqSQJ7jt7K6q4=;
 b=Yr6x1a/E3wlye1P1KNJUn71wcl2hJaopiSe78Hb8sizedFoZZVmCJJ1APbGxg1xIEb4MpAMb8tEczezJmb6JpC3juobJgo9H8B5slGKiCXuEsJmS59mFL4AxgFnR9r3JjxfZ29bg5CsZBnQTeer4eCYkHfBW1CzdQemhaLHFf0okI/GZBi2FnHH/Pleh7q/mEAUKAOrMpoz0T70VJLxTIpRxtrpcUksvwFEs+BbmTa+bShrjQxyE8fGPG3Fcd6V8kwEgt4EGrvRuG1C9FNqfqHfV85ob5JsZkd0+ObhVzGd3o0yvpLcrrmsRDnQ8+xUySjQdmRdiWaQ/JGWueqWU2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFScmQP1piVa3a6cUYQZVgH3N2GRl1eqSQJ7jt7K6q4=;
 b=mqxd8bWWUf75ldowr6B7Mw+lFp93Ha1DHJ57TaaBsyOmRtUg/3R1/wrlc203MA8Vg2lNg0kNm0pvmAb9G+CQmMcTV8fxbCll0EHUKArs2SPXBIZgRpeeCNF9Sv4HVCTBstbJVRroRkmn4T/90KEVe+/UnyBBtK6ZPvZrL9bv/NA=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6632.eurprd05.prod.outlook.com (2603:10a6:20b:136::12)
 by AM7PR05MB6630.eurprd05.prod.outlook.com (2603:10a6:20b:141::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Fri, 8 May
 2020 11:55:20 +0000
Received: from AM7PR05MB6632.eurprd05.prod.outlook.com
 ([fe80::94da:ac7a:611:781f]) by AM7PR05MB6632.eurprd05.prod.outlook.com
 ([fe80::94da:ac7a:611:781f%9]) with mapi id 15.20.2958.030; Fri, 8 May 2020
 11:55:20 +0000
Subject: Re: [PATCH bpf-next 04/14] xsk: introduce AF_XDP buffer allocation
 API
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
 <20200507104252.544114-5-bjorn.topel@gmail.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <be945166-cb5e-143b-e850-8fe60ecbece6@mellanox.com>
Date:   Fri, 8 May 2020 14:55:17 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200507104252.544114-5-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0033.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::20) To AM7PR05MB6632.eurprd05.prod.outlook.com
 (2603:10a6:20b:136::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by BE0P281CA0033.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:14::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Fri, 8 May 2020 11:55:19 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b90cfd90-b2a1-4ad5-99a3-08d7f346aeb3
X-MS-TrafficTypeDiagnostic: AM7PR05MB6630:
X-Microsoft-Antispam-PRVS: <AM7PR05MB6630385E1CCB88FEB19F45DCD1A20@AM7PR05MB6630.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kgxywlf6PBRUT34rvJ+HCZmMZsWIZbssDPJaGBmob1WZtww+CVGNmIdtmwqJCtDNLlGCkxIcsrxD2OBsQ0tXkBeFSZMBy0xJjXxOIgIEcjoE2fK2lA8Htw3EDvnA/dGl2pkAs6YuZ3m170QSG1wfs9o5Eb1fCUssfEWEWJVlZDZ4Rxl8/hcrmCNeN+TY23H5sCUiD15voQ3jqhxLkYQlAl/I9Txc0YBuis9lHlO+eFVsko3xBO1v2LgiwbEYX0RxgWM1O6M2HVHXL1GdHLfGhdcxGq7zlXbuQa9URpL3/2OKH6JvtcH0SVjSTHcydCPb5gqEhkEXJ/K1vIYmJ/sPsRzSsbDJ++tznpB5WuW2IklcniKfgGi95dMxykgawz4Msy2hbfBGqX7rrUzcpTnmrRWb6KO8Mmw0z2q7GO04fko5Ikfx/dzM1t65vsXkDtquKvczV7hu5/jzH9+0j3CGg5BzzPEPlKMNrjAJQ+sRa/V8LLh0nq6OV43kA3k21YIbRECs7XwqRByOVLslNvEis+uC/RDQooWLb2qw+UY3hR28sxyc8a4vl5RgIO2ZnZYE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6632.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(33430700001)(86362001)(66574014)(7416002)(478600001)(36756003)(16576012)(31696002)(52116002)(83300400001)(5660300002)(956004)(83290400001)(316002)(8936002)(83320400001)(83280400001)(83310400001)(186003)(16526019)(8676002)(2906002)(26005)(66946007)(6486002)(2616005)(4326008)(33440700001)(31686004)(53546011)(55236004)(66476007)(30864003)(110136005)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: soCEEdKdRfeq/xhjWJUvYIrA4odAFQ3mSkCp6Cfeydu/CktzeGaeKlDq38MKl0iUh6ZdgsbHg2lHK9LaHVpjCRo+GNvR/JQnJcONeYNmIAd+7QFw279mwA/t6W6xHUVwbQkGDEj3FbaFgUJ9OcssotizqeXNcHbESoQDw6anR254M8T36UZS/gqrzd+5JSMV8hB6ZMT5pL9K8j9/akaSDaZGLAF5OVusfohFm6ygqLbFmBVlhJttieI2WV5Va6feAn46Bv1lfNEBXgggn3R5gXCU1WfBjp46CM1xsh/rVydF8ubvjVll+WOxXXuU1JfNLyL1RWaIAbaltCt5S+3wOczrcDNLUwdnW+cCCNy654MZ+ainpNUoEWh5sHOj/oVQxBl2wb85BcMwy/vHX5U6EdsUhPwKTAxB8nJYYYwwO4NI+Kx2Vjb2r7YmU508dlsNBH9DMBPMIRmD282BAbpeKN/GDFiVt57UVOaAXNOc85Q/9IYzFVRSS3tLLVz7bI06
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b90cfd90-b2a1-4ad5-99a3-08d7f346aeb3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 11:55:20.1735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofvdLZSAgKkc4ob+7hHBfRHTZmdqtBIbRkDV+4hiy4bGZlElgf3fcjlAPyOVNeHFzzocOkTzzrODCvVHOMuPNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6630
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-07 13:42, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> In order to simplify AF_XDP zero-copy enablement for NIC driver
> developers, a new AF_XDP buffer allocation API is added. The
> implementation is based on a single core (single producer/consumer)
> buffer pool for the AF_XDP UMEM.
> 
> A buffer is allocated using the xsk_buff_alloc() function, and
> returned using xsk_buff_free(). If a buffer is disassociated with the
> pool, e.g. when a buffer is passed to an AF_XDP socket, a buffer is
> said to be released. Currently, the release function is only used by
> the AF_XDP internals and not visible to the driver.
> 
> Drivers using this API should register the XDP memory model with the
> new MEM_TYPE_XSK_BUFF_POOL type.
> 
> The API is defined in net/xdp_sock_drv.h.
> 
> The buffer type is struct xdp_buff, and follows the lifetime of
> regular xdp_buffs, i.e.  the lifetime of an xdp_buff is restricted to
> a NAPI context. In other words, the API is not replacing xdp_frames.
> 
> In addition to introducing the API and implementations, the AF_XDP
> core is migrated to use the new APIs.
> 
> rfc->v1: Fixed build errors/warnings for m68k and riscv. (kbuild test
>           robot)
>           Added headroom/chunk size getter. (Maxim/Björn)
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Björn's signoff should go first (as the original author).

> ---
>   include/net/xdp.h           |   4 +-
>   include/net/xdp_sock.h      |   2 +
>   include/net/xdp_sock_drv.h  | 152 ++++++++++++
>   include/net/xsk_buff_pool.h |  54 +++++
>   include/trace/events/xdp.h  |   3 +-
>   net/core/xdp.c              |  14 +-
>   net/xdp/Makefile            |   1 +
>   net/xdp/xdp_umem.c          |  19 +-
>   net/xdp/xsk.c               | 147 +++++-------
>   net/xdp/xsk_buff_pool.c     | 462 ++++++++++++++++++++++++++++++++++++
>   net/xdp/xsk_diag.c          |   2 +-
>   net/xdp/xsk_queue.h         |  59 +++--
>   12 files changed, 800 insertions(+), 119 deletions(-)
>   create mode 100644 include/net/xsk_buff_pool.h
>   create mode 100644 net/xdp/xsk_buff_pool.c
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 3cc6d5d84aa4..83173e4d306c 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -38,6 +38,7 @@ enum xdp_mem_type {
>   	MEM_TYPE_PAGE_ORDER0,     /* Orig XDP full page model */
>   	MEM_TYPE_PAGE_POOL,
>   	MEM_TYPE_ZERO_COPY,
> +	MEM_TYPE_XSK_BUFF_POOL,
>   	MEM_TYPE_MAX,
>   };
>   
> @@ -101,7 +102,8 @@ struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
>   	int metasize;
>   	int headroom;
>   
> -	if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY)
> +	if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY ||
> +	    xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL)
>   		return xdp_convert_zc_to_xdp_frame(xdp);
>   
>   	/* Assure headroom is available for storing info */
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index fb7fe3060175..6e7265f63c04 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -31,11 +31,13 @@ struct xdp_umem_fq_reuse {
>   struct xdp_umem {
>   	struct xsk_queue *fq;
>   	struct xsk_queue *cq;
> +	struct xsk_buff_pool *pool;
>   	struct xdp_umem_page *pages;
>   	u64 chunk_mask;
>   	u64 size;
>   	u32 headroom;
>   	u32 chunk_size_nohr;
> +	u32 chunk_size;
>   	struct user_struct *user;
>   	refcount_t users;
>   	struct work_struct work;
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index 98dd6962e6d4..5a0970d4c44c 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -7,6 +7,7 @@
>   #define _LINUX_XDP_SOCK_DRV_H
>   
>   #include <net/xdp_sock.h>
> +#include <net/xsk_buff_pool.h>
>   
>   #ifdef CONFIG_XDP_SOCKETS
>   
> @@ -96,6 +97,87 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 address,
>   		return address + offset;
>   }
>   
> +static inline u32 xsk_umem_get_headroom(struct xdp_umem *umem)
> +{
> +	return XDP_PACKET_HEADROOM + umem->headroom;
> +}
> +
> +static inline u32 xsk_umem_get_chunk_size(struct xdp_umem *umem)
> +{
> +	return umem->chunk_size;
> +}
> +
> +static inline u32 xsk_umem_get_rx_frame_size(struct xdp_umem *umem)
> +{
> +	return xsk_umem_get_chunk_size(umem) - xsk_umem_get_headroom(umem);
> +}
> +
> +static inline void xsk_buff_set_rxq_info(struct xdp_umem *umem,
> +					 struct xdp_rxq_info *rxq)
> +{
> +	xp_set_rxq_info(umem->pool, rxq);
> +}
> +
> +static inline void xsk_buff_dma_unmap(struct xdp_umem *umem,
> +				      unsigned long attrs)
> +{
> +	xp_dma_unmap(umem->pool, attrs);
> +}
> +
> +static inline int xsk_buff_dma_map(struct xdp_umem *umem, struct device *dev,
> +				   unsigned long attrs)
> +{
> +	return xp_dma_map(umem->pool, dev, attrs, umem->pgs, umem->npgs);
> +}
> +
> +static inline dma_addr_t xsk_buff_xdp_get_dma(struct xdp_buff *xdp)
> +{
> +	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
> +
> +	return xp_get_dma(xskb);
> +}
> +
> +static inline struct xdp_buff *xsk_buff_alloc(struct xdp_umem *umem)
> +{
> +	return xp_alloc(umem->pool);
> +}
> +
> +static inline bool xsk_buff_can_alloc(struct xdp_umem *umem, u32 count)
> +{
> +	return xp_can_alloc(umem->pool, count);
> +}
> +
> +static inline void xsk_buff_free(struct xdp_buff *xdp)
> +{
> +	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
> +
> +	xp_free(xskb);
> +}
> +
> +static inline dma_addr_t xsk_buff_raw_get_dma(struct xdp_umem *umem, u64 addr)
> +{
> +	return xp_raw_get_dma(umem->pool, addr);
> +}
> +
> +static inline void *xsk_buff_raw_get_data(struct xdp_umem *umem, u64 addr)
> +{
> +	return xp_raw_get_data(umem->pool, addr);
> +}
> +
> +static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp)
> +{
> +	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
> +
> +	xp_dma_sync_for_cpu(xskb);
> +}
> +
> +static inline void xsk_buff_raw_dma_sync_for_device(struct xdp_umem *umem,
> +						    dma_addr_t dma,
> +						    size_t size)
> +{
> +	xp_dma_sync_for_device(umem->pool, dma, size);
> +}
> +
>   #else
>   
>   static inline bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
> @@ -202,6 +284,76 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 handle,
>   	return 0;
>   }
>   
> +static inline u32 xsk_umem_get_headroom(struct xdp_umem *umem)
> +{
> +	return 0;
> +}
> +
> +static inline u32 xsk_umem_get_chunk_size(struct xdp_umem *umem)
> +{
> +	return 0;
> +}
> +
> +static inline u32 xsk_umem_get_rx_frame_size(struct xdp_umem *umem)
> +{
> +	return 0;
> +}
> +
> +static inline void xsk_buff_set_rxq_info(struct xdp_umem *umem,
> +					 struct xdp_rxq_info *rxq)
> +{
> +}
> +
> +static inline void xsk_buff_dma_unmap(struct xdp_umem *umem,
> +				      unsigned long attrs)
> +{
> +}
> +
> +static inline int xsk_buff_dma_map(struct xdp_umem *umem, struct device *dev,
> +				   unsigned long attrs)
> +{
> +	return 0;
> +}
> +
> +static inline dma_addr_t xsk_buff_xdp_get_dma(struct xdp_buff *xdp)
> +{
> +	return 0;
> +}
> +
> +static inline struct xdp_buff *xsk_buff_alloc(struct xdp_umem *umem)
> +{
> +	return NULL;
> +}
> +
> +static inline bool xsk_buff_can_alloc(struct xdp_umem *umem, u32 count)
> +{
> +	return false;
> +}
> +
> +static inline void xsk_buff_free(struct xdp_buff *xdp)
> +{
> +}
> +
> +static inline dma_addr_t xsk_buff_raw_get_dma(struct xdp_umem *umem, u64 addr)
> +{
> +	return 0;
> +}
> +
> +static inline void *xsk_buff_raw_get_data(struct xdp_umem *umem, u64 addr)
> +{
> +	return NULL;
> +}
> +
> +static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp)
> +{
> +}
> +
> +static inline void xsk_buff_raw_dma_sync_for_device(struct xdp_umem *umem,
> +						    dma_addr_t dma,
> +						    size_t size)
> +{
> +}
> +
>   #endif /* CONFIG_XDP_SOCKETS */
>   
>   #endif /* _LINUX_XDP_SOCK_DRV_H */
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> new file mode 100644
> index 000000000000..9abef166441d
> --- /dev/null
> +++ b/include/net/xsk_buff_pool.h
> @@ -0,0 +1,54 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2020 Intel Corporation. */
> +
> +#ifndef XSK_BUFF_POOL_H_
> +#define XSK_BUFF_POOL_H_
> +
> +#include <linux/types.h>
> +#include <linux/dma-mapping.h>
> +#include <net/xdp.h>
> +
> +struct xsk_buff_pool;
> +struct xdp_rxq_info;
> +struct xsk_queue;
> +struct xdp_desc;
> +struct device;
> +struct page;
> +
> +struct xdp_buff_xsk {
> +	struct xdp_buff xdp;
> +	dma_addr_t dma;
> +	struct xsk_buff_pool *pool;
> +	bool unaligned;
> +	u64 orig_addr;
> +	struct list_head free_list_node;
> +};
> +
> +/* AF_XDP core. */
> +struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
> +				u32 chunk_size, u32 headroom, u64 size,
> +				bool unaligned);
> +void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq);
> +void xp_destroy(struct xsk_buff_pool *pool);
> +void xp_release(struct xdp_buff_xsk *xskb);
> +u64 xp_get_handle(struct xdp_buff_xsk *xskb);
> +bool xp_validate_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc);
> +
> +/* AF_XDP, and XDP core. */
> +void xp_free(struct xdp_buff_xsk *xskb);
> +
> +/* AF_XDP ZC drivers, via xdp_sock_buff.h */
> +void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq);
> +int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
> +	       unsigned long attrs, struct page **pages, u32 nr_pages);
> +void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs);
> +struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool);
> +bool xp_can_alloc(struct xsk_buff_pool *pool, u32 count);
> +void *xp_raw_get_data(struct xsk_buff_pool *pool, u64 addr);
> +dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr);
> +dma_addr_t xp_get_dma(struct xdp_buff_xsk *xskb);
> +void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb);
> +void xp_dma_sync_for_device(struct xsk_buff_pool *pool, dma_addr_t dma,
> +			    size_t size);
> +
> +#endif /* XSK_BUFF_POOL_H_ */
> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> index b95d65e8c628..48547a12fa27 100644
> --- a/include/trace/events/xdp.h
> +++ b/include/trace/events/xdp.h
> @@ -287,7 +287,8 @@ TRACE_EVENT(xdp_devmap_xmit,
>   	FN(PAGE_SHARED)		\
>   	FN(PAGE_ORDER0)		\
>   	FN(PAGE_POOL)		\
> -	FN(ZERO_COPY)
> +	FN(ZERO_COPY)		\
> +	FN(XSK_BUFF_POOL)
>   
>   #define __MEM_TYPE_TP_FN(x)	\
>   	TRACE_DEFINE_ENUM(MEM_TYPE_##x);
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 4c7ea85486af..89053ef8333b 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -16,6 +16,7 @@
>   #include <net/xdp.h>
>   #include <net/xdp_priv.h> /* struct xdp_mem_allocator */
>   #include <trace/events/xdp.h>
> +#include <net/xdp_sock_drv.h>
>   
>   #define REG_STATE_NEW		0x0
>   #define REG_STATE_REGISTERED	0x1
> @@ -360,7 +361,7 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
>    * of xdp_frames/pages in those cases.
>    */
>   static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
> -			 unsigned long handle)
> +			 unsigned long handle, struct xdp_buff *xdp)
>   {
>   	struct xdp_mem_allocator *xa;
>   	struct page *page;
> @@ -389,6 +390,11 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
>   		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
>   		xa->zc_alloc->free(xa->zc_alloc, handle);
>   		rcu_read_unlock();
> +		break;
> +	case MEM_TYPE_XSK_BUFF_POOL:
> +		/* NB! Only valid from an xdp_buff! */
> +		xsk_buff_free(xdp);
> +		break;
>   	default:
>   		/* Not possible, checked in xdp_rxq_info_reg_mem_model() */
>   		break;
> @@ -397,19 +403,19 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
>   
>   void xdp_return_frame(struct xdp_frame *xdpf)
>   {
> -	__xdp_return(xdpf->data, &xdpf->mem, false, 0);
> +	__xdp_return(xdpf->data, &xdpf->mem, false, 0, NULL);
>   }
>   EXPORT_SYMBOL_GPL(xdp_return_frame);
>   
>   void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
>   {
> -	__xdp_return(xdpf->data, &xdpf->mem, true, 0);
> +	__xdp_return(xdpf->data, &xdpf->mem, true, 0, NULL);
>   }
>   EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
>   
>   void xdp_return_buff(struct xdp_buff *xdp)
>   {
> -	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp->handle);
> +	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp->handle, xdp);
>   }
>   EXPORT_SYMBOL_GPL(xdp_return_buff);
>   
> diff --git a/net/xdp/Makefile b/net/xdp/Makefile
> index 90b5460d6166..30cdc4315f42 100644
> --- a/net/xdp/Makefile
> +++ b/net/xdp/Makefile
> @@ -1,3 +1,4 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   obj-$(CONFIG_XDP_SOCKETS) += xsk.o xdp_umem.o xsk_queue.o xskmap.o
> +obj-$(CONFIG_XDP_SOCKETS) += xsk_buff_pool.o
>   obj-$(CONFIG_XDP_SOCKETS_DIAG) += xsk_diag.o
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 37ace3bc0d48..7f04688045d5 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -245,7 +245,7 @@ static void xdp_umem_release(struct xdp_umem *umem)
>   	}
>   
>   	xsk_reuseq_destroy(umem);
> -
> +	xp_destroy(umem->pool);
>   	xdp_umem_unmap_pages(umem);
>   	xdp_umem_unpin_pages(umem);
>   
> @@ -390,6 +390,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>   	umem->size = size;
>   	umem->headroom = headroom;
>   	umem->chunk_size_nohr = chunk_size - headroom;
> +	umem->chunk_size = chunk_size;
>   	umem->npgs = size / PAGE_SIZE;
>   	umem->pgs = NULL;
>   	umem->user = NULL;
> @@ -415,11 +416,21 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>   	}
>   
>   	err = xdp_umem_map_pages(umem);
> -	if (!err)
> -		return 0;
> +	if (err)
> +		goto out_pages;
>   
> -	kvfree(umem->pages);
> +	umem->pool = xp_create(umem->pgs, umem->npgs, chunks, chunk_size,
> +			       headroom, size, unaligned_chunks);
> +	if (!umem->pool) {
> +		err = -ENOMEM;
> +		goto out_unmap;
> +	}
> +	return 0;
>   
> +out_unmap:
> +	xdp_umem_unmap_pages(umem);
> +out_pages:
> +	kvfree(umem->pages);
>   out_pin:
>   	xdp_umem_unpin_pages(umem);
>   out_account:
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 8bda654e82ec..6933f0d494ba 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -117,76 +117,67 @@ bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem)
>   }
>   EXPORT_SYMBOL(xsk_umem_uses_need_wakeup);
>   
> -/* If a buffer crosses a page boundary, we need to do 2 memcpy's, one for
> - * each page. This is only required in copy mode.
> - */
> -static void __xsk_rcv_memcpy(struct xdp_umem *umem, u64 addr, void *from_buf,
> -			     u32 len, u32 metalen)
> +static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
>   {
> -	void *to_buf = xdp_umem_get_data(umem, addr);
> -
> -	addr = xsk_umem_add_offset_to_addr(addr);
> -	if (xskq_cons_crosses_non_contig_pg(umem, addr, len + metalen)) {
> -		void *next_pg_addr = umem->pages[(addr >> PAGE_SHIFT) + 1].addr;
> -		u64 page_start = addr & ~(PAGE_SIZE - 1);
> -		u64 first_len = PAGE_SIZE - (addr - page_start);
> -
> -		memcpy(to_buf, from_buf, first_len);
> -		memcpy(next_pg_addr, from_buf + first_len,
> -		       len + metalen - first_len);
> +	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
> +	u64 addr;
> +	int err;
>   
> -		return;
> +	addr = xp_get_handle(xskb);
> +	err = xskq_prod_reserve_desc(xs->rx, addr, len);
> +	if (err) {
> +		xs->rx_dropped++;
> +		return err;
>   	}
>   
> -	memcpy(to_buf, from_buf, len + metalen);
> +	xp_release(xskb);
> +	return 0;
>   }
>   
> -static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
> +static void xsk_copy_xdp(struct xdp_buff *to, struct xdp_buff *from, u32 len)
>   {
> -	u64 offset = xs->umem->headroom;
> -	u64 addr, memcpy_addr;
> -	void *from_buf;
> +	void *from_buf, *to_buf;
>   	u32 metalen;
> -	int err;
> -
> -	if (!xskq_cons_peek_addr(xs->umem->fq, &addr, xs->umem) ||
> -	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
> -		xs->rx_dropped++;
> -		return -ENOSPC;
> -	}
>   
> -	if (unlikely(xdp_data_meta_unsupported(xdp))) {
> -		from_buf = xdp->data;
> +	if (unlikely(xdp_data_meta_unsupported(from))) {
> +		from_buf = from->data;
> +		to_buf = to->data;
>   		metalen = 0;
>   	} else {
> -		from_buf = xdp->data_meta;
> -		metalen = xdp->data - xdp->data_meta;
> +		from_buf = from->data_meta;
> +		metalen = from->data - from->data_meta;
> +		to_buf = to->data - metalen;
>   	}
>   
> -	memcpy_addr = xsk_umem_adjust_offset(xs->umem, addr, offset);
> -	__xsk_rcv_memcpy(xs->umem, memcpy_addr, from_buf, len, metalen);
> -
> -	offset += metalen;
> -	addr = xsk_umem_adjust_offset(xs->umem, addr, offset);
> -	err = xskq_prod_reserve_desc(xs->rx, addr, len);
> -	if (!err) {
> -		xskq_cons_release(xs->umem->fq);
> -		xdp_return_buff(xdp);
> -		return 0;
> -	}
> -
> -	xs->rx_dropped++;
> -	return err;
> +	memcpy(to_buf, from_buf, len + metalen);
>   }
>   
> -static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
> +static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
> +		     bool explicit_free)
>   {
> -	int err = xskq_prod_reserve_desc(xs->rx, xdp->handle, len);
> +	struct xdp_buff *xsk_xdp;
> +	int err;
>   
> -	if (err)
> +	if (len > xsk_umem_get_rx_frame_size(xs->umem)) {
> +		xs->rx_dropped++;
> +		return -ENOSPC;
> +	}
> +
> +	xsk_xdp = xsk_buff_alloc(xs->umem);
> +	if (!xsk_xdp) {
>   		xs->rx_dropped++;
> +		return -ENOSPC;
> +	}
>   
> -	return err;
> +	xsk_copy_xdp(xsk_xdp, xdp, len);
> +	err = __xsk_rcv_zc(xs, xsk_xdp, len);
> +	if (err) {
> +		xsk_buff_free(xsk_xdp);
> +		return err;
> +	}
> +	if (explicit_free)
> +		xdp_return_buff(xdp);
> +	return 0;
>   }
>   
>   static bool xsk_is_bound(struct xdp_sock *xs)
> @@ -199,7 +190,8 @@ static bool xsk_is_bound(struct xdp_sock *xs)
>   	return false;
>   }
>   
> -static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
> +static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp,
> +		   bool explicit_free)
>   {
>   	u32 len;
>   
> @@ -211,8 +203,10 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>   
>   	len = xdp->data_end - xdp->data;
>   
> -	return (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY) ?
> -		__xsk_rcv_zc(xs, xdp, len) : __xsk_rcv(xs, xdp, len);
> +	return xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY ||
> +		xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL ?
> +		__xsk_rcv_zc(xs, xdp, len) :
> +		__xsk_rcv(xs, xdp, len, explicit_free);
>   }
>   
>   static void xsk_flush(struct xdp_sock *xs)
> @@ -224,46 +218,11 @@ static void xsk_flush(struct xdp_sock *xs)
>   
>   int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>   {
> -	u32 metalen = xdp->data - xdp->data_meta;
> -	u32 len = xdp->data_end - xdp->data;
> -	u64 offset = xs->umem->headroom;
> -	void *buffer;
> -	u64 addr;
>   	int err;
>   
>   	spin_lock_bh(&xs->rx_lock);
> -
> -	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
> -		err = -EINVAL;
> -		goto out_unlock;
> -	}
> -
> -	if (!xskq_cons_peek_addr(xs->umem->fq, &addr, xs->umem) ||
> -	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
> -		err = -ENOSPC;
> -		goto out_drop;
> -	}
> -
> -	addr = xsk_umem_adjust_offset(xs->umem, addr, offset);
> -	buffer = xdp_umem_get_data(xs->umem, addr);
> -	memcpy(buffer, xdp->data_meta, len + metalen);
> -
> -	addr = xsk_umem_adjust_offset(xs->umem, addr, metalen);
> -	err = xskq_prod_reserve_desc(xs->rx, addr, len);
> -	if (err)
> -		goto out_drop;
> -
> -	xskq_cons_release(xs->umem->fq);
> -	xskq_prod_submit(xs->rx);
> -
> -	spin_unlock_bh(&xs->rx_lock);
> -
> -	xs->sk.sk_data_ready(&xs->sk);
> -	return 0;
> -
> -out_drop:
> -	xs->rx_dropped++;
> -out_unlock:
> +	err = xsk_rcv(xs, xdp, false);
> +	xsk_flush(xs);
>   	spin_unlock_bh(&xs->rx_lock);
>   	return err;
>   }
> @@ -273,7 +232,7 @@ int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
>   	struct list_head *flush_list = this_cpu_ptr(&xskmap_flush_list);
>   	int err;
>   
> -	err = xsk_rcv(xs, xdp);
> +	err = xsk_rcv(xs, xdp, true);
>   	if (err)
>   		return err;
>   
> @@ -404,7 +363,7 @@ static int xsk_generic_xmit(struct sock *sk)
>   
>   		skb_put(skb, len);
>   		addr = desc.addr;
> -		buffer = xdp_umem_get_data(xs->umem, addr);
> +		buffer = xsk_buff_raw_get_data(xs->umem, addr);
>   		err = skb_store_bits(skb, 0, buffer, len);
>   		/* This is the backpressure mechanism for the Tx path.
>   		 * Reserve space in the completion queue and only proceed
> @@ -860,6 +819,8 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
>   		q = (optname == XDP_UMEM_FILL_RING) ? &xs->umem->fq :
>   			&xs->umem->cq;
>   		err = xsk_init_queue(entries, q, true);
> +		if (optname == XDP_UMEM_FILL_RING)
> +			xp_set_fq(xs->umem->pool, *q);
>   		mutex_unlock(&xs->mutex);
>   		return err;
>   	}
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> new file mode 100644
> index 000000000000..df5db2c38859
> --- /dev/null
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -0,0 +1,462 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <net/xsk_buff_pool.h>
> +#include <net/xdp_sock.h>
> +#include <linux/dma-direct.h>
> +#include <linux/dma-noncoherent.h>
> +#include <linux/swiotlb.h>
> +
> +#include "xsk_queue.h"
> +
> +struct xsk_buff_pool {
> +	struct xsk_queue *fq;
> +	struct list_head free_list;
> +	dma_addr_t *dma_pages;
> +	struct xdp_buff_xsk *heads;
> +	u64 chunk_mask;
> +	u64 addrs_cnt;
> +	u32 free_list_cnt;
> +	u32 dma_pages_cnt;
> +	u32 heads_cnt;
> +	u32 free_heads_cnt;
> +	u32 headroom;
> +	u32 chunk_size;
> +	u32 frame_len;
> +	bool cheap_dma;
> +	bool unaligned;
> +	void *addrs;
> +	struct device *dev;
> +	struct xdp_buff_xsk *free_heads[];
> +};
> +
> +static void xp_addr_unmap(struct xsk_buff_pool *pool)
> +{
> +	vunmap(pool->addrs);
> +}
> +
> +static int xp_addr_map(struct xsk_buff_pool *pool,
> +		       struct page **pages, u32 nr_pages)
> +{
> +	pool->addrs = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> +	if (!pool->addrs)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +void xp_destroy(struct xsk_buff_pool *pool)
> +{
> +	if (!pool)
> +		return;
> +
> +	xp_addr_unmap(pool);
> +	kvfree(pool->heads);
> +	kvfree(pool);
> +}
> +
> +struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
> +				u32 chunk_size, u32 headroom, u64 size,
> +				bool unaligned)
> +{
> +	struct xsk_buff_pool *pool;
> +	struct xdp_buff_xsk *xskb;
> +	int err;
> +	u32 i;
> +
> +	pool = kvzalloc(struct_size(pool, free_heads, chunks), GFP_KERNEL);
> +	if (!pool)
> +		goto out;
> +
> +	pool->heads = kvcalloc(chunks, sizeof(*pool->heads), GFP_KERNEL);
> +	if (!pool->heads)
> +		goto out;
> +
> +	pool->chunk_mask = ~((u64)chunk_size - 1);
> +	pool->addrs_cnt = size;
> +	pool->heads_cnt = chunks;
> +	pool->free_heads_cnt = chunks;
> +	pool->headroom = headroom;
> +	pool->chunk_size = chunk_size;
> +	pool->cheap_dma = true;
> +	pool->unaligned = unaligned;
> +	pool->frame_len = chunk_size - headroom - XDP_PACKET_HEADROOM;
> +	INIT_LIST_HEAD(&pool->free_list);
> +
> +	for (i = 0; i < pool->free_heads_cnt; i++) {
> +		xskb = &pool->heads[i];
> +		xskb->pool = pool;
> +		pool->free_heads[i] = xskb;
> +	}
> +
> +	err = xp_addr_map(pool, pages, nr_pages);
> +	if (!err)
> +		return pool;
> +
> +out:
> +	xp_destroy(pool);
> +	return NULL;
> +}
> +
> +void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq)
> +{
> +	pool->fq = fq;
> +}
> +
> +void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
> +{
> +	u32 i;
> +
> +	for (i = 0; i < pool->heads_cnt; i++)
> +		pool->heads[i].xdp.rxq = rxq;
> +}
> +EXPORT_SYMBOL(xp_set_rxq_info);
> +
> +void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
> +{
> +	dma_addr_t *dma;
> +	u32 i;
> +
> +	if (pool->dma_pages_cnt == 0)
> +		return;
> +
> +	for (i = 0; i < pool->dma_pages_cnt; i++) {
> +		dma = &pool->dma_pages[i];
> +		if (*dma) {
> +			dma_unmap_page_attrs(pool->dev, *dma, PAGE_SIZE,
> +					     DMA_BIDIRECTIONAL, attrs);
> +			*dma = 0;
> +		}
> +	}
> +
> +	kvfree(pool->dma_pages);
> +	pool->dma_pages_cnt = 0;
> +	pool->dev = NULL;
> +}
> +EXPORT_SYMBOL(xp_dma_unmap);
> +
> +static void xp_check_dma_contiguity(struct xsk_buff_pool *pool)
> +{
> +	u32 i;
> +
> +	for (i = 0; i < pool->dma_pages_cnt - 1; i++) {
> +		if (pool->dma_pages[i] + PAGE_SIZE == pool->dma_pages[i + 1])
> +			pool->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
> +		else
> +			pool->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
> +	}
> +}
> +
> +static bool __maybe_unused xp_check_swiotlb_dma(struct xsk_buff_pool *pool)
> +{
> +#if defined(CONFIG_SWIOTLB)
> +	phys_addr_t paddr;
> +	u32 i;
> +
> +	for (i = 0; i < pool->dma_pages_cnt; i++) {
> +		paddr = dma_to_phys(pool->dev, pool->dma_pages[i]);
> +		if (is_swiotlb_buffer(paddr))
> +			return false;
> +	}
> +#endif
> +	return true;
> +}
> +
> +static bool xp_check_cheap_dma(struct xsk_buff_pool *pool)
> +{
> +#if defined(CONFIG_HAS_DMA)
> +	const struct dma_map_ops *ops = get_dma_ops(pool->dev);
> +
> +	if (ops) {
> +		return !ops->sync_single_for_cpu &&
> +			!ops->sync_single_for_device;
> +	}
> +
> +	if (!dma_is_direct(ops))
> +		return false;
> +
> +	if (!xp_check_swiotlb_dma(pool))
> +		return false;
> +
> +	if (!dev_is_dma_coherent(pool->dev)) {
> +#if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) ||		\
> +	defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL) ||	\
> +	defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE)
> +		return false;
> +#endif
> +	}
> +#endif
> +	return true;
> +}
> +
> +int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
> +	       unsigned long attrs, struct page **pages, u32 nr_pages)
> +{
> +	dma_addr_t dma;
> +	u32 i;
> +
> +	pool->dma_pages = kvcalloc(nr_pages, sizeof(*pool->dma_pages),
> +				   GFP_KERNEL);
> +	if (!pool->dma_pages)
> +		return -ENOMEM;
> +
> +	pool->dev = dev;
> +	pool->dma_pages_cnt = nr_pages;
> +
> +	for (i = 0; i < pool->dma_pages_cnt; i++) {
> +		dma = dma_map_page_attrs(dev, pages[i], 0, PAGE_SIZE,
> +					 DMA_BIDIRECTIONAL, attrs);
> +		if (dma_mapping_error(dev, dma)) {
> +			xp_dma_unmap(pool, attrs);
> +			return -ENOMEM;
> +		}
> +		pool->dma_pages[i] = dma;
> +	}
> +
> +	if (pool->unaligned)
> +		xp_check_dma_contiguity(pool);
> +
> +	pool->dev = dev;
> +	pool->cheap_dma = xp_check_cheap_dma(pool);
> +	return 0;
> +}
> +EXPORT_SYMBOL(xp_dma_map);
> +
> +static bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
> +					  u64 addr, u32 len)
> +{
> +	bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
> +
> +	if (pool->dma_pages_cnt && cross_pg) {
> +		return !(pool->dma_pages[addr >> PAGE_SHIFT] &
> +			 XSK_NEXT_PG_CONTIG_MASK);
> +	}
> +	return false;
> +}
> +
> +static bool xp_addr_crosses_non_contig_pg(struct xsk_buff_pool *pool,
> +					  u64 addr)
> +{
> +	return xp_desc_crosses_non_contig_pg(pool, addr, pool->chunk_size);
> +}
> +
> +void xp_release(struct xdp_buff_xsk *xskb)
> +{
> +	xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
> +}
> +
> +static u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
> +{
> +	return addr & pool->chunk_mask;
> +}
> +
> +static u64 xp_unaligned_extract_addr(u64 addr)
> +{
> +	return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
> +}
> +
> +static u64 xp_unaligned_extract_offset(u64 addr)
> +{
> +	return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> +}
> +
> +static u64 xp_unaligned_add_offset_to_addr(u64 addr)
> +{
> +	return xp_unaligned_extract_addr(addr) +
> +		xp_unaligned_extract_offset(addr);
> +}
> +
> +static bool xp_check_unaligned(struct xsk_buff_pool *pool, u64 *addr)
> +{
> +	*addr = xp_unaligned_extract_addr(*addr);
> +	if (*addr >= pool->addrs_cnt ||
> +	    *addr + pool->chunk_size > pool->addrs_cnt ||
> +	    xp_addr_crosses_non_contig_pg(pool, *addr))
> +		return false;
> +	return true;
> +}
> +
> +static bool xp_check_aligned(struct xsk_buff_pool *pool, u64 *addr)
> +{
> +	*addr = xp_aligned_extract_addr(pool, *addr);
> +	return *addr < pool->addrs_cnt;
> +}
> +
> +static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
> +{
> +	struct xdp_buff_xsk *xskb;
> +	u64 addr;
> +	bool ok;
> +
> +	if (pool->free_heads_cnt == 0)
> +		return NULL;
> +
> +	xskb = pool->free_heads[--pool->free_heads_cnt];
> +
> +	for (;;) {
> +		if (!xskq_cons_peek_addr_unchecked(pool->fq, &addr)) {
> +			xp_release(xskb);
> +			return NULL;
> +		}
> +
> +		ok = pool->unaligned ? xp_check_unaligned(pool, &addr) :
> +		     xp_check_aligned(pool, &addr);
> +		if (!ok) {
> +			pool->fq->invalid_descs++;
> +			xskq_cons_release(pool->fq);
> +			continue;
> +		}
> +		break;
> +	}
> +	xskq_cons_release(pool->fq);
> +
> +	xskb->orig_addr = addr;
> +	xskb->xdp.data_hard_start = pool->addrs + addr + pool->headroom;
> +	if (pool->dma_pages_cnt) {
> +		xskb->dma = (pool->dma_pages[addr >> PAGE_SHIFT] &
> +			     ~XSK_NEXT_PG_CONTIG_MASK) +
> +			    (addr & ~PAGE_MASK) +
> +			    pool->headroom + XDP_PACKET_HEADROOM;
> +	}
> +	return xskb;
> +}
> +
> +struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
> +{
> +	struct xdp_buff_xsk *xskb;
> +
> +	if (!pool->free_list_cnt) {
> +		xskb = __xp_alloc(pool);
> +		if (!xskb)
> +			return NULL;
> +	} else {
> +		pool->free_list_cnt--;
> +		xskb = list_first_entry(&pool->free_list, struct xdp_buff_xsk,
> +					free_list_node);
> +		list_del(&xskb->free_list_node);
> +	}
> +
> +	xskb->xdp.data = xskb->xdp.data_hard_start + XDP_PACKET_HEADROOM;
> +	xskb->xdp.data_meta = xskb->xdp.data;
> +
> +	if (!pool->cheap_dma) {
> +		dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
> +						 pool->frame_len,
> +						 DMA_BIDIRECTIONAL);
> +	}
> +	return &xskb->xdp;
> +}
> +EXPORT_SYMBOL(xp_alloc);
> +
> +bool xp_can_alloc(struct xsk_buff_pool *pool, u32 count)
> +{
> +	if (pool->free_list_cnt >= count)
> +		return true;
> +	return xskq_cons_has_entries(pool->fq, count - pool->free_list_cnt);
> +}
> +EXPORT_SYMBOL(xp_can_alloc);
> +
> +void xp_free(struct xdp_buff_xsk *xskb)
> +{
> +	xskb->pool->free_list_cnt++;
> +	list_add(&xskb->free_list_node, &xskb->pool->free_list);
> +}
> +EXPORT_SYMBOL(xp_free);
> +
> +static bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
> +				     struct xdp_desc *desc)
> +{
> +	u64 chunk, chunk_end;
> +
> +	chunk = xp_aligned_extract_addr(pool, desc->addr);
> +	chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len);
> +	if (chunk != chunk_end)
> +		return false;
> +
> +	if (chunk >= pool->addrs_cnt)
> +		return false;
> +
> +	if (desc->options)
> +		return false;
> +	return true;
> +}
> +
> +static bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
> +				       struct xdp_desc *desc)
> +{
> +	u64 addr, base_addr;
> +
> +	base_addr = xp_unaligned_extract_addr(desc->addr);
> +	addr = xp_unaligned_add_offset_to_addr(desc->addr);
> +
> +	if (desc->len > pool->chunk_size)
> +		return false;
> +
> +	if (base_addr >= pool->addrs_cnt || addr >= pool->addrs_cnt ||
> +	    xp_desc_crosses_non_contig_pg(pool, addr, desc->len))
> +		return false;
> +
> +	if (desc->options)
> +		return false;
> +	return true;
> +}
> +
> +bool xp_validate_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
> +{
> +	return pool->unaligned ? xp_unaligned_validate_desc(pool, desc) :
> +		xp_aligned_validate_desc(pool, desc);
> +}
> +
> +u64 xp_get_handle(struct xdp_buff_xsk *xskb)
> +{
> +	u64 offset = xskb->xdp.data - xskb->xdp.data_hard_start;
> +
> +	offset += xskb->pool->headroom;
> +	if (!xskb->pool->unaligned)
> +		return xskb->orig_addr + offset;
> +	return xskb->orig_addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
> +}
> +
> +void *xp_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
> +{
> +	addr = pool->unaligned ? xp_unaligned_add_offset_to_addr(addr) : addr;
> +	return pool->addrs + addr;
> +}
> +EXPORT_SYMBOL(xp_raw_get_data);
> +
> +dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr)
> +{
> +	addr = pool->unaligned ? xp_unaligned_add_offset_to_addr(addr) : addr;
> +	return (pool->dma_pages[addr >> PAGE_SHIFT] &
> +		~XSK_NEXT_PG_CONTIG_MASK) +
> +		(addr & ~PAGE_MASK);
> +}
> +EXPORT_SYMBOL(xp_raw_get_dma);
> +
> +dma_addr_t xp_get_dma(struct xdp_buff_xsk *xskb)
> +{
> +	return xskb->dma;
> +}
> +EXPORT_SYMBOL(xp_get_dma);
> +
> +void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb)
> +{
> +	size_t size;
> +
> +	if (xskb->pool->cheap_dma)
> +		return;
> +
> +	size = xskb->xdp.data_end - xskb->xdp.data;
> +	dma_sync_single_range_for_cpu(xskb->pool->dev, xskb->dma, 0,
> +				      size, DMA_BIDIRECTIONAL);
> +}
> +EXPORT_SYMBOL(xp_dma_sync_for_cpu);
> +
> +void xp_dma_sync_for_device(struct xsk_buff_pool *pool, dma_addr_t dma,
> +			    size_t size)
> +{
> +	if (pool->cheap_dma)
> +		return;
> +
> +	dma_sync_single_range_for_device(pool->dev, dma, 0,
> +					 size, DMA_BIDIRECTIONAL);
> +}
> +EXPORT_SYMBOL(xp_dma_sync_for_device);
> diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
> index f59791ba43a0..0163b26aaf63 100644
> --- a/net/xdp/xsk_diag.c
> +++ b/net/xdp/xsk_diag.c
> @@ -56,7 +56,7 @@ static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
>   	du.id = umem->id;
>   	du.size = umem->size;
>   	du.num_pages = umem->npgs;
> -	du.chunk_size = umem->chunk_size_nohr + umem->headroom;
> +	du.chunk_size = umem->chunk_size;
>   	du.headroom = umem->headroom;
>   	du.ifindex = umem->dev ? umem->dev->ifindex : 0;
>   	du.queue_id = umem->queue_id;
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index a322a7dac58c..9151aef7dbca 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -9,6 +9,7 @@
>   #include <linux/types.h>
>   #include <linux/if_xdp.h>
>   #include <net/xdp_sock.h>
> +#include <net/xsk_buff_pool.h>
>   
>   #include "xsk.h"
>   
> @@ -172,31 +173,45 @@ static inline bool xskq_cons_read_addr(struct xsk_queue *q, u64 *addr,
>   	return false;
>   }
>   
> -static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
> -					   struct xdp_desc *d,
> -					   struct xdp_umem *umem)
> +static inline bool xskq_cons_read_addr_aligned(struct xsk_queue *q, u64 *addr)
>   {
> -	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG) {
> -		if (!xskq_cons_is_valid_unaligned(q, d->addr, d->len, umem))
> -			return false;
> +	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
>   
> -		if (d->len > umem->chunk_size_nohr || d->options) {
> -			q->invalid_descs++;
> -			return false;
> -		}
> +	while (q->cached_cons != q->cached_prod) {
> +		u32 idx = q->cached_cons & q->ring_mask;
> +
> +		*addr = ring->desc[idx];
> +		if (xskq_cons_is_valid_addr(q, *addr))
> +			return true;
>   
> +		q->cached_cons++;
> +	}
> +
> +	return false;
> +}
> +
> +static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
> +{
> +	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
> +
> +	if (q->cached_cons != q->cached_prod) {
> +		u32 idx = q->cached_cons & q->ring_mask;
> +
> +		*addr = ring->desc[idx];
>   		return true;
>   	}
>   
> -	if (!xskq_cons_is_valid_addr(q, d->addr))
> -		return false;
> +	return false;
> +}
>   
> -	if (((d->addr + d->len) & q->chunk_mask) != (d->addr & q->chunk_mask) ||
> -	    d->options) {
> +static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
> +					   struct xdp_desc *d,
> +					   struct xdp_umem *umem)
> +{
> +	if (!xp_validate_desc(umem->pool, d)) {
>   		q->invalid_descs++;
>   		return false;
>   	}
> -
>   	return true;
>   }
>   
> @@ -260,6 +275,20 @@ static inline bool xskq_cons_peek_addr(struct xsk_queue *q, u64 *addr,
>   	return xskq_cons_read_addr(q, addr, umem);
>   }
>   
> +static inline bool xskq_cons_peek_addr_aligned(struct xsk_queue *q, u64 *addr)
> +{
> +	if (q->cached_prod == q->cached_cons)
> +		xskq_cons_get_entries(q);
> +	return xskq_cons_read_addr_aligned(q, addr);
> +}
> +
> +static inline bool xskq_cons_peek_addr_unchecked(struct xsk_queue *q, u64 *addr)
> +{
> +	if (q->cached_prod == q->cached_cons)
> +		xskq_cons_get_entries(q);
> +	return xskq_cons_read_addr_unchecked(q, addr);
> +}
> +
>   static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
>   				       struct xdp_desc *desc,
>   				       struct xdp_umem *umem)
> 

