Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F22A607715
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiJUMj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiJUMjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:39:03 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D57266438
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:38:47 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221021123844epoutp030c4a603bb4322ecaa0c54a9e0d9c3852~gFeJdFKpM0743307433epoutp03g
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:38:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221021123844epoutp030c4a603bb4322ecaa0c54a9e0d9c3852~gFeJdFKpM0743307433epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666355924;
        bh=JtkMA5D8SVkPb9doEE5f+t/tBPmUae3KaqaNnSWbDGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/iAtTEnTDeko2vN7NCLowhfyxiQG9Twn+T3J6Ib6mErerIHOhBOdvAbBunrCa2U4
         A/UFLELuS/SQReNVkvUgOgmJUg5/DxKLQiaWzDxLo/xWgMSube0DF8lDgdRxkTAj8W
         vmFeFL3FWNIbg9XNhkh9WZ7CyO6aESHNlttlc1/w=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221021123843epcas5p28a0c98a56bdf36dc3c0abadee4964292~gFeJFZdnr2156121561epcas5p2m;
        Fri, 21 Oct 2022 12:38:43 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Mv3t91FPhz4x9Pq; Fri, 21 Oct
        2022 12:38:41 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.EB.20812.0D292536; Fri, 21 Oct 2022 21:38:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221021102632epcas5p29333840201aacbae42bc90f651ac85cd~gDquPbJiL0419604196epcas5p2N;
        Fri, 21 Oct 2022 10:26:32 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221021102632epsmtrp1176b401c1daa5743e3ec78b54f316e90~gDquOjlxB1811718117epsmtrp1s;
        Fri, 21 Oct 2022 10:26:32 +0000 (GMT)
X-AuditID: b6c32a49-b09f97000001514c-69-635292d0cb47
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.40.18644.7D372536; Fri, 21 Oct 2022 19:26:32 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021102630epsmtip12ef9d4f8d1736fbd32fafe9be83776a3~gDqsUHv3B2574025740epsmtip18;
        Fri, 21 Oct 2022 10:26:29 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH 4/7] can: mcan: enable peripheral clk to access mram
