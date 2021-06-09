Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BCF3A0F2E
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 10:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237773AbhFIJAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:00:24 -0400
Received: from mail-bn8nam11on2132.outbound.protection.outlook.com ([40.107.236.132]:27488
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235888AbhFIJAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 05:00:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8np+rp5rjc+pJKK3OMlO8bdtQsF1Ag/AR+KbSdjWtzOmf68tBWWUEGM2KTs5/hyy+DUB+U28F/GOZXnIjpvc1HIkwF6AOkIb1VlC2OOBWOSRUBVPfwqgyWRLINc1Q8g1F4e3SZaE5yChberP/XCHmN6b6Jtj/jwUxEbHBpztS32I/msDBxUbsiSjtFaW6NkeS9xwk3G95z73RgkbPHq4KZ5yNVEbZhWiObS5Nw+5oFfenQyH6VFLK1O7C+CPAND4TEvqzYFByz+8bL2ho2S7mdafMhoHFke6euqbQe3pMbVuWm5YqaA520uNA6HEOXRPqViKO210D83uFLIBTiSFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fKvIIvZ2SOAqVTMvqIOOUvmNH5JsTLr2R+nBddEfXw=;
 b=h7/qWMbSJW+XuHSy7ginEob7hNR+YtUMVL4bS+VjbuXt0G9G3u5UoEPNfhWPRt8TdsqP5vXiROG6nCAzRZt3cNo49cafWNY3sQHvSVsfmI3faKVlMgqC7ghR3VANMX7hHmyMGx1ij4y7fBu88k7CpHrnpDoBI1eEEHx2E92cJa5UB46MuUwjq07IW3tLBeilRu4JXaPv7Et8ELlEteHdZ1DgXofqa2dhW3gIZ5CXYS4qT9CbiRsKSGFCFaEsW++fDgXomt0Qvry45kaTqsUZliulF1qzHAVEuztOMh0PXzq3r6Zwr3SdIZiGJbDvM4gZqa0yE5GuQk4vPpwL/tB1VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fKvIIvZ2SOAqVTMvqIOOUvmNH5JsTLr2R+nBddEfXw=;
 b=ec4jBJRIUk8wxndlOtif40N8AgV4HAI5k0MTtq5KQTCfktBpxyE67sEyXESULVl56+QVrNz3RRIz50/mqrAo0sZ1nMUVjXAvnP5GIA1AZliewFKbIzthjkJigEjr5C7RMVoVeJ4i6rdbYbIOTltrmu7wQaj4WuzCiyKTpwYBES0=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4923.namprd13.prod.outlook.com (2603:10b6:510:99::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.12; Wed, 9 Jun
 2021 08:58:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.009; Wed, 9 Jun 2021
 08:58:24 +0000
Date:   Wed, 9 Jun 2021 10:58:17 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, yangjihong1@huawei.com, yukuai3@huawei.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next v2] nfp: use list_move instead of
 list_del/list_add in nfp_cppcore.c
Message-ID: <20210609085814.GB16547@corigine.com>
References: <20210609070921.1330407-1-libaokun1@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609070921.1330407-1-libaokun1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [2001:982:756:703:d63d:7eff:fe99:ac9d]
X-ClientProxiedBy: AM3PR05CA0099.eurprd05.prod.outlook.com
 (2603:10a6:207:1::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM3PR05CA0099.eurprd05.prod.outlook.com (2603:10a6:207:1::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 08:58:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19fed9ea-de82-4e23-bc0e-08d92b24bcf5
X-MS-TrafficTypeDiagnostic: PH0PR13MB4923:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4923645E910CF2408B38F9B3E8369@PH0PR13MB4923.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ogF54ufeIRgnUNvKhSBWpf7Z63XJJSIO5XUWczSNrJP0AKqQlti/0MfzR85aOAewCM3ixiyaMGGomeHhYeBCmQi/p8wkyNtFYtYKBsahS1pxYNdbIU1lygFz07MaDKTP5WzOe8Gi5RwwjYxx1HvA7rNev6A4yI1PYvgqPvCDWW7VCs9sPeSWvb9hVQJbmxSw1DBPRYw+QdZcdKdoXXpHYtugDnvZvz9dnDBQKSsNDVk3urIMyJKZOmLhTf46WMvzAsoTvyL6RVMPnZZbEEBloBMX2xhkhhNQiHAJW7UgqtNJ4YhxHZVODB0IzAheqoIoFbAXJ72uwgknMwaRC+/GwhJCWPs3geXosIDhpMmKKAwsqZ9pq4hCfTaMvFdWRtnysiVtCycepjY0/8i/D0S4pkCys2+tu65lWBXbvrndHFZg7xfa9vnpU3JdVL6S/6tcFr/0nc+SKTETfQOADbECeavGckD53xfCYNIKenPyQuAjt2QODSpOzAJalAD3Tlw81zUPCaZWyzEOAVAAnqYqR/LHZtmfcqSJtEs1gHTmXxg4zqLAjfeVzhtb/786BRBj6mJ/AAQDE/H2ZnHNBFWq0ruIgN8nfpuIWZkTqe/idvw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(136003)(39830400003)(52116002)(2906002)(2616005)(478600001)(5660300002)(8676002)(7696005)(44832011)(186003)(558084003)(6666004)(86362001)(6916009)(316002)(54906003)(7416002)(8936002)(55016002)(1076003)(4326008)(66556008)(33656002)(66476007)(8886007)(16526019)(38100700002)(66946007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HuSittwV/Et+Ckn91Y1a1/DGZ549NsuxV4FGfTlkRBpfFW9np3lem+Yc2+7x?=
 =?us-ascii?Q?m72doDWMgy1rDjwEd6riLv/ntvk6wMaNeCfsVzU2MdVLAOUDtZinpqCFPwyd?=
 =?us-ascii?Q?J6HpGVmIhyALeoHPgYGEtPZeuVWkhBJI/y3E7OrW6ACuMp6wPvrazWwkRr3j?=
 =?us-ascii?Q?j21bwAgHFHuInL1+O13rFeojQOtbcE70JdnHfsKJb+UmGYvM7eLPSza9kKFx?=
 =?us-ascii?Q?vLf5xzZDFGoPz3Yv+8O6MDsAGpjoR1BkjdhqekGO6l+5qDLWg5SX89RD5NlY?=
 =?us-ascii?Q?xUMBSvEs+XDOvKz91hoY9MgohJn1koA3jsmz4bWIRnk1Zfue2jLj2w84nD2r?=
 =?us-ascii?Q?r/SRNaZ37QcyYCNJ9wuDvuNiERcDwW6vXj0hJ2yowAHv7cGnmMr9qyT1pBKc?=
 =?us-ascii?Q?KbVslLRCRdUUwSwt/BTlkaDNai1PCpQKiBN7SuemoBw6VHQIcEcRuQiJoaQ7?=
 =?us-ascii?Q?ZqV3DmKv49xt4NaDmYpB2OvMbpjZW4tn2nJHOR2pIXWTp7J/A/iruamH/IcS?=
 =?us-ascii?Q?+ecyv1l/aj3GKHVkSse2KoKzIMldsRzXZd8zBaGuafICm+pTcESJrBVQNEqs?=
 =?us-ascii?Q?rXPdtFejbvhl++yj7r0GaD8AXgQtv+3cghz0kVMkpifQQfvre/A/eW57h5Cn?=
 =?us-ascii?Q?JIHVi2CMBA12lzCLsKiGErwlxyEzTNHxoTHid9DGyqDwfyJj4mp6fDQwQyQ8?=
 =?us-ascii?Q?ClYAKzBz2XBPyJjHK6JNsjccggOGK6QJmEVH52+fYPqSmpsmlS+dCYJGTNb7?=
 =?us-ascii?Q?6GkMpbFXVtB9dWnYlZ9Jayt6v9fUlAgc1CrIMvw4X6As38qWKiaV2lRY/gE1?=
 =?us-ascii?Q?7lssLExwAwzVf8r+YxZeWUgWMwmP/woniIIrmyeaCgg4Xd+AvXeA9e9hkBRW?=
 =?us-ascii?Q?xzOKV2dcjYQUpArmTynN0dr0+R3eihHULS42eiAIBAEv8xTLPcqGi5kgyLde?=
 =?us-ascii?Q?+ZE9mvhhBXsvw6PWsWQDopUEWGmSmvjrDGSGzeHTOfQDTjQ+azTF7qzQxzFu?=
 =?us-ascii?Q?AAgszE4zR6rcCsr/dxLPGl8k/4HXoIcvasXFcwth6/JQSdr0BzZFK+PEwbaN?=
 =?us-ascii?Q?yY7wT34tUy5ynmqnrB3EfjRV9InUiJVphEoQXwVyujJBCknAfvJCzYLUg6YG?=
 =?us-ascii?Q?ZUb17PJvCyxgXBGjk7MX/IyzD5w8v1WsJkVQACk2bbGwJSK8uktsZ4f2rT+F?=
 =?us-ascii?Q?ORgTwjDlN8hWf8nGiW5l9t/UwNe4SO0agUAy9Ho+e8bki/0afgij/CObReCX?=
 =?us-ascii?Q?/zomPtHcoLlXqFWDWU5hkgtdwpmGooPYtElHvG84m7QyimxVH8KJlx9Sk0cW?=
 =?us-ascii?Q?/2HxWo5jKt/zfy1k9KtChrugWnD73O6IiwqKvGw6TkYy6kc3PbJyqtEjGZnN?=
 =?us-ascii?Q?/F5nfPyDQYBG6hVYTBLI9IfbL2ny?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19fed9ea-de82-4e23-bc0e-08d92b24bcf5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 08:58:23.9928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ObBgt8fQdwUrhJPc/zeYBtuyYcaV1brhkxsdSo9Fh1I+SsbKlieApyaCSM4zfCcXN0WJUWkg61yMpnk/kBMAScHm7IWOgCWHVp5qcmrkyls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4923
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 03:09:21PM +0800, Baokun Li wrote:
> Using list_move() instead of list_del() + list_add() in nfp_cppcore.c.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
