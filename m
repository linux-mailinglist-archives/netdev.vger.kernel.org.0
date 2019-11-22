Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD131076C6
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfKVRyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:54:46 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:38394 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfKVRyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:54:45 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 45850B4005A;
        Fri, 22 Nov 2019 17:54:43 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 22 Nov
 2019 17:54:31 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/4] sfc: ARFS expiry improvements
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, David Ahern <dahern@digitalocean.com>
Message-ID: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
Date:   Fri, 22 Nov 2019 17:54:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25058.003
X-TM-AS-Result: No-1.316000-8.000000-10
X-TMASE-MatchedRID: aXvf+Zg2vDG1Hdke1yr591D5LQ3Tl9H7BnIRIVcCWN/IDyxrEi1Fa8Q5
        vcyCjz1I6QzpMtwrwpw/Lodj+FCLCWptg0usYtagPE3khmVvHO41X1Ls767cpmMunwKby/AXCh5
        FGEJlYgHJ/hRSI+YUum8pKa7updu+kwqG9GH9l96eAiCmPx4NwLTrdaH1ZWqCZYJ9vPJ1vSDefx
        4FmMaZTOTCMddcL/gjxlblqLlYqXJeWoX7Pzse13R4AJiXvLesfG/ckLYYESU1VqbFMaSr9V7Cd
        RP5piN0rDaK5/bodH93pWiVXr22dnNZ6RCAIh4Yivu9DFz3v76QRHK5EcWCeFIypztSlSisEpGw
        8LptO86qtDFfJ0jAbwAXzdZ50duF
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.316000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25058.003
X-MDID: 1574445284-WeGqiFHXUOVh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A series of changes to how we check filters for expiry, manage how much
 of that work to do & when, etc.
Prompted by some pathological behaviour under heavy load, which was
Reported-By: David Ahern <dahern@digitalocean.com>

Edward Cree (4):
  sfc: change ARFS expiry mechanism
  sfc: suppress MCDI errors from ARFS
  sfc: add statistics for ARFS
  sfc: do ARFS expiry work occasionally even without NAPI poll

 drivers/net/ethernet/sfc/ef10.c       |  8 +++-
 drivers/net/ethernet/sfc/efx.c        | 14 +++---
 drivers/net/ethernet/sfc/efx.h        | 19 +++++---
 drivers/net/ethernet/sfc/ethtool.c    |  6 +++
 drivers/net/ethernet/sfc/net_driver.h | 20 +++++---
 drivers/net/ethernet/sfc/rx.c         | 68 +++++++++++++++++++--------
 6 files changed, 94 insertions(+), 41 deletions(-)

