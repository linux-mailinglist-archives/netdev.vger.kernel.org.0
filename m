Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AF16473F3
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiLHQL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiLHQLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:11:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2114.outbound.protection.outlook.com [40.107.100.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0940AD32E;
        Thu,  8 Dec 2022 08:11:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkA+JypVhKEK7iF6qZulmAdqo1BmSM3HLASyp61EqVl93Bj5w7CKgEllrExHPXeWBIuK6B110k0Cgc/byhEoS6Pw9jTrUsR6vlvLEqkLjf2UAtZN76+jrXrQqw1RZQJuJjw1x9CWt5BWYZ0gzW0VmJbr3cVb3ZFVr4FgIR5v/txNjZgLlmUC5lkR2NfsaFA0YUdZOTzANYHDxMnXLH83uW834UKzNO4aBSnZkhUeb87OR9/dwcl5Z+tfqWLPQIoXNOU4HqNlY3PTiF8m/UavBa4H7VocKzwXB8W0VuZYxGrh2SCUHp4xBXxzvNY+Bb6EeQwodGP4ApjuHIqQY7p3Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxcu2jil4sax/VSjDrBDSsrAJlsAsLk4gsPQZe8BMt0=;
 b=SNPiMVpWTb/qBxlIR8KaCzz11Z0T0pkJqLOVDuUolO1IifL7FEXWdzSXU91Ieff0fkXz+M0czCc5RgxgX+fRajU6xvfh1yO1tPACkQtmjZEVKioyRMBFGHEGEfmgfMjwhJOFO5mgAOjMB01L98bLbcVer7eYjFPOPatsoWMkPgkEdWyrKVgnduBnI/BYfRnoRymj3SAzDWQIKllertNE1C9s8Gqxjk41HlN5b+UhGG1HvvQGg7kuy2uXL7MP1EqykDt+zkrxczfYjsHnJB8BAiZZiFJgBY1OOqB12ei6LmVE9dBjujR1B5mU1EhJw5w+n2f6qkpYk06WBe05qNjK6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxcu2jil4sax/VSjDrBDSsrAJlsAsLk4gsPQZe8BMt0=;
 b=YhOFm2zqWEZ6MGxeSdp1fL9QDKddR6bml3wl6xNX6Lf4WPZvCu3SqCKBXaqVBw/l6skuWYP/bXL0T9Qc5vHxLLD0UQow7K2Y9Aot7F7w+2+6KkenLviAtGE7dJqI7IYD5dXcsf3Vepv8tGiQaCC11lJJlS0fFvQghXdOtmt+f1U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 16:11:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 16:11:21 +0000
Date:   Thu, 8 Dec 2022 17:11:08 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     yang.yang29@zte.com.cn
Cc:     salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, brianvv@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH linux-next] net: hns3: use strscpy() to instead of
 strncpy()
