Return-Path: <netdev+bounces-10727-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E985072FFE5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:22:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E631A1C20D11
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D86AD43;
	Wed, 14 Jun 2023 13:22:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B3F3D99
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:22:25 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2110.outbound.protection.outlook.com [40.107.92.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB9F1BEF;
	Wed, 14 Jun 2023 06:22:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ku3OYXv739DOlaDnm72v02bNtHv4cBBfXRnz6v1bFTnl7OnOuvFkVMTyagbOk/tFlrpek+ukziVdR3ZyRCsVSFVd/jfgz6vhn4eqRoTuIsdWC8ILyqPqrHNAl7DWzzfVckTiN65igb5PHbxFUmXlM2XeazW8IJvHpEW2Svjw2lxUqyFgU8W6PRcb8nV3Dok9l5aVPnHth7usk8d7iemJjjznHbisGe6rpqoFcV0EHZzQeOgfNdXAlBSqCdEdgg1ibBtZV5UHwA9H+Cpb7+XI5c/CSYWfZkhis89ZUGlHU4ZmBUt8BJR0Y4U2lvw2MV+uCakWvqRtQndY947rt7KGEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5dvz9wlM4jztB25uB6NP7ymWVehJob7EcQRWfqAkzI=;
 b=coj8XZzp83CGTkuGtIhKPg9O5ZvumPmB9TKqoqivlJYQ205la0newZ6XFXse0eg13OOvojl9TEv83MNDq3RXs4fwBY4znIaIa3H0+AmAyDPqiVQGQRUPixLVPLlYQOIMNSarhVflARXBb4mnGsp1fsw9BIQ6gPWWQ9yVzHmB5buuIz8W+4JCAoe0iRAqFtviQNMT3cki+Ika7RWrRvQpalnYOA/HH7Xc0d3e/fkZSkYA0EVmsBUu7RUX1+HxS5nnEN3/AbbndMCwUyxkuo0SXwwnS3Q0sn3LoS5hyS/e7bNodtqrQd9+ASyO665G5gINX48KtZviVw0RWOWCjpLO9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5dvz9wlM4jztB25uB6NP7ymWVehJob7EcQRWfqAkzI=;
 b=FbNSeCuPlo7slwpD2uv0BzxqVkwraGPVF3/6SH9fdZW7Z7jYKIB03j2CN8RK7KuWx2KeYRBBFlBUGobUyJjay8daZ//ms3GvE4D4UGd8QtoSv4U/nNTA/JH+/Txqva6O1s6hG3AlxOcL9HBxkEhdkNTTBmRPnylr2yzuPf/jjsY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3878.namprd13.prod.outlook.com (2603:10b6:610:93::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 13:22:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 13:22:19 +0000
Date: Wed, 14 Jun 2023 15:22:13 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] ipv6: clean up some inconsistent indenting
Message-ID: <ZIm/BVd9vUQ3E5ma@corigine.com>
References: <20230614014959.23000-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614014959.23000-1-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: AM0PR03CA0028.eurprd03.prod.outlook.com
 (2603:10a6:208:14::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3878:EE_
X-MS-Office365-Filtering-Correlation-Id: 0694d582-2907-4535-049b-08db6cda614e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Lo+439glIuEGtNkwQ3SG2ZJkN74ACO4X9mBPv+ePL5NuQMhOe06/pXjQD1icUV0ThFobTQZPyXjBRpX1C1RkrpRdoskKvd6o16CBGBn60lT/rucePiYhGNtY4EZW2QIjwLYOB3TLhHAxB3/zAPFj9ZXH7o0LwWGTZWSqEXupTSnZSPfSD0DiPNaGf2uv3S75ySl4qaXg6vq2EaFouXDiRNwYkr5akMfas++1JVSEr0cRSdWjsjXbJ32+krk6yqXP+NCWgkTK6i2zzB+p2BMIBg6SoGAqx6gq8wG3qjSdY7kLmL0OnhklwclSuX0IU5zRiUx3o+3b6ygCTt+Hfqsb5VwKDfGJoWlMVCBAdAuvy9YDQdQSwkifLxhT9X27ODEG9khdeXPggfV8RiWZh74lblG/pRp7Kyj+1kJyXZUhUtisbn1elmNugo608+fkjcta7DwAGZMM5jZij/Nq85t6/IX7DqPKOanU1bU4TD0Y46XJMslR7kaIXZmSpGcktVB6CvqFn9skSxeEhieh0qkndgXG51HNoCXIVLDuLI75gQ4QAi5UQYTGwZrnro0mZYCwvzgyHweBoOhxXkbsZpaqrELwQulrkPuT6dA8Ha7XZck=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39830400003)(396003)(366004)(451199021)(86362001)(6486002)(6666004)(316002)(966005)(8676002)(41300700001)(5660300002)(83380400001)(6512007)(38100700002)(6506007)(8936002)(44832011)(66556008)(36756003)(66946007)(6916009)(4326008)(478600001)(186003)(2906002)(66476007)(4744005)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hKfUB1AC4ESm+Y5OR5WqAgFlcWAl/gAEXMfpvm9CgEqddgIDEDJvzkT6UaCk?=
 =?us-ascii?Q?n5vNRWYbpAJqkuj9hmjSFjLlMTbSoz3t9KUgvtzm+aLA3a2TbLIL6SZ1UwvL?=
 =?us-ascii?Q?f5fGXJEMynk2+1v7U/rVdzhjTRw2gZYe3FqK/I4P1UBZALp9o6IGjvWt2oow?=
 =?us-ascii?Q?lkWQ8YPQZtOlYvp6gkDgXX++HAsd81IABEazazsxWgfPkhR2MS7pbURIvcC7?=
 =?us-ascii?Q?P6B2jr/bsmq5WFos0Xrz6vMlrS3Qctoo6jjI4BXGWl6efktu+dTwG8DDWNCF?=
 =?us-ascii?Q?a7Ro4y9DH+FZsJKB8Oc5vG9cLzwnNOwDFr8t5lBS9wQaU/Upv0lIamGzD4Sv?=
 =?us-ascii?Q?DHyAbY6jPSRakdE7FbD8jd4kyzjNkb07HQeyBlq+Rf1TgRJQNifFbAF0PnBD?=
 =?us-ascii?Q?AUvzXkfqAxo0KZxwhDwopr7YOzeJwRlxqJ28+YqSlSkywEyo24LJViYN/iiH?=
 =?us-ascii?Q?0+6BZoGlsMIVEXE4zJ1NeBpfRZk96ks8WWPgCSNrVToEtBrwp+M9YzOhVU4Q?=
 =?us-ascii?Q?xyapdt69PAdz6/yy3pwDh+6Rtc52nlxxRdgbXu96/a/Pso9f7Jrs/kvJH8hu?=
 =?us-ascii?Q?YOTj8Z68FmN/jqD+SA4oEl+aXRZHlwkvVLZ5Ah87yiQa0+zV5E7LnX6eK9j3?=
 =?us-ascii?Q?/AtS0RLx0Cx1yEL3cXofAKkBLMEk86mPQYxQRvXvn6klcw06TPPeq/KnQjum?=
 =?us-ascii?Q?7RX+XxuwhXEOLs2UxPsjWsULHeqliWIP8hd/xVg2cjJpIpz0New4aV9cs1wM?=
 =?us-ascii?Q?AmsRAEEQ89ZOlRObdz3TNyYkcepdfo3HsDrGNWtKK1eqK1R6BLrhxDvFvQUr?=
 =?us-ascii?Q?gJep6+EzaV3Y9fmmm98bB9dSYx3nECYHJRYUjuJFzN1tg1AULLwEhjuSmnas?=
 =?us-ascii?Q?9x2wMY0r1hHHBhh+K0IqJn4eRWSaTZH8n93cz3C4GBZRmdIAl5hvVRZ5SXGA?=
 =?us-ascii?Q?3+nMIaeCaaR7U9kOh15nEWxrxIHCgO7AI3PRVifLKNPzS87pz/q31kcfAjyY?=
 =?us-ascii?Q?rc5i0D1uKjOVuk5OpoiqaNAqfPa+UEXg+pY3Vv7QE163NqgBQsJ1tcvvNDPc?=
 =?us-ascii?Q?BWivE4ZaVIEhDPrxT3mjpx6wsejbC+rgetm5qKx0KeDUxenNhcVceZljEwtA?=
 =?us-ascii?Q?FDazPDWlaCdqpBOfB3kDVQsdNViKeQLFZTHmGp4rujGo9S7R8A2XGm0RSwWe?=
 =?us-ascii?Q?9hSjPWt1VPk4WbfzTSADPD/DOmaftHyjlDiBXqjMkJXhdNHVhKvANcaF8O5Z?=
 =?us-ascii?Q?wqRE9BjW9qy+W+VB3CnnBwGdoBy5ekKArvjZMKGfP1cEqcWo93Wfsjt73Vpd?=
 =?us-ascii?Q?rIR82PDXMWiUjKTrdLvcy78D76W2qsjq81u41R7bC7B6z7b94WWi1I3Xm30E?=
 =?us-ascii?Q?0XDawmE3ttmJoyMibCeJwdrhrU5v+tZw1mYfD5GoxmlOE9hL9xAagWuN/gn/?=
 =?us-ascii?Q?gVj4OVtBtbQ3WsA1YfzGneGUiUUOaZaTTYPI7FoytNhZUCO5T2jKe5X9FMaF?=
 =?us-ascii?Q?7UfU9oMj1Lm5WalQaPz6Nv2RSuq5VIKNVQxkQ2dUtnVzOC7I547hqmwmdcg3?=
 =?us-ascii?Q?bBDVc0stHMQwicp00XCHSPhaKpR/25fC7ZGKzHi+xdeDD+DiKWXKjouBBCGN?=
 =?us-ascii?Q?tbrkOb8aEnbxeB5WJOv1nFGVNBrvZWZUPmsYhgKslpTs7TDwxXufeSiqCS24?=
 =?us-ascii?Q?93aFdQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0694d582-2907-4535-049b-08db6cda614e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 13:22:19.5676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hiZPiDgTsVZaXB0GPx1UXEoU3OvH3oDzYoqAE8A7T0Oj8DjZW2WKQ6AQX2m/NJTGCbsSzHbtjnkqMWCMnXJsFDg5+W1h9Ib7Mgy2fPnVNSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3878
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 09:49:59AM +0800, Jiapeng Chong wrote:
> No functional modification involved.
> 
> net/ipv6/ip6_offload.c:252 ipv6_gro_receive() warn: inconsistent indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5522
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Hi Jiapeng,

unfortunately we don't accept patches that only clean
up code for checkpatch warnings (or similar) for
Networking code.

-- 
pw-bot: reject

