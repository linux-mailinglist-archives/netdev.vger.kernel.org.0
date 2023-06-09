Return-Path: <netdev+bounces-9682-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F77972A2D3
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEE21281A29
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746D4408FF;
	Fri,  9 Jun 2023 19:06:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EEF408D9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:06:41 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2118.outbound.protection.outlook.com [40.107.243.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BD035B3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:06:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/ieKIklVe2KbAnEcKd+lrnKrRKX6+XoYHC42GYmrS3lYq2UeNhlJq0JJXL8pwVePfL2vAhovMi/IALXAJfFU2vLC6VzV3kgedi1Nc+bONilKfSv0qfFKb7x8Yrap26OaGqsljthUUNTCgBE2Hx/265rVF32+zcxTBoFynt7AzIYGxUKhjDUrPseRJQrczzlfm27B6uRDkhT31wqO9HzhzL+Gr2NiUON5BLl0/f3gsglG14CuDj2tMsuWttIgV81yxP1K0IJQPZmaQNt6M4hm7EdeA3TtxyhYorB+IeyEBADChcPQ2u7nLHazk9vfgvuIE1vbWk6XI4sXabaAigskA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDnOHIhr25xOetZKnwT8M5+EHMTxs4dRNa52R7rG538=;
 b=oW5Wik6DseKVEAt/38n+t6IH8iMGdMD1Lv/Mo+MyBYvl2iqq8FkQFQ41RE1NhuinTkt5sisDjalRXqV7Ea+i0IwbDe5an5NTix/+be7kQDvfeFNCV4pcuCWl7J8qmX5sBliBU05g171K0Cf25j/YBF3H3QtH5t8+Pdr5627BegltSPqgnDZSs7cfO+bilNAaddD3ahTD4s4AKTZxx877okbPXD9qfR7gnyjT2lGNr5UnJSrALpzm9B+04eTKQmp58HzFvh9TbD4iqD6fEtaYRKrGIevuP9ZpMCwozll2AEm8UhWW/P45/vtQtCOOun/JCiqBRlURd3G0mgO1WXsxmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDnOHIhr25xOetZKnwT8M5+EHMTxs4dRNa52R7rG538=;
 b=F8AN10dOVU65zzRCwynVaI8iS6KHKp3rb2jWGJkq7Qrzg42g1d+DY/e9GeRsD0xkRgmxcuXlBCB4mOtsoN9USkaZGpugbATcXrl9yMN9PHTBugKAySG60Sg47DBFinaXlp5ABqpNS8HagZ3O9R9tTWTtCg9UIBBJMZaSESDwzRw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6336.namprd13.prod.outlook.com (2603:10b6:408:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.17; Fri, 9 Jun
 2023 19:06:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 19:06:38 +0000
Date: Fri, 9 Jun 2023 21:06:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Petr Machata <petrm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 6/8] mlxsw: Convert RIF-has-netdevice queries to
 a dedicated helper
Message-ID: <ZIN4OJC7X05oXvBq@corigine.com>
References: <cover.1686330238.git.petrm@nvidia.com>
 <90b883793c1a724483b483009a107449ea76c6d7.1686330239.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90b883793c1a724483b483009a107449ea76c6d7.1686330239.git.petrm@nvidia.com>
X-ClientProxiedBy: AM4PR0202CA0018.eurprd02.prod.outlook.com
 (2603:10a6:200:89::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e150678-0dcd-4ec2-94aa-08db691ca6e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YlB2Ki7g3ROvZo75mZN6jb7JAff9IvPgTK227gkh2u+gjrL9DPn3XeaipNbkFNidO7N7x4sPgOtS4VFiHerrcxCmme14HWmihWPR+YS1bYBl0budAcHWLMA3KJ5U765g1UpQgcWhqtP3VxhaDVe0cLjNG7hjdlYvKUeJYM/KX52Sv48qrDhu+a7gWwjCutHsv7cJTrXApH1dj2tg0S56E6kIlLrnvpGSTDfJ/tVwgQLJJGTI29S1uz+AiSg6Qp8j+YzKFBLE8aE8kKYjgY4yrN0xCK5zhZSnKLhcmUm+24UJ7QJZWubAedCWWiAcCQI9vTmDLyT+LKPzi5fFvqfr/E6k/rk+EVi/1HWvql+qAHH5Xe88ATtBtIdEIstX+E45csuDRWYZMt831ZkK8CvrkM+4e4iwf4rBFOO9prm/YcKvIsruxy9NS0FazfRQB5bOKbC2SyzEC/vbv8ZDRyvlsJ0pI7/ChVvo06EIf4qFjl1Az7GAxhzfztvtQvKuJjgoU0AzYAirB0J6kaOjienKzZ1For5ljMJye6CfVmmex3GCu1fnGvZqZflbghfQCKec
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(366004)(376002)(396003)(451199021)(66574015)(83380400001)(2906002)(4744005)(8676002)(8936002)(5660300002)(6486002)(316002)(41300700001)(44832011)(86362001)(6666004)(478600001)(66946007)(66556008)(66476007)(38100700002)(4326008)(6916009)(54906003)(2616005)(6506007)(6512007)(36756003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?myssEJTmvuK7XSiaXRGAN8PpB0MVIdjNKN5DsnTlblIR44GFreZnYH2vPi0o?=
 =?us-ascii?Q?RDb2nzIyiXSdnQN62nnINdo0k88JPPtxaeMMIp0faNePEEntlPwVKRKwfkKw?=
 =?us-ascii?Q?PpN5+xLOgXTG7oBrNnzUmjwk7Tt24SrPvftB1j2uv9KW2BxCxjlUiZyZFnyn?=
 =?us-ascii?Q?UKJ2fBQAMeQlddUoS6nu/e8M2NzbXkA+0HnVRHXCKt/wohk/p77dW7qROuPb?=
 =?us-ascii?Q?569Zq6PGo+I0sFXwX3Ri23HZC7SX/1tQTEjxPLQtGw/6EJKNMYbKqnGaiIoE?=
 =?us-ascii?Q?nuZLwRFq/hLohtGxK7OvKOZZvYTDzKWab0C6RcMONLt6/fNYrYK9Xzd3mxq8?=
 =?us-ascii?Q?eikUnamk5NyTNg8o4qTk0I0w62GS5Py93yMtxM8dtA4eJs8HYSDmeSwMQ+r3?=
 =?us-ascii?Q?E5MxAPe1OpJhSErhX1fdtZYeCOfoXtT89SNr2rI4FC89XSaI2ji6gS8Xz2pY?=
 =?us-ascii?Q?JmjNVzUoBdVWMocnIgz85oaz+rRDiqTo9xXw2fuEe513QTShcn2mqI5LUsHk?=
 =?us-ascii?Q?p0+zdKdrLy8u8wHzF8CGb36+JHENvS3gIekt6RKf4LXauhjnZdWDKmIdkeZM?=
 =?us-ascii?Q?Uc4jHA4ZWBip70C6MegaB/Hnn7c8tXOTwIvX8j/pfbmWcvQeb1bzz1iB107l?=
 =?us-ascii?Q?ZUlWl7JSY/xCM8xkPoNGAqH9jgYiaAmorL4Mbm7QKpDkUw8AkL7TcX6g0thO?=
 =?us-ascii?Q?qBdr841lNkNrLye88xQWqDerSuQzuZw0oD//teC2MFoY5KzRts1EbTZFqmNw?=
 =?us-ascii?Q?Hf/bv3sdFfx/7R8KfX7/G7pPhKx3UujNHwAEiiHY/MJISNUH3klThqDRejTt?=
 =?us-ascii?Q?7Ufw1bOKsCOYeQtuHErNggYC4UTACuxQOmFpvF9NRpsStO76Y+rL9EwL2EQD?=
 =?us-ascii?Q?LqgXyHWqtQE0vnMmt1F7OgIjy6kGEccw88T7UR3C3JTyq723wV+TT5OmkpS6?=
 =?us-ascii?Q?f8bK2nxtKRiz6t0C+UzU5xrA98gleALUZLa24soFQ5VzGeFrAp5uslQByIyw?=
 =?us-ascii?Q?kIWSzb2Zof5S+B5RYJi681tJKi5qhGvj2njIpw+Sz10DL381uJ8xFCIq1BUd?=
 =?us-ascii?Q?6xlvLpHaXe6GfFIEoj6cvd9rP5qC1MnCYjYTahHHgpzQHDZbYHpLXwiwFVaY?=
 =?us-ascii?Q?nPnZhzHH1DXKizS1CTNV/3JfRHMP0U03KDgaDWBHUSJd42EPvfplpoegpBip?=
 =?us-ascii?Q?UyM8wa124Bb4WwcHZvnjATDLOVkiPnTfGZPfV2XDCW19okQN5yrWLZldgvhA?=
 =?us-ascii?Q?Xn+jnz/rp8sF3msoaFEzPDKWuplkTwJxKqtvQS3YKfE+Lo8Zjm061VDOXSns?=
 =?us-ascii?Q?tUTHEb3E23nt/D/ihM4rwH2xoBtug1Bu3tMtSZv5a3nWSHSUUp4rjHd91Lno?=
 =?us-ascii?Q?NvQsFKRgrcpb9tyDPNJaTmBLXtmGUOoZO9RykNK3vlnrAygJE3BiAuJnj5qR?=
 =?us-ascii?Q?CdPvmNPSGJP+FbH5F9s82k5Zu5PA1SxYlkNbnnOYW28rEwvmP8KpP06fgXVR?=
 =?us-ascii?Q?5LN7mLpmNwx+sjDV3hUOXapyliEcwJsTv+gRZ6ANCkmqWBWy/PzY6tdm3Hdo?=
 =?us-ascii?Q?lnSmyQBHGL2PifecTU5PtbYxAlUWq+R11ZVbNga/OHUXza9WgPQYdCnU6HYg?=
 =?us-ascii?Q?kM6nJDCBgflV0dySVnv2f44iEKbu1Opl6tWEwNUN64QWbbn43wWrXMvMV/bI?=
 =?us-ascii?Q?AbDaQQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e150678-0dcd-4ec2-94aa-08db691ca6e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 19:06:38.5041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cGXzluQpf2bTL1CaA6xDaNENZvvw715US/7oL3VxRa0JERAARhBSawXpSBRwVH+J9cYk/00QGqOMHHApUOFMsHHH4x8uAPR5iMj4a7Mwm1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6336
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 07:32:11PM +0200, Petr Machata wrote:
> In a number of places, a netdevice underlying a RIF is obtained only to
> check if it a NULL pointer. In order to clean up the interface between the
> router and the other modules, add a new helper to specifically answer this
> question, and convert the relevant uses to this new interface.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


