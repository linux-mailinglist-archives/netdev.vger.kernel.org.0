Return-Path: <netdev+bounces-2229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D898700D67
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4D1F281CB6
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E432FA32;
	Fri, 12 May 2023 16:52:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A64200AC
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 16:52:59 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796BC1736
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:52:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hm8MPSKbzGKLlWhxJYOqmUK/x1y0SHXmSq5FKXM2tvzKZNOxVHvNwnob4dDEFtjbmKJg/oyhuec0DQegcPFOsTX3KroHJ99jgulOrFw4v4Om0NZ88My8w9/mKZH23vd3UzySu4mxYZ8plM40h9XX3JLBm6QRUWNaFlmzjxnp5M4BmE0UZJmVh2y0FkbpSYDsybRDcsp7bdAIyEiXiQpClc9+NwvACSQtX64rYNAeNGzh0cgEe9ha7iB1Xt+xDheDpI40K+Wb3bRsnCSbqgGwX58E9YsIhM0Fw7+XAZ6UqwTyL5ZibrcjZEt/Wxb+CmJtDpwJKL4cADWm27UOwvDH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S188ExI1DSXAEatCAbaDzL721+Ymb4qiHnHgMvyL7Mg=;
 b=JhFJaBUC8YxJBA43Q4jSqPrlp6Cpj7Rx96zarrFEUfQKZO1nkXZVfS7ExCym7r7QKFrx7ZBdbvwPk2uPvR9Q1B2oJzsLx9UHR9aTcpTvY9hVCJKtzNQ5me1H7gVCSbTme5hEXSBHd3k1Mg6hXsZKhbkhMlmjMtgXOhVvurYLlWawYySYLNDKdauZsBueSTYkL3xmPqRwA0OtyWANr+pOfaV3PPNdF+fZMvo4kgCltX3Xt1CbMUk7IBvakIvwBwncudpT//chGq92MvEbmRM2GLel7II4tTLB2WCkLjukXsqZWWKoaDMIBACwAlByXMkP9S3u52ybz+u6H/9PI3fQvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S188ExI1DSXAEatCAbaDzL721+Ymb4qiHnHgMvyL7Mg=;
 b=NLYNULhJlPzDInorDPwD922E3dyir5DDslN9fX5xKPSghNo7YYmcadQE3/3+EWa/62rF7hxvzHCumztxtXwDw83uXBm3k4FF1yfvmjEeMNpG0u+xJWwIP0zj9RkIpmot/+3l2o4Imy8r7OVyx6WFOBCs8JitAsVuHXL4YDj0oT8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH8PR13MB6289.namprd13.prod.outlook.com (2603:10b6:510:254::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Fri, 12 May
 2023 16:52:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 16:52:51 +0000
Date: Fri, 12 May 2023 18:52:44 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net,
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, William Tu <u9012063@gmail.com>,
	Kevin Traynor <ktraynor@redhat.com>
Subject: Re: [PATCH net] erspan: get the proto with the md version for
 collect_md
Message-ID: <ZF5u3INWj6gQswjX@corigine.com>
References: <e995c2a2b885e11d744e9c2743032d16e4fe9baa.1683847331.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e995c2a2b885e11d744e9c2743032d16e4fe9baa.1683847331.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM0PR02CA0116.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH8PR13MB6289:EE_
X-MS-Office365-Filtering-Correlation-Id: 54272970-fd9e-4b6c-57b3-08db530952cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Z1sCMUBHekRj3L0pAQkHOwzIhA5Q9I1qcI2NRPb97vcnphSzaqqqAFL11qFLDEWCBcCMCd7NEkGLZL+X/EtLp0sEKURuoNup5NLk4H8c+kcK16I4TbcPjWbYdv0mQXLHXiXZ983VxYacSURATEHKhsaykwxd4lbkNV737LmaenYcgmmLFyFVejdQWPkE54SUWWGdLaKbE52XhhkT+4+q5IyI8OEduj6tp12OkG0itEfps4T5H4zkxHsdKlf/jOTpObP92knuTsa/TL6xsE1IOs8B/0HUonaQlIh9a9ttpxnK6q6YQwbvKCR4BW6n4bLs5RS3CnWGira0J0BwhugAZcZRteqg0HaQKL6qGk5Nt2/Q6FRoqoGa2Y7fEtBGnDVTFsSd/eUN1dZtgQQ/xx1Vw2HdLGlRV+8AYjdRVydouGWBqV4tns797peMfbQehkYe571xBwf6hQ/K9F+qSlbBHdo3uku8kiVGHlSz/Cr8xjMiAR0eUvQ+JUXTdfG1vdTiO9b3muUkFX7HrDvv5bExHgfaX4hRWhOn0M5cGKbS2mXv73hQvukdS9FRFnLBoRctkFYbli//okgRyNT9VDoaFofWsngGcxr1K/3JAljkV+1T7/VsmGPCurgrw69aWoXnOIQI8kZLQpzqv9eE+N6wPOfCJ3V7OCXa1XLJbLBQ/Ao=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(376002)(39840400004)(396003)(451199021)(4744005)(2906002)(316002)(4326008)(6916009)(8936002)(5660300002)(2616005)(8676002)(86362001)(66946007)(44832011)(36756003)(41300700001)(478600001)(66556008)(66476007)(6666004)(6486002)(38100700002)(54906003)(6506007)(186003)(6512007)(15583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cVUAmbWYURzDYrtK7E/UWZcvDdiX3FEKxSsVkOqAcl0f6l1fqkkfxWvX2jkU?=
 =?us-ascii?Q?/JuWF0ys0/7Trrbme8ul7b2xZCsTCXnSfeXSdwvXYm08SdCHRYL2f1PtgiWY?=
 =?us-ascii?Q?qVkCocxzapx1bTmqCmXJjbZLeLPmMrL53xcBxiJUg6GBDA1eeJ/fq9LSlnbj?=
 =?us-ascii?Q?Z+D0etJg6hv2IoTcA7IBQDSW/jf54HAG+wdTopnY5+Nf42z4+DsGQXuPrhJy?=
 =?us-ascii?Q?Y6+HPzf4G8Yr1WSV29BU+U9sUIqNSLoJV6a/BS3VkTK5oxx8krfXx+aXlIV4?=
 =?us-ascii?Q?IlDlRFvqCCh/1CisfuDnXynJGiosP2qMVV/AcAidxickb2RKXt4faJtl6FtF?=
 =?us-ascii?Q?v7JGAWvoJXsW9hryxhSfpuJ3LPDtDULTI5kwRGL+i3Cr6MP4CfJTNsAfQUVr?=
 =?us-ascii?Q?HpBcjdDpgMBiGrUJzvyessWZaVFelV38GYNDayW64lUoTQuVNejH1SValDs5?=
 =?us-ascii?Q?pqjB9i5UFx0R0MDBlJ3sBT4vsge4m3nepRAiEVCwwDP3hE60ImLG4s2/OT0d?=
 =?us-ascii?Q?K/lMhxHSCcW87vpSj+imGoadh60wxSSIQWTnJjzpCtjlJYlXbdVeVYwmFXbY?=
 =?us-ascii?Q?RVWzef4ammEk3CuiAe6w1l+nuwva+16LHkSunXaxsZGk0WyjhAT8tT5WUKyv?=
 =?us-ascii?Q?2cc2EH5lR96l9x89T0xFxVYq5bqCtDJstisK+YfwgYGoVJclk4mCynwO+zlo?=
 =?us-ascii?Q?17NA9zevHn2sw/yc5vLeWy0Qfjxo4PKP0xMVuBAuM06m4Eoz0DVEtkHS6P/q?=
 =?us-ascii?Q?zb3K7sfDz7LgQqHuj6L4ICDxo+3Jpj4nV1qsOgW+0rUZmyrlG7r7cz73yz/6?=
 =?us-ascii?Q?aIZ9WlS11bl6zw+vyO3zUVtYCOmW9VL5Cl/Pu7iL/uhkI3UqnAlBBgSonaun?=
 =?us-ascii?Q?Hgy/lF71b6fu6x2WSXUIwYwT5zkZx913GGcbfyEiCvrqJgsgW02Xzcioj08O?=
 =?us-ascii?Q?7aW9H0QYZx5NrxFlt1dNcdktuw87zgEA7KOig3XeqLkF5DTrG7gAR5CSIRYS?=
 =?us-ascii?Q?Y8oqQCpbQ5BxnydHFbNM0tyd9vlXdUmGiV0W1VkaRfXmlL7SsL9jqqCDrPSO?=
 =?us-ascii?Q?MDkf0yXM3XC0U3wYp3sbZGzyOP0UA3YGkeYz1bi3xzPzzxT0d0KPZnUbEshy?=
 =?us-ascii?Q?jkFIj1wuzBGuuGr1IpxfbAaPsp1+RlZ5iwoQaxzuSrjtOFYw03vTJDz4Fpsd?=
 =?us-ascii?Q?7XbFsGvT5tF/COMmiUWjceDnA3FJwXKR89MgokrN1T25fCXb9VmCamHm1WIR?=
 =?us-ascii?Q?akT/VtcCrnygjxRm3823Q4Fa0im8YSIp23NMPZVnj1F/bFrkdeCILPko/c6a?=
 =?us-ascii?Q?WrodibyMJcVVv5vSeeCTU45KhOCBnOUoNxKzoivWX+rReCjYfiXIs5OrVw+G?=
 =?us-ascii?Q?sh9mnXQhDI2Z8wpSsyxR2KwohnfZZKxbtEROSWfWrzovFXyiySNaL7eEdJ7d?=
 =?us-ascii?Q?76UAMo/JT7jN0ssWOi1r5CdFQ0fGOFubzVT/4dJF1bvuPG3xHbVUvfKWZzDG?=
 =?us-ascii?Q?l7NAbJ4DHjSJuwf/Cf8IroqBFpaxOEtHnpTLKvIJxyc15VkANRxD8PnNCs7E?=
 =?us-ascii?Q?juQ74ryJpyPLv7eYRs0j6jGPYD9c1WvAxQyp6KpsxO/nwz8QqQndL5Vc/NBK?=
 =?us-ascii?Q?hiMFkwnOfLl/NsT9idR6UMruYUFtc9v0qh2xMaezYmC5x5fqLWhqiR7TDRSw?=
 =?us-ascii?Q?V44vmw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54272970-fd9e-4b6c-57b3-08db530952cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 16:52:51.4849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +utIAGfPkdninqEGJQ1Thy0G4dFS14afkoJSQfgi8WahbCduIoBa4Fp8uu4iqHys0TKadAlzvpOg/ICarcXerawTfTgHeB773r+qnFJfvSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6289
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 07:22:11PM -0400, Xin Long wrote:
> In commit 20704bd1633d ("erspan: build the header with the right proto
> according to erspan_ver"), it gets the proto with t->parms.erspan_ver,
> but t->parms.erspan_ver is not used by collect_md branch, and instead
> it should get the proto with md->version for collect_md.
> 
> Thanks to Kevin for pointing this out.
> 
> Fixes: 94d7d8f29287 ("ip6_gre: add erspan v2 support")

Hi Xin,

In a way this fixes the following commit which in turn fixes the above
commit.

Fixes: 20704bd1633d ("erspan: build the header with the right proto according to erspan_ver")

> Reported-by: Kevin Traynor <ktraynor@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


