Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688C0EB82F
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfJaT7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:59:25 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36599 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726741AbfJaT7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:59:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572551964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xyKb0AlQehYN2iuWlX59rLjDz/ARumkzDBfUO6cn4Xo=;
        b=evVhaomjlmfbFci6FHUeoerU1fPFvUGEhIs3br/eNNmtsEGjmB90K2EUp1OSx5LKpuybdo
        oNLy39ysH5Ywj0J0iJZgaTir1KlfvtT8pKlxsnKqy5cUcT/Ze47wjrvLAhPIi+c4aeL2mn
        vvLWEge7ufTzcZxrWzv/rNoQ0fz93yE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342---Ocs4-uP-2s39-8_6l_Qw-1; Thu, 31 Oct 2019 15:59:21 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D4E7107ACC0;
        Thu, 31 Oct 2019 19:59:20 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17781600CD;
        Thu, 31 Oct 2019 19:59:15 +0000 (UTC)
Date:   Thu, 31 Oct 2019 20:59:14 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Charles McLachlan <cmclachlan@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, brouer@redhat.com
Subject: Re: [PATCH net-next v4 2/6] sfc: perform XDP processing on received
 packets
Message-ID: <20191031205914.16df4021@carbon>
In-Reply-To: <63b437c4-30b2-0e6a-421f-5845b83ca64b@solarflare.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
        <63b437c4-30b2-0e6a-421f-5845b83ca64b@solarflare.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: --Ocs4-uP-2s39-8_6l_Qw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 10:23:23 +0000
Charles McLachlan <cmclachlan@solarflare.com> wrote:

> Adds a field to hold an attached xdp_prog, but never populates it (see
> following patch).  Also, XDP_TX support is deferred to a later patch
> in the series.
>=20
> Track failures of xdp_rxq_info_reg() via per-queue xdp_rxq_info_valid
> flags and a per-nic xdp_rxq_info_failed flag. The per-queue flags are
> needed to prevent attempts to xdp_rxq_info_unreg() structs that failed
> to register.  Possibly the API could be changed in the future to avoid
> the need for these flags.
>=20
> Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/efx.c        |   5 +-
>  drivers/net/ethernet/sfc/net_driver.h |  12 +++
>  drivers/net/ethernet/sfc/rx.c         | 130 +++++++++++++++++++++++++-
>  3 files changed, 145 insertions(+), 2 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

