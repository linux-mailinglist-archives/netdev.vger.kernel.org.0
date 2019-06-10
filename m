Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58723B923
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404114AbfFJQN7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 10 Jun 2019 12:13:59 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:46634 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388850AbfFJQN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 12:13:59 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id C580A6E4445C28E02EAA;
        Tue, 11 Jun 2019 00:13:53 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Jun 2019 00:13:53 +0800
Received: from lhreml702-chm.china.huawei.com (10.201.108.51) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 11 Jun 2019 00:13:51 +0800
Received: from lhreml702-chm.china.huawei.com ([10.201.68.197]) by
 lhreml702-chm.china.huawei.com ([10.201.68.197]) with mapi id 15.01.1713.004;
 Mon, 10 Jun 2019 17:13:48 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     xuechaojing <xuechaojing@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Luoshaokai (luoshaokai)" <luoshaokai@huawei.com>,
        "Wangxiaoyun (Cloud, Network Chip Application Development Dept)" 
        <cloud.wangxiaoyun@huawei.com>,
        xuechaojing <xuechaojing@huawei.com>,
        chiqijun <chiqijun@huawei.com>, "wulike (A)" <wulike1@huawei.com>
Subject: RE: [PATCH net-next 1/2] hinic: add rss support
Thread-Topic: [PATCH net-next 1/2] hinic: add rss support
Thread-Index: AQHVH39GZfVwWAWVqkmdo9ZxQyX0SKaVDyNg
Date:   Mon, 10 Jun 2019 16:13:48 +0000
Message-ID: <b2ddfca5c5c643368f05820b0d077bd2@huawei.com>
References: <20190610033455.9405-1-xuechaojing@huawei.com>
In-Reply-To: <20190610033455.9405-1-xuechaojing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.226.43]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Xue Chaojing
> Sent: Monday, June 10, 2019 4:35 AM
> To: davem@davemloft.net
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; Luoshaokai
> (luoshaokai) <luoshaokai@huawei.com>; Wangxiaoyun (Cloud, Network Chip
> Application Development Dept) <cloud.wangxiaoyun@huawei.com>;
> xuechaojing <xuechaojing@huawei.com>; chiqijun <chiqijun@huawei.com>;
> wulike (A) <wulike1@huawei.com>
> Subject: [PATCH net-next 1/2] hinic: add rss support
> 
> This patch adds rss support for the HINIC driver.
> 
> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
> ---

[...]

> +
> +int hinic_set_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
> +		       struct hinic_rss_type rss_type)
> +{
> +	struct hinic_hwdev *hwdev = nic_dev->hwdev;
> +	struct hinic_func_to_io *func_to_io = &hwdev->func_to_io;
> +	struct hinic_hwif *hwif = hwdev->hwif;
> +	struct hinic_rss_context_tbl *ctx_tbl;
> +	struct pci_dev *pdev = hwif->pdev;
> +	struct hinic_cmdq_buf cmd_buf;
> +	u64 out_param;
> +	u32 ctx = 0;
> +	int err;


reverse Christmas tree order in defining local variables everywhere?