Message-ID: <Y5IMnKja6kyhuq01@corigine.com>
References: <202212081953254923522@zte.com.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212081953254923522@zte.com.cn>
X-ClientProxiedBy: AM0PR06CA0078.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a6c860a-82ec-45b5-3019-08dad936d870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dmbWNi+zv9GmTKb9EuJ8uFP58I3IUYDDUAVQ7Le1SlsGlYboObms46K/zIB/dS/cqXaPWwgYc2rVltmPc/ZLOAPHtJHtGYVZfp/35HU4yPx5UHtcDfYoSbfXiZg9kzlXFaAzN8nlbz/nH/HEq2M4ccD46eL8NcW8+jSMrJGhGWJzDsvTuaZ3u61VGV+IgLDAa7M2MzbISzy7bIYzXa7V+BU9hRs5Hw9MSsTa9lh/s2PlWTdP/FlFug/jWF/eIFXI+Gc12n11znmJxnCucteWw1jze3ufNBtYzj7RbuPlaYUAIz3OAbYLx+vAgPXYqJLscBEvfogBIbIjp2qcsrN2nnce2hdq2BE2HDyiajVqSI9vXE0tR54fKhRYBdYIZPUBnaPaDsdMDLJE8o3ZWR63YZZ6zVJ9PeG6w6nZ2FHwHjE7jKkWR9VxfmguocYpFZa/v6dn0+Rhpmn1po2g0GUqFbIzR7a/dKLbP280V7mbnw3iHJgc8xW9PyZXnqeyrnfLDN7O3Q1Ria7wpQZogDMK8bTIweoXSNs68209wPW3kxOwJfsj09nJxJNGs118/ArMPbxyl0dKS/14BSJZsiCmqY5NwhwkkLyRAY1Db/W1j81BaCPlTJc4swhC1GDR8i+BbnCY/gKQb2+el2X/IPBOFrjgPBQraa/W/oSaxAjhRMY9SyYrC2W1uSpYZVk9Kh4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(366004)(346002)(39840400004)(451199015)(36756003)(6486002)(86362001)(478600001)(6506007)(8676002)(186003)(66556008)(66476007)(6666004)(8936002)(6916009)(7416002)(316002)(44832011)(5660300002)(2906002)(4744005)(66946007)(41300700001)(4326008)(2616005)(38100700002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FQ2KDPHyGdqdxKq9fRze793BR0oJ/ykNxiqw/Uv23MG1S2IDtHI9ed0GUz1f?=
 =?us-ascii?Q?nrg2aTaPXBWP88EOrhQX0roFkNWXbrhiB4RoNOT+EA8V3+6rna9iGeAm+4NX?=
 =?us-ascii?Q?cZLSz4uVPmj9ZGpHVjOou4SpIdQ4yeB/QvqRP0uYjqBbnhG3/Y1WRd7u58AA?=
 =?us-ascii?Q?CtI2TB4BEgtuLTLHRjFXn+ozR4t31Qgdrghzf+Wm5btNBOlZplVVMmeSDcNn?=
 =?us-ascii?Q?A1FFrHJ9yMrernNNNcRACBc8VBbs6YLgV66nYg7/Rbkw8wdTAivAIyByIN4Q?=
 =?us-ascii?Q?tF76MgG+x50Mrv32/si6bpcA6s2VpS5EZie4VJrFxAkMToKPOoT7kJnlpcZX?=
 =?us-ascii?Q?Vaf+0wGcZkOxB0AriMBa95Ty5PgOvHFg7ZikiioHYmXui1HwKocbi7ZM3O/B?=
 =?us-ascii?Q?/jFwcfCbSktpm+3sFZAocg32fo3Cq2OmaVpcrWzxukVcC+RxkcTKnKDPI2DC?=
 =?us-ascii?Q?H8fvd3/xjudthS6EVZbIxmlPVhiaDEWGhWk971Q9neMZoPTOMzBgD39vtGLB?=
 =?us-ascii?Q?mamKUieECPl+mEQ3SA3TkeVzGEbvS6AfKEf9K0uAdGoLdk1fMAOBnj91TGj8?=
 =?us-ascii?Q?3JqS+e3WE2zCekgbobo37C7CHAWVq0Rtq6XNU6A7E34xlknU5LCp/EvgIhEH?=
 =?us-ascii?Q?6QjayUMNI0p6QzXGV9dE4RPnXb07GrvH1O3nFsO0QUtsUcSQ+ePemvtYplE/?=
 =?us-ascii?Q?ZSYFShxTfbUM9X5XK+LqjZ1HEghqx3BcGrfFq9t4n+EdABtC5kVwuC4e87ps?=
 =?us-ascii?Q?3XXybmc1b25Cr3DKix4TVZIQ3r9Vnz+y+QzM4/DX4TnJFfd86x8L7Hv2Z0da?=
 =?us-ascii?Q?zkZwjyvByLyNvyMTOQu6bvoeEi2Y4aekE90La73+2rJkK5AZcCQhC8B8FuLK?=
 =?us-ascii?Q?hzhKHaoBVnkV97FdxMNL0FAQCkh867RLXYPXVjESt9VGV1N2t1dkmZx02zPQ?=
 =?us-ascii?Q?RRhGKn3W0wvKiMFOFH8MSATyI7nhmuY4xJqz3pC8Ea+ZfF4uc/T53shxFHzg?=
 =?us-ascii?Q?XxPZ2PLSVf3sPVDZcVNnbMwIrzOZ/QE7GaePlAV+Ashh7DbYOuQYOHGagwgh?=
 =?us-ascii?Q?Hz46bshmV/3H7bIxgbGinTDmMSP68To/dx068Vp/XdSaG9Q4S8MxPJcgZFF6?=
 =?us-ascii?Q?mDC7Rq6gKG2KRvZBN9aapHZXXQRw4bACudx+JdTfNrPqoz4KwLRXFiotPnuK?=
 =?us-ascii?Q?Qbfs+c8KM/MLJ094L3XzcgHFVGCEjb2WeumO4yJ7ooa3fu8mmpfWP+c9TpIl?=
 =?us-ascii?Q?2Ex6LdFgjaZmmyy/31AFUwJqQNVB9hF4uuLldINh4YKMP9rnDTRSMlTJK69A?=
 =?us-ascii?Q?979EuQtc+fg2jnTT47RZcyRFZb2Q5zUdOgbb/1MBYGEU03zdZxLE6gBTm4rz?=
 =?us-ascii?Q?vd01OYbr/MzZLbYGLyclR4shJYcC9NM9rERetEVE4PQjnDvyPu3RqC8kbLEo?=
 =?us-ascii?Q?N2hmJ7xhKDPycHh2Y9Qgag1asmecOfgOMmLSVM2pxciwTHgrN8TQXzZoFf8x?=
 =?us-ascii?Q?AxgJusjKuVqRjOZXoBaVDKyQqb21SaLDQ4MC3uZXBjPXp4eRz2AeNmi7ouEM?=
 =?us-ascii?Q?ywAzWKpSPxD/mfoRu+8OCMq48YQ+vgxv0NZRt3Unj4/khkM+p0a2OAW7BOmX?=
 =?us-ascii?Q?nFCNrnHH1jcGG0BTGXMOdCST5coBS6y1tH5sh+Flwq2jvn8jvP9E49PXQacB?=
 =?us-ascii?Q?2xM0wA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a6c860a-82ec-45b5-3019-08dad936d870
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:11:21.1382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juESjCS1NML9fOrjKvf5eAD5isbv8FGU9Nx9m4lVfHlxGpnoTF7RvQyPEvhqdHuuLcA/K6fKCS3FgRTjbZqzFzFNgGpx4NWKFJ348JC1PSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4834
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 07:53:25PM +0800, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL terminated strings.
> 
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>

This change looks good to me, although it should probably be
tagged for 'net-next' rather than 'linux-next'.

  [PATCH net-next] net: hns3: use strscpy() to instead of strncpy

That notwithstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>
