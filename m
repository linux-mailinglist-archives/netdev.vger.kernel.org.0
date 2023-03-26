Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4856C94E6
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjCZOAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjCZOAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:00:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2095.outbound.protection.outlook.com [40.107.220.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727D17A9A
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 06:59:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8mxIiNMWLyegGLSH7vxWUxUWGbcAGFrZwE0oLORMLsAMSpPGY0lOhVRJjbk/tg2LKr6Gtri29l4de7ANGITEpgEkvOczxLvN2BZLCoCHRjXykv3BdSKiqM6ZwOCp8pI3+uW+7kK72vrf1Q2DpUZ1+WHdgJKIovLmPjKZBQjfDI9qUSoFAPjEQfCouaZvpdQU7O/wpSglVjOL2xASMelyHce1X78yxTPNLq4bmyVtOtLodBlheoBWJ0pdW1LPcdVvk0hmQTSGpT70+su3LBUy6yVYJ7cogCHldloreJNZwZ6Rwp3dUN58FaYh0GgXzOBtf6sJCJNH7kR99YKnl76eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7N8Eak+YZe8Bh6ZWUqjYvB4u9QQ5Qu7K9UBKwg3874=;
 b=l2ZWPoUIgc/zXNfw9idiNXVvYVjAXTjVBhIX3giZ2fRyRvLbGxuyNOhz2EBBvNP4tUOjZgx9epL5CW2SWk/XfgwfDAJdTBMLnnTG+98riKJ9JRV6ZaHSo2G0VyMCmkINT4Hnba2shhFwJa3RK5JhxNiF9cSedagBldVZodniFV80gua3rEEOFzMo+HVcSLPPYOIFnEnHmv5X5eNwX9pWbOkTJ3JORXnPfLOUptR0TbDqnx/LUEEeOL2DmXTSzOMnwDzh9y0TZNaVLQAqYry0pddRiMH8C7q28a7dnRtD4aha75Rmn1kE/v5/p4uy6uqXo4LMGWFs8a1OFpef4G8e1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7N8Eak+YZe8Bh6ZWUqjYvB4u9QQ5Qu7K9UBKwg3874=;
 b=MdBX5CrN7RN2WbBZvQMcK8iU+5E1O4J0UsJiYBJdcUu1V4JfGK+zEijyulDaQ1M/j13dtb8aw2vrcMWDa2CsSdO2aT9rX8zGeN6tePrVwXF+WvKVOOlgu9HMprE6FZZ6FNgXMXvWsHueIqOQLwqXPJMz/ow3I0tmtgzMpEArczA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5939.namprd13.prod.outlook.com (2603:10b6:303:1b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 13:59:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 13:59:51 +0000
Date:   Sun, 26 Mar 2023 15:59:45 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 1/6] mlxsw: reg: Move 'mpsc' definition in
 'mlxsw_reg_infos'
Message-ID: <ZCBP0WA06Z84xMCt@corigine.com>
References: <cover.1679502371.git.petrm@nvidia.com>
 <9ece6a3ddfc4f092fc07e912ace0efe9f882334f.1679502371.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ece6a3ddfc4f092fc07e912ace0efe9f882334f.1679502371.git.petrm@nvidia.com>
X-ClientProxiedBy: AS4P191CA0029.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5939:EE_
X-MS-Office365-Filtering-Correlation-Id: 79ad8587-0b21-40ca-d889-08db2e025e8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xjGAkoEVCb5mXUWSSJTDwT+UFpzQPn54yFHILAdF0EcBmXNOCLBhi9z2hyNwc2Gr4x7qRglM52/XN1g+JPafMZik8rDHYkw3hY1vCIUr4WL8628PjrJ9uTzHGkyM2/mW9plyNJFlc2rDO1S1hSkPzUS7DuhpyrKMFDidkJ/DHlkfXIEHCBEhhFlFc7neFRHBQ4DxT+Z9xnjmiuLYjh58QAfIOXaqO+AA5WplauvJLT5q6BLqKACfaQD5vymtHPUWY89JwBDqynvXuexFSz0yOdDK10ZckqRqBTAeGH63VOtCxztLt8C1EDzzcXL2NZmSmUoBHwltz92OgiKsvLuTDpIW36z8HqkFxtQBPtwqtAaykXjm94nM6CD6b1PpXsxcj5Pg2n8T+DbO88ghnPM8veUFR1YHeUfTF7qOO4rXYMak0SudEZqxGII74U9zMKAsXLhUeKa0qfOq0ITGpVTWk8sxmcOCCeFCYECr/3KFr6WAevdBBsDDHXftlyE5oaKmyNIqZv5Nydj6PL5BbmMeDO3iFQ9EMZsFjCpw7ghMuNj6rXrrB7Lr2lGPXzlc0kLcJt5lYmCYXvEUntDaMShB4h0NX38eI7Ct18lyzBK/8RY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(39840400004)(376002)(136003)(451199021)(66946007)(66556008)(66476007)(8676002)(4326008)(6916009)(54906003)(316002)(5660300002)(8936002)(4744005)(38100700002)(41300700001)(186003)(6512007)(6506007)(2616005)(6486002)(478600001)(6666004)(83380400001)(86362001)(44832011)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GfgJ5j236ETFhle5uMsfX/BrD0n2S3SU8rAVj/q4/hryHjiU7svO1qwYgMlL?=
 =?us-ascii?Q?LAgZ3xo8LD/+1XUflHOJtQLriUdMNdKN4rRDshkIt9PkZs4iBfCa8sin/pTv?=
 =?us-ascii?Q?jIaxvChAsd75Kl3Jm4RGGnioq6ojVTWeKCPkmWzNHxgNo3GQT6CRUHK6qbAH?=
 =?us-ascii?Q?HteGbA4NcHcOlYPu1a4BYV+OQ3iiZXBfw+wVBmysoRwVqt7+F0Lx0wC+BiIb?=
 =?us-ascii?Q?uPwRaGhpXADmefqeZzOfeSAgBaL2En6Y4y9y1mBQPD41LCRUAyRv89WCLos9?=
 =?us-ascii?Q?aX0xL4eFutqRFcsvsHYB+JvGUuOxoDR4yzHCzvpp1t9BkJhuZeyXR6F7sfQF?=
 =?us-ascii?Q?Lb+OjEMxh+2kEinWA+KFLibUU7E7RRrun+qyAFUK8yWozloNGAyrz8W6OOfr?=
 =?us-ascii?Q?0tnm6PfvNAzVoKHoQ/FvkN0llrgqnZEho8Gva2NTyLgRkVpuaOFhLc6Zhm9x?=
 =?us-ascii?Q?Z37C5vRmnkSIjYkJpPR+41FtHZe/TDOk8fAxRK5N+RGnpGv1ki96p0QwWXJl?=
 =?us-ascii?Q?u3l1rOx930w4J77Ysb1DQYchzn3/RyRL0WWJVQs/Uh2XJlxYFGMrWkoiQjh0?=
 =?us-ascii?Q?KqzIQVqPkNIVzn3B4pe722BtDIAg+sh/Hy38kMa8xdAiikZh2hpRAt3z1L7I?=
 =?us-ascii?Q?5jK0TAH9K8XzYdorOTed+9wfzXcz1CJh6x2kKwXOZIPLt3UYeZDbRlQpFVVY?=
 =?us-ascii?Q?CyrWS9AIRZN/nLbTjrpTb6/OehNEvIKX81LcuIOFHWXMErqEZ3c4j8znAa2h?=
 =?us-ascii?Q?zK1YVFkVIHfr+NIHabokBpquN6oMFxzAfEr2pUnDELGEreulDmfVF/etgksx?=
 =?us-ascii?Q?NryOEDuoxUjmS10y8Km/GzccyQlHfChomoz3axk2evzbcIaVrmyVNkztx2Vv?=
 =?us-ascii?Q?eMnyYgxXZw2wiZV+6bA05vgXzDRdMYX92I5m0OY06mKGrgihLOW6qOZ49nGM?=
 =?us-ascii?Q?UuYRRpvZuUsbzfwrONK2bhP3ABaqf7k+xWSIiBN3Uz1w1Ah/Ay2t5p9ID+la?=
 =?us-ascii?Q?u2QBLS8P2z8Xvl7UtVwCig/MfjzszQSA6Hw1+REMsr7srJWgk1Bn5QYOXRzb?=
 =?us-ascii?Q?/T25mcTgQ+4ajS9mXCUiX/2dmCbZT8uvK14fbSvBbgcrr8fBJf9WXyVsN5LN?=
 =?us-ascii?Q?zn3dzcJxn9yBFQRdJRLq1fUpVT12eHBa2tPLNucCilvarBO7UFrhBNIhiQ1r?=
 =?us-ascii?Q?c5Wkpno9X1fmzn7UxR8LXsCaPsFkB9Cp2kwQVVruYDIr/pEUm8D3dln9+MLz?=
 =?us-ascii?Q?9c2oWj+TMH7DydsXw0PxUnyYVTtx6rOw78qKmmSXBvnVKRpI1MPsfvQq5Ign?=
 =?us-ascii?Q?3VGMDqVich2Sx4k1w1ADq6dWN+HFTlwEDIv6bYPdaAAIjNb35POmTS+NoUp5?=
 =?us-ascii?Q?qWmhbFrGXQIvDK8O/lf1EGpYmJ8E1rLDt3Y0rTWPYwVTRXWa7qa5/MaFzoPj?=
 =?us-ascii?Q?LhT9U/K2bf0QDMa6p8h829l9DN/lajGkF5c0K/P9TJFQZzYS5x7TLjjzWhei?=
 =?us-ascii?Q?21w5g6nXadMIJVdUaut1J5HVWpqVaQQipFV52CSRNvZk1MptVh63U60oN0Bt?=
 =?us-ascii?Q?MUQr6BFYTlbKm5ymkYtD0yUmW1O7O558S8gAZ5Rps0NTSBpnVQipO9I7z67P?=
 =?us-ascii?Q?939//tPPSmA6xuoj62mkMi0+bT2SHaIANMXhO0miI1wa+Jx33uPD56ZT9jfX?=
 =?us-ascii?Q?q0T98A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ad8587-0b21-40ca-d889-08db2e025e8b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:59:51.6442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MYUMfSxIduxO/dcBx2iFJZ8ajQ8mhRkX5dh8btv/qjPEwp9eHctC/ScaV0O4iTTrycKd7mr7d0x32bK5AtImzHrbGQla1B5XlnB5VevKJXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5939
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 05:49:30PM +0100, Petr Machata wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> The array 'mlxsw_reg_infos' is ordered by registers' IDs. The ID of MPSC
> register is 0x9080, so it should be after MCDA (register ID 0x9063) and
> not after MTUTC (register ID 0x9055). Note that the register's fields are
> defined in the correct place in the file, only the definition in
> 'mlxsw_reg_infos' is wrong. This issue was found while adding new
> register which supposed to be before mpsc.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

