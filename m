Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18682262AA
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgGTO7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:59:35 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:64865
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726506AbgGTO7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 10:59:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aK2vBpooYO4HfnfPzAEU4H2AZGcsbuMRtE3szQswF8y1WJ29EdOYHGr2I9xyIxthvDuXsHQGmIDfeuFM06Twqug7wsF1tmJbFhLeyPVewMxHwW3hOLmk9f9FGIb/zHjcwRvF3PSlqZy5V47zXl2/M9t4EZwvMJg3qcMw4L64ZPYuZDm9MTL6HIgAv3Nt2LRaSngV1iiUdc9P4/CxoXBEealFDEMxSjt4R5SqGBKL2zB2tgJWYsXLTJpd5TqZ1ZtGaKWve2BYE7/0XWTxdVe427ZHQRvLX8qMBw3tILX4rUp+MqNotbxH/x4HrVcPCGRhVYmNoJupxvbD214cc4pkww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un4/oF7JuowtHPlr6QWhNeJuZfP7xpPFpz+ZumY4PeQ=;
 b=XIjU+UPMfjTKlxQLroiWhcfj1++WkwiiJDsCNohFYLmbM2GRcJXpoI9uS0EtHJL3Y9F3uVM/BAqLY0LWYldfC2M1s055ZJwGw0NK4l7z4pBX/sei/W7xoud6MHJ6ggTb56xeXCKrRbAJdPt2Gk6MXBsG3eyX+WrIy58rRcP/6fqlbK7dVMOlbEx0vh1S1buOjxYJjPDGZefY0zGiGSlpjJcfZksjnJcpnFLrPjnU1oML6tpDwWsnqc9t99uepDKC4TpKfj8sAHe29mPz+PpVJc2Ueg17aDtyj98HqXFLkXpaTInwWUWJ+r9TEpSBFfvBl5ikK/dTrSdVlDRq+0BOYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un4/oF7JuowtHPlr6QWhNeJuZfP7xpPFpz+ZumY4PeQ=;
 b=jcV6t8lTiRU4AUxrd/iKsOfBWlBBr+ZtfmckvkxMKtbqQDXm2ZRHzo31djfEEY3eSGwErJrXzhSJLS1CdadKAI3HBJIcco/pPjAdNFUIV0UGfQfvhQUqdvzhLPZqGmK6gkVb9zmksfiyt9+o/52N9QYDfV7iv9yMAKTvoIjiqww=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com (2603:10a6:20b:15a::7)
 by AM0PR05MB6436.eurprd05.prod.outlook.com (2603:10a6:208:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Mon, 20 Jul
 2020 14:59:30 +0000
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::4985:1285:c162:725c]) by AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::4985:1285:c162:725c%5]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 14:59:30 +0000
Date:   Mon, 20 Jul 2020 17:59:28 +0300
From:   Ido Schimmel <idosch@mellanox.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     jiri@mellanox.co, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] mlxsw: destroy workqueue when trap_register in
 mlxsw_emad_init
Message-ID: <20200720145928.GA522956@shredder>
References: <20200720143150.40362-1-liujian56@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720143150.40362-1-liujian56@huawei.com>
X-ClientProxiedBy: AM4PR0902CA0024.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::34) To AM0PR05MB6754.eurprd05.prod.outlook.com
 (2603:10a6:20b:15a::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (193.47.165.251) by AM4PR0902CA0024.eurprd09.prod.outlook.com (2603:10a6:200:9b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Mon, 20 Jul 2020 14:59:30 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b39af21b-cec8-4db5-8868-08d82cbd8191
X-MS-TrafficTypeDiagnostic: AM0PR05MB6436:
X-Microsoft-Antispam-PRVS: <AM0PR05MB64363789D2CCAC6582060D9EBF7B0@AM0PR05MB6436.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QmwWLAoWK8r6ud3eCJStf799lnycj38sr4SFdoWsa9w94+TVJ4UnlxTAWeVIVlx9j6DP8vmZ7XNATlyvjeZaNshIl3J0BVNvHVSunJB/s2gZyYQq8g2rQpFDsdXPoxv1Cm4e2NbCw+4ws3L1GTnZmXfY2jxTb3lspePgT2tYR7gzkYoLxpN6qEFEUo1pW4aGDeTV8l8QVFA7CNI/9hs+JZanYDJ4NHpjpMPH4TExEKs5GBJM9JTfk9g+rsVrs7r9yToTW6WI57khs+DdmZz6FOiiofLFlbh7CdQ3Zu1aQMLQEtGBv8DLvBEuy6FXGMDDxfkZQfH7k0P9LUu1j4B3iA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB6754.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(366004)(376002)(136003)(346002)(4326008)(6916009)(1076003)(478600001)(86362001)(956004)(316002)(8936002)(33656002)(9686003)(66556008)(66476007)(186003)(2906002)(52116002)(8676002)(26005)(4744005)(66946007)(83380400001)(6496006)(33716001)(6486002)(5660300002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XWOibQ/pOXHmJ8oz51c7LGr0FQ8We2GqHaCpo9L8Mc4fbF226hNXQiWGRBFzf7xnq3iYZgl0lS8To4eAuNPd5mV+eIX2tfrk55FDDP3VZLOgABVA9tIKV6lzoRjCovRw3py0HWzvsuep/sN7rEN4aTGD64gp5isqFi0cKK3wqikukRKI4BJuRhbNeGI89lNr1QVGSwnTliqgGHtsXnwc9BLoWVzVZp51TqbkL2ul08VcBYNGibYZBlqMxSIrFFPLCu7oMrKmjcFBtQZRUZqi0K/c1UDNB84touy5jO/dYMkZyxB3StM/N49TXXaKUQZDTmqBwLxm9BHQVA8btJNVyBftNqVaN37K+5Yv2fL3BIhzuX72cRj9A7fX9ft3uZhROiFzQUHXctIz81mK3dnZkTjHcUnviuLCn3ttZjQdJ+9WkQifoQhqnDHjS6B/A6W7z4B9MOlDaLsq8DaMf4tVRBRMwpuMsr0Ydz8vifn93ph/z96rWB+Tf2R1kkh4Q9t6
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b39af21b-cec8-4db5-8868-08d82cbd8191
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB6754.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2020 14:59:30.9076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tBer08vmvIcu5/Rkk9veAjzasy8uCLKvnmdHjRGwkf32nb3xoYZIwQUQ6T64/J1+ginqKKy3u+Pm0g6PksSp9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6436
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 10:31:49PM +0800, Liu Jian wrote:
> When mlxsw_core_trap_register fails in mlxsw_emad_init,
> destroy_workqueue() shouled be called to destroy mlxsw_core->emad_wq.
> 
> Fixes: d965465b60ba ("mlxsw: core: Fix possible deadlock")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>

Thanks!
