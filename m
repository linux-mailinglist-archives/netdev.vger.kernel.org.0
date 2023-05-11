Return-Path: <netdev+bounces-1800-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 101036FF2EE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FAB81C20F94
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32471F940;
	Thu, 11 May 2023 13:34:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEB719E4F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:34:02 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2120.outbound.protection.outlook.com [40.107.237.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A66D043
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:33:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W31HGC2ZVI5CqGuwfYAkCjv4R0ys2TMkP8TCJnTejv/CvOTgJfW8CkgroekMoU6SlRM1It+foAKWpiLHrTVIwsGti1LbkaF0iSrpb7iopv9RkHFa9IYv5g7wTnC7pvn+oHO2L0Lo0Y3uUtagc2givOZPOAWcUd4uGNA7gNT+R3wu0SGSxAX5sRiZLXm7apVZRWWHTREoUtaBQ+9TbCUhzBeAEEch1QCXj9PbAzWyCz+NrJaeNiXByJk7e82YaXD1LAGeAXJRZldyngV4ytgChkYT+6XHoG9sjEZeZtyk3gwIyPp77oR6+VI4hyQ7boNhSwJzh4BYNs1zYRWOabVu1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYMk6oiMuYOMExvrCQOSMiTouXsWvhB7yNj2zJvGLVQ=;
 b=cNyg+30jETQM8IkR3NxIeFcPybVrpwJILoxTDli5OoDHuliE4ngUoBdbJgYa0f+e/mqiIhhgFFvGmfZNQ6H3ubaZRbxJQhyVBPnCmxyLWJ6J0eNww5jC7Cfwyf8Q4Emrn/OiB2xZ41QGYYVXTOWqkfrMBwl1HmTl5NbGd7R27O9JfO3RkULxyXNKMs4mdz6gI0SoRnMAMU7KLd5usta2AaQECM1uhzgKmW686VUUSj0arvn7blZ/aX2cUCBjDCq63wr2c8k1/CiJ3/O7w9VviuxgMOvsMp3/+qDEUQWvcUJSNXo60MJ15cifoK3rE+23N9tKDE+umSLW+41UaUDh4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYMk6oiMuYOMExvrCQOSMiTouXsWvhB7yNj2zJvGLVQ=;
 b=Gj76EDale+HJXkYW5VbUrsH6bis8tD5l2XtUr5NhEAveHPkVXjD8D4XWCbqKdkO8VhFe6TtyFp+dD/y5bh7ji5WtNh1th7nLk0U9p0Llp645DnmPFF8mgwVgA9tU51iD4sq0E7cwmbP62mzZClDQMqPCguOsCSnmyzJJ5lHeTJE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4099.namprd13.prod.outlook.com (2603:10b6:5:2a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Thu, 11 May
 2023 13:33:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 13:33:52 +0000
Date: Thu, 11 May 2023 15:33:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Cc: netdev@vger.kernel.org, linux-net-drivers@amd.com, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Subject: Re: [PATCH net] sfc: disable RXFCS and RXALL features by default
Message-ID: <ZFzuud+3c1Le+c79@corigine.com>
References: <20230511094333.38645-1-pieter.jansen-van-vuuren@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511094333.38645-1-pieter.jansen-van-vuuren@amd.com>
X-ClientProxiedBy: AS4P192CA0030.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4099:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b9f1a57-d99f-4ae3-3178-08db52245c07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	R+zAxxm7yoJuLpB8xzgHP1NK1OYWo9O+GPd6rBc7arBZc15zip2Vxv5EQ5AGL4kY4uvUHU0q23g6Y1JH0cHHDpRHKfl2hB905hURp6RBorSJfvQsRjXfowrPjgxxApw8CjdgmXIzWhyangmUBLGfWP/iYOCHaiWJvvQY1Li3OOq27aC4mCqEZf4k0XaSAgqKOapCDvHcnOjAmItpECEu8Hcxerhp2ucY21bU4HiDIoaTksjbYjEzbYvW7JYBeJ21AmAKFlgdvrjI0xqcqwrDrhgBHQJ2ezEk/4Dlpa3HWxVYoYneyBUSxyUHs9Sd4x0bPh6BUVVYDa/fj4Jb2LOKmDeX0WEs5z5bJlbvsKZ6Scoig0AUkObAbAaTfOq0bbL0JO/0/AAwqJBhx8tGh1bsPMFOhKnV7mwnkHFd/9wgQ7NvRctH3UYBtmLg9froa/Eou1ox0/YryPiC+r/wL/sXj+8ImLytwGZUYiLmYWxc+Y1o8Zvs1+t/SWr06c7IvHs+KLVTkZ262V3fGTCjMY0MbDRNbauThG48AKhvsBcOtLfcEJuPXGzV4OEoOjpr7gCY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39840400004)(136003)(366004)(376002)(451199021)(6666004)(6486002)(6512007)(36756003)(2616005)(186003)(6506007)(86362001)(38100700002)(6916009)(66946007)(66556008)(66476007)(2906002)(4744005)(4326008)(44832011)(8936002)(8676002)(316002)(5660300002)(41300700001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cDux++KYC1sH2AKixe6RBEQu8SxQqybiWWpyasEJT6fzJJ0VqE4eYd5xsiU+?=
 =?us-ascii?Q?HjLuzmtYJaOtK2IXbEUkU20+dSgfStH+ITcuUKaDPMsKCucvfHQxXUkiNOYv?=
 =?us-ascii?Q?te62hc7iygfUaVtDAxBvwFnkzJ8d/J66rjgoH4JJZgC+N+d1qaIx+na+L4t5?=
 =?us-ascii?Q?LxKme/mfaPc+iE6y7JTP7DxRJH4Sd4nEN0D0wEkCHk5kclY++h6x/3B2To+c?=
 =?us-ascii?Q?t2U5bV4Vh5OfCKsf4bVJ68MTbjYhqqZShZ3eFRXZ09HDP4gtuKB9seKpzgfI?=
 =?us-ascii?Q?JfkIWn3WSQ5vYLjVggpDb6uRmbz+vy14b6XTBqFCrrmrj0s+tpwwpZLtSjGH?=
 =?us-ascii?Q?b8E5jvTcg8O+U0P/EM8onVr0T+WPU8Kd3jDyi4r1FlEM9mytWu0zxu1zSJi/?=
 =?us-ascii?Q?YJ+DheHgT+5nEoH7Hookfw4cNw9OUBiOdn4xX6VEus4xEGO9RIMhKE8Hmsdp?=
 =?us-ascii?Q?/vMxjbuc0pOIU+mYcejCulYSb9dIT2ZT8ccAJq6V8gPnrtzRlOZ1Et3DYU5z?=
 =?us-ascii?Q?RemQAwPo1xVMb18pLDgubpEKrrdp1Q8eTdw7T5dnOJmKXPiaGFKvaYRpJE0+?=
 =?us-ascii?Q?GzYz2O2XxeUn2eGEVESjGYKHsJWv02l6cOVg1L6WHO915Q9zrK70qD4cZSCD?=
 =?us-ascii?Q?eqI3/nMISdWFP5j/FXBuE+zi6L16V+3a8rofjbrD4MC893au2UgYi+ogsGvk?=
 =?us-ascii?Q?jGh/hqMeN9PQCKDjWUlbh/uMwTz5J2djGB39KBiOFRdD67bQptlR6RZzypwy?=
 =?us-ascii?Q?auNnIUxpsCDulTOwTDS+Q73yXQJ6QvlJztqK4Pml5SaLMJkFkXxk17GPLqhl?=
 =?us-ascii?Q?bMLWU1qi9FeNvGqZUtvJH0eCDH2sRsIiV8Q232tZ3zm1UzdjA+MCFLMdgkBK?=
 =?us-ascii?Q?W6bIJf08VJ9zXzAKTHqktIzr3Dp1MhBq9AdmMMJIn0FZ2d0c3XzdPIE7kexW?=
 =?us-ascii?Q?iy2cpBARjG/h+OClb2MYQCSdX+V7Ie7Qvbauk2qbnYDjDWLUnt0tLOi9cJ61?=
 =?us-ascii?Q?z0GpscaOI8/8bnkt0HdnwPe6ZlamF7gVWEWViWzutEBzhqQp3intRGwRjQY7?=
 =?us-ascii?Q?/A+rMhgHFeK4k1XJXHsNsX49ZeoQUG/OSkq5AehR3aWbUyxGjHJuD/Pc5fFN?=
 =?us-ascii?Q?gzasuaeXhAY58Y8AFOi74A+kYGdPacge2ogDGyUaqTNVqsN7ESCoBSYy7Gwb?=
 =?us-ascii?Q?wumTXFa/q7enDVXr/4fkcMGexXx81fXExNuoskEpxmlwzGnQK0wmUgxRu1jy?=
 =?us-ascii?Q?1k+9qjgGGQKy0cJduRflHKrKWOakACNR6U2n1QalcETRx3wKY5gaOJ7E9DmV?=
 =?us-ascii?Q?YzzBqZ3Jp6tBbpWwknGqvPFbu3Ps9vLwIexC4ChUchnc6I4VgMoOmALXsTbK?=
 =?us-ascii?Q?S+D1xUmvVbMCp/rzel0xZLTkTElVEnqOGFAJ7QVk9wfdjnnEbXVZgFZbVgim?=
 =?us-ascii?Q?1Qa4hQWATzqaEORBXZFwkl2bu9DnuxhFLXe42Dk3lxcE/Dlu8GWE++JB8USl?=
 =?us-ascii?Q?q0LHmIsOhaPY7vK/727dlgb6n1dpvH8gq922GEBHgRslkkrRXUWXMUTpQRyM?=
 =?us-ascii?Q?m4Ox7RKRqwUw4X8yuHIAkL/oBpe9ufV4/Nx54Fy11GqLm+MIfrYHOjuM13G4?=
 =?us-ascii?Q?P352TvC/LLKzRWjxrYtp9He6sQM2AhRtUXiEIMuIFhtD3wbKxHbnYTYwHdMb?=
 =?us-ascii?Q?Voythg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9f1a57-d99f-4ae3-3178-08db52245c07
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 13:33:52.1197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9eRJHj4RTeU9rNqaIzrBhOezNAIqvVXYiF4cfEkbMb+b+3n+pDB6pKfTVgn8rSMSiAIKUJ+S9UZlXcI2dfdNXQfzeXVmzT6aCdAynEa0gKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4099
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 10:43:33AM +0100, Pieter Jansen van Vuuren wrote:
> By default we would not want RXFCS and RXALL features enabled as they are
> mainly intended for debugging purposes. This does not stop users from
> enabling them later on as needed.
> 
> Fixes: 8e57daf70671 ("sfc_ef100: RX path for EF100")
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Co-developed-by: Edward Cree <ecree.xilinx@gmail.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>

Thanks Pieter,

looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


