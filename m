Return-Path: <netdev+bounces-3259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA14706423
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:29:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 446BC2812BD
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DF511197;
	Wed, 17 May 2023 09:29:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0975249
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:29:00 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2110.outbound.protection.outlook.com [40.107.94.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AB630FE;
	Wed, 17 May 2023 02:28:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i48Q952h9k5WG2+FcOyu8cuF8NviHJFL8RGjzKro5I5m/QKJOLNnWBcGL7wTumkRVIctfu/K9hY9QSjdaEvPbssttjIKxHhaEZMXl4fx7mvSUXguK2/48ofhB6eUi4pzwRNEdGCucMza16MziqCIcOJo5P6sfs8uONVnRT2zsmBIRZOTYlKYMpriLAVTp5ga9dlexFXcGUklffZO3IuOvMHqS9UH7OlNcYxep2NwJCXryBpjCryO6GswyJCSNcUC4YLErKihI0maYZE+z5q8D1JH9fHw9AgSNLUCxJZoyBiu0wI4aEDxcbjlJ7VaI9Mlda0aG+kGd8wv8h9dd3nNbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gh4XPGm66tD7ZIIspUuORvS39+l8AI6hAbeyzH3UxPo=;
 b=lfM2eI/L3xUsdfdtFjkKghknibf8iYJ9yn8mtB25bZu9Rgjo1i5Uhr8HIMPM58a3Nad8QjY1Lxt8EyM8TFnLvc2VY4O2tCAv5TbXuUer996ifSZ3UK1cmLCN1hJMChH4T2WM+JYk/ghq1eXmdd620eRxXrH5SFjlArz/IBQx+oFlI6jg0f+ADouwYPT1N7VTCNpgcbXcUQhhY/1LGNAJyCDuNHwp2IJwxbEutqOdvwHIEIl23li0+j4150lJMZXq8a0sFbjugZJACXSpC0m3MBqAUc5Vpj3FTLQwf8WQR3DZeS1DeEwCo1WHbkCWfmH7uFbunYPqUaHEAXfeOBLqNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh4XPGm66tD7ZIIspUuORvS39+l8AI6hAbeyzH3UxPo=;
 b=D80eMJ6YkESIeM4xQCkEpzynepGIw72hC1ASePb2KpujlNKuBWNvh/zK6tcuQh9tlUQY5di50r/yEUJHxaPapRsCZqO3XHrH6BxhhHPRDYckk0unII1gE5jUNaBtT4Ts7v5gSAdqlVtTcDdbcPxlpz2BHQebnal2CPmHCKtO/9k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6359.namprd13.prod.outlook.com (2603:10b6:408:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 09:28:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 09:28:48 +0000
Date: Wed, 17 May 2023 11:28:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Baozhu Ni <nibaozhu@yeah.net>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Outreachy <outreachy@lists.linux.dev>
Subject: Re: [PATCH v2 net-next] e1000e: Add @adapter description to kdoc
Message-ID: <ZGSeSTCB4lrJEUtR@corigine.com>
References: <20230517012726.GA1785@john-VirtualBox>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517012726.GA1785@john-VirtualBox>
X-ClientProxiedBy: AS4P195CA0024.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6359:EE_
X-MS-Office365-Filtering-Correlation-Id: c08f2495-7fd8-4a44-8676-08db56b91e50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jS0xswiiJKfnRiJ164ayWUehPQIM1QvG/tOsJf/lmeoB4ZfDHcM6bXR9qG/tSBQ5XnR8nHkc83POyZ4FH6ujI9o8PLjUQPwESPNwQ87ECRjQAIPK+YE7+kJCoaM/SWXL0HID+cUKjlzvIqXi7fqagVmk2RSssJrk6P6PQrKnZ4f2okBDMV4NQOCY/TodZLJOU4wEhh7IQK7sMqGQ8shOLE3aZWlPatxcrWtUqYHoShjj6L9zOX90n+rC0LiU8VZdu98kTXWlDIv/1Kq93+y5TIjYHHP9lhe223QgIR4BqC1yXcRmXxxlyJitXAYn6SlyXPRD1EIovBqCB7vlpGWbOip3ILTes9Z35gNsILCb06BCLMMWQkd+6MV2olq/+XSRyD+L8G1xUAYyvBkkkDZPC44X1RNjmoZm2lC3q+SE36FCkzaVkWQ0n42/gEnSlegtTvMEvI2g2SppRIb0aNM3oECTOPV6RB5jPHcLiQ7UrEk0qWLBQAKbD4ZuntaicjqqsWuZ5fMwySOStU7f1sZ3K2++i6fap5owQVSd0/HJOEM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39840400004)(376002)(346002)(451199021)(86362001)(36756003)(54906003)(66946007)(66556008)(66476007)(6916009)(4326008)(316002)(966005)(478600001)(6486002)(6666004)(8936002)(8676002)(5660300002)(41300700001)(4744005)(2906002)(7416002)(44832011)(38100700002)(2616005)(6506007)(6512007)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JX7U2CZPOG+gv6fr8KX5EH+b5IMCx4PwXDNvSAjA2b46b8hx7NDNPocCphnb?=
 =?us-ascii?Q?ycjv0r8KpyuMHafsZHLPgTCCDG3L2sHaE2NHyhzW8Ql6QUICry1+8p9FF5m3?=
 =?us-ascii?Q?0jWc3WsIPcDHiZiahnncMBRVavVC3LshWvaWaw7Dc4fnNdJCokZE3RjR+zAz?=
 =?us-ascii?Q?3QHnmX7KHNhFydeuzZXL665qomdSfPO0oHztA18Ed3fi6bE+OSOCcjqmyQoM?=
 =?us-ascii?Q?LXweL0hu1nE0ZetyAWCX40fPy7sqVgqFioe1bOxP1Vc/5CZvBfTRFFyJCZC9?=
 =?us-ascii?Q?suNKeOCxD1VuTlEOzicZYKkyDVjBGzFaXXKmJkAn9cXw7g1kTtV22f/NsjDx?=
 =?us-ascii?Q?+QQC4qPISyAerd577sc/bFknarJAq+qeZ77tC/PKyH7gj+fBK7/EVvmcmAtE?=
 =?us-ascii?Q?fl5tFPbUVpD7vj1kKXLxjt0D0RfP558Zr2oILScmme7UrwpxRmjqUIdRGFvD?=
 =?us-ascii?Q?TYYOSNLJwsuZ7x/zVrqyYHPCLXiqUccq7MKgvlI0W/kyiLETgTc41Dr8JPII?=
 =?us-ascii?Q?oKarJ9e5lnVkYLmc+ZHRyFWUlTu/uHdEpIxSsxE0+E4sPS+Mf2alzAVQvAWG?=
 =?us-ascii?Q?OB9dAcibMXV3oIZSU7+s9Ep2AbnW3d6etXMTsrVs42SwTEWJwg+60PzEmK7E?=
 =?us-ascii?Q?qoCSK78HutC25bgjojjGkZCVlUU8Z9bc8d7yqL98IgXefs3P0DoYSQqV+/oq?=
 =?us-ascii?Q?2jojzh2AUlRFV6MJOlC64sCJaoVXzWiXNSzW3VHu3zU3PfkZjOnVyB6kbfFw?=
 =?us-ascii?Q?MQxYKpB++JwO4oZ0rdXSsyGbMIVtw2arQBEwgwfLbHiqyDN0nh54HvydCgu0?=
 =?us-ascii?Q?2XKkaM3jazRUH0fL4dr7ESBn9noOb8q+KbEAxSP+GhuJ3MeTywQB6ksg/nqc?=
 =?us-ascii?Q?QoaYsrKoofwWSzqFlwY5fYn6vY+LafzgcuDV4gj7PmXFwt2XuGI7w7mO1SeY?=
 =?us-ascii?Q?Xqgw0mSfqBs86JerJwRzQW+U1QfJ+LDl1GuWP1olEbdQv8BACxRsmmaW7jsT?=
 =?us-ascii?Q?JGLc91wjPcMR1YFsGvNQn3XJBS8C5vMO4XoB0uWK736eWci0RghkapJ6AvNk?=
 =?us-ascii?Q?0tRpF6vyUXkt70R2Zfm1tQ2FrrJcVE2+jGddsX1O0rCVKh/Yf/kWmFXLa873?=
 =?us-ascii?Q?aWW0YOPBp8CegXGss5fOUhwcXhgNDfUJ4MYpqgpmK5TCY3ucS21uy3J6OhxF?=
 =?us-ascii?Q?4oFSMmMCpQPNZ+8schfwJOOx1d4pB1IRAUCb5FbqATI7zNdV97w444d09az3?=
 =?us-ascii?Q?C95hsua2B9PiI+r+6EhV3aykl61We2NIhZdLSF65PPvz7svDkhcS4eGRIIAQ?=
 =?us-ascii?Q?ey21KcLjegpA6e26JLCa2T8eckC0CRnQfnNg5c+htjlqImjj/y1X79LrDzPO?=
 =?us-ascii?Q?nzYv6o+DY0PM/6tOA3ZkzxXnA2lotaDx/JXDVCJlWn4KyB5ZbVEDtmsh0vJy?=
 =?us-ascii?Q?DJuAjnXAXCjYziUp5sF6ywaF9DSSXc0nzOMfqiu3YubN3Z7a21VvsHQ/yW/E?=
 =?us-ascii?Q?Kkir5wqsEf05S7SdJlJiQmjWG7tqvRYnPFbjwQqkIf25q/GaXhnL0f9yr969?=
 =?us-ascii?Q?H1msxStTeQ4+bHwC65Lf3/QZ2OZLmWARNqNodp+2ZTyaDmcRmVjtDxs3ssAu?=
 =?us-ascii?Q?5i1H510jLqeydEd55wF8BbnxkejRs7VD5CD4/mBGwu2/c7GFQQKCtxBCGq4F?=
 =?us-ascii?Q?Cpnz8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08f2495-7fd8-4a44-8676-08db56b91e50
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 09:28:48.2591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3MtK/ShYvmYPK/h739YnTJgf0hBn72AeldSmkUMrqQI76Otxr8tSNj5QEiPQRiJ84uOmz0hxi84bDmrcL3L67eat8AN1dCY1I7cyeLQwB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6359
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 09:27:26AM +0800, Baozhu Ni wrote:
> Provide a description for the kernel doc of the @adapter
> of e1000e_trigger_lsc()
> 
> Signed-off-by: Baozhu Ni <nibaozhu@yeah.net>
> ---
> v2:
>   - let the subject and description clearer
> v1: https://lore.kernel.org/lkml/ZGNl8yHEko7LpCBr@corigine.com/

Thanks for the update.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


