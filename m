Return-Path: <netdev+bounces-1412-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BF66FDB41
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:03:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CCBC281067
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0166FD4;
	Wed, 10 May 2023 10:03:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DDA20B41
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:03:36 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2138.outbound.protection.outlook.com [40.107.100.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BA66A4B;
	Wed, 10 May 2023 03:03:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lC0mhAh2D8AjnZeqwrKdofclDwijdJxaYX+2kU5IcyKU4nY9sQjxHfH7rGfbBSl5TTx7Ebjz/adEiE6QyA2w4NX4NYchVyluWKdiBIwK2cP3emhswMQWf8bhc6e504CoHsWV6yiayyd5G4vuU1zNFdIAsioMDwm0Xo/K3Nphu/ZW4lh1Ne7AsG8ROPY0A6f9I9/ad9ATOp7GIN2WO78of/r7VMHe5cC6T0RNldmWhT2MCFA/K0OXozLY/mWM0BWvEbw3uZDTQfHNhTjqPKgMvmcLvgrORvC8Zmc0BGF3wdcypj1ignSqlHFOSXUnrjPQ2Zt4dlxomK7oZvS0+aAwtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phuWtBxAlF2JypLpgwuN88me+nfm7qmUO7l1d2mamQY=;
 b=bNppwuzooa/Q7LjMsggSc63dqdRZAhvnUz3xPbnf+dppK1mStOVyN0sNiNJ4bER3boJbSrZKYUH3flaIKCxRviqPgqbsIN0TRa1kv4HfEJdIKA2MxcO/Dkla8TnK5CzR7pZh9K8x/vxeGye/3oMPTm33KAN/xppol/4HE/dcTGJyQsGNmGghJMQJaDHn4U29BcciynMlnUjNJKrUXNnzURscSZo4e7K2p2oH5E1CN8AQti8Bay8xSQ+g/e55dvOD7IbOwD/MZoTWvXTFMwXohcaHWscTNurK8o0JuokL5iCk0CVKLwMlsBW1ewfC5jtxGLYVPSX8rNE6OlPfzEQEFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phuWtBxAlF2JypLpgwuN88me+nfm7qmUO7l1d2mamQY=;
 b=DQ3lrt38Ev9LrWgpR3Q5tKy3WOmdAcm+icWir+U/tmleENKP/qgIoxFYIIBZk0UwyBUn67W5tVIY5LhyFjGcvPs1+FJgLZUCR0Kcu2awbFVanbcNaOzRkpLXgIwNVQaPDLB7I6HGjM362UVDR8Z8SefmLYfnIZRHo9w21ZlvNiQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5590.namprd13.prod.outlook.com (2603:10b6:510:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Wed, 10 May
 2023 10:03:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 10:03:24 +0000
Date: Wed, 10 May 2023 12:03:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yan Wang <rk.code@outlook.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@armlinux.org.uk
Subject: Re: [PATCH v3] net: mdiobus: Add a function to deassert reset
Message-ID: <ZFtr47e5Q9oZ73yq@corigine.com>
References: <KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-ClientProxiedBy: AM8P189CA0014.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5590:EE_
X-MS-Office365-Filtering-Correlation-Id: b0b3f243-8fc7-4240-71dd-08db513dcabc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VpG3ytNLWPMrDEKuVcMNeRBzUhTWyYWrFsp6sR7fm8EW4RW69m3o+Ki4LL9IttLI97MJ+mbYokpIQ3SfDpIra3UVJllXypAlED5Owly6/4hEjX2AVB7lJYuCSixE/woPPbZLH4eh8xUoYHq2OT1KprEB41ctTAxbuwJ4CJUslIF4VbwcedRJs7o3u5qQWWg/aqSJNxLCs232MY6vk+caOVbBbIf1PbwUKHIuI7bTLPVTKEXdw3zMdRP+zGLJ35Xh1JsGwz/+DT0zNhQ0+lr0h8BVIaHunKj6zeAKbLytk1G+0ZkfZ9PFDOyBiwuCSrdoLMmJSqt74cUIx0SD/bk7F5AkSFp3gcauXLyF8JcgMsiZCm8FblhCRIFKiJnFnTkjWHjGoUXY8uXysL9frujxseTeNpEH810QOFuXsb7ZEXPnUheyNt2HMDq8QyhyOu7W7H9Sxpb9IFQY/ltFAgJ4utdjzD1RMdCzQ8y1NtRZDsq4D/vJEfbW+RF50BJnr4XEsGAkWaE+KDNNjqkIGV/ElhCMyPcNB02/TDUVGd2306vAWbgrQQ4KDS+6RJ1SE30Q06cXeRPSBm/oOUe3xK5SRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(136003)(39840400004)(451199021)(41300700001)(2906002)(4744005)(6512007)(186003)(6506007)(5660300002)(44832011)(38100700002)(8936002)(7416002)(8676002)(478600001)(45080400002)(2616005)(36756003)(6486002)(6666004)(966005)(86362001)(66556008)(66476007)(66946007)(6916009)(316002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GadyNb3K4bL9qSR+YgaTj/YdWSYnGePZscjmZ0tyZrtXWmEzzWRcBiXvuBs9?=
 =?us-ascii?Q?sfW+0ZOFpS8bwVY54kHb1tv2N7RKqcTEMjiAvRRI5w/lloN+WdVM2G6ir+iv?=
 =?us-ascii?Q?4OYHw6tHu1NgY+ixG2KgcHFnojTfKeu+utiHRgB024ML7V6rQq6w/7nZtZO0?=
 =?us-ascii?Q?TSZVxuBd10iR/jJL1uhVNL0x+5HlXLJJPlOx7hNPtggilWV4hqTod/MKGiXC?=
 =?us-ascii?Q?NF1v5sWZlZNf40jat5zCBx1sHOKI3a7S/Xrgv9I4ASDTVaefHemwVg1T8Juc?=
 =?us-ascii?Q?OSoMDfCfHvVS+u0HnQimGPe+WII4gqt7MSUcc9z0qgTT86YNQ0Xjueb1a0gT?=
 =?us-ascii?Q?lH96CiaX7Vj4IotLshG06Plg/XTzZbcSegyGR+vKKwNVGjJhwARuxymQ1e4Y?=
 =?us-ascii?Q?huFmUyn6qdBehH6Tuo2ShsX5c2OplUC6mbq++mmf+udYOiEVu/8KQdqbE0wn?=
 =?us-ascii?Q?Mck/pY3vcFO+UlpzV4VdOxnP9//R4ibCY0krdWVQpgiOYD8V/o8pgWo3tcQk?=
 =?us-ascii?Q?MlNwOeVp+2jTNRXui7eeQ42A4X7CLPQ/CshStLuLGoPRglR9giTYpk8x3iQo?=
 =?us-ascii?Q?FY0sHcWBclluH5ihZlxtDeLASwB2gXQIvyKO9R2NfXNciyKY8VI2g0Nwt5mY?=
 =?us-ascii?Q?MVEGf4FEgir7mI2qrP9x+EBz+gMLOCTlAsvQGFcR5MEu/gauKBCnA/6YfQyO?=
 =?us-ascii?Q?xkGCNCEJGz3qSwapJAsnjgZrETjtmY2MJzJE1eB5FSpKxAfCHQohBBXvVhej?=
 =?us-ascii?Q?ey2RvzxZhTtnBHV5XMb20bQI/0O+ui3AV5AK4cs+YUHwwuxQ3FmqONuESny5?=
 =?us-ascii?Q?i+xTBV/VJe1txjSmBY6/bRRAbolTXBS+O6YBdPMGRCR+juaTmzKnTs0Jyg/P?=
 =?us-ascii?Q?acjqBdRgsy5tEUxru0SMGiLH4F06XgtnV3E/7FnJaNYTNHvSTzEXFtawadvL?=
 =?us-ascii?Q?5Me9Iot/LlNVXUtDrQPYc5eepb8ZBJCZlChZZgBAW+xh4hKtgT7CRqUfJCfx?=
 =?us-ascii?Q?IqytnLhIzv6jwUy5fh2PMrPeOGj1dB9DByMJM7w0FL9CIeR91rSF2F5n1jnl?=
 =?us-ascii?Q?iivhzfnfWzLCjKgGf3+CXn+Ek36J2iwdDjpe9lXbj48KFbx//v3DXSpnMixD?=
 =?us-ascii?Q?dQ1H968COTDW/Q2oxWVuP2VAHq2PgdasZEyRroChT7eMV/IA1Xy3rbAu9Mmv?=
 =?us-ascii?Q?Q0Us6P5YtoTEhgPnYCA+LAxR4Jcj2s96EpElThrwa8h6g4Tullc+2xDJWsPU?=
 =?us-ascii?Q?MQv21fP0sndaJqffLiUI/+GNBY0gxukUblVu17z20OsBTDUw7Fkxro1AHUoH?=
 =?us-ascii?Q?TiXqRg4hNdDSFsMYkonuXdSIaxhmXKoENAXMjqEb3VnAuNOkOcGiur4QmXOh?=
 =?us-ascii?Q?3UPQGtROM1OISaPRJGdUlmOZFVGk+zoP3M0cm5Br0GU7bTCI1jTVwKE+AfNK?=
 =?us-ascii?Q?/09yN8khzGbEJkBPnjU/l640F4TM852v8Xb+Mesho2WvmmsWguf+dpxJ/+Rd?=
 =?us-ascii?Q?24GXsZk3/gUTQwoT613Mx4xZAXVYzSoup9TSOjVruj9AGKGYLr9YhOIu9AS6?=
 =?us-ascii?Q?tHezDF41hYBaChpEuin0xT1toZDB1uagH9RhMQ7rCcIJ34C2L2qB4OZe4Fy4?=
 =?us-ascii?Q?G+KZbQndj/Lzy9rsQWQb67lVENXWhk+gFQpg9oWds+SZU4JxFpv/1m5JPJVp?=
 =?us-ascii?Q?cYjhgw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b3f243-8fc7-4240-71dd-08db513dcabc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 10:03:24.1445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0XUXARiDQEJCn3bRcmG4UEOOvwCyC17ALVz99OHF6Fk3XeSmqgAIqprKq0A+a5zTUQ/MvIoWkjvJ8vdQhjN/JrNbaNLp8v1VKHHYOxlD0cY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5590
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 04:15:22PM +0800, Yan Wang wrote:
> It is possible to mount multiple sub-devices on the mido bus.
> The hardware power-on does not necessarily reset these devices.
> The device may be in an uncertain state, causing the device's ID
> to not be scanned.
> 
> So, before adding a reset to the scan, make sure the device is in
> normal working mode.
> 
> I found that the subsequent drive registers the reset pin into the
> structure of the sub-device to prevent conflicts, so release the
> reset pin.
> 
> Signed-off-by: Yan Wang <rk.code@outlook.com>

Hi Yan,

v3 was posted less than 15 minutes after v2.
Please wait 24h between posting patches to give reviewers an opportunity
to review patches.

Link: https://kernel.org/doc/html/v6.1/process/maintainer-netdev.html