Date:   Fri, 21 Oct 2022 15:28:30 +0530
Message-Id: <20221021095833.62406-5-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221021095833.62406-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTU/fipKBkg497GC0ezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERl
        22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXa2kUJaY
        UwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74
        fv4sY8FT7oo1V14zNTD+4uxi5OSQEDCRuHBuBlMXIxeHkMBuRon/nS3sEM4nRolFk3eygFQJ
        CXxmlLi1FqiKA6zj2lEXiJpdjBKXpv1lgqhpZZKYNkMExGYT0JJ43LkArFdE4C6jxLXFmSC9
        zALVEgeO8IGEhQVcJM7vb2EGCbMIqErc6+YCCfMKWEs8fNbEAnGbvMTqDQeYQWxOARuJV/O3
        MIKslRDo5ZD4s/IWI0SRi8Srj9uYIGxhiVfHt7BD2FISL/vboOxkiR3/Olkh7AyJBRP3QPXa
        Sxy4MocF4jRNifW79CHCshJTT60DG8kswCfR+/sJ1HheiR3zYGwViRefJ7BCQkRKovecMETY
        Q6L79g9GSOj0M0ps+readQKj3CyEDQsYGVcxSqYWFOempxabFhjmpZbDIyw5P3cTIzhRannu
        YLz74IPeIUYmDsZDjBIczEoivBZ1QclCvCmJlVWpRfnxRaU5qcWHGE2BwTeRWUo0OR+YqvNK
        4g1NLA1MzMzMTCyNzQyVxHkXz9BKFhJITyxJzU5NLUgtgulj4uCUamDizTYM2+rml6/0aN3V
        n34TOvw2SvD7PeB6mXp6tyiz8pqzf+OCi4tWXtC3cT/EURFjpOu/Mv6b8rvcIour5i7XzSSW
        fz8XbVHe72rmGj6nXcj30aowtuZ78/bdLH8uoTfh4PPdKzbm37/p4x3Z9mmGc7F6edwGc2N/
        v8vVh69LTBGYqCz+qC94xs3FH958Zk/zKz8td6/88gwNduOiGSp3vPK2Tngld2x5jk/KVyOv
        dyZKv4pF9jAxKLG7a208uivTYz3rvvybKWdiT035yrSbt7OwS6WksGnSV73psYvs8/fE2UrN
        ulMbpLFnac2DkDVxqZPVeXkVr3bcsDwcwmy070Dq+7JMgWAtzQmLHZRYijMSDbWYi4oTAe8N
        MXgdBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWy7bCSnO6N4qBkg3OXGC0ezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERx
        2aSk5mSWpRbp2yVwZXw/f5ax4Cl3xZorr5kaGH9xdjFycEgImEhcO+rSxcjFISSwg1Hi6N1e
        xi5GTqC4lMSUMy9ZIGxhiZX/nrNDFDUzScyZ9pEZJMEmoCXxuHMBWJGIwEtGiZazbCA2s0C9
        xLszN9lBbGEBF4nz+1uYQZaxCKhK3OvmAgnzClhLPHzWBDVfXmL1hgNgIzkFbCRezd8CdoMQ
        UM2yRzfZJzDyLWBkWMUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERzQWlo7GPes+qB3
        iJGJg/EQowQHs5IIb8G7gGQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YW
        pBbBZJk4OKUamOpd8icJz/1837to/zbXAtdHxWvre+PmuWXe/J912XaBsZdsyjexmIUZNjtk
        3i4Len3kpvCk3OXnFNQ3XZjEUyda8Or0q2O7Vrhp7t39SVz0pCbf3uDyo4x2YlX3ej4eu2p6
        3cNVzlLq5/PPuSeVU0tjz7vum2mSGuYz3TZb8MK1CFGGX70Va3Z0T36iXzH/QYT/imWbNxro
        KTOdXMBh2qz0k+fKz+CMfSUHnnxf18GdlWBn8bVTTehBafZZ6StzNPf7aS9d9+ZeZ+kOg0dm
        2trPyq95Sxxyvuv9d7K+dkuTcMGTuwdWeUY5dXDMrxSf7j3ldxr7o4wOL3d5px7VtPlB8z9l
        KnN/NRS0v/lbVomlOCPRUIu5qDgRALuRRIXXAgAA
X-CMS-MailID: 20221021102632epcas5p29333840201aacbae42bc90f651ac85cd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102632epcas5p29333840201aacbae42bc90f651ac85cd
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102632epcas5p29333840201aacbae42bc90f651ac85cd@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we try to access the mcan message ram addresses, make sure hclk is
not gated by any other drivers or disabled. Enable the clock (hclk) before
accessing the mram and disable it after that.

This is required in case if by-default hclk is gated.

Signed-off-by: Ravi Patel <ravi.patel@samsung.com>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 drivers/net/can/m_can/m_can_platform.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index eee47bad0592..5aab025775f9 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -140,10 +140,17 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mcan_class);
 
-	ret = m_can_init_ram(mcan_class);
+	/* clock needs to be enabled to access mram block */
+	ret = clk_prepare_enable(mcan_class->hclk);
 	if (ret)
 		goto probe_fail;
 
+	ret = m_can_init_ram(mcan_class);
+	if (ret)
+		goto mram_fail;
+
+	clk_disable_unprepare(mcan_class->hclk);
+
 	pm_runtime_enable(mcan_class->dev);
 	ret = m_can_class_register(mcan_class);
 	if (ret)
@@ -153,6 +160,8 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 out_runtime_disable:
 	pm_runtime_disable(mcan_class->dev);
+mram_fail:
+	clk_disable_unprepare(mcan_class->hclk);
 probe_fail:
 	m_can_class_free_dev(mcan_class->net);
 	return ret;
-- 
2.17.1

