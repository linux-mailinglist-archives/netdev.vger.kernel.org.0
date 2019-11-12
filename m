Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87910F884B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 06:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfKLF4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 00:56:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51544 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725795AbfKLF4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 00:56:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573538190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t4H1BAGawGahyIzPrHbrHyHMfWVwsFAeBKzU7Z42zAo=;
        b=AkjoSmayGVAAMhbnFjP0BTCOzo4XoUQg3jiWRBBBJ8WIEPNEH7CJJUDnq0H0KBNWVLSNT+
        H6TCpgbAtyB9COvbWfu7X479/aC2lKTw2/x1HPTZ4b0M5dUVOsdFW8OWGYH4AgLr9Lr2pH
        xMaC4I1fKEFSR3CRqy+KQWMx+kuuVeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-OfrAog8PPI22IT-AmCI-Nw-1; Tue, 12 Nov 2019 00:56:27 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3645800C61;
        Tue, 12 Nov 2019 05:56:24 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D2D860852;
        Tue, 12 Nov 2019 05:56:18 +0000 (UTC)
Date:   Mon, 11 Nov 2019 21:56:17 -0800 (PST)
Message-Id: <20191111.215617.1625420574702786179.davem@redhat.com>
To:     Mark-MC.Lee@mediatek.com
Cc:     sean.wang@mediatek.com, john@phrozen.org, matthias.bgg@gmail.com,
        andrew@lunn.ch, robh+dt@kernel.org, mark.rutland@arm.com,
        opensource@vdorst.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net,v2 1/3] net: ethernet: mediatek: Integrate GDM/PSE
 setup operations
From:   David Miller <davem@redhat.com>
In-Reply-To: <20191111065129.30078-2-Mark-MC.Lee@mediatek.com>
References: <20191111065129.30078-1-Mark-MC.Lee@mediatek.com>
        <20191111065129.30078-2-Mark-MC.Lee@mediatek.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: OfrAog8PPI22IT-AmCI-Nw-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: MarkLee <Mark-MC.Lee@mediatek.com>
Date: Mon, 11 Nov 2019 14:51:27 +0800

> +static void mtk_gdm_config(struct mtk_eth *eth, u32 config)
> +{
> +=09int i;
> +
> +=09for (i =3D 0; i < MTK_MAC_COUNT; i++) {
> +=09=09u32 val =3D mtk_r32(eth, MTK_GDMA_FWD_CFG(i));
> +
> +=09=09/* default setup the forward port to send frame to PDMA */
> +=09=09val &=3D ~0xffff;
> +
> +=09=09/* Enable RX checksum */
> +=09=09val |=3D MTK_GDMA_ICS_EN | MTK_GDMA_TCS_EN | MTK_GDMA_UCS_EN;
> +
> +=09=09val |=3D config;
> +
> +=09=09mtk_w32(eth, val, MTK_GDMA_FWD_CFG(i));
> +=09}
> +=09/*Reset and enable PSE*/

Please put spaces before and after the comment sentence, like:

=09/* Reset and enable PSE */

