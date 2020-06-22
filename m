Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6EA203A03
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgFVOxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:53:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28068 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728956AbgFVOxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:53:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MEZHHj003841;
        Mon, 22 Jun 2020 07:53:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=jjM2MG3jpi1Al8kziTPdNDxXKoQIgOORwmRPJYNToL4=;
 b=fkx/VglPwxsTLfP9DkaPnu9U+gqDYIsoM4sx6sFeQ/PQJk6A0euovnQ75LXljkBoHx7A
 ehovGlYnSFQ+gaeTXVwovzXY75uU1e4F8aoynU58YSjHxqOdy+hMz2yCxEtONn8924bQ
 NCfKlrkUk3bLe/Y1INZufGcLgN0su/LGBPa2I/VgZWE9U7ft2GfhtpKLQauIGYYyJQFw
 uiAanXfgvcnMgyOh5Ta4N5M7lsnMUnS66in5xRvvTY0dFE535YmJOvjEgcXOhc5dnk1y
 KlEU7E6EilhNm5AWDaT3H44oz9SS+/0iJtTKz+We0We6VJtV6FUlnodYFE0XvawVoz8t 9g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynrhq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 07:53:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 07:53:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 07:53:13 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 1A9D03F703F;
        Mon, 22 Jun 2020 07:53:11 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 0/6] net: atlantic: additional A2 features
Date:   Mon, 22 Jun 2020 17:53:03 +0300
Message-ID: <20200622145309.455-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_08:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds more features to A2:
 * half duplex rates;
 * EEE;
 * flow control;
 * link partner capabilities reporting;
 * phy loopback.

Feature-wise A2 is almost on-par with A1 save for WoL and filtering, which
will be submitted as separate follow-up patchset(s).

Dmitry Bogdanov (2):
  net: atlantic: A2: report link partner capabilities
  net: atlantic: A2: phy loopback support

Igor Russkikh (2):
  net: atlantic: A2: half duplex support
  net: atlantic: A2: flow control support

Nikita Danilov (2):
  net: atlantic: remove baseX usage
  net: atlantic: A2: EEE support

 .../ethernet/aquantia/atlantic/aq_common.h    |  18 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  19 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  10 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 109 +++++++++--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |   4 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |   3 +
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |   1 +
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |   1 +
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |   9 +-
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 174 ++++++++++++++++++
 10 files changed, 313 insertions(+), 35 deletions(-)

-- 
2.25.1

