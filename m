Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B93F4A72F2
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344919AbiBBO0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:26:10 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:57156 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344905AbiBBO0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:26:09 -0500
Received: from ubuntu.home (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 5F0C4200F827;
        Wed,  2 Feb 2022 15:26:07 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 5F0C4200F827
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1643811967;
        bh=rS6Zj4XOuxkbE47QLxsSv9GiPzJiuGynTucwTs+u4AQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Ir6DtPku7Svo/3iLDv7Vy3cUW26OxC3WMQEP6Qp6u/WcAJfqY6z1U4LWmuMvQiP57
         MnlNA8+DKThGv3Wd/ZR37hV2bQllFGDArLfPCiJ+9/u0TGu9TraBpf6ZToe8pLEJdu
         ydu43jj0CVVT9GBWeQtaAOgWe5YXpkB7rnimQBL+6LSfrVXnF3CM55fxapb717QBsk
         wBEjwMpNc1chFr6Msxnk0Stu0hAAQMChFVix3E9qwz2qeWKTRbBGhN/BM/SmtIZmbx
         rnbEF9a/uSROGeK39SFfROiYxG8CURjqlEhlONdPWfIN7XeMKHUOGHMw9pcxJDN6rn
         vGYC3o2eKDryQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next v2 0/2] Support for the IOAM insertion frequency
Date:   Wed,  2 Feb 2022 15:25:52 +0100
Message-Id: <20220202142554.9691-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
 - signed -> unsigned (for "k" and "n")
 - keep binary compatibility by moving "k" and "n" at the end of uapi

The insertion frequency is represented as "k/n", meaning IOAM will be
added to {k} packets over {n} packets, with 0 < k <= n and 1 <= {k,n} <=
1000000. Therefore, it provides the following percentages of insertion
frequency: [0.0001% (min) ... 100% (max)].

Not only this solution allows an operator to apply dynamic frequencies
based on the current traffic load, but it also provides some
flexibility, i.e., by distinguishing similar cases (e.g., "1/2" and
"2/4").

"1/2" = Y N Y N Y N Y N ...
"2/4" = Y Y N N Y Y N N ...

Justin Iurman (2):
  uapi: ioam: Insertion frequency
  ipv6: ioam: Insertion frequency in lwtunnel output

 include/uapi/linux/ioam6_iptunnel.h |  9 +++++
 net/ipv6/ioam6_iptunnel.c           | 59 ++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 2 deletions(-)

-- 
2.25.1

