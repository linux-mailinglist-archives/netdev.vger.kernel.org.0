Return-Path: <netdev+bounces-7925-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67394722210
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D50271C20B9D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24A8134D9;
	Mon,  5 Jun 2023 09:24:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB16804
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:24:01 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDD3BD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:24:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpFNeG4f91jkf88d9GdXCFaX7Jnf1Utyu9tT9ulcY1sX+605fj5QaRCgkiOiQNJTzLCcq6HtwpJP9fi+UZNK72yIDv9PZLQpi0W2+trjLbceBTGW+O1t+aLagGHMraC8ojdnuiQV4kAKgovBXeCCWBYpXxYV/IrV4bjOkGs2xGR43OURoP7i7+R65PPdIckOZV1IwmNlju5upVitFfWi2Imbtd45h/JjGvAyrMu+XEQPKc1IAbZZxfga7TghMT9wqULir0/hvwtYRolWbA9TOWQD+CQucxx7urKo9hmgBtbpQD4OpCrJDAfJNTb3pCmcEGktUFgca+8fTKEc60p0Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+U9Ui9Pzmj470zcTQTQAzX4wYgkYia5MVXUZJW0zqz4=;
 b=coUUZsQbvysTwLxXEqLfeaZPjprBmkbT5zxPwY/ufDABGk3vN6j/oRYq94TnCQU0bFnIx6SHbNsu1D0xlYPLNxNMnj4yo9Tcarl0aVTIKpcuchhjUxabS5mEDeOjB/Fv9TYzN9Sp7VmTyI2Ur4z37Atk2zP5yDqy6QJxnNO8n2lvJnmGQqUWy9onzKefpAsQBwI5B84mqdkNXUODy0qohLpX+fi07fET2O5lERwaunF93LVHbUYuE3lDOzZJ/VSDerr/+7z0D/8KXEJyHGAhQcV++Uji1gitGoNp+9BGCGKXME2J14sf4BW/dFKGTgZch50Kixjek4HFP+dCBrV0Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+U9Ui9Pzmj470zcTQTQAzX4wYgkYia5MVXUZJW0zqz4=;
 b=LUB4q1TdmfNJF3nba9Ly4thy3wetzCy9iO5RepKhX+8Xh7s3LqrOoa0ljXKKV+YldwaqK9jFcPl78QH7S5rJt5N2MXTdztzGNjGbux0qthhp7RlKqrb+Ra+D78+JRBbleoLaBYFbBhM8zpeiBcvls65PIALBkxa1NzSQg9OuAww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5510.namprd13.prod.outlook.com (2603:10b6:303:195::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 09:23:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 09:23:59 +0000
Date: Mon, 5 Jun 2023 11:23:53 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Marcin Szycik <marcin.szycik@linux.intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	wojciech.drewek@intel.com, michal.swiatkowski@linux.intel.com,
	alexandr.lobakin@intel.com, davem@davemloft.net, kuba@kernel.org,
	jiri@resnulli.us, pabeni@redhat.com, jesse.brandeburg@intel.com,
	idosch@nvidia.com
Subject: Re: [RFC PATCH iwl-next 1/6] ip_tunnel: use a separate struct to
 store tunnel params in the kernel
Message-ID: <ZH2pqYw+0kA/Zz/v@corigine.com>
References: <20230601131929.294667-1-marcin.szycik@linux.intel.com>
 <20230601131929.294667-2-marcin.szycik@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601131929.294667-2-marcin.szycik@linux.intel.com>
X-ClientProxiedBy: AS4PR10CA0025.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5510:EE_
X-MS-Office365-Filtering-Correlation-Id: 45dda37e-73f9-4092-9cfb-08db65a697c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	n1O9vs68Dg+nAiYgrFau+ibqIMpAZXcgoqA/DqUCgfGj/LuVtjM1AjmCV+C00zR9d6MrNW5UNL964fmUlAp2ircp4sX1JawkrzlMk5NSCWBZaPq9v+4XK0ifHi+9gWO5BtbIZltYNOxzo9qqRKRFdb8QDBeQd4N5KPK090QMsGXnPN8y2FafYmh01lkbi4nNigVEwFQ88omwOXVSirRYTk+VvOxMmZ4efl2H8583+GGcMsoNkvmNCvJ8uj61ONlej5hRLI7/EfShwEkmnJRTWjGf8ZomxQgJLh/YEEdUuvgDZ2msqFBk2uI2n9LIajcnIj/a/P1vPTi4/vASthN30yYfHW4CM4NEwGMN6IN3/RpXCON4B97ipJ2W0r3/jk5WWwnlI9BQk/7xv1VG/c9Ndj+ZP9UX0fy/nG+t1/jjF0+09ltoRupTrjPbkW7jcD6ir526VLjDdM6d4BsNAudArQ3EUsq3M/qkIXWMFJ12ccCcfiiZV7+adU+37novcVPJ0hA0Q9hG9jf30r9SNLB3sFJ26g1kk3W7u/2ZX8UeZTTT+/aT6D7kUwfBj4NOJseV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(346002)(136003)(39840400004)(451199021)(6512007)(6506007)(38100700002)(2616005)(41300700001)(6486002)(6666004)(186003)(478600001)(4326008)(66476007)(66556008)(6916009)(316002)(66946007)(7416002)(8936002)(8676002)(5660300002)(44832011)(2906002)(4744005)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YKd80JDo+drNAldbjwyMOvy23flPU/czvTQhQPz59fx8VD5eE7KM+zHoEOCO?=
 =?us-ascii?Q?5L+H/RREyAQFnke+WCiTcEr11j7vvkcYcpXbJMDXtYCgjFOX8fs/FaO80lDG?=
 =?us-ascii?Q?ufufksmWQjm3ZWijhRlcyndVqP34LAK/9WhQeLlJmwNOSiycISemtaF9b/o5?=
 =?us-ascii?Q?y8pXcy41GgMdyve14w5E8S9Kp1LiwrtDmhQUEfUmrgL/HWeKYEtvHaS1SCbx?=
 =?us-ascii?Q?kqRvVlJl7z+49FPIDHOo0xnUdxupCiI5kp0li7Akzd+g1CZs0i+lHqVwatNm?=
 =?us-ascii?Q?hDOCRDF1H1o0+xnvEge6KWYB05nY1YpDF3IvzRGkcUv/FTMkMs5//XPFXHqk?=
 =?us-ascii?Q?AJO75kE6FecmNdqr24CLAvUzGIltffEKCipaU+NlNgnDFmIaDrAW4kyqvxX/?=
 =?us-ascii?Q?QDhwaAOqGBWesi2jem86R1LHVw+GSoNi3bGvonBrfhSEFUQmjp7pzNytypOv?=
 =?us-ascii?Q?aeF8hwdHQO4mzbRYT9X0r3C1ZRbXfrIz3fG70AMAPxSXymVGzZ6MniYaFe9A?=
 =?us-ascii?Q?5kdohE+9qn7FxdYgwdtYcCJiKfca5mh3yodktMSPyQokrzHcruAufVbnWaJd?=
 =?us-ascii?Q?q91URnNZmKfal5cU4Ie+CJrmmN9CG87p12jD8v4xXw1p3+WZVackm/GDQiUE?=
 =?us-ascii?Q?o7QH721UhQlAgMW187LpcwUATc3YiyhpzXg7cXRaVGSN34uXvS/8PWzOWOqZ?=
 =?us-ascii?Q?DppjB/C2Onvkmj7UUC6LJIjdGELCdLejEFx92KmJh0HuSsy1T8FFCdxthjZ/?=
 =?us-ascii?Q?sZxT/Ho2y+qSCadp8tJehy1jjfvMhOsx4psMtEE/hQAKdfCX+UlGKmDgjonk?=
 =?us-ascii?Q?iCag81paR++jRo2ES6KzJFsN1e+zI2TBD0/Cdz/ol2djbuEjs3o0gdlFJudA?=
 =?us-ascii?Q?Iux4fmJWn0x5A2+x25oPOD08QWb6/SNuS86FP0HyMu9RrCc2yftmKBRyIU6p?=
 =?us-ascii?Q?RSMn8aAX7xbe1rAxDRGS/I+lXFHowhITrpz0pQf6gU0qr3wtuJ64sl0HW8uG?=
 =?us-ascii?Q?ig27JFje+P/9ENWWXnS661NeB/3r/cTJm+wsfopHuH5Q7thV1ez1EvLVK2G/?=
 =?us-ascii?Q?L/7HRn8c8+/mA5Grokn+1YylSDMC8Kpaw4CNK25Pnt9qifW5UalBazPEZxYx?=
 =?us-ascii?Q?8g4PnAClYu+PX9OROSzRzxHjEvvnILPQ9X+GQ5U/NfRPBCOuh72lV2iN+8BM?=
 =?us-ascii?Q?Bfa9iTaTznrcnCv72qVPB37SK6aGcneXBzMOYKOHVzS8BbZ95hS6nYMIRsQw?=
 =?us-ascii?Q?SUDYs/sMltzc7wmBgfJwA3rV4AalKIXlsuKxC7Y7Y5kdMGJfZuwXV+GbbqRJ?=
 =?us-ascii?Q?deg8slTvlY7M9BdxSNZ7VwiA3St6VhAfJD79Qi5/l6CcpWgYYv2DF8x0EVmW?=
 =?us-ascii?Q?dji7IsElO6l7R7uVFcue9rgxwmxr1m1xzvD57ox/XU71qMgZv2tw4npQ6vtb?=
 =?us-ascii?Q?2hSzuKpski4o9SI66zanhQp8pGFM5JMu+H76g6cDVCSESa4o+Q0B8hksBGGy?=
 =?us-ascii?Q?bFGjU3PSEunXRONIrCqIzP2k08i2Lq2Pjk1RX9Ge8Dp7ZfC9rWIf7TInZ/F2?=
 =?us-ascii?Q?pa588J6tjwL2+jD4Zw5UbT9TjlagWDaCPTK4GR6IA0jfQDxPf4VEZWR/l5e3?=
 =?us-ascii?Q?tmU9neYY77i26DoPDLINkiD+0vNq1CQbdBNVVW0i4GM8MR2uPYHS1RDIOGzr?=
 =?us-ascii?Q?sF1u8g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45dda37e-73f9-4092-9cfb-08db65a697c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 09:23:59.0277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HpiiHhQka2y1SB/XRgRByC+2J5JOmzz1IX8GK126v08YxS9Vl08fyYpI5u7LZ6FrNTcNQrq0kEq7/InMn3cb78Pogh8IXB2mCMYvX7e0J+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5510
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 03:19:24PM +0200, Marcin Szycik wrote:
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> 
> Unlike IPv6 tunnels which use purely-kernel __ip6_tnl_parm structure
> to store params inside the kernel, IPv4 tunnel code uses the same
> ip_tunnel_parm which is being used to talk with the userspace.
> This makes it difficult to alter or add any fields or use a
> different format for whatever data.
> Define struct ip_tunnel_parm_kern, a 1:1 copy of ip_tunnel_parm for
> now, and use it throughout the code. The two places where the latter
> is used to interact with the userspace, now do a conversion from one
> type to another, with manual field-by-field assignments.
> Must be done at once, since ip_tunnel::parms is being used in most
> of those places.
> 
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


