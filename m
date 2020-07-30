Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBDC2336B7
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 18:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgG3Q0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 12:26:35 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:58045 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Q0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 12:26:35 -0400
Date:   Thu, 30 Jul 2020 16:26:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1596126392; bh=4VfKsqMSgIAjlvStX7Jque18AnWNCZTbZpiyXiqEaxI=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=FhJzlXZlKq11kMhH4Y6se2vV9kwMBD3hYJ/fgdVUSz5jZuFLrfH7T7aX8cUiBtO9e
         FNJEbVb92/V9XWH7MBAfXFRezGXmJwuyvDQfY/J67nkfDwS3rxC+UxEhbs3RgAH3c3
         +WZ7K9rGXvptUCFODjwng+FuoXGO79nZ0xULHgQN+p9tyIznXyBQmLNEVtPeEGT6JK
         YdwVYP0SBUAkBcW8KkQcP0pd286mhVr/hj4PrBgP8TClOUp6ainoQyBg2x6OpNWdbk
         wnpguCFTIg9czGaip6v3TB0wQdWrBNZAPCkFFWF2TviV9S+HQZY4YEKh0BS0O1Nc3K
         Yb5i9vZF2rUAw==
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v1] qed: Use %pM format specifier for MAC addresses
Message-ID: <SKiAD0R1iJX4FHbr-_GUICKdDvuTvqrJjcR2CQEpE_-GCYtJq-lLbDeec-WmOCZ6NIxW6rca1CRm-d1tSRUu2zFyAapHAjvmgvI5iN6Zvp8=@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 30 Jul 2020 18:59:20 +0300

> Convert to %pM instead of using custom code.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_mcp.c   | 5 ++---
>  drivers/net/ethernet/qlogic/qed/qed_sriov.c | 6 ++----
>  2 files changed, 4 insertions(+), 7 deletions(-)

Thanks!

Acked-by: Alexander Lobakin <alobakin@pm.me>

> diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethe=
rnet/qlogic/qed/qed_mcp.c
> index 988d84564849..5be08f83e0aa 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> @@ -2518,11 +2518,10 @@ int qed_mcp_fill_shmem_func_info(struct qed_hwfn =
*p_hwfn,
>  =09}
> =20
>  =09DP_VERBOSE(p_hwfn, (QED_MSG_SP | NETIF_MSG_IFUP),
> -=09=09   "Read configuration from shmem: pause_on_host %02x protocol %02=
x BW [%02x - %02x] MAC %02x:%02x:%02x:%02x:%02x:%02x wwn port %llx node %ll=
x ovlan %04x wol %02x\n",
> +=09=09   "Read configuration from shmem: pause_on_host %02x protocol %02=
x BW [%02x - %02x] MAC %pM wwn port %llx node %llx ovlan %04x wol %02x\n",
>  =09=09info->pause_on_host, info->protocol,
>  =09=09info->bandwidth_min, info->bandwidth_max,
> -=09=09info->mac[0], info->mac[1], info->mac[2],
> -=09=09info->mac[3], info->mac[4], info->mac[5],
> +=09=09info->mac,
>  =09=09info->wwn_port, info->wwn_node,
>  =09=09info->ovlan, (u8)p_hwfn->hw_info.b_wol_support);
> =20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/et=
hernet/qlogic/qed/qed_sriov.c
> index aa215eeeb4df..9489089706fe 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
> @@ -3276,14 +3276,12 @@ static void qed_iov_vf_mbx_ucast_filter(struct qe=
d_hwfn *p_hwfn,
> =20
>  =09DP_VERBOSE(p_hwfn,
>  =09=09   QED_MSG_IOV,
> -=09=09   "VF[%d]: opcode 0x%02x type 0x%02x [%s %s] [vport 0x%02x] MAC %=
02x:%02x:%02x:%02x:%02x:%02x, vlan 0x%04x\n",
> +=09=09   "VF[%d]: opcode 0x%02x type 0x%02x [%s %s] [vport 0x%02x] MAC %=
pM, vlan 0x%04x\n",
>  =09=09   vf->abs_vf_id, params.opcode, params.type,
>  =09=09   params.is_rx_filter ? "RX" : "",
>  =09=09   params.is_tx_filter ? "TX" : "",
>  =09=09   params.vport_to_add_to,
> -=09=09   params.mac[0], params.mac[1],
> -=09=09   params.mac[2], params.mac[3],
> -=09=09   params.mac[4], params.mac[5], params.vlan);
> +=09=09   params.mac, params.vlan);
> =20
>  =09if (!vf->vport_instance) {
>  =09=09DP_VERBOSE(p_hwfn,
> --=20
> 2.27.0

Al

