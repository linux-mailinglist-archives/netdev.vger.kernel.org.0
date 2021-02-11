Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4136C3189A7
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhBKLiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:38:54 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19827 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhBKLgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:36:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602516a80000>; Thu, 11 Feb 2021 03:36:08 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 11:36:07 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 11:36:04 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 0/3] Compile-flag for sock RX queue mapping
Date:   Thu, 11 Feb 2021 13:35:50 +0200
Message-ID: <20210211113553.8211-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613043368; bh=h+m/6PXybwii7MQmQcbcUAxK08i9uilBhzTQkK7Gnnk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=enKEbC0G4qrLjjiMFuLMpc5NyNv9idcfO159je9+rWoFrwQOXny08jTI8Op9HfKbp
         YLxcudjtMB2b66kvxNRybjev77dQCG1BDzLsEO4Po18nVm+Vy/8ASbKes4h7ArrAl2
         Lua2xGd9MGblLHmsr3ih8xWge751jQUOE0+C/0RdhSSp0AjIbnMMmhEDYTA3WDWVbQ
         FdvMXlHZjWeOquO7BUySNnW9g6FvLpwjzbm/q669dXFlsqTvOo2ZKyIcKHEUW7ei4c
         bkKdhB3nRbfvO3CyvLX0+3XfxwyVtIL+UwIbZVXvvyq19muS9Ciu2BtZqaJFUkDcd8
         lX3fgglF+f6Zw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Socket's RX queue mapping logic is useful also for non-XPS use cases.
This series breaks the dependency between the two, introducing a new
kernel config flag SOCK_RX_QUEUE_MAPPING.

Here we select this new kernel flag from TLS_DEVICE, as well as XPS.

Regards,
Tariq

Tariq Toukan (3):
  net/sock: Add kernel config SOCK_RX_QUEUE_MAPPING
  net/tls: Select SOCK_RX_QUEUE_MAPPING from TLS_DEVICE
  net/mlx5: Remove TLS dependencies on XPS

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig |  2 --
 include/net/sock.h                              | 12 ++++++------
 net/Kconfig                                     |  4 ++++
 net/core/filter.c                               |  2 +-
 net/tls/Kconfig                                 |  1 +
 5 files changed, 12 insertions(+), 9 deletions(-)

--=20
2.21.0

