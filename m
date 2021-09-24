Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886E1416C93
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244319AbhIXHNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:13:06 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27962 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244268AbhIXHNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:13:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18NNeJLJ011146;
        Thu, 23 Sep 2021 23:19:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=yz0nsJp5OcQrn3pYiwpUzi+cdLkrIua2UQrZxXFp+UM=;
 b=KixeblfmoQnCvxoFx4KPGsR9Oche3VdalSqs3EN6HVpBWzbKLsQYIPruvy/U7kkGf3dK
 dRoXQYEdbjwoJQlfq5Su7c2tTgaVTDEnNg1bBJlG2M6mj3N6PPS4xqT1fXL9prNKvIC+
 MrvtGO5Pr2Et7fPhZXXafRraVVHLH9v9QEK0zIDvQbZGkb1SQHw9soFxuACFci+1hr/9
 rhxu//oxIqY5isBmiEcXBNtK5a34a597GbnPy+4qFHwbQafG/zAftF6rkiqj1uRJywpx
 894f9y3GcXEeoTnKPc15/YJ1l8tgHM0pX4EC/3+EQJLUloKB975ALCVnI4DtVd1shhjz Ug== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b93f890nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 23:19:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 23:19:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Sep 2021 23:19:06 -0700
Received: from localhost.localdomain (unknown [10.28.34.15])
        by maili.marvell.com (Postfix) with ESMTP id BA85F3F7077;
        Thu, 23 Sep 2021 23:19:02 -0700 (PDT)
From:   <kirankumark@marvell.com>
To:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Kiran Kumar K <kirankumark@marvell.com>
Subject: [net-next 0/2] adding KPU profile changes for GTPU and custom
Date:   Fri, 24 Sep 2021 11:48:49 +0530
Message-ID: <20210924061851.680922-1-kirankumark@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: omG1SF_5ZyZEDZE90OiWOf276jZyoakA
X-Proofpoint-ORIG-GUID: omG1SF_5ZyZEDZE90OiWOf276jZyoakA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-24_01,2021-09-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran Kumar K <kirankumark@marvell.com>

Adding changes to limit the KPU processing for GTPU headers to parse
packet up to L4 and added changes to variable length headers to parse LA
as part of PKIND action.

Kiran Kumar K (2):
  octeontx2-af: Limit KPU parsing for GTPU packets
  octeontx2-af: Optimize KPU1 processing for variable-length headers

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  20 +-
 .../net/ethernet/marvell/octeontx2/af/npc.h   |   9 +-
 .../marvell/octeontx2/af/npc_profile.h        | 403 +++---------------
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   5 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |   2 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   4 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  96 +++++
 7 files changed, 197 insertions(+), 342 deletions(-)

--
2.25.1

