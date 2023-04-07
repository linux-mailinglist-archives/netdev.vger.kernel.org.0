Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF7C6DAACF
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240574AbjDGJX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240509AbjDGJXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:23:51 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168AEAD3A
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 02:23:49 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PtCbj0yW7z4f3wYC
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 17:23:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.102.38])
        by APP4 (Coremail) with SMTP id gCh0CgCX_7Ig4S9kT5WUGw--.50826S4;
        Fri, 07 Apr 2023 17:23:46 +0800 (CST)
From:   Wei Yongjun <weiyongjun@huaweicloud.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Joseph CHAMG <josright123@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nathan Huckleberry <nhuck@google.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
        Wells Lu <wellslutw@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: davicom: Make davicom drivers not depends on DM9000
Date:   Fri,  7 Apr 2023 09:49:30 +0000
Message-Id: <20230407094930.2633137-1-weiyongjun@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCX_7Ig4S9kT5WUGw--.50826S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw4DZr15tF4kGF4fuF15Jwb_yoWDAwb_Kr
        W0gr4Yqw4UGrsYvw4v9F48X3s0krs8Zw1fZay7try3Jr4qkry5G3ZruryxJr4Y93W5CF9r
        Aanaqa4Iy342qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb28YFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0x
        vE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: 5zhl50pqjm3046kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

All davicom drivers build need CONFIG_DM9000 is set, but this dependence
is not correctly since dm9051 can be build as module without dm9000, switch
to using CONFIG_NET_VENDOR_DAVICOM instead.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 0d872d4efcd1..ee640885964e 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -32,7 +32,7 @@ obj-$(CONFIG_NET_VENDOR_CIRRUS) += cirrus/
 obj-$(CONFIG_NET_VENDOR_CISCO) += cisco/
 obj-$(CONFIG_NET_VENDOR_CORTINA) += cortina/
 obj-$(CONFIG_CX_ECAT) += ec_bhf.o
-obj-$(CONFIG_DM9000) += davicom/
+obj-$(CONFIG_NET_VENDOR_DAVICOM) += davicom/
 obj-$(CONFIG_DNET) += dnet.o
 obj-$(CONFIG_NET_VENDOR_DEC) += dec/
 obj-$(CONFIG_NET_VENDOR_DLINK) += dlink/
-- 
2.34.1

