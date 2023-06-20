Return-Path: <netdev+bounces-12218-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B687C736C3B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73052281227
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CBEA14286;
	Tue, 20 Jun 2023 12:47:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A09110790
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 12:47:36 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2122.outbound.protection.outlook.com [40.107.237.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B22810F4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 05:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GoeMIkOP5G2WpbK3N6KVjT9ROkKH9pry8pUu+74QXp5QRKiIl8LP/3umCzHBe0eGmSTQ8nZ7CxKQ6DR3dKdcfVv+4zgAo4584QIQwdXzogTQ6RE21uWEvHrlNzPJ1sqOD5mMHj0htsOhwhws8AxwYQiq8l+BZHbBmz3dBQwfFzP00OJHpotLant6AO/4hPUmof6bWT+d3QDrxeUZfEPdLh+KGiwcfNNldtnC7Hwhlczbood91fNjLgTXJCorc5n9fuC8Vx2hoTygiXIdWMsdvEvaGhsEL5Y5uFLkbOL7DW900WfGirNTXa1orj1Nw1b3IvpF36Tb+mi9jiHBbgy8PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l4xF5/AQjZaPTwXCgVvQdgLZbQAi3l9S2Yc88ePV9QM=;
 b=ZXi0iq7za7ALworfmnmyrZ9H9oaf+1jQyRU0t4YSxuUssdJlDgHQ38KjcBLFuCP7C1bad/tO3znVvmT0Ds6mHlLhJabKmZmep1ek7kocABtNpMQCiz5YoywQyJJQyQEMaYQR1B8KyOOb3L5CROz8IJ03jVqgwVDWtMGO6OxhUOiih4xtSCxB8JkOASZ4FPsHMch8Xm+nYYIvTWVidN2TLEVJYyYh7spO2ljnfLjCls9RP0daFybTMK9ozn3GXxzAKP4FQOqS4hzymAX60u5GfFOhFnGznCwALb23N9zkif2BKP6r4wc/SgIBQ1QAhQG9Ga42wE8Z/gxQ5VmseQqGxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4xF5/AQjZaPTwXCgVvQdgLZbQAi3l9S2Yc88ePV9QM=;
 b=kqCqNfd0I02ExLyMMaWkEcuSXtYwM7hGwKAUQZViJoiNyInOCgREdkSJDDxB7QDFWN2PLgeTYWRAkKFMF/zJ1g9OF78SVLLtgPirygac5VK15TwFUfcfCptriMpMJR99ZRSxmfOhy+WvBcS0N/oRb8DogX0RsBydcezZ4+qJDl0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4877.namprd13.prod.outlook.com (2603:10b6:806:186::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 12:47:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 12:47:32 +0000
Date: Tue, 20 Jun 2023 14:47:24 +0200
From: Simon Horman <simon.horman@corigine.com>
To: darinzon@amazon.com
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org, "Woodhouse, David" <dwmw@amazon.com>,
	"Machulsky, Zorik" <zorik@amazon.com>,
	"Matushevsky, Alexander" <matua@amazon.com>,
	Saeed Bshara <saeedb@amazon.com>, "Wilson, Matt" <msw@amazon.com>,
	"Liguori, Anthony" <aliguori@amazon.com>,
	"Bshara, Nafea" <nafea@amazon.com>,
	"Saidi, Ali" <alisaidi@amazon.com>,
	"Herrenschmidt, Benjamin" <benh@amazon.com>,
	"Kiyanovski, Arthur" <akiyano@amazon.com>,
	"Dagan, Noam" <ndagan@amazon.com>,
	"Agroskin, Shay" <shayagr@amazon.com>,
	"Itzko, Shahar" <itzko@amazon.com>,
	"Abboud, Osama" <osamaabb@amazon.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v1 net-next] net: ena: Add missing newline after markup
Message-ID: <ZJGf3K+oZ1x6wVYz@corigine.com>
References: <20230620070206.1320-1-darinzon@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620070206.1320-1-darinzon@amazon.com>
X-ClientProxiedBy: AM8P251CA0013.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4877:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e2ff306-18e5-4be3-8ed0-08db718c8390
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FsrqkJ50hXjln697hrFxapRJSLG6YgFj9PqjEObtISdqvpS0YxiSoVYvG0eOcqSrJfRbOblaBvqJ4M4q6lnZnOVNRh/lGmQRIwcREwX0cY31AMD0bAW2zG2mVZTn/sFej04wFfCGGHjb3sP8FgQ8orkGVG8QE1blnKZrbWsg4nX+Y0/DrHTdDUU+3JPsU/xJxJlSsL19DXOOaTdU/zxppE4BohSKv4qJ2QQOcdI/WCXlC9cmpxtOoTTXRwc4WzykKED+PzqhTY8EtziMhkyuSOUmzFK7kfXaZljPlxGmx4hydpytJObF7dfsW7mQQoB5Vaed0BQ5Q/a+qblhpDv6o13/lHd5QIwANCE3YRZHec0K9Cw3cgwztplwbyK9syn7djufXPqCcblua1AWdXKoAEw3//HWtud96kmPQolEodjnnVRWiksgeeqsV/sHey44SCafO266pMkBknEB2RjpKzSVq7P5j65lNwEwMHg3+jrjpQLhJviyKL6O0B0NSGngPDS0dy1l95JRMR9i+Ua+6oJVQRNu1TBDRAI8cyHbSH+T4rYctkPVlporoovNvcphC5U+bP9o3VQV4fzDTmkYfO9ECKYnQyRj+lqWsiF5aJg4h140J8C3D/YgMUJqSNNAAsw2kYSakmOuRqITZrAu2w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(396003)(346002)(376002)(366004)(451199021)(44832011)(38100700002)(86362001)(83380400001)(41300700001)(8936002)(8676002)(5660300002)(66476007)(6916009)(316002)(66946007)(66556008)(7416002)(2616005)(6506007)(6512007)(966005)(6666004)(186003)(6486002)(478600001)(54906003)(4326008)(2906002)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MQlUDVdvdGv3IatPbDOafPWxJRSGJFKzkt1YgOqie77vNspfuimEf/9gG026?=
 =?us-ascii?Q?QFDuYaWq8XCoy+PtRB/Jmc4P1AKyNPhT9vpB/xbuklCn9y2uzY1vOWWGax54?=
 =?us-ascii?Q?P2zhHHNEa8N/zay79zbwOUmhpyON/ZlLw1dhN5iouffiFTuflfCgpYySOXwM?=
 =?us-ascii?Q?z9fz9J7S9y/gtZp990Z8QQDnd/U1mN/JHx5FAd8ATFJFTCNu4b+vWE0WinkH?=
 =?us-ascii?Q?VPFZnFrKbwIbSD9WOls44dKrivdLeBck7Yf6mjNxB7sGnwygbqxMi2xCWLIZ?=
 =?us-ascii?Q?PnHg5G35AG2iTGXHwyzG79rTWyxYR0AVKpu8cvRIOPuEPg9g1zjlf12vJzdA?=
 =?us-ascii?Q?yGhzV0ctC+zrhpsXQGR3cIXspG+DY1ziAVHrCD0EPJul7GP3wOGRhMkc8ZUR?=
 =?us-ascii?Q?tFhgjTw3w0Q9k7hF48jxV2Uo4JJSCce5p3eHT5YYfLZqfPO3zbI9mEzkbCye?=
 =?us-ascii?Q?Xd9w9Z8DKfMGfYgHlgubeuMk+89cbSlhY6Oz/gtBDZurJC541IuvR1/ViN4r?=
 =?us-ascii?Q?gX444Ae2YTuOe9oQu+qsuoCnS3LZpfhhXlQH/CgbrScqkZjlogP1wyUHA2Qw?=
 =?us-ascii?Q?GBmPMqqD2V1XTQTd/8Hgs2Sb/EJyC1xOYQ/NSRbU2ip8+P4MVFtSBCjIfQyI?=
 =?us-ascii?Q?0y9xPzn1Yr69SFLCqDGqsOFQSknw++x8VJsO30aIGDdmes+a/XGC91HFOgvv?=
 =?us-ascii?Q?0TD8hWkxJi4se5yzhVncAZHjZDgxkETgTfrxVXG7nnkM/XnFjVWU84kIBJqn?=
 =?us-ascii?Q?Rg75a6luOckNNy5RwFWjpR30BviuMy5jXgeVX4o8TgBLz5jWxmLJL3IbS9I1?=
 =?us-ascii?Q?milqx8QgILZAjhHU4IciarGmVEu8ENLVq0AOdbL4JEKxGRMYZZXaPNAOh0Ew?=
 =?us-ascii?Q?G1WkAmB9Qm3/S3JWJ4HvgKjcJX+uYszFAKVhnPC/EiPnWh+Wgbj2PHvTvQvW?=
 =?us-ascii?Q?M6c8TuLPH/OiRxzbHYxOUrhrN+IhugENfLsaExD+ctv8yRekZXpI2Qo57NBQ?=
 =?us-ascii?Q?B2Fk2cUoSaXQSLmsTQtOSDv1GohQfQkMM6ZQzba6SoguQJgjITH/0+t3UbbV?=
 =?us-ascii?Q?qw2eVRiKJKIYvN+8129OeWr99h2m7ukBA/f+4meuWvRAS2xYD0SL/9g26DGX?=
 =?us-ascii?Q?ZdVF+OQO/KjmVsWleGsVCI9SZ+Xj4E83CuPY5RoTu+RNG2BttXM3XeAsNwQC?=
 =?us-ascii?Q?MB+Sh2zgbfJ01cK7GJzoAJ4RrTUis+smpve6suIOtu+9rw8vYvOoCllkrUvK?=
 =?us-ascii?Q?G0N+Q9K7MnJ5w60mUvLe6y3l7ufOmwHdiFLXPTeOusXvSTHkePnssFR+wWxq?=
 =?us-ascii?Q?psD0e5OSfIyu0Kf7fqEZ99o/pvcGlTHxjMuqGESIgD0shjSXLRQvehc3yqOh?=
 =?us-ascii?Q?iJxMhi9YCasgGsTShBAfInu5HFQ3JzdRVPnYXkX0blKkZxby+qtka4niaq/O?=
 =?us-ascii?Q?17apJmmnAOp+40xx1ZkMg5I1R9E5vk6zl7ReniLSSeSXhvfiTVQ2/eHR7umB?=
 =?us-ascii?Q?2TMSTuL1GAKveOchqEC5juWPkEjFXPl371j8txIk+G8t7rRerqVgbatf3Sth?=
 =?us-ascii?Q?rU8+F0+zEmMNR+UDHiD7csXccPUVs03RF82bkANrA0mJDXozWuMV1kGmUtMz?=
 =?us-ascii?Q?+z0Fncv1VoD4ZXKo+XVx1q/NHkUxRjOzGfYzTpPPOmmEjTKU7tla+NpmpmhP?=
 =?us-ascii?Q?EUvqEg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2ff306-18e5-4be3-8ed0-08db718c8390
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 12:47:32.1388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BpyawzYxDtu47G5Ahqi677pcAnPW4FdB4QeNaiNEP80jECnylBImxbgyNRuiSycIvvQCdNxfGB8FmuDWfkPkiKrxGaj1YT4mMQ0KusUb7hQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4877
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 07:02:06AM +0000, darinzon@amazon.com wrote:
> From: David Arinzon <darinzon@amazon.com>
> 
> This patch fixes a warning in the ena documentation
> file identified by the kernel automatic tools.
> 
> Signed-off-by: David Arinzon <darinzon@amazon.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202306171804.U7E92zoE-lkp@intel.com/
> ---
>  Documentation/networking/device_drivers/ethernet/amazon/ena.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> index 491492677632..00851ec7b4ec 100644
> --- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> +++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> @@ -206,6 +206,7 @@ More information about Adaptive Interrupt Moderation (DIM) can be found in
>  Documentation/networking/net_dim.rst
>  
>  .. _`RX copybreak`:
> +
>  RX copybreak
>  ============
>  The rx_copybreak is initialized by default to ENA_DEFAULT_RX_COPYBREAK

Thanks David,

this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

Although it doesn't trigger a warning, the formatting of the
text updated below doesn't seem right (I used make htmldocs).
Feel free to take this if it is useful, or say the word and I'll submit
it formally.

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index 00851ec7b4ec..5eaa3ab6c73e 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -38,6 +38,7 @@ debug logs.
 
 Some of the ENA devices support a working mode called Low-latency
 Queue (LLQ), which saves several more microseconds.
+
 ENA Source Code Directory Structure
 ===================================
 


