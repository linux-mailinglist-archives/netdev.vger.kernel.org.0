Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57E3307753
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 14:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhA1NmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 08:42:20 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10848 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhA1NmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 08:42:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012bf110003>; Thu, 28 Jan 2021 05:41:37 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 13:41:37 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 28 Jan 2021 13:41:35 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, <elic@nvidia.com>
Subject: [PATCH 0/2] Fix failure to hot add memory
Date:   Thu, 28 Jan 2021 15:41:28 +0200
Message-ID: <20210128134130.3051-1-elic@nvidia.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611841297; bh=DisB0kHtwE92+PqVn4btpi5qX92YhpfOEYqfJRcGINA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=hs0xW+1Iem9MEqgagvn4JZbZTPxdjnjZ0mx7qkMrR19E+ETVwZAby5OdVSbXmrH8v
         tCuHkdd9zVY5iHAiN4XguzrmjMikCG4zMIyZVOqFHClNC/fhfjRVJ91bywMu1QnCdT
         vwh3BoFE4W36qu0K9omlNLvvgs4N4tXUw0px1lGJxLZqnYQM0DVCyP2bbETYCoS6Cg
         l1N+F5ZHyWYNfPlWpfENHev04Caj851UgqAJuXloORr7Rt/v6U89aeJGEtLgUpHRS+
         B4OVT7RX4rRZKRGUzHpxYjwBooDdjSC3S9bimGCJRjVld/F1TxWuC4NXAwKzurARhM
         4hjjgExt5F1aw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,
The following two patches are a fixing a failure to update the hardware
with the updated used index. This results in a failure to to hot add
memory to the guest which results in a memory map update and teardown
and re-create of the resources.

The first patch just removes unnecessary code. The second on is the
actual fix.

Eli Cohen (2):
  vdpa/mlx5: Avoid unnecessary query virtqueue
  vdpa/mlx5: Restore the hardware used index after change map

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--=20
2.29.2

