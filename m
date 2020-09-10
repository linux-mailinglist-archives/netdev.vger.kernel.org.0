Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9B126516A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgIJUyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730871AbgIJOuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:50:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C88A2076D;
        Thu, 10 Sep 2020 14:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599748926;
        bh=+gsiRg3WcLfihlR/th8sz9qrLSLS3vhLBD2R94NOnFg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OB+t3CM62uUeMsu929LsTXuoaHmNV8FlCgLUJE2WUdJb/Znl/KJayAD3JFC8JJdAr
         ZyZz19YlqG0W1ySsbo53ySmEs4uqlVoKE1E7aTw4Y28PGrkHH34lr3qJrgz0w9lfLp
         85XKBzk8ZnlYSTPNKuwwqyDaQn0tOXwXbnbF90SQ=
Date:   Thu, 10 Sep 2020 07:42:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 4/5] dpaa2-eth: utilize skb->cb[0] for hardware
 timestamping
Message-ID: <20200910074204.2535d416@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910093835.24317-5-yangbo.lu@nxp.com>
References: <20200910093835.24317-1-yangbo.lu@nxp.com>
        <20200910093835.24317-5-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 17:38:34 +0800 Yangbo Lu wrote:
> @@ -2107,7 +2111,7 @@ static int dpaa2_eth_xdp_create_fd(struct net_devic=
e *net_dev,
>  	/* We require a minimum headroom to be able to transmit the frame.
>  	 * Otherwise return an error and let the original net_device handle it
>  	 */
> -	needed_headroom =3D dpaa2_eth_needed_headroom(priv, NULL);
> +	needed_headroom =3D dpaa2_eth_needed_headroom(NULL);
>  	if (xdpf->headroom < needed_headroom)
>  		return -EINVAL;
> =20
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c: In function =E2=80=98dpaa=
2_eth_xdp_create_fd=E2=80=99:
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2104:25: warning: unused v=
ariable =E2=80=98priv=E2=80=99 [-Wunused-variable]
 2104 |  struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);
      |                         ^~~~
