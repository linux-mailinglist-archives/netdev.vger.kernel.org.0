Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED823BA6F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfFJRLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:11:01 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:45852 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfFJRLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:11:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560186660; x=1591722660;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SnKLn2EwQwFTfRWf9FNM48KRKB2NYQgzd/S0Rywb2yw=;
  b=pmWhV4VjR9s87JAIXBdmWSbKHQuMzK53DrajnXB2XLgoxjhwnxv22Zg2
   uYQlrOXaH2oKNexA2SDFjImLWYgtVJdDHwD5iSOMVaxtZuRPn9krFLG2g
   nZjX5IN2rBITpnNnJ2nd8iY/e+U/J9IyHTmBIAU9w+vsNhyLtSgQEu8+L
   A=;
X-IronPort-AV: E=Sophos;i="5.60,576,1549929600"; 
   d="scan'208";a="405796382"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Jun 2019 17:10:57 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 50875A2329;
        Mon, 10 Jun 2019 17:10:57 +0000 (UTC)
Received: from EX13D22EUB002.ant.amazon.com (10.43.166.131) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 17:10:56 +0000
Received: from EX13D04EUB002.ant.amazon.com (10.43.166.51) by
 EX13D22EUB002.ant.amazon.com (10.43.166.131) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 17:10:56 +0000
Received: from EX13D04EUB002.ant.amazon.com ([10.43.166.51]) by
 EX13D04EUB002.ant.amazon.com ([10.43.166.51]) with mapi id 15.00.1367.000;
 Mon, 10 Jun 2019 17:10:55 +0000
From:   "Bshara, Nafea" <nafea@amazon.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Miller <davem@davemloft.net>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
Subject: Re: [PATCH V2 net-next 4/6] net: ena: allow queue allocation backoff
 when low on memory
Thread-Topic: [PATCH V2 net-next 4/6] net: ena: allow queue allocation backoff
 when low on memory
Thread-Index: AQHVH35jzDPn4vNV40SQXH/gzLngnaaVEVcAgAAFHoCAAAl7mg==
Date:   Mon, 10 Jun 2019 17:10:54 +0000
Message-ID: <DD66F007-6D54-4B87-A6B1-23C5B33F0A2A@amazon.com>
References: <20190610111918.21397-1-sameehj@amazon.com>
 <20190610111918.21397-5-sameehj@amazon.com>
 <20190610.091840.690511717716268814.davem@davemloft.net>,<20190610163659.GL28724@lunn.ch>
In-Reply-To: <20190610163659.GL28724@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Sent from my iPhone

> On Jun 10, 2019, at 9:38 AM, Andrew Lunn <andrew@lunn.ch> wrote:
>=20
>> On Mon, Jun 10, 2019 at 09:18:40AM -0700, David Miller wrote:
>> From: <sameehj@amazon.com>
>> Date: Mon, 10 Jun 2019 14:19:16 +0300
>>=20
>>> +static inline void set_io_rings_size(struct ena_adapter *adapter,
>>> +                     int new_tx_size, int new_rx_size)
>>=20
>> Please do not ever use inline in foo.c files, let the compiler decide.
>=20
> Hi David
>=20
> It looks like a few got passed review:
>=20
> ~/linux/drivers/net/ethernet/amazon/ena$ grep inline *.c
> ena_com.c:static inline int ena_com_mem_addr_set(struct ena_com_dev *ena_=
dev,
> ena_com.c:static inline void comp_ctxt_release(struct ena_com_admin_queue=
 *queue,
> ena_com.c:static inline int ena_com_init_comp_ctxt(struct ena_com_admin_q=
ueue *queue)
> ena_eth_com.c:static inline struct ena_eth_io_rx_cdesc_base *ena_com_get_=
next_rx_cdesc(
> ena_eth_com.c:static inline void *get_sq_desc_regular_queue(struct ena_co=
m_io_sq *io_sq)
> ena_eth_com.c:static inline int ena_com_write_bounce_buffer_to_dev(struct=
 ena_com_io_sq *io_sq,
> ena_eth_com.c:static inline int ena_com_write_header_to_bounce(struct ena=
_com_io_sq *io_sq,
> ena_eth_com.c:static inline void *get_sq_desc_llq(struct ena_com_io_sq *i=
o_sq)
> ena_eth_com.c:static inline int ena_com_close_bounce_buffer(struct ena_co=
m_io_sq *io_sq)
> ena_eth_com.c:static inline void *get_sq_desc(struct ena_com_io_sq *io_sq=
)
> ena_eth_com.c:static inline int ena_com_sq_update_llq_tail(struct ena_com=
_io_sq *io_sq)
> ena_eth_com.c:static inline int ena_com_sq_update_tail(struct ena_com_io_=
sq *io_sq)
> ena_eth_com.c:static inline struct ena_eth_io_rx_cdesc_base *
> ena_eth_com.c:static inline u16 ena_com_cdesc_rx_pkt_get(struct ena_com_i=
o_cq *io_cq,
> ena_eth_com.c:static inline int ena_com_create_and_store_tx_meta_desc(str=
uct ena_com_io_sq *io_sq,
> ena_eth_com.c:static inline void ena_com_rx_set_flags(struct ena_com_rx_c=
tx *ena_rx_ctx,
> ena_netdev.c:static inline int validate_rx_req_id(struct ena_ring *rx_rin=
g, u16 req_id)
> ena_netdev.c:static inline int ena_alloc_rx_page(struct ena_ring *rx_ring=
,
> ena_netdev.c:static inline void ena_unmap_tx_skb(struct ena_ring *tx_ring=
,
> ena_netdev.c:static inline void ena_rx_checksum(struct ena_ring *rx_ring,
> ena_netdev.c:inline void ena_adjust_intr_moderation(struct ena_ring *rx_r=
ing,
> ena_netdev.c:static inline void ena_unmask_interrupt(struct ena_ring *tx_=
ring,
> ena_netdev.c:static inline void ena_update_ring_numa_node(struct ena_ring=
 *tx_ring,
> ena_netdev.c:static inline void set_default_llq_configurations(struct ena=
_llq_configurations *llq_config)
>=20
>    Andrew

We will fix all of those=
