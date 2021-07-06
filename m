Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3F03BC48F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 03:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGFBSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 21:18:35 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:60743 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhGFBSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 21:18:35 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id EAF19806B6;
        Tue,  6 Jul 2021 13:15:53 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1625534153;
        bh=7EH8newCu/5rldYs/AL9Gg04ut1kOlRle/EtodLUUno=;
        h=From:To:Cc:Subject:Date;
        b=i0wMqBFmN5puqg6QTxMfAo6e6LTXDeNntERIv9XaSTa6r0zSHuV4hL903rG/X1T0z
         JW1CQ9PVFgH5djDL/CCZ3EOQApOA35ZyMqCvvDv0A2LR7dX1Py05nShCUMdRxegu71
         2V+6MSbMFDA2JUlelj8BSF4qXmd6KWLeOLHTGHz4kAI8uA7dmjWA3zfnTZJ3Vi+2+n
         vs1gBYAOlSHYGaSCuxCEiNR7AuUJMv+p9qvTVDRBaU8BNCUDmuY0XC7YKNeYuq6H+q
         rIIuj2Jbt5ZU09cbSMOOdxlEs9HcoJ3c766LwaNDMAweRuSfA2i0Ge7Od77DNUvRKY
         WHkLv+lMRRcVQ==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60e3aec90000>; Tue, 06 Jul 2021 13:15:53 +1200
Received: from callums-dl.ws.atlnz.lc (callums-dl.ws.atlnz.lc [10.33.22.16])
        by pat.atlnz.lc (Postfix) with ESMTP id BFAD913EE58;
        Tue,  6 Jul 2021 13:15:53 +1200 (NZST)
Received: by callums-dl.ws.atlnz.lc (Postfix, from userid 1764)
        id B7D12A028D; Tue,  6 Jul 2021 13:15:53 +1200 (NZST)
From:   Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
To:     dsahern@kernel.org, nikolay@nvidia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.luessing@c0d3.blue,
        Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
Subject: [PATCH] net: Allow any address multicast join for IP sockets
Date:   Tue,  6 Jul 2021 13:15:47 +1200
Message-Id: <20210706011548.2201-1-callum.sinclair@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=IOh89TnG c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=e_q4qTt1xDgA:10 a=Mf_EwY-YAuCiQXJ_BIEA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For an application to receive all multicast packets in a range such as
224.0.0.1 - 239.255.255.255 each multicast IP address has to be joined
explicitly one at a time.

Allow the any address to be passed to the IP_ADD_MEMBERSHIP and
IPV6_ADD_MEMBERSHIP socket option per interface. By joining the any
address the socket will receive all multicast packets that are received
on the interface.=20

This allows any IP socket to be used for IGMP or MLD snooping.

Callum Sinclair (1):
  net: Allow any address multicast join for IP sockets

 net/ipv4/igmp.c  | 40 ++++++++++++++++++++++++++++++++--------
 net/ipv6/mcast.c | 20 ++++++++++++++------
 2 files changed, 46 insertions(+), 14 deletions(-)

--=20
2.32.0

