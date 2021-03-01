Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EFB3275AB
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 01:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhCAAyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 19:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhCAAyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 19:54:06 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F21C061756
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 16:53:25 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 3594C806B7;
        Mon,  1 Mar 2021 13:53:21 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1614560001;
        bh=TjAbNQH/NYykn1brklhYh1K6vaIb607P6QqDXERWPcQ=;
        h=From:To:Cc:Subject:Date;
        b=INGk5d0WGqe3owJDYiwv06bFFANjwSK2MdA/+MjKoO5Lj50M6hCGzA+9bZSc8MmUd
         QpuCwCJ6UbEGM7f08uwO4a6DHCTirwPGwTQVAqTUAjVn8KIuweu8B+SGza6qm9Buur
         19PpLvVqbER/08Z4T5AQGRBfi13u3bLkulycVG0hxQ/xMKHjSMtwF4lwdRcflqFlDB
         McoLXjj6eC9fAN0fuAffMJSK3EJDNgtsij5k3XjhNa+P0GQ2/RhyqMUEar79dVZrvU
         L2MVCA9GkvzABVG+xCyAYAETBTC0AW+Is6pJMWWjr2E9znyLsyydgB8GIhBsop1e3f
         U+G2COsPTcraQ==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B603c3b010000>; Mon, 01 Mar 2021 13:53:21 +1300
Received: from henrys-dl.ws.atlnz.lc (henrys-dl.ws.atlnz.lc [10.33.23.26])
        by smtp (Postfix) with ESMTP id 7E25C13EF08;
        Mon,  1 Mar 2021 13:53:31 +1300 (NZDT)
Received: by henrys-dl.ws.atlnz.lc (Postfix, from userid 1052)
        id 0FB734E19B6; Mon,  1 Mar 2021 13:53:21 +1300 (NZDT)
From:   Henry Shen <henry.shen@alliedtelesis.co.nz>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris.packham@alliedtelesis.co.nz,
        Henry Shen <henry.shen@alliedtelesis.co.nz>
Subject: [PATCH] net:ipv4: Packet is not forwarded when ingress interface is not configured with bc_forwarding
Date:   Mon,  1 Mar 2021 13:53:17 +1300
Message-Id: <20210301005318.8959-1-henry.shen@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7uXNjH+ c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=dESyimp9J3IA:10 a=-2i4ktxzaliv6IimGlkA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow an IPv4 packet with a destination address of broadcast to be forwar=
ded=20
if the ingress interface is not configured with bc_forwarding but the egr=
ess=20
interface is. This is inline with Cisco's implementation of directed=20
broadcast.

Henry Shen (1):
  net:ipv4: Fix pakcet not forwarded when ingress interface is not
    configured with bc_forwarding

 net/ipv4/route.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--=20
2.30.1

