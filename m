Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B83B137C69
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgAKIeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:34:03 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36850 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728641AbgAKIeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 03:34:03 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 90C47CE2EC48E026DEB9;
        Sat, 11 Jan 2020 16:34:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 16:33:52 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/7] net: hns3: add some misc update about reset issue
Date:   Sat, 11 Jan 2020 16:33:46 +0800
Message-ID: <1578731633-10709-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some misc update relating to reset issue.
[patch 1/7] & [patch 2/7] splits hclge_reset()/hclgevf_reset()
into two parts: preparing and rebuilding. Since the procedure
of FLR should be separated out from the reset task([patch 3/7 &
patch 3/7]), then the FLR's processing can reuse these codes.

pci_error_handlers.reset_prepare() is void type function, so
[patch 6/7] & [patch 7/7] factor some codes related to PF
function reset to make the preparing done before .reset_prepare()
return.

BTW, [patch 5/7] enlarges the waiting time of reset for matching
the hardware's.

Huazhong Tan (7):
  net: hns3: split hclge_reset() into preparing and rebuilding part
  net: hns3: split hclgevf_reset() into preparing and rebuilding part
  net: hns3: refactor the precedure of PF FLR
  net: hns3: refactor the procedure of VF FLR
  net: hns3: enlarge HCLGE_RESET_WAIT_CNT
  net: hns3: modify hclge_func_reset_sync_vf()'s return type to void
  net: hns3: refactor the notification scheme of PF reset

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   5 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 204 ++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 195 ++++++++++----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 5 files changed, 194 insertions(+), 212 deletions(-)

-- 
2.7.4

