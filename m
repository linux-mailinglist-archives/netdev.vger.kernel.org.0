Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374042656AB
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgIKBau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgIKBau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:30:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 494C2208FE;
        Fri, 11 Sep 2020 01:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599787849;
        bh=Wy9X4q7qzX65CN5BuZ9Wshm/ZM9V8W4Mh5aVWfbcTV0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pg3R+t8Cp/gwkpQzviwf7p1VXVMJwzW9wRySg/cYHlYr4t6xaHQ16Vqf6P0xu6UUW
         ZXJ37E75UmiZjuThCJrZtjVDv7yykD3vrOuWfnyNIqXYyLDVl2uU4frffrZN58ztJG
         XDgTV+Cpim3h92oTw3c9xG2qxMZkKDMl+aFGA+2c=
Date:   Thu, 10 Sep 2020 18:30:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v8 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200910183047.39e4cd7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910150055.15598-2-vadym.kochan@plvision.eu>
References: <20200910150055.15598-1-vadym.kochan@plvision.eu>
        <20200910150055.15598-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 18:00:50 +0300 Vadym Kochan wrote:
> +static int prestera_sdma_tx_wait(struct prestera_sdma *sdma,
> +				 struct prestera_tx_ring *tx_ring)
> +{
> +	int tx_wait_num =3D PRESTERA_SDMA_WAIT_MUL * tx_ring->max_burst;
> +	bool is_ready;
> +
> +	return read_poll_timeout_atomic(prestera_sdma_is_ready, is_ready, true,
> +					1, tx_wait_num, false, sdma);
> +}

This is strange and generates a warning:

drivers/net/ethernet/marvell/prestera/prestera_rxtx.c: In function =E2=80=
=98prestera_sdma_tx_wait=E2=80=99:
drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:695:7: warning: varia=
ble =E2=80=98is_ready=E2=80=99 set but not used [-Wunused-but-set-variable]
  695 |  bool is_ready;
      |       ^~~~~~~~
