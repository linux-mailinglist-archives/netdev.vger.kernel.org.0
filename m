Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B826E7E20
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbjDSPV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjDSPV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:21:56 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20708.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::708])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0DC93E5
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:21:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgJQ1yv4Xed6Ea6Yi1hst6kQgqCW0A3lNt9XpDxi2XBIo/9X2ewMvSkzVt/j2CH9vSA2mpllml2LTTdj6QlOedtjPPBxUf+vFEGUfwbUZ98lah9xg7HiG+0aNuCfdZxGW43VFaTLjm5KNNHPUVFVrAFdttFYKLRF05utNDOIJyVE5qtQsb4PpUwnX0us9bjtxFvt8mjEDxcR2MWkXymCi6CZvFcdUOvcO7JdU2djXs0JlUK07moIBbKLghBIb4BcZRG0BiSOJ2dg/uKSb0qdxZGhoGg6uGVkXYhKffuxJPj3UkUc/t5YbDMfpEqodiPjMR5Rssm2nba5Ypv5i1IZrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oYWSrjvUfQhtMij28RhZRyGvfy1Ogil+zDFPLr+dcTU=;
 b=fpk78x6VdbZNh90AlRnucHeogeCn72j6/6U9BMCJp3Qp7Ac4c6kf+E6RqYpCdzMAnr62Z8FRdR2uuLvvBC6f7747QBDeambnK2FR4kVzsVyhVdSWcwm1YghAY3dN2BXBU1ShkId7B58wHeD2orM4bVbmT5c/ObB6HRHo/KPnJ7Z/BcF4SAA6opaT0ru8/TFMGsTaTNCPcmVKfRkH/04syS9A5ssBtSamTymSTGA843Ko2Zy04zeqGlenWl02wF9y1DGtt3lmbG0fpA4rexaapJPnNbbBrxlU2DTcAMT2M5tCGr/Xozu2ap1CaEYGh/CSQABc7XBFZ17ydzhs4yjx2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYWSrjvUfQhtMij28RhZRyGvfy1Ogil+zDFPLr+dcTU=;
 b=Iu7sU78OiO5CKzYktX+5qrPDXHFr9Z/cI2gCY3vfSSOKTntWfO5ZJ6XzyYmArSblEIXVLWRa6bVHGJ03S9siCr1ieOO9LTy3tG2wpa8D1TdSSWbS1WTfCpIbUJ32giki7Pok4xAhSTAYyhoxouv7sj7EjOJPjOJUHVldy0iibAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4760.namprd13.prod.outlook.com (2603:10b6:408:12d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 15:20:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 15:20:01 +0000
Date:   Wed, 19 Apr 2023 17:19:55 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com,
        mengyuanlou@net-swift.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yang.lee@linux.alibaba.com, error27@gmail.com
Subject: Re: [PATCH net-next] net: libwx: fix memory leak in
 wx_setup_rx_resources
Message-ID: <ZEAGm73nAuB8aHnN@corigine.com>
References: <20230418065450.2268522-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418065450.2268522-1-shaozhengchao@huawei.com>
X-ClientProxiedBy: AS4P192CA0023.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4760:EE_
X-MS-Office365-Filtering-Correlation-Id: cfa05c36-26a9-4ea9-034a-08db40e98b6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: clXUsT6oW6hXUAfWaKrDob1E8/QfjGT4J56FPWFVjqez1Udx1hIECHL11d785uk6Tqz7Z+6hpd5m9rPOpLVU9I2xd9ryDvVD4l+NxQUd3pxWKT3dAbclsr2iybUyUmbgDS96Y13zxl5mQmandBvmQIQjghSuFIaH8ty9FFwAhu1uJ+0KsbVpLMpWx5qclMFxmEaKOmqiafAEFEI0fYDyAHTZZ3EQEpGpv/8xQuhIG99yVW0bxy6nq3+1uhOkXzSLWNe+bRqthxLqIPeWa1ctcIAeTEKKjp6f0mEdbxmgnJTt8JwqDs8Yj+JZsG58jlFH/ADP8x7nOOG+PbzzByMqDGsdAzUxSKbv3GsjEDwAuFYp7J9D/JhcESbIHecsDh0VdsjQvQ9ZHXfDJkEc+vIGGTqVGPgebcam0YUYsTnhrAjJ41NxCdAStlSXMqqb5UC83JnBWPK4lxEYN3O2LN69hXfAYQVUXpzh91v+7dCcSzmMA0cFJ28omlDDcTlEZSAMVbFEnNvTQIq39yBj0VLsuXoAY5wCX1ILWY7Nwp6uFAqCUE9RK08UaDa0U8BMLA7M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39840400004)(366004)(451199021)(2906002)(4744005)(8936002)(38100700002)(8676002)(7416002)(44832011)(5660300002)(36756003)(86362001)(6486002)(6666004)(6512007)(6506007)(478600001)(2616005)(186003)(316002)(4326008)(6916009)(66556008)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YHzZm7DaX9TnlIS3pKCNODwQ0MFikOng9iLokZgYYnBxurVWLCfqtE9TDJzL?=
 =?us-ascii?Q?caJ+HqPt+END0zNsAjQVVIh5N0pk/Rw+P1Ox7WfAaRoC0aFYuQ9H9O7mRqWz?=
 =?us-ascii?Q?4Y/wdsaHid5wqewlD4uFcEvaIwc9z5stH+XsiNDpKTnNM0Y+CRogCvpNFR1d?=
 =?us-ascii?Q?kH8/yZ6VGPhxwbQ42vMD671tX5InhuFZzDQDeecXtHHXfBd46lOnEN+UytVW?=
 =?us-ascii?Q?+fUKtDAS9eE1Rm/mypOWGUfwy3y68gVYqF1a4iKPOzvM0yb1VmzDwbMdYXCm?=
 =?us-ascii?Q?eJh69zuD4vdr6V65NgRK/CY1MmiNuj3JESKYW/8d9eS3RkPZRXg9cS5OA74V?=
 =?us-ascii?Q?fOPL2EZDPxB4VqDk4uYve0c7dXu6rwJwNAWNL19EO52jtLQh3o9/U3p4XU5+?=
 =?us-ascii?Q?ohrv3G2k7rqdk2n3wOQxkd3jc2j3YwOuhqDb1mBEZTq3guqyxIw2EGUIN0HI?=
 =?us-ascii?Q?eKa8qG0MgGAQKpt6BkUIdokQy585J0I+fJJ7nKUzqeWftX45xReUyNDvfL17?=
 =?us-ascii?Q?HmJljScgXTFH0Mfex65ZTNCNqXn7nq04dBdGJzdm7tq3LgMCmigkkW5bYE2D?=
 =?us-ascii?Q?yDUej3shcnvGTkWM4gU2p9t8Eb3+hnUAUvksd0sVddBN1ovW8IG8l8VEsxaB?=
 =?us-ascii?Q?nyQDWYziUu3ivC3Twma3H1XpRQAa0GP5Wl210IlzOo41c5Rms7/3Svg8poNc?=
 =?us-ascii?Q?608pOy4Y/9fYayIopOK6aECKZVfJsyWozonkMqMTNYii4+norQRFLEKtVgwq?=
 =?us-ascii?Q?SAZdJgGQyF1l96+ph8QILN1MS8TkBSz6nk/8Yqabep6Xm7Iq2uI8Ovz1bsry?=
 =?us-ascii?Q?u9ebY6gGVrwkccT68ata3I873EwVz6JWF/8X92D8UZDaAaJe9jdsOF7t7SIL?=
 =?us-ascii?Q?oVXZU6j1HyNcSnqDNkGoiCWJDV7QGhGBCHBWcv8RbkhsKj4AQtqOycsgZxUC?=
 =?us-ascii?Q?ABZT2vaWeazr23WolHfO69ZBAoqPwrHMEqJprla8RL2FuzPchZN6xxg5iQ3u?=
 =?us-ascii?Q?fccubWbzpHJ3jj+Sk7vfIz8SQzriQjxWSQ9LZDeQdoZuyYtOIrfY0NbZRu36?=
 =?us-ascii?Q?gpUvZb3KIqtczXlmmFP0z7EkpUFVqML0C9R5hu7e7lCSWMc87qR1c5aw5VFN?=
 =?us-ascii?Q?/pCxNQOiKf603EPMKyQ37Q/QeTxJXTah2LHWMy3+bpnJmBng6mHRsxJ8h0+K?=
 =?us-ascii?Q?hOsr8+ACKKycoiFQb664OtdMyojkYdYacoQOnBLEQoFgvVq1GgSq1S8xIjHj?=
 =?us-ascii?Q?QMBb//xJvQS1VRQKjj/5uIEX+OwRape7Ru7sXSxBnTT0qNzt28a3mKRfRqSi?=
 =?us-ascii?Q?7GPL61FzBDop2AVDZK+T7SA8KCrPMVuD84tdOeuHpyIJPXc+PEMQpzdw+nWk?=
 =?us-ascii?Q?U7tKQ0bpGHTYXPBbzOEs3yww4ktpRhuxObkvromHlNNRTej5U4mdRqZSRuSO?=
 =?us-ascii?Q?ZaI9dAUGrQGC+z1UHhIwKnZq6dlEoXBWR75p3PV1ubxIMr+V69rPsEV2pvuj?=
 =?us-ascii?Q?ItbE5cXannEQW/yJ9NlwxlQJ6HKfRXEcJnFvwKYwqeJNy/OonkdufwfJqtlh?=
 =?us-ascii?Q?x1sHhKSlW4I7oshMaqWgpYgAkO8ECdSDtaHNalyGzrjmV2Bb2ZGeY8vvIAFN?=
 =?us-ascii?Q?jd8W+kW92ypobswVEndsOo9tvf/jSvER8PK0Z7O0//535dV6ZnTdErv0ieeD?=
 =?us-ascii?Q?VObFJg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa05c36-26a9-4ea9-034a-08db40e98b6d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:20:01.6565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIs3kg0ahUISIMXKoYeqD9LgGJrMWl7W4G8Kz+YJSXBUpPqeoW3ftjVfNkemI4CmfgmR1ZaWKZXBDQnMDHHIFSLtYgSN52zlhZMeZ2ue6sk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4760
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 02:54:50PM +0800, Zhengchao Shao wrote:
> When wx_alloc_page_pool() failed in wx_setup_rx_resources(), it doesn't
> release DMA buffer. Add dma_free_coherent() in the error path to release
> the DMA buffer.
> 
> Fixes: 850b971110b2 ("net: libwx: Allocate Rx and Tx resources")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

