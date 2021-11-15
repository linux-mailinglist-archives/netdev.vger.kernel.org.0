Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F03451645
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346334AbhKOVS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:18:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347179AbhKOUj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:39:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637008593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bPYUh0OhJjU9fdv3+7WdB7aWrvMxAgiWAI1AFl3R1/s=;
        b=R7KIyeCUvU5zgdwAtkvnserEnCr+2pJzAKYjSbQeHYPgquE0E0mMyn9xRtJ5FzhrxE19ZL
        ZsiE/TfsHY2/LuIRYg5139rNNs2JEC+utAVwrlmwd12XOMgqE3aEyknxbmE4PzRWCQDdyU
        Up1lfV3HqNZomHt4a0QxQmpsruQZ4IM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-tMhi55ZAPPub8i3exNJDhA-1; Mon, 15 Nov 2021 15:36:30 -0500
X-MC-Unique: tMhi55ZAPPub8i3exNJDhA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 541758799EF;
        Mon, 15 Nov 2021 20:36:28 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49A705F4E1;
        Mon, 15 Nov 2021 20:36:22 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id BE3CE30027803;
        Mon, 15 Nov 2021 21:36:20 +0100 (CET)
Subject: [PATCH net-next 0/2] igc: driver change to support XDP metadata
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com,
        bjorn@kernel.org
Date:   Mon, 15 Nov 2021 21:36:20 +0100
Message-ID: <163700856423.565980.10162564921347693758.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes to fix and enable XDP metadata to a specific Intel driver igc.
Tested with hardware i225 that uses driver igc, while testing AF_XDP
access to metadata area.

---

Jesper Dangaard Brouer (2):
      igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS
      igc: enable XDP metadata in driver


 drivers/net/ethernet/intel/igc/igc_main.c |   33 +++++++++++++++++++----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--

