Return-Path: <netdev+bounces-2183-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E92700B1A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:11:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC1F2281BD4
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1FF2413F;
	Fri, 12 May 2023 15:11:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76022412F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 15:11:31 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2123.outbound.protection.outlook.com [40.107.244.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BB14C1C
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:11:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWZNFYOMVHhcToN/Mc4m4dVC/2GZWmm/ZqpQw3S9oLLqSQeJ0/AqI4B7An6UekTaFjBfIw+ZCDjxnWgR8uP8uwJol+lO2O3bebdeMkya71mCQM3bBJ7cFjQ6U9X1PnnbGPAvhsw/KfuCldgnhGISgqndJ/48gLaqo3ixgnAG1sFP+NIsISqe3Wm1jjZbywtP7sqLBhu6nYbQu59/wA2eIzcPmmdKtckE+lyIBVk9PHkvwQiq0BKsEWp8D/M4DdDNlO2UzhQSiOSdkSjej/1KWkKGzqIP/B45XPzl3T/8SCjnXs1bPrOfUmR9Q2IfrAEibtNXoQGRAu7e9l5jaRuP9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wj46vWMGOVaAnuvODJL7DKJhdyz0I0QI8AvwYn7KtN8=;
 b=XU0Oow6DabwmoBEgsg6lDZG+xth43HrVNQUIqO+xbIL2T2Ek14kuEiaJwry5RPLVMIM8K8YeTySKeq6IOqExqbXCkU5vI1YRZlcVqQS1/BcvURMijxbdgLq4flVKdXKhBDkK9ujHOAo8sTKGGBpOqtoQMUx0BZN2CUk2zhVhIp1s/DF/QDMXc3DbrNNdDLHVU6YFERWU1QX+PxGyWLsLhz5j/4+LJosMe3fRz/2/OuSKhB/3zI6p8EzUpIaBugzIStWt3V2A3S55RhxCO3253+ZgQs70/gQwZp3R88on4/YmWq+vLy25lYLMoB7lt7Zjw2Dh6ZH/doggnr4CL20i8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wj46vWMGOVaAnuvODJL7DKJhdyz0I0QI8AvwYn7KtN8=;
 b=F60+gA5rTezCvJsrhi2bLcXupUsWjWZ7U8YbKUzzsIAsqm74q//0LqKgSKT02znI2xBDCzs4NNstT/TzvUmysHfCAyvHmImDbtuQveGo41t/8e2JHwOqfy4v4QFAawZQkqG+od42Xsf81Jan+RJPOGwAejIcqZj1SQ6HXx7Ohl0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5455.namprd13.prod.outlook.com (2603:10b6:510:139::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 15:11:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 15:11:26 +0000
Date: Fri, 12 May 2023 17:11:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: daire.mcnamara@microchip.com
Cc: nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	conor.dooley@microchip.com
Subject: Re: [PATCH v4 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Message-ID: <ZF5XFhm6urnFEqLH@corigine.com>
References: <20230512122032.2902335-1-daire.mcnamara@microchip.com>
 <20230512122032.2902335-2-daire.mcnamara@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512122032.2902335-2-daire.mcnamara@microchip.com>
X-ClientProxiedBy: AM0PR06CA0086.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5455:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ca00717-a6e3-4e70-3c6d-08db52fb27d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FEPwJiYFwbiEz5V1B+QJlxHcP+WHRKyjPOXXGZZ/M4MA0YBPuqLavZJo8YB50vJb5QmB+xDQYOr2UMpeElTvaqOxNlmNN3x+/YhTCadNgJF9TEyNT2sv4xAbCZZeYQuRtHBJa1MZAPIXbNPdbdopUWc2HzMdCBL0Ky8havwWPUQjSBMBNc8tHwyziCKt2pt1sDEcme3OeXKFJTyhcFoSuGM6GX7RK+GljddiDutZubmmbRXt93LuZ4qD2oFBZvPT2eHioRi+OkQWK4qiLP3jf8M7owKfBaDcbB0qptZOYHDGUw58XJ58ObBy4S0xRb2YbLhSQwShtk6FskDGQnuqH2CXxspKxNa4pvkFEzjfeKwp82d/zqbjR2mW3k5PRh7j+SGUCP4OelpXIs+EDCDX9t+kt7gQVfY6DUrSBxLjnEWKZQ9UJRXACHQoxK76A9i2t2vSvFnmofkKA8/dspiIzx7AqxVgUoAdHxKFUdIXovw3msBbc2UXN7GaksipZ6t/Fo2CroH5Uu+t63tmTNX7KzAgPraGNw4VJAYs6QEhtDQZQdxYfpUppiTmsijNM8sh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(366004)(376002)(396003)(136003)(451199021)(5660300002)(44832011)(478600001)(66476007)(6486002)(8676002)(41300700001)(8936002)(6666004)(316002)(66556008)(6512007)(6506007)(4326008)(66946007)(6916009)(4744005)(2906002)(2616005)(186003)(86362001)(36756003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Crdkm1LCBqvPfhDFvTiSdhps+LtH5UC8HreD9kWtttPDImZwJcYCKQD/p5bi?=
 =?us-ascii?Q?x99O4ToEKVqfkaQRmnpDALRakiLbDN03IOXgYzKv10zq0HvnfU7jZU1vnXYv?=
 =?us-ascii?Q?AhevZP1j5GSCeIRKHOhLa+jGZIejDSvANHX2RdjWGXPQWASC3cRX3Ww7zJ/P?=
 =?us-ascii?Q?UJJeXYU6OZVkMcErGyxe0jz3qJvPRDJkC0sAIKwXjU+2Kr/4+komux/w3ehV?=
 =?us-ascii?Q?bPB8zf3owXzs8yUmU1ogJLQrlrVjwMwZCvsFqeF/rT4V6aNoZ0qk/zZpICX4?=
 =?us-ascii?Q?iIAw0LmK3WVbhRG+UkJ37QqQpArq+6T037GPDEu6IdH7WhtRl0V8rjMvh8NZ?=
 =?us-ascii?Q?3EIbmwlWUeQWxZ50qSAhuUbtvgaNNRo7OORL474ANWtNecC/rnXAxqHaPnWz?=
 =?us-ascii?Q?7fKo1vribyb8z6VEjnLxTrnbfj9ql1ao5p4gdlQ+eD77EzS5HN5A5ATzErTl?=
 =?us-ascii?Q?XTKWV5fgm9ToJls1uE9YexZRdbPZS0jzhNE/l1qXLYbvV5NhRSqLRL8zje2K?=
 =?us-ascii?Q?JibmlDzEXtIwy9m7ZvsXctjxC9A/mfXA0Mj0z6iVspXAmAWC5HpTqQ1BzP50?=
 =?us-ascii?Q?xhY0+wwI3FTF1pGCXk9AdbgFBFU3iydFu4MsmJsJTFKu21lVxJwx+KAJYTRc?=
 =?us-ascii?Q?o5ofuToQMkbZ2/awDRWvmWoZEtFRUBOTeE6HdTnVrEAZ9Hk0xbiktIoBELWe?=
 =?us-ascii?Q?ekb6T7cKesFYWWad5v4ETQ95Ph2FOGEFGOoDvkSUYvALGcve6CnJH2NCHYT5?=
 =?us-ascii?Q?2OOdzpIz5hvtaRICl5V3bObregbUfsdMHjhmrdukKre4a9mYBU1vxDeZnQY6?=
 =?us-ascii?Q?kZ6OnZq1ka/zzPPJLrBP5hSqcRppCvVKGhSl+BhimgIABzshZgpQvADLSfCo?=
 =?us-ascii?Q?v/sZn/pNRS9/EFzYoW7pFovd6qG21vAQtQwt3YUM75ZaH1UApiQuPlOzBpNn?=
 =?us-ascii?Q?f+kXXCw3mV7qw5bTLbBV5S5iJeBnwsKVF/D6ZD3tZOFgVmcQ7CPzekUsWLg2?=
 =?us-ascii?Q?B0vTjdd+EOUYlKTAKoMEJvkM8p9vQ7zDB8FC0jRqnRwkM4OBLoCTBDam5dC6?=
 =?us-ascii?Q?ZRzmK5HLpZvD+9wiAaTTUGwnnUn5A6pzQqGsjNU+HiZ5Qu+RsWaC9ruj5G20?=
 =?us-ascii?Q?F/2fOXMNJfZ8SKbTVYkXA9cRH1FoWflb8uLdCUbBYjmtDVMkGfC6xQyJyFcN?=
 =?us-ascii?Q?7cKLafydx6tF/DKarpztKGP0jb9HReVZqmakidXhQZVBD9+6RdgEhF4q+LcN?=
 =?us-ascii?Q?3kiVdvi16Wy5xUSwpb9nPzJm7CUUjRO/raaNvu0GO4fIWrR9xIuGLygB1eEe?=
 =?us-ascii?Q?KqR1di05AD9gVMM4+ru2Ki5dQu0axVyiIxKXinpUNYt1owN8T4KYshybVYGO?=
 =?us-ascii?Q?dCDjHR7UQmXyPlpxfLsE5/ClYq9MNwlpd2e+dwO12R+Z/z4gS4DB73c6lkej?=
 =?us-ascii?Q?fDo8Ic2hX8x2jarvB+BqFfDL9L+62Z1eNYjXJl4F7Ob/8nS7WEeijXK/t4iP?=
 =?us-ascii?Q?Om7gzUT8d9Be9oUiK8IZlmhpmcBbnzGqGVTJr9Dau8W2wQhn9Q97nN0LQHCD?=
 =?us-ascii?Q?ZZ6D63UDMsb4Iv37rz+mVcWHUEqtyDPPzDbdLU70hMft96bGvBUGGSTqXOkV?=
 =?us-ascii?Q?jzqO/1XAc7Ks2UPhGwTyszxbFhESBcsWaWV/wa4tVWK4LCuztCRbTdmB0Ewh?=
 =?us-ascii?Q?4kjUkg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca00717-a6e3-4e70-3c6d-08db52fb27d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 15:11:26.3409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhJNeko7e/7ZTGcPOJSv7EIXECdEFy7CZ6Qpftx4mlr/1bPq8VHfIOVQUJMEhF+OEt/r7J73HKLzmFuUyBXxeJMHxyi0p2oBm0ioZsZBgNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5455
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 01:20:32PM +0100, daire.mcnamara@microchip.com wrote:
> From: Daire McNamara <daire.mcnamara@microchip.com>
> 
> On mpfs, with SRAM configured for 4 queues, setting max_tx_len
> to GEM_TX_MAX_LEN=0x3f0 results multiple AMBA errors.
> Setting max_tx_len to (4KiB - 56) removes those errors.
> 
> The details are described in erratum 1686 by Cadence
> 
> The max jumbo frame size is also reduced for mpfs to (4KiB - 56).
> 
> Signed-off-by: Daire McNamara <daire.mcnamara@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


