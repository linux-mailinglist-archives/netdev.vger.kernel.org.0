Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1980B327564
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 00:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhB1XxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 18:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhB1XxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 18:53:12 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA28C06174A
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 15:52:31 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 80B63806B7;
        Mon,  1 Mar 2021 12:52:28 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1614556348;
        bh=TjAbNQH/NYykn1brklhYh1K6vaIb607P6QqDXERWPcQ=;
        h=From:To:Cc:Subject:Date;
        b=cLqV3/DG9pbEyoncZhMnCl8MOw5lfWvZK9RyNodHgjv2SRCUW80xA7leUGqVHh2u2
         Gfd3Js9dj9VsTlo/dzHxgl4K1fWDf9/CEGZEtR+TvXrCODAQowQpatouivyippRvEc
         f8GcEqkjZNsD4lnaApcGUbUkgNwGxDdJoOb6l+HJ6vvM5B1RZggyYMv+1oAXoVQpNS
         AopIYx8lf+BiLHfhTzZmBoiFuurcPQjKjz0DP3xh6wmVkPm/SeHeUuQs2LiFNHZaLG
         4yAmX+pf7yb56agb6etyvYn7j50VX4dJdSdiEJMGbw03yTE1yXyuy+NBZAMmYHOkg1
         Xu6R9AWEvQTrg==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B603c2cbc0000>; Mon, 01 Mar 2021 12:52:28 +1300
Received: from henrys-dl.ws.atlnz.lc (henrys-dl.ws.atlnz.lc [10.33.23.26])
        by smtp (Postfix) with ESMTP id C9A5F13EF08;
        Mon,  1 Mar 2021 12:52:38 +1300 (NZDT)
Received: by henrys-dl.ws.atlnz.lc (Postfix, from userid 1052)
        id 5D84E4E19B6; Mon,  1 Mar 2021 12:52:28 +1300 (NZDT)
From:   Henry Shen <henry.shen@alliedtelesis.co.nz>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris.packham@alliedtelesis.co.nz,
        Henry Shen <henry.shen@alliedtelesis.co.nz>
Subject: [PATCH] net:ipv4: Packet is not forwarded when ingress interface is not configured with bc_forwarding
Date:   Mon,  1 Mar 2021 12:52:23 +1300
Message-Id: <20210228235224.30445-1-henry.shen@alliedtelesis.co.nz>
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

