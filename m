Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B41048234C
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhLaKW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:22:57 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15996 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhLaKW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:22:57 -0500
Received: from kwepemi500010.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JQLjL6LSgzZdsS;
        Fri, 31 Dec 2021 18:19:34 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500010.china.huawei.com (7.221.188.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:22:55 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 31 Dec
 2021 18:22:55 +0800
Subject: Re: [PATCH net-next 00/10] net: hns3: refactor cmdq functions in
 PF/VF
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
References: <20211231101459.56083-1-huangguangbin2@huawei.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <cc2df715-3bdf-6f45-8f7e-6d42c244fb14@huawei.com>
Date:   Fri, 31 Dec 2021 18:22:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20211231101459.56083-1-huangguangbin2@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am sorry, this patch-set is incomplete, please ignore this series.

On 2021/12/31 18:14, Guangbin Huang wrote:
> Currently, hns3 PF and VF module have two sets of cmdq APIs to provide
> cmdq message interaction functions. Most of these APIs are the same. The
> only differences are the function variables and names with pf and vf
> suffixes. These two sets of cmdq APIs are redundent and add extra bug fix
> work.
> 
> This series refactor the cmdq APIs in hns3 PF and VF by implementing one
> set of common cmdq APIs for PF and VF reuse and deleting the old APIs.
> 
> Jie Wang (10):
>    net: hns3: create new set of unified hclge_comm_cmd_send APIs
>    net: hns3: refactor hclge_cmd_send with new hclge_comm_cmd_send API
>    net: hns3: refactor hclgevf_cmd_send with new hclge_comm_cmd_send API
>    net: hns3: create common cmdq resource allocate/free/query APIs
>    net: hns3: refactor PF cmdq resource APIs with new common APIs
>    net: hns3: refactor VF cmdq resource APIs with new common APIs
>    net: hns3: create common cmdq init and uninit APIs
>    net: hns3: refactor PF cmdq init and uninit APIs with new common APIs
>    net: hns3: refactor VF cmdq init and uninit APIs with new common APIs
>    net: hns3: delete the hclge_cmd.c and hclgevf_cmd.c
> 
>   drivers/net/ethernet/hisilicon/hns3/Makefile  |   9 +-
>   .../hns3/hns3_common/hclge_comm_cmd.c         | 626 ++++++++++++++++++
>   .../hns3/hns3_common/hclge_comm_cmd.h         | 172 +++++
>   .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 591 -----------------
>   .../hisilicon/hns3/hns3pf/hclge_cmd.h         | 153 +----
>   .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  10 +-
>   .../hisilicon/hns3/hns3pf/hclge_err.c         |  25 +-
>   .../hisilicon/hns3/hns3pf/hclge_main.c        | 170 ++---
>   .../hisilicon/hns3/hns3pf/hclge_main.h        |  23 +-
>   .../hisilicon/hns3/hns3pf/hclge_mbx.c         |  16 +-
>   .../hisilicon/hns3/hns3pf/hclge_mdio.c        |   4 +-
>   .../hisilicon/hns3/hns3pf/hclge_ptp.c         |   2 +-
>   .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       | 556 ----------------
>   .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       | 140 +---
>   .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 133 ++--
>   .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  30 +-
>   .../hisilicon/hns3/hns3vf/hclgevf_mbx.c       |  19 +-
>   17 files changed, 1046 insertions(+), 1633 deletions(-)
>   create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
>   delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
>   delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
> 
