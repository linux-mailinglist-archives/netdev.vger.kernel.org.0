Return-Path: <netdev+bounces-10683-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58CA372FC12
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B5A11C20C34
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488C26FD0;
	Wed, 14 Jun 2023 11:12:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B7E1FD3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:12:10 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2120.outbound.protection.outlook.com [40.107.223.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1781BC6
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 04:12:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VM/BM2YYYkQ5MhDKcg/Bv5tW3e6Iukl6pMtK+oqWKlX6TVsupPP4mRGbttH+iKSTQcgiKUJba42JpWYeH2FN+efmbi8ZDwt6CoPCzPCKXN/qx4TIWREepB+VOE1YTU2AWAwD6nA7TJmJDRprOl9ZrNp9c3AfKxwcZvIUyApE+babZ//bT9j44RW8EFCuPNqpf0OugivIe5YdPkYTXqIT8RvV2Se8YbnK0Nl+jwVInvxCKcm+ucOzCfEY0GGWasLvsHdaBtFYRvkJ8Fhc4jQhAO1qhS10IJ45O8vEK5svraLj+s/GuNXjA82shZustrJ5A+ur8oHai3QpE3UF2HPUvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faccXRNDU78ShMNEVfFfwKB9j4QXHoM5t4sjmaYOePQ=;
 b=WZFVnh1vlQV/rEq/y00BDhICGGSns4ztzhdoXCyPu1vhylzSzsQg9C6pU9CCIK445DAleE0cGBTN89O0/I8IpD0P/oUW6SltT3Zg2vZSRv4uAJ37pDWLru9/0kZKjzI2KxsfDn4BPA8mYEKVgNQrZ208egSpkYBUo4fEDo9YCmS+y93LRw47TKrXpcpUtEmZk9ayFka5rdeUjikW5k/nKrI00UJIW8KhL3s/CbGYCrFoZencIbCrY2FqerG5cjGcASXPlJMZom/4QDTpQPiCwb9kWY4JvpOo33dPYyizyLj400bKufS1UPHr3SkjT5vNzUH64gZstfA9oPl0wi8zbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faccXRNDU78ShMNEVfFfwKB9j4QXHoM5t4sjmaYOePQ=;
 b=EBc8+VhT6MBGVznZQpPEOr0h1gj5WhPxNUULXpmEmzO+7vW/dJgbs/lydSgt8iokQ6oMWXEMKR3tQaUcwM52r/vHTsWjkVmxKeIq1VXGkISHKCEag/PtzOtICyznpu1tolJnzGIsw8WWwhYydbjTpGdzy8qQTWnmjHpluCjS2/g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4937.namprd13.prod.outlook.com (2603:10b6:510:79::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 11:12:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 11:12:06 +0000
Date: Wed, 14 Jun 2023 13:12:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Dave Ertman <david.m.ertman@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, daniel.machon@microchip.com,
	netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH iwl-next v4 01/10] ice: Correctly initialize queue
 context values
Message-ID: <ZImggC0H91d/qUyg@corigine.com>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
 <20230609211626.621968-2-david.m.ertman@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609211626.621968-2-david.m.ertman@intel.com>
X-ClientProxiedBy: AS4P191CA0049.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: fe33c6c0-dea1-4031-70bc-08db6cc8305b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	g1u8tgQcDhLYHNMEdsKid003PtI65bEYSAXa9Q4JiO7GSo0kXQqQ2/KPil0v64XNR2z7FdljwO7pNi+Q6GXIe3ya0GDUMnDI17ypGKi0t4zAnA/YqKyfda54wAWsgSJ5B+M6x7qdjep51bV6lyQaAER8MMlttu/98i0+ImJCa/6ukrFwyRWDAIcK617dFDvE3FZh00ErB9huubXsqm/gGFd01kGONzWyXL+ASxGeJLQSZfKPLhzORGnFmXlsE76TevVDyzV1up4N/LX7qeR3lT3KCo8z+oweXSgYpXmHQibFWrt1joK/YzHk27M+xOLz/DU3Pyyg/pyD5+svwcGUU+ORX5kM+UDZMjC1Df2KA3SQ+G1XzxQDh6q2b3Qshgahd+KY3mJEk0GcXKkqNn0mOKJRltOfH5jVQ6Bzuzlo98voMYeaTbact8lbapyRZQOqcYcaDKxw7s3FQk1z2sOqbf50XZ/lrAmfThegVtnL2MUZpGO+h6Z4d2OKI+Qqu6h98kNKjB0hxLdzlTFPmmj4XjdXRduWDAu9HxXJQ91B5MA7ba21cRlk4ov/umABng/8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(396003)(366004)(346002)(376002)(136003)(451199021)(8936002)(6916009)(66476007)(4326008)(36756003)(66556008)(66946007)(38100700002)(316002)(41300700001)(6512007)(6666004)(6486002)(6506007)(478600001)(44832011)(86362001)(5660300002)(2906002)(8676002)(2616005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RvFwFSieOoLKhSK3ColFPsHPadI50l9aiYtEn29WGyn1+b+p03jcKKbNHXtF?=
 =?us-ascii?Q?YjloBHP6J7pMHcK2LtRso5JNAUjUN4QIUBIUNGBCsXpiXbgpy3aHbks3SFba?=
 =?us-ascii?Q?rWvbFYywRJqudZrzmTV8qNJ8LWT+Y+Yn5pDw23TY3apa4enyI4rIpv2B0YPD?=
 =?us-ascii?Q?ZuwTwaHB8UHk4wgIAtXdLffND4KgdC1gPz/mGN2UKl3uGiWyg8z8JvdDM/aM?=
 =?us-ascii?Q?IF8zYNzWKeixkDnvQvTGLrGHF9ECy9eHqQ/t4AdLOCueOhWdyTDWTyPtQqGR?=
 =?us-ascii?Q?GSb2WkHmUfiWuYLVjarzjhg4UFtdZKKDhtDYoJv0iG5ymIePcGyvSVwkOyS2?=
 =?us-ascii?Q?v0/a2EqKTFm/J6lI3OeB/LSZ5ddiGhQqXzxwGaAAgygDIS1ZUA8g1bAw7xui?=
 =?us-ascii?Q?UoipoPiK0AxPIyoGm8uHnyZu95FTdW8Drwq3CSqts8++4uiIpUAgLyYUG4kA?=
 =?us-ascii?Q?/L93qsYesa5Pkge/B70ZBqEd0f+xyLuNq4iLKxxEqI+EFf6cLGfvWmTjuobg?=
 =?us-ascii?Q?KiNNQOL9vl+dwqgH9e3mhJpp6+izW9yCf5eUr8Ve6tAYBCnRURxaebUztGZO?=
 =?us-ascii?Q?KXyWfzOF+USknPb1K1f4MaZmILQZiLQc8NydCHZDpPr3AC3MbchZG59R/beI?=
 =?us-ascii?Q?SCfR1vUtXvxj0iHo3D3KHZ4tn+wz8dBhrfLiXkbvkjEbmhOmIqpeGx1AuGSM?=
 =?us-ascii?Q?ZHgLCjcE56IPLDMVOJCZjx7ncVOUxkkROdSzmKPYKqS7eLTvnxWMX8M4LWqY?=
 =?us-ascii?Q?EJPKyGjB7mnau5wQ0Avxmwr4Q5PnGyk6sExWMTLwrWdMQG4+qWd5yLYNYsyV?=
 =?us-ascii?Q?7jjSJniocYgzJaEVTY//faEBwtq7NBHl1dlvqiZVL2H3YQFodAdxnUuXnuF6?=
 =?us-ascii?Q?TMJRPRaFMoX1A4Otg4z9EZJJ2ZJ6L36AMtgllelL8kd8DA+ZVNOugOo76ZDm?=
 =?us-ascii?Q?d79OBJp2N6V1OuDvHjd1WK3M1LjHPAJLRT0XuXDe4Jl+hBQ88Vu2GWaycM8c?=
 =?us-ascii?Q?PyiaK2FELNwiE46bkeob728pU46hw0Y2O5FIaTfcwyD/M170vgnePXnIOFJr?=
 =?us-ascii?Q?JlXhuup9ZmFrku9MC71fE7OKgFa298u/dFQyNOwreLS9/cwF4c7YantOGYfI?=
 =?us-ascii?Q?tYjfHTmSKQdvkgzlN3fH6c3K/ASdiAI+4ef5/YjWu7GvH5lmHUzgPHopK8+p?=
 =?us-ascii?Q?0HKwgmDDExQaXGA8+Rz/Y3WuEUvFAuf/3x2KhYUexMaPM9eRAw8k2tzzGTpE?=
 =?us-ascii?Q?6A5Ieepus8WiSzs90Tj7qJafQmIt13PipJqjRh84P8N6wIUZJXEijEsItGQu?=
 =?us-ascii?Q?uW8WJ3pQHOmNIYI8YcmFIromboIwkbXiqSjR3fN1Ot2jlbC+pX+M9yu/WMXz?=
 =?us-ascii?Q?xHdUWouXU16mY+/aHaK1V/MWrvGHMtZLTRncMvJqgpU1Wv8sDl7g78sDn7gD?=
 =?us-ascii?Q?q9XrSg+BMk2K4lPlKq/IdbdPq8GBAeLCG1kdC84X6JziwzW0wQ3bwoLbtMDc?=
 =?us-ascii?Q?bdVHUD2kHnmHFrRw946DSTktgLVeUlpONIDa4QVHsB9TecKPOcL388nlbEvU?=
 =?us-ascii?Q?JLUtgfj6HCVvwVWEQIq2vAbJs+2Ji1U7WIIvQOVLTf0vs/DLbfhQAS9ANrJ8?=
 =?us-ascii?Q?kPk0KJ0N7PWgZ5METz0hg/dBUD/PNqzIF/IJ9nKHoAkYJcxvAKUHtSE8xHSf?=
 =?us-ascii?Q?adZeeQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe33c6c0-dea1-4031-70bc-08db6cc8305b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 11:12:06.5220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTppKuSYuz+co/+UbFcUDvdvbxjBQBvD9jUQYNfSkTt/iQEoEE1R1DSJVCWru9kXmylmCD0KVI6U7QnC6sAffjuFnKqWED1Ol3XGgJ7nEaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4937
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 02:16:17PM -0700, Dave Ertman wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> The ice_alloc_lan_q_ctx function allocates the queue context array for a
> given traffic class. This function uses devm_kcalloc which will
> zero-allocate the structure. Thus, prior to any queue being setup by
> ice_ena_vsi_txq, the q_ctx structure will have a q_handle of 0 and a q_teid
> of 0. These are potentially valid values.
> 
> Modify the ice_alloc_lan_q_ctx function to initialize every member of the
> q_ctx array to have invalid values. Modify ice_dis_vsi_txq to ensure that
> it assigns q_teid to an invalid value when it assigns q_handle to the
> invalid value as well.
> 
> This will allow other code to check whether the queue context is currently
> valid before operating on it.
> 
> Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


