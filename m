Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A3D1801B0
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgCJPWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:22:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30494 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgCJPWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:22:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AFJpJZ008945;
        Tue, 10 Mar 2020 08:22:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=0KEZ4Xh6CHqPzN2W1KoMFGt+vQKAfKXksr3ux+JW720=;
 b=INXMtYUI2Xlu1fJ0UNuisDHNwT7SpQljpbl5Bca3rVcW/zxuetIt4dz90/CDiiDCNGoL
 lo/+qT/mslnAwELwlfRA7y7HCYDPT24y2wkVc9yAqmX6WtVLBvjgepRCS3cBcxv6RLuc
 FPsXOY3EluHW6s+462M31PdmrCI4je5S73LgmV/NOqAs/ISB0s2NiDOmz/l1waL586ws
 eoED1MUxV+/6msKrt+hpjnkREYDDVSj5+e3qx2y7qvyISCzu1ai+64bPx9tHcWXDcwdD
 WzZBsy3ePMsSgatd/WcoqEIIkGZnPssLVVK5GTPkVgIGEx22s2K4Wa0axSdlX7yRwi8R 8g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwpqsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:22:46 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:22:45 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:22:44 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:22:43 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id A73FB3F703F;
        Tue, 10 Mar 2020 08:22:42 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net 0/2] MACSec bugfixes related to MAC address change
Date:   Tue, 10 Mar 2020 18:22:23 +0300
Message-ID: <20200310152225.2338-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_10:2020-03-10,2020-03-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found out that there's an issue in MACSec code when the MAC address
is changed.
Both s/w and offloaded implementations don't update SCI when the MAC
address changes at the moment, but they should do so, because SCI contains
MAC in its first 6 octets.

Dmitry Bogdanov (2):
  net: macsec: update SCI upon MAC address change.
  net: macsec: invoke mdo_upd_secy callback when mac address changed

 drivers/net/macsec.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

-- 
2.17.1

