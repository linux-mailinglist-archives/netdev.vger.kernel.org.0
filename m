Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15E31B6FDF
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgDXIjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:39:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38050 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbgDXIjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:39:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O8a2jM026673;
        Fri, 24 Apr 2020 01:39:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=DUTHw+iDhuNP/Za81i4Bb+fIhMRVn9BvZ1r4jDQCWX8=;
 b=dW3FI3ray2Vv+0YwirIz8OkLSgmiPj04teSfvbEd0REtqbfZ2NVlwv4wWp300zoSZyme
 0FOLS8ovp602Uh+sas2on6QE/194fODNZlXo4uySIQNPr1Ub/HQ2bobsHkCYNBWPLmpc
 qYedvE/Yeyq9NWqbiA4Z32Gum1RcUzPPjvB3tehRfJLqKQtoomJkagZsAFDpbLPODXpz
 YLk3jDei6HKLWNlxQBB1bVoXRKQkOkNeECpPZgJh1alWOg66+jFn6xkbIfdBeS8HSPIf
 XXsSvFhp+2ShPx2pXgCM9fEroQRx+dIaxKyHn+Wve5k6B3c5cVG0Drw3VoIX24OeZWaD UQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsbcg7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 01:39:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 01:39:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 01:39:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 01:39:01 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 256463F703F;
        Fri, 24 Apr 2020 01:38:59 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: [PATCH iproute2-next 0/2] macsec: add offloading support
Date:   Fri, 24 Apr 2020 11:38:55 +0300
Message-ID: <20200424083857.1265-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This series adds support for selecting the offloading mode of a MACsec
interface at link creation time.
Available modes are for now 'off', 'phy' and 'mac', 'off' being the default
when an interface is created.

First patch adds support for MAC offloading.

Last patch allows a user to change the offloading mode at runtime
through a new attribute, `ip link add link ... offload`:

  # ip link add link enp1s0 type macsec encrypt on offload off
  # ip link add link enp1s0 type macsec encrypt on offload phy
  # ip link add link enp1s0 type macsec encrypt on offload mac

Mark Starovoytov (2):
  macsec: add support for MAC offload
  macsec: add support for specifying offload at link add time

 ip/ipmacsec.c        | 23 ++++++++++++++++++++++-
 man/man8/ip-macsec.8 | 10 ++++++++--
 2 files changed, 30 insertions(+), 3 deletions(-)

-- 
2.20.1

