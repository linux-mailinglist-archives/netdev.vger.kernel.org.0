Return-Path: <netdev+bounces-9209-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B20727F3D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:44:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F27A61C20ADC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6FC1119C;
	Thu,  8 Jun 2023 11:42:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECF312B6D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:42:24 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931B0E6C;
	Thu,  8 Jun 2023 04:42:17 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3580DHYG005521;
	Thu, 8 Jun 2023 04:42:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=k0JbJgWQMnOxCC7xgPDDWP4Ea1HJDQ7G2q0EpBsecVA=;
 b=NJmpQ6oqMmys3ngVV8CjXyLB1dfyO0Z18G2a4FcA9WUb2+1nXOF+/sD0WsaI6KYUierR
 CLuD9RO9ZmRZycBqOF5f608Y7OKj/K4uId0mk95Ft+GxtTnHZer+2ZAgOelGYofK5cQk
 bYsTentgPxfGdX5X1A/2p26mQPvv3InAeE5MMyq203RdG9A5M6797Xnayn4MslY27Vqb
 nHGWOQD6s6PghIwBRy3Lk5Wq4yjJiGGMSFTTgA7kj/1AWhJfitOOVACaAQ8+d1/FlBBo
 KxyVEw/8giOZCqGBoJ8asAUwiEFhLgDdnk9wByyvjpzlbFvcz8TgC0Zx4jxEk7IMaXFS 1g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r30eu2csc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 08 Jun 2023 04:42:07 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 8 Jun
 2023 04:42:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 8 Jun 2023 04:42:05 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id 711593F703F;
	Thu,  8 Jun 2023 04:42:03 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net PATCH 0/2] RVU NIX AF driver fixes
Date: Thu, 8 Jun 2023 17:11:59 +0530
Message-ID: <20230608114201.31112-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: nUsjLOfHUiy-Ge0ZhvlHUfwAeAuNyhx9
X-Proofpoint-GUID: nUsjLOfHUiy-Ge0ZhvlHUfwAeAuNyhx9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_08,2023-06-08_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch series contains few fixes to the RVU NIX AF driver.

The first patch modifies the driver check to validate whether the req count
for contiguous and non-contiguous arrays is less than the maximum limit.

The second patch fixes HW lbk interface link credit programming.

Nithin Dabilpuram (1):
  octeontx2-af: fix lbk link credits on cn10k

Satha Rao (1):
  octeontx2-af: fixed resource availability check

 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

-- 
2.39.0.198.ga38d39a4c5


