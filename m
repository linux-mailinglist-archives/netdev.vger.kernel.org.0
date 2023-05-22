Return-Path: <netdev+bounces-4311-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CEFE70BFFA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:46:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DA3E280F5A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F0513AF7;
	Mon, 22 May 2023 13:46:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2563F13AE3
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:46:27 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2111.outbound.protection.outlook.com [40.107.96.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE34C6;
	Mon, 22 May 2023 06:46:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dngCf8fM80UaULeniFJcBAUTnMSzdEHSejHRRefIsnDkhRKYPzWduLi9pGyxh9lD+QHR9clf6UHN13VYH69vJADk7Kia77EzZc4QkQ/kpVP3Sr4WqCQbbaGWWnQgBocKzR/koRgbcJHEkHSnbglI1Ax8GvsPsHOWJhzQugagkL5TpHEums7d68jEOI/dt9nYb2BF+dq3PwBycvr+hunQHZb0xzUXmieSv7E9Zg//2287OUM/i6ziEBQk0zeHIgcTeXtSh5IUPHYcB4djgBf2icb0vq6BN4rT96YZ3oWVIwUD+YhFOzwFNgrSAFP7OuAfxK+n6hS8oqP8CIfW89v18A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojOrWdKxgzi9j/Zmvcg4Rz42T0wmgom9sT6xpxHIllc=;
 b=mWLuAQVbMOxzzaliYPWzJqTqpSAQXkCBzJaKWLh8C7n5pHrKjK/sZ68zb95UesnPqvhnGvfhA8D3CuHWSY7jhTbUxtkdtugYhBJo36ORNVre+OzJjxh0ME9m0ZL8YkWoCGJi5TprUj2+xVevBJ/oB+Q0+Reno+2ldcgySb3nBWFkouybkB9ZKBJaFcf8/byrbgf3FoUkwUJSGdSSUcXRXRJu3/83Dm9oWosRoVtydbK40M2d+WcuhOse8Q4/K9yU3II2SWWip6t7cEAmh0lR9iYUhY9GiGB/3wNC7zfx/1LJPW3GZZFR3SB4J5RwLBm0A9acxoPW4z26h5TQgK9DuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojOrWdKxgzi9j/Zmvcg4Rz42T0wmgom9sT6xpxHIllc=;
 b=Q9BjWBYcgMK0FW3316VlJK12DQ8pEGScpMUIDkfi4T20O2noKg8KfrHB3KDC5A11nX6xV/Z1ukG0utMJpSehz5N1SG+36SynrssWHXW0jb96Alt40XGcZ7a53y6L6obVQNAzah5ZaCVQ8xpZE7EarkzIrb/v0JGrQdZphaqsoDo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5422.namprd13.prod.outlook.com (2603:10b6:510:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 13:46:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 13:46:22 +0000
Date: Mon, 22 May 2023 15:46:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] lan966x: Fix unloading/loading of the driver
Message-ID: <ZGtyJ504Jv5YYcx1@corigine.com>
References: <20230522120038.3749026-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522120038.3749026-1-horatiu.vultur@microchip.com>
X-ClientProxiedBy: AM0PR04CA0109.eurprd04.prod.outlook.com
 (2603:10a6:208:55::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5422:EE_
X-MS-Office365-Filtering-Correlation-Id: 41f21351-989b-4e93-2a7c-08db5acaed83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sLU/PaSKywZmQx5GioncDvSEjSUxWcT0QbUklaO2zHtC9jR8srOZ/2SvYgI8yD4S32IlV4u9lshr6po244zTYFX9tZp7nzQ/eK5SK76TNe8wDk8RzXxEvxW4AVmgZIwms3WEMCw2Rf8zrS5DibI4MeL8LP2/MA2PFJwtSoJ/DA3HVEQk4MVf2/24a4I0xe2MMKE307ranERMWKgHjS9hAXXumMuLgGAVnsoMku9xQRzFPWrPTYYSXO2h1NOJhD+cxjxwPe8iUJu3yOPzbKWO67WXmY86MxUs5H12Oz48y9y6FDbtFbJoZTSV3hk/bGWDbKi5mog3IfcUJgGm8SqpQK5+5neIJvw6p969H60YsOwzio3bKGEhQQdsb2hHhrwNTGVcoYNXSymIKZv04vSc5JoM5nbVmBg08eLm8J3KpJIOTLfRlmKj1F9Oz2bNiCDTofpAdw5VsAOzlBI2zOpLs7AoOStivW4O9iOqnw8Oykh6Wfi4gSJPHc2q7u6VSd+YjADXUDOadZ4W0H5grasG2m3KNOQPF+xKZ+6sWx7oCjs+sLlEKJui8esq7cPIHQff
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39840400004)(376002)(396003)(136003)(451199021)(2906002)(5660300002)(44832011)(8676002)(8936002)(36756003)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(316002)(478600001)(41300700001)(6666004)(86362001)(2616005)(186003)(6512007)(6506007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ONfHiRWZg7kfqs7Hq/B+6frIfIy7043VuB5+QgsXTL5ApWUZijM5IKCgjw4L?=
 =?us-ascii?Q?isL1jOEl4auUFKUWMi2sfNASeth9Y33vZS2Qq+N5b81UH+5b+hVK14kmFWFW?=
 =?us-ascii?Q?HTXU03OwQLoCl5vfFsXalJ8YNMgMuhoV0m7kdmC8sZ8HfwKKoCmIEkLc1HWd?=
 =?us-ascii?Q?QMyL6c3bm6nyet9KVz2DpCH+jy2HVPkSbDo1+rX5eEKk8Hmkwq+pWL7JGiKl?=
 =?us-ascii?Q?IifyyhssXxD+LWFjWoFXNKNSnle118N+3Asu/JVXYOhIMdnd/ZSJQRrgMlyB?=
 =?us-ascii?Q?w/aq0AHxosStJpPEEA9VEYDAnxHgfluh80Rhyogq+POsRUGdrDgJJl7+w3d9?=
 =?us-ascii?Q?IhXRkcfu13KRVuku90lxG8EV5lfOIVOQmBYHre3HROtI7eOFGgxELzUbXJcl?=
 =?us-ascii?Q?Uk7797HttMMQVw2LCt7p/t4IzExfS4xCTqu9ChR2UHOQuogFNuQZbR+0CjAk?=
 =?us-ascii?Q?gAjSmc6SrwarU+cspHm51wBpXC9puub/+Y8ocgJ85ZJF8EcW0tkr3B/NKeMU?=
 =?us-ascii?Q?kTCVSjdVarbfM6hlU+4sCyD6yYEEDn+8d7OqHZaDGoEBu6GIeqydFiUcu/q4?=
 =?us-ascii?Q?SuUtbRvyx9CPGNJLiIaJyflMBm7YaMGz9MKcTIWPk/w1bJFEx0/lCLuIeYhJ?=
 =?us-ascii?Q?xoRN5iTcDhgnPd5PLAt33GeSFaWOyUffm+o2ySzJRe0eGBNzzNwnGyDKLHEy?=
 =?us-ascii?Q?ZLL/2nAmxxHHlhYNjOiLBrkJ58rcpG+A3B0j/CGBAG4Z7TVxC3JuZxRKZwXc?=
 =?us-ascii?Q?70hgBYBsJJSMHx8/JmTZIew1/IkAMhuF6hZ5po65gehDLGvxKUAcIx71usw6?=
 =?us-ascii?Q?4L/qD8a88rKa8ckUR1SARu2fRf4O9Mpj1fxU0PvodwarGAcK4DiFWb6rKnHX?=
 =?us-ascii?Q?/uhloFwq+hLw7KkT9WBHi7xgYvCt0EjbXhA1H4Y5mrBJSeSWwpen6j9uMnDK?=
 =?us-ascii?Q?sGKFEcmKLf7FgKDwD8vLxFo9Hhq6ppeM5Xilcf/u9lA5YDHap59huSb4oJ5P?=
 =?us-ascii?Q?tVlAMPtnGhK6yZMOKf+nClq1LD2WS/i/taVkF5E8Gn1m2EdmmPyLigrtOd29?=
 =?us-ascii?Q?vSJMIRzcDCdmnh89gEIpMLNuCzHgKvIiFh4y1waPbQbEOs+NvOj69yuiBqhg?=
 =?us-ascii?Q?ge0xdVrRRXA4J6S7qXwBzSPLC/1kLT2yTqKWAwNgEYeM2j77R9fRUJukmDvU?=
 =?us-ascii?Q?B33W8ZCL/TUoJrHtzwZItatkTquhcfK7DWSIrrj4xjp5ryPEGJBZmgzTERVy?=
 =?us-ascii?Q?93Qt9vNM+o/eEHprfjMkJKgYkAW6FRbI+QVCwEsO0jdgKoN3FO0dicApU42z?=
 =?us-ascii?Q?/kdNv5b932LJtmR5ZXUE7MMK2ER78fROymJI5uFV+WhpXooydlWZwbQhtZUZ?=
 =?us-ascii?Q?vpA61HEzorX/mqDkP4k1iqIStVEej08FQZOdr4pvX/AjdKLvmR1jlJJmJsnj?=
 =?us-ascii?Q?CdwNUj7mHIOm14j7Z7T3XKK466MQsJvYV/n7z/pA8U0ySiJ4ZDg99lu3DvGg?=
 =?us-ascii?Q?lrJ7XdzdFbuVJeWM63YnV/clSxOw1IjAgu1OeJ5TevEn4AWcs39ZOw1jF1hw?=
 =?us-ascii?Q?qzNL3D5QaPijpG8s9DVwHH/6/5a7QTFy+cEbe2se2bBsGVat0EpM+DTeSTLM?=
 =?us-ascii?Q?CJgXXBaE2sLpWDTGxatHcK7rTED9a6mDQ9vFMWY/ymnLsmT61gvvmIuUAZ84?=
 =?us-ascii?Q?6aKOUA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f21351-989b-4e93-2a7c-08db5acaed83
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 13:46:21.9422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +iXopXbQxK1e5fHAuYTT5fgYVBJi6UOCbqCXuM5c/i7yEoKG0144OXeqcGsilrnbX11+ksD0JEbpG/ciyX+47dv9akvyN9RFpJKnGwLwiYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5422
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 02:00:38PM +0200, Horatiu Vultur wrote:
> It was noticing that after a while when unloading/loading the driver and
> sending traffic through the switch, it would stop working. It would stop
> forwarding any traffic and the only way to get out of this was to do a
> power cycle of the board. The root cause seems to be that the switch
> core is initialized twice. Apparently initializing twice the switch core
> disturbs the pointers in the queue systems in the HW, so after a while
> it would stop sending the traffic.

Ouch.

> Unfortunetly, it is not possible to use a reset of the switch here,

nit: s/Unfortunetly/Unfortunately/

> because the reset line is connected to multiple devices like MDIO,
> SGPIO, FAN, etc. So then all the devices will get reseted when the

nit: s/reseted/reset/

> network driver will be loaded.
> So the fix is to check if the core is initialized already and if that is
> the case don't initialize it again.
> 
> Fixes: db8bcaad5393 ("net: lan966x: add the basic lan966x driver")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

